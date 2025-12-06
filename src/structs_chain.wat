
    ;; ============================================================================================================
    ;; CHAIN ARCHITECTURE CONSTANTS
    ;; ============================================================================================================

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CHAIN BLOCK (4224 Bytes Fixed Size)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $CHAIN_BLOCK_SIZE                      i32 (i32.const 4224))
    (global $CHAIN_HEADER_SIZE                     i32 (i32.const 64))
    (global $CHAIN_STATE_BLOCK_SIZE                i32 (i32.const 64))
    (global $TASK_HEADER_SIZE                      i32 (i32.const 64))
    (global $MAX_TASKS_PER_BLOCK                   i32 (i32.const 63))

    (global $OFFSET_CHAIN_HEADER_START             i32 (i32.const 0))
    (global $OFFSET_CHAIN_STATE_BLOCK_START        i32 (i32.const 64))
    (global $OFFSET_CHAIN_TASK_HEADERS_START       i32 (i32.const 128))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CHAIN HEADER OFFSETS (64 Bytes)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $OFFSET_CHAIN_ID                       i32 (i32.const 0))  ;; i32
    (global $OFFSET_NEXT_CHAIN_PTR                 i32 (i32.const 4))  ;; i32
    (global $OFFSET_CPU_COUNT                      i32 (i32.const 8))  ;; i32
    (global $OFFSET_GPU_COUNT                      i32 (i32.const 12)) ;; i32
    (global $OFFSET_NPU_COUNT                      i32 (i32.const 16)) ;; i32
    (global $OFFSET_LOOP_COUNT                     i32 (i32.const 20)) ;; i32
    (global $OFFSET_START_EPOCH                    i32 (i32.const 24)) ;; f32
    (global $OFFSET_END_EPOCH                      i32 (i32.const 28)) ;; f32
    (global $OFFSET_TOTAL_EPOCH                    i32 (i32.const 32)) ;; f32
    (global $OFFSET_TASK_COUNT                     i32 (i32.const 36)) ;; i32
    (global $OFFSET_COUNTER_PENDING                i32 (i32.const 40)) ;; i32 (Atomic)
    (global $OFFSET_COUNTER_PROCESSING             i32 (i32.const 44)) ;; i32 (Atomic)
    (global $OFFSET_COUNTER_COMPLETED              i32 (i32.const 48)) ;; i32 (Atomic)
    ;; Reserved: 52, 56, 60

    ;; ------------------------------------------------------------------------------------------------------------
    ;; TASK HEADER OFFSETS (64 Bytes)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $OFFSET_TASK_CHAIN_ID                  i32 (i32.const 0))  ;; i32
    
    ;; Packed Byte Fields (Offset 4)
    (global $OFFSET_ATOMIC_COUNTER                 i32 (i32.const 4))  ;; i8
    (global $OFFSET_OP_CODE                        i32 (i32.const 5))  ;; i8
    (global $OFFSET_VARIANT_CODE                   i32 (i32.const 6))  ;; i8
    (global $OFFSET_IS_MIXED_SPACE                 i32 (i32.const 7))  ;; i8

    (global $OFFSET_TASK_FUNC_INDEX                i32 (i32.const 8))  ;; i32
    (global $OFFSET_SRC_TYPE_SPACE                 i32 (i32.const 12)) ;; i32
    (global $OFFSET_VAL_TYPE_SPACE                 i32 (i32.const 16)) ;; i32
    (global $OFFSET_DST_TYPE_SPACE                 i32 (i32.const 20)) ;; i32
    (global $OFFSET_SRC_BYTELENGTH                 i32 (i32.const 24)) ;; i32
    (global $OFFSET_VAL_BYTELENGTH                 i32 (i32.const 28)) ;; i32
    (global $OFFSET_DST_BYTELENGTH                 i32 (i32.const 32)) ;; i32
    (global $OFFSET_SRC_LENGTH                     i32 (i32.const 36)) ;; i32
    (global $OFFSET_VAL_LENGTH                     i32 (i32.const 40)) ;; i32
    (global $OFFSET_DST_LENGTH                     i32 (i32.const 44)) ;; i32
    
    ;; v128 Aligned Block (Offset 48)
    (global $OFFSET_BUF_BYTELENGTH                 i32 (i32.const 48)) ;; i32
    (global $OFFSET_SRC_BYTEOFFSET                 i32 (i32.const 52)) ;; i32
    (global $OFFSET_VAL_BYTEOFFSET                 i32 (i32.const 56)) ;; i32
    (global $OFFSET_DST_BYTEOFFSET                 i32 (i32.const 60)) ;; i32
