
    (table $func_table 65536 funcref)

    (func $set_handlers<>
        (table.set $func_table i32(0) func($void))
        (call $set_handlers_f32<>)
    )

    (include "handlers_worker_f32.wat")
    