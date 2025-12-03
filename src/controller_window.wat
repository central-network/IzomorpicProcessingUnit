
    (func $delete_self_symbols<>
        (call $self.Reflect.deleteProperty<ref.ref> global($self.Uint8Array)   (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> global($self.Uint16Array)  (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> global($self.Uint32Array)  (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> global($self.Float32Array) (call $get_self_symbol<>ref))
        (call $self.Reflect.deleteProperty<ref.ref> global($self.DataView)     (call $get_self_symbol<>ref))

        (call $self.Reflect.deleteProperty<fun.ref> func($this) (text 'create'))
        (call $self.Reflect.deleteProperty<fun.ref> func($this) (text 'destroy'))
        (call $self.Reflect.deleteProperty<fun.ref> func($this) (text 'memory'))
    )

    (func $get_self_symbol<>ref
        (result ref)

        (if (ref.is_null global($kSymbol))
            (then
                (global.set $kSymbol 
                    (call $self.Symbol<ref>ref 
                        global($kSymbol.tag)
                    )
                )
            )
        )

        global($kSymbol)
    )

    (func $get_self_symbol<ref>i32
        (param $this ref)
        (result i32)
        (call $self.Reflect.get<ref.ref>i32 local($this) (call $get_self_symbol<>ref))
    )

    (func $define_self_symbols<>
        (call $define_property<ref.ref.i32> global($self.Uint8Array)   (call $get_self_symbol<>ref) global($TYPE_Uint8))
        (call $define_property<ref.ref.i32> global($self.Uint16Array)  (call $get_self_symbol<>ref) global($TYPE_Uint16))
        (call $define_property<ref.ref.i32> global($self.Uint32Array)  (call $get_self_symbol<>ref) global($TYPE_Uint32))
        (call $define_property<ref.ref.i32> global($self.Float32Array) (call $get_self_symbol<>ref) global($TYPE_Float32))
        (call $define_property<ref.ref.i32> global($self.DataView)     (call $get_self_symbol<>ref) global($TYPE_DataView))
        
        (call $define_property<fun.ref.ref> func($this) (text 'threads') global($worker.threads))
        (call $define_property<fun.ref.ref> func($this) (text 'memory') (call $get_memory<>ref))
        (call $define_property<fun.ref.fun> func($this) (text 'create') func($create))
        (call $define_property<fun.ref.fun> func($this) (text 'destroy') func($destroy))
        (call $define_property<fun.ref.fun> func($this) (text 'malloc') func($malloc))

        (call $self.Reflect.setPrototypeOf<fun.ref> func($this) null)
        (call $self.Reflect.deleteProperty<fun.ref> func($this) (text 'length'))
        (call $self.Reflect.deleteProperty<fun.ref> func($this) (text 'name'))
    )

    (func $define_property<ref.ref.i32>
        (param $ref ref)
        (param $key ref)
        (param $val i32)
        
        (call $self.Reflect.defineProperty<ref.ref.ref>
            local($ref) 
            local($key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref>ref
                    (call $self.Array.of<ref.i32>ref text('value') local($val))
                    (call $self.Array.of<ref.i32>ref text('configurable') true)
                )
            )
        )
    )

    (func $define_property<fun.ref.i32>
        (param $ref funcref)
        (param $key ref)
        (param $val i32)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            local($ref) 
            local($key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref>ref
                    (call $self.Array.of<ref.i32>ref text('value') local($val))
                    (call $self.Array.of<ref.i32>ref text('configurable') true)
                )
            )
        )
    )

    (func $define_property<fun.ref.fun>
        (param $ref funcref)
        (param $key ref)
        (param $val funcref)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            local($ref) 
            local($key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref.ref>ref
                    (call $self.Array.of<ref.fun>ref text('value') local($val))
                    (call $self.Array.of<ref.i32>ref text('enumerable') true)
                    (call $self.Array.of<ref.i32>ref text('configurable') true)
                )
            )
        )
    )

    (func $define_property<fun.ref.ref>
        (param $ref funcref)
        (param $key ref)
        (param $val ref)
        
        (call $self.Reflect.defineProperty<fun.ref.ref>
            local($ref) 
            local($key)
            (call $self.Object.fromEntries<ref>ref
                (call $self.Array.of<ref.ref.ref>ref
                    (call $self.Array.of<ref.ref>ref text('value') local($val))
                    (call $self.Array.of<ref.i32>ref text('enumerable') true)
                    (call $self.Array.of<ref.i32>ref text('configurable') true)
                )
            )
        )
    )