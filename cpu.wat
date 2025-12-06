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
   
	(import "Reflect" "apply" (func $self.Reflect.apply<refx3>ref (param externref externref externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<i32>ref (param i32) (result externref)))
	(import "Reflect" "apply" (func $self.Reflect.apply<refx3> (param externref externref externref)))
	(import "Array" "of" (func $self.Array.of<>ref  (result externref)))
	(import "Array" "of" (func $self.Array.of<i32.i32>ref (param i32 i32) (result externref)))
	(import "Reflect" "construct" (func $self.Reflect.construct<refx2>ref (param externref externref) (result externref)))
	(import "Reflect" "set" (func $self.Reflect.set<ref.i32.i32> (param externref i32 i32)))
	(import "URL" "createObjectURL" (func $self.URL.createObjectURL<ref>ref (param externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<ref>ref (param externref) (result externref)))
	(import "Object" "fromEntries" (func $self.Object.fromEntries<ref>ref (param externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<ref.ref>ref (param externref externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<ref.ref.ref>ref (param externref externref externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<ref.i32>ref (param externref i32) (result externref)))
	(import "Reflect" "get" (func $self.Reflect.get<ref.ref>ref (param externref externref) (result externref)))
	(import "Reflect" "deleteProperty" (func $self.Reflect.deleteProperty<ref.ref> (param externref externref)))
	(import "Reflect" "deleteProperty" (func $self.Reflect.deleteProperty<fun.ref> (param funcref externref)))
	(import "self" "Symbol" (func $self.Symbol<ref>ref (param externref) (result externref)))
	(import "Reflect" "get" (func $self.Reflect.get<ref.ref>i32 (param externref externref) (result i32)))
	(import "Reflect" "setPrototypeOf" (func $self.Reflect.setPrototypeOf<fun.ref> (param funcref externref)))
	(import "Reflect" "defineProperty" (func $self.Reflect.defineProperty<ref.ref.ref> (param externref externref externref)))
	(import "Reflect" "defineProperty" (func $self.Reflect.defineProperty<fun.ref.ref> (param funcref externref externref)))
	(import "Array" "of" (func $self.Array.of<ref.fun>ref (param externref funcref) (result externref)))
	(import "console" "log" (func $self.console.log<ref> (param externref)))
	(import "Reflect" "apply" (func $self.Reflect.apply<ref.ref.ref>ref (param externref externref externref) (result externref)))
	(import "Array" "of" (func $self.Array.of<fun>ref (param funcref) (result externref)))
	(import "Reflect" "set" (func $self.Reflect.set<ref.i32.fun> (param externref i32 funcref)))
	(import "Reflect" "set" (func $self.Reflect.set<ref.i32.ref> (param externref i32 externref)))
	(import "Reflect" "set" (func $self.Reflect.set<ref.ref.i32> (param externref externref i32)))
	(import "Reflect" "construct" (func $self.Reflect.construct<ref.ref>ref (param externref externref) (result externref)))
	(import "Reflect" "apply" (func $self.Reflect.apply<ref.ref.ref> (param externref externref externref)))
	(import "Reflect" "set" (func $self.Reflect.set<ref.ref.ref> (param externref externref externref)))
	(import "Array" "of" (func $self.Array.of<i32.i32.i32>ref (param i32 i32 i32) (result externref)))
	(import "Reflect" "apply" (func $self.Reflect.apply<refx3>i32 (param externref externref externref) (result i32)))
	(import "ArrayBuffer" "isView" (func $self.ArrayBuffer.isView<ref>i32 (param externref) (result i32)))
	(import "Array" "of" (func $self.Array.of<i32x2>ref (param i32 i32) (result externref)))
	(import "Object" "is" (func $self.Object.is<ref.ref>i32 (param externref externref) (result i32)))
	(import "Reflect" "get" (func $self.Reflect.get<refx2>ref (param externref externref) (result externref)))
	(import "Reflect" "get" (func $self.Reflect.get<refx2>i32 (param externref externref) (result i32)))
	(import "console" "warn" (func $self.console.warn<ref.i32> (param externref i32)))
	(import "Atomics" "notify" (func $self.Atomics.notify<ref.i32.i32>i32 (param externref i32 i32) (result i32)))
	(import "console" "log" (func $self.console.log<i32.i32> (param i32 i32)))
	(import "console" "log" (func $self.console.log<i32.i32.i32> (param i32 i32 i32)))
	(import "Atomics" "waitAsync" (func $self.Atomics.waitAsync<ref.i32.i32>ref (param externref i32 i32) (result externref)))
	(import "console" "error" (func $self.console.error<ref.ref> (param externref externref)))
	 

    
    (memory 1 10)
    
    
	(; externref  ;)
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
            (i32.shl (local.get $opcode) (global.get $SHIFT_OP))
            (i32.or
                (i32.shl (local.get $type_space) (global.get $SHIFT_TYPE))
                (local.get $variant_code)
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
    
    (global $worker/length i32 (i32.const 4133))
    (data $worker/buffer "\00\61\73\6d\01\00\00\00\01\56\10\60\00\01\6f\60\03\6f\7f\7f\00\60\02\6f\6f\01\6f\60\02\6f\6f\01\7f\60\02\6f\6f\01\7d\60\02\6f\6f\01\7e\60\02\6f\6f\01\7c\60\03\6f\6f\6f\01\6f\60\03\7f\7f\7f\00\60\01\6f\00\60\00\00\60\03\7f\7f\7f\01\7f\60\00\01\7f\60\01\7f\00\60\00\01\7b\60\02\7f\7f\01\6f\02\8c\02\10\04\73\65\6c\66\05\41\72\72\61\79\00\00\07\52\65\66\6c\65\63\74\03\73\65\74\00\01\07\52\65\66\6c\65\63\74\18\67\65\74\4f\77\6e\50\72\6f\70\65\72\74\79\44\65\73\63\72\69\70\74\6f\72\00\02\07\52\65\66\6c\65\63\74\09\63\6f\6e\73\74\72\75\63\74\00\02\07\52\65\66\6c\65\63\74\03\67\65\74\00\02\07\52\65\66\6c\65\63\74\03\67\65\74\00\03\07\52\65\66\6c\65\63\74\03\67\65\74\00\04\07\52\65\66\6c\65\63\74\03\67\65\74\00\05\07\52\65\66\6c\65\63\74\03\67\65\74\00\06\07\52\65\66\6c\65\63\74\05\61\70\70\6c\79\00\07\04\73\65\6c\66\04\73\65\6c\66\03\6f\00\06\53\74\72\69\6e\67\0c\66\72\6f\6d\43\68\61\72\43\6f\64\65\03\6f\00\07\63\6f\6e\73\6f\6c\65\03\6c\6f\67\00\08\07\63\6f\6e\73\6f\6c\65\05\65\72\72\6f\72\00\09\04\73\65\6c\66\06\6d\65\6d\6f\72\79\02\03\ff\ff\03\ff\ff\03\04\73\65\6c\66\05\63\6c\6f\73\65\00\0a\03\38\37\0a\0b\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0a\0c\0c\0c\0c\0d\0c\0c\0c\0a\0c\0e\0c\0c\0c\0c\0a\0a\0a\0a\0f\04\0a\02\70\00\80\80\04\6f\01\07\07\06\d4\03\56\7f\00\41\03\0b\7f\00\41\07\0b\7f\00\41\01\0b\7f\00\41\02\0b\7f\00\41\03\0b\7f\00\41\04\0b\7f\00\41\05\0b\7f\00\41\01\0b\7f\00\41\02\0b\7f\00\41\03\0b\7f\00\41\04\0b\7f\00\41\05\0b\7f\00\41\06\0b\7f\00\41\07\0b\7f\00\41\08\0b\7f\00\41\09\0b\7f\00\41\0a\0b\7f\00\41\01\0b\7f\00\41\02\0b\7f\00\41\03\0b\7f\00\41\04\0b\7f\00\41\05\0b\7f\00\41\06\0b\7f\00\41\07\0b\7f\00\41\08\0b\7f\00\41\09\0b\7f\00\41\0a\0b\7f\00\41\0b\0b\7f\00\41\0c\0b\7f\00\41\0d\0b\7f\00\41\0e\0b\7f\00\41\0f\0b\7f\00\41\10\0b\7f\00\41\11\0b\7f\00\41\12\0b\7f\00\41\13\0b\7f\00\41\14\0b\7f\00\41\15\0b\7f\00\41\16\0b\7f\00\41\17\0b\7f\00\41\18\0b\7f\00\41\19\0b\7f\00\41\00\0b\7f\00\41\04\0b\7f\00\41\08\0b\7f\00\41\0c\0b\7f\00\41\10\0b\7f\00\41\14\0b\7f\00\41\18\0b\7f\00\41\1c\0b\7f\00\41\20\0b\7f\00\41\08\0b\7f\00\41\24\0b\7f\00\41\09\0b\7f\00\41\28\0b\7f\00\41\2c\0b\7f\00\41\30\0b\7f\00\41\30\0b\7f\00\41\34\0b\7f\00\41\38\0b\7f\00\41\3c\0b\7f\00\41\c0\00\0b\7f\00\41\10\0b\7f\00\41\70\0b\7f\00\41\74\0b\7f\00\41\78\0b\7f\00\41\7c\0b\7f\00\41\04\0b\7f\00\41\cb\00\0b\7f\00\41\96\01\0b\7f\00\41\e1\01\0b\7f\00\41\ac\02\0b\7f\00\41\02\0b\7f\00\41\03\0b\7f\00\41\0b\0b\7f\00\41\00\0b\7f\00\41\01\0b\7f\00\41\02\0b\7f\00\41\03\0b\7f\00\41\04\0b\7f\00\41\05\0b\7f\00\41\06\0b\7f\01\41\00\0b\7b\01\fd\0c\00\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\0b\7b\01\fd\0c\ff\ff\ff\ff\01\00\00\00\01\00\00\00\01\00\00\00\0b\6f\01\d0\6f\0b\08\01\3f\09\24\01\01\00\20\0d\18\19\1a\1b\24\25\26\27\22\23\2e\2f\20\1e\21\1f\2c\2a\2d\2b\1d\1c\29\28\11\12\13\14\16\17\15\0c\01\01\0a\83\16\37\02\00\0b\10\00\20\00\23\03\74\20\01\23\02\74\20\02\72\72\0b\0a\00\41\00\d2\0d\26\00\10\10\0b\f6\02\00\23\13\23\09\23\04\10\0e\d2\18\26\00\23\15\23\09\23\04\10\0e\d2\19\26\00\23\16\23\09\23\04\10\0e\d2\1a\26\00\23\14\23\09\23\04\10\0e\d2\1b\26\00\23\13\23\09\23\05\10\0e\d2\24\26\00\23\15\23\09\23\05\10\0e\d2\25\26\00\23\16\23\09\23\05\10\0e\d2\26\26\00\23\14\23\09\23\05\10\0e\d2\27\26\00\23\19\23\09\23\04\10\0e\d2\22\26\00\23\1a\23\09\23\04\10\0e\d2\23\26\00\23\19\23\09\23\05\10\0e\d2\2e\26\00\23\1a\23\09\23\05\10\0e\d2\2f\26\00\23\1b\23\09\23\04\10\0e\d2\20\26\00\23\1d\23\09\23\04\10\0e\d2\1e\26\00\23\1c\23\09\23\04\10\0e\d2\21\26\00\23\1e\23\09\23\04\10\0e\d2\1f\26\00\23\1b\23\09\23\05\10\0e\d2\2c\26\00\23\1d\23\09\23\05\10\0e\d2\2a\26\00\23\1c\23\09\23\05\10\0e\d2\2d\26\00\23\1e\23\09\23\05\10\0e\d2\2b\26\00\23\18\23\09\23\04\10\0e\d2\1d\26\00\23\17\23\09\23\04\10\0e\d2\1c\26\00\23\18\23\09\23\05\10\0e\d2\29\26\00\23\17\23\09\23\05\10\0e\d2\28\26\00\23\1f\23\09\23\06\10\0e\d2\11\26\00\23\21\23\09\23\06\10\0e\d2\12\26\00\23\20\23\09\23\06\10\0e\d2\13\26\00\23\22\23\09\23\06\10\0e\d2\14\26\00\23\25\23\09\23\06\10\0e\d2\16\26\00\23\24\23\09\23\06\10\0e\d2\17\26\00\23\23\23\09\23\06\10\0e\d2\15\26\00\0b\37\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\68\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\37\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\67\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\37\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\69\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\37\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\6a\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\38\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\e3\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\38\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\e1\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\38\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\fd\e0\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e4\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e6\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e7\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e5\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e9\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\e8\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\45\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\46\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\43\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\44\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\41\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\40\01\01\7b\23\55\10\3a\fd\ae\01\21\00\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\00\fd\1b\02\fd\00\04\00\fd\42\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e4\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e6\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e7\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e5\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e9\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\42\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\e8\01\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\45\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\46\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\43\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\44\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\41\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\41\01\02\7b\23\55\10\3a\fd\ae\01\21\00\10\3d\fd\09\02\00\21\01\03\40\20\00\fd\1b\00\04\40\20\00\fd\1b\03\20\00\fd\1b\01\fd\00\04\00\20\01\fd\42\fd\0b\04\00\23\56\20\00\fd\ae\01\21\00\0c\01\0b\0b\0b\08\00\23\30\fe\10\02\00\0b\0a\00\23\31\41\01\fe\1e\02\00\0b\08\00\23\31\fe\10\02\00\0b\08\00\23\32\fe\10\02\00\0b\0a\00\23\32\20\00\fe\17\02\00\0b\0a\00\23\32\41\01\fe\1e\02\00\0b\08\00\23\33\fe\10\02\00\0b\08\00\23\39\fe\10\02\00\0b\0a\00\23\39\41\00\fe\17\02\00\0b\07\00\23\38\28\02\00\0b\08\00\23\3a\fd\00\04\00\0b\07\00\23\3b\28\02\00\0b\07\00\23\3c\28\02\00\0b\07\00\23\3d\28\02\00\0b\07\00\23\3e\28\02\00\0b\83\01\00\41\01\41\00\41\84\01\10\43\26\01\41\02\41\84\01\41\ec\00\10\43\26\01\41\03\41\f0\01\41\30\10\43\26\01\41\04\41\a0\02\41\24\10\43\26\01\41\05\41\c4\02\41\10\10\43\26\01\41\06\41\d4\02\41\0c\10\43\26\01\23\00\41\03\25\01\10\04\41\04\25\01\10\04\41\05\25\01\10\02\41\06\25\01\10\04\24\57\10\40\03\40\10\37\11\0a\00\23\54\10\36\10\33\10\0a\10\35\10\36\46\04\40\10\42\0b\10\41\0c\00\0b\10\0c\0b\1e\00\10\31\24\54\23\55\23\54\fd\11\fd\b5\01\24\55\23\56\10\39\fd\11\fd\b5\01\24\56\10\0f\0b\15\00\23\36\41\00\42\7f\fe\01\02\00\04\40\41\01\25\01\10\0b\0b\0b\17\01\01\7f\23\34\41\01\fe\00\02\00\04\40\0f\0b\41\02\25\01\10\0b\00\0b\53\02\01\6f\01\7f\20\01\45\04\40\d0\6f\0f\0b\10\00\21\02\41\00\28\02\00\21\03\03\40\20\01\41\04\6b\21\01\41\00\20\00\20\01\6a\41\04\fc\08\00\00\20\02\20\01\41\04\6e\41\00\2a\02\00\a9\10\01\20\01\0d\00\0b\41\00\20\03\36\02\00\23\01\d0\6f\20\02\10\09\0b\0b\e4\02\01\01\e0\02\00\00\ae\42\00\00\d2\42\00\00\dc\42\00\00\c8\42\00\00\de\42\00\00\ee\42\00\00\00\42\00\00\da\42\00\00\ea\42\00\00\e8\42\00\00\ca\42\00\00\f0\42\00\00\00\42\00\00\d8\42\00\00\de\42\00\00\c6\42\00\00\d6\42\00\00\00\42\00\00\e4\42\00\00\ca\42\00\00\e8\42\00\00\ea\42\00\00\e4\42\00\00\dc\42\00\00\ca\42\00\00\c8\42\00\00\00\42\00\00\ec\42\00\00\c2\42\00\00\d8\42\00\00\ea\42\00\00\ca\42\00\00\04\42\00\00\ae\42\00\00\d2\42\00\00\dc\42\00\00\c8\42\00\00\de\42\00\00\ee\42\00\00\00\42\00\00\dc\42\00\00\de\42\00\00\e8\42\00\00\d2\42\00\00\cc\42\00\00\d2\42\00\00\c6\42\00\00\c2\42\00\00\e8\42\00\00\d2\42\00\00\de\42\00\00\dc\42\00\00\00\42\00\00\cc\42\00\00\c2\42\00\00\d2\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\04\42\00\00\9a\42\00\00\ca\42\00\00\e6\42\00\00\e6\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\8a\42\00\00\ec\42\00\00\ca\42\00\00\dc\42\00\00\e8\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\e8\42\00\00\de\42\00\00\e8\42\00\00\f2\42\00\00\e0\42\00\00\ca\42\00\00\c8\42\00\00\c2\42\00\00\e8\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\e8\42")
    

    
	(; externref  ;)
	(func $terminate_all_workers<>
        (local $threads externref )
        (local $worker externref )
        (local $index            i32)

        (global.set $isSpawning (i32.const 0))
        
        (local.set $index (call $get_worker_count<>i32 ))
        (local.set $threads (global.get $worker.threads))

        (loop $workerCount--

            (local.set $index (local.get $index) (i32.const 1) (i32.sub))

            (local.set $worker
                (call $self.Reflect.apply<refx3>ref 
            (global.get $self.Array:at)
                    (local.get 0) (call $self.Array.of<i32>ref (local.get $index))
                )
            )

            (call $self.Reflect.apply<refx3> 
            (global.get $self.Worker:terminate) 
                (local.get $worker) (call $self.Array.of<>ref)
            )

            (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:splice) 
                (local.get 0) (call $self.Array.of<i32.i32>ref (local.get $index) (i32.const 1))
            )

            (br_if $workerCount-- (local.get $index))
        )

        (call $set_active_workers<i32> (i32.const 0))
        (call $set_locked_workers<i32> (i32.const 0))
        (i32.atomic.store (global.get $OFFSET_MAXLENGTH) (i32.const 0))
    )




    (func $get_worker_module<>ref
        (result externref)
        (local $i i32)
        (local $zero i32)
        (local $module externref)

        (if (ref.is_null (global.get $module))
            (then
                (local.set $i (global.get $worker/length))
                (local.set $zero (i32.load (i32.const 0)))
                (local.set $module (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Uint8Array) 
            (call $self.Array.of<i32>ref  (local.get $i))))

                (loop $i-- (local.tee $i (local.get $i) (i32.const 1) (i32.sub))
                    (if (then
                            (memory.init $worker/buffer (i32.const 0) (local.get $i) (i32.const 1))

                            (call $self.Reflect.set<ref.i32.i32>
                                (local.get $module) (local.get $i) (i32.load (i32.const 0))
                            )

                            (br $i--)
                        )
                    )
                )

                (i32.store (i32.const 0) (local.get $zero))
                (global.set $module (local.get $module))
            )
        )

        (global.get $module)
    )

    (func $get_worker_url<>ref
        (result externref)

        (if (ref.is_null (global.get $worker.URL))
            (then
                (global.set $worker.URL
                    (call $self.URL.createObjectURL<ref>ref
                        (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Blob) 
            (call $self.Array.of<ref>ref 
                            (call $self.Array.of<ref>ref
                                (global.get $worker.code)
                            )
                        ))
                    )
                )
            )
        )

        (global.get $worker.URL)
    )

    (func $get_worker_data<>ref
        (result externref)

        (if (ref.is_null (global.get $worker.data))
            (then
                (global.set $worker.data
                    (call $self.Object.fromEntries<ref>ref
                        (call $self.Array.of<ref.ref>ref
                            (call $self.Array.of<ref.ref>ref (table.get $extern (i32.const 1)) (call $get_worker_module<>ref ))
                            (call $self.Array.of<ref.ref>ref (table.get $extern (i32.const 2)) (global.get $memory))
                        )
                    )
                )
            )
        )

        (global.get $worker.data)
    )

    (func $get_worker_config<>ref
        (result externref)

        (if (ref.is_null (global.get $worker.config))
            (then
                (global.set $worker.config
                    (call $self.Object.fromEntries<ref>ref
                        (call $self.Array.of<ref>ref
                            (call $self.Array.of<ref.ref>ref
                                (table.get $extern (i32.const 3)) (table.get $extern (i32.const 4))
                            )
                        )
                    )
                )
            )
        )

        (global.get $worker.config)
    )
    
	(; externref  ;)
	(func $get_memory<>ref
        (result externref)

        (if (ref.is_null (global.get $memory))
            (then
                (global.set $memory
                    (call $self.Reflect.construct<refx2>ref 
            (global.get $self.WebAssembly.Memory) 
            (call $self.Array.of<ref>ref 
                        (call $self.Object.fromEntries<ref>ref
                            (call $self.Array.of<ref.ref.ref>ref
                                (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 5)) (global.get $DEFAULT_MEMORY_INITIAL))
                                (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 6)) (global.get $DEFAULT_MEMORY_MAXIMUM))
                                (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 7))  (global.get $DEFAULT_MEMORY_SHARED))
                            )
                        )
                    ))
                )
            )
        )

        (global.get $memory)
    )

    (func $get_buffer<>ref
        (result externref)

        (if (ref.is_null (global.get $buffer))
            (then
                (global.set $buffer
                    (call $self.Reflect.get<ref.ref>ref
                        (call $get_memory<>ref) 
                        (table.get $extern (i32.const 8))
                    ) 
                )
            )
        )

        (global.get $buffer)
    )

    (func $create_memory_links<>
        (global.set $i32View
            (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Int32Array) 
            (call $self.Array.of<ref>ref 
                (call $get_buffer<>ref)
            ))
        )

        (global.set $dataView
            (call $self.Reflect.construct<refx2>ref 
            (global.get $self.DataView) 
            (call $self.Array.of<ref>ref 
                (call $get_buffer<>ref)
            ))
        )
    )

    (func $reset_memory_values<i32>
        (param $workerCount i32)
        
        (call $set_zero<i32>            (i32.const 0))
        (call $set_heap_ptr<i32>        (global.get $HEAP_START))
        (call $set_capacity<i32>        (i32.mul (global.get $DEFAULT_MEMORY_INITIAL) (i32.const 65536)))
        (call $set_maxlength<i32>       (i32.mul (global.get $DEFAULT_MEMORY_MAXIMUM) (i32.const 65536)))

        (call $set_worker_count<i32>    (local.get $workerCount))
        (call $set_active_workers<i32>  (i32.const 0))
        (call $set_locked_workers<i32>  (i32.const 0))
        (call $set_notifier_index<i32>  (i32.sub (local.get $workerCount) (i32.const 1)))

        (call $set_func_index<i32>      (i32.const 0))
        (call $set_stride<i32>          (i32.mul (local.get $workerCount) (i32.const 16)))
        (call $set_worker_mutex<i32>    (i32.const 0))
        (call $set_window_mutex<i32>    (i32.const 0))

        (call $set_buffer_len<i32>      (i32.const 0))
        (call $set_source_ptr<i32>      (i32.const 0))
        (call $set_values_ptr<i32>      (i32.const 0))
        (call $set_target_ptr<i32>      (i32.const 0))

        (i32.store (global.get $OFFSET_ZERO)         (i32.const 0))
        (i32.store (global.get $OFFSET_HEAP_PTR)     (global.get $HEAP_START))
        (i32.store (global.get $OFFSET_CAPACITY)     (i32.mul (i32.const 1) (i32.const 65536)))
        (i32.store (global.get $OFFSET_MAXLENGTH)    (i32.const 0))
    )
    
	(; externref  ;)
	(func $delete_self_symbols<>
        (call $self.Reflect.deleteProperty<ref.ref> (global.get $self.Uint8Array)   (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> (global.get $self.Uint16Array)  (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> (global.get $self.Uint32Array)  (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> (global.get $self.Float32Array) (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> (global.get $self.DataView)     (call $get_self_symbol<>ref))

        (call $self.Reflect.deleteProperty<fun.ref> (ref.func $this) (table.get $extern (i32.const 9)))
        (call $self.Reflect.deleteProperty<fun.ref> (ref.func $this) (table.get $extern (i32.const 2)))
    )

    (func $get_self_symbol<>ref
        (result externref)

        (if (ref.is_null (global.get $kSymbol))
            (then
                (global.set $kSymbol 
                    (call $self.Symbol<ref>ref 
                        (global.get $kSymbol.tag)
                    )
                )
            )
        )

        (global.get $kSymbol)
    )

    (func $get_self_symbol<ref>i32
        (param $this externref)
        (result i32)
        (call $self.Reflect.get<ref.ref>i32 (local.get $this) (call $get_self_symbol<>ref))
    )

    (func $define_self_symbols<>
        (call $define_property<ref.ref.i32> (global.get $self.Uint8Array)   (call $get_self_symbol<>ref) (global.get $TYPE_Uint8))
        (call $define_property<ref.ref.i32> (global.get $self.Uint16Array)  (call $get_self_symbol<>ref) (global.get $TYPE_Uint16))
        (call $define_property<ref.ref.i32> (global.get $self.Uint32Array)  (call $get_self_symbol<>ref) (global.get $TYPE_Uint32))
        (call $define_property<ref.ref.i32> (global.get $self.Float32Array) (call $get_self_symbol<>ref) (global.get $TYPE_Float32))
        (call $define_property<ref.ref.i32> (global.get $self.DataView)     (call $get_self_symbol<>ref) (global.get $TYPE_DataView))
        
        (call $define_property<fun.ref.ref> (ref.func $this) (table.get $extern (i32.const 10)) (global.get $worker.threads))
        (call $define_property<fun.ref.ref> (ref.func $this) (table.get $extern (i32.const 2)) (call $get_memory<>ref))
        (call $define_property<fun.ref.fun> (ref.func $this) (table.get $extern (i32.const 11)) (ref.func $create))
        (call $define_property<fun.ref.fun> (ref.func $this) (table.get $extern (i32.const 9)) (ref.func $destroy))
        (call $define_property<fun.ref.fun> (ref.func $this) (table.get $extern (i32.const 12)) (ref.func $malloc))

        (call $self.Reflect.setPrototypeOf<fun.ref> (ref.func $this) (ref.null extern))
        (call $self.Reflect.deleteProperty<fun.ref> (ref.func $this) (table.get $extern (i32.const 13)))
        (call $self.Reflect.deleteProperty<fun.ref> (ref.func $this) (table.get $extern (i32.const 3)))
    )

    (func $define_property<ref.ref.i32>
        (param $ref externref)
        (param $key externref)
        (param $val i32)
        
        (call $self.Reflect.defineProperty<ref.ref.ref>
            (local.get $ref) 
            (local.get $key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref>ref
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 14)) (local.get $val))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 15)) (i32.const 1))
                )
            )
        )
    )

    (func $define_property<fun.ref.i32>
        (param $ref funcref)
        (param $key externref)
        (param $val i32)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            (local.get $ref) 
            (local.get $key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref>ref
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 14)) (local.get $val))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 15)) (i32.const 1))
                )
            )
        )
    )

    (func $define_property<fun.ref.fun>
        (param $ref funcref)
        (param $key externref)
        (param $val funcref)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            (local.get $ref) 
            (local.get $key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref.ref>ref
                    (call $self.Array.of<ref.fun>ref (table.get $extern (i32.const 14)) (local.get $val))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 16)) (i32.const 1))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 15)) (i32.const 1))
                )
            )
        )
    )

    (func $define_property<fun.ref.ref>
        (param $ref funcref)
        (param $key externref)
        (param $val externref)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            (local.get $ref) 
            (local.get $key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref.ref>ref
                    (call $self.Array.of<ref.ref>ref (table.get $extern (i32.const 14)) (local.get $val))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 16)) (i32.const 1))
                    (call $self.Array.of<ref.i32>ref (table.get $extern (i32.const 15)) (i32.const 1))
                )
            )
        )
    )
    
	(; externref  ;)
	(func $onscheduledclose<>
        (global.set $postTask.isScheduled (i32.const 0))
        (call $self.console.log<ref> (table.get $extern (i32.const 17)))
        (call $terminate_all_workers<>)
    )

    (func $schedule_close_task<>
        (if (i32.eqz (global.get $postTask.isScheduled)) 
            (then
                (call $self.console.log<ref> (table.get $extern (i32.const 18)))

                (call $self.Reflect.apply<refx3> 
            (global.get $self.Promise.prototype.catch)
                    (call $self.Reflect.apply<ref.ref.ref>ref
                        (global.get $self.Scheduler:postTask)
                        (global.get $self.scheduler)
                        (global.get $postTask.arguments)
                    )
                    (call $self.Array.of<fun>ref (ref.func $void))
                )
                (global.set $postTask.isScheduled (i32.const 1))
            )
        )
    )

    (func $create_task_scheduler<>
        (call $self.console.log<ref> (table.get $extern (i32.const 19)))

        (global.set $postTask.delay (i32.const 3000))
        (global.set $postTask.options (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Object)  (call $self.Array.of<>ref)))
        (global.set $postTask.arguments (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Array)  (call $self.Array.of<>ref)))

        (call $self.Reflect.set<ref.i32.fun>
            (global.get $postTask.arguments) 
            (i32.const 0) 
            (ref.func $onscheduledclose<>) 
        )

        (call $self.Reflect.set<ref.i32.ref>
            (global.get $postTask.arguments)
            (i32.const 1) 
            (global.get $postTask.options) 
        )

        (call $self.Reflect.set<ref.ref.i32>
            (global.get $postTask.options) 
            (table.get $extern (i32.const 20)) 
            (global.get $postTask.delay) 
        )

        (call $create_abort_controller<>)
    )

    (func $create_abort_controller<>  
        (local $signal externref)

        (call $self.console.log<ref> (table.get $extern (i32.const 21)))

        (global.set $abortController 
            (call $self.Reflect.construct<ref.ref>ref
                (global.get $self.AbortController) (global.get $wat4wasm/self)
            )
        )

        (local.set $signal
            (call $self.Reflect.apply<ref.ref.ref>ref
                (global.get $self.AbortController:signal/get)
                (global.get $abortController)
                (global.get $wat4wasm/self)
            )
        )

        (call $self.Reflect.apply<ref.ref.ref>
            (global.get $self.AbortSignal:onabort/set)
            (local.get $signal) 
            (call $self.Array.of<fun>ref
                (ref.func $create_abort_controller<>)
            )
        )

        (call $self.Reflect.set<ref.ref.ref>
            (global.get $postTask.options) 
            (table.get $extern (i32.const 22)) 
            (local.get $signal)
        )
    )

    (func $abort_scheduled_task<>
        (if (i32.eq (i32.const 1) (global.get $postTask.isScheduled)) 
            (then
                (call $self.console.log<ref> (table.get $extern (i32.const 23)))

                (call $self.Reflect.apply<ref.ref.ref>
                    (global.get $self.AbortController:abort)
                    (global.get $abortController) 
                    (global.get $wat4wasm/self)
                )

                (global.set $postTask.isScheduled (i32.const 0))
            )
        )
    )
    
	(; externref  ;)
	(func $malloc
        (param $byteLength i32)
        (result i32)

        (local $usedBytes i32)
        (local $offset i32)
        (local $rem_u i32)
        (local $stride i32)

        (local.set $stride (call $get_stride<>i32 ))
        (local.set $offset (call $get_heap_ptr<>i32 ))

        (local.set $usedBytes
            (i32.add
                (local.get $byteLength) 
                (global.get $LENGTH_MALLOC_HEADERS)
            )
        )

        (if (i32.le_u (local.get $usedBytes) (local.get $stride))
            (then (local.set $usedBytes (local.get $stride)))
            (else
                (if (local.tee $rem_u
                        (i32.rem_u
                            (local.get $usedBytes)
                            (local.get $stride)
                        )
                    )
                    (then
                        (local.set $usedBytes
                            (i32.add 
                                (local.get $usedBytes)
                                (i32.sub
                                    (local.get $stride)
                                    (local.get $rem_u)
                                )
                            )
                        )
                    )
                )
            )
        )

        (call $set_heap_ptr<i32> 
            (i32.add
                (local.get $offset) 
                (local.get $usedBytes)
            )
        )

        (local.set $offset
            (i32.add
                (local.get $offset) 
                (global.get $LENGTH_MALLOC_HEADERS)
            )
        )


        (call $set_bytelength<i32.i32> (local.get $offset) (local.get $byteLength))
        (call $set_used_bytes<i32.i32> (local.get $offset) (local.get $usedBytes))

        (local.get $offset)
    )

    (func $set_array_type<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_ARRAY_TYPE))
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_used_bytes<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_USED_BYTES))
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_bytelength<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_BYTELENGTH))
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_item_count<i32.i32>
        (param $ptr i32)
        (param $value i32)

        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_ITEM_COUNT))
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $get_array_type<i32>i32
        (param $ptr i32)
        (result i32)

        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_ARRAY_TYPE))
                (i32.const 1)
            )
        )
    )

    (func $get_used_bytes<i32>i32
        (param $ptr i32)
        (result i32)

        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_USED_BYTES))
                (i32.const 1)
            )
        )
    )

    (func $get_bytelength<i32>i32
        (param $ptr i32)
        (result i32)

        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_BYTELENGTH))
                (i32.const 1)
            )
        )
    )

    (func $get_item_count<i32>i32
        (param $ptr i32)
        (result i32)

        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (i32.add (local.get $ptr) (global.get $OFFSET_ITEM_COUNT))
                (i32.const 1)
            )
        )
    )

    (func $set_zero<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_ZERO)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_heap_ptr<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_HEAP_PTR)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_capacity<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_CAPACITY)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_maxlength<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_MAXLENGTH)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_worker_count<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_WORKER_COUNT)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_active_workers<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_ACTIVE_WORKERS)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_locked_workers<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_LOCKED_WORKERS)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $reset_locked_workers<>
        (call $set_locked_workers<i32> (i32.const 0))
    )

    (func $set_notifier_index<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_NOTIFIER_INDEX)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_func_index<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_FUNC_INDEX)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_stride<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_STRIDE)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_worker_mutex<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_WORKER_MUTEX)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_window_mutex<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_WINDOW_MUTEX)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_buffer_len<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_BUFFER_LEN)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_source_ptr<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_SOURCE_PTR)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_values_ptr<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_VALUES_PTR)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $set_target_ptr<i32>
        (param $value i32)
        
        (call $self.Reflect.apply<refx3> 
            (global.get $self.DataView:setUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32.i32>ref 
                (global.get $OFFSET_TARGET_PTR)
                (local.get $value)
                (i32.const 1)
            )
        )
    )

    (func $get_zero<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_ZERO)
                (i32.const 1)
            )
        )
    )

    (func $get_heap_ptr<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_HEAP_PTR)
                (i32.const 1)
            )
        )
    )

    (func $get_capacity<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_CAPACITY)
                (i32.const 1)
            )
        )
    )

    (func $get_maxlength<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_MAXLENGTH)
                (i32.const 1)
            )
        )
    )

    (func $get_worker_count<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_WORKER_COUNT)
                (i32.const 1)
            )
        )
    )

    (func $get_active_workers<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_ACTIVE_WORKERS)
                (i32.const 1)
            )
        )
    )

    (func $get_locked_workers<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_LOCKED_WORKERS)
                (i32.const 1)
            )
        )
    )

    (func $get_notifier_index<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_NOTIFIER_INDEX)
                (i32.const 1)
            )
        )
    )

    (func $get_func_index<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_FUNC_INDEX)
                (i32.const 1)
            )
        )
    )

    (func $get_stride<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_STRIDE)
                (i32.const 1)
            )
        )
    )

    (func $get_worker_mutex<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_WORKER_MUTEX)
                (i32.const 1)
            )
        )
    )

    (func $get_window_mutex<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_WINDOW_MUTEX)
                (i32.const 1)
            )
        )
    )

    (func $get_buffer_len<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_BUFFER_LEN)
                (i32.const 1)
            )
        )
    )

    (func $get_source_ptr<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_SOURCE_PTR)
                (i32.const 1)
            )
        )
    )

    (func $get_values_ptr<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_VALUES_PTR)
                (i32.const 1)
            )
        )
    )

    (func $get_target_ptr<>i32
        (result i32)
        
        (call $self.Reflect.apply<refx3>i32 
            (global.get $self.DataView:getUint32)
            (global.get $dataView)
            (call $self.Array.of<i32.i32>ref 
                (global.get $OFFSET_TARGET_PTR)
                (i32.const 1)
            )
        )
    )

    (func $get_byteoffset<ref>i32
        (param $object externref)
        (result i32)
        
        (call $self.Reflect.get<ref.ref>i32
            (local.get $object) (table.get $extern (i32.const 24))
        )
    )

    (func $get_array_type<ref>i32
        (param $object externref)
        (result i32)
        
        (call $get_array_type<i32>i32
            (call $get_byteoffset<ref>i32
                (local.get $object)
            )
        )
    )

    (func $get_used_bytes<ref>i32
        (param $object externref)
        (result i32)
        
        (call $get_used_bytes<i32>i32
            (call $get_byteoffset<ref>i32
                (local.get $object)
            )
        )
    )

    (func $get_bytelength<ref>i32
        (param $object externref)
        (result i32)
        
        (call $get_bytelength<i32>i32
            (call $get_byteoffset<ref>i32
                (local.get $object)
            )
        )
    )

    (func $get_item_count<ref>i32
        (param $object externref)
        (result i32)
        
        (call $get_item_count<i32>i32
            (call $get_byteoffset<ref>i32
                (local.get $object)
            )
        )
    )
    
	(; externref  ;)
	(table $func 30 funcref)

    (type $arg3     
        (func 
            (param $source externref) 
            (param $values externref) 
            (param $target externref) 
            (result externref )
        )
    )

    (type $arg2     
        (func 
            (param $source externref) 
            (param $target externref) 
            (result externref )
        )
    )
    
    (func $add      (export "add")     (type $arg3) (call $calc (global.get $OP_ADD)     (local.get 0) (local.get 1) (local.get 2)))
    (func $sub      (export "sub")     (type $arg3) (call $calc (global.get $OP_SUB)     (local.get 0) (local.get 1) (local.get 2)))
    (func $mul      (export "mul")     (type $arg3) (call $calc (global.get $OP_MUL)     (local.get 0) (local.get 1) (local.get 2)))
    (func $div      (export "div")     (type $arg3) (call $calc (global.get $OP_DIV)     (local.get 0) (local.get 1) (local.get 2)))
    (func $max      (export "max")     (type $arg3) (call $calc (global.get $OP_MAX)     (local.get 0) (local.get 1) (local.get 2)))
    (func $min      (export "min")     (type $arg3) (call $calc (global.get $OP_MIN)     (local.get 0) (local.get 1) (local.get 2)))
    (func $eq       (export "eq")      (type $arg3) (call $calc (global.get $OP_EQ)      (local.get 0) (local.get 1) (local.get 2)))
    (func $ne       (export "ne")      (type $arg3) (call $calc (global.get $OP_NE)      (local.get 0) (local.get 1) (local.get 2)))
    (func $lt       (export "lt")      (type $arg3) (call $calc (global.get $OP_LT)      (local.get 0) (local.get 1) (local.get 2)))
    (func $gt       (export "gt")      (type $arg3) (call $calc (global.get $OP_GT)      (local.get 0) (local.get 1) (local.get 2)))
    (func $le       (export "le")      (type $arg3) (call $calc (global.get $OP_LE)      (local.get 0) (local.get 1) (local.get 2)))
    (func $ge       (export "ge")      (type $arg3) (call $calc (global.get $OP_GE)      (local.get 0) (local.get 1) (local.get 2)))
    (func $floor    (export "floor")   (type $arg2) (call $calc (global.get $OP_FLOOR)   (local.get 0)     (ref.null extern) (local.get 1)))
    (func $trunc    (export "trunc")   (type $arg2) (call $calc (global.get $OP_TRUNC)   (local.get 0)     (ref.null extern) (local.get 1)))
    (func $ceil     (export "ceil")    (type $arg2) (call $calc (global.get $OP_CEIL)    (local.get 0)     (ref.null extern) (local.get 1)))
    (func $nearest  (export "nearest") (type $arg2) (call $calc (global.get $OP_NEAREST) (local.get 0)     (ref.null extern) (local.get 1)))
    (func $sqrt     (export "sqrt")    (type $arg2) (call $calc (global.get $OP_SQRT)    (local.get 0)     (ref.null extern) (local.get 1)))
    (func $abs      (export "abs")     (type $arg2) (call $calc (global.get $OP_ABS)     (local.get 0)     (ref.null extern) (local.get 1)))
    (func $neg      (export "neg")     (type $arg2) (call $calc (global.get $OP_NEG)     (local.get 0)     (ref.null extern) (local.get 1)))
    (func $and      (export "and")     (type $arg3) (call $calc (global.get $OP_AND)     (local.get 0) (local.get 1) (local.get 2)))
    (func $or       (export "or")      (type $arg3) (call $calc (global.get $OP_OR)      (local.get 0) (local.get 1) (local.get 2)))
    (func $xor      (export "xor")     (type $arg3) (call $calc (global.get $OP_XOR)     (local.get 0) (local.get 1) (local.get 2)))
    (func $not      (export "not")     (type $arg3) (call $calc (global.get $OP_NOT)     (local.get 0) (local.get 1) (local.get 2)))
    (func $shl      (export "shl")     (type $arg3) (call $calc (global.get $OP_SHL)     (local.get 0) (local.get 1) (local.get 2)))
    (func $shr      (export "shr")     (type $arg3) (call $calc (global.get $OP_SHR)     (local.get 0) (local.get 1) (local.get 2)))

    (global $target/userView (mut externref) ref.null extern)
    (global $target/needReset (mut i32) (i32.const 0))
    (global $target/memoryView (mut externref) ref.null extern)
    (global $active_task_offset (mut i32) (i32.const 0))

    (func $import
        (param  $userView externref)
        (param  $sourceView externref)
        (param  $isntTarget i32)
        (result externref)
        
        (local  $memoryView externref)
        (local  $isNotArray i32)
        (local  $hasSrcView i32)
        (local  $byteOffset i32)

        (local.set $isNotArray (i32.eqz (call $self.ArrayBuffer.isView<ref>i32 (local.get $userView))))
        (local.set $hasSrcView (i32.eqz (ref.is_null (local.get $sourceView))))

        (if (local.get $hasSrcView)
            (; target or values checking ;)
            (then
                (if (local.get $isntTarget)
                    (; values view check -- same buffer with zero length of source ;)
                    (then
                        (if (local.get $isNotArray)
                            (then 
                                (local.set $userView 
                                    (call $self.Reflect.apply<refx3>ref 
            (global.get $self.Uint8Array.__proto__.prototype.subarray)
                                        (local.get $sourceView) (call $self.Array.of<i32x2>ref (i32.const 0) (i32.const 0))
                                    )
                                )
                            )
                        )
                    )
                    (; target view check -- no clone needed make it source ;)
                    (else
                        (if (local.get $isNotArray)
                            (then 
                                (local.set $userView (local.get $sourceView))
                            )
                        )
                    )
                )
            )
            (; source is checking ;)
            (else (if (local.get $isNotArray) (then unreachable)))
        )

        (if (call $self.Object.is<ref.ref>i32
                (local.get $userView) (table.get $extern (i32.const 8)) (call $self.Reflect.get<refx2>ref) (global.get $buffer) 
            )
            (then
                (return (local.get $userView))
            )
        )

        (local.set $memoryView
            (call $new
                (local.get $userView) (table.get $extern (i32.const 25)) (call $self.Reflect.get<refx2>ref)                 (local.get $userView) (table.get $extern (i32.const 13)) (call $self.Reflect.get<refx2>i32)             )
        )

        (if (local.get $isntTarget)
            (then
                (call $self.Reflect.apply<refx3> 
            (global.get $self.Uint8Array.__proto__.prototype.set)
                    (local.get $memoryView) 
                    (call $self.Array.of<ref>ref
                        (local.get $userView)
                    )
                )
            )
            (else
                (global.set $target/userView (local.get $userView))
                (global.set $target/needReset (i32.const 1))
                (global.set $target/memoryView (local.get $memoryView))
            )
        )

        (local.get $memoryView)
    )

    (func $is_mixed_space<i32.i32.i32>i32
        (param  $type_space          i32)
        (param  $source_ptr          i32)
        (param  $values_ptr          i32)
        (result i32)

        (if (i32.ne (local.get $type_space) (call $get_array_type<i32>i32 (local.get $source_ptr)))
            (then (return (i32.const 1)))
        )

        (if (local.get $values_ptr)
            (then
                (return (i32.ne (local.get $type_space) (call $get_array_type<i32>i32 (local.get $values_ptr))))
            )
        )

        (return (i32.const 0))
    )

    (func $find_variant_code<i32.i32>i32
        (param  $write_length       i32)
        (param  $read_length        i32)
        (result i32)

        (if (i32.eqz (local.get $read_length))
            (then (return (global.get $VARIANT_0)))
        )

        (if (i32.eq (i32.const 1) (local.get $read_length))
            (then (return (global.get $VARIANT_1)))
        )

        (if (i32.eq (local.get $read_length) (local.get $write_length))
            (then (return (global.get $VARIANT_N)))
        )

        (if (i32.eq (local.get $read_length) (i32.div_u (local.get $write_length) (i32.const 2)))
            (then (return (global.get $VARIANT_H)))
        )

        (if (i32.eq (local.get $read_length) (i32.div_u (local.get $write_length) (i32.const 4)))
            (then (return (global.get $VARIANT_Q)))
        )

        unreachable
    )

    (func $find_func_index<i32.i32.i32.i32.i32>i32
        (param  $opcode               i32)
        (param  $buffer_len           i32)
        (param  $source_ptr           i32)
        (param  $values_ptr           i32)
        (param  $target_ptr           i32)
        (result i32)

        (local  $values_len           i32)
        (local  $type_space           i32)
        (local  $is_mixed_space       i32)
        (local  $variant_code         i32)
        (local  $func_index           i32)

        (local.set $type_space
            (call $get_array_type<i32>i32 (local.get $target_ptr))
        )

        (local.set $is_mixed_space  
            (call $is_mixed_space<i32.i32.i32>i32 
                (local.get $type_space) 
                (local.get $source_ptr)
                (local.get $values_ptr)
            )
        )

        (if (local.get $values_ptr)
            (then
                (local.set $values_len
                    (call $get_used_bytes<i32>i32 
                        (local.get $values_ptr)
                    )
                )

                (local.set $variant_code  
                    (call $find_variant_code<i32.i32>i32 
                        (local.get $buffer_len)
                        (local.get $values_len)
                    )
                )
            )
            (else
                (local.set $variant_code
                    (global.get $VARIANT_0)
                )   
            )
        )

        
        (local.set $func_index
            (call $fni (local.get $opcode) (local.get $type_space) (local.get $variant_code))
        )

        (local.get $func_index)
    )

    (global $isSpawning (mut i32) (i32.const 0))

    (table $task.promise 1 65536 externref)
    (table $task.resolve 65536 externref)
    (table $task.reject 65536 externref)
    (table $task.userView 65536 externref)
    (table $task.memoryView 65536 externref)

    (export "task.promise" (table $task.promise))
    (export "task.resolve" (table $task.resolve))
    (export "task.reject" (table $task.reject))
    (export "task.userView" (table $task.userView))
    (export "task.memoryView" (table $task.memoryView))    

    (global $isProcessing (mut i32) (i32.const 0))

    (func $calc
        (param  $opcode                 i32)
        (param  $source externref )
        (param  $values externref )
        (param  $target externref )
        (result externref )

        (local  $queue_offset           i32)
        (local  $promise externref )
        (local  $resolve externref )
        (local  $reject externref )
        (local  $withResolvers externref )

        (local  $task_index             i32)
        (local  $func_index             i32)
        (local  $source_ptr             i32)
        (local  $values_ptr             i32)
        (local  $target_ptr             i32)
        (local  $buffer_len             i32)


        (local.set $source      (call $import (local.get $source) (ref.null extern) (i32.const 1)))
        (local.set $source_ptr  (local.get $source) (table.get $extern (i32.const 24)) (call $self.Reflect.get<refx2>i32) )

        (if (i32.eqz (ref.is_null (local.get $values)))
            (then
                (local.set $values      (call $import (local.get $values) (local.get $source) (i32.const 1)))
                (local.set $values_ptr  (local.get $values) (table.get $extern (i32.const 24)) (call $self.Reflect.get<refx2>i32) )
            )
        )

        (local.set $target      (call $import (local.get $target) (local.get $source) (i32.const 0)))
        (local.set $target_ptr  (local.get $target) (table.get $extern (i32.const 24)) (call $self.Reflect.get<refx2>i32) )

        (local.set $buffer_len
            (call $get_used_bytes<ref>i32 
                (local.get $target)
            )
        )

        (local.set $func_index
            (call $find_func_index<i32.i32.i32.i32.i32>i32
                (local.get $opcode)
                (local.get $buffer_len)
                (local.get $source_ptr)
                (local.get $values_ptr)
                (local.get $target_ptr)
            )
        )

        (local.set $queue_offset
            (call $new_queue_offset<>i32)
        )

        (local.set $withResolvers 
            (call $self.Reflect.apply<ref.ref.ref>ref
                (global.get $self.Promise.withResolvers)
                (global.get $self.Promise)
                (global.get $wat4wasm/self)
            )
        )

        (local.set $promise  (call $self.Reflect.get<ref.ref>ref (local.get $withResolvers) (table.get $extern (i32.const 26))))
        (local.set $resolve  (call $self.Reflect.get<ref.ref>ref (local.get $withResolvers) (table.get $extern (i32.const 27))))
        (local.set $reject   (call $self.Reflect.get<ref.ref>ref (local.get $withResolvers) (table.get $extern (i32.const 28))))

        (local.set $task_index 
             (table.grow $task.promise (local.get $promise) (i32.const 1))
        )

         (table.set $task.resolve (local.get $task_index) (local.get $resolve))
         (table.set $task.reject  (local.get $task_index) (local.get $reject))

        (if (global.get $target/needReset)
            (then
                 (table.set $task.userView (local.get $task_index) (global.get $target/userView))                
                 (table.set $task.memoryView (local.get $task_index) (global.get $target/memoryView))  
            )
        )

        (call $set_queue_task_index<i32.i32> (local.get $queue_offset) (local.get $task_index))
        (call $set_queue_func_index<i32.i32> (local.get $queue_offset) (local.get $func_index))
        (call $set_queue_buffer_len<i32.i32> (local.get $queue_offset) (local.get $buffer_len))
        (call $set_queue_source_ptr<i32.i32> (local.get $queue_offset) (local.get $source_ptr))
        (call $set_queue_values_ptr<i32.i32> (local.get $queue_offset) (local.get $values_ptr))
        (call $set_queue_target_ptr<i32.i32> (local.get $queue_offset) (local.get $target_ptr))
        (call $set_queue_need_reset<i32.i32> (local.get $queue_offset) (global.get $target/needReset))
        (call $set_queue_task_state<i32.i32> (local.get $queue_offset) (global.get $TASK_STATE_QUEUED))
        (call $process_task_queue)

        (local.get $promise)
    )

    (func $ontaskcomplete<>
        (local $task externref)
        (local $task_index i32)
        (local $queue_offset i32)
        (local $withResolvers externref)

        (call $self.console.warn<ref.i32> (table.get $extern (i32.const 29)) (global.get $active_task_offset))

        (local.set $queue_offset 
            (global.get $active_task_offset)
        )

        (global.set $active_task_offset (i32.const 0))
        
        (local.set $task_index
            (call $get_queue_task_index<i32>i32 
                (local.get $queue_offset)
            )
        )
    
        (if (call $get_queue_need_reset<i32>i32 (local.get $queue_offset))
            (then
                (call $self.Reflect.apply<refx3> 
            (global.get $self.Uint8Array.__proto__.prototype.set)
                     (table.get $task.userView (local.get $task_index))
                    (call $self.Array.of<ref>ref  (table.get $task.memoryView (local.get $task_index)))
                )
            )
        )

        (call $self.Reflect.apply<ref.ref.ref>
             (table.get $task.resolve (local.get $task_index))
             (table.get $task.promise (local.get $task_index))
            (global.get $wat4wasm/self)
        )

        (call $set_queue_task_state<i32.i32>
            (local.get $queue_offset) (global.get $TASK_STATE_COMPLETED)
        )

        (global.set $isProcessing (i32.const 0))
        (call $process_task_queue)
    )

    (func $notify_worker_mutex<i32>i32
        (param $concurrency i32)
        (result i32)

        (call $self.Atomics.notify<ref.i32.i32>i32
            (global.get $i32View) 
            (global.get $INDEX_WORKER_MUTEX)
            (local.get $concurrency)
        )
    )

    (func $new
        (export "new")
        (param  $constructor externref )
        (param  $length              i32)
        (result externref )

        (local  $offset              i32)
        (local  $byteLength          i32)
        (local  $BYTES_PER_ELEMENT   i32)
        (local  $arguments externref )

        (if (i32.eqz
                (local.tee $BYTES_PER_ELEMENT 
                    (local.get $constructor) (table.get $extern (i32.const 30)) (call $self.Reflect.get<refx2>i32)                 )
            )
            (then (local.set $BYTES_PER_ELEMENT (i32.const 1)))
        )
        
        (local.set $byteLength 
            (i32.mul 
                (local.get $length) 
                (local.get $BYTES_PER_ELEMENT)
            )
        )

        (local.set $offset 
            (call $malloc
                (local.get $byteLength)
            )
        )

        (call $set_array_type<i32.i32>
            (local.get $offset) 
            (call $self.Reflect.get<ref.ref>i32
                (local.get $constructor) 
                (call $get_self_symbol<>ref)
            )
        )

        (call $set_item_count<i32.i32>
            (local.get $offset) 
            (local.get $length)
        )

        (local.set $arguments 
            (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Array)  (call $self.Array.of<>ref))
        )

        (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:push) (local.get $arguments) (call $self.Array.of<ref>ref (call $get_buffer<>ref)))
        (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:push) (local.get $arguments) (call $self.Array.of<i32>ref (local.get $offset)))
        (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:push) (local.get $arguments) (call $self.Array.of<i32>ref (local.get $length)))

        (call $self.Reflect.construct<ref.ref>ref
            (local.get $constructor)
            (local.get $arguments)
        )
    )

    
	(; externref  ;)
	(func $process_task_queue
    (local  $queue_offset      i32)

    (local  $source_ptr           i32)
    (local  $values_ptr           i32)
    (local  $target_ptr           i32)
    (local  $buffer_len           i32)

    (local  $func_index           i32)
    (local  $concurrency          i32)
    (local  $current_threads      i32)
    (local  $needed_threads       i32)

    (if (global.get $isProcessing) (then (return)))

    (if (i32.eqz (local.tee $queue_offset (call $next_queued_task<>i32)))
        (then
            (global.set $isProcessing (i32.const 0))
            (call $schedule_close_task<>)
            (return)
        )
    )
    
    (global.set $isProcessing (i32.const 1))

    (call $abort_scheduled_task<>)
    (call $reset_locked_workers<>)
    (call $create_wait_async<>)

    (call $set_func_index<i32> (call $get_queue_func_index<i32>i32 (local.get $queue_offset)))
    (call $set_buffer_len<i32> (call $get_queue_buffer_len<i32>i32 (local.get $queue_offset)))
    (call $set_source_ptr<i32> (call $get_queue_source_ptr<i32>i32 (local.get $queue_offset)))
    (call $set_values_ptr<i32> (call $get_queue_values_ptr<i32>i32 (local.get $queue_offset)))
    (call $set_target_ptr<i32> (call $get_queue_target_ptr<i32>i32 (local.get $queue_offset)))

    (global.set $active_task_offset 
        (local.get $queue_offset)
    )

    (local.set $concurrency
        (call $get_worker_count<>i32)
    )

    ;; Notify existing workers to wake up
    (call $notify_worker_mutex<i32>i32
        (local.get $concurrency)
    )            

    (drop)

    ;; Check if we need to spawn more workers
    (local.set $current_threads
        (i32.atomic.load (global.get $OFFSET_MAXLENGTH))
    )

    (call $self.console.log<i32.i32>
        (local.get $concurrency)
        (local.get $current_threads)
    )

    (if (i32.lt_u (local.get $current_threads) (local.get $concurrency))
        (then
            (local.set $needed_threads
                (i32.sub (local.get $concurrency) (local.get $current_threads))
            )
            
            

            (call $create_worker_threads<i32> (local.get $needed_threads))
        )
    )
)

(func $create_worker_threads<i32>
    (param $workerCount          i32)
    (local $worker externref )

    ;; No global flag needed anymore as we check the count before calling
    
    (loop $fork
        (if (local.get $workerCount)
            (then
                (local.set $worker
                    (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Worker) 
            (call $self.Array.of<ref.ref>ref 
                        (call $get_worker_url<>ref)
                        (call $get_worker_config<>ref)
                    ))
                )

                (call $self.Reflect.apply<refx3> 
            (global.get $self.Worker:postMessage)
                    (local.get $worker) (call $self.Array.of<ref>ref (call $get_worker_data<>ref ))
                )

                (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:push)
                    (global.get $worker.threads) (call $self.Array.of<ref>ref (local.get $worker))
                )
                
                (i32.atomic.rmw.add (global.get $OFFSET_MAXLENGTH) (i32.const 1))
                (drop)

                (local.set $workerCount (i32.sub (local.get $workerCount) (i32.const 1)))
                (br $fork)
            )
        )
    )        
)
    
	(; externref  ;)
	(func $process_task_queue_ozgur
    (local  $queue_offset      i32)

    (local  $source_ptr           i32)
    (local  $values_ptr           i32)
    (local  $target_ptr           i32)
    (local  $buffer_len           i32)

    (local  $func_index           i32)
    (local  $fork_count           i32)
    (local  $concurrency          i32)
    (local  $task externref )

    (if (i32.eqz (local.tee $queue_offset (call $next_queued_task<>i32)))
        (then
            (global.set $isProcessing (i32.const 0))
            (call $schedule_close_task<>)
            (return)
        )
    )
    
    (global.set $isProcessing (i32.const 1))

    (call $abort_scheduled_task<>)
    (call $reset_locked_workers<>)
    (call $create_wait_async<>)

    (call $set_func_index<i32> (call $get_queue_func_index<i32>i32 (local.get $queue_offset)))
    (call $set_buffer_len<i32> (call $get_queue_buffer_len<i32>i32 (local.get $queue_offset)))
    (call $set_source_ptr<i32> (call $get_queue_source_ptr<i32>i32 (local.get $queue_offset)))
    (call $set_values_ptr<i32> (call $get_queue_values_ptr<i32>i32 (local.get $queue_offset)))
    (call $set_target_ptr<i32> (call $get_queue_target_ptr<i32>i32 (local.get $queue_offset)))

    (global.set $active_task_offset 
        (local.get $queue_offset)
    )

    (local.set $concurrency
        (call $get_worker_count<>i32)
    )

    (local.set $fork_count
        (call $notify_worker_mutex<i32>i32
            (local.get $concurrency)
        )            
    )

    (if (i32.lt_u 
            (local.get $fork_count) 
            (local.get $concurrency)
        ) 
        (then
            (if (i32.eqz (global.get $isSpawning))
                (then 
                    (call $self.console.log<i32.i32.i32>
                        (local.get $concurrency)
                        (local.get $fork_count)
                        (call $get_active_workers<>i32)
                    )

                    (call $create_worker_threads<i32>
                        (i32.sub
                            (local.get $concurrency)
                            (local.get $fork_count)
                        )
                    )
                )
            )
        )
    )
)

(func $create_worker_threads_ozgur
    (param $workerCount          i32)
    (local $worker externref )

    (global.set $isSpawning (i32.const 1))

    (loop $fork
        (local.set $worker
            (call $self.Reflect.construct<refx2>ref 
            (global.get $self.Worker) 
            (call $self.Array.of<ref.ref>ref 
                (call $get_worker_url<>ref)
                (call $get_worker_config<>ref)
            ))
        )

        (call $self.Reflect.apply<refx3> 
            (global.get $self.Worker:postMessage)
            (local.get $worker) (call $self.Array.of<ref>ref (call $get_worker_data<>ref ))
        )

        (call $self.Reflect.apply<refx3> 
            (global.get $self.Array:push)
            (global.get $worker.threads) (call $self.Array.of<ref>ref (local.get $worker))
        )

        (br_if $fork (local.tee $workerCount (local.get $workerCount) (i32.const 1) (i32.sub)))
    )        
)

    (global $kSymbol.tag (mut externref) ref.null extern)
    (global $worker.code (mut externref) ref.null extern)

    (global $DEFAULT_MEMORY_INITIAL  i32 (i32.const 65535))
    (global $DEFAULT_MEMORY_MAXIMUM  i32 (i32.const 65535))
    (global $DEFAULT_MEMORY_SHARED         i32 (i32.const 1))

    (global $MAX_TASK_COUNT                      i32 (i32.const 1000))
    (global $BYTES_PER_TASK                        i32 (i32.const 32))

    (global $OFFSET_QUEUED_TASK_COUNT              i32 (i32.const 16))
    (global $OFFSET_COMPLETED_TASK_COUNT           i32 (i32.const 20))
    (global $OFFSET_TASK_HEADERS_START             i32 (i32.const 64))
    (global $OFFSET_TASK_HEADERS_END            i32 (i32.const 32064))

    (global $OFFSET_QUEUED_TASK_TASK_STATE          i32 (i32.const 0))
    (global $OFFSET_QUEUED_TASK_TASK_INDEX          i32 (i32.const 4))
    (global $OFFSET_QUEUED_TASK_FUNC_INDEX          i32 (i32.const 8))
    (global $OFFSET_QUEUED_TASK_BUFFER_LEN         i32 (i32.const 12))
    (global $OFFSET_QUEUED_TASK_SOURCE_PTR         i32 (i32.const 16))
    (global $OFFSET_QUEUED_TASK_VALUES_PTR         i32 (i32.const 20))
    (global $OFFSET_QUEUED_TASK_TARGET_PTR         i32 (i32.const 24))
    (global $OFFSET_QUEUED_TASK_NEED_RESET         i32 (i32.const 28))

    (func $get_queue_task_state<i32>i32 (param $offset i32) (result i32) (i32.load   offset=0 (local.get 0)))
    (func $get_queue_task_index<i32>i32 (param $offset i32) (result i32) (i32.load   offset=4 (local.get 0)))
    (func $get_queue_func_index<i32>i32 (param $offset i32) (result i32) (i32.load   offset=8 (local.get 0)))
    (func $get_queue_buffer_len<i32>i32 (param $offset i32) (result i32) (i32.load  offset=12 (local.get 0)))
    (func $get_queue_source_ptr<i32>i32 (param $offset i32) (result i32) (i32.load  offset=16 (local.get 0)))
    (func $get_queue_values_ptr<i32>i32 (param $offset i32) (result i32) (i32.load  offset=20 (local.get 0)))
    (func $get_queue_target_ptr<i32>i32 (param $offset i32) (result i32) (i32.load  offset=24 (local.get 0)))
    (func $get_queue_need_reset<i32>i32 (param $offset i32) (result i32) (i32.load  offset=28 (local.get 0)))

    (func $set_queue_task_state<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=0 (local.get 0) (local.get 1)))
    (func $set_queue_task_index<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=4 (local.get 0) (local.get 1)))
    (func $set_queue_func_index<i32.i32> (param $offset i32) (param $value i32) (i32.store  offset=8 (local.get 0) (local.get 1)))
    (func $set_queue_buffer_len<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=12 (local.get 0) (local.get 1)))
    (func $set_queue_source_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=16 (local.get 0) (local.get 1)))
    (func $set_queue_values_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=20 (local.get 0) (local.get 1)))
    (func $set_queue_target_ptr<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=24 (local.get 0) (local.get 1)))
    (func $set_queue_need_reset<i32.i32> (param $offset i32) (param $value i32) (i32.store offset=28 (local.get 0) (local.get 1)))

    (global $TASK_STATE_CLOSED           i32 (i32.const 0))
    (global $TASK_STATE_RESERVED         i32 (i32.const 1))
    (global $TASK_STATE_QUEUED           i32 (i32.const 2))
    (global $TASK_STATE_PROCESSING       i32 (i32.const 3))
    (global $TASK_STATE_COMPLETED        i32 (i32.const 4))

    (func $get_queue_count<>i32
        (result i32)
        (local  $offset i32)
        (local  $count i32)

        (local.set $offset 
            (global.get $OFFSET_TASK_HEADERS_START)
        )

        (loop $next_task_offset
            (if (i32.atomic.load (local.get $offset))
                (then (local.set $count (local.get $count) (i32.const 1) (i32.add)))
            )

            (local.set $offset 
                (i32.add (local.get $offset) 
                    (global.get $BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u (local.get $offset)
                    (global.get $OFFSET_TASK_HEADERS_END)
                )
            )
        )

        (local.get $count)
    )

    (func $next_queued_task<>i32
        (result i32)
        (local  $offset i32)

        (local.set $offset 
            (global.get $OFFSET_TASK_HEADERS_START)
        )

        (loop $next_task_offset
            (if (i32.eq (global.get $TASK_STATE_QUEUED)
                    (i32.atomic.rmw.cmpxchg (local.get $offset)
                        (global.get $TASK_STATE_QUEUED)
                        (global.get $TASK_STATE_PROCESSING)
                    )
                )
                (then (return (local.get $offset)))
            )

            (local.set $offset 
                (i32.add (local.get $offset) 
                    (global.get $BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u (local.get $offset)
                    (global.get $OFFSET_TASK_HEADERS_END)
                )
            )
        )

        (i32.const 0)
    )

    (func $new_queue_offset<>i32
        (result i32)
        (local  $offset i32)
        
        (local.set $offset 
            (global.get $OFFSET_TASK_HEADERS_START)
        )
        
        (loop $next_task_offset
            (if (i32.eq (global.get $TASK_STATE_CLOSED)
                    (i32.atomic.rmw.cmpxchg (local.get $offset)
                        (global.get $TASK_STATE_CLOSED)
                        (global.get $TASK_STATE_RESERVED)
                    )
                )
                (then (return (local.get $offset)))
            )

            (local.set $offset 
                (i32.add (local.get $offset) 
                    (global.get $BYTES_PER_TASK)
                )
            )

            (br_if $next_task_offset
                (i32.lt_u (local.get $offset)
                    (global.get $OFFSET_TASK_HEADERS_END)
                )
            )
        )

        (unreachable)
        ;; loop all again but (local.get 0) time mark completed tasks as closed 
    )

    (global $sigint                         (mut i32) (i32.const 0))
    (global $module                      (mut externref) ref.null extern)
    (global $memory                      (mut externref) ref.null extern)
    (global $buffer                      (mut externref) ref.null extern)

    (global $i32View                     (mut externref) ref.null extern)
    (global $dataView                    (mut externref) ref.null extern)
    (global $kSymbol                     (mut externref) ref.null extern)

    (global $worker.URL                  (mut externref) ref.null extern)
    (global $worker.data                 (mut externref) ref.null extern)
    (global $worker.config               (mut externref) ref.null extern)

    (global $worker.threads (mut externref) (ref.null extern))
    (global $abortController             (mut externref) ref.null extern)
    (global $postTask.arguments          (mut externref) ref.null extern)
    (global $postTask.options            (mut externref) ref.null extern)
    (global $postTask.delay                 (mut i32) (i32.const 0))
    (global $postTask.isScheduled           (mut i32) (i32.const 0))

    (global $taskQueue (mut externref) (ref.null extern))

    (global $promise                     (mut externref) ref.null extern)
    (global $promise.arguments           (mut externref) ref.null extern)
    (global $promise.resolve             (mut externref) ref.null extern)
    (global $promise.reject              (mut externref) ref.null extern)
    (global $promise.isPromised             (mut i32) (i32.const 0))
    (global $promise.isResolved             (mut i32) (i32.const 0))
    (global $promise.isRejected             (mut i32) (i32.const 0))

    (global $self.DataView (mut externref) ref.null extern)
    (global $self.Uint8Array (mut externref) ref.null extern)
    (global $self.Uint16Array (mut externref) ref.null extern)
    (global $self.Uint32Array (mut externref) ref.null extern)
    (global $self.Float32Array (mut externref) ref.null extern)
    
    (global $self.navigator.deviceMemory (mut i32) (i32.const 0))
    (global $self.navigator.hardwareConcurrency (mut i32) (i32.const 0))

    (global $self.scheduler (mut externref) ref.null extern)
    (global $self.Scheduler:postTask (mut externref) ref.null extern)
    (global $self.AbortController (mut externref) ref.null extern)
    (global $self.AbortController:abort (mut externref) ref.null extern)
    (global $self.AbortController:signal/get (mut externref) ref.null extern)
    (global $self.AbortSignal:onabort/set (mut externref) ref.null extern)

    (global $self.Promise (mut externref) ref.null extern)
    (global $self.Promise.withResolvers (mut externref) ref.null extern)

    (func $this (export "this"))

    (func (export "dump")
        (result externref )
        (local $variables externref )

        (local.set $variables (call $self.Reflect.apply<refx3>ref 
            (global.get $self.Object) (global.get $wat4wasm/self) (call $self.Array.of<>ref)))

        (call $self.Reflect.set<ref.ref.i32> (local.get $variables) (table.get $extern (i32.const 31))   (call $get_worker_count<>i32))
        (call $self.Reflect.set<ref.ref.i32> (local.get $variables) (table.get $extern (i32.const 32)) (call $get_active_workers<>i32))
        (call $self.Reflect.set<ref.ref.i32> (local.get $variables) (table.get $extern (i32.const 33)) (call $get_locked_workers<>i32))
        (call $self.Reflect.set<ref.ref.i32> (local.get $variables) (table.get $extern (i32.const 34)) (call $get_notifier_index<>i32))

        (local.get $variables)
    )

    (func $create 
        (param $workerCount i32)

        (if (i32.eqz (local.get $workerCount))
            (then (local.set $workerCount (global.get $self.navigator.hardwareConcurrency)))
        )

        (call $define_self_symbols<>)
        (call $create_memory_links<>)
        
        (call $reset_memory_values<i32> (local.get $workerCount))    
        (call $create_task_scheduler<>)
    )

    (func $create_wait_async<>
        (local $waitAsync externref )
        (local $promise externref )
        (local $isAsync               i32)

        (call $self.console.log<ref> (table.get $extern (i32.const 35)))

        (local.set $waitAsync
            (call $self.Atomics.waitAsync<ref.i32.i32>ref
                (global.get $i32View) 
                (global.get $INDEX_WINDOW_MUTEX) 
                (i32.const 0)
            )
        )

        (local.set $isAsync
            (call $self.Reflect.get<ref.ref>i32
                (local.get $waitAsync) (table.get $extern (i32.const 36))
            )
        )

        (if (i32.eqz (local.get $isAsync))
            (then
                (call $self.console.error<ref.ref> (table.get $extern (i32.const 37)) (local.get $waitAsync))
                (unreachable)
            )
        )

        (local.set $promise
            (call $self.Reflect.get<ref.ref>ref
                (local.get $waitAsync) (table.get $extern (i32.const 14))
            )
        )

        (call $self.Reflect.apply<refx3> 
            (global.get $self.Promise.prototype.then)
            (local.get $promise) (call $self.Array.of<fun>ref (ref.func $ontaskcomplete<>))
        )
    )

    (func $destroy 
        (call $delete_self_symbols<>)
        (call $terminate_all_workers<>)
        (call $remove_extern_globals<>)
    )
    
    (func $remove_extern_globals<>
        (global.set $i32View        (ref.null extern))
        (global.set $dataView       (ref.null extern))
        (global.set $buffer         (ref.null extern))    
        (global.set $memory         (ref.null extern))
        (global.set $module         (ref.null extern))
        (global.set $worker.URL     (ref.null extern))
        (global.set $worker.data    (ref.null extern))
        (global.set $worker.config  (ref.null extern))
        (global.set $kSymbol        (ref.null extern))
    )

    (start $init) (func $init
(table.set $extern (i32.const 1) (call $wat4wasm/text (i32.const 0) (i32.const 4)))
		(table.set $extern (i32.const 2) (call $wat4wasm/text (i32.const 4) (i32.const 24)))
		(table.set $extern (i32.const 3) (call $wat4wasm/text (i32.const 28) (i32.const 16)))
		(table.set $extern (i32.const 4) (call $wat4wasm/text (i32.const 44) (i32.const 12)))
		(table.set $extern (i32.const 5) (call $wat4wasm/text (i32.const 56) (i32.const 28)))
		(table.set $extern (i32.const 6) (call $wat4wasm/text (i32.const 84) (i32.const 28)))
		(table.set $extern (i32.const 7) (call $wat4wasm/text (i32.const 112) (i32.const 24)))
		(table.set $extern (i32.const 8) (call $wat4wasm/text (i32.const 136) (i32.const 24)))
		(table.set $extern (i32.const 9) (call $wat4wasm/text (i32.const 160) (i32.const 28)))
		(table.set $extern (i32.const 10) (call $wat4wasm/text (i32.const 188) (i32.const 28)))
		(table.set $extern (i32.const 11) (call $wat4wasm/text (i32.const 216) (i32.const 24)))
		(table.set $extern (i32.const 12) (call $wat4wasm/text (i32.const 240) (i32.const 24)))
		(table.set $extern (i32.const 13) (call $wat4wasm/text (i32.const 264) (i32.const 24)))
		(table.set $extern (i32.const 14) (call $wat4wasm/text (i32.const 288) (i32.const 20)))
		(table.set $extern (i32.const 15) (call $wat4wasm/text (i32.const 308) (i32.const 48)))
		(table.set $extern (i32.const 16) (call $wat4wasm/text (i32.const 356) (i32.const 40)))
		(table.set $extern (i32.const 17) (call $wat4wasm/text (i32.const 396) (i32.const 96)))
		(table.set $extern (i32.const 18) (call $wat4wasm/text (i32.const 492) (i32.const 104)))
		(table.set $extern (i32.const 19) (call $wat4wasm/text (i32.const 596) (i32.const 140)))
		(table.set $extern (i32.const 20) (call $wat4wasm/text (i32.const 736) (i32.const 20)))
		(table.set $extern (i32.const 21) (call $wat4wasm/text (i32.const 756) (i32.const 120)))
		(table.set $extern (i32.const 22) (call $wat4wasm/text (i32.const 876) (i32.const 24)))
		(table.set $extern (i32.const 23) (call $wat4wasm/text (i32.const 900) (i32.const 108)))
		(table.set $extern (i32.const 24) (call $wat4wasm/text (i32.const 1008) (i32.const 40)))
		(table.set $extern (i32.const 25) (call $wat4wasm/text (i32.const 1048) (i32.const 44)))
		(table.set $extern (i32.const 26) (call $wat4wasm/text (i32.const 1092) (i32.const 28)))
		(table.set $extern (i32.const 27) (call $wat4wasm/text (i32.const 1120) (i32.const 28)))
		(table.set $extern (i32.const 28) (call $wat4wasm/text (i32.const 1148) (i32.const 24)))
		(table.set $extern (i32.const 29) (call $wat4wasm/text (i32.const 1172) (i32.const 56)))
		(table.set $extern (i32.const 30) (call $wat4wasm/text (i32.const 1228) (i32.const 68)))
		(table.set $extern (i32.const 31) (call $wat4wasm/text (i32.const 1296) (i32.const 48)))
		(table.set $extern (i32.const 32) (call $wat4wasm/text (i32.const 1344) (i32.const 56)))
		(table.set $extern (i32.const 33) (call $wat4wasm/text (i32.const 1400) (i32.const 56)))
		(table.set $extern (i32.const 34) (call $wat4wasm/text (i32.const 1456) (i32.const 56)))
		(table.set $extern (i32.const 35) (call $wat4wasm/text (i32.const 1512) (i32.const 96)))
		(table.set $extern (i32.const 36) (call $wat4wasm/text (i32.const 1608) (i32.const 20)))
		(table.set $extern (i32.const 37) (call $wat4wasm/text (i32.const 1628) (i32.const 108)))
		(table.set $extern (i32.const 38) (call $wat4wasm/text (i32.const 1736) (i32.const 16)))
		(table.set $extern (i32.const 39) (call $wat4wasm/text (i32.const 1752) (i32.const 20)))
		(table.set $extern (i32.const 40) (call $wat4wasm/text (i32.const 1772) (i32.const 32)))
		(table.set $extern (i32.const 41) (call $wat4wasm/text (i32.const 1804) (i32.const 40)))
		(table.set $extern (i32.const 42) (call $wat4wasm/text (i32.const 1844) (i32.const 44)))
		(table.set $extern (i32.const 43) (call $wat4wasm/text (i32.const 1888) (i32.const 44)))
		(table.set $extern (i32.const 44) (call $wat4wasm/text (i32.const 1932) (i32.const 48)))
		(table.set $extern (i32.const 45) (call $wat4wasm/text (i32.const 1980) (i32.const 36)))
		(table.set $extern (i32.const 46) (call $wat4wasm/text (i32.const 2016) (i32.const 48)))
		(table.set $extern (i32.const 47) (call $wat4wasm/text (i32.const 2064) (i32.const 76)))
		(table.set $extern (i32.const 48) (call $wat4wasm/text (i32.const 2140) (i32.const 36)))
		(table.set $extern (i32.const 49) (call $wat4wasm/text (i32.const 2176) (i32.const 36)))
		(table.set $extern (i32.const 50) (call $wat4wasm/text (i32.const 2212) (i32.const 36)))
		(table.set $extern (i32.const 51) (call $wat4wasm/text (i32.const 2248) (i32.const 32)))
		(table.set $extern (i32.const 52) (call $wat4wasm/text (i32.const 2280) (i32.const 60)))
		(table.set $extern (i32.const 53) (call $wat4wasm/text (i32.const 2340) (i32.const 20)))
		(table.set $extern (i32.const 54) (call $wat4wasm/text (i32.const 2360) (i32.const 12)))
		(table.set $extern (i32.const 55) (call $wat4wasm/text (i32.const 2372) (i32.const 44)))
		(table.set $extern (i32.const 56) (call $wat4wasm/text (i32.const 2416) (i32.const 28)))
		(table.set $extern (i32.const 57) (call $wat4wasm/text (i32.const 2444) (i32.const 12)))
		(table.set $extern (i32.const 58) (call $wat4wasm/text (i32.const 2456) (i32.const 28)))
		(table.set $extern (i32.const 59) (call $wat4wasm/text (i32.const 2484) (i32.const 52)))
		(table.set $extern (i32.const 60) (call $wat4wasm/text (i32.const 2536) (i32.const 48)))
		(table.set $extern (i32.const 61) (call $wat4wasm/text (i32.const 2584) (i32.const 16)))
		(table.set $extern (i32.const 62) (call $wat4wasm/text (i32.const 2600) (i32.const 16)))
		(table.set $extern (i32.const 63) (call $wat4wasm/text (i32.const 2616) (i32.const 44)))
		(table.set $extern (i32.const 64) (call $wat4wasm/text (i32.const 2660) (i32.const 24)))
		(table.set $extern (i32.const 65) (call $wat4wasm/text (i32.const 2684) (i32.const 40)))
		(table.set $extern (i32.const 66) (call $wat4wasm/text (i32.const 2724) (i32.const 24)))
		(table.set $extern (i32.const 67) (call $wat4wasm/text (i32.const 2748) (i32.const 24)))
		(table.set $extern (i32.const 68) (call $wat4wasm/text (i32.const 2772) (i32.const 8)))
		(table.set $extern (i32.const 69) (call $wat4wasm/text (i32.const 2780) (i32.const 36)))
		(table.set $extern (i32.const 70) (call $wat4wasm/text (i32.const 2816) (i32.const 24)))
		(table.set $extern (i32.const 71) (call $wat4wasm/text (i32.const 2840) (i32.const 20)))
		(table.set $extern (i32.const 72) (call $wat4wasm/text (i32.const 2860) (i32.const 36)))
		(table.set $extern (i32.const 73) (call $wat4wasm/text (i32.const 2896) (i32.const 36)))
		(table.set $extern (i32.const 74) (call $wat4wasm/text (i32.const 2932) (i32.const 36)))
		(table.set $extern (i32.const 75) (call $wat4wasm/text (i32.const 2968) (i32.const 32)))
		(table.set $extern (i32.const 76) (call $wat4wasm/text (i32.const 3000) (i32.const 16)))
		(table.set $extern (i32.const 77) (call $wat4wasm/text (i32.const 3016) (i32.const 44)))
		(table.set $extern (i32.const 78) (call $wat4wasm/text (i32.const 3060) (i32.const 16)))
		(table.set $extern (i32.const 79) (call $wat4wasm/text (i32.const 3076) (i32.const 40)))
		(table.set $extern (i32.const 80) (call $wat4wasm/text (i32.const 3116) (i32.const 300)))

(global.set $kSymbol.tag (table.get $extern (i32.const 79)))(global.set $worker.code (table.get $extern (i32.const 80)))


        (global.set $worker.threads
            (call $wat4wasm/Reflect.construct<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 38)) 
                    ) (table.get $extern (i32.const 39)) 
                )
                (global.get $wat4wasm/self) 
            )
        )
        
        (global.set $taskQueue
            (call $wat4wasm/Reflect.construct<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 38)) 
                    ) (table.get $extern (i32.const 39)) 
                )
                (global.get $wat4wasm/self) 
            )
        )
        
        (global.set $self.DataView
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 40)) 
            )
        )
        
        (global.set $self.Uint8Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 41)) 
            )
        )
        
        (global.set $self.Uint16Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 42)) 
            )
        )
        
        (global.set $self.Uint32Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 43)) 
            )
        )
        
        (global.set $self.Float32Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 44)) 
            )
        )
        
        (global.set $self.navigator.deviceMemory
            (call $wat4wasm/Reflect.get<refx2>i32
                (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 45)) 
                    )
                (table.get $extern (i32.const 46)) 
            )
        )
        
        (global.set $self.navigator.hardwareConcurrency
            (call $wat4wasm/Reflect.get<refx2>i32
                (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 45)) 
                    )
                (table.get $extern (i32.const 47)) 
            )
        )
        
        (global.set $self.scheduler
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 48)) 
            )
        )
        
        (global.set $self.Scheduler:postTask
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 49)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 51)) 
            )
        )
        
        (global.set $self.AbortController
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 52)) 
            )
        )
        
        (global.set $self.AbortController:abort
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 52)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 53)) 
            )
        )
        
        (global.set $self.AbortController:signal/get
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.getOwnPropertyDescriptor<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 52)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                    (table.get $extern (i32.const 22)) 
                )
                (table.get $extern (i32.const 54)) 
            )
        )
        
        (global.set $self.AbortSignal:onabort/set
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.getOwnPropertyDescriptor<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 55)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                    (table.get $extern (i32.const 56)) 
                )
                (table.get $extern (i32.const 57)) 
            )
        )
        
        (global.set $self.Promise
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 58)) 
            )
        )
        
        (global.set $self.Promise.withResolvers
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 58)) 
                    )
                (table.get $extern (i32.const 59)) 
            )
        )
        
        (global.set $self.MessageEvent.prototype.data/get
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.getOwnPropertyDescriptor<refx2>ref
                    (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 60)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                    (table.get $extern (i32.const 61)) 
                )
                (table.get $extern (i32.const 54)) 
            )
        )
        
        (global.set $self.Blob
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 62)) 
            )
        )
        
        (global.set $self.WebAssembly.Memory
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 63)) 
                    )
                (table.get $extern (i32.const 64)) 
            )
        )
        
        (global.set $self.Int32Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 65)) 
            )
        )
        
        (global.set $self.Object
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 66)) 
            )
        )
        
        (global.set $self.Array
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 39)) 
            )
        )
        
        (global.set $self.Worker
            (call $wat4wasm/Reflect.get<refx2>ref
                (global.get $wat4wasm/self)
                (table.get $extern (i32.const 67)) 
            )
        )
        
        (global.set $self.Array:at
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 39)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 68)) 
            )
        )
        
        (global.set $self.Worker:terminate
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 67)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 69)) 
            )
        )
        
        (global.set $self.Array:splice
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 39)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 70)) 
            )
        )
        
        (global.set $self.Promise.prototype
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                        (global.get $wat4wasm/self) 
                        (table.get $extern (i32.const 58)) 
                    )
                (table.get $extern (i32.const 50)) 
            )
        )
        
        (global.set $self.Promise.prototype.catch
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 58)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 71)) 
            )
        )
        
        (global.set $self.DataView:setUint32
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 40)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 72)) 
            )
        )
        
        (global.set $self.DataView:getUint32
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 40)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 73)) 
            )
        )
        
        (global.set $self.Uint8Array.__proto__.prototype
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 41)) 
                            ) 
                            (table.get $extern (i32.const 74)) 
                        )
                (table.get $extern (i32.const 50)) 
            )
        )
        
        (global.set $self.Uint8Array.__proto__.prototype.subarray
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                                (call $wat4wasm/Reflect.get<refx2>ref 
                                        (call $wat4wasm/Reflect.get<refx2>ref 
                                            (global.get $wat4wasm/self) 
                                            (table.get $extern (i32.const 41)) 
                                        ) 
                                        (table.get $extern (i32.const 74)) 
                                    ) 
                                (table.get $extern (i32.const 50)) 
                            )
                (table.get $extern (i32.const 75)) 
            )
        )
        
        (global.set $self.Uint8Array.__proto__.prototype.set
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                                (call $wat4wasm/Reflect.get<refx2>ref 
                                        (call $wat4wasm/Reflect.get<refx2>ref 
                                            (global.get $wat4wasm/self) 
                                            (table.get $extern (i32.const 41)) 
                                        ) 
                                        (table.get $extern (i32.const 74)) 
                                    ) 
                                (table.get $extern (i32.const 50)) 
                            )
                (table.get $extern (i32.const 57)) 
            )
        )
        
        (global.set $self.Array:push
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 39)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 76)) 
            )
        )
        
        (global.set $self.Worker:postMessage
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 67)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 77)) 
            )
        )
        
        (global.set $self.Promise.prototype.then
            (call $wat4wasm/Reflect.get<refx2>ref
                (call $wat4wasm/Reflect.get<refx2>ref 
                            (call $wat4wasm/Reflect.get<refx2>ref 
                                (global.get $wat4wasm/self) 
                                (table.get $extern (i32.const 58)) 
                            ) 
                            (table.get $extern (i32.const 50)) 
                        )
                (table.get $extern (i32.const 78)) 
            )
        )
        
  (call $create (i32.const 0)))

	(global $self.MessageEvent.prototype.data/get (mut externref) ref.null extern)


	(global $self.Blob (mut externref) ref.null extern)
	(global $self.WebAssembly.Memory (mut externref) ref.null extern)
	(global $self.Int32Array (mut externref) ref.null extern)
	(global $self.Object (mut externref) ref.null extern)
	(global $self.Array (mut externref) ref.null extern)
	(global $self.Worker (mut externref) ref.null extern)

	(global $self.Array:at (mut externref) ref.null extern)
	(global $self.Worker:terminate (mut externref) ref.null extern)
	(global $self.Array:splice (mut externref) ref.null extern)
	(global $self.Promise.prototype (mut externref) ref.null extern)
	(global $self.Promise.prototype.catch (mut externref) ref.null extern)
	(global $self.DataView:setUint32 (mut externref) ref.null extern)
	(global $self.DataView:getUint32 (mut externref) ref.null extern)
	(global $self.Uint8Array.__proto__.prototype (mut externref) ref.null extern)
	(global $self.Uint8Array.__proto__.prototype.subarray (mut externref) ref.null extern)
	(global $self.Uint8Array.__proto__.prototype.set (mut externref) ref.null extern)
	(global $self.Array:push (mut externref) ref.null extern)
	(global $self.Worker:postMessage (mut externref) ref.null extern)
	(global $self.Promise.prototype.then (mut externref) ref.null extern)

	(elem $wat4wasm/refs funcref (ref.func $this) (ref.func $create) (ref.func $destroy) (ref.func $malloc) (ref.func $void) (ref.func $onscheduledclose<>) (ref.func $create_abort_controller<>) (ref.func $ontaskcomplete<>))

    (table $extern 81 81 externref)

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
                
            (memory.init $wat4wasm/text
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

    (data $wat4wasm/text "\00\00\10\42\00\00\da\42\00\00\ca\42\00\00\da\42\00\00\de\42\00\00\e4\42\00\00\f2\42\00\00\dc\42\00\00\c2\42\00\00\da\42\00\00\ca\42\00\00\c6\42\00\00\e0\42\00\00\ea\42\00\00\d2\42\00\00\dc\42\00\00\d2\42\00\00\e8\42\00\00\d2\42\00\00\c2\42\00\00\d8\42\00\00\da\42\00\00\c2\42\00\00\f0\42\00\00\d2\42\00\00\da\42\00\00\ea\42\00\00\da\42\00\00\e6\42\00\00\d0\42\00\00\c2\42\00\00\e4\42\00\00\ca\42\00\00\c8\42\00\00\c4\42\00\00\ea\42\00\00\cc\42\00\00\cc\42\00\00\ca\42\00\00\e4\42\00\00\c8\42\00\00\ca\42\00\00\e6\42\00\00\e8\42\00\00\e4\42\00\00\de\42\00\00\f2\42\00\00\e8\42\00\00\d0\42\00\00\e4\42\00\00\ca\42\00\00\c2\42\00\00\c8\42\00\00\e6\42\00\00\c6\42\00\00\e4\42\00\00\ca\42\00\00\c2\42\00\00\e8\42\00\00\ca\42\00\00\da\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\de\42\00\00\c6\42\00\00\d8\42\00\00\ca\42\00\00\dc\42\00\00\ce\42\00\00\e8\42\00\00\d0\42\00\00\ec\42\00\00\c2\42\00\00\d8\42\00\00\ea\42\00\00\ca\42\00\00\c6\42\00\00\de\42\00\00\dc\42\00\00\cc\42\00\00\d2\42\00\00\ce\42\00\00\ea\42\00\00\e4\42\00\00\c2\42\00\00\c4\42\00\00\d8\42\00\00\ca\42\00\00\ca\42\00\00\dc\42\00\00\ea\42\00\00\da\42\00\00\ca\42\00\00\e4\42\00\00\c2\42\00\00\c4\42\00\00\d8\42\00\00\ca\42\00\00\de\42\00\00\dc\42\00\00\00\42\00\00\e6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\c6\42\00\00\d8\42\00\00\de\42\00\00\e6\42\00\00\ca\42\00\00\00\42\00\00\c6\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\e6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\00\42\00\00\c6\42\00\00\d8\42\00\00\de\42\00\00\e6\42\00\00\ca\42\00\00\00\42\00\00\e8\42\00\00\c2\42\00\00\e6\42\00\00\d6\42\00\00\00\42\00\00\c6\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\c6\42\00\00\e4\42\00\00\ca\42\00\00\c2\42\00\00\e8\42\00\00\d2\42\00\00\dc\42\00\00\ce\42\00\00\00\42\00\00\e8\42\00\00\c2\42\00\00\e6\42\00\00\d6\42\00\00\00\42\00\00\e6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\e4\42\00\00\00\42\00\00\20\42\00\00\de\42\00\00\dc\42\00\00\d8\42\00\00\f2\42\00\00\00\42\00\00\de\42\00\00\dc\42\00\00\c6\42\00\00\ca\42\00\00\24\42\00\00\c8\42\00\00\ca\42\00\00\d8\42\00\00\c2\42\00\00\f2\42\00\00\c6\42\00\00\e4\42\00\00\ca\42\00\00\c2\42\00\00\e8\42\00\00\ca\42\00\00\00\42\00\00\c2\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\00\42\00\00\c6\42\00\00\de\42\00\00\dc\42\00\00\e8\42\00\00\e4\42\00\00\de\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\e4\42\00\00\00\42\00\00\c6\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\e6\42\00\00\d2\42\00\00\ce\42\00\00\dc\42\00\00\c2\42\00\00\d8\42\00\00\c2\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\00\42\00\00\e6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\00\42\00\00\e8\42\00\00\c2\42\00\00\e6\42\00\00\d6\42\00\00\00\42\00\00\c6\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\c4\42\00\00\f2\42\00\00\e8\42\00\00\ca\42\00\00\9e\42\00\00\cc\42\00\00\cc\42\00\00\e6\42\00\00\ca\42\00\00\e8\42\00\00\c6\42\00\00\de\42\00\00\dc\42\00\00\e6\42\00\00\e8\42\00\00\e4\42\00\00\ea\42\00\00\c6\42\00\00\e8\42\00\00\de\42\00\00\e4\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\da\42\00\00\d2\42\00\00\e6\42\00\00\ca\42\00\00\e4\42\00\00\ca\42\00\00\e6\42\00\00\de\42\00\00\d8\42\00\00\ec\42\00\00\ca\42\00\00\e4\42\00\00\ca\42\00\00\d4\42\00\00\ca\42\00\00\c6\42\00\00\e8\42\00\00\e8\42\00\00\c2\42\00\00\e6\42\00\00\d6\42\00\00\00\42\00\00\c6\42\00\00\de\42\00\00\da\42\00\00\e0\42\00\00\d8\42\00\00\ca\42\00\00\e8\42\00\00\ca\42\00\00\c8\42\00\00\84\42\00\00\b2\42\00\00\a8\42\00\00\8a\42\00\00\a6\42\00\00\be\42\00\00\a0\42\00\00\8a\42\00\00\a4\42\00\00\be\42\00\00\8a\42\00\00\98\42\00\00\8a\42\00\00\9a\42\00\00\8a\42\00\00\9c\42\00\00\a8\42\00\00\ee\42\00\00\de\42\00\00\e4\42\00\00\d6\42\00\00\ca\42\00\00\e4\42\00\00\be\42\00\00\c6\42\00\00\de\42\00\00\ea\42\00\00\dc\42\00\00\e8\42\00\00\c2\42\00\00\c6\42\00\00\e8\42\00\00\d2\42\00\00\ec\42\00\00\ca\42\00\00\be\42\00\00\ee\42\00\00\de\42\00\00\e4\42\00\00\d6\42\00\00\ca\42\00\00\e4\42\00\00\e6\42\00\00\d8\42\00\00\de\42\00\00\c6\42\00\00\d6\42\00\00\ca\42\00\00\c8\42\00\00\be\42\00\00\ee\42\00\00\de\42\00\00\e4\42\00\00\d6\42\00\00\ca\42\00\00\e4\42\00\00\e6\42\00\00\dc\42\00\00\de\42\00\00\e8\42\00\00\d2\42\00\00\cc\42\00\00\d2\42\00\00\ca\42\00\00\e4\42\00\00\be\42\00\00\d2\42\00\00\dc\42\00\00\c8\42\00\00\ca\42\00\00\f0\42\00\00\c6\42\00\00\e4\42\00\00\ca\42\00\00\c2\42\00\00\e8\42\00\00\ca\42\00\00\00\42\00\00\ee\42\00\00\c2\42\00\00\d2\42\00\00\e8\42\00\00\00\42\00\00\c2\42\00\00\e6\42\00\00\f2\42\00\00\dc\42\00\00\c6\42\00\00\00\42\00\00\c6\42\00\00\c2\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\c8\42\00\00\c2\42\00\00\e6\42\00\00\f2\42\00\00\dc\42\00\00\c6\42\00\00\ee\42\00\00\c2\42\00\00\d2\42\00\00\e8\42\00\00\82\42\00\00\e6\42\00\00\f2\42\00\00\dc\42\00\00\c6\42\00\00\00\42\00\00\d2\42\00\00\e6\42\00\00\00\42\00\00\dc\42\00\00\de\42\00\00\e8\42\00\00\00\42\00\00\c2\42\00\00\00\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\da\42\00\00\d2\42\00\00\e6\42\00\00\ca\42\00\00\04\42\00\00\e6\42\00\00\ca\42\00\00\d8\42\00\00\cc\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\88\42\00\00\c2\42\00\00\e8\42\00\00\c2\42\00\00\ac\42\00\00\d2\42\00\00\ca\42\00\00\ee\42\00\00\aa\42\00\00\d2\42\00\00\dc\42\00\00\e8\42\00\00\60\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\aa\42\00\00\d2\42\00\00\dc\42\00\00\e8\42\00\00\44\42\00\00\58\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\aa\42\00\00\d2\42\00\00\dc\42\00\00\e8\42\00\00\4c\42\00\00\48\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\8c\42\00\00\d8\42\00\00\de\42\00\00\c2\42\00\00\e8\42\00\00\4c\42\00\00\48\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\dc\42\00\00\c2\42\00\00\ec\42\00\00\d2\42\00\00\ce\42\00\00\c2\42\00\00\e8\42\00\00\de\42\00\00\e4\42\00\00\c8\42\00\00\ca\42\00\00\ec\42\00\00\d2\42\00\00\c6\42\00\00\ca\42\00\00\9a\42\00\00\ca\42\00\00\da\42\00\00\de\42\00\00\e4\42\00\00\f2\42\00\00\d0\42\00\00\c2\42\00\00\e4\42\00\00\c8\42\00\00\ee\42\00\00\c2\42\00\00\e4\42\00\00\ca\42\00\00\86\42\00\00\de\42\00\00\dc\42\00\00\c6\42\00\00\ea\42\00\00\e4\42\00\00\e4\42\00\00\ca\42\00\00\dc\42\00\00\c6\42\00\00\f2\42\00\00\e6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\e4\42\00\00\a6\42\00\00\c6\42\00\00\d0\42\00\00\ca\42\00\00\c8\42\00\00\ea\42\00\00\d8\42\00\00\ca\42\00\00\e4\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\e8\42\00\00\de\42\00\00\e8\42\00\00\f2\42\00\00\e0\42\00\00\ca\42\00\00\e0\42\00\00\de\42\00\00\e6\42\00\00\e8\42\00\00\a8\42\00\00\c2\42\00\00\e6\42\00\00\d6\42\00\00\82\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\86\42\00\00\de\42\00\00\dc\42\00\00\e8\42\00\00\e4\42\00\00\de\42\00\00\d8\42\00\00\d8\42\00\00\ca\42\00\00\e4\42\00\00\c2\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\ce\42\00\00\ca\42\00\00\e8\42\00\00\82\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\a6\42\00\00\d2\42\00\00\ce\42\00\00\dc\42\00\00\c2\42\00\00\d8\42\00\00\de\42\00\00\dc\42\00\00\c2\42\00\00\c4\42\00\00\de\42\00\00\e4\42\00\00\e8\42\00\00\e6\42\00\00\ca\42\00\00\e8\42\00\00\a0\42\00\00\e4\42\00\00\de\42\00\00\da\42\00\00\d2\42\00\00\e6\42\00\00\ca\42\00\00\ee\42\00\00\d2\42\00\00\e8\42\00\00\d0\42\00\00\a4\42\00\00\ca\42\00\00\e6\42\00\00\de\42\00\00\d8\42\00\00\ec\42\00\00\ca\42\00\00\e4\42\00\00\e6\42\00\00\9a\42\00\00\ca\42\00\00\e6\42\00\00\e6\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\8a\42\00\00\ec\42\00\00\ca\42\00\00\dc\42\00\00\e8\42\00\00\c8\42\00\00\c2\42\00\00\e8\42\00\00\c2\42\00\00\84\42\00\00\d8\42\00\00\de\42\00\00\c4\42\00\00\ae\42\00\00\ca\42\00\00\c4\42\00\00\82\42\00\00\e6\42\00\00\e6\42\00\00\ca\42\00\00\da\42\00\00\c4\42\00\00\d8\42\00\00\f2\42\00\00\9a\42\00\00\ca\42\00\00\da\42\00\00\de\42\00\00\e4\42\00\00\f2\42\00\00\92\42\00\00\dc\42\00\00\e8\42\00\00\4c\42\00\00\48\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\9e\42\00\00\c4\42\00\00\d4\42\00\00\ca\42\00\00\c6\42\00\00\e8\42\00\00\ae\42\00\00\de\42\00\00\e4\42\00\00\d6\42\00\00\ca\42\00\00\e4\42\00\00\c2\42\00\00\e8\42\00\00\e8\42\00\00\ca\42\00\00\e4\42\00\00\da\42\00\00\d2\42\00\00\dc\42\00\00\c2\42\00\00\e8\42\00\00\ca\42\00\00\e6\42\00\00\e0\42\00\00\d8\42\00\00\d2\42\00\00\c6\42\00\00\ca\42\00\00\c6\42\00\00\c2\42\00\00\e8\42\00\00\c6\42\00\00\d0\42\00\00\e6\42\00\00\ca\42\00\00\e8\42\00\00\aa\42\00\00\d2\42\00\00\dc\42\00\00\e8\42\00\00\4c\42\00\00\48\42\00\00\ce\42\00\00\ca\42\00\00\e8\42\00\00\aa\42\00\00\d2\42\00\00\dc\42\00\00\e8\42\00\00\4c\42\00\00\48\42\00\00\be\42\00\00\be\42\00\00\e0\42\00\00\e4\42\00\00\de\42\00\00\e8\42\00\00\de\42\00\00\be\42\00\00\be\42\00\00\e6\42\00\00\ea\42\00\00\c4\42\00\00\c2\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\e0\42\00\00\ea\42\00\00\e6\42\00\00\d0\42\00\00\e0\42\00\00\de\42\00\00\e6\42\00\00\e8\42\00\00\9a\42\00\00\ca\42\00\00\e6\42\00\00\e6\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\e8\42\00\00\d0\42\00\00\ca\42\00\00\dc\42\00\00\d6\42\00\00\82\42\00\00\e4\42\00\00\e4\42\00\00\c2\42\00\00\f2\42\00\00\a8\42\00\00\f2\42\00\00\e0\42\00\00\ca\42\00\00\de\42\00\00\dc\42\00\00\da\42\00\00\ca\42\00\00\e6\42\00\00\e6\42\00\00\c2\42\00\00\ce\42\00\00\ca\42\00\00\00\42\00\00\74\42\00\00\00\42\00\00\ca\42\00\00\00\42\00\00\74\42\00\00\78\42\00\00\00\42\00\00\9e\42\00\00\c4\42\00\00\d4\42\00\00\ca\42\00\00\c6\42\00\00\e8\42\00\00\38\42\00\00\c2\42\00\00\e6\42\00\00\e6\42\00\00\d2\42\00\00\ce\42\00\00\dc\42\00\00\20\42\00\00\e6\42\00\00\ca\42\00\00\d8\42\00\00\cc\42\00\00\30\42\00\00\ca\42\00\00\38\42\00\00\c8\42\00\00\c2\42\00\00\e8\42\00\00\c2\42\00\00\24\42\00\00\38\42\00\00\ae\42\00\00\ca\42\00\00\c4\42\00\00\82\42\00\00\e6\42\00\00\e6\42\00\00\ca\42\00\00\da\42\00\00\c4\42\00\00\d8\42\00\00\f2\42\00\00\38\42\00\00\d2\42\00\00\dc\42\00\00\e6\42\00\00\e8\42\00\00\c2\42\00\00\dc\42\00\00\e8\42\00\00\d2\42\00\00\c2\42\00\00\e8\42\00\00\ca\42\00\00\20\42\00\00\10\42\00\00\30\42\00\00\e6\42\00\00\ca\42\00\00\d8\42\00\00\cc\42\00\00\24\42")
)