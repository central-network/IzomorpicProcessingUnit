(func $process_task_queue
    (local  $queue_offset      i32)

    (local  $source_ptr           i32)
    (local  $values_ptr           i32)
    (local  $target_ptr           i32)
    (local  $buffer_len           i32)

    (local  $func_index           i32)
    (local  $concurrency          i32)
    (local  $current_threads      i32)
    (local  $needed_threads       i32)

    (if (global.get $isProcessing) (then (return)))

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

    ;; Notify existing workers to wake up
    (call $notify_worker_mutex<i32>i32
        local($concurrency)
    )            

    (drop)

    ;; Check if we need to spawn more workers
    (local.set $current_threads
        (i32.atomic.load global($OFFSET_MAXLENGTH))
    )

    (log<i32.i32>
        local($concurrency)
        local($current_threads)
    )

    (if (i32.lt_u local($current_threads) local($concurrency))
        (then
            (local.set $needed_threads
                (i32.sub local($concurrency) local($current_threads))
            )
            
            

            (call $create_worker_threads<i32> local($needed_threads))
        )
    )
)

(func $create_worker_threads<i32>
    (param $workerCount          i32)
    (local $worker          <Worker>)

    ;; No global flag needed anymore as we check the count before calling
    
    (loop $fork
        (if (local.get $workerCount)
            (then
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
                
                (i32.atomic.rmw.add global($OFFSET_MAXLENGTH) i32(1))
                (drop)

                (local.set $workerCount (i32.sub local($workerCount) i32(1)))
                (br $fork)
            )
        )
    )        
)
