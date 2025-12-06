
    ;; ============================================================================================================
    ;; CHAIN & TASK ACCESSORS (Getters/Setters)
    ;; ============================================================================================================

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CHAIN HEADER ACCESSORS (Offset 0-63)
    ;; ------------------------------------------------------------------------------------------------------------
    (func $get_chain_id<i32>i32                (param $ptr i32) (result i32) (i32.load offset=0  local.get $ptr))
    (func $get_next_chain_ptr<i32>i32          (param $ptr i32) (result i32) (i32.load offset=4  local.get $ptr))
    (func $get_chain_cpu_count<i32>i32         (param $ptr i32) (result i32) (i32.load offset=8  local.get $ptr))
    (func $get_chain_gpu_count<i32>i32         (param $ptr i32) (result i32) (i32.load offset=12 local.get $ptr))
    (func $get_chain_npu_count<i32>i32         (param $ptr i32) (result i32) (i32.load offset=16 local.get $ptr))
    (func $get_chain_loop_count<i32>i32        (param $ptr i32) (result i32) (i32.load offset=20 local.get $ptr))
    (func $get_chain_start_epoch<i32>f32       (param $ptr i32) (result f32) (f32.load offset=24 local.get $ptr))
    (func $get_chain_end_epoch<i32>f32         (param $ptr i32) (result f32) (f32.load offset=28 local.get $ptr))
    (func $get_chain_total_epoch<i32>f32       (param $ptr i32) (result f32) (f32.load offset=32 local.get $ptr))
    (func $get_chain_task_count<i32>i32        (param $ptr i32) (result i32) (i32.load offset=36 local.get $ptr))
    
    (func $get_chain_counter_pending<i32>i32   (param $ptr i32) (result i32) (i32.atomic.load offset=40 local.get $ptr))
    (func $get_chain_counter_processing<i32>i32 (param $ptr i32) (result i32) (i32.atomic.load offset=44 local.get $ptr))
    (func $get_chain_counter_completed<i32>i32 (param $ptr i32) (result i32) (i32.atomic.load offset=48 local.get $ptr))

    (func $set_chain_id<i32.i32>               (param $ptr i32) (param $val i32) (i32.store offset=0  local.get $ptr local.get $val))
    (func $set_next_chain_ptr<i32.i32>         (param $ptr i32) (param $val i32) (i32.store offset=4  local.get $ptr local.get $val))
    (func $set_chain_cpu_count<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=8  local.get $ptr local.get $val))
    (func $set_chain_gpu_count<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=12 local.get $ptr local.get $val))
    (func $set_chain_npu_count<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=16 local.get $ptr local.get $val))
    (func $set_chain_loop_count<i32.i32>       (param $ptr i32) (param $val i32) (i32.store offset=20 local.get $ptr local.get $val))
    (func $set_chain_start_epoch<i32.f32>      (param $ptr i32) (param $val f32) (f32.store offset=24 local.get $ptr local.get $val))
    (func $set_chain_end_epoch<i32.f32>        (param $ptr i32) (param $val f32) (f32.store offset=28 local.get $ptr local.get $val))
    (func $set_chain_total_epoch<i32.f32>      (param $ptr i32) (param $val f32) (f32.store offset=32 local.get $ptr local.get $val))
    (func $set_chain_task_count<i32.i32>       (param $ptr i32) (param $val i32) (i32.store offset=36 local.get $ptr local.get $val))
    
    (func $set_chain_counter_pending<i32.i32>   (param $ptr i32) (param $val i32) (i32.atomic.store offset=40 local.get $ptr local.get $val))
    (func $set_chain_counter_processing<i32.i32> (param $ptr i32) (param $val i32) (i32.atomic.store offset=44 local.get $ptr local.get $val))
    (func $set_chain_counter_completed<i32.i32>  (param $ptr i32) (param $val i32) (i32.atomic.store offset=48 local.get $ptr local.get $val))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; TASK STATE BLOCK ACCESSORS (Offset 64-127)
    ;; ------------------------------------------------------------------------------------------------------------
    ;; Check if any tasks exist in a 16-task block (SIMD)
    (func $get_chain_has_task<i32>i32
        (param $chain_ptr i32)
        (result i32)
        
        ;; Block 0 (Tasks 0-15)
        (if (v128.any_true (v128.load offset=64 (local.get $chain_ptr)))
            (then (return (i32.const 1)))
        )
        ;; Block 1 (Tasks 16-31)
        (if (v128.any_true (v128.load offset=80 (local.get $chain_ptr)))
            (then (return (i32.const 1)))
        )
        ;; Block 2 (Tasks 32-47)
        (if (v128.any_true (v128.load offset=96 (local.get $chain_ptr)))
            (then (return (i32.const 1)))
        )
        ;; Block 3 (Tasks 48-63)
        (if (v128.any_true (v128.load offset=112 (local.get $chain_ptr)))
            (then (return (i32.const 1)))
        )
        (i32.const 0)
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; TASK HEADER ACCESSORS (Offset 128+)
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; NOTE: $ptr here MUST be the pointer to the specific TASK HEADER, not the Chain Header.
    ;; TaskPtr = ChainPtr + 128 + (TaskIndex * 64)
    
    (func $get_task_chain_id<i32>i32           (param $ptr i32) (result i32) (i32.load offset=0  local.get $ptr))
    
    (func $get_task_atomic_counter<i32>i32     (param $ptr i32) (result i32) (i32.atomic.load8_u offset=4 local.get $ptr))
    (func $get_task_op_code<i32>i32            (param $ptr i32) (result i32) (i32.load8_u offset=5 local.get $ptr))
    (func $get_task_variant_code<i32>i32       (param $ptr i32) (result i32) (i32.load8_u offset=6 local.get $ptr))
    (func $get_task_is_mixed_space<i32>i32     (param $ptr i32) (result i32) (i32.load8_u offset=7 local.get $ptr))

    (func $get_task_func_index<i32>i32         (param $ptr i32) (result i32) (i32.load offset=8  local.get $ptr))
    (func $get_task_src_type_space<i32>i32     (param $ptr i32) (result i32) (i32.load offset=12 local.get $ptr))
    (func $get_task_val_type_space<i32>i32     (param $ptr i32) (result i32) (i32.load offset=16 local.get $ptr))
    (func $get_task_dst_type_space<i32>i32     (param $ptr i32) (result i32) (i32.load offset=20 local.get $ptr))
    (func $get_task_src_bytelength<i32>i32     (param $ptr i32) (result i32) (i32.load offset=24 local.get $ptr))
    (func $get_task_val_bytelength<i32>i32     (param $ptr i32) (result i32) (i32.load offset=28 local.get $ptr))
    (func $get_task_dst_bytelength<i32>i32     (param $ptr i32) (result i32) (i32.load offset=32 local.get $ptr))
    (func $get_task_src_length<i32>i32         (param $ptr i32) (result i32) (i32.load offset=36 local.get $ptr))
    (func $get_task_val_length<i32>i32         (param $ptr i32) (result i32) (i32.load offset=40 local.get $ptr))
    (func $get_task_dst_length<i32>i32         (param $ptr i32) (result i32) (i32.load offset=44 local.get $ptr))
    
    (func $get_task_buf_bytelength<i32>i32     (param $ptr i32) (result i32) (i32.load offset=48 local.get $ptr))
    (func $get_task_src_byteoffset<i32>i32     (param $ptr i32) (result i32) (i32.load offset=52 local.get $ptr))
    (func $get_task_val_byteoffset<i32>i32     (param $ptr i32) (result i32) (i32.load offset=56 local.get $ptr))
    (func $get_task_dst_byteoffset<i32>i32     (param $ptr i32) (result i32) (i32.load offset=60 local.get $ptr))

    ;; Setters
    (func $set_task_chain_id<i32.i32>          (param $ptr i32) (param $val i32) (i32.store offset=0  local.get $ptr local.get $val))
    
    (func $set_task_atomic_counter<i32.i32>    (param $ptr i32) (param $val i32) (i32.atomic.store8 offset=4 local.get $ptr local.get $val))
    (func $set_task_op_code<i32.i32>           (param $ptr i32) (param $val i32) (i32.store8 offset=5  local.get $ptr local.get $val))
    (func $set_task_variant_code<i32.i32>      (param $ptr i32) (param $val i32) (i32.store8 offset=6  local.get $ptr local.get $val))
    (func $set_task_is_mixed_space<i32.i32>    (param $ptr i32) (param $val i32) (i32.store8 offset=7  local.get $ptr local.get $val))

    (func $set_task_func_index<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=8  local.get $ptr local.get $val))
    (func $set_task_src_type_space<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=12 local.get $ptr local.get $val))
    (func $set_task_val_type_space<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=16 local.get $ptr local.get $val))
    (func $set_task_dst_type_space<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=20 local.get $ptr local.get $val))
    (func $set_task_src_bytelength<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=24 local.get $ptr local.get $val))
    (func $set_task_val_bytelength<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=28 local.get $ptr local.get $val))
    (func $set_task_dst_bytelength<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=32 local.get $ptr local.get $val))
    (func $set_task_src_length<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=36 local.get $ptr local.get $val))
    (func $set_task_val_length<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=40 local.get $ptr local.get $val))
    (func $set_task_dst_length<i32.i32>        (param $ptr i32) (param $val i32) (i32.store offset=44 local.get $ptr local.get $val))
    
    (func $set_task_buf_bytelength<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=48 local.get $ptr local.get $val))
    (func $set_task_src_byteoffset<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=52 local.get $ptr local.get $val))
    (func $set_task_val_byteoffset<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=56 local.get $ptr local.get $val))
    (func $set_task_dst_byteoffset<i32.i32>    (param $ptr i32) (param $val i32) (i32.store offset=60 local.get $ptr local.get $val))
