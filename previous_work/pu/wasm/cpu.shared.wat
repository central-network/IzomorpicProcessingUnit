(module
    (import "0" "memory"                    (memory $memory 65536 65536 shared))
    (import "0" "mutexAddr"                 (global $mutexAddr i32))
    (import "0" "threadIndex"               (global $threadIndex i32))
    (import "0" "dataByteOffset"            (global $dataByteOffset i32))

    (import "0" "OFFSET_FUNC"               (global $OFFSET_FUNC i32))
    (import "0" "OFFSET_BPE"                (global $OFFSET_BPE i32))
    (import "0" "OFFSET_VALUE"              (global $OFFSET_VALUE/v128 i32))
    (import "0" "OFFSET_BYTES_PER_THREAD"   (global $OFFSET_BYTES_PER_THREAD/u32 i32))
    (import "0" "OFFSET_COUNT_PER_THREAD"   (global $OFFSET_COUNT_PER_THREAD/u32 i32))

    (import "0" "f32_add" (global $f32_add i32))
    (import "0" "f32_mul" (global $f32_mul i32))
    (import "0" "f32_sub" (global $f32_sub i32))
    (import "0" "f32_div" (global $f32_div i32))

    (import "0" "i32_add" (global $i32_add i32))
    (import "0" "i32_mul" (global $i32_mul i32))
    (import "0" "i32_sub" (global $i32_sub i32))

    (global $STATE/IDLE i32 (i32.const 0))
    (global $STATE/LOCK i32 (i32.const 1))
    (global $STATE/BUSY i32 (i32.const 2))
    
    (func $thread->works (result i32) (i32.atomic.load  offset=4 (global.get $mutexAddr)))
    (func $thread->btyes (result i32) (i32.atomic.load  offset=8 (global.get $mutexAddr)))
    (func $thread->flops (result i32) (i32.atomic.load offset=12 (global.get $mutexAddr)))
    (func $thread->cycle (result i32) (i32.atomic.load offset=16 (global.get $mutexAddr)))
    (func $thread->state (result i32) (i32.atomic.load offset=20 (global.get $mutexAddr)))

    (func $works->thread (param i32) (i32.atomic.store  offset=4 (global.get $mutexAddr) (local.get 0)))
    (func $bytes->thread (param i32) (i32.atomic.store  offset=8 (global.get $mutexAddr) (local.get 0)))
    (func $flops->thread (param i32) (i32.atomic.store offset=12 (global.get $mutexAddr) (local.get 0)))
    (func $cycle->thread (param i32) (i32.atomic.store offset=16 (global.get $mutexAddr) (local.get 0)))
    (func $state->thread (param i32) (i32.atomic.store offset=20 (global.get $mutexAddr) (local.get 0)))

    (func $value/BPE:1 (result v128) (v128.load8_splat  (global.get $OFFSET_VALUE/v128)))
    (func $value/BPE:2 (result v128) (v128.load16_splat (global.get $OFFSET_VALUE/v128)))
    (func $value/BPE:4 (result v128) (v128.load32_splat (global.get $OFFSET_VALUE/v128)))
    (func $value/BPE:8 (result v128) (v128.load64_splat (global.get $OFFSET_VALUE/v128)))

    (func $arguments 
        (result i32 v128 i32)

        (local $bytes    i32)
        (local $offset   i32)
        (local $value   v128)
        (local $count    i32)
        (local $bpe      i32)

        (block $offset
            (local.set $offset
                (i32.add
                    (global.get $dataByteOffset)
                    (i32.mul
                        (global.get $threadIndex)
                        (local.tee $bytes
                            (i32.load 
                                (global.get $OFFSET_BYTES_PER_THREAD/u32)
                            )
                        )
                    )
                )
            )

            (call $bytes->thread
                (i32.add 
                    (local.get $bytes) 
                    (call $thread->btyes)
                )
            )

            (br_if $offset (local.get $offset))
            (unreachable)
        )

        (block $value
        
            (local.set $bpe 
                (i32.load (global.get $OFFSET_BPE))
            )

            (if (i32.eq (local.get $bpe) (i32.const 1))
                (then (local.set $value (call $value/BPE:1)) (br $value))
            )

            (if (i32.eq (local.get $bpe) (i32.const 2))
                (then (local.set $value (call $value/BPE:2)) (br $value))
            )

            (if (i32.eq (local.get $bpe) (i32.const 4))
                (then (local.set $value (call $value/BPE:4)) (br $value))
            )

            (if (i32.eq (local.get $bpe) (i32.const 8))
                (then (local.set $value (call $value/BPE:8)) (br $value))
            )

            (unreachable)
        )        

        (block $count
            (local.set $count
                (i32.load 
                    (global.get $OFFSET_COUNT_PER_THREAD/u32)
                )
            )

            (call $flops->thread
                (i32.add 
                    (local.get $count) 
                    (call $thread->flops)
                )
            )
            
            (br_if $count (local.get $count))
            (unreachable)
        )

        (local.get $offset)
        (local.get $value)
        (local.get $count)
    )

    (func $handler
        (result i32)
        (local $func i32)

        (local.tee $func
            (i32.load (global.get $OFFSET_FUNC))
        )

        (if (then (return (local.get $func))))

        (unreachable)
    )

    (func $cycle++
        (call $cycle->thread 
            (i32.add 
                (i32.const 1) 
                (call $thread->cycle)
            )
        )
    )

    (func $works--
        (call $works->thread 
            (i32.sub 
                (call $thread->works) 
                (i32.const 1)
            )
        )                
    )

    (elem   $calc funcref 
        (ref.null func)
        (ref.func $f32_add)
        (ref.func $f32_mul)
        (ref.func $f32_sub)
        (ref.func $f32_div)
        (ref.func $i32_add)
        (ref.func $i32_mul)
        (ref.func $i32_sub)
    )

    (func   $main 
        (table.set $calc (global.get $f32_add) (ref.func $f32_add))
        (table.set $calc (global.get $f32_mul) (ref.func $f32_mul))
        (table.set $calc (global.get $f32_sub) (ref.func $f32_sub))
        (table.set $calc (global.get $f32_div) (ref.func $f32_div))
        (table.set $calc (global.get $i32_add) (ref.func $i32_add))
        (table.set $calc (global.get $i32_mul) (ref.func $i32_mul))
        (table.set $calc (global.get $i32_sub) (ref.func $i32_sub))

        (elem.drop $calc)
    )

    (table  $calc 8 funcref)   

    (func   $f32_add
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (f32x4.add
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $f32_mul
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (f32x4.mul
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $f32_sub
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (f32x4.sub
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $f32_div
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (f32x4.div
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $i32_add
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (i32x4.add
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $i32_mul
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (i32x4.mul
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func   $i32_sub
        (param $byteOffset  i32)
        (param $value      v128)
        (param $count       i32)
        
        (loop $i--
            (local.set $count       (i32.sub (local.get $count) (i32.const 1)))

            (v128.store
                (local.get $byteOffset)
                (i32x4.sub
                    (v128.load (local.get $byteOffset))
                    (local.get $value)
                )
            )

            (local.set $byteOffset  (i32.add (local.get $byteOffset) (i32.const 16)))

            (br_if $i-- (local.get $count))
        )
    )

    (func $loop 
        (export "loop")
        
        (if (call $thread->works)
            (then
                (call $state->thread (global.get $STATE/BUSY))

                (call $arguments)
                (call_indirect $calc (param i32 v128 i32) (call $handler))

                (call $cycle++)
                (call $works--)   

                (call $state->thread (global.get $STATE/IDLE))
            )
        )

        (call $lock)
    )

    ;; Lock a mutex at the given address, retrying until successful.
    (func $lock 

        (drop
            (memory.atomic.notify
                ;; mutex address
                (global.get $mutexAddr)   
                
                ;; notify 1 waiter
                (i32.const 1)
            )
        )

        (drop
            (memory.atomic.wait32
                    
                ;; mutex address
                (global.get $mutexAddr) 
                
                ;; expected value (1 => locked)
                (i32.const 0)          
                
                ;; infinite timeout
                (i64.const -1)
            ) 
        )

        (call $loop)
    )

    (start $main)
)