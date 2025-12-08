(module 
    (import "self" "local_memory" (memory $memory/local 1000 65535))
    (import "self" "shared_memory" (memory $memory/shared 1000 65535 shared))
    (import "self" "worker_index" (global $worker_index i32))

    (global $TOTAL_BYTES i32 (i32.const 65536000))

    ;; ============================================================================
    ;; BENCHMARK: OPTIMIZED SIMD on SHARED memory - ONLY ADD
    ;; ============================================================================
    (func $benchmark_shared (export "benchmark_shared")
        (local $task_vector v128)
        (local $adding_value v128)
        (local $loop_iterator v128)
        
        (local.set $task_vector (v128.const i32x4 65536000 0 0 0))
        (local.set $loop_iterator (v128.const i32x4 -16 16 16 16))
        (local.set $adding_value (f32x4.splat (f32.const 1.00001)))

        (loop $main
            (if (i32x4.extract_lane 0 (local.get $task_vector))
                (then
                    (v128.store $memory/shared
                        (i32x4.extract_lane 3 (local.get $task_vector))
                        (f32x4.add 
                            (v128.load $memory/shared (i32x4.extract_lane 1 (local.get $task_vector)))
                            (local.get $adding_value)
                        )
                    )
                    
                    (local.set $task_vector 
                        (i32x4.add (local.get $task_vector) (local.get $loop_iterator))
                    )
                    (br $main)
                )
            )
        )
    )

    ;; ============================================================================
    ;; BENCHMARK: SIMPLE i32 counter SIMD on SHARED memory
    ;; ============================================================================
    (func $benchmark_shared_simple (export "benchmark_shared_simple")
        (local $ptr i32)
        (local $end i32)
        (local $adding_value v128)
        
        (local.set $ptr (i32.const 0))
        (local.set $end (global.get $TOTAL_BYTES))
        (local.set $adding_value (f32x4.splat (f32.const 1.00001)))

        (loop $main
            (v128.store $memory/shared
                (local.get $ptr)
                (f32x4.add 
                    (v128.load $memory/shared (local.get $ptr))
                    (local.get $adding_value)
                )
            )
            
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 16)))
            (br_if $main (i32.lt_u (local.get $ptr) (local.get $end)))
        )
    )

    ;; ============================================================================
    ;; BENCHMARK: OPTIMIZED SIMD on LOCAL, then COPY - ONLY ADD
    ;; ============================================================================
    (func $benchmark_local_then_copy (export "benchmark_local_then_copy")
        (local $task_vector v128)
        (local $adding_value v128)
        (local $loop_iterator v128)
        
        (local.set $task_vector (v128.const i32x4 65536000 0 0 0))
        (local.set $loop_iterator (v128.const i32x4 -16 16 16 16))
        (local.set $adding_value (f32x4.splat (f32.const 1.00001)))

        (loop $main
            (if (i32x4.extract_lane 0 (local.get $task_vector))
                (then
                    (v128.store $memory/local
                        (i32x4.extract_lane 3 (local.get $task_vector))
                        (f32x4.add 
                            (v128.load $memory/local (i32x4.extract_lane 1 (local.get $task_vector)))
                            (local.get $adding_value)
                        )
                    )
                    
                    (local.set $task_vector 
                        (i32x4.add (local.get $task_vector) (local.get $loop_iterator))
                    )
                    (br $main)
                )
            )
        )
        
        (memory.copy $memory/shared $memory/local 
            (i32.const 0)
            (i32.const 0)
            (global.get $TOTAL_BYTES)
        )
    )

    ;; ============================================================================
    ;; BENCHMARK 3: READ from LOCAL, WRITE to SHARED (no copy)
    ;; ============================================================================
    (func $benchmark_local_read_shared_write (export "benchmark_local_read_shared_write")
        (local $task_vector v128)
        (local $adding_value v128)
        (local $loop_iterator v128)
        
        (local.set $task_vector (v128.const i32x4 65536000 0 0 0))
        (local.set $loop_iterator (v128.const i32x4 -16 16 16 16))
        (local.set $adding_value (f32x4.splat (f32.const 1.00001)))

        (loop $main
            (if (i32x4.extract_lane 0 (local.get $task_vector))
                (then
                    ;; READ from LOCAL, WRITE to SHARED
                    (v128.store $memory/shared
                        (i32x4.extract_lane 3 (local.get $task_vector))
                        (f32x4.add 
                            (v128.load $memory/local (i32x4.extract_lane 1 (local.get $task_vector)))
                            (local.get $adding_value)
                        )
                    )
                    
                    (local.set $task_vector 
                        (i32x4.add (local.get $task_vector) (local.get $loop_iterator))
                    )
                    (br $main)
                )
            )
        )
    )

    ;; ============================================================================
    ;; BENCHMARK: i32.add for offset (calculate next ptr)
    ;; ============================================================================
    (func $benchmark_add_offset (export "benchmark_add_offset")
        (local $ptr i32)
        (local $count i32)
        
        (local.set $ptr (i32.const 0))
        (local.set $count (i32.const 4096000))  ;; how many iterations

        (loop $main
            ;; Just increment ptr, no memory operation to isolate the cost
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 16)))
            
            (local.set $count (i32.sub (local.get $count) (i32.const 1)))
            (br_if $main (local.get $count))
        )
    )

    ;; ============================================================================
    ;; BENCHMARK: i32.load for offset (read next ptr from memory - linked list)
    ;; ============================================================================
    (func $benchmark_load_offset (export "benchmark_load_offset")
        (local $ptr i32)
        (local $count i32)
        
        (local.set $ptr (i32.const 0))
        (local.set $count (i32.const 4096000))

        (loop $main
            ;; Read next offset from memory (like linked list traversal)
            (local.set $ptr (i32.load $memory/shared (local.get $ptr)))
            
            (local.set $count (i32.sub (local.get $count) (i32.const 1)))
            (br_if $main (local.get $count))
        )
    )

    ;; ============================================================================
    ;; INIT: Setup linked-list style offsets in memory
    ;; ============================================================================
    (func $init_linked_offsets (export "init_linked_offsets")
        (local $ptr i32)
        (local $end i32)
        
        (local.set $ptr (i32.const 0))
        (local.set $end (i32.sub (global.get $TOTAL_BYTES) (i32.const 16)))

        (loop $main
            ;; At each position, store the next offset (ptr + 16)
            (i32.store $memory/shared 
                (local.get $ptr) 
                (i32.add (local.get $ptr) (i32.const 16))
            )
            
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 16)))
            (br_if $main (i32.lt_u (local.get $ptr) (local.get $end)))
        )
        
        ;; Last element points to 0 (loop back)
        (i32.store $memory/shared (local.get $ptr) (i32.const 0))
    )
)