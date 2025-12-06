(func $process_task_queue_ozgur
    (local  $queue_offset      i32)

    (local  $source_ptr           i32)
    (local  $values_ptr           i32)
    (local  $target_ptr           i32)
    (local  $buffer_len           i32)

    (local  $func_index           i32)
    (local  $fork_count           i32)
    (local  $concurrency          i32)
    (local  $task             <Array>)

    (if (0 === tee($queue_offset (call $next_queued_task<>i32)))
        (then
            (global.set $isProcessing false)
            (call $schedule_close_task<>)
            (return)
        )
    )
    
    (global.set $isProcessing true)

    (call $abort_scheduled_task<>)
    (call $reset_locked_workers<>)
    (call $create_wait_async<>)

    (call $set_func_index<i32> (call $get_queue_func_index<i32>i32 local($queue_offset)))
    (call $set_buffer_len<i32> (call $get_queue_buffer_len<i32>i32 local($queue_offset)))
    (call $set_source_ptr<i32> (call $get_queue_source_ptr<i32>i32 local($queue_offset)))
    (call $set_values_ptr<i32> (call $get_queue_values_ptr<i32>i32 local($queue_offset)))
    (call $set_target_ptr<i32> (call $get_queue_target_ptr<i32>i32 local($queue_offset)))

    (global.set $active_task_offset 
        local($queue_offset)
    )

    (local.set $concurrency
        (call $get_worker_count<>i32)
    )

    (local.set $fork_count
        (call $notify_worker_mutex<i32>i32
            local($concurrency)
        )            
    )

    (if (i32.lt_u 
            local($fork_count) 
            local($concurrency)
        ) 
        (then
            (if (false === global($isSpawning))
                (then 
                    (log<i32.i32.i32>
                        local($concurrency)
                        local($fork_count)
                        (call $get_active_workers<>i32)
                    )

                    (call $create_worker_threads<i32>
                        (i32.sub
                            local($concurrency)
                            local($fork_count)
                        )
                    )
                )
            )
        )
    )
)

(func $create_worker_threads_ozgur
    (param $workerCount          i32)
    (local $worker          <Worker>)

    (global.set $isSpawning true)

    (loop $fork
        (local.set $worker
            (new $self.Worker<ref.ref>ref
                (call $get_worker_url<>ref)
                (call $get_worker_config<>ref)
            )
        )

        (apply $self.Worker:postMessage<ref>
            local($worker) (param $get_worker_data<>ref())
        )

        (apply $self.Array:push<ref>
            global($worker.threads) (param local($worker))
        )

        (br_if $fork tee($workerCount local($workerCount)--))
    )        
)
