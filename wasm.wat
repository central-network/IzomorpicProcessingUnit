(module
    (import "self" "memory" (memory $memory 100 65536 shared))
    (import "self" "postMessage" (func $postMessage (param i32)))

    (global $worker_count   (mut i32)  (i32.const 0))
    (global $worker_index   (mut i32)  (i32.const 0))
    (global $worker_offset  (mut v128) (v128.const i32x4 0 0 0 0))

    (global $void           i32 (i32.const 0))
    (global $F_4_add_n      i32 (i32.const 1))
    (global $F_4_add_v      i32 (i32.const 2))
    (global $F_4_mul_n      i32 (i32.const 3))
    (global $F_4_mul_v      i32 (i32.const 4))
    (global $F_4_div_n      i32 (i32.const 5))
    (global $F_4_div_v      i32 (i32.const 6))
    (global $F_4_sub_n      i32 (i32.const 7))
    (global $F_4_sub_v      i32 (i32.const 8))
    (global $F_4_max_n      i32 (i32.const 9))
    (global $F_4_max_v      i32 (i32.const 10))
    (global $F_4_min_n      i32 (i32.const 11))
    (global $F_4_min_v      i32 (i32.const 12))
    (global $F_4_eq_n       i32 (i32.const 13))
    (global $F_4_eq_v       i32 (i32.const 14))
    (global $F_4_ne_n       i32 (i32.const 15))
    (global $F_4_ne_v       i32 (i32.const 16))
    (global $F_4_lt_n       i32 (i32.const 17))
    (global $F_4_lt_v       i32 (i32.const 18))
    (global $F_4_gt_n       i32 (i32.const 19))
    (global $F_4_gt_v       i32 (i32.const 20))
    (global $F_4_le_n       i32 (i32.const 21))
    (global $F_4_le_v       i32 (i32.const 22))
    (global $F_4_ge_n       i32 (i32.const 23))
    (global $F_4_ge_v       i32 (i32.const 24))
    (global $F_4_floor      i32 (i32.const 25))
    (global $F_4_trunc      i32 (i32.const 26))
    (global $F_4_ceil       i32 (i32.const 27))
    (global $F_4_nearest    i32 (i32.const 28))

    (table $func
        100 funcref
    )
    
    (start $loop
        i32(1) 
        call $postMessage
        call $init

        block $sigint
            loop $handle 
                call $wait br_if $sigint
                call $func call_indirect 
                call $next br_if $handle
            end
        end

        call $exit
    )
   
    (elem $func
        funcref
        (ref.func $void)
        (ref.func $F_4_add_n)
        (ref.func $F_4_add_v)
        (ref.func $F_4_mul_n)
        (ref.func $F_4_mul_v)
        (ref.func $F_4_div_n)
        (ref.func $F_4_div_v)
        (ref.func $F_4_sub_n)
        (ref.func $F_4_sub_v)
        (ref.func $F_4_max_n)
        (ref.func $F_4_max_v)
        (ref.func $F_4_min_n)
        (ref.func $F_4_min_v)
        (ref.func $F_4_eq_n)
        (ref.func $F_4_eq_v)
        (ref.func $F_4_ne_n)
        (ref.func $F_4_ne_v)
        (ref.func $F_4_lt_n)
        (ref.func $F_4_lt_v)
        (ref.func $F_4_gt_n)
        (ref.func $F_4_gt_v)
        (ref.func $F_4_le_n)
        (ref.func $F_4_le_v)
        (ref.func $F_4_ge_n)
        (ref.func $F_4_ge_v)
        (ref.func $F_4_floor)
        (ref.func $F_4_trunc)
        (ref.func $F_4_ceil)
        (ref.func $F_4_nearest)
    )

    (func $init
        (global.set $worker_index  (call $new_worker_index))
        (global.set $worker_offset (call $new_worker_offset))

        (table.set $func (global.get $void)         (ref.func $void))
        (table.set $func (global.get $F_4_add_n)    (ref.func $F_4_add_n))
        (table.set $func (global.get $F_4_add_v)    (ref.func $F_4_add_v))
        (table.set $func (global.get $F_4_mul_n)    (ref.func $F_4_mul_n))
        (table.set $func (global.get $F_4_mul_v)    (ref.func $F_4_mul_v))
        (table.set $func (global.get $F_4_div_n)    (ref.func $F_4_div_n))
        (table.set $func (global.get $F_4_div_v)    (ref.func $F_4_div_v))
        (table.set $func (global.get $F_4_sub_n)    (ref.func $F_4_sub_n))
        (table.set $func (global.get $F_4_sub_v)    (ref.func $F_4_sub_v))
        (table.set $func (global.get $F_4_max_n)    (ref.func $F_4_max_n))
        (table.set $func (global.get $F_4_max_v)    (ref.func $F_4_max_v))
        (table.set $func (global.get $F_4_min_n)    (ref.func $F_4_min_n))
        (table.set $func (global.get $F_4_min_v)    (ref.func $F_4_min_v))
        (table.set $func (global.get $F_4_eq_n)     (ref.func $F_4_eq_n))
        (table.set $func (global.get $F_4_eq_v)     (ref.func $F_4_eq_v))
        (table.set $func (global.get $F_4_ne_n)     (ref.func $F_4_ne_n))
        (table.set $func (global.get $F_4_ne_v)     (ref.func $F_4_ne_v))
        (table.set $func (global.get $F_4_lt_n)     (ref.func $F_4_lt_n))
        (table.set $func (global.get $F_4_lt_v)     (ref.func $F_4_lt_v))
        (table.set $func (global.get $F_4_gt_n)     (ref.func $F_4_gt_n))
        (table.set $func (global.get $F_4_gt_v)     (ref.func $F_4_gt_v))
        (table.set $func (global.get $F_4_le_n)     (ref.func $F_4_le_n))
        (table.set $func (global.get $F_4_le_v)     (ref.func $F_4_le_v))
        (table.set $func (global.get $F_4_ge_n)     (ref.func $F_4_ge_n))
        (table.set $func (global.get $F_4_ge_v)     (ref.func $F_4_ge_v))
        (table.set $func (global.get $F_4_floor)    (ref.func $F_4_floor))
        (table.set $func (global.get $F_4_trunc)    (ref.func $F_4_trunc))
        (table.set $func (global.get $F_4_ceil)     (ref.func $F_4_ceil))
        (table.set $func (global.get $F_4_nearest)  (ref.func $F_4_nearest))        
    )

    (func $exit
        (i32.atomic.rmw.sub (i32.const 8) (i32.const 1)) 
        (drop)
    )

    (func $wait
        (result i32)
        (memory.atomic.wait32 (i32.const 0) (i32.const 0) (i64.const -1))
    )

    (func $next
        (result i32)

        (if (i32.atomic.load (i32.const 0))
            (then (return (i32.const 0)))
        )

        (if (i32.eq
                (i32.atomic.rmw.sub 
                    (i32.const 8) 
                    (i32.const 1) 
                )
                (i32.const 1) 
            )
            (then (call $signal))
        )

        (i32.const 1)
    )

    (func $signal
    )

    (func $func
        (result i32)
        (i32.atomic.load (i32.const 12))
    )

    (func $void
        nop
    )

    (func $F_4_add_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_add_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.add 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_mul_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_mul_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.mul 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_div_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_div_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.div 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_sub_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_sub_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.sub 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_max_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_max_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.max 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_min_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_min_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.min 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_eq_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_eq_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.eq 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_ne_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_ne_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ne 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_lt_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_lt_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.lt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_gt_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_gt_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.gt 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_le_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_le_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.le 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_ge_n
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (v128.load (i32x4.extract_lane 3 (local.get $offsets)))
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_ge_v
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ge 
                            (v128.load (i32x4.extract_lane 2 (local.get $offsets)))
                            (local.get $uniform)
                        )
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_floor
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.floor (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_trunc
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.trunc (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_ceil
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ceil (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $F_4_nearest
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))
        (local.set $operand (call $get_operand))

        (loop $i
            (if (i32x4.extract_lane 0 (local.get $offsets))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.nearest (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (local.get $operand)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $get_lock_state
        (result i32)
        (i32.atomic.load (i32.const 0))
    )

    (func $set_lock_state
        (param i32)
        (i32.atomic.store (i32.const 0) (local.get 0))
    )

    (func $get_worker_count
        (result i32)
        (i32.atomic.load (i32.const 4))
    )

    (func $new_worker_index
        (result i32)
        (i32.atomic.rmw.add (i32.const 8) (i32.const 1))
    )

    (func $new_worker_offset
        (result v128)
        (i32x4.mul 
            (v128.const i32x4 0 16 16 16) 
            (i32x4.splat (global.get $worker_index))
        )
    )

    (func $get_stride
        (result i32)
        (i32.mul (global.get $worker_count) (i32.const 16))
    )

    (func $get_offsets
        (result v128)
        (i32x4.add 
            (v128.load (i32.const 16)) 
            (global.get $worker_offset)
        )
    )

    (func $get_length
        (result i32)
        (i32.atomic.load (i32.const 16))
    )

    (func $get_target_offset
        (result i32)
        (i32.atomic.load (i32.const 20))
    )

    (func $get_source_offset
        (result i32)
        (i32.atomic.load (i32.const 24))
    )

    (func $get_values_offset
        (result i32)
        (i32.atomic.load (i32.const 28))
    )

    (func $get_operand
        (result v128)
        (v128.load (i32.const 32))
    )

    (func $get_uniform/32
        (result v128)
        (v128.load32_splat (call $get_values_offset))
    )
)