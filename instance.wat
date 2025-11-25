(module
    (memory 10 10)
    
    (data $wasm:mem "wasm://mem.wat")
    (data $wasm:cpu "wasm://cpu.wat")

    (global $onready mut extern)

    (func (export "init") (param ref)
        $wasm:mem<fun>(
            (func $on_memory_ready
                (param $instance ref)
                (local $exports  ref)
                (local $memory   ref)
                (local $init     ref)

                local($exports $self.Reflect.get<refx2>ref(local($instance) text("exports")))
                local($memory  $self.Reflect.get<refx2>ref(local($exports)  text("memory")))
                local($init    $self.Reflect.get<refx2>ref(local($exports)  text("init")))

                $self.Reflect.set<refx3>(
                    $self.Reflect.get<refx2>ref(local($exports) text('buffer')) 
                    text("value") 
                    $self.Reflect.get<refx2>ref(local($memory) text('buffer'))
                )

                $self.Reflect.apply<refx3>(
                    local($init) null $self.Array.of<ref>ref(global($onready))
                )
            )
        )

        (global.set $onready this)
    )
)