(module
    (memory 10 10)
    
    (data $wasm:memory   "wasm://memory.wat")

    (global $promise mut extern)
    (global $resolve mut extern)
    (global $imports new Object)
    (global $options new Object)
    
    (global $HURRA mut extern)

    (func 
        (export "start") 
        (param  $options              <Object>) 
        (result $promise             <Promise>)
        (local  $promise/resolvers    <Object>)

        (local.set $promise/resolvers 
            $self.Promise.withResolvers<>ref()
        )
        
        (global.set $options $self.Object.assign<ref.ref>ref(global($options) Object(local($options))))
        (global.set $promise $self.Reflect.get<ref.ref>ref(local($promise/resolvers) text('promise')))
        (global.set $resolve $self.Reflect.get<ref.ref>ref(local($promise/resolvers) text('resolve')))        

        $wasm:memory<fun>(
            func($on_memory_instance_start)
        )

        global($promise)
    )


    (func $on_memory_instance_ready
        (param $HURRA           <Object>)

        (global.set $HURRA local($HURRA))

        $self.Reflect.apply<ref.ref.ref>(
            global($resolve) 
            global($promise) 
            $self.Array.of<ref>ref(
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

        local($exports $self.Reflect.get<ref.ref>ref(local($instance) text("exports")))
        local($memory  $self.Reflect.get<ref.ref>ref(local($exports)  text("memory")))
        local($buffer  $self.Reflect.get<ref.ref>ref(local($memory)   text("buffer")))
        local($start   $self.Reflect.get<ref.ref>ref(local($exports)  text("start")))

        $self.Reflect.set<ref.ref.ref>(
            $self.Reflect.get<ref.ref>ref(local($exports) text('buffer')) 
            text("value") 
            $self.Reflect.get<ref.ref>ref(local($memory) text('buffer'))
        )

        $self.Reflect.set<ref.ref.ref>(global($options) text('memory') local($memory))
        $self.Reflect.set<ref.ref.ref>(global($options) text('buffer') local($buffer))

        (; call memory init function with callback ;)
        $self.Reflect.apply<ref.ref.ref>(
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