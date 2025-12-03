    (func $createMemory<i32.i32.i32>ref
        (param  $initial              i32) 
        (param  $maximum              i32) 
        (param  $shared               i32)
        (result $memory          <Memory>) 
        (local  $options         <Object>)

        (local.set $options
            $self.Object.fromEntries<ref>ref(
                $self.Array.of<ref.ref.ref>ref(
                    $self.Array.of<ref.i32>ref(text('initial') local($initial))
                    $self.Array.of<ref.i32>ref(text('maximum') local($maximum))
                    $self.Array.of<ref.i32>ref(text('shared') local($shared))
                )
            )
        )

        (new $self.WebAssembly.Memory<ref>ref
            local($options)
        )
    )