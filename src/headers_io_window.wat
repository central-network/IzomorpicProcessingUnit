
    (func $malloc
        (param $byteLength i32)
        (result i32)

        (local $usedBytes i32)
        (local $offset i32)
        (local $rem_u i32)
        (local $stride i32)

        (local.set $stride $get_stride<>i32())
        (local.set $offset $get_heap_ptr<>i32())

        (local.set $usedBytes
            (i32.add
                local($byteLength) 
                global($LENGTH_MALLOC_HEADERS)
            )
        )

        (if (i32.le_u local($usedBytes) local($stride))
            (then (local.set $usedBytes local($stride)))
            (else
                (if (local.tee $rem_u
                        (i32.rem_u
                            local($usedBytes)
                            local($stride)
                        )
                    )
                    (then
                        (local.set $usedBytes
                            (i32.add 
                                local($usedBytes)
                                (i32.sub
                                    local($stride)
                                    local($rem_u)
                                )
                            )
                        )
                    )
                )
            )
        )

        (call $set_heap_ptr<i32> 
            (i32.add
                local($offset) 
                local($usedBytes)
            )
        )

        (local.set $offset
            (i32.add
                local($offset) 
                global($LENGTH_MALLOC_HEADERS)
            )
        )

        (call $set_bytelength<i32.i32> local($offset) local($byteLength))
        (call $set_used_bytes<i32.i32> local($offset) local($usedBytes))

        local($offset)
    )

    (func $set_array_type<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_ARRAY_TYPE))
                local($value)
                true
            )
        )
    )

    (func $set_used_bytes<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_USED_BYTES))
                local($value)
                true
            )
        )
    )

    (func $set_bytelength<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_BYTELENGTH))
                local($value)
                true
            )
        )
    )

    (func $set_item_count<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_ITEM_COUNT))
                local($value)
                true
            )
        )
    )

    (func $get_array_type<i32>i32
        (param $ptr i32)
        (result $value i32)

        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_ARRAY_TYPE))
                true
            )
        )
    )

    (func $get_used_bytes<i32>i32
        (param $ptr i32)
        (result $value i32)

        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_USED_BYTES))
                true
            )
        )
    )

    (func $get_bytelength<i32>i32
        (param $ptr i32)
        (result $value i32)

        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_BYTELENGTH))
                true
            )
        )
    )

    (func $get_item_count<i32>i32
        (param $ptr i32)
        (result $value i32)

        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                (i32.add local($ptr) global($OFFSET_ITEM_COUNT))
                true
            )
        )
    )

    (func $set_zero<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_ZERO)
                local($value)
                true
            )
        )
    )

    (func $set_heap_ptr<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_HEAP_PTR)
                local($value)
                true
            )
        )
    )

    (func $set_capacity<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_CAPACITY)
                local($value)
                true
            )
        )
    )

    (func $set_maxlength<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_MAXLENGTH)
                local($value)
                true
            )
        )
    )

    (func $set_ready_state<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_READY_STATE)
                local($value)
                true
            )
        )
    )

    (func $set_worker_count<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_WORKER_COUNT)
                local($value)
                true
            )
        )
    )

    (func $set_active_workers<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_ACTIVE_WORKERS)
                local($value)
                true
            )
        )
    )

    (func $set_locked_workers<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_LOCKED_WORKERS)
                local($value)
                true
            )
        )
    )

    (func $set_func_index<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_FUNC_INDEX)
                local($value)
                true
            )
        )
    )

    (func $set_stride<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_STRIDE)
                local($value)
                true
            )
        )
    )

    (func $set_worker_mutex<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_WORKER_MUTEX)
                local($value)
                true
            )
        )
    )

    (func $set_window_mutex<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_WINDOW_MUTEX)
                local($value)
                true
            )
        )
    )

    (func $set_buffer_len<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_BUFFER_LEN)
                local($value)
                true
            )
        )
    )

    (func $set_source_ptr<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_SOURCE_PTR)
                local($value)
                true
            )
        )
    )

    (func $set_values_ptr<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_VALUES_PTR)
                local($value)
                true
            )
        )
    )

    (func $set_target_ptr<i32>
        (param $value i32)
        
        (apply $self.DataView:setUint32<i32.i32.i32>
            global($dataView)
            (param 
                global($OFFSET_TARGET_PTR)
                local($value)
                true
            )
        )
    )

    (func $get_zero<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_ZERO)
                true
            )
        )
    )

    (func $get_heap_ptr<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_HEAP_PTR)
                true
            )
        )
    )

    (func $get_capacity<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_CAPACITY)
                true
            )
        )
    )

    (func $get_maxlength<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_MAXLENGTH)
                true
            )
        )
    )

    (func $get_ready_state<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_READY_STATE)
                true
            )
        )
    )

    (func $get_worker_count<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_WORKER_COUNT)
                true
            )
        )
    )

    (func $get_active_workers<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_ACTIVE_WORKERS)
                true
            )
        )
    )

    (func $get_locked_workers<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_LOCKED_WORKERS)
                true
            )
        )
    )

    (func $get_func_index<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_FUNC_INDEX)
                true
            )
        )
    )

    (func $get_stride<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_STRIDE)
                true
            )
        )
    )

    (func $get_worker_mutex<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_WORKER_MUTEX)
                true
            )
        )
    )

    (func $get_window_mutex<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_WINDOW_MUTEX)
                true
            )
        )
    )

    (func $get_buffer_len<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_BUFFER_LEN)
                true
            )
        )
    )

    (func $get_source_ptr<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_SOURCE_PTR)
                true
            )
        )
    )

    (func $get_values_ptr<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_VALUES_PTR)
                true
            )
        )
    )

    (func $get_target_ptr<>i32
        (result $value i32)
        
        (apply $self.DataView:getUint32<i32.i32>i32
            global($dataView)
            (param 
                global($OFFSET_TARGET_PTR)
                true
            )
        )
    )

    (func $get_byteoffset<ref>i32
        (param $object ref)
        (result $offset i32)
        
        (call $self.Reflect.get<ref.ref>i32
            local($object) text('byteOffset')
        )
    )

    (func $get_array_type<ref>i32
        (param $object ref)
        (result $offset i32)
        
        (call $get_array_type<i32>i32
            (call $get_byteoffset<ref>i32
                local($object)
            )
        )
    )

    (func $get_used_bytes<ref>i32
        (param $object ref)
        (result $offset i32)
        
        (call $get_used_bytes<i32>i32
            (call $get_byteoffset<ref>i32
                local($object)
            )
        )
    )

    (func $get_bytelength<ref>i32
        (param $object ref)
        (result $offset i32)
        
        (call $get_bytelength<i32>i32
            (call $get_byteoffset<ref>i32
                local($object)
            )
        )
    )

    (func $get_item_count<ref>i32
        (param $object ref)
        (result $offset i32)
        
        (call $get_item_count<i32>i32
            (call $get_byteoffset<ref>i32
                local($object)
            )
        )
    )

    

