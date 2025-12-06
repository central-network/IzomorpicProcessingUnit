
    (func $get_memory<>ref
        (result ref)

        (if (ref.is_null global($memory))
            (then
                (global.set $memory
                    (new $self.WebAssembly.Memory<ref>ref
                        (call $self.Object.fromEntries<ref>ref
                            (call $self.Array.of<ref.ref.ref>ref
                                $self.Array.of<ref.i32>ref(text('initial') global($DEFAULT_MEMORY_INITIAL))
                                $self.Array.of<ref.i32>ref(text('maximum') global($DEFAULT_MEMORY_MAXIMUM))
                                $self.Array.of<ref.i32>ref(text('shared')  global($DEFAULT_MEMORY_SHARED))
                            )
                        )
                    )
                )
            )
        )

        global($memory)
    )

    (func $get_buffer<>ref
        (result ref)

        (if (ref.is_null global($buffer))
            (then
                (global.set $buffer
                    (call $self.Reflect.get<ref.ref>ref
                        (call $get_memory<>ref) 
                        (text 'buffer')
                    ) 
                )
            )
        )

        global($buffer)
    )

    (func $create_memory_links<>
        (global.set $i32View
            (new $self.Int32Array<ref>ref
                (call $get_buffer<>ref)
            )
        )

        (global.set $dataView
            (new $self.DataView<ref>ref
                (call $get_buffer<>ref)
            )
        )
    )

    (func $reset_memory_values<i32>
        (param $workerCount i32)
        
        (call $set_zero<i32>            i32(0))
        (call $set_heap_ptr<i32>        global($HEAP_START))
        (call $set_capacity<i32>        (i32.mul global($DEFAULT_MEMORY_INITIAL) i32(65536)))
        (call $set_maxlength<i32>       (i32.mul global($DEFAULT_MEMORY_MAXIMUM) i32(65536)))

        (call $set_worker_count<i32>    local($workerCount))
        (call $set_active_workers<i32>  i32(0))
        (call $set_locked_workers<i32>  i32(0))
        (call $set_notifier_index<i32>  (i32.sub local($workerCount) i32(1)))

        (call $set_func_index<i32>      i32(0))
        (call $set_stride<i32>          (i32.mul local($workerCount) i32(16)))
        (call $set_worker_mutex<i32>    i32(0))
        (call $set_window_mutex<i32>    i32(0))

        (call $set_buffer_len<i32>      i32(0))
        (call $set_source_ptr<i32>      i32(0))
        (call $set_values_ptr<i32>      i32(0))
        (call $set_target_ptr<i32>      i32(0))

        (i32.store global($OFFSET_ZERO)         i32(0))
        (i32.store global($OFFSET_HEAP_PTR)     global($HEAP_START))
        (i32.store global($OFFSET_CAPACITY)     (i32.mul i32(1) i32(65536)))
        (i32.store global($OFFSET_MAXLENGTH)    i32(0))
    )
