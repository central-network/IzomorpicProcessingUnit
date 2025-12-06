(module
    (memory 1 10)
    
    (include "shared.wat")
    (compile "worker.wat"
        (data $worker/buffer)
        (global $worker/length i32)
    )

    (include "controller_worker.wat")
    (include "controller_memory.wat")
    (include "controller_window.wat")
    (include "controller_scheduler.wat")
    (include "headers_io_window.wat")
    (include "handlers_window.wat")

    (include "source_gemini.wat")
    (include "source_ozgur.wat")

    (global $kSymbol.tag 'kArrayType')
    (global $worker.code 'onmessage = e => Object.assign(self,e.data).WebAssembly.instantiate($,self)')

    (global $DEFAULT_MEMORY_INITIAL  i32 i32(65535))
    (global $DEFAULT_MEMORY_MAXIMUM  i32 i32(65535))
    (global $DEFAULT_MEMORY_SHARED         i32 true)

    (global $MAX_TASK_COUNT                      i32 (i32.const 1000))
    (global $BYTES_PER_TASK                        i32 (i32.const 32))

    (global $OFFSET_QUEUED_TASK_COUNT              i32 (i32.const 16))
    (global $OFFSET_COMPLETED_TASK_COUNT           i32 (i32.const 20))
    (global $OFFSET_TASK_HEADERS_START             i32 (i32.const 64))
    (global $OFFSET_TASK_HEADERS_END            i32 (i32.const 32064))

    (global $OFFSET_QUEUED_TASK_TASK_STATE          i32 (i32.const 0))
    (global $OFFSET_QUEUED_TASK_TASK_INDEX          i32 (i32.const 4))
    (global $OFFSET_QUEUED_TASK_FUNC_INDEX          i32 (i32.const 8))
    (global $OFFSET_QUEUED_TASK_BUFFER_LEN         i32 (i32.const 12))
    (global $OFFSET_QUEUED_TASK_SOURCE_PTR         i32 (i32.const 16))
    (global $OFFSET_QUEUED_TASK_VALUES_PTR         i32 (i32.const 20))
    (global $OFFSET_QUEUED_TASK_TARGET_PTR         i32 (i32.const 24))
    (global $OFFSET_QUEUED_TASK_NEED_RESET         i32 (i32.const 28))

    (func $get_queue_task_state<i32>i32 (param $offset i32) (result $value i32) (i32.load   offset=0 local(0)))
    (func $get_queue_task_index<i32>i32 (param $offset i32) (result $value i32) (i32.load   offset=4 local(0)))
    (func $get_queue_func_index<i32>i32 (param $offset i32) (result $value i32) (i32.load   offset=8 local(0)))
    (func $get_queue_buffer_len<i32>i32 (param $offset i32) (result $value i32) (i32.load  offset=12 local(0)))
    (func $get_queue_source_ptr<i32>i32 (param $offset i32) (result $value i32) (i32.load  offset=16 local(0)))
    (func $get_queue_values_ptr<i32>i32 (param $offset i32) (result $value i32) (i32.load  offset=20 local(0)))
    (func $get_queue_target_ptr<i32>i32 (param $offset i32) (result $value i32) (i32.load  offset=24 local(0)))
    (func $get_queue_need_reset<i32>i32 (param $offset i32) (result $value i32) (i32.load  offset=28 local(0)))

    (func $set_queue_task_state<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=0 local(0) local(1)))
    (func $set_queue_task_index<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=4 local(0) local(1)))
    (func $set_queue_func_index<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=8 local(0) local(1)))
    (func $set_queue_buffer_len<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=12 local(0) local(1)))
    (func $set_queue_source_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=16 local(0) local(1)))
    (func $set_queue_values_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=20 local(0) local(1)))
    (func $set_queue_target_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=24 local(0) local(1)))
    (func $set_queue_need_reset<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=28 local(0) local(1)))

    (global $TASK_STATE_CLOSED           i32 i32(0))
    (global $TASK_STATE_RESERVED         i32 i32(1))
    (global $TASK_STATE_QUEUED           i32 i32(2))
    (global $TASK_STATE_PROCESSING       i32 i32(3))
    (global $TASK_STATE_COMPLETED        i32 i32(4))

    (func $get_queue_count<>i32
        (result $offset i32)
        (local  $offset i32)
        (local  $count i32)

        (local.set $offset 
            global($OFFSET_TASK_HEADERS_START)
        )

        (loop $next_task_offset
            (if (i32.atomic.load local($offset))
                (then (local.set $count local($count)++))
            )

            (local.set $offset 
                (i32.add local($offset) 
                    global($BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u local($offset)
                    global($OFFSET_TASK_HEADERS_END)
                )
            )
        )

        local($count)
    )

    (func $next_queued_task<>i32
        (result $offset i32)
        (local  $offset i32)

        (local.set $offset 
            global($OFFSET_TASK_HEADERS_START)
        )

        (loop $next_task_offset
            (if (i32.eq global($TASK_STATE_QUEUED)
                    (i32.atomic.rmw.cmpxchg local($offset)
                        global($TASK_STATE_QUEUED)
                        global($TASK_STATE_PROCESSING)
                    )
                )
                (then (return local($offset)))
            )

            (local.set $offset 
                (i32.add local($offset) 
                    global($BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u local($offset)
                    global($OFFSET_TASK_HEADERS_END)
                )
            )
        )

        i32(0)
    )

    (func $new_queue_offset<>i32
        (result $offset i32)
        (local  $offset i32)
        
        (local.set $offset 
            global($OFFSET_TASK_HEADERS_START)
        )
        
        (loop $next_task_offset
            (if (i32.eq global($TASK_STATE_CLOSED)
                    (i32.atomic.rmw.cmpxchg local($offset)
                        global($TASK_STATE_CLOSED)
                        global($TASK_STATE_RESERVED)
                    )
                )
                (then (return local($offset)))
            )

            (local.set $offset 
                (i32.add local($offset) 
                    global($BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u local($offset)
                    global($OFFSET_TASK_HEADERS_END)
                )
            )
        )

        (unreachable)
        ;; loop all again but this time mark completed tasks as closed 
    )

    (global $sigint                         mut i32)
    (global $module                      mut extern)
    (global $memory                      mut extern)
    (global $buffer                      mut extern)

    (global $i32View                     mut extern)
    (global $dataView                    mut extern)
    (global $kSymbol                     mut extern)

    (global $worker.URL                  mut extern)
    (global $worker.data                 mut extern)
    (global $worker.config               mut extern)

    (global $worker.threads               new Array)
    (global $abortController             mut extern)
    (global $postTask.arguments          mut extern)
    (global $postTask.options            mut extern)
    (global $postTask.delay                 mut i32)
    (global $postTask.isScheduled           mut i32)

    (global $taskQueue                   new Array)

    (global $promise                     mut extern)
    (global $promise.arguments           mut extern)
    (global $promise.resolve             mut extern)
    (global $promise.reject              mut extern)
    (global $promise.isPromised             mut i32)
    (global $promise.isResolved             mut i32)
    (global $promise.isRejected             mut i32)

    (global $self.DataView                externref)
    (global $self.Uint8Array              externref)
    (global $self.Uint16Array             externref)
    (global $self.Uint32Array             externref)
    (global $self.Float32Array            externref)
    
    (global $self.navigator.deviceMemory              i32)
    (global $self.navigator.hardwareConcurrency       i32)

    (global $self.scheduler                     externref)
    (global $self.Scheduler:postTask            externref)
    (global $self.AbortController               externref)
    (global $self.AbortController:abort         externref)
    (global $self.AbortController:signal/get    externref)
    (global $self.AbortSignal:onabort/set       externref)

    (global $self.Promise                       externref)
    (global $self.Promise.withResolvers         externref)

    (func $this (export "this"))

    (func (export "dump")
        (result $variables <Object>)
        (local $variables <Object>)

        (local.set $variables (call $self.Object<>ref))

        (call $self.Reflect.set<ref.ref.i32> local($variables) text('worker_count')   (call $get_worker_count<>i32))
        (call $self.Reflect.set<ref.ref.i32> local($variables) text('active_workers') (call $get_active_workers<>i32))
        (call $self.Reflect.set<ref.ref.i32> local($variables) text('locked_workers') (call $get_locked_workers<>i32))
        (call $self.Reflect.set<ref.ref.i32> local($variables) text('notifier_index') (call $get_notifier_index<>i32))

        local($variables)
    )

    (func $create 
        (param $workerCount i32)

        (if (0 === local($workerCount))
            (then (local.set $workerCount global($self.navigator.hardwareConcurrency)))
        )

        (call $define_self_symbols<>)
        (call $create_memory_links<>)
        
        (call $reset_memory_values<i32> local($workerCount))    
        (call $create_task_scheduler<>)
    )

    (func $create_wait_async<>
        (local $waitAsync        <Object>)
        (local $promise         <Promise>)
        (local $isAsync               i32)

        (log<ref> text('create wait async called'))

        (local.set $waitAsync
            (call $self.Atomics.waitAsync<ref.i32.i32>ref
                global($i32View) 
                global($INDEX_WINDOW_MUTEX) 
                false
            )
        )

        (local.set $isAsync
            (call $self.Reflect.get<ref.ref>i32
                local($waitAsync) text('async')
            )
        )

        (if (false === local($isAsync))
            (then
                (error<ref.ref> text('waitAsync is not a promise!') local($waitAsync))
                (unreachable)
            )
        )

        (local.set $promise
            (call $self.Reflect.get<ref.ref>ref
                local($waitAsync) text('value')
            )
        )

        (apply $self.Promise.prototype.then<fun>
            local($promise) (param func($ontaskcomplete<>))
        )
    )

    (func $destroy 
        (call $delete_self_symbols<>)
        (call $terminate_all_workers<>)
        (call $remove_extern_globals<>)
    )
    
    (func $remove_extern_globals<>
        (global.set $i32View        null)
        (global.set $dataView       null)
        (global.set $buffer         null)    
        (global.set $memory         null)
        (global.set $module         null)
        (global.set $worker.URL     null)
        (global.set $worker.data    null)
        (global.set $worker.config  null)
        (global.set $kSymbol        null)
    )

    (start $init (call $create false))
)   