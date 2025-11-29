(module
    (memory 10 10)
    
    (data $wasm:mem   "wasm://mem.wat")

    (global $promise mut extern)
    (global $resolve mut extern)
    (global $imports new Object)
    (global $options new Object)
    
    (global $HURRA mut extern)

    (func (export "start") 
        (param $options              <Object>) 
        (result $promise            <Promise>)
        (local $promise/resolvers    <Object>)

        (local.set $promise/resolvers Promise.withResolvers())
        
        (global.set $options Object.assign(global($options) Object(local($options))))
        (global.set $promise Reflect.get(local($promise/resolvers) text('promise')))
        (global.set $resolve Reflect.get(local($promise/resolvers) text('resolve')))        

        $wasm:mem<fun>(
            func($on_memory_instance_start)
        )

        global($promise)
    )


    (func $on_memory_instance_ready
        (param $HURRA           <Object>)
        (global.set $HURRA local($HURRA))

        $self.Reflect.apply<refx3>(
            global($resolve) 
            global($promise) 
            Array.of(
                global($HURRA)
            )
        )
    )

    (; memory module initial state, call init and wait for async ;)
    (func $on_memory_instance_start
        (param $instance             <Instance>)
        (local $exports                <Object>)
        (local $memory                 <Memory>)
        (local $buffer      <SharedArrayBuffer>)
        (local $start                <Function>)

        local($exports Reflect.get(local($instance) text("exports")))
        local($memory  Reflect.get(local($exports)  text("memory")))
        local($buffer  Reflect.get(local($memory)   text("buffer")))
        local($start   Reflect.get(local($exports)  text("start")))

        Reflect.set(
            Reflect.get(local($exports) text('buffer')) text("value") 
            Reflect.get(local($memory) text('buffer'))
        )

        Reflect.set(global($options) text('memory') local($memory))
        Reflect.set(global($options) text('buffer') local($buffer))

        (; call memory init function with callback ;)
        $self.Reflect.apply<refx3>(
            local($start)
            null
            $self.Array.of<ref.fun>ref(
                (; options came from here -> module.instance.exports.init( {options} ) ;)
                global($options)
                (; memory dispatched our callback ;)
                func($on_memory_instance_ready)
            )
        )
    )
)