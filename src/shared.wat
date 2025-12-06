
    (func $void)
    ;; ============================================================================================================
    ;; CONSTANTS & OPCODES (BITWISE COMPOSITION)
    ;; ============================================================================================================
    ;; ID Structure (16-bit):
    ;; [ Reserved (3) ] [ Operation (6) ] [ Type (4) ] [ Variant (3) ]
    ;;
    ;; Formula:
    ;; ID = (Operation << 7) | (Type << 3) | Variant
    ;; 
    ;; Note: Shifts are adjusted to:
    ;; Variant:   Bits 0-2 (Mask: 0x07)
    ;; Type:      Bits 3-6 (Mask: 0x78)  -> Shift 3
    ;; Operation: Bits 7-12 (Mask: 0x1F80) -> Shift 7
    ;; ============================================================================================================

    ;; ------------------------------------------------------------------------------------------------------------
    ;; SHIFTS
    ;; ------------------------------------------------------------------------------------------------------------
    (global $SHIFT_TYPE                            i32 (i32.const 3))
    (global $SHIFT_OP                              i32 (i32.const 7))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; VARIANTS (3 Bits: 1-7)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $VARIANT_N                             i32 (i32.const 1)) ;; Exact Length
    (global $VARIANT_1                             i32 (i32.const 2)) ;; 1 Uniform / Scalar Source
    (global $VARIANT_0                             i32 (i32.const 3)) ;; 0 Source (Unary)
    (global $VARIANT_Q                             i32 (i32.const 4)) ;; Quarter Source
    (global $VARIANT_H                             i32 (i32.const 5)) ;; Half Source
    ;; Reserved 6-7

    ;; ------------------------------------------------------------------------------------------------------------
    ;; TYPES (4 Bits: 1-15)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $TYPE_Float32                          i32 (i32.const 1))
    (global $TYPE_Int32                            i32 (i32.const 2))
    (global $TYPE_Uint32                           i32 (i32.const 3))
    (global $TYPE_Int8                             i32 (i32.const 4))
    (global $TYPE_Uint8                            i32 (i32.const 5))
    (global $TYPE_Int16                            i32 (i32.const 6))
    (global $TYPE_Uint16                           i32 (i32.const 7))
    (global $TYPE_Float64                          i32 (i32.const 8))
    (global $TYPE_BigInt64                         i32 (i32.const 9))
    (global $TYPE_BigUint64                        i32 (i32.const 10))
    ;; Reserved 11-15

    ;; ------------------------------------------------------------------------------------------------------------
    ;; OPERATIONS (6 Bits: 1-64)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $OP_ADD                                i32 (i32.const 1))
    (global $OP_SUB                                i32 (i32.const 2))
    (global $OP_MUL                                i32 (i32.const 3))
    (global $OP_DIV                                i32 (i32.const 4))
    (global $OP_MAX                                i32 (i32.const 5))
    (global $OP_MIN                                i32 (i32.const 6))
    (global $OP_EQ                                 i32 (i32.const 7))
    (global $OP_NE                                 i32 (i32.const 8))
    (global $OP_LT                                 i32 (i32.const 9))
    (global $OP_GT                                 i32 (i32.const 10))
    (global $OP_LE                                 i32 (i32.const 11))
    (global $OP_GE                                 i32 (i32.const 12))
    (global $OP_FLOOR                              i32 (i32.const 13))
    (global $OP_TRUNC                              i32 (i32.const 14))
    (global $OP_CEIL                               i32 (i32.const 15))
    (global $OP_NEAREST                            i32 (i32.const 16))
    (global $OP_SQRT                               i32 (i32.const 17))
    (global $OP_ABS                                i32 (i32.const 18))
    (global $OP_NEG                                i32 (i32.const 19))
    (global $OP_AND                                i32 (i32.const 20))
    (global $OP_OR                                 i32 (i32.const 21))
    (global $OP_XOR                                i32 (i32.const 22))
    (global $OP_NOT                                i32 (i32.const 23))
    (global $OP_SHL                                i32 (i32.const 24))
    (global $OP_SHR                                i32 (i32.const 25))
    ;; ... Add more as needed

    ;; ------------------------------------------------------------------------------------------------------------
    ;; PRE-CALCULATED GLOBAL IDs (For Table & Exports)
    ;; Formula: (OP << 7) | (TYPE << 3) | VARIANT
    ;; Base: Type=1 (Float32) -> Shift 3 -> 8
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; ADD (OP=1) -> 128
    (func $fni
        (param $opcode i32)
        (param $type_space i32)
        (param $variant_code i32)
        (result i32)
        (i32.or
            (i32.shl local($opcode) global($SHIFT_OP))
            (i32.or
                (i32.shl local($type_space) global($SHIFT_TYPE))
                local($variant_code)
            )
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; MEMORY OFFSETS (64-Byte Header)
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; Block 0: Memory Info (0x00 - 0x0F)
    (global $OFFSET_ZERO                           i32 (i32.const 0))
    (global $OFFSET_HEAP_PTR                       i32 (i32.const 4))
    (global $OFFSET_CAPACITY                       i32 (i32.const 8))
    (global $OFFSET_MAXLENGTH                      i32 (i32.const 12))

    ;; Block 1: Worker Info (0x10 - 0x1F)
    (global $OFFSET_WORKER_COUNT                   i32 (i32.const 16))
    (global $OFFSET_ACTIVE_WORKERS                 i32 (i32.const 20))
    (global $OFFSET_LOCKED_WORKERS                 i32 (i32.const 24))
    (global $OFFSET_NOTIFIER_INDEX                 i32 (i32.const 28))

    ;; Block 2: Control Info (0x20 - 0x2F)
    (global $OFFSET_WINDOW_MUTEX                   i32 (i32.const 32)) ;; 0x20
    (global $INDEX_WINDOW_MUTEX                    i32 (i32.const  8)) 
    (global $OFFSET_WORKER_MUTEX                   i32 (i32.const 36)) ;; 0x24
    (global $INDEX_WORKER_MUTEX                    i32 (i32.const  9)) 
    (global $OFFSET_STRIDE                         i32 (i32.const 40)) ;; 0x28
    (global $OFFSET_FUNC_INDEX                     i32 (i32.const 44)) ;; 0x2C

    ;; Block 3: Task State Vector (0x30 - 0x3F) -> 48
    (global $OFFSET_TASK_VECTOR                    i32 (i32.const 48))
    (global $OFFSET_BUFFER_LEN                     i32 (i32.const 48))
    (global $OFFSET_SOURCE_PTR                     i32 (i32.const 52))
    (global $OFFSET_VALUES_PTR                     i32 (i32.const 56))
    (global $OFFSET_TARGET_PTR                     i32 (i32.const 60))

    ;; Heap Start
    (global $HEAP_START                            i32 (i32.const 64))
    (global $LENGTH_MALLOC_HEADERS                 i32 (i32.const 16)) 

    ;; Malloc Header Offsets (Relative to Data Pointer)
    (global $OFFSET_ARRAY_TYPE                     i32 (i32.const -16))
    (global $OFFSET_USED_BYTES                     i32 (i32.const -12))
    (global $OFFSET_BYTELENGTH                     i32 (i32.const -8))
    (global $OFFSET_ITEM_COUNT                     i32 (i32.const -4))



    ;; Legacy / Helper
    (global $SINGLE_VALUE                          i32 (i32.const 4))
    (global $EXACT_LENGTH                          i32 (i32.const 75))
    (global $ZERO_UNIFORM                          i32 (i32.const 150))
    (global $QUARTER_BITS                          i32 (i32.const 225))
    (global $HALF_OF_BITS                          i32 (i32.const 300))
    (global $SIGNED                                i32 (i32.const 2))
    (global $UNSIGNED                              i32 (i32.const 3))

    (global $TYPE_DataView                         i32 (i32.const 11)) ;; Added DataView

    (global $READY_STATE_CLOSED                    i32 (i32.const 0))
    (global $READY_STATE_OPEN                      i32 (i32.const 1))
    (global $READY_STATE_OPENING                   i32 (i32.const 2))
    (global $READY_STATE_CLOSING                   i32 (i32.const 3))
    (global $READY_STATE_ERROR                     i32 (i32.const 4))
    (global $READY_STATE_BUSY                      i32 (i32.const 5))
    (global $READY_STATE_IDLE                      i32 (i32.const 6))

    