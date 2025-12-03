(module
    
    
    (import "self" "Array"              (func $wat4wasm/Array<>ref (param) (result externref)))
    (import "Reflect" "set"             (func $wat4wasm/Reflect.set<ref.i32x2> (param externref i32 i32) (result)))
    (import "Reflect" "getOwnPropertyDescriptor" (func $wat4wasm/Reflect.getOwnPropertyDescriptor<refx2>ref (param externref externref) (result externref)))
    (import "Reflect" "construct"       (func $wat4wasm/Reflect.construct<refx2>ref (param externref externref) (result externref)))
    (import "Reflect" "get"             (func $wat4wasm/Reflect.get<refx2>ref (param externref externref) (result externref)))
    (import "Reflect" "get"             (func $wat4wasm/Reflect.get<refx2>i32 (param externref externref) (result i32)))
    (import "Reflect" "get"             (func $wat4wasm/Reflect.get<refx2>f32 (param externref externref) (result f32)))
    (import "Reflect" "get"             (func $wat4wasm/Reflect.get<refx2>i64 (param externref externref) (result i64)))
    (import "Reflect" "get"             (func $wat4wasm/Reflect.get<refx2>f64 (param externref externref) (result f64)))
    (import "Reflect" "apply"           (func $wat4wasm/Reflect.apply<refx3>ref (param externref externref externref) (result externref)))
    (import "self" "self"               (global $wat4wasm/self externref))
    (import "String" "fromCharCode"     (global $wat4wasm/String.fromCharCode externref))
   
	 

    (import "self" "memory" (memory $memory 100 65536 shared))
    (import "self" "postMessage" (func $postMessage (param i32)))

    
	(; externref  ;)
	(module
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
    ;; VARIANTS (3 Bits: 0-7)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $VARIANT_N_S                           i32 (i32.const 0)) ;; Normal / Scalar Source
    (global $VARIANT_1_S                           i32 (i32.const 1)) ;; 1 Uniform / Scalar Source
    (global $VARIANT_0_S                           i32 (i32.const 2)) ;; 0 Source (Unary)
    (global $VARIANT_Q_S                           i32 (i32.const 3)) ;; Quarter Source
    (global $VARIANT_H_S                           i32 (i32.const 4)) ;; Half Source
    ;; Reserved 5-7

    ;; ------------------------------------------------------------------------------------------------------------
    ;; TYPES (4 Bits: 0-15)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $TYPE_Float32                          i32 (i32.const 0))
    (global $TYPE_Int32                            i32 (i32.const 1))
    (global $TYPE_Uint32                           i32 (i32.const 2))
    (global $TYPE_Int8                             i32 (i32.const 3))
    (global $TYPE_Uint8                            i32 (i32.const 4))
    (global $TYPE_Int16                            i32 (i32.const 5))
    (global $TYPE_Uint16                           i32 (i32.const 6))
    (global $TYPE_Float64                          i32 (i32.const 7))
    (global $TYPE_BigInt64                         i32 (i32.const 8))
    (global $TYPE_BigUint64                        i32 (i32.const 9))
    ;; Reserved 10-15

    ;; ------------------------------------------------------------------------------------------------------------
    ;; OPERATIONS (6 Bits: 0-63)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $OP_ADD                                i32 (i32.const 0))
    (global $OP_SUB                                i32 (i32.const 1))
    (global $OP_MUL                                i32 (i32.const 2))
    (global $OP_DIV                                i32 (i32.const 3))
    (global $OP_MAX                                i32 (i32.const 4))
    (global $OP_MIN                                i32 (i32.const 5))
    (global $OP_EQ                                 i32 (i32.const 6))
    (global $OP_NE                                 i32 (i32.const 7))
    (global $OP_LT                                 i32 (i32.const 8))
    (global $OP_GT                                 i32 (i32.const 9))
    (global $OP_LE                                 i32 (i32.const 10))
    (global $OP_GE                                 i32 (i32.const 11))
    (global $OP_FLOOR                              i32 (i32.const 12))
    (global $OP_TRUNC                              i32 (i32.const 13))
    (global $OP_CEIL                               i32 (i32.const 14))
    (global $OP_NEAREST                            i32 (i32.const 15))
    (global $OP_SQRT                               i32 (i32.const 16))
    (global $OP_ABS                                i32 (i32.const 17))
    (global $OP_NEG                                i32 (i32.const 18))
    (global $OP_AND                                i32 (i32.const 19))
    (global $OP_OR                                 i32 (i32.const 20))
    (global $OP_XOR                                i32 (i32.const 21))
    (global $OP_NOT                                i32 (i32.const 22))
    (global $OP_SHL                                i32 (i32.const 23))
    (global $OP_SHR                                i32 (i32.const 24))
    ;; ... Add more as needed

    ;; ------------------------------------------------------------------------------------------------------------
    ;; PRE-CALCULATED GLOBAL IDs (For Table & Exports)
    ;; Formula: (OP << 7) | (TYPE << 3) | VARIANT
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; ADD (OP=0)
    ;; Float32 (TYPE=0)
    (global $Float32Array.ADD.N.S                  i32 (i32.const 0))   ;; (0<<7)|(0<<3)|0 = 0
    (global $Float32Array.ADD.1.S                  i32 (i32.const 1))   ;; (0<<7)|(0<<3)|1 = 1

    ;; SUB (OP=1)
    ;; Float32 (TYPE=0)
    (global $Float32Array.SUB.N.S                  i32 (i32.const 128)) ;; (1<<7)|(0<<3)|0 = 128
    (global $Float32Array.SUB.1.S                  i32 (i32.const 129)) ;; (1<<7)|(0<<3)|1 = 129

    ;; MUL (OP=2)
    (global $Float32Array.MUL.N.S                  i32 (i32.const 256)) ;; (2<<7)|(0<<3)|0 = 256
    (global $Float32Array.MUL.1.S                  i32 (i32.const 257)) ;; (2<<7)|(0<<3)|1 = 257

    ;; DIV (OP=3)
    (global $Float32Array.DIV.N.S                  i32 (i32.const 384)) ;; (3<<7)|(0<<3)|0 = 384
    (global $Float32Array.DIV.1.S                  i32 (i32.const 385)) ;; (3<<7)|(0<<3)|1 = 385

    ;; MAX (OP=4)
    (global $Float32Array.MAX.N.S                  i32 (i32.const 512))
    (global $Float32Array.MAX.1.S                  i32 (i32.const 513))

    ;; MIN (OP=5)
    (global $Float32Array.MIN.N.S                  i32 (i32.const 640))
    (global $Float32Array.MIN.1.S                  i32 (i32.const 641))

    ;; EQ (OP=6)
    (global $Float32Array.EQ.N.S                   i32 (i32.const 768))
    (global $Float32Array.EQ.1.S                   i32 (i32.const 769))

    ;; NE (OP=7)
    (global $Float32Array.NE.N.S                   i32 (i32.const 896))
    (global $Float32Array.NE.1.S                   i32 (i32.const 897))

    ;; LT (OP=8)
    (global $Float32Array.LT.N.S                   i32 (i32.const 1024))
    (global $Float32Array.LT.1.S                   i32 (i32.const 1025))

    ;; GT (OP=9)
    (global $Float32Array.GT.N.S                   i32 (i32.const 1152))
    (global $Float32Array.GT.1.S                   i32 (i32.const 1153))

    ;; LE (OP=10)
    (global $Float32Array.LE.N.S                   i32 (i32.const 1280))
    (global $Float32Array.LE.1.S                   i32 (i32.const 1281))

    ;; GE (OP=11)
    (global $Float32Array.GE.N.S                   i32 (i32.const 1408))
    (global $Float32Array.GE.1.S                   i32 (i32.const 1409))

    ;; FLOOR (OP=12)
    (global $Float32Array.FLOOR.0.S                i32 (i32.const 1538)) ;; (12<<7)|(0<<3)|2 = 1536 + 2 = 1538

    ;; TRUNC (OP=13)
    (global $Float32Array.TRUNC.0.S                i32 (i32.const 1666)) ;; (13<<7)|(0<<3)|2 = 1664 + 2 = 1666

    ;; CEIL (OP=14)
    (global $Float32Array.CEIL.0.S                 i32 (i32.const 1794)) ;; (14<<7)|(0<<3)|2 = 1792 + 2 = 1794

    ;; NEAREST (OP=15)
    (global $Float32Array.NEAREST.0.S              i32 (i32.const 1922)) ;; (15<<7)|(0<<3)|2 = 1920 + 2 = 1922

    ;; ------------------------------------------------------------------------------------------------------------
    ;; MEMORY OFFSETS (64-Byte Header)
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; Block 0: Memory Info (0x00 - 0x0F)
    (global $OFFSET_ZERO                           i32 (i32.const 0))
    (global $OFFSET_HEAP_PTR                       i32 (i32.const 4))
    (global $OFFSET_CAPACITY                       i32 (i32.const 8))
    (global $OFFSET_MAX_PAGES                      i32 (i32.const 12))

    ;; Block 1: Worker Info (0x10 - 0x1F)
    (global $OFFSET_CONCURRENCY                    i32 (i32.const 16))
    (global $OFFSET_WORKER_COUNT                   i32 (i32.const 20))
    (global $OFFSET_ACTIVE_WORKERS                 i32 (i32.const 24))
    (global $OFFSET_LOCKED_WORKERS                 i32 (i32.const 28))

    ;; Block 2: Control Info (0x20 - 0x2F)
    (global $OFFSET_FUNC_INDEX                     i32 (i32.const 32)) ;; 0x20
    (global $OFFSET_STRIDE                         i32 (i32.const 36)) ;; 0x24
    (global $OFFSET_WORKER_MUTEX                   i32 (i32.const 40)) ;; 0x28
    (global $OFFSET_WORKER_INDEX_COUNTER           i32 (i32.const 44)) ;; 0x2C44

    ;; Block 3: Task State Vector (0x30 - 0x3F) -> 48
    (global $OFFSET_TASK_VECTOR                    i32 (i32.const 48))
    (global $OFFSET_BUFFER_SIZE                    i32 (i32.const 48))
    (global $OFFSET_SOURCE_PTR                     i32 (i32.const 52))
    (global $OFFSET_VALUES_PTR                     i32 (i32.const 56))
    (global $OFFSET_TARGET_PTR                     i32 (i32.const 60))

    ;; Heap Start
    (global $HEAP_START                            i32 (i32.const 64))
    (global $LENGTH_MALLOC_HEADERS                 i32 (i32.const 16)) 

    ;; Malloc Header Offsets (Relative to Data Pointer)
    (global $OFFSET_HEAD_TYPE                      i32 (i32.const -16))
    (global $OFFSET_HEAD_COUNT                     i32 (i32.const -12))
    (global $OFFSET_HEAD_SIZE                      i32 (i32.const -8))
    (global $OFFSET_HEAD_ALIGNED                   i32 (i32.const -4))

    ;; Legacy / Helper
    (global $SINGLE_VALUE                          i32 (i32.const 4))
    (global $EXACT_LENGTH                          i32 (i32.const 75))
    (global $ZERO_UNIFORM                          i32 (i32.const 150))
    (global $QUARTER_BITS                          i32 (i32.const 225))
    (global $HALF_OF_BITS                          i32 (i32.const 300))
    (global $SIGNED                                i32 (i32.const 2))
    (global $UNSIGNED                              i32 (i32.const 3))
)

    (global $worker_count   (mut i32)  (i32.const 0))
    (global $worker_index   (mut i32)  (i32.const 0))
    (global $worker_offset  (mut v128) (v128.const i32x4 0 0 0 0))
    (global $loop_iterator  (mut v128) (v128.const i32x4 0 0 0 0))

    (table $func 3000 funcref)
    
    (start $loop) (func $loop
(table.set $extern (i32.const 1) (call $wat4wasm/text (i32.const 0) (i32.const 48)))
		(table.set $extern (i32.const 2) (call $wat4wasm/text (i32.const 48) (i32.const 36)))
		(table.set $extern (i32.const 3) (call $wat4wasm/text (i32.const 84) (i32.const 16)))
		(table.set $extern (i32.const 4) (call $wat4wasm/text (i32.const 100) (i32.const 12)))




        (global.set $self.MessageEvent.prototype.data/get
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.getOwnPropertyDescriptor<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 1)) 
                            ) 
                            (table.get $extern (i32.const 2)) 
                        )
                    (table.get $extern (i32.const 3)) 
                )
                (table.get $extern (i32.const 4)) 
            )
        )
        
 
        call $init

        block $sigint
            loop $handle 
                call $wait br_if $sigint
                call $func call_indirect 
                call $next br_if $handle
            end
        end

        call $exit
    )
   
    (global $void i32 (i32.const 0))    
   
    (elem $func
        funcref
        (ref.func $void)
        (ref.func $Float32Array.ADD.N.S)
        (ref.func $Float32Array.ADD.1.S)
        (ref.func $Float32Array.MUL.N.S)
        (ref.func $Float32Array.MUL.1.S)
        (ref.func $Float32Array.DIV.N.S)
        (ref.func $Float32Array.DIV.1.S)
        (ref.func $Float32Array.SUB.N.S)
        (ref.func $Float32Array.SUB.1.S)
        (ref.func $Float32Array.MAX.N.S)
        (ref.func $Float32Array.MAX.1.S)
        (ref.func $Float32Array.MIN.N.S)
        (ref.func $Float32Array.MIN.1.S)
        (ref.func $Float32Array.EQ.N.S)
        (ref.func $Float32Array.EQ.1.S)
        (ref.func $Float32Array.NE.N.S)
        (ref.func $Float32Array.NE.1.S)
        (ref.func $Float32Array.LT.N.S)
        (ref.func $Float32Array.LT.1.S)
        (ref.func $Float32Array.GT.N.S)
        (ref.func $Float32Array.GT.1.S)
        (ref.func $Float32Array.LE.N.S)
        (ref.func $Float32Array.LE.1.S)
        (ref.func $Float32Array.GE.N.S)
        (ref.func $Float32Array.GE.1.S)
        (ref.func $Float32Array.FLOOR.0.S)
        (ref.func $Float32Array.TRUNC.0.S)
        (ref.func $Float32Array.CEIL.0.S)
        (ref.func $Float32Array.NEAREST.0.S)
    )

    (func $init
        (local $stride i32)
        (local $count i32)
        (local $index i32)
        (local $offset i32)

        ;; Get Worker Index
        (local.set $index (call $new_worker_index))
        (global.set $worker_index (local.get $index))

        ;; Get Worker Count & Stride
        (local.set $count (i32.atomic.load (global.get $OFFSET_WORKER_COUNT)))
        (local.set $stride (i32.mul (local.get $count) (i32.const 16)))
        
        ;; Calculate Initial Worker Offset (Index * 16)
        (local.set $offset (i32.mul (local.get $index) (i32.const 16)))

        ;; Prepare Worker Offset Vector: [0, Offset, Offset, Offset]
        ;; User specified: First lane is 0 (Length is shared), others are Offset.
        (global.set $worker_offset 
            (i32x4.replace_lane 0
                (i32x4.splat (local.get $offset))
                (i32.const 0)
            )
        )

        ;; Prepare Loop Iterator: [-Stride, Stride, Stride, Stride]
        (global.set $loop_iterator
            (i32x4.replace_lane 0
                (i32x4.splat (local.get $stride))
                (i32.sub (i32.const 0) (local.get $stride))
            )
        )

        (table.set $func (global.get $void)                      (ref.func $void))
        (table.set $func (global.get $Float32Array.ADD.N.S)      (ref.func $Float32Array.ADD.N.S))
        (table.set $func (global.get $Float32Array.MUL.N.S)      (ref.func $Float32Array.MUL.N.S))
        (table.set $func (global.get $Float32Array.DIV.N.S)      (ref.func $Float32Array.DIV.N.S))
        (table.set $func (global.get $Float32Array.SUB.N.S)      (ref.func $Float32Array.SUB.N.S))
        (table.set $func (global.get $Float32Array.MAX.N.S)      (ref.func $Float32Array.MAX.N.S))
        (table.set $func (global.get $Float32Array.MIN.N.S)      (ref.func $Float32Array.MIN.N.S))
        (table.set $func (global.get $Float32Array.EQ.N.S)       (ref.func $Float32Array.EQ.N.S))
        (table.set $func (global.get $Float32Array.NE.N.S)       (ref.func $Float32Array.NE.N.S))
        (table.set $func (global.get $Float32Array.LT.N.S)       (ref.func $Float32Array.LT.N.S))
        (table.set $func (global.get $Float32Array.GT.N.S)       (ref.func $Float32Array.GT.N.S))
        (table.set $func (global.get $Float32Array.LE.N.S)       (ref.func $Float32Array.LE.N.S))
        (table.set $func (global.get $Float32Array.GE.N.S)       (ref.func $Float32Array.GE.N.S))

        (table.set $func (global.get $Float32Array.ADD.1.S)      (ref.func $Float32Array.ADD.1.S))
        (table.set $func (global.get $Float32Array.MUL.1.S)      (ref.func $Float32Array.MUL.1.S))
        (table.set $func (global.get $Float32Array.DIV.1.S)      (ref.func $Float32Array.DIV.1.S))
        (table.set $func (global.get $Float32Array.SUB.1.S)      (ref.func $Float32Array.SUB.1.S))
        (table.set $func (global.get $Float32Array.MAX.1.S)      (ref.func $Float32Array.MAX.1.S))
        (table.set $func (global.get $Float32Array.MIN.1.S)      (ref.func $Float32Array.MIN.1.S))
        (table.set $func (global.get $Float32Array.EQ.1.S)       (ref.func $Float32Array.EQ.1.S))
        (table.set $func (global.get $Float32Array.NE.1.S)       (ref.func $Float32Array.NE.1.S))
        (table.set $func (global.get $Float32Array.LT.1.S)       (ref.func $Float32Array.LT.1.S))
        (table.set $func (global.get $Float32Array.GT.1.S)       (ref.func $Float32Array.GT.1.S))
        (table.set $func (global.get $Float32Array.LE.1.S)       (ref.func $Float32Array.LE.1.S))
        (table.set $func (global.get $Float32Array.GE.1.S)       (ref.func $Float32Array.GE.1.S))

        (table.set $func (global.get $Float32Array.FLOOR.0.S)    (ref.func $Float32Array.FLOOR.0.S))
        (table.set $func (global.get $Float32Array.TRUNC.0.S)    (ref.func $Float32Array.TRUNC.0.S))
        (table.set $func (global.get $Float32Array.CEIL.0.S)     (ref.func $Float32Array.CEIL.0.S))
        (table.set $func (global.get $Float32Array.NEAREST.0.S)  (ref.func $Float32Array.NEAREST.0.S))     

        (call $postMessage (i32.const 0))   
    )

    (func $exit
        (i32.atomic.rmw.sub (global.get $OFFSET_ACTIVE_WORKERS) (i32.const 1)) 
        (drop)
    )

    (func $wait
        (result i32)
        (memory.atomic.wait32 (global.get $OFFSET_WORKER_MUTEX) (i32.const 0) (i64.const -1))
    )

    (func $next
        (result i32)

        (if (i32.atomic.load (global.get $OFFSET_ZERO))
            (then (return (i32.const 0)))
        )

        (if (i32.eq
                (i32.atomic.rmw.add 
                    (global.get $OFFSET_LOCKED_WORKERS) 
                    (i32.const 1) 
                )
                (i32.sub (i32.atomic.load (global.get $OFFSET_ACTIVE_WORKERS)) (i32.const 1))
            )
            (then (call $signal))
        )

        (i32.const 1)
    )

    (func $signal
        (memory.atomic.notify (global.get $OFFSET_ACTIVE_WORKERS) (i32.const 1))
        (drop)
    )

    (func $get_offsets
        (result v128)
        
        ;; Load Task Vector [Length, Source, Values, Target]
        ;; Add Worker Offset Vector [-Offset, Offset, Offset, Offset]
        (i32x4.add
            (v128.load (global.get $OFFSET_TASK_VECTOR))
            (global.get $worker_offset)
        )
    )

    ;; $get_operand removed (obsolete)

    (func $func
        (result i32)
        (i32.atomic.load (i32.const 12))
    )

    (func $void
        nop
    )

    (func $Float32Array.ADD.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.ADD.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MUL.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MUL.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.DIV.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.DIV.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.SUB.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.SUB.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MAX.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MAX.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MIN.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MIN.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.EQ.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.EQ.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LT.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LT.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GT.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GT.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.FLOOR.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.floor (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.TRUNC.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.trunc (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.CEIL.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ceil (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NEAREST.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.nearest (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )




    (func $get_lock_state
        (result i32)
        (i32.atomic.load (i32.const 0))
    )

    (func $new_worker_index
        (result i32)
        (i32.atomic.rmw.add (global.get $OFFSET_WORKER_INDEX_COUNTER) (i32.const 1))
    )

    (func $get_uniform/32
        (result v128)
        (v128.load32_splat (i32.atomic.load (global.get $OFFSET_VALUES_PTR)))
    )

	(global $self.MessageEvent.prototype.data/get (mut externref) ref.null extern)




	(elem $wat4wasm/refs funcref (ref.func $void) (ref.func $Float32Array.ADD.N.S) (ref.func $Float32Array.ADD.1.S) (ref.func $Float32Array.MUL.N.S) (ref.func $Float32Array.MUL.1.S) (ref.func $Float32Array.DIV.N.S) (ref.func $Float32Array.DIV.1.S) (ref.func $Float32Array.SUB.N.S) (ref.func $Float32Array.SUB.1.S) (ref.func $Float32Array.MAX.N.S) (ref.func $Float32Array.MAX.1.S) (ref.func $Float32Array.MIN.N.S) (ref.func $Float32Array.MIN.1.S) (ref.func $Float32Array.EQ.N.S) (ref.func $Float32Array.EQ.1.S) (ref.func $Float32Array.NE.N.S) (ref.func $Float32Array.NE.1.S) (ref.func $Float32Array.LT.N.S) (ref.func $Float32Array.LT.1.S) (ref.func $Float32Array.GT.N.S) (ref.func $Float32Array.GT.1.S) (ref.func $Float32Array.LE.N.S) (ref.func $Float32Array.LE.1.S) (ref.func $Float32Array.GE.N.S) (ref.func $Float32Array.GE.1.S) (ref.func $Float32Array.FLOOR.0.S) (ref.func $Float32Array.TRUNC.0.S) (ref.func $Float32Array.CEIL.0.S) (ref.func $Float32Array.NEAREST.0.S))

    (table $extern 5 5 externref)

    (func $wat4wasm/text 
        (param $offset i32)
        (param $length i32)

        (result externref)
        
        (local $array externref)
        (local $ovalue i32)

        (if (i32.eqz (local.get $length))
            (then (return (ref.null extern)))
        )

        (local.set $array 
            (call $wat4wasm/Array<>ref)
        )

        (local.set $ovalue (i32.load (i32.const 0)))

        (loop $length--
            (local.set $length
                (i32.sub (local.get $length) (i32.const 4))
            )
                
            (memory.init 0 $wat4wasm/text
                (i32.const 0)
                (i32.add 
                    (local.get $offset)
                    (local.get $length)
                )
                (i32.const 4)
            )        
                            
            (call $wat4wasm/Reflect.set<ref.i32x2>
                (local.get $array)
                (i32.div_u (local.get $length) (i32.const 4))
                (i32.trunc_f32_u	
                    (f32.load 
                        (i32.const 0)
                    )
                )
            )

            (br_if $length-- (local.get $length))
        )

        (i32.store (i32.const 0) (local.get $ovalue))

        (call $wat4wasm/Reflect.apply<refx3>ref
            (global.get $wat4wasm/String.fromCharCode)
            (ref.null extern)
            (local.get $array)
        )
    )

    (data $wat4wasm/text "\00\00\9a\42\00\00\ca\42\00\00\e6\42\00\00\e6\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\8a\42\00\00\ec\42\00\00\ca\42\00\00\dc\42\00\00\e8\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\e8\42\00\00\de\42\00\00\e8\42\00\00\f2\42\00\00\e0\42\00\00\ca\42\00\00\c8\42\00\00\c2\42\00\00\e8\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\e8\42")
)