(module
    (import "0" "memory" (memory 1 65536 shared))
    (import "1" "log" (func $log (param i32)))
    (import "1" "warn" (func $warn (param i32 i32)))

    (global $LOCK_STATUS_LOCKED i32 (i32.const  1))
    (global $LOCK_STATUS_IDLE   i32 (i32.const  0))
    (global $LOCK_STATUS_SELFLOCK  i32 (i32.const  2))
    (global $LOCK_STATUS_WORKING   i32 (i32.const  3))
    (global $LOCK_STATUS_SIGINT i32 (i32.const -1))

    (global $TIME_LOCK_DELAY    i64 (i64.const -1))

    (global $pu_index              (mut i32) (i32.const 0))
    (global $pu_offset             (mut i32) (i32.const 0))
    (global $loop_index            (mut i32) (i32.const 0))

    (global $OFFSET_ARGS                i32 (i32.const 32))
    (global $OFFSET_OPERAND             i32 (i32.const 48))
    (global $LENGTH_HEADERS             i32 (i32.const 64))

    (global $OFFSET_ZERO_RESV           i32 (i32.const  0))
    (global $OFFSET_MALLOC_LENGTH       i32 (i32.const  4))
    (global $OFFSET_THREAD_COUNT        i32 (i32.const  8))
    (global $OFFSET_LOCK_STATUS         i32 (i32.const 12))

    (global $OFFSET_PROCESSOR_STAGE     i32 (i32.const 16))
    (global $OFFSET_CYCLE_COUNT         i32 (i32.const 20))
    (global $OFFSET_CALC_BYTELENGTH     i32 (i32.const 24))
    (global $OFFSET_HANDLER_ELEM        i32 (i32.const 28))
    
    (global $OFFSET_LENGTH              i32 (i32.const 32))
    (global $OFFSET_SOURCE              i32 (i32.const 36))
    (global $OFFSET_VALUES              i32 (i32.const 40))
    (global $OFFSET_TARGET              i32 (i32.const 44))

    (global $OFFSET_STRIDE              i32 (i32.const 48))
    (global $OFFSET_SRCADD              i32 (i32.const 52))
    (global $OFFSET_VALADD              i32 (i32.const 56))
    (global $OFFSET_DSTADD              i32 (i32.const 60))

    (func $main

        (global.set $pu_index  (i32.atomic.rmw.add (global.get $OFFSET_THREAD_COUNT) (i32.const 1)))
        (global.set $pu_offset (i32.atomic.rmw.add (global.get $OFFSET_STRIDE) (i32.const -16)))

        (loop $calc
            (memory.atomic.wait32
                (global.get $OFFSET_LOCK_STATUS)
                (global.get $LOCK_STATUS_SELFLOCK) (; expected value (1 => locked) ;)
                (global.get $TIME_LOCK_DELAY)             
            )
            (drop)

            (i32.atomic.load (global.get $OFFSET_LOCK_STATUS))
            (if (i32.ne (global.get $LOCK_STATUS_SIGINT))
                (then
                    (; do jobs here ;)

                    (call $warn (global.get $pu_index) (global.get $pu_offset))
                    (br $calc)
                )                    
            )
        )

        (call $log (global.get $pu_index))

        (global.set $pu_index  (i32.atomic.rmw.sub (global.get $OFFSET_THREAD_COUNT) (i32.const 1)))
        (global.set $pu_offset (i32.atomic.rmw.sub (global.get $OFFSET_STRIDE) (i32.const -16)))

        (; then -> close ;)
    )

    (start $main)

    (func $f32_add_v        
        (local $uniform v128)   
        (local $offsets v128)   
        (local $operand v128)   

        (local.set $uniform (v128.load32_splat (global.get $OFFSET_VALUES)))
        (local.set $offsets (v128.load (global.get $OFFSET_ARGS)))
        (local.set $operand (v128.load (global.get $OFFSET_OPERAND)))

        (loop $next
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (local.set $offsets
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand) 
                        )
                    )

                    (v128.store
                        (i32x4.extract_lane 3 (local.get $offsets))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 1 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (br $next)
                )
            )
        )
    )
)