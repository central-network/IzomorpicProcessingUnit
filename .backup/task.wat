(module
    (import "self" "memory" (memory $malloc 100 65536 shared))
    (import "self" "memory" (global $memory externref))
    (import "self" "buffer" (global $buffer externref))

    (data $cpu.wat "wasm://cpu.wat")

    (global $options new Object)
    (global $onready mut extern)

    (global $js "onmessage = e => self.Object.assign(self,e.data).WebAssembly.instantiate(wasm,self).then(close)")
    (global $url mut extern)
    (global $data new Object)
    (global $config new Object)
    (global $workers new Array)

    (global $stride       mut i32)
    (global $concurrency  mut i32)
    (global $worker_count mut i32)

    (func (export "start")
        (param $options   <Object>)
        (param $onready <Function>)

        (global.set $options Object.assign(global($options) local($options)))
        (global.set $onready local($onready))

        $configure()
        $spawn:cpu()
    )

    (func $spawn:cpu
        (local $i i32)
        (local.set $i $get_worker_count())

        (if (local.get $i)
            (then
                (loop $fork $fork:cpu()
                    (br_if $fork tee($i local($i)--))
                )
            )
        )
    )

    (func $configure
        (global.set $url 
            URL.createObjectURL(
                new Blob(Array.of(global($js))) 
            ) 
        )

        (global.set $concurrency
            $self.Reflect.get<ref.ref>i32(
                global($options) text('concurrency')
            )
        )

        (if (i32.eqz global($concurrency))
            (then unreachable)
        )
        
        Reflect.set(
            global($data) text('memory') global($memory)
        )

        $set_worker_count(
            global($concurrency)
        )
    )

    (func $onmessage
        (param $taskid i32)
        (log<i32> this)
    )

    (func $onopen
        (param $event <MessageEvent>)
        (local $worker <Worker>)

        (local.set $worker
            Reflect.get(this text('target'))
        )

        (log<ref> local($worker))

        (apply $self.addEventListener<ref.fun>
            local($worker) (param text('message') func($onmessage))
        )

        (apply $self.removeEventListener<ref.fun>
            local($worker) (param text('message') func($onopen))
        )

        (apply $self.Array:push<ref>
            global($workers) (param local($worker))
        )
    )

    (func $fork:cpu
        (local $worker <Worker>)

        Reflect.set(global($data) text('wasm') global($cpu.wat))
        Reflect.set(global($config) text('name') text('cpu'))

        (local.set $worker
            new Worker(global($url) global($config))
        )

        (apply $self.addEventListener<ref.fun>
            local($worker) (param text('message') func($onopen))
        )

        (; send wasm module and memory ;)
        (apply $self.Worker:postMessage<ref>
            local($worker) (param global($data))
        )
    )

    (func $set_worker_count
        (param i32)

        (i32.store (i32.const 4) (local.get 0))
        (global.set $worker_count (local.get 0))
        (global.set $stride (i32.mul (local.get 0) (i32.const 16)))

        ;; substract vector for vec4(length + offsets)
        (call $set_operand
            (i32x4.mul 
                (v128.const i32x4 -1 1 1 1) 
                (i32x4.splat global($stride))
            )
        )
    )

    (;  (func (export "calc")
        (param $func i32)
        (param $length i32)
        (param $sourceOffset i32)
        (param $valuesOffset i32)
        (param $targetOffset i32)

        (call $set_func           (local.get $func))
        (call $set_length         (local.get $length))
        (call $set_target_offset  (local.get $targetOffset))
        (call $set_source_offset  (local.get $sourceOffset))
        (call $set_values_offset  (local.get $valuesOffset))

        (call $notify)
    )  ;)

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

    (func $get_length 
        (result i32)
        (i32.atomic.load (i32.const 16))
    )

    (func $set_length
        (param i32)

        (if (i32.rem_u (local.get 0) global($stride))
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