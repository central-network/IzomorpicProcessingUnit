
    (func $get_worker_count<>i32
        (result $value i32)
        (i32.atomic.load global($OFFSET_WORKER_COUNT))
    )

    (func $new_worker_index<>i32
        (result $value i32)
        (i32.atomic.rmw.add global($OFFSET_ACTIVE_WORKERS) i32(1))
    )

    (func $get_active_workers<>i32
        (result $value i32)
        (i32.atomic.load global($OFFSET_ACTIVE_WORKERS))
    )

    (func $get_locked_workers<>i32
        (result $value i32)
        (i32.atomic.load global($OFFSET_LOCKED_WORKERS))
    )

    (func $set_locked_workers<i32>
        (param $value i32)
        (i32.atomic.store global($OFFSET_LOCKED_WORKERS) local($value))
    )

    (func $new_locked_index<>i32
        (result $value i32)
        (i32.atomic.rmw.add global($OFFSET_LOCKED_WORKERS) i32(1))
    )

    (func $get_notifier_index<>i32
        (result $value i32)
        (i32.atomic.load global($OFFSET_NOTIFIER_INDEX))
    )

    (func $get_func_index<>i32
        (result $value i32)
        (i32.atomic.load global($OFFSET_FUNC_INDEX))
    )

    (func $reset_func_index<>
        (i32.atomic.store global($OFFSET_FUNC_INDEX) i32(0))
    )

    (func $get_stride<>i32
        (result $value i32)
        (i32.load global($OFFSET_STRIDE))
    )

    (func $get_task_vector<>v128
        (result $value v128)
        (v128.load global($OFFSET_TASK_VECTOR))
    )

    (func $get_buffer_len<>i32
        (result $value i32)
        (i32.load global($OFFSET_BUFFER_LEN))
    )

    (func $get_source_ptr<>i32
        (result $value i32)
        (i32.load global($OFFSET_SOURCE_PTR))
    )

    (func $get_values_ptr<>i32
        (result $value i32)
        (i32.load global($OFFSET_VALUES_PTR))
    )

    (func $get_target_ptr<>i32
        (result $value i32)
        (i32.load global($OFFSET_TARGET_PTR))
    )