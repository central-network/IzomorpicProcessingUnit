

    (func $onlastworkeropen<>
        (call $set_ready_state<i32>
            global($READY_STATE_OPEN)
        )

        (; check is calc requested ;)
        (if (call $get_func_index<>i32)
            (then
                (call $set_active_workers<i32>
                    (call $notify_worker_mutex<>i32)
                )
            )
        )
    )

    (func $terminate_all_workers<>
        (local $threads      <Array>)
        (local $worker      <Worker>)
        (local $index            i32)

        (local.set $index $get_worker_count<>i32())
        (local.set $threads global($worker.threads))

        (loop $workerCount--

            (local.set $index local($index)--)

            (local.set $worker
                (apply $self.Array:at<i32>ref
                    this (param local($index))
                )
            )

            (apply $self.Worker:terminate<> 
                local($worker) (param)
            )

            (br_if $workerCount-- local($index))
        )
        
        (apply $self.Array:splice<i32.i32> 
            this (param i32(0) (call $notify_worker_mutex<>i32))
        )

        (call $set_worker_count<i32> i32(0))
    )

    (func $create_worker_threads<>
        (local $workerCount          i32)
        (local $worker          <Worker>)

        (local.set $workerCount
            (call $get_worker_count<>i32)
        )

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


    (func $get_worker_module<>ref
        (result ref)
        (local $i i32)
        (local $zero i32)
        (local $module ref)

        (if (ref.is_null global($module))
            (then
                (local.set $i global($worker/length))
                (local.set $zero (i32.load i32(0)))
                (local.set $module (new $self.Uint8Array<i32>ref local($i)))

                (loop $i-- tee($i local($i)--)
                    (if (then
                            (memory.init $worker/buffer i32(0) local($i) i32(1))

                            (call $self.Reflect.set<ref.i32.i32>
                                local($module) local($i) (i32.load i32(0))
                            )

                            (br $i--)
                        )
                    )
                )

                (i32.store i32(0) local($zero))
                (global.set $module local($module))
            )
        )

        global($module)
    )

    (func $get_worker_url<>ref
        (result ref)

        (if (ref.is_null global($worker.URL))
            (then
                (global.set $worker.URL
                    (call $self.URL.createObjectURL<ref>ref
                        (new $self.Blob<ref>ref
                            (call $self.Array.of<ref>ref
                                global($worker.code)
                            )
                        )
                    )
                )
            )
        )

        global($worker.URL)
    )

    (func $get_worker_data<>ref
        (result ref)

        (if (ref.is_null global($worker.data))
            (then
                (global.set $worker.data
                    (call $self.Object.fromEntries<ref>ref
                        (call $self.Array.of<ref.ref>ref
                            (call $self.Array.of<ref.ref>ref text('$') $get_worker_module<>ref())
                            (call $self.Array.of<ref.ref>ref text('memory') global($memory))
                        )
                    )
                )
            )
        )

        global($worker.data)
    )

    (func $get_worker_config<>ref
        (result ref)

        (if (ref.is_null global($worker.config))
            (then
                (global.set $worker.config
                    (call $self.Object.fromEntries<ref>ref
                        (call $self.Array.of<ref>ref
                            (call $self.Array.of<ref.ref>ref
                                text('name') text('cpu')
                            )
                        )
                    )
                )
            )
        )

        global($worker.config)
    )
