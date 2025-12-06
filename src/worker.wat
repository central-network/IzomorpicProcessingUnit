(module
    (import "self" "memory" (memory $memory 65535 65535 shared))
    (import "self" "close" (func $close))

    (include "shared.wat")
    (include "handlers_worker.wat")
    (include "headers_io_worker.wat")

    (global $worker_index mut i32)
    (global $worker_offset (mut v128) (v128.const i32x4 0 16 16 16))    
    (global $loop_iterator (mut v128) (v128.const i32x4 -1 1 1 1))
    
    (start $main

        call $start
        loop $while

            call $get_func_index<>i32
            call_indirect $func_table 

            (log<i32.i32.i32>
                (global.get $worker_index)
                (call $get_notifier_index<>i32)
                (call $get_locked_workers<>i32)
            )

            (if (i32.eq
                    (call $new_locked_index<>i32)
                    (call $get_notifier_index<>i32)
                ) 
                (then 
                    (call $notify_window_mutex<>)
                )
            )

            call $lock_worker_mutex<>

            br $while
        end

        call $close
    )

    (func $start
        (global.set $worker_index 
            (call $new_worker_index<>i32)
        )

        (global.set $worker_offset
            (i32x4.mul
                global($worker_offset)
                (i32x4.splat global($worker_index))
            )
        )

        (global.set $loop_iterator
            (i32x4.mul
                global($loop_iterator)
                (i32x4.splat (call $get_stride<>i32))
            )
        )

        (call $set_handlers<>)
    )

    (func $lock_worker_mutex<>
        (if (memory.atomic.wait32 global($OFFSET_WORKER_MUTEX) false forever)
            (then (error<ref> text('Window mutex lock returned value!')))
        )
    )

    (func $notify_window_mutex<>
        (local $isNotified i32)

        (if (memory.atomic.notify global($OFFSET_WINDOW_MUTEX) true)
            (then return)
        )

        (error<ref> text('Window notification failed!'))
        (unreachable)
    )
)