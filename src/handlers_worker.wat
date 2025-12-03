
    (table $func_table 3000 funcref)

    (func $set_handlers<>
        update($func_table global($f32v_add_n) func($f32v_add_n))
        update($func_table global($f32v_mul_n) func($f32v_mul_n))
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
