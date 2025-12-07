(module
    (import "env" "memory" (memory 10 10 shared))

    ;; ============================================================================================================
    ;; TASK EXECUTION MODULE (chain_task.wat)
    ;; ============================================================================================================
    ;; Responsible for executing a specific Task given its memory offset.
    ;; Reads commands from the Task's Command Block and performs operations.

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CONSTANTS (Task Header)
    ;; ------------------------------------------------------------------------------------------------------------
    ;; Task Header Offsets (assuming 128-byte header as per chain_memory_layout)
    (global $OFFSET_TASK_COMMAND_COUNT      i32 (i32.const 32))
    (global $OFFSET_TASK_COMMAND_OFFSET     i32 (i32.const 64)) 

    ;; Command Structure (16 Bytes)
    ;; [Opcode (4)] [OpA (4)] [OpB (4)] [Target (4)]
    (global $COMMAND_SIZE                   i32 (i32.const 16))
    (global $OFFSET_CMD_OPCODE              i32 (i32.const 0))
    (global $OFFSET_CMD_OPA                 i32 (i32.const 4))
    (global $OFFSET_CMD_OPB                 i32 (i32.const 8))
    (global $OFFSET_CMD_TARGET              i32 (i32.const 12))

    ;; Opcodes (Immediate Values)
    (global $OP_ADD                         i32 (i32.const 1))
    (global $OP_SUB                         i32 (i32.const 2))
    (global $OP_MUL                         i32 (i32.const 3))
    (global $OP_DIV                         i32 (i32.const 4))

    ;; Opcodes (Pointer-Based: OpA is a PTR, OpB is Immediate)
    (global $OP_ADD_PTR                     i32 (i32.const 11))
    (global $OP_SUB_PTR                     i32 (i32.const 12))
    (global $OP_MUL_PTR                     i32 (i32.const 13))
    (global $OP_DIV_PTR                     i32 (i32.const 14))

    ;; Opcodes (Comparison: result = condition ? 1.0 : 0.0)
    (global $OP_CMP_GT                      i32 (i32.const 21))
    (global $OP_CMP_LT                      i32 (i32.const 22))
    (global $OP_CMP_EQ                      i32 (i32.const 23))
    (global $OP_CMP_GT_PTR                  i32 (i32.const 31)) ;; PTR variant
    (global $OP_CMP_LT_PTR                  i32 (i32.const 32))
    (global $OP_CMP_EQ_PTR                  i32 (i32.const 33))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; EXECUTE TASK
    ;; ------------------------------------------------------------------------------------------------------------
    (func $execute_task (export "execute_task")
        (param $task_ptr i32)
        (result i32) ;; Returns number of commands executed

        (local $command_count i32)
        (local $command_ptr i32)
        (local $i i32)
        (local $opcode i32)
        (local $val_a f32) ;; Assuming f32 for prototype simplicity
        (local $val_b f32)
        (local $target_ptr i32)
        (local $result f32)

        ;; 1. Read Command Count
        (local.set $command_count
            (i32.load offset=32 ;; OFFSET_TASK_COMMAND_COUNT
                (local.get $task_ptr)
            )
        )

        ;; 2. Read Command Buffer Offset (Relative to Task Ptr? Or Absolute? 
        ;;    Let's assume Absolute for simplicity in this prototype, or Relative to Memory Base. 
        ;;    Actually, usually it's a pointer. Let's assume it's an absolute index in shared memory.)
        (local.set $command_ptr
            (i32.load offset=64 ;; OFFSET_TASK_COMMAND_OFFSET
                (local.get $task_ptr)
            )
        )

        ;; 3. Loop through Commands
        (local.set $i (i32.const 0))
        (loop $cmd_loop
            (if (i32.lt_u (local.get $i) (local.get $command_count))
                (then
                    ;; Read Opcode
                    (local.set $opcode
                        (i32.load offset=0 (local.get $command_ptr))
                    )

                    ;; Read Operands (Assuming they are Values stored directly in command for this prototype, 
                    ;; or pointers? Let's treat them as f32 values cast to i32 bits for the prototype to avoid dereferencing).
                    ;; WAIT: If they are pointers, we need to load.
                    ;; Let's make this a "Compute Task" where OpA and OpB are IMMEDIATE float values for testing logic.
                    (local.set $val_a
                        (f32.load offset=4 (local.get $command_ptr))
                    )
                    (local.set $val_b
                        (f32.load offset=8 (local.get $command_ptr))
                    )
                    
                    ;; Read Target Pointer (Where to write result)
                    (local.set $target_ptr
                        (i32.load offset=12 (local.get $command_ptr))
                    )

                    ;; Execute (Immediate Opcodes)
                    (if (i32.eq (local.get $opcode) (global.get $OP_ADD))
                        (then (local.set $result (f32.add (local.get $val_a) (local.get $val_b))))
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_SUB))
                        (then (local.set $result (f32.sub (local.get $val_a) (local.get $val_b))))
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_MUL))
                        (then (local.set $result (f32.mul (local.get $val_a) (local.get $val_b))))
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_DIV))
                        (then (local.set $result (f32.div (local.get $val_a) (local.get $val_b))))
                    )

                    ;; Execute (Pointer-Based Opcodes: OpA is a PTR)
                    ;; For PTR opcodes, we need to re-interpret OpA as a pointer and load the value.
                    ;; OpA (offset 4) is stored as i32 pointer. OpB (offset 8) is immediate f32.
                    (if (i32.eq (local.get $opcode) (global.get $OP_ADD_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result (f32.add (local.get $val_a) (local.get $val_b)))
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_SUB_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result (f32.sub (local.get $val_a) (local.get $val_b)))
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_MUL_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result (f32.mul (local.get $val_a) (local.get $val_b)))
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_DIV_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result (f32.div (local.get $val_a) (local.get $val_b)))
                        )
                    )

                    ;; Execute (Comparison Opcodes: Immediate)
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_GT))
                        (then 
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.gt (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_LT))
                        (then 
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.lt (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_EQ))
                        (then 
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.eq (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )

                    ;; Execute (Comparison Opcodes: PTR)
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_GT_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.gt (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_LT_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.lt (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )
                    (if (i32.eq (local.get $opcode) (global.get $OP_CMP_EQ_PTR))
                        (then 
                            (local.set $val_a (f32.load (i32.load offset=4 (local.get $command_ptr))))
                            (local.set $result 
                                (select (f32.const 1.0) (f32.const 0.0) 
                                    (f32.eq (local.get $val_a) (local.get $val_b))
                                )
                            )
                        )
                    )

                    ;; Store Result
                    (f32.store (local.get $target_ptr) (local.get $result))

                    ;; Advance
                    (local.set $command_ptr (i32.add (local.get $command_ptr) (global.get $COMMAND_SIZE)))
                    (local.set $i (i32.add (local.get $i) (i32.const 1)))
                    (br $cmd_loop)
                )
            )
        )

        (local.get $command_count)
    )
)
