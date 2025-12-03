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
    (global $f32v_add_n                            i32 (i32.const 137)) ;; 128 + 8 + 1
    (global $f32v_add_1                            i32 (i32.const 138)) ;; 128 + 8 + 2

    ;; SUB (OP=2) -> 256
    (global $f32v_sub_n                            i32 (i32.const 265)) ;; 256 + 8 + 1
    (global $f32v_sub_1                            i32 (i32.const 266)) ;; 256 + 8 + 2

    ;; MUL (OP=3) -> 384
    (global $f32v_mul_n                            i32 (i32.const 393)) ;; 384 + 8 + 1
    (global $f32v_mul_1                            i32 (i32.const 394)) ;; 384 + 8 + 2

    ;; DIV (OP=4) -> 512
    (global $f32v_div_n                            i32 (i32.const 521)) ;; 512 + 8 + 1
    (global $f32v_div_1                            i32 (i32.const 522)) ;; 512 + 8 + 2

    ;; MAX (OP=5) -> 640
    (global $f32v_max_n                            i32 (i32.const 649))
    (global $f32v_max_1                            i32 (i32.const 650))

    ;; MIN (OP=6) -> 768
    (global $f32v_min_n                            i32 (i32.const 777))
    (global $f32v_min_1                            i32 (i32.const 778))

    ;; EQ (OP=7) -> 896
    (global $f32v_eq_n                             i32 (i32.const 905))
    (global $f32v_eq_1                             i32 (i32.const 906))

    ;; NE (OP=8) -> 1024
    (global $f32v_ne_n                             i32 (i32.const 1033))
    (global $f32v_ne_1                             i32 (i32.const 1034))

    ;; LT (OP=9) -> 1152
    (global $f32v_lt_n                             i32 (i32.const 1161))
    (global $f32v_lt_1                             i32 (i32.const 1162))

    ;; GT (OP=10) -> 1280
    (global $f32v_gt_n                             i32 (i32.const 1289))
    (global $f32v_gt_1                             i32 (i32.const 1290))

    ;; LE (OP=11) -> 1408
    (global $f32v_le_n                             i32 (i32.const 1417))
    (global $f32v_le_1                             i32 (i32.const 1418))

    ;; GE (OP=12) -> 1536
    (global $f32v_ge_n                             i32 (i32.const 1545))
    (global $f32v_ge_1                             i32 (i32.const 1546))

    ;; FLOOR (OP=13) -> 1664
    (global $f32v_floor_0                          i32 (i32.const 1675)) ;; 1664 + 8 + 3

    ;; TRUNC (OP=14) -> 1792
    (global $f32v_trunc_0                          i32 (i32.const 1803)) ;; 1792 + 8 + 3

    ;; CEIL (OP=15) -> 1920
    (global $f32v_ceil_0                           i32 (i32.const 1931)) ;; 1920 + 8 + 3

    ;; NEAREST (OP=16) -> 2048
    (global $f32v_nearest_0                        i32 (i32.const 2059)) ;; 2048 + 8 + 3

    ;; ------------------------------------------------------------------------------------------------------------
    ;; MEMORY OFFSETS (64-Byte Header)
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; Block 0: Memory Info (0x00 - 0x0F)
    (global $OFFSET_ZERO                           i32 (i32.const 0))
    (global $OFFSET_HEAP_PTR                       i32 (i32.const 4))
    (global $OFFSET_CAPACITY                       i32 (i32.const 8))
    (global $OFFSET_MAXLENGTH                      i32 (i32.const 12))

    ;; Block 1: Worker Info (0x10 - 0x1F)
    (global $OFFSET_READY_STATE                    i32 (i32.const 16))
    (global $OFFSET_WORKER_COUNT                   i32 (i32.const 20))
    (global $OFFSET_ACTIVE_WORKERS                 i32 (i32.const 24))
    (global $OFFSET_LOCKED_WORKERS                 i32 (i32.const 28))

    (global $INDEX_ACTIVE_WORKERS                  i32 (i32.const 6))
    (global $INDEX_LOCKED_WORKERS                  i32 (i32.const 7))


    ;; Block 2: Control Info (0x20 - 0x2F)
    (global $OFFSET_FUNC_INDEX                     i32 (i32.const 32)) ;; 0x20
    (global $OFFSET_STRIDE                         i32 (i32.const 36)) ;; 0x24
    (global $OFFSET_WORKER_MUTEX                   i32 (i32.const 40)) ;; 0x28
    (global $OFFSET_WINDOW_MUTEX                   i32 (i32.const 44)) ;; 0x2C

    (global $INDEX_WORKER_MUTEX                    i32 (i32.const 10)) ;; 0x28
    (global $INDEX_WINDOW_MUTEX                    i32 (i32.const 11)) ;; 0x2C

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