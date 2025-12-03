
    (func $set_handlers_f32<>
        update($func_table (call $fni global($OP_ADD) global($TYPE_Float32) global($VARIANT_N)) func($f32v_add_n))
        update($func_table (call $fni global($OP_MUL) global($TYPE_Float32) global($VARIANT_N)) func($f32v_mul_n))
        update($func_table (call $fni global($OP_DIV) global($TYPE_Float32) global($VARIANT_N)) func($f32v_div_n))
        update($func_table (call $fni global($OP_SUB) global($TYPE_Float32) global($VARIANT_N)) func($f32v_sub_n))
        update($func_table (call $fni global($OP_ADD) global($TYPE_Float32) global($VARIANT_1)) func($f32v_add_1))
        update($func_table (call $fni global($OP_MUL) global($TYPE_Float32) global($VARIANT_1)) func($f32v_mul_1))
        update($func_table (call $fni global($OP_DIV) global($TYPE_Float32) global($VARIANT_1)) func($f32v_div_1))
        update($func_table (call $fni global($OP_SUB) global($TYPE_Float32) global($VARIANT_1)) func($f32v_sub_1))
        update($func_table (call $fni global($OP_EQ) global($TYPE_Float32) global($VARIANT_N)) func($f32v_eq_n))
        update($func_table (call $fni global($OP_NE) global($TYPE_Float32) global($VARIANT_N)) func($f32v_ne_n))
        update($func_table (call $fni global($OP_EQ) global($TYPE_Float32) global($VARIANT_1)) func($f32v_eq_1))
        update($func_table (call $fni global($OP_NE) global($TYPE_Float32) global($VARIANT_1)) func($f32v_ne_1))
        update($func_table (call $fni global($OP_LT) global($TYPE_Float32) global($VARIANT_N)) func($f32v_lt_n))
        update($func_table (call $fni global($OP_LE) global($TYPE_Float32) global($VARIANT_N)) func($f32v_le_n))
        update($func_table (call $fni global($OP_GT) global($TYPE_Float32) global($VARIANT_N)) func($f32v_gt_n))
        update($func_table (call $fni global($OP_GE) global($TYPE_Float32) global($VARIANT_N)) func($f32v_ge_n))
        update($func_table (call $fni global($OP_LT) global($TYPE_Float32) global($VARIANT_1)) func($f32v_lt_1))
        update($func_table (call $fni global($OP_LE) global($TYPE_Float32) global($VARIANT_1)) func($f32v_le_1))
        update($func_table (call $fni global($OP_GT) global($TYPE_Float32) global($VARIANT_1)) func($f32v_gt_1))
        update($func_table (call $fni global($OP_GE) global($TYPE_Float32) global($VARIANT_1)) func($f32v_ge_1))
        update($func_table (call $fni global($OP_MIN) global($TYPE_Float32) global($VARIANT_N)) func($f32v_min_n))
        update($func_table (call $fni global($OP_MAX) global($TYPE_Float32) global($VARIANT_N)) func($f32v_max_n))
        update($func_table (call $fni global($OP_MIN) global($TYPE_Float32) global($VARIANT_1)) func($f32v_min_1))
        update($func_table (call $fni global($OP_MAX) global($TYPE_Float32) global($VARIANT_1)) func($f32v_max_1))
        update($func_table (call $fni global($OP_FLOOR) global($TYPE_Float32) global($VARIANT_0)) func($f32v_floor_0))
        update($func_table (call $fni global($OP_CEIL) global($TYPE_Float32) global($VARIANT_0)) func($f32v_ceil_0))
        update($func_table (call $fni global($OP_TRUNC) global($TYPE_Float32) global($VARIANT_0)) func($f32v_trunc_0))
        update($func_table (call $fni global($OP_NEAREST) global($TYPE_Float32) global($VARIANT_0)) func($f32v_nearest_0))
        update($func_table (call $fni global($OP_NEG) global($TYPE_Float32) global($VARIANT_0)) func($f32v_neg_0))
        update($func_table (call $fni global($OP_ABS) global($TYPE_Float32) global($VARIANT_0)) func($f32v_abs_0))
        update($func_table (call $fni global($OP_SQRT) global($TYPE_Float32) global($VARIANT_0)) func($f32v_sqrt_0))
    )

    (func $f32v_floor_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.floor 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_ceil_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.ceil 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_trunc_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.trunc 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_nearest_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.nearest 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_sqrt_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.sqrt 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_neg_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.neg 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_abs_0
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.abs 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )
    
    (func $f32v_add_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_mul_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_div_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_sub_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_max_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_min_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_le_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_ge_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_lt_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_gt_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_eq_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_ne_n
        (local $task_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            (v128.load (i32x4.extract_lane 2 local($task_vector)))
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )



    (func $f32v_add_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then
                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_mul_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_div_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_sub_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_max_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_min_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_le_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_ge_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_lt_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_gt_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_eq_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    (func $f32v_ne_1
        (local $task_vector v128)
        (local $value_vector v128)
        
        (local.set $task_vector 
            (i32x4.add global($worker_offset) (call $get_task_vector<>v128))
        )

        (local.set $value_vector 
            (v128.load32_splat (call $get_values_ptr<>i32))
        )

        (loop $i
            (if (i32x4.extract_lane 0 local($task_vector))
                (then

                    (v128.store (i32x4.extract_lane 3 local($task_vector))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 1 local($task_vector)))
                            local($value_vector)
                        )
                    )

                    (local.set $task_vector 
                        (i32x4.add global($loop_iterator) local($task_vector))
                    )

                    (br $i)
                )
            )
        )
    )

    
