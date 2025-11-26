(module 
    (memory $memory 100 65536 shared)
    (global $resolve mut extern)

    (type $CALC (func (param i32 i32 i32) (result i32)))

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
    (global $HURRA.__proto__ mut extern)

    (global $self.Symbol.toStringTag externref)
    (global $self.String:toUpperCase externref)

    (global $self.Uint8Array externref)
    (global $self.Uint32Array externref)
    (global $self.Float32Array externref)
    (global $self.navigator.hardwareConcurrency i32)

    (global $self.TypedArray:buffer/get         externref)
    (global $self.TypedArray:byteOffset/get     externref)
    (global $self.TypedArray:byteLength/get     externref)
    (global $self.TypedArray:length/get         externref)

    (global $Number         i32 (i32.const 0))
    (global $Uint8Array     i32 (i32.const 1))
    (global $Uint32Array    i32 (i32.const 2))
    (global $Float32Array   i32 (i32.const 3))

    (table $__proto__ 10 10 externref)
    (table $__kTYPE__ 10 10 externref)

    (func (export "init")
        (param $options ref)
        (param $promise ref)
        (param $resolve ref)

        (global.set $concurrency global($self.navigator.hardwareConcurrency))
        (global.set $stride (i32.mul global($self.navigator.hardwareConcurrency) i32(16)))
        (i32.atomic.store global($OFFSET_MALLOC_LENGTH) global($PREALLOC_LENGTH))

        (call $init.HURRA)
        (call $init.kType)

        $self.Reflect.apply<refx3>(
            local($resolve) 
            local($promise) 
            $self.Array.of<ref>ref(
                global($HURRA)
            )
        )
    )

    (func $init.HURRA
        (global.set $HURRA.__proto__ 
            $self.Object.create<ref>ref(
                $self.Reflect.getPrototypeOf<ref>ref(
                    global($HURRA)
                )
            )
        )

        $self.Reflect.defineProperty<refx3>(
            global($HURRA.__proto__)
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

        global($HURRA)x2
        $self.Reflect.setPrototypeOf<refx2>(global($HURRA.__proto__))
        $self.Object.create<ref>()

        $defineHURRAFunction<ref.fun.i32>(text('add')     func($add)     global($ADD))
        $defineHURRAFunction<ref.fun.i32>(text('sub')     func($sub)     global($SUB))
        $defineHURRAFunction<ref.fun.i32>(text('mul')     func($mul)     global($MUL))
        $defineHURRAFunction<ref.fun.i32>(text('div')     func($div)     global($DIV))
        $defineHURRAFunction<ref.fun.i32>(text('max')     func($max)     global($MAX))
        $defineHURRAFunction<ref.fun.i32>(text('min')     func($min)     global($MIN))
        $defineHURRAFunction<ref.fun.i32>(text('eq')      func($eq)      global($EQ))
        $defineHURRAFunction<ref.fun.i32>(text('ne')      func($ne)      global($NE))
        $defineHURRAFunction<ref.fun.i32>(text('lt')      func($lt)      global($LT))
        $defineHURRAFunction<ref.fun.i32>(text('gt')      func($gt)      global($GT))
        $defineHURRAFunction<ref.fun.i32>(text('le')      func($le)      global($LE))
        $defineHURRAFunction<ref.fun.i32>(text('ge')      func($ge)      global($GE))
        $defineHURRAFunction<ref.fun.i32>(text('floor')   func($floor)   global($FLOOR))
        $defineHURRAFunction<ref.fun.i32>(text('trunc')   func($trunc)   global($TRUNC))
        $defineHURRAFunction<ref.fun.i32>(text('ceil')    func($ceil)    global($CEIL))
        $defineHURRAFunction<ref.fun.i32>(text('nearest') func($nearest) global($NEAREST))
        $defineHURRAFunction<ref.fun.i32>(text("new")     func($new)     global($NEW))
    )

    (global $self.Number externref)

    (func $init.kType
        global($kType $self.Symbol<ref>ref(text("kType")))

        update($__proto__ global($Number) 
            get(<refx2>ref global($self.Number) text('prototype'))
        )
        
        $generateProtoAndKType<ref.i32>(global($self.Uint8Array) global($Uint8Array))
        $generateProtoAndKType<ref.i32>(global($self.Uint32Array) global($Uint32Array))
        $generateProtoAndKType<ref.i32>(global($self.Float32Array) global($Float32Array))
    )

    (func $generateProtoAndKType<ref.i32>
        (param $SelfGlobal ref)
        (param $kTypeValue i32)

        (local $__kTYPE__   ref)
        (local $__proto__   ref)
        (local $kType       ref)
        (local $name        ref)
        (local $prototype   ref)
        (local $descriptor  ref)

        (local.set $__kTYPE__ 
            (new $self.Number<i32>ref local($kTypeValue))
        )

        (local.set $prototype   $self.Reflect.getPrototypeOf<ref>ref(local($__kTYPE__)))
        (local.set $name        get(<refx2>ref local($SelfGlobal) text('name')))
        (local.set $__proto__   $self.Object.create<ref>ref(local($prototype)))

        (local.set $descriptor 
            $self.Object.fromEntries<ref>ref(
                $self.Array.of<ref>ref(
                    $self.Array.of<ref.ref>ref(
                        text('value') 
                        local($name)
                    )
                )
            )
        )

        $self.Reflect.defineProperty<refx3>(
            local($__proto__) 
            global($self.Symbol.toStringTag) 
            local($descriptor)
        )

        update($__proto__ local($kTypeValue) local($__proto__))

        (local.set $name        apply($self.String:toUpperCase local($name)))
        (local.set $__proto__   $self.Object.create<ref>ref(local($prototype)))
        (local.set $descriptor 
            $self.Object.fromEntries<ref>ref(
                $self.Array.of<ref>ref(
                    $self.Array.of<ref.ref>ref(
                        text('value') 
                        local($name)
                    )
                )
            )
        )

        $self.Reflect.defineProperty<refx3>(
            local($__proto__) 
            global($self.Symbol.toStringTag) 
            local($descriptor)
        )

        $self.Reflect.setPrototypeOf<refx2>(
            local($__kTYPE__) 
            local($__proto__)
        )
        
        $self.Object.create<ref>(
            local($__kTYPE__)
        )

        $self.Reflect.set<refx3>(
            local($descriptor) text('value') local($__kTYPE__)
        )

        $self.Reflect.defineProperty<refx3>(
            local($SelfGlobal) global($kType) local($descriptor)
        )

        $self.Reflect.defineProperty<refx3>(
            (get <refx2>ref local($SelfGlobal) text('prototype')) global($kType) local($descriptor)
        )

        $self.Reflect.defineProperty<refx3>(
            global($HURRA.__proto__)
            local($name) 
            local($descriptor)
        )

        update($__kTYPE__ local($kTypeValue) local($__kTYPE__))
    )

    (global $NEW      i32 i32(99))     
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

    (func $calc 
        (param $typeof i32)
        (param $target i32)
        (param $source i32)
        (param $values i32)
        (result i32)
        i32(1)
    )

    (func $add     (export "add")       (type $CALC) (call $calc global($ADD)     local(0) local(1) local(2)))
    (func $sub     (export "sub")       (type $CALC) (call $calc global($SUB)     local(0) local(1) local(2)))
    (func $mul     (export "mul")       (type $CALC) (call $calc global($MUL)     local(0) local(1) local(2)))
    (func $div     (export "div")       (type $CALC) (call $calc global($DIV)     local(0) local(1) local(2)))
    (func $max     (export "max")       (type $CALC) (call $calc global($MAX)     local(0) local(1) local(2)))
    (func $min     (export "min")       (type $CALC) (call $calc global($MIN)     local(0) local(1) local(2)))
    (func $eq      (export "eq")        (type $CALC) (call $calc global($EQ)      local(0) local(1) local(2)))
    (func $ne      (export "ne")        (type $CALC) (call $calc global($NE)      local(0) local(1) local(2)))
    (func $lt      (export "lt")        (type $CALC) (call $calc global($LT)      local(0) local(1) local(2)))
    (func $gt      (export "gt")        (type $CALC) (call $calc global($GT)      local(0) local(1) local(2)))
    (func $le      (export "le")        (type $CALC) (call $calc global($LE)      local(0) local(1) local(2)))
    (func $ge      (export "ge")        (type $CALC) (call $calc global($GE)      local(0) local(1) local(2)))
    (func $floor   (export "floor")     (type $CALC) (call $calc global($FLOOR)   local(0) local(1) local(2)))
    (func $trunc   (export "trunc")     (type $CALC) (call $calc global($TRUNC)   local(0) local(1) local(2)))
    (func $ceil    (export "ceil")      (type $CALC) (call $calc global($CEIL)    local(0) local(1) local(2)))
    (func $nearest (export "nearest")   (type $CALC) (call $calc global($NEAREST) local(0) local(1) local(2)))
    (func $new     (export "new")
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

    (func $defineHURRAFunction<ref.fun.i32>
        (param $name externref)
        (param $func funcref)
        (param $type i32)
        (local $descriptor ref)
        (local $prototype ref)
        (local $__proto__ ref)
        (local $kType ref)

        (local.set $descriptor (new $self.Object))
        
        $self.Reflect.set<ref.ref.ref>(
            local($descriptor) text('value') local($name)
        )

        $self.Reflect.defineProperty<fun.ref.ref>(
            local($func) text('name') local($descriptor)
        )

        $self.Reflect.set<ref.ref.i32>(
            local($descriptor) text('value') local($type)
        )

        $self.Reflect.defineProperty<fun.ref.ref>(
            local($func) global($kType) local($descriptor)
        )

        $self.Reflect.set<ref.ref.fun>(
            global($HURRA) local($name) local($func)
        )

        $self.Reflect.set<ref.ref.i32>(
            local($descriptor) text('value') local($type)
        )

        (local.set $kType       new($self.Number<i32>ref local($type)))
        (local.set $name        apply($self.String:toUpperCase local($name)))
        (local.set $prototype   $self.Reflect.getPrototypeOf<ref>ref(local($kType)))
        (local.set $__proto__   $self.Object.create<ref>ref(local($prototype)))

        $self.Reflect.set<ref.ref.ref>(
            local($descriptor) 
            text('value') 
            local($name)
        )

        $self.Reflect.defineProperty<refx3>(
            local($__proto__)
            global($self.Symbol.toStringTag)
            local($descriptor)
        )

        $self.Reflect.setPrototypeOf<refx2>(
            local($kType) 
            local($__proto__)
        )

        $self.Object.create<ref>(
            local($kType)
        )

        $self.Reflect.set<ref.ref.ref>(
            local($descriptor) 
            text('value') 
            local($kType)
        )

        $self.Reflect.defineProperty<ref.ref.ref>(
            global($HURRA.__proto__) 
            local($name) 
            local($descriptor)
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