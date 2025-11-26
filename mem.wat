(module     
    (export "memory"                     (memory $memory))
    (export "buffer"                     (global $buffer))

    (memory $memory                     1000 65536 shared)
    (table $__proto__                   100 100 externref)
    (table $__kTYPE__                   100 100 externref)

    (global $INDEX_MALLOC_LENGTH        i32 (i32.const 1))
    (global $OFFSET_MALLOC_LENGTH       i32 (i32.const 4))
    (global $LENGTH_MALLOC_HEADERS     i32 (i32.const 32))
    (global $PREALLOC_LENGTH           i32 (i32.const 32))

    (global $-OFFSET_BUFFER_SIZE      i32 (i32.const -32))
    (global $-OFFSET_BUFFER_TYPE      i32 (i32.const -28))
    (global $-OFFSET_BYTE_LENGTH      i32 (i32.const -24))
    (global $-OFFSET_BYTE_OFFSET      i32 (i32.const -20))
    (global $-OFFSET_ITEM_LENGTH      i32 (i32.const -16))

    (global $kHurraType                        mut extern)
    (global $kReference                        mut extern)
    (global $options                           new Object)
    (global $memory                            mut extern)
    (global $buffer                            mut extern)
    (global $HURRA                             new Object)
    (global $HURRA.__proto__                   mut extern)
    (global $stride                               mut i32)
    (global $concurrency                          mut i32)

    (global $self.navigator.hardwareConcurrency       i32)
    (global $self.String.prototype.toUpperCase  externref)
    (global $self.Symbol.toStringTag            externref)
    (global $self.Uint8Array                    externref)
    (global $self.Uint32Array                   externref)
    (global $self.Float32Array                  externref)
    (global $self.TypedArray:buffer/get         externref)
    (global $self.TypedArray:byteOffset/get     externref)
    (global $self.TypedArray:byteLength/get     externref)
    (global $self.TypedArray:length/get         externref)

    (global $Number                     i32 (i32.const 0))
    (global $Uint8Array                 i32 (i32.const 1))
    (global $Uint32Array                i32 (i32.const 2))
    (global $Float32Array               i32 (i32.const 3))

    (global $NEW                              i32 i32(99))     
    (global $ADD                              i32 i32(11))     
    (global $SUB                              i32 i32(12))     
    (global $MUL                              i32 i32(13))     
    (global $DIV                              i32 i32(14))     
    (global $MAX                              i32 i32(15))     
    (global $MIN                              i32 i32(16))     
    (global $EQ                               i32 i32(17))      
    (global $NE                               i32 i32(18))      
    (global $LT                               i32 i32(19))      
    (global $GT                               i32 i32(20))      
    (global $LE                               i32 i32(21))      
    (global $GE                               i32 i32(22))      
    (global $FLOOR                            i32 i32(23))   
    (global $TRUNC                            i32 i32(24))   
    (global $CEIL                             i32 i32(25))    
    (global $NEAREST                          i32 i32(26)) 

    (global $SINGLE_VALUE                     i32 i32(50))
    (global $EXACT_LENGTH                     i32 i32(51))
    (global $ZERO_UNIFORM                     i32 i32(52))

    (func (export "init")
        (param $options ref)
        (param $promise ref)
        (param $resolve ref)

        $init(this)

        $self.Reflect.apply<refx3>(
            local($resolve) 
            local($promise) 
            Array.of(
                global($HURRA)
            )
        )
    )

    (func $init
        (param $options ref)
        (local $descriptor ref)

        (i32.atomic.store
            global($OFFSET_MALLOC_LENGTH)
            global($PREALLOC_LENGTH)
        )

        (global.set $options        Object.assign(global($options) Object(local($options))))
        (global.set $concurrency    global($self.navigator.hardwareConcurrency))
        (global.set $stride         (i32.mul global($self.navigator.hardwareConcurrency) i32(16)))
        (global.set $kHurraType     Symbol.for("kType"))
        (global.set $kReference     Symbol.for("kLink"))

        update($__proto__ 
            global($Number) 
            global($self.Number).prototype
        )

        global($HURRA.__proto__ 
            Object.create(
                global($HURRA).__proto__
            )
        )

        local($descriptor Object())

        Reflect.set(
            local($descriptor)
            text('value')
            text('HURRA')
        )

        Reflect.defineProperty(
            global($HURRA.__proto__)
            global($self.Symbol.toStringTag)
            local($descriptor)
        )

        Reflect.setPrototypeOf(
            global($HURRA)
            global($HURRA.__proto__)
        )
        
        Reflect.create(
            global($HURRA)
        )

        $define:MathOperator<ref.fun.i32>(text('add')     func($add)     global($ADD))
        $define:MathOperator<ref.fun.i32>(text('sub')     func($sub)     global($SUB))
        $define:MathOperator<ref.fun.i32>(text('mul')     func($mul)     global($MUL))
        $define:MathOperator<ref.fun.i32>(text('div')     func($div)     global($DIV))
        $define:MathOperator<ref.fun.i32>(text('max')     func($max)     global($MAX))
        $define:MathOperator<ref.fun.i32>(text('min')     func($min)     global($MIN))
        $define:MathOperator<ref.fun.i32>(text('eq')      func($eq)      global($EQ))
        $define:MathOperator<ref.fun.i32>(text('ne')      func($ne)      global($NE))
        $define:MathOperator<ref.fun.i32>(text('lt')      func($lt)      global($LT))
        $define:MathOperator<ref.fun.i32>(text('gt')      func($gt)      global($GT))
        $define:MathOperator<ref.fun.i32>(text('le')      func($le)      global($LE))
        $define:MathOperator<ref.fun.i32>(text('ge')      func($ge)      global($GE))
        $define:MathOperator<ref.fun.i32>(text('floor')   func($floor)   global($FLOOR))
        $define:MathOperator<ref.fun.i32>(text('trunc')   func($trunc)   global($TRUNC))
        $define:MathOperator<ref.fun.i32>(text('ceil')    func($ceil)    global($CEIL))
        $define:MathOperator<ref.fun.i32>(text('nearest') func($nearest) global($NEAREST))
        $define:MathOperator<ref.fun.i32>(text("new")     func($new)     global($NEW))

        
        $create:PrototypeAndType<ref.i32>(global($self.Uint8Array) global($Uint8Array))
        $create:PrototypeAndType<ref.i32>(global($self.Uint32Array) global($Uint32Array))
        $create:PrototypeAndType<ref.i32>(global($self.Float32Array) global($Float32Array))

        $create:ValuesLengthType<ref.i32>(text('SINGLE_VALUE') global($SINGLE_VALUE))
        $create:ValuesLengthType<ref.i32>(text('EXACT_LENGTH') global($EXACT_LENGTH))
        $create:ValuesLengthType<ref.i32>(text('ZERO_UNIFORM') global($ZERO_UNIFORM))
    )

    (func $define:MathOperator<ref.fun.i32>
        (param $name externref)
        (param $func funcref)
        (param $type i32)
        (local $descriptor ref)
        (local $prototype ref)
        (local $__proto__ ref)
        (local $kHurraType ref)

        (local.set $descriptor (new $self.Object))
        
        Reflect.set(
            local($descriptor) 
            text('value') 
            local($name)
        )

        $self.Reflect.defineProperty<fun.ref.ref>(
            local($func) 
            text('name') 
            local($descriptor)
        )

        $self.Reflect.set<ref.ref.i32>(
            local($descriptor) 
            text('value') 
            local($type)
        )

        $self.Reflect.set<ref.ref.fun>(
            global($HURRA) 
            local($name) 
            local($func)
        )

        $self.Reflect.set<ref.ref.i32>(
            local($descriptor) 
            text('value') 
            local($type)
        )

        (local.set $kHurraType       new($self.Number<i32>ref local($type)))
        (local.set $name        apply($self.String:toUpperCase local($name)))
        (local.set $prototype   local($kHurraType).__proto__)
        (local.set $__proto__   Object.create(local($prototype)))

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($name)
        )

        Reflect.defineProperty(
            local($__proto__)
            global($self.Symbol.toStringTag)
            local($descriptor)
        )

        Reflect.setPrototypeOf(
            local($kHurraType) 
            local($__proto__)
        )

        Reflect.create(
            local($kHurraType)
        )

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($kHurraType)
        )

        Reflect.defineProperty(
            global($HURRA.__proto__) 
            local($name) 
            local($descriptor)
        )

        $self.Reflect.defineProperty<fun.ref.ref>(
            local($func) 
            global($kHurraType) 
            local($descriptor)
        )

        update($__kTYPE__ 
            local($type) 
            local($kHurraType)
        )
    )

    (func $create:ValuesLengthType<ref.i32>
        (param $name ref)
        (param $type i32)

        (local $__kTYPE__   ref)
        (local $__proto__   ref)
        (local $kHurraType       ref)
        (local $prototype   ref)
        (local $descriptor  ref)

        (local.set $__kTYPE__   new($self.Number<i32>ref local($type)))
        (local.set $prototype   local($__kTYPE__).__proto__)
        (local.set $__proto__   Object.create(local($prototype)))
        (local.set $descriptor  Object())

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($name)
        )

        Reflect.defineProperty(
            local($__proto__) 
            global($self.Symbol.toStringTag) 
            local($descriptor)
        )

        Reflect.setPrototypeOf(
            local($__kTYPE__) 
            local($__proto__)
        )
        
        Reflect.create(
            local($__kTYPE__)
        )

        update($__kTYPE__ 
            local($type) 
            local($__kTYPE__)
        )
    )

    (func $create:PrototypeAndType<ref.i32>
        (param $SelfGlobal ref)
        (param $kHurraTypeValue i32)

        (local $__kTYPE__   ref)
        (local $__proto__   ref)
        (local $kHurraType       ref)
        (local $name        ref)
        (local $prototype   ref)
        (local $descriptor  ref)

        (local.set $__kTYPE__   new($self.Number<i32>ref local($kHurraTypeValue)))
        (local.set $prototype   local($__kTYPE__).__proto__)
        (local.set $name        local($SelfGlobal).name)
        (local.set $__proto__   Object.create(local($prototype)))
        (local.set $descriptor  Object())

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($name)
        )

        Reflect.defineProperty(
            local($__proto__) 
            global($self.Symbol.toStringTag) 
            local($descriptor)
        )

        update($__proto__ 
            local($kHurraTypeValue) 
            local($__proto__)
        )

        (local.set $name        apply($self.String:toUpperCase local($name)))
        (local.set $__proto__   Object.create(local($prototype)))
        (local.set $descriptor  Object())

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($name)
        )

        Reflect.defineProperty(
            local($__proto__) 
            global($self.Symbol.toStringTag) 
            local($descriptor)
        )

        Reflect.setPrototypeOf(
            local($__kTYPE__) 
            local($__proto__)
        )
        
        Reflect.create(
            local($__kTYPE__)
        )

        Reflect.set(
            local($descriptor) 
            text('value') 
            local($__kTYPE__)
        )

        Reflect.defineProperty(
            local($SelfGlobal) 
            global($kHurraType) 
            local($descriptor)
        )

        Reflect.defineProperty(
            local($SelfGlobal).prototype 
            global($kHurraType) 
            local($descriptor)
        )

        Reflect.defineProperty(
            global($HURRA.__proto__) 
            local($name) 
            local($descriptor)
        )

        update($__kTYPE__ 
            local($kHurraTypeValue) 
            local($__kTYPE__)
        )
    )

    (func $calc 
        (param $optype i32)
        (param $source ref)
        (param $values ref)
        (param $target ref)

        (result $task ref)

        (local $dataType i32)
        (local $operandType i32)

        (local $epoch f32)
        (local $length i32)
        (local $offset/source i32)
        (local $offset/values i32)
        (local $offset/target i32)

        (local.set $source $import(local($source) null true))
        (local.set $values $import(local($values) local($source) true))
        (local.set $target $import(local($target) local($source) false))

        (local.set $epoch         $self.performance.now<>f32())
        (local.set $operandType   $operandType<ref.ref>i32(local($values) local($target)))
        (local.set $dataType      $TypedArray:kType<ref>i32(local($source)))
        (local.set $length        $TypedArray:bufferSize<ref>i32(local($values)))
        (local.set $offset/source $TypedArray:byteOffset<ref>i32(local($source)))
        (local.set $offset/values $TypedArray:byteOffset<ref>i32(local($values)))
        (local.set $offset/target $TypedArray:byteOffset<ref>i32(local($target)))

        (warn<f32.i32x4.refx3> 
            local($epoch)
            local($length)
            local($offset/source)
            local($offset/values)
            local($offset/target)
            select($__kTYPE__ local($optype))
            select($__kTYPE__ local($dataType))
            select($__kTYPE__ local($operandType))
        )  

        null
    )

    (func $import
        (param $bufferView ref)
        (param $sourceView ref)
        (param $isntTarget i32)
        (result ref)
        
        (local $mallocView ref)
        (local $isNotArray i32)
        (local $descriptor ref)
        (local $hasSrcView i32)

        (local.set $isNotArray ArrayBuffer.isView(this) === false)
        (local.set $hasSrcView local($sourceView) !== null)

        (if local($hasSrcView)
            (; target or values checking ;)
            (then
                (if local($isntTarget)
                    (; values view check -- same buffer with zero length of source ;)
                    (then
                        (if local($isNotArray)
                            (then 
                                (local.set $bufferView 
                                    (apply $self.TypedArray:subarray<i32x2>ref
                                        local($sourceView) (param i32(0) i32(0))
                                    )
                                )
                            )
                        )
                    )
                    (; target view check -- no clone needed make it source ;)
                    (else
                        (if local($isNotArray)
                            (then (local.set $bufferView local($sourceView)))
                        )
                    )
                )
            )
            (; source is checking ;)
            (else (if local($isNotArray) (then unreachable)))
        )

        (if Object.is(
                global($buffer) 
                $TypedArray:buffer<ref>ref(local($bufferView))
            )
            (then local($bufferView) return)
        )

        (local.set $mallocView
            (call $new
                local($bufferView).constructor
                local($bufferView).length
                false
            )
        )

        (local.set $descriptor Object())

        Reflect.set(
            local($descriptor)
            text('value')
            local($bufferView)
        )

        Reflect.defineProperty(
            local($mallocView) 
            global($kReference)
            local($descriptor)
        )

        (if (local.get $isntTarget)
            (then
                (apply $self.TypedArray:set<ref>
                    local($mallocView) (param local($bufferView))
                )
            )
        )

        local($mallocView)
    )

    (func $align
        (param $byteLength i32)
        (result i32)
        (local $remainder i32)

        (if (i32.le_u local($byteLength) global($stride))
            (then global($stride) return)
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

    (func $malloc
        (param $byteLength i32)
        (result i32)
        (local $bufferSize i32)
        (local $byteOffset i32)

        (local.set $bufferSize
            $align(
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

    (type $math    (func (param externref externref externref) (result externref)))

    (func $add     (export "add")     (type $math) (call $calc global($ADD)     local(0) local(1) local(2)))
    (func $sub     (export "sub")     (type $math) (call $calc global($SUB)     local(0) local(1) local(2)))
    (func $mul     (export "mul")     (type $math) (call $calc global($MUL)     local(0) local(1) local(2)))
    (func $div     (export "div")     (type $math) (call $calc global($DIV)     local(0) local(1) local(2)))
    (func $max     (export "max")     (type $math) (call $calc global($MAX)     local(0) local(1) local(2)))
    (func $min     (export "min")     (type $math) (call $calc global($MIN)     local(0) local(1) local(2)))
    (func $eq      (export "eq")      (type $math) (call $calc global($EQ)      local(0) local(1) local(2)))
    (func $ne      (export "ne")      (type $math) (call $calc global($NE)      local(0) local(1) local(2)))
    (func $lt      (export "lt")      (type $math) (call $calc global($LT)      local(0) local(1) local(2)))
    (func $gt      (export "gt")      (type $math) (call $calc global($GT)      local(0) local(1) local(2)))
    (func $le      (export "le")      (type $math) (call $calc global($LE)      local(0) local(1) local(2)))
    (func $ge      (export "ge")      (type $math) (call $calc global($GE)      local(0) local(1) local(2)))
    (func $floor   (export "floor")   (type $math) (call $calc global($FLOOR)   local(0)   null   local(1)))
    (func $trunc   (export "trunc")   (type $math) (call $calc global($TRUNC)   local(0)   null   local(1)))
    (func $ceil    (export "ceil")    (type $math) (call $calc global($CEIL)    local(0)   null   local(1)))
    (func $nearest (export "nearest") (type $math) (call $calc global($NEAREST) local(0)   null   local(1)))
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
            $align(
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
                    global($OFFSET_MALLOC_LENGTH) 
                    local($bufferSize)
                )
            )
        )
        
        (local.set $typedArray
            Reflect.construct(
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

    (func $TypedArray:BYTES_PER_ELEMENT<ref>i32
        (param $this# ref) (result i32) (get <refx2>i32 this text('BYTES_PER_ELEMENT'))
    )

    (func $TypedArray:buffer<ref>ref
        (param $this# ref) (result ref)
        
        $self.Reflect.apply<refx3>ref(
            global($self.TypedArray:buffer/get) 
            this 
            self
        )
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

    (func $TypedArray:bufferSize<ref>i32
        (param $this# ref) (result i32)
        (call $TypedArray:bufferSize<i32>i32 $TypedArray:byteOffset<ref>i32(this))
    )

    (func $TypedArray:bufferSize<i32>i32
        (param $this* i32) (result i32)
        (call $bufferSize<i32>i32 this)
    )

    (func $TypedArray:kType<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.get<refx2>i32 this global($kHurraType))
    )

    (func $TypedArray:kType<ref>ref
        (param $this# ref) (result ref)
        select($__kTYPE__ (call $TypedArray:kType<ref>i32 this))
    )

    (func $TypedArray:kType<ref.i32>
        (param $this# ref) (param $kHurraType i32)
        (call $TypedArray:kType<ref.ref> this select($__kTYPE__ local($kHurraType)))
    )

    (func $TypedArray:kType<ref.ref>
        (param $this# ref) (param $kHurraType ref)
        (call $self.Reflect.defineProperty<refx3>
            this 
            global($kHurraType)
            $self.Object.fromEntries<ref>ref(
                $self.Array.of<ref>ref(
                    $self.Array.of<ref.ref>ref(
                        text('value') local($kHurraType)
                    )
                )
            )
        )
    )

    (func $TypedArray:bufferType<ref>i32
        (param $this# ref) (result i32)
        (call $self.Reflect.get<refx2>i32 this global($kHurraType))
    )

    (func $operandType<ref.ref>i32
        (param $values ref)
        (param $target ref)
        (result i32)
        (call $operandType<i32.i32>i32
            (call $TypedArray:length<ref>i32 local($values))
            (call $TypedArray:length<ref>i32 local($target))
        )
    )

    (func $operandType<i32.i32>i32
        (param $values.length i32)
        (param $target.length i32)
        (result i32)
        (local $optype i32)

        (block $switch

            (local.set $optype global($ZERO_UNIFORM))
            (br_if $switch (i32.eqz local($values.length)))
            
            (local.set $optype global($SINGLE_VALUE))
            (br_if $switch (i32.eq local($values.length) i32(1)))

            (local.set $optype global($EXACT_LENGTH))
            (br_if $switch (i32.eq local($values.length) local($target.length)))

            (unreachable)
        )

        local($optype)
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