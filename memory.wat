(module
    (import "navigator" "hardwareConcurrency"                                        (global $concurrency i32))
    (import "self" "undefined"                                                   (global $undefined externref))
    (import "self" "Number"                                                 (global $Number externref))
    (import "self" "Uint8Array"                                                 (global $Uint8Array externref))
    (import "self" "Uint32Array"                                               (global $Uint32Array externref))
    (import "self" "Float32Array"                                             (global $Float32Array externref))
    (import "Uint8Array" "BYTES_PER_ELEMENT"                        (global $Uint8Array.BYTES_PER_ELEMENT i32))
    (import "Uint32Array" "BYTES_PER_ELEMENT"                      (global $Uint32Array.BYTES_PER_ELEMENT i32))
    (import "Float32Array" "BYTES_PER_ELEMENT"                    (global $Float32Array.BYTES_PER_ELEMENT i32))
    (import "Uint8Array" "name"                                            (global $Uint8Array.name externref))
    (import "Uint32Array" "name"                                          (global $Uint32Array.name externref))
    (import "Float32Array" "name"                                        (global $Float32Array.name externref))

    (import "Reflect" "setPrototypeOf" (func $Reflect.setPrototypeOf<ref.ref> (param externref externref) (result)))
    (import "Reflect" "getPrototypeOf" (func $Reflect.getPrototypeOf<ref>ref (param externref) (result externref)))
    (import "Reflect" "set" (func $Reflect.set<ref.ref.ref> (param externref externref externref) (result)))
    (import "Reflect" "construct" (func $Reflect.construct<ref.ref>ref (param externref externref) (result externref)))
    (import "Array" "of" (func $Array.of<ref.i32.i32>ref (param externref i32 i32) (result externref)))
    (import "Array" "of" (func $Array.of<i32>ref (param i32) (result externref)))
    (import "Symbol" "toStringTag" (global $Symbol.toStringTag externref))

    (import "self" "Object"               (func $Object<i32>ref (param i32) (result externref)))
    (import "Object" "is"               (func $Object.is<ref.ref>i32 (param externref externref) (result i32)))
    (import "Object" "create"               (func $Object.create<ref>ref (param externref) (result externref)))
    (import "Object" "create"               (func $Object.restore<ref> (param externref) (result)))

    (global $Uint8Array.TYPE_OF_ELEMENTS i32 (i32.const 1))
    (global $Uint32Array.TYPE_OF_ELEMENTS i32 (i32.const 2))
    (global $Float32Array.TYPE_OF_ELEMENTS i32 (i32.const 3))

    (table $__proto__ (export "__proto__") 10 10 externref)

    (global $OFFSET_TYPE                                                                   i32 (i32.const  -4))
    (global $OFFSET_LENGTH                                                                 i32 (i32.const  -8))
    (global $OFFSET_BYTE_LENGTH                                                            i32 (i32.const -12))
    (global $OFFSET_BUFFER_SIZE                                                            i32 (i32.const -16))
    (global $OFFSET_RESERVED                                                               i32 (i32.const -32))
    (global $LENGTH_MALLOC_HEADERS                                                         i32 (i32.const  32))

    (memory $memory                                                                           (export "memory") 
        32768 32768 shared
    )

    (data (i32.const 64) "\80")

    (func $getByteOffset<i32>i32                                                       (export "getByteOffset")
        (param $this* i32)
        (result i32)
        (local.get $this*)
    )

    (func $setBufferSize<i32.i32>                                                      (export "setBufferSize")
        (param $this* i32)
        (param $value i32)
        (i32.atomic.store (i32.add (local.get $this*) (global.get $OFFSET_BUFFER_SIZE)) (local.get $value))
    )

    (func $getBufferSize<i32>i32                                                       (export "getBufferSize")
        (param $this* i32)
        (result i32)
        (i32.atomic.load (i32.add (local.get $this*) (global.get $OFFSET_BUFFER_SIZE)))
    )

    (func $setByteLength<i32.i32>                                                      (export "setByteLength")
        (param $this* i32)
        (param $value i32)
        (i32.atomic.store (i32.add (local.get $this*) (global.get $OFFSET_BYTE_LENGTH)) (local.get $value))
    )

    (func $getByteLength<i32>i32                                                       (export "getByteLength")
        (param $this* i32)
        (result i32)
        (i32.atomic.load (i32.add (local.get $this*) (global.get $OFFSET_BYTE_LENGTH)))
    )

    (func $setLength<i32.i32>                                                              (export "setLength")
        (param $this* i32)
        (param $value i32)
        (i32.atomic.store (i32.add (local.get $this*) (global.get $OFFSET_LENGTH)) (local.get $value))
    )

    (func $getLength<i32>i32                                                               (export "getLength")
        (param $this* i32)
        (result i32)
        (i32.atomic.load (i32.add (local.get $this*) (global.get $OFFSET_LENGTH)))
    )

    (func $setBufferType<i32.i32>                                                      (export "setBufferType")
        (param $this* i32)
        (param $value i32)
        (i32.store (i32.add (local.get $this*) (global.get $OFFSET_TYPE)) (local.get $value))
    )

    (func $getBufferType<i32>i32                                                       (export "getBufferType")
        (param $this* i32)
        (result i32)
        (i32.load (i32.add (local.get $this*) (global.get $OFFSET_TYPE)))
    )

    (func $exit                                                                                 (export "exit")
        (i32.atomic.store (i32.const 12) (i32.const 0))
        (i32.atomic.store (i32.const 8)  (i32.const 0))
        (i32.atomic.store (i32.const 0)  (i32.const 1))
        (call $notify)
    )

    (func $getTypedArray<ref>i32.i32
        (param $TypedArray externref)
        (result i32 i32)

        (if (call $Object.is<ref.ref>i32 (global.get $Float32Array) (local.get $TypedArray))
            (then
                (global.get $Float32Array.TYPE_OF_ELEMENTS)
                (global.get $Float32Array.BYTES_PER_ELEMENT)
            return)
        )
        
        (if (call $Object.is<ref.ref>i32 (global.get $Uint32Array) (local.get $TypedArray))
            (then
                (global.get $Uint32Array.TYPE_OF_ELEMENTS)
                (global.get $Uint32Array.BYTES_PER_ELEMENT)
            return)
        )

        (if (i32.or
                (call $Object.is<ref.ref>i32 (global.get $Uint8Array) (local.get $TypedArray))
                (call $Object.is<ref.ref>i32 (global.get $undefined) (local.get $TypedArray))
            )
            (then
                (global.get $Uint8Array.TYPE_OF_ELEMENTS)
                (global.get $Uint8Array.BYTES_PER_ELEMENT)
            return)
        )

        (unreachable)
    )


    (func $getPtrPrototype<ref>ref
        (param $TypedArray externref)
        (result externref)
         
        (if (call $Object.is<ref.ref>i32 (local.get $TypedArray) (global.get $Float32Array))
            (then (table.get $__proto__ (global.get $Float32Array.TYPE_OF_ELEMENTS)) return)
        )

        (if (call $Object.is<ref.ref>i32 (local.get $TypedArray) (global.get $Uint32Array) )
            (then (table.get $__proto__ (global.get $Uint32Array.TYPE_OF_ELEMENTS)) return)
        )
        
        (if (i32.or
                (call $Object.is<ref.ref>i32 (local.get $TypedArray) (global.get $Uint8Array))
                (call $Object.is<ref.ref>i32 (local.get $TypedArray) (global.get $undefined))
            )
            (then (table.get $__proto__ (global.get $Uint8Array.TYPE_OF_ELEMENTS)) return)
        )

        (unreachable)
    )

    (func $ptr*
        (param $TypedArray externref)
        (param $length i32)
        (result i32)

        (local $byteLength i32)
        (local $byteOffset i32)
        (local $bufferType i32)
        (local $remain i32)
        (local $BYTES_PER_ELEMENT i32)

        (call $getTypedArray<ref>i32.i32 
            (local.get $TypedArray)
        )
        (local.set $BYTES_PER_ELEMENT)
        (local.set $bufferType)

        (local.set $byteOffset 
            (call $malloc 
                (i32.mul 
                    (local.get $length) 
                    (local.get $BYTES_PER_ELEMENT)
                )
            )
        )

        (call $setBufferType<i32.i32> (local.get $byteOffset) (local.get $bufferType))
        (call $setLength<i32.i32>     (local.get $byteOffset) (local.get $length))

        (local.get $byteOffset)    
    )

    (func $new (export "new")
        (param $TypedArray externref)
        (param $length i32)
        (param $isPointer i32)
        (result externref)

        (local $this* i32)
        (local $this# externref)
        
        (local.set $this*
            (call $ptr* 
                (local.get $TypedArray) 
                (local.get $length)
            )
        )

        (if (local.get $isPointer)
            (then
                (local.set $this#
                    (call $Reflect.construct<ref.ref>ref
                        (global.get $Number)
                        (call $Array.of<i32>ref (local.get $this*))
                    ) 
                )

                (call $Reflect.setPrototypeOf<ref.ref>
                    (local.get $this#)
                    (call $getPtrPrototype<ref>ref (local.get $TypedArray))
                )

                (call $Object.restore<ref> 
                    (local.get $this#)
                ) 
            )
            (else
                (local.set $this#
                    (call $Reflect.construct<ref.ref>ref
                        (local.get $TypedArray)
                        (call $Array.of<ref.i32.i32>ref
                            (global.get $buffer) 
                            (local.get $this*) 
                            (local.get $length)
                        )
                    ) 
                )       
            )
        )

        (local.get $this#)
    )
    
    (func $malloc                                                                             (export "malloc")                                    
        (param $byteLength i32)
        (result i32)

        (local $remain i32)
        (local $bufferSize i32)
        (local $byteOffset i32)
        
        (local.set $bufferSize
            (call $align 
                (i32.add 
                    (local.get $byteLength) 
                    (global.get $LENGTH_MALLOC_HEADERS)
                )
            )
        )

        (local.set $byteOffset
            (i32.add 
                (i32.atomic.rmw.add 
                    (i32.const 64)
                    (local.get $bufferSize)
                )
                (global.get $LENGTH_MALLOC_HEADERS)
            )
        )

        (call $setBufferSize<i32.i32> (local.get $byteOffset) (local.get $bufferSize))
        (call $setByteLength<i32.i32> (local.get $byteOffset) (local.get $byteLength))

        (local.get $byteOffset) 
    )

    (func $align
        (param $length i32)
        (result i32)
        (local $remain i32)
        (local $stride i32)
        (local.set $stride (call $get_stride))

        (if (i32.le_u (local.get $length) (local.get $stride))
            (then (return (local.get $stride)))
        )

        (if (local.tee $remain 
                (i32.rem_u 
                    (local.get $length) 
                    (local.get $stride)
                )
            )
            (then
                (local.set $length
                    (i32.add
                        (local.get $length)
                        (i32.sub 
                            (local.get $stride) 
                            (local.get $remain)
                        )
                    )
                )
            )
        )

        (local.get $length)
    )

    (func $set_buffer (export "set_buffer")
        (param $buffer externref)
        (global.set $buffer (local.get $buffer))
    )

    (global $buffer (mut externref) ref.null extern)

    (global $void                (export "void")    i32 (i32.const 0))
    (global $F_4_add_n      (export "F_4_add_n")    i32 (i32.const 1))
    (global $F_4_add_v      (export "F_4_add_v")    i32 (i32.const 2))
    (global $F_4_mul_n      (export "F_4_mul_n")    i32 (i32.const 3))
    (global $F_4_mul_v      (export "F_4_mul_v")    i32 (i32.const 4))
    (global $F_4_div_n      (export "F_4_div_n")    i32 (i32.const 5))
    (global $F_4_div_v      (export "F_4_div_v")    i32 (i32.const 6))
    (global $F_4_sub_n      (export "F_4_sub_n")    i32 (i32.const 7))
    (global $F_4_sub_v      (export "F_4_sub_v")    i32 (i32.const 8))
    (global $F_4_max_n      (export "F_4_max_n")    i32 (i32.const 9))
    (global $F_4_max_v      (export "F_4_max_v")    i32 (i32.const 10))
    (global $F_4_min_n      (export "F_4_min_n")    i32 (i32.const 11))
    (global $F_4_min_v      (export "F_4_min_v")    i32 (i32.const 12))
    (global $F_4_eq_n       (export "F_4_eq_n")     i32 (i32.const 13))
    (global $F_4_eq_v       (export "F_4_eq_v")     i32 (i32.const 14))
    (global $F_4_ne_n       (export "F_4_ne_n")     i32 (i32.const 15))
    (global $F_4_ne_v       (export "F_4_ne_v")     i32 (i32.const 16))
    (global $F_4_lt_n       (export "F_4_lt_n")     i32 (i32.const 17))
    (global $F_4_lt_v       (export "F_4_lt_v")     i32 (i32.const 18))
    (global $F_4_gt_n       (export "F_4_gt_n")     i32 (i32.const 19))
    (global $F_4_gt_v       (export "F_4_gt_v")     i32 (i32.const 20))
    (global $F_4_le_n       (export "F_4_le_n")     i32 (i32.const 21))
    (global $F_4_le_v       (export "F_4_le_v")     i32 (i32.const 22))
    (global $F_4_ge_n       (export "F_4_ge_n")     i32 (i32.const 23))
    (global $F_4_ge_v       (export "F_4_ge_v")     i32 (i32.const 24))
    (global $F_4_floor      (export "F_4_floor")    i32 (i32.const 25))
    (global $F_4_trunc      (export "F_4_trunc")    i32 (i32.const 26))
    (global $F_4_ceil       (export "F_4_ceil")     i32 (i32.const 27))
    (global $F_4_nearest    (export "F_4_nearest")  i32 (i32.const 28))


    (global $worker_count  (mut i32)  (i32.const 0))
    (global $worker_index  (mut i32)  (i32.const 0))
    (global $worker_offset (mut v128) (v128.const i32x4 0 0 0 0))

    (func $newExtendedNumberPrototype
        (param $toStringTag externref)
        (result externref)
        (local $__proto__ externref)

        (local.set $__proto__
            (call $Object.create<ref>ref
                (call $Reflect.getPrototypeOf<ref>ref
                    (call $Reflect.construct<ref.ref>ref
                        (global.get $Number) 
                        (call $Array.of<i32>ref 
                            (i32.const 0)
                        )
                    )
                )
            )
        )

        (call $Reflect.set<ref.ref.ref>
            (local.get $__proto__)
            (global.get $Symbol.toStringTag)
            (local.get $toStringTag)
        )

        (local.get $__proto__)
    )

    (func $main
        (call $set_worker_count (global.get $concurrency))

        (table.set $__proto__ (global.get $Uint8Array.TYPE_OF_ELEMENTS) (call $newExtendedNumberPrototype (global.get $Uint8Array.name)))
        (table.set $__proto__ (global.get $Uint32Array.TYPE_OF_ELEMENTS) (call $newExtendedNumberPrototype (global.get $Uint32Array.name)))
        (table.set $__proto__ (global.get $Float32Array.TYPE_OF_ELEMENTS) (call $newExtendedNumberPrototype (global.get $Float32Array.name)))
    )
   
    (start $main)
    
    (global $stride (export "stride") (mut i32) (i32.const 16))

    (func $set_worker_count
        (param i32)

        (i32.store (i32.const 4) (local.get 0))
        (global.set $worker_count (call $get_worker_count))
        (global.set $stride (call $get_stride))

        ;; substract vector for vec4(length + offsets)
        (call $set_operand
            (i32x4.mul 
                (v128.const i32x4 -1 1 1 1) 
                (i32x4.splat (call $get_stride))
            )
        )
    )

    (func (export "calc")
        (param $func i32)
        (param $byteLength i32)
        (param $targetOffset i32)
        (param $sourceOffset i32)
        (param $valuesOffset i32)

        (call $set_func           (local.get $func))
        (call $set_length         (call $align (local.get $byteLength)))
        (call $set_target_offset  (local.get $targetOffset))
        (call $set_source_offset  (local.get $sourceOffset))
        (call $set_values_offset  (local.get $valuesOffset))

        (call $notify)
    )

    (func $notify
        (i32.atomic.store 
            (i32.const 8) 
            (memory.atomic.notify 
                (i32.const 0) 
                (global.get $worker_count)
            ) 
        )
    )

    (func $get_worker_count
        (result i32)
        (i32.atomic.load (i32.const 4))
    )

    (func $set_func
        (param i32)
        (i32.atomic.store (i32.const 12) (local.get 0))
    )

    (func $get_stride 
        (result i32)
        (i32.mul (global.get $worker_count) (i32.const 16))
    )

    (func $get_offsets
        (result v128)
        (i32x4.add (v128.load (i32.const 16)) (global.get $worker_offset))
    )

    (func $get_length 
        (result i32)
        (i32.atomic.load (i32.const 16))
    )

    (func $set_length
        (param i32)

        (if (i32.rem_u (local.get 0) (call $get_stride))
            (then unreachable)
        )

        (i32.atomic.store (i32.const 16) (local.get 0))
    )


    (func $get_target_offset
        (result i32)
        (i32.atomic.load (i32.const 20))
    )

    (func $set_target_offset
        (param i32)
        (i32.atomic.store (i32.const 20) (local.get 0))
    )

    (func $get_source_offset
        (result i32)
        (i32.atomic.load (i32.const 24))
    )

    (func $set_source_offset
        (param i32)
        (i32.atomic.store (i32.const 24) (local.get 0))
    )

    (func $get_values_offset
        (result i32)
        (i32.atomic.load (i32.const 28))
    )

    (func $set_values_offset
        (param i32)
        (i32.atomic.store (i32.const 28) (local.get 0))
    )

    (func $get_operand
        (result v128)
        (v128.load (i32.const 32))
    )

    (func $set_operand
        (param v128)
        (v128.store (i32.const 32) (local.get 0))
    )

    (func $get_uniform/32
        (result v128)
        (v128.load32_splat (call $get_values_offset))
    )
)