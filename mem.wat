(module 
    (memory $memory 100 65536 shared)
    (global $onready mut extern)

    (type $TYPEOF_MATHOP (func (param externref externref externref) (result externref)))

    (export "memory" (memory $memory))
    (export "buffer" (global $buffer))

    (global $INDEX_MALLOC_LENGTH i32 (i32.const 1))
    (global $OFFSET_MALLOC_LENGTH i32 (i32.const 4))
    (global $LENGTH_MALLOC_HEADERS i32 (i32.const 32))
    (global $PREALLOC_LENGTH i32 (i32.const 32))

    (global $-OFFSET_BUFFER_SIZE i32 (i32.const -32))
    (global $-OFFSET_BUFFER_TYPE i32 (i32.const -28))
    (global $-OFFSET_BYTE_LENGTH i32 (i32.const -24))
    (global $-OFFSET_BYTE_OFFSET i32 (i32.const -20))
    (global $-OFFSET_ITEM_LENGTH i32 (i32.const -16))

    (global $kType mut extern)
    (global $memory mut extern)
    (global $buffer mut extern)
    (global $stride mut i32)
    (global $atomics mut extern)
    (global $imports new Object)
    (global $concurrency mut i32)
    (global $HURRA new Object)
    (global $Math  new Object)
    (global $Task  new Object)

    (global $self.Symbol.toStringTag externref)

    (global $self.Uint8Array externref)
    (global $self.Uint32Array externref)
    (global $self.Float32Array externref)
    (global $self.navigator.hardwareConcurrency i32)

    (global $self.TypedArray:buffer/get         externref)
    (global $self.TypedArray:byteOffset/get     externref)
    (global $self.TypedArray:byteLength/get     externref)
    (global $self.TypedArray:length/get         externref)

    (global $Uint8Array i32 (i32.const 1))
    (global $Uint32Array i32 (i32.const 2))
    (global $Float32Array i32 (i32.const 3))


    (func (export "init")
        (param $onready externref)

        (global.set $concurrency global($self.navigator.hardwareConcurrency))
        (global.set $stride (i32.mul global($self.navigator.hardwareConcurrency) i32(16)))
        (i32.atomic.store global($OFFSET_MALLOC_LENGTH) global($PREALLOC_LENGTH))

        (warn<ref> (text "HURRA starting..."))

        (call $init.kType)
        (call $init.HURRA)

        $self.Reflect.apply<refx3>(
            this null $self.Array.of<ref>ref(
                global($HURRA)
            )
        )
    )

    (func $init.HURRA
        (local $__proto__ ref)

        (local.set $__proto__ 
            $self.Object.create<ref>ref(
                $self.Reflect.getPrototypeOf<ref>ref(
                    global($HURRA)
                )
            )
        )

        $self.Reflect.defineProperty<refx3>(
            local($__proto__)
            global($self.Symbol.toStringTag)
            $self.Object.fromEntries<ref>ref(
                $self.Array.of<ref>ref(
                    $self.Array<refx2>ref(
                        text("value") 
                        text("HURRA")
                    )
                )
            )
        )

        $self.Reflect.setPrototypeOf<refx2>(global($HURRA) local($__proto__))
        $self.Reflect.setPrototypeOf<refx2>(global($Math)  null)
        $self.Reflect.setPrototypeOf<refx2>(global($Task)  null)


        $self.Object.create<ref>(global($HURRA))

        $self.Reflect.set<ref.ref.fun>(
            global($HURRA) text("new") func($new<ref.i32.i32>ref)
        )

        (call $init.Math)

        $self.Reflect.set<ref.ref.ref>(global($HURRA) text("Task") global($Task))

    )

    (func $init.kType
        (global.set $kType 
            $self.Symbol<ref>ref(text("kType"))
        )
        
        $definePropertyKType<ref.i32>(global($self.Uint8Array) global($Uint8Array))
        $definePropertyKType<ref.i32>(global($self.Uint32Array) global($Uint32Array))
        $definePropertyKType<ref.i32>(global($self.Float32Array) global($Float32Array))
    )

    (func $init.Math
        global($HURRA)
        $self.Reflect.set<ref.ref.ref>(text('Math') global($Math))

        global($Math)x16
        $self.Reflect.set<ref.ref.fun>(text('add')     func($add))
        $self.Reflect.set<ref.ref.fun>(text('sub')     func($sub))
        $self.Reflect.set<ref.ref.fun>(text('mul')     func($mul))
        $self.Reflect.set<ref.ref.fun>(text('div')     func($div))
        $self.Reflect.set<ref.ref.fun>(text('max')     func($max))
        $self.Reflect.set<ref.ref.fun>(text('min')     func($min))
        $self.Reflect.set<ref.ref.fun>(text('eq')      func($eq))
        $self.Reflect.set<ref.ref.fun>(text('ne')      func($ne))
        $self.Reflect.set<ref.ref.fun>(text('lt')      func($lt))
        $self.Reflect.set<ref.ref.fun>(text('gt')      func($gt))
        $self.Reflect.set<ref.ref.fun>(text('le')      func($le))
        $self.Reflect.set<ref.ref.fun>(text('ge')      func($ge))
        $self.Reflect.set<ref.ref.fun>(text('floor')   func($floor))
        $self.Reflect.set<ref.ref.fun>(text('trunc')   func($trunc))
        $self.Reflect.set<ref.ref.fun>(text('ceil')    func($ceil))
        $self.Reflect.set<ref.ref.fun>(text('nearest') func($nearest))        
    )

    (func $Math.call<i32.refx3>ref 
        (param $typeof i32)
        (param $target ref)
        (param $source ref)
        (param $values ref)
        (result ref)
        null
    )

    (global $ADD      i32 i32(11))     
    (global $SUB      i32 i32(12))     
    (global $MUL      i32 i32(13))     
    (global $DIV      i32 i32(14))     
    (global $MAX      i32 i32(15))     
    (global $MIN      i32 i32(16))     
    (global $EQ       i32 i32(17))      
    (global $NE       i32 i32(18))      
    (global $LT       i32 i32(19))      
    (global $GT       i32 i32(20))      
    (global $LE       i32 i32(21))      
    (global $GE       i32 i32(22))      
    (global $FLOOR    i32 i32(23))   
    (global $TRUNC    i32 i32(24))   
    (global $CEIL     i32 i32(25))    
    (global $NEAREST  i32 i32(26)) 

    (func $add     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($ADD)     local(0) local(1) local(2)))
    (func $sub     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($SUB)     local(0) local(1) local(2)))
    (func $mul     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($MUL)     local(0) local(1) local(2)))
    (func $div     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($DIV)     local(0) local(1) local(2)))
    (func $max     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($MAX)     local(0) local(1) local(2)))
    (func $min     (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($MIN)     local(0) local(1) local(2)))
    (func $eq      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($EQ)      local(0) local(1) local(2)))
    (func $ne      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($NE)      local(0) local(1) local(2)))
    (func $lt      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($LT)      local(0) local(1) local(2)))
    (func $gt      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($GT)      local(0) local(1) local(2)))
    (func $le      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($LE)      local(0) local(1) local(2)))
    (func $ge      (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($GE)      local(0) local(1) local(2)))
    (func $floor   (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($FLOOR)   local(0) local(1) local(2)))
    (func $trunc   (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($TRUNC)   local(0) local(1) local(2)))
    (func $ceil    (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($CEIL)    local(0) local(1) local(2)))
    (func $nearest (type $TYPEOF_MATHOP) (call $Math.call<i32.refx3>ref global($NEAREST) local(0) local(1) local(2)))

    (func $definePropertyKType<ref.i32>
        (param $constructor ref)
        (param $kTypeValue i32)
        (local $prototype ref)
        (local $descriptor ref)

        (local.set $descriptor (new $self.Object))
        (local.set $prototype (get <refx2>ref this text("prototype")))
        
        $self.Reflect.set<ref.ref.i32>(
            local($descriptor) 
            text("value") 
            local($kTypeValue)
        )

        $self.Reflect.defineProperty<refx3>(
            local($constructor) global($kType) local($descriptor)
        )

        $self.Reflect.defineProperty<refx3>(
            local($prototype) global($kType) local($descriptor)
        )
    )

    (func $TypedArray:BYTES_PER_ELEMENT<ref>i32
        (param $this# ref) (result i32) (get <refx2>i32 this text('BYTES_PER_ELEMENT'))
    )

    (func $TypedArray:buffer<ref>ref
        (param $this# ref) (result ref)
        (call $self.Reflect.apply<refx3>ref global($self.TypedArray:buffer/get) this self)
    )

    (func $TypedArray:byteOffset<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.apply<refx3>i32 global($self.TypedArray:byteOffset/get) this self)
    )

    (func $TypedArray:byteLength<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.apply<refx3>i32 global($self.TypedArray:byteLength/get) this self)
    )

    (func $TypedArray:length<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.apply<refx3>i32 global($self.TypedArray:length/get) this self)
    )

    (func $TypedArray:bufferType<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.get<refx2>i32 this global($kType))
    )

    (func $align<i32>i32
        (param $byteLength i32)
        (result i32)
        (local $remainder i32)

        (if (i32.le_u local($byteLength) global($stride))
            (then (return global($stride)))
        )

        (if (local.tee $remainder
                (i32.rem_u local($byteLength) global($stride))
            )
            (then
                (local.set $byteLength
                    (i32.add
                        local($byteLength)
                        (i32.sub global($stride) local($remainder))
                    )
                )   
            )
        )

        local($byteLength)
    )

    (func $new<ref.i32.i32>ref
        (param $TypedArray ref)
        (param $itemLength i32)
        (param $isPointer i32)
        (result externref)

        (local $bufferType i32)
        (local $byteLength i32)
        (local $bufferSize i32)
        (local $byteOffset i32)
        (local $typedArray ref)

        (local.set $bufferType
            $TypedArray:bufferType<ref>i32(
                local($TypedArray)
            )
        )
        
        (local.set $byteLength
            (i32.mul
                local($itemLength)
                $TypedArray:BYTES_PER_ELEMENT<ref>i32(
                    local($TypedArray)
                )
            )
        )

        (local.set $bufferSize
            $align<i32>i32(
                (i32.add
                    local($byteLength)
                    global($LENGTH_MALLOC_HEADERS)
                )
            )
        )

        (local.set $byteOffset
            (i32.add
                global($LENGTH_MALLOC_HEADERS)
                (i32.atomic.rmw.add
                    global($OFFSET_MALLOC_LENGTH) local($bufferSize)
                )
            )
        )
        
        (local.set $typedArray
            $self.Reflect.construct<refx2>ref(
                local($TypedArray) 
                $self.Array.of<ref.i32.i32>ref(
                    global($buffer) local($byteOffset) local($itemLength)
                )
            )
        )

        (call $bufferType<i32.i32> local($byteOffset) local($bufferType))
        (call $bufferSize<i32.i32> local($byteOffset) local($bufferSize))
        (call $byteLength<i32.i32> local($byteOffset) local($byteLength))
        (call $itemLength<i32.i32> local($byteOffset) local($itemLength))
        
        local($typedArray)
    )

    (func $malloc<i32>i32
        (export "malloc")
        (param $byteLength i32)
        (result i32)
        (local $bufferSize i32)
        (local $byteOffset i32)

        (local.set $bufferSize
            $align<i32>i32(
                (i32.add global($LENGTH_MALLOC_HEADERS)
                    local($byteLength)
                )
            )
        )

        (local.set $byteOffset
            (i32.add
                global($LENGTH_MALLOC_HEADERS)
                (i32.atomic.rmw.add global($-OFFSET_BUFFER_SIZE) 
                    local($bufferSize)
                )
            )
        )

        local($byteOffset)
    )

    (func $bufferSize<i32.i32>
        (param $byteOffset i32)
        (param $bufferSize i32)

        (i32.atomic.store
            (i32.add global($-OFFSET_BUFFER_SIZE)
                local($byteOffset)
            )   
            local($bufferSize)
        )
    )

    (func $bufferSize<i32>i32
        (param $byteOffset i32)
        (result $bufferSize i32)

        (i32.atomic.load
            (i32.add global($-OFFSET_BUFFER_SIZE)
                local($byteOffset)
            )   
        )
    )


    (func $byteLength<i32.i32>
        (param $byteOffset i32)
        (param $byteLength i32)

        (i32.atomic.store
            (i32.add global($-OFFSET_BYTE_LENGTH)
                local($byteOffset)
            )   
            local($byteLength)
        )
    )

    (func $byteLength<i32>i32
        (param $byteOffset i32)
        (result $byteLength i32)

        (i32.atomic.load
            (i32.add global($-OFFSET_BYTE_LENGTH)
                local($byteOffset)
            )   
        )
    )


    (func $bufferType<i32.i32>
        (param $byteOffset i32)
        (param $bufferType i32)

        (i32.atomic.store
            (i32.add global($-OFFSET_BUFFER_TYPE)
                local($byteOffset)
            )   
            local($bufferType)
        )
    )

    (func $bufferType<i32>i32
        (param $byteOffset i32)
        (result $bufferType i32)

        (i32.atomic.load
            (i32.add global($-OFFSET_BUFFER_TYPE)
                local($byteOffset)
            )   
        )
    )

    (func $itemLength<i32.i32>
        (param $byteOffset i32)
        (param $itemLength i32)

        (i32.atomic.store
            (i32.add global($-OFFSET_ITEM_LENGTH)
                local($byteOffset)
            )   
            local($itemLength)
        )
    )

    (func $itemLength<i32>i32
        (param $byteOffset i32)
        (result $itemLength i32)

        (i32.atomic.load
            (i32.add global($-OFFSET_ITEM_LENGTH)
                local($byteOffset)
            )   
        )
    )
)