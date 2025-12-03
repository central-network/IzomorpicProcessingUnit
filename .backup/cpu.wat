(module
    (import "self" "memory" (memory $memory 100 65536 shared))
    (import "self" "postMessage" (func $postMessage (param i32)))

    (include "const.wat")

    (global $worker_count   (mut i32)  (i32.const 0))
    (global $worker_index   (mut i32)  (i32.const 0))
    (global $worker_offset  (mut v128) (v128.const i32x4 0 0 0 0))
    (global $loop_iterator  (mut v128) (v128.const i32x4 0 0 0 0))

    (table $func 3000 funcref)
    
    (start $loop
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
   
    (global $void i32 false)    
   
    (elem $func
        funcref
        (ref.func $void)
        (ref.func $Float32Array.ADD.N.S)
        (ref.func $Float32Array.ADD.1.S)
        (ref.func $Float32Array.MUL.N.S)
        (ref.func $Float32Array.MUL.1.S)
        (ref.func $Float32Array.DIV.N.S)
        (ref.func $Float32Array.DIV.1.S)
        (ref.func $Float32Array.SUB.N.S)
        (ref.func $Float32Array.SUB.1.S)
        (ref.func $Float32Array.MAX.N.S)
        (ref.func $Float32Array.MAX.1.S)
        (ref.func $Float32Array.MIN.N.S)
        (ref.func $Float32Array.MIN.1.S)
        (ref.func $Float32Array.EQ.N.S)
        (ref.func $Float32Array.EQ.1.S)
        (ref.func $Float32Array.NE.N.S)
        (ref.func $Float32Array.NE.1.S)
        (ref.func $Float32Array.LT.N.S)
        (ref.func $Float32Array.LT.1.S)
        (ref.func $Float32Array.GT.N.S)
        (ref.func $Float32Array.GT.1.S)
        (ref.func $Float32Array.LE.N.S)
        (ref.func $Float32Array.LE.1.S)
        (ref.func $Float32Array.GE.N.S)
        (ref.func $Float32Array.GE.1.S)
        (ref.func $Float32Array.FLOOR.0.S)
        (ref.func $Float32Array.TRUNC.0.S)
        (ref.func $Float32Array.CEIL.0.S)
        (ref.func $Float32Array.NEAREST.0.S)
    )

    (func $init
        (local $stride i32)
        (local $count i32)
        (local $index i32)
        (local $offset i32)

        ;; Get Worker Index
        (local.set $index (call $new_worker_index))
        (global.set $worker_index (local.get $index))

        ;; Get Worker Count & Stride
        (local.set $count (i32.atomic.load (global.get $OFFSET_WORKER_COUNT)))
        (local.set $stride (i32.mul (local.get $count) (i32.const 16)))
        
        ;; Calculate Initial Worker Offset (Index * 16)
        (local.set $offset (i32.mul (local.get $index) (i32.const 16)))

        ;; Prepare Worker Offset Vector: [0, Offset, Offset, Offset]
        ;; User specified: First lane is 0 (Length is shared), others are Offset.
        (global.set $worker_offset 
            (i32x4.replace_lane 0
                (i32x4.splat (local.get $offset))
                (i32.const 0)
            )
        )

        ;; Prepare Loop Iterator: [-Stride, Stride, Stride, Stride]
        (global.set $loop_iterator
            (i32x4.replace_lane 0
                (i32x4.splat (local.get $stride))
                (i32.sub (i32.const 0) (local.get $stride))
            )
        )

        (table.set $func (global.get $void)                      (ref.func $void))
        (table.set $func (global.get $Float32Array.ADD.N.S)      (ref.func $Float32Array.ADD.N.S))
        (table.set $func (global.get $Float32Array.MUL.N.S)      (ref.func $Float32Array.MUL.N.S))
        (table.set $func (global.get $Float32Array.DIV.N.S)      (ref.func $Float32Array.DIV.N.S))
        (table.set $func (global.get $Float32Array.SUB.N.S)      (ref.func $Float32Array.SUB.N.S))
        (table.set $func (global.get $Float32Array.MAX.N.S)      (ref.func $Float32Array.MAX.N.S))
        (table.set $func (global.get $Float32Array.MIN.N.S)      (ref.func $Float32Array.MIN.N.S))
        (table.set $func (global.get $Float32Array.EQ.N.S)       (ref.func $Float32Array.EQ.N.S))
        (table.set $func (global.get $Float32Array.NE.N.S)       (ref.func $Float32Array.NE.N.S))
        (table.set $func (global.get $Float32Array.LT.N.S)       (ref.func $Float32Array.LT.N.S))
        (table.set $func (global.get $Float32Array.GT.N.S)       (ref.func $Float32Array.GT.N.S))
        (table.set $func (global.get $Float32Array.LE.N.S)       (ref.func $Float32Array.LE.N.S))
        (table.set $func (global.get $Float32Array.GE.N.S)       (ref.func $Float32Array.GE.N.S))

        (table.set $func (global.get $Float32Array.ADD.1.S)      (ref.func $Float32Array.ADD.1.S))
        (table.set $func (global.get $Float32Array.MUL.1.S)      (ref.func $Float32Array.MUL.1.S))
        (table.set $func (global.get $Float32Array.DIV.1.S)      (ref.func $Float32Array.DIV.1.S))
        (table.set $func (global.get $Float32Array.SUB.1.S)      (ref.func $Float32Array.SUB.1.S))
        (table.set $func (global.get $Float32Array.MAX.1.S)      (ref.func $Float32Array.MAX.1.S))
        (table.set $func (global.get $Float32Array.MIN.1.S)      (ref.func $Float32Array.MIN.1.S))
        (table.set $func (global.get $Float32Array.EQ.1.S)       (ref.func $Float32Array.EQ.1.S))
        (table.set $func (global.get $Float32Array.NE.1.S)       (ref.func $Float32Array.NE.1.S))
        (table.set $func (global.get $Float32Array.LT.1.S)       (ref.func $Float32Array.LT.1.S))
        (table.set $func (global.get $Float32Array.GT.1.S)       (ref.func $Float32Array.GT.1.S))
        (table.set $func (global.get $Float32Array.LE.1.S)       (ref.func $Float32Array.LE.1.S))
        (table.set $func (global.get $Float32Array.GE.1.S)       (ref.func $Float32Array.GE.1.S))

        (table.set $func (global.get $Float32Array.FLOOR.0.S)    (ref.func $Float32Array.FLOOR.0.S))
        (table.set $func (global.get $Float32Array.TRUNC.0.S)    (ref.func $Float32Array.TRUNC.0.S))
        (table.set $func (global.get $Float32Array.CEIL.0.S)     (ref.func $Float32Array.CEIL.0.S))
        (table.set $func (global.get $Float32Array.NEAREST.0.S)  (ref.func $Float32Array.NEAREST.0.S))     

        (call $postMessage i32(0))   
    )

    (func $exit
        (i32.atomic.rmw.sub (global.get $OFFSET_ACTIVE_WORKERS) (i32.const 1)) 
        (drop)
    )

    (func $wait
        (result i32)
        (memory.atomic.wait32 (global.get $OFFSET_WORKER_MUTEX) (i32.const 0) (i64.const -1))
    )

    (func $next
        (result i32)

        (if (i32.atomic.load (global.get $OFFSET_ZERO))
            (then (return (i32.const 0)))
        )

        (if (i32.eq
                (i32.atomic.rmw.add 
                    (global.get $OFFSET_LOCKED_WORKERS) 
                    (i32.const 1) 
                )
                (i32.sub (i32.atomic.load (global.get $OFFSET_ACTIVE_WORKERS)) (i32.const 1))
            )
            (then (call $signal))
        )

        (i32.const 1)
    )

    (func $signal
        (memory.atomic.notify (global.get $OFFSET_ACTIVE_WORKERS) (i32.const 1))
        (drop)
    )

    (func $get_offsets
        (result v128)
        
        ;; Load Task Vector [Length, Source, Values, Target]
        ;; Add Worker Offset Vector [-Offset, Offset, Offset, Offset]
        (i32x4.add
            (v128.load (global.get $OFFSET_TASK_VECTOR))
            (global.get $worker_offset)
        )
    )

    ;; $get_operand removed (obsolete)

    (func $func
        (result i32)
        (i32.atomic.load (i32.const 12))
    )

    (func $void
        nop
    )

    (func $Float32Array.ADD.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.ADD.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MUL.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MUL.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.DIV.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.DIV.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.SUB.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.SUB.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MAX.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MAX.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MIN.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.MIN.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.EQ.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.EQ.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LT.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LT.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GT.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GT.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.LE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GE.N.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.GE.1.S
        (local $offsets v128)
        (local $operand v128)
        (local $uniform v128)

        (local.set $offsets (call $get_offsets))
        (local.set $uniform (call $get_uniform/32))
    
        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
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
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.FLOOR.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.floor (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.TRUNC.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.trunc (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.CEIL.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.ceil (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
                        )
                    )

                    (br $i)
                )
            )
        )
    )

    (func $Float32Array.NEAREST.0.S
        (local $offsets v128)
        (local $operand v128)

        (local.set $offsets (call $get_offsets))

        (loop $i
            (if (i32.gt_s (i32x4.extract_lane 0 (local.get $offsets)) (i32.const 0))
                (then
                    (v128.store (i32x4.extract_lane 1 (local.get $offsets))
                        (f32x4.nearest (v128.load (i32x4.extract_lane 2 (local.get $offsets))))
                    )

                    (local.set $offsets 
                        (i32x4.add 
                            (local.get $offsets) 
                            (global.get $loop_iterator)
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

    (func $new_worker_index
        (result i32)
        (i32.atomic.rmw.add (global.get $OFFSET_WORKER_INDEX_COUNTER) (i32.const 1))
    )

    (func $get_uniform/32
        (result v128)
        (v128.load32_splat (i32.atomic.load (global.get $OFFSET_VALUES_PTR)))
    )
)