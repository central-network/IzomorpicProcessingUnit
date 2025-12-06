(module
    (import "env" "memory" (memory 10 10 shared))
    (import "env" "index" (global $WORKER_INDEX i32))
    (import "console" "log" (func $console.log<i32> (param i32)))
    (import "console" "log" (func $console.log<i32.i32> (param i32 i32)))
    (import "console" "warn" (func $console.warn<i32> (param i32)))
    (import "console" "warn" (func $console.warn<i32.i32> (param i32 i32)))
    (import "console" "error" (func $console.error<i32> (param i32)))

    (global $OFFSET_WORKER_HEADERS              i32 (i32.const 12))
    (global $LENGTH_WORKER_HEADERS              i32 (i32.const 16))

    (global $LENGTH_CHAIN_HEADERS               i32 (i32.const 64))
    (global $OFFSET_CHAIN_TASK_STATES_BLOCK     i32 (i32.const 64))
    (global $LENGTH_CHAIN_TASK_STATES_BLOCK     i32 (i32.const 64)) ;; 1 * 64
    (global $OFFSET_CHAIN_TASK_HEADERS          i32 (i32.const 128))
    (global $LENGTH_CHAIN_TASK_HEADERS          i32 (i32.const 4096)) ;; 64 * 64 
    (global $LENGTH_CHAIN                       i32 (i32.const 4224)) ;; 64 + 64 + 4096
    (global $COUNT_CHAIN_TASKS                  i32 (i32.const 64))

    (global $OFFSET_CHAIN_TASK_CHAIN_OFFSET     i32 (i32.const  0)) 
    (global $OFFSET_CHAIN_TASK_ATOMIC_COUNTER   i32 (i32.const  4))
    (global $OFFSET_CHAIN_TASK_OP_CODE          i32 (i32.const  5)) 
    (global $OFFSET_CHAIN_TASK_VARIANT_CODE     i32 (i32.const  6))
    (global $OFFSET_CHAIN_TASK_IS_MIXED_SPACE   i32 (i32.const  7))
    (global $OFFSET_CHAIN_TASK_FUNC_INDEX       i32 (i32.const  8))
    (global $OFFSET_CHAIN_TASK_SRC_TYPE_SPACE   i32 (i32.const 12))
    (global $OFFSET_CHAIN_TASK_VAL_TYPE_SPACE   i32 (i32.const 16))
    (global $OFFSET_CHAIN_TASK_DST_TYPE_SPACE   i32 (i32.const 20))
    (global $OFFSET_CHAIN_TASK_SRC_BYTELENGTH   i32 (i32.const 24))
    (global $OFFSET_CHAIN_TASK_VAL_BYTELENGTH   i32 (i32.const 28))
    (global $OFFSET_CHAIN_TASK_DST_BYTELENGTH   i32 (i32.const 32))
    (global $OFFSET_CHAIN_TASK_SRC_LENGTH       i32 (i32.const 36))
    (global $OFFSET_CHAIN_TASK_VAL_LENGTH       i32 (i32.const 40))
    (global $OFFSET_CHAIN_TASK_DST_LENGTH       i32 (i32.const 44))

    (global $OFFSET_CHAIN_TASK_VECTOR           i32 (i32.const 48)) ;; this is a v128 container offset for next values
    (global $OFFSET_CHAIN_TASK_BUF_BYTELENGTH   i32 (i32.const 48))
    (global $OFFSET_CHAIN_TASK_SRC_BYTEOFFSET   i32 (i32.const 52))
    (global $OFFSET_CHAIN_TASK_VAL_BYTEOFFSET   i32 (i32.const 56))
    (global $OFFSET_CHAIN_TASK_DST_BYTEOFFSET   i32 (i32.const 60))
    (global $LENGTH_CHAIN_TASK                  i32 (i32.const 64))

    (global $WORKER_OFFSET (mut i32) (i32.const 0))

    (func $loop_chain (export "loop_chain")
        (param $chain_offset i32)
        (local $task_offset i32)
        (local $task_count i32)
        (local $task_state_offset i32)
        (local $chain_cpu_count i32)
        (local $chain_cpu_notifier_index i32)
        (local $task_atomic_counter_cpu_index i32)

        (if (call $get_chain_has_task<i32>i32
                (local.get $chain_offset)
            )
            (then
                (local.set $chain_cpu_count
                    (i32.load offset=8 (local.get $chain_offset))
                )

                (local.set $chain_cpu_notifier_index
                    (i32.sub 
                        (local.get $chain_cpu_count)
                        (i32.const 1)
                    )
                )

                (local.set $task_count
                    (global.get $COUNT_CHAIN_TASKS)
                )

                (local.set $task_offset
                    (i32.add 
                        (local.get $chain_offset)
                        (global.get $OFFSET_CHAIN_TASK_HEADERS)
                    )
                )

                (loop $process_chain_tasks
                
                    (call $process_chain_task<i32>
                        (local.get $task_offset)
                    )

                    (local.set $task_state_offset
                        (i32.add 
                            (local.get $task_state_offset)
                            (i32.const 1)
                        )
                    )

                    (local.set $task_atomic_counter_cpu_index
                        (i32.atomic.rmw8.add_u offset=4
                            (local.get $task_offset)
                            (i32.const 1)
                        )
                    )

                    (if (i32.eq
                            (local.get $task_atomic_counter_cpu_index)
                            (local.get $chain_cpu_notifier_index)
                        )
                        (then
                            (i32.store8 offset=64
                                (local.get $task_state_offset) ;; NOTE: This offset logic for state block needs check too. 
                                ;; task_state_offset started at 0? 
                                ;; Wait, previous code used (local.get $task_state_offset) which was 0-based index?
                                ;; Let's fix that below.
                                (global.get $CHAIN_TASK_CLOSED)
                            )
                        )
                    )
                    
                    ;; Increment for next loop
                    (local.set $task_offset
                        (i32.add 
                            (local.get $task_offset)
                            (global.get $LENGTH_CHAIN_TASK)
                        )
                    )

                    ;; Increment Chain Completion Counter (Offset 48)
                    ;; (i32.atomic.rmw.add offset=48 (local.get $chain_offset) (i32.const 1))
                    (if (i32.eq
                            (i32.atomic.rmw.add offset=48
                                (local.get $chain_offset)
                                (i32.const 1)
                            )
                            (i32.sub (global.get $COUNT_CHAIN_TASKS) (i32.const 1))
                        )
                        (then
                            ;; Chain Completely Finished!
                            ;; TODO: Jump to Next Chain or Reset Loop
                            ;; For now, maybe just mark chain as CLOSED or something visible?
                            ;; Or return 1 to signal "I finished the chain"
                            (return)
                        )
                    )

                    (local.set $task_count
                        (i32.add 
                            (local.get $task_count)
                            (i32.const -1)
                        )
                    )

                    (br_if $process_chain_tasks (local.get $task_count))
                )
            )
        )
    )

    (global $CHAIN_TASK_CLOSED i32 (i32.const 0))

    (func $process_chain_task<i32>
        (param $task_offset i32) 

        (local $task_chain_offset    i32) 
        (local $task_op_code         i32) 
        (local $task_variant_code    i32)
        (local $task_is_mixed_space  i32)
        (local $task_atomic_counter  i32)
        (local $task_func_index      i32)
        (local $task_src_type_space  i32)
        (local $task_val_type_space  i32)
        (local $task_dst_type_space  i32)
        (local $task_src_bytelength  i32)
        (local $task_val_bytelength  i32)
        (local $task_dst_bytelength  i32)
        (local $task_src_length      i32)
        (local $task_val_length      i32)
        (local $task_dst_length      i32)
        (local $task_buf_bytelength  i32)
        (local $task_src_byteoffset  i32)
        (local $task_val_byteoffset  i32)
        (local $task_dst_byteoffset  i32)
        (local $task_vector         v128)

        (local.set $task_chain_offset    (i32.load      offset=0 (local.get $task_offset))) 
        (local.set $task_atomic_counter  (i32.load8_u   offset=4 (local.get $task_offset)))
        (local.set $task_op_code         (i32.load8_u   offset=5 (local.get $task_offset))) 
        (local.set $task_variant_code    (i32.load8_u   offset=6 (local.get $task_offset)))
        (local.set $task_is_mixed_space  (i32.load8_u   offset=7 (local.get $task_offset)))
        (local.set $task_func_index      (i32.load      offset=8 (local.get $task_offset)))
        (local.set $task_src_type_space  (i32.load      offset=12 (local.get $task_offset)))
        (local.set $task_val_type_space  (i32.load      offset=16 (local.get $task_offset)))
        (local.set $task_dst_type_space  (i32.load      offset=20 (local.get $task_offset)))
        (local.set $task_src_bytelength  (i32.load      offset=24 (local.get $task_offset)))
        (local.set $task_val_bytelength  (i32.load      offset=28 (local.get $task_offset)))
        (local.set $task_dst_bytelength  (i32.load      offset=32 (local.get $task_offset)))
        (local.set $task_src_length      (i32.load      offset=36 (local.get $task_offset)))
        (local.set $task_val_length      (i32.load      offset=40 (local.get $task_offset)))
        (local.set $task_dst_length      (i32.load      offset=44 (local.get $task_offset)))
        (local.set $task_buf_bytelength  (i32.load      offset=48 (local.get $task_offset)))
        (local.set $task_src_byteoffset  (i32.load      offset=52 (local.get $task_offset)))
        (local.set $task_val_byteoffset  (i32.load      offset=56 (local.get $task_offset)))
        (local.set $task_dst_byteoffset  (i32.load      offset=60 (local.get $task_offset)))

        (local.set $task_vector (v128.load offset=44 (local.get $task_offset)))
    )

    (func $get_chain_has_task<i32>i32
        (param $chain_offset i32)
        (result i32)
        
        ;; 64 byte chain headers + 0 byte state block 0 offset
        (if (v128.any_true (v128.load offset=64 (local.get $chain_offset)))
            (then (i32.const 1) return )
        )

        ;; 64 byte chain headers + 16 byte state block 1 offset
        (if (v128.any_true (v128.load offset=80 (local.get $chain_offset)))
            (then (i32.const 1) return )
        )

        ;; 64 byte chain headers + 32 byte state block 2 offset
        (if (v128.any_true (v128.load offset=96 (local.get $chain_offset)))
            (then (i32.const 1) return )
        )

        ;; 64 byte chain headers + 48 byte state block 3 offset
        (if (v128.any_true (v128.load offset=112 (local.get $chain_offset)))
            (then (i32.const 1) return )
        )

        ;; a chain has 4 blocks / 64 empty task slots
        (i32.const 0)
    )

    (func $main
        (global.set $WORKER_OFFSET
            (i32.add
                (global.get $OFFSET_WORKER_HEADERS)
                (i32.mul
                    (global.get $WORKER_INDEX)
                    (global.get $LENGTH_WORKER_HEADERS)
                )
            )
        )

        (call $console.warn<i32.i32> (global.get $WORKER_INDEX) (global.get $WORKER_OFFSET))


        (call $console.error<i32> 
            (memory.atomic.wait32 (global.get $WORKER_OFFSET) (i32.const 0) (i64.const -1))
        )

        (call $console.log<i32> 
            (global.get $WORKER_INDEX)
        )
    )

    (start $main)
)