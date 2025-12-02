(module
    (memory 1)
    
    (include "shared.wat")
    (compile "worker.wat"
        (data $worker/buffer)
        (global $worker/length i32)
    )

    (include "controller_worker.wat")
    (include "controller_memory.wat")
    (include "controller_window.wat")
    (include "headers_io_window.wat")
    (include "handlers_window.wat")

    (global $DEFAULT_MEMORY_INITIAL     i32 i32(10))
    (global $DEFAULT_MEMORY_MAXIMUM  i32 i32(65535))
    (global $DEFAULT_MEMORY_SHARED         i32 true)

    (global $sigint                         mut i32)
    (global $module                      mut extern)
    (global $memory                      mut extern)
    (global $buffer                      mut extern)

    (global $i32View                     mut extern)
    (global $dataView                    mut extern)
    (global $kSymbol                     mut extern)
    (global $kSymbol.tag               'kArrayType')

    (global $self.DataView                externref)
    (global $self.Uint8Array              externref)
    (global $self.Uint16Array             externref)
    (global $self.Uint32Array             externref)
    (global $self.Float32Array            externref)
    
    (global $self.navigator.deviceMemory        i32)
    (global $self.navigator.hardwareConcurrency i32)

    (func $this (export "this"))

    (func $create 
        (param $workerCount i32)

        (if (0 === local($workerCount))
            (then (local.set $workerCount global($self.navigator.hardwareConcurrency)))
        )

        (call $define_self_symbols<>)
        (call $create_memory_links<>)
        
        (call $reset_memory_values<i32>
            local($workerCount)
        )    
        
        (apply $self.Promise.prototype.then<fun>
            (call $create_wait_promise<>ref)
            (param func($onlastworkeropen<>))
        )

        (call $create_worker_threads<>)
    )

    (func $destroy 
        (call $set_ready_state<i32>
            global($READY_STATE_CLOSING)
        )

        (call $delete_self_symbols<>)
        (call $terminate_all_workers<>)

        (call $set_ready_state<i32>
            global($READY_STATE_CLOSED)
        )

        (call $remove_extern_globals<>)
    )
    
    (func $remove_extern_globals<>
        (global.set $i32View        null)
        (global.set $dataView       null)
        (global.set $buffer         null)    
        (global.set $memory         null)
        (global.set $module         null)
        (global.set $worker.URL     null)
        (global.set $worker.data    null)
        (global.set $worker.config  null)
        (global.set $kSymbol        null)
    )

    (start $init (call $create false))
)   