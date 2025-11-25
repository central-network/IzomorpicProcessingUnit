
    (include "const.wat")

    (global $kType mut extern)
    (global $buffer mut extern)
    
    (global $stride mut i32)
    (global $concurrency mut i32)

    (func $kTypeOf
        (param $any ref)
        (result i32)
        (get <ref.ref>i32 this global($kType))
    )
