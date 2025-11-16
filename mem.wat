(module
    (import "console" "log" (func $log (param i32)))
    (import "console" "log" (func $log<ref> (param externref)))
    (import "console" "warn" (func $console.warn<ref> (param externref)))

    (import "Reflect" "get"                         (func $get<refx2>ref (param externref externref) (result externref)))
    (import "Reflect" "get"                         (func $get<ref.ref>ref (param externref externref) (result externref)))
    (import "Reflect" "set"                         (func $set<refx3> (param externref externref externref)))
    (import "Reflect" "set"                         (func $set<ref.i32x2> (param externref i32 i32)))
    (import "Reflect" "set"                         (func $set<ref.ref.ref> (param externref externref externref)))
    (import "Reflect" "set"                         (func $set<ref.i32.i32> (param externref i32 i32)))
    (import "Reflect" "set"                         (func $set<ref.i32.ref> (param externref i32 externref)))
    (import "Reflect" "apply"                       (func $apply<refx3>ref (param externref externref externref) (result externref)))
    (import "Reflect" "construct"                   (func $construct<refx2>ref (param externref externref) (result externref)))
    (import "Reflect" "defineProperty"              (func $defineProperty<refx3> (param externref externref externref)))
    (import "Reflect" "getPrototypeOf"              (func $getPrototypeOf<ref>ref (param externref) (result externref)))
    (import "Reflect" "setPrototypeOf"              (func $setPrototypeOf<refx2> (param externref externref)))
    (import "Reflect" "getOwnPropertyDescriptor"    (func $getOwnPropertyDescriptor<refx2>ref (param externref externref) (result externref)))
    
    (import "self" "Array"                          (func $Array<>ref (param) (result externref)))
    (import "self" "Object"                         (func $Object<>ref (param) (result externref)))
    (import "self" "String"                         (func $String<>ref (param) (result externref)))
    (import "self" "Object"                         (func $Object<ref>ref (param externref) (result externref)))
    (import "Array" "of"                            (func $Array.of<i32>ref (param i32) (result externref)))
    (import "Array" "of"                            (func $Array.of<ref>ref (param externref) (result externref)))
    (import "Array" "of"                            (func $Array.of<refx2>ref (param externref externref) (result externref)))
    (import "Object" "is"                           (func $Object.is<refx2>i32 (param externref externref) (result i32)))
    (import "Object" "create"                       (func $Object.create<ref> (param externref) (result)))
    (import "Object" "create"                       (func $Object.create<ref>ref (param externref) (result externref)))
    (import "Object" "fromEntries"                  (func $Object.fromEntries<ref>ref (param externref) (result externref)))
    (import "self" "Boolean"                        (func $Boolean<ref>i32 (param externref) (result i32)))
    (import "self" "Boolean"                        (func $Boolean<i32>ref (param i32) (result externref)))

    (import "self" "self"                           (global $self externref))
    (import "self" "name"                           (global $name externref))
    (import "self" "NaN"                            (global $NaN externref))
    (import "self" "undefined"                      (global $undefined externref))
    (import "self" "Number"                         (global $Number externref))
    
    (import "Symbol" "toStringTag"                  (global $Symbol.toStringTag externref))
    (import "String" "fromCharCode"                 (global $String.fromCharCode externref))

    (import "self" "Uint8Array"                     (global $Uint8Array externref))
    (import "self" "Uint16Array"                    (global $Uint16Array externref))
    (import "self" "Uint32Array"                    (global $Uint32Array externref))
    (import "self" "Float32Array"                   (global $Float32Array externref))

    (import "Uint8Array" "BYTES_PER_ELEMENT"        (global $Uint8Array.size i32))
    (import "Uint16Array" "BYTES_PER_ELEMENT"       (global $Uint16Array.size i32))
    (import "Uint32Array" "BYTES_PER_ELEMENT"       (global $Uint32Array.size i32))
    (import "Float32Array" "BYTES_PER_ELEMENT"      (global $Float32Array.size i32))

    (import "Uint8Array" "name"                     (global $Uint8Array.name externref))
    (import "Uint16Array" "name"                    (global $Uint16Array.name externref))
    (import "Uint32Array" "name"                    (global $Uint32Array.name externref))
    (import "Float32Array" "name"                   (global $Float32Array.name externref))

    (global $Uint8Array.type                        i32 (i32.const 1))
    (global $Uint16Array.type                       i32 (i32.const 2))
    (global $Uint32Array.type                       i32 (i32.const 3))
    (global $Float32Array.type                      i32 (i32.const 4))

    (global $true                                   (mut externref) (ref.null extern))
    (global $false                                  (mut externref) (ref.null extern))
    (global $null                                   externref (ref.null extern))

    (global $'name'         (mut externref) (ref.null extern))
    (global $'value'        (mut externref) (ref.null extern))
    (global $'configurable' (mut externref) (ref.null extern))
    (global $'Pointer'      (mut externref) (ref.null extern))
    
    (global $#Pointer       (mut externref) (ref.null extern))
    (global $#Uint8Array    (mut externref) (ref.null extern))
    (global $#Uint16Array   (mut externref) (ref.null extern))
    (global $#Uint32Array   (mut externref) (ref.null extern))
    (global $#Float32Array  (mut externref) (ref.null extern))

    (memory (export "memory") 1 65536 shared)

    (global $LOCK_STATUS_LOCKED i32 (i32.const  1))
    (global $LOCK_STATUS_IDLE   i32 (i32.const  0))

    (global $LOCK_STATUS_SELFLOCK  i32 (i32.const  2))
    (global $LOCK_STATUS_WORKING   i32 (i32.const  3))
    (global $LOCK_STATUS_SIGINT i32 (i32.const -1))

    (global $TIME_LOCK_DELAY    i64 (i64.const -1))

    (global $OFFSET_ARGS                i32 (i32.const 32))
    (global $OFFSET_OPERAND             i32 (i32.const 48))
    (global $LENGTH_MEMORY_HEADERS      i32 (i32.const 64))
    (global $LENGTH_MALLOC_HEADERS      i32 (i32.const 16))

    (global $OFFSET_ZERO_RESV           i32 (i32.const  0))
    (global $OFFSET_MALLOC_LENGTH       i32 (i32.const  4))
    (global $OFFSET_THREAD_COUNT        i32 (i32.const  8))
    (global $OFFSET_LOCK_STATUS         i32 (i32.const 12))

    (global $OFFSET_PROCESSOR_STAGE     i32 (i32.const 16))
    (global $OFFSET_CYCLE_COUNT         i32 (i32.const 20))
    (global $OFFSET_CALC_BYTELENGTH     i32 (i32.const 24))
    (global $OFFSET_HANDLER_ELEM        i32 (i32.const 28))
    
    (global $OFFSET_LENGTH              i32 (i32.const 32))
    (global $OFFSET_SOURCE              i32 (i32.const 36))
    (global $OFFSET_VALUES              i32 (i32.const 40))
    (global $OFFSET_TARGET              i32 (i32.const 44))

    (global $OFFSET_STRIDE              i32 (i32.const 48))
    (global $OFFSET_SRCADD              i32 (i32.const 52))
    (global $OFFSET_VALADD              i32 (i32.const 56))
    (global $OFFSET_DSTADD              i32 (i32.const 60))

    (func $main
        (v128.store (global.get $OFFSET_ZERO_RESV) (v128.const i32x4 0 64 0 1))
        (v128.store (global.get $OFFSET_STRIDE) (v128.const i32x4 0 16 16 16))
        (v128.store (global.get $OFFSET_ARGS) (v128.const i32x4 0 0 0 0))

        (i32.atomic.store 
            (global.get $OFFSET_LOCK_STATUS)
            (global.get $LOCK_STATUS_SELFLOCK) (; locked ;)
        )

        (call $setGlobals)
    )

    (func $setGlobals
        (local $arguments<array> externref)

        (global.set $true  (call $Boolean<i32>ref (i32.const 1)))
        (global.set $false (call $Boolean<i32>ref (i32.const 0)))

        (local.set $arguments<array> (call $Array<>ref))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 0) (i32.const 118))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 1) (i32.const  97))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 2) (i32.const 108))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 3) (i32.const 117))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 4) (i32.const 101))
        (global.set $'value' 
            (call $apply<refx3>ref 
                (global.get $String.fromCharCode) 
                (global.get $self) 
                (local.get $arguments<array>)
            )
        )

        (local.set $arguments<array> (call $Array<>ref))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  0) (i32.const  99))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  1) (i32.const 111))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  2) (i32.const 110))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  3) (i32.const 102))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  4) (i32.const 105))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  5) (i32.const 103))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  6) (i32.const 117))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  7) (i32.const 114))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  8) (i32.const  97))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const  9) (i32.const  98))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 10) (i32.const 108))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 11) (i32.const 101))
        (global.set $'configurable' 
            (call $apply<refx3>ref 
                (global.get $String.fromCharCode) 
                (global.get $self) 
                (local.get $arguments<array>)
            )
        )

        (local.set $arguments<array> (call $Array<>ref))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 0) (i32.const 110))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 1) (i32.const  97))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 2) (i32.const 109))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 3) (i32.const 101))
        (global.set $'name' 
            (call $apply<refx3>ref 
                (global.get $String.fromCharCode) 
                (global.get $self) 
                (local.get $arguments<array>)
            )
        )

        (local.set $arguments<array> (call $Array<>ref))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 0) (i32.const  80))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 1) (i32.const 111))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 2) (i32.const 105))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 3) (i32.const 110))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 4) (i32.const 116))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 5) (i32.const 101))
        (call $set<ref.i32.i32> (local.get $arguments<array>) (i32.const 6) (i32.const 114))
        (global.set $'Pointer' 
            (call $apply<refx3>ref 
                (global.get $String.fromCharCode) 
                (global.get $self) 
                (local.get $arguments<array>)
            )
        )

        (global.set $#Pointer 
            (call $construct<refx2>ref
                (global.get $Number)
                (global.get $self)
            )
        )

        (call $Object:toStringTag<refx2> (global.get $#Pointer) (global.get $'Pointer'))

        (global.set $#Uint8Array   (call $Object.create<ref>ref (global.get $#Pointer)))
        (global.set $#Uint16Array  (call $Object.create<ref>ref (global.get $#Pointer)))
        (global.set $#Uint32Array  (call $Object.create<ref>ref (global.get $#Pointer)))
        (global.set $#Float32Array (call $Object.create<ref>ref (global.get $#Pointer)))

        (call $Object:toStringTag<refx2> (global.get $#Uint8Array)   (global.get $Uint8Array.name))
        (call $Object:toStringTag<refx2> (global.get $#Uint16Array)  (global.get $Uint16Array.name))
        (call $Object:toStringTag<refx2> (global.get $#Uint32Array)  (global.get $Uint32Array.name))
        (call $Object:toStringTag<refx2> (global.get $#Float32Array) (global.get $Float32Array.name))
    )

    (func $Object:toStringTag<refx2>
        (param $object externref)
        (param $tagName externref)

        (call $defineProperty<refx3> 
            (local.get $object)
            (global.get $Symbol.toStringTag)
            (call $Object.fromEntries<ref>ref
                (call $Array.of<refx2>ref
                    (call $Array.of<refx2>ref (global.get $'value') (local.get $tagName))
                    (call $Array.of<refx2>ref (global.get $'configurable') (global.get $true))
                )
            )
        )
    )

    (func $Object.fromEntry<refx2>ref
        (param $key externref)
        (param $value externref)
        (result externref)

        (call $Object.fromEntries<ref>ref
            (call $Array.of<refx2>ref
                (call $Array.of<refx2>ref (local.get $key) (local.get $value))
                (call $Array.of<refx2>ref (global.get $'configurable') (global.get $true))
            )
        )
    )

    (start $main)

    (func (export "calc")
        (call $log (i32.load (global.get $OFFSET_STRIDE)))
    )

    (func $align
        (param $length i32)
        (result i32)

        (local $remain i32)
        (local $stride i32)

        (local.tee $stride (i32.load (global.get $OFFSET_STRIDE)))
        (if (i32.eqz) (then (local.set $stride (i32.const 16))))
        (local.set $remain (i32.rem_u (local.get $length) (local.get $stride)))

        (if (local.get $remain)
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

    (func $resize (export "resize")
        (param $byteLength i32)
        (local $memoryByteLength i32)
        (local $deltaByteLength i32)
        (local $deltaPageSize i32)

        (local.set $memoryByteLength
            (i32.mul (memory.size) (i32.const 65536))
        )

        (if (i32.lt_u (local.get $memoryByteLength) (local.get $byteLength))
            (then
                (local.set $deltaByteLength
                    (i32.sub (local.get $byteLength) (local.get $memoryByteLength))
                )

                (local.set $deltaPageSize
                    (i32.div_u (local.get $deltaByteLength) (i32.const 65536))
                )

                (if (i32.eqz (local.get $deltaPageSize)) 
                    (then 
                        (local.set $deltaPageSize (i32.const 1))
                    )
                )

                (memory.grow (local.get $deltaPageSize))

                (drop)
            )
        )
    )

    (func (export "malloc")
        (param $byteLength i32)
        (result externref)
        (call $new.Uint8Array<i32>ref (local.get $byteLength))
    )

    (func $Uint8Array.is<ref>i32
        (param $TypedArray externref)
        (result i32)
        (call $Object.is<refx2>i32 (local.get $TypedArray) (global.get $Uint8Array))
    )

    (func $Uint8Array.is<i32>i32
        (param $type i32)
        (result i32)
        (i32.eq (local.get $type) (global.get $Uint8Array.type))
    )

    (func $Uint16Array.is<ref>i32
        (param $TypedArray externref)
        (result i32)
        (call $Object.is<refx2>i32 (local.get $TypedArray) (global.get $Uint16Array))
    )

    (func $Uint16Array.is<i32>i32
        (param $type i32)
        (result i32)
        (i32.eq (local.get $type) (global.get $Uint16Array.type))
    )

    (func $Uint32Array.is<ref>i32
        (param $TypedArray externref)
        (result i32)
        (call $Object.is<refx2>i32 (local.get $TypedArray) (global.get $Uint32Array))
    )

    (func $Uint32Array.is<i32>i32
        (param $type i32)
        (result i32)
        (i32.eq (local.get $type) (global.get $Uint32Array.type))
    )

    (func $Float32Array.is<ref>i32
        (param $TypedArray externref)
        (result i32)
        (call $Object.is<refx2>i32 (local.get $TypedArray) (global.get $Float32Array))
    )

    (func $Float32Array.is<i32>i32
        (param $type i32)
        (result i32)
        (i32.eq (local.get $type) (global.get $Float32Array.type))
    )

    (func $TypedArray:type<ref>i32
        (param $TypedArray externref)
        (result i32)

        (if (call $Boolean<ref>i32 (local.get $TypedArray))
            (then
                (if (call $Uint16Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint16Array.type) return) 
                )

                (if (call $Uint16Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint16Array.type) return) 
                )

                (if (call $Uint32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint32Array.type) return) 
                )

                (if (call $Float32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Float32Array.type) return) 
                )
            )
        )

        (global.get $Uint8Array.type)
    )

    (func $TypedArray:size<ref>i32
        (param $TypedArray externref)
        (result i32)

        (if (call $Boolean<ref>i32 (local.get $TypedArray))
            (then
                (if (call $Uint8Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint8Array.size) return) 
                )

                (if (call $Uint16Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint16Array.size) return) 
                )

                (if (call $Uint32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint32Array.size) return) 
                )

                (if (call $Float32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Float32Array.size) return) 
                )
            )
        )

        (unreachable)
    )

    (func $TypedArray:name<ref>ref
        (param $TypedArray externref)
        (result externref)

        (if (call $Boolean<ref>i32 (local.get $TypedArray))
            (then
                (if (call $Uint8Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint8Array.name) return) 
                )

                (if (call $Uint16Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint16Array.name) return) 
                )

                (if (call $Uint32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Uint32Array.name) return) 
                )

                (if (call $Float32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $Float32Array.name) return) 
                )
            )
        )

        (unreachable)
    )

    (func $TypedArray:this<ref>ref
        (param $TypedArray externref)
        (result externref)

        (if (call $Boolean<ref>i32 (local.get $TypedArray))
            (then
                (if (call $Uint8Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $#Uint8Array) return) 
                )

                (if (call $Uint16Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $#Uint16Array) return) 
                )

                (if (call $Uint32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $#Uint32Array) return) 
                )

                (if (call $Float32Array.is<ref>i32 (local.get $TypedArray))
                    (then (global.get $#Float32Array) return) 
                )
            )
        )

        (unreachable)
    )

    (func $new.Uint8Array<i32>ref (export "Uint8Array")
        (param $length i32)
        (result externref)
        (call $new.TypedArray<i32.ref>ref (local.get $length) (global.get $Uint8Array))
    )

    (func $new.Uint16Array<i32>ref (export "Uint16Array")
        (param $length i32)
        (result externref)
        (call $new.TypedArray<i32.ref>ref (local.get $length) (global.get $Uint16Array))
    )

    (func $new.Uint32Array<i32>ref (export "Uint32Array")
        (param $length i32)
        (result externref)
        (call $new.TypedArray<i32.ref>ref (local.get $length) (global.get $Uint32Array))
    )
    
    (func $new.Float32Array<i32>ref (export "Float32Array")
        (param $length i32)
        (result externref)
        (call $new.TypedArray<i32.ref>ref (local.get $length) (global.get $Float32Array))
    )

    (func $isEmpty<ref>i32
        (param $value externref)
        (result i32)
        (i32.eqz (call $Boolean<ref>i32 (local.get $value)))
    )

    (func $new.TypedArray<i32.ref.ref>ref (export "TypedArray")
        (param $length i32)
        (param $TypedArray externref)
        (param $tagName externref)
        (result externref)

        (local $#ptr externref)
        (local $#ref externref)

        (if (call $isEmpty<ref>i32 (local.get $TypedArray))
            (then (local.set $TypedArray (global.get $Uint8Array)))
        )
        
        (local.set $#ptr 
            (call $new.Pointer<i32.ref>ref 
                (local.get $length)
                (local.get $TypedArray)
            )
        )

        (if (call $isEmpty<ref>i32 (local.get $tagName))
            (then (local.get $#ptr) return)
        )

        (local.set $#ref 
            (call $getPrototypeOf<ref>ref 
                (local.get $#ptr)
            )
        )

        (call $setPrototypeOf<refx2>
            (local.get $#ptr)
            (call $Object.create<ref>ref (local.get $#ref))
        )

        (call $Object.create<ref>
                (local.get $#ptr)
            )
        (call $Object:toStringTag<refx2>
            (call $getPrototypeOf<ref>ref (local.get $#ptr))
            (local.get $tagName)
        )
        
        (local.get $#ptr)
    )

    (func $new.TypedArray<i32.ref>ref
        (param $length i32)
        (param $TypedArray externref)
        (result externref)
        (call $new.TypedArray<i32.ref.ref>ref (local.get $length) (local.get $TypedArray) (ref.null extern))
    )

    (func $new.Pointer<i32>ref
        (param $length i32)
        (result externref)
        (call $new.Pointer<i32.ref>ref (local.get $length) (global.get $Uint8Array))
    )

    (func $new.Pointer<i32.ref>ref
        (param $length i32)
        (param $TypedArray externref)
        (result externref)

        (local $#ptr externref)
        (local $byteLength i32)
        (local $byteOffset i32)
        
        (local $size i32)
        (local $type i32)

        (local.set $size (call $TypedArray:size<ref>i32 (local.get $TypedArray)))
        (local.set $type (call $TypedArray:type<ref>i32 (local.get $TypedArray)))

        (local.set $byteLength (i32.mul (local.get $length) (local.get $size)))
        (local.set $byteOffset (call $malloc (local.get $byteLength)))
        
        (call $set_element_type (local.get $byteOffset) (local.get $type))

        (local.set $#ptr (call $new.Number<i32>ref (local.get $byteOffset)))

        (call $setPrototypeOf<refx2>
            (local.get $#ptr)
            (call $TypedArray:this<ref>ref 
                (local.get $TypedArray)
            )
        )

        (call $Object.create<ref> (local.get $#ptr))

        (local.get $#ptr)
    )

    (func $extend<refx2>ref
        (param $object externref)
        (param $prototype externref)
        (result externref)

        (local $extended externref)

        (local.set $extended (call $Object.create<ref>ref (local.get $object)))

        (call $Object.create<ref> (local.get $extended))
        (call $setPrototypeOf<refx2> (local.get $extended) (local.get $prototype))

        (local.get $extended)
    )

    (func $new.Number<i32>ref
        (param $value i32)
        (result externref)

        (call $construct<refx2>ref
            (global.get $Number)
            (call $Array.of<i32>ref
                (local.get $value)
            )
        )
    )

    (func $malloc 
        (param $byteLength i32)
        (result i32)
        (local $bufferSize i32)
        (local $byteOffset i32)
        (local $remain i32)

        (local.set $bufferSize
            (i32.add 
                (local.get $byteLength)
                (global.get $LENGTH_MALLOC_HEADERS)
            )
        )

        (local.set $remain (i32.rem_u (local.get $bufferSize) (i32.const 16)))

        (if (local.get $remain) 
            (then
                (local.set $remain
                    (i32.sub 
                        (i32.const 16)
                        (local.get $remain)
                    )
                )
            )
        )

        (local.set $bufferSize
            (i32.add 
                (local.get $remain)
                (local.get $bufferSize)
            )
        )

        (local.set $byteOffset
            (i32.atomic.rmw.add 
                (global.get $OFFSET_MALLOC_LENGTH)
                (local.get $bufferSize)
            )
        )

        (call $resize 
            (i32.add 
                (local.get $byteOffset)
                (local.get $bufferSize)
            )
        )
        
        (call $set_buffer_size (local.get $byteOffset) (local.get $bufferSize))
        (call $set_byte_length (local.get $byteOffset) (local.get $byteLength))

        (local.get $byteOffset)
    )

    (func $set_buffer_size
        (param $ptr* i32)
        (param $value i32)
        (i32.atomic.store offset=0 (local.get $ptr*) (local.get $value))
    )

    (func $set_byte_length
        (param $ptr* i32)
        (param $value i32)
        (i32.atomic.store offset=4 (local.get $ptr*) (local.get $value))
    )

    (func $set_length
        (param $ptr* i32)
        (param $value i32)
        (i32.atomic.store offset=8 (local.get $ptr*) (local.get $value))
    )

    (func $set_element_type
        (param $ptr* i32)
        (param $value i32)
        (i32.atomic.store offset=12 (local.get $ptr*) (local.get $value))
    )

    (func (export "exit")
        (i32.atomic.store 
            (global.get $OFFSET_LOCK_STATUS)
            (global.get $LOCK_STATUS_SIGINT)
        )

        (memory.atomic.notify
            (global.get $OFFSET_LOCK_STATUS)
            (i32.load (global.get $OFFSET_THREAD_COUNT))
        )

        (drop)
    )

    (func (export "unlock")
        (i32.atomic.store 
            (global.get $OFFSET_LOCK_STATUS)
            (global.get $LOCK_STATUS_WORKING) (; locked ;)
        )

        (memory.atomic.notify
            (global.get $OFFSET_LOCK_STATUS)
            (i32.load (global.get $OFFSET_THREAD_COUNT))
        )
        (call $log )

        (i32.atomic.store 
            (global.get $OFFSET_LOCK_STATUS)
            (global.get $LOCK_STATUS_SELFLOCK) (; lock after work ;)
        )
    )

    (func (export "maxLength") (result i32) (i32.mul (memory.size) (i32.const 1365)))
)