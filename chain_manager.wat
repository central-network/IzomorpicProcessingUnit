(module
    (import "env" "memory" (memory 10 10 shared))

    ;; ============================================================================================================
    ;; CHAIN MANAGER (chain_manager.wat)
    ;; ============================================================================================================
    ;; Manages the 4224-byte Chain Block Structure.
    ;; - Chain Header (64 bytes)
    ;; - Task State Block (64 bytes)
    ;; - Task Headers (64 * 64 bytes = 4096 bytes)

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CONSTANTS
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; Offsets (Relative to Chain Block Base)
    (global $OFFSET_CHAIN_HEADER            i32 (i32.const 0))
    (global $OFFSET_TASK_STATE_BLOCK        i32 (i32.const 64))
    (global $OFFSET_TASK_HEADERS_START      i32 (i32.const 128))

    ;; Sizes
    (global $CHAIN_HEADER_SIZE              i32 (i32.const 64))
    (global $TASK_STATE_BLOCK_SIZE          i32 (i32.const 64))
    (global $TASK_HEADER_SIZE               i32 (i32.const 64))
    (global $TOTAL_TASKS                    i32 (i32.const 64))

    (global $OFFSET_TASK_NEXT_INDEX         i32 (i32.const 0))
    (global $OFFSET_TASK_ID                 i32 (i32.const 0)) ;; Alias if needed, but we use index now
    (global $OFFSET_TASK_ATOMIC_COUNTER     i32 (i32.const 4))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CHAIN INITIALIZATION
    ;; ------------------------------------------------------------------------------------------------------------
    
    (func $init_chain (export "init_chain")
        (param $chain_ptr i32)
        
        ;; 1. Clear Chain Header (0..63)
        ;; (Simple loop or fill)
        (memory.fill (local.get $chain_ptr) (i32.const 0) (global.get $CHAIN_HEADER_SIZE))

        ;; 2. Clear Task State Block (64..127)
        (memory.fill 
            (i32.add (local.get $chain_ptr) (global.get $OFFSET_TASK_STATE_BLOCK)) 
            (i32.const 0) 
            (global.get $TASK_STATE_BLOCK_SIZE)
        )

        ;; 3. Clear Task Headers (128..4223)
        ;; Actually, let's just clear the whole block if possible, but step by step is fine.
        (memory.fill
            (i32.add (local.get $chain_ptr) (global.get $OFFSET_TASK_HEADERS_START))
            (i32.const 0)
            (i32.const 4096) ;; 64 * 64
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; PREPARE TASK
    ;; ------------------------------------------------------------------------------------------------------------
    (func $prepare_task (export "prepare_task")
        (param $chain_ptr i32)
        (param $task_index i32)
        (param $opcode i32)
        (param $next_task_index i32) ;; NEW PARAMETER
        
        (local $task_ptr i32)
        
        ;; Calculate Task Pointer
        (local.set $task_ptr
            (i32.add
                (local.get $chain_ptr)
                (i32.add
                    (global.get $OFFSET_TASK_HEADERS_START)
                    (i32.mul (local.get $task_index) (global.get $TASK_HEADER_SIZE))
                )
            )
        )

        ;; Write Next Task Index (Offset 0)
        (i32.store offset=0 (local.get $task_ptr) (local.get $next_task_index))

        ;; Write Opcode (Offset 5)
        (i32.store8 offset=5 (local.get $task_ptr) (local.get $opcode))
        
        ;; Reset Atomic Counter (Offset 4) -> 0 (Available)
        (i32.store8 offset=4 (local.get $task_ptr) (i32.const 0))
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; ACTIVATE TASK (Set bit in Task State Block)
    ;; ------------------------------------------------------------------------------------------------------------
    
    (func $activate_task (export "activate_task")
        (param $chain_ptr i32)
        (param $task_index i32)
        
        (local $state_byte_ptr i32)
        
        ;; State Block is at Chain + 64.
        ;; It's a 64-byte vector. Each byte corresponds to a task? 
        ;; Wait, v128 scan checks for "any_true". 
        ;; If we use 64 bytes for 64 tasks, each byte is a task.
        ;; If byte != 0, task is pending.
        
        (local.set $state_byte_ptr
            (i32.add
                (i32.add (local.get $chain_ptr) (global.get $OFFSET_TASK_STATE_BLOCK))
                (local.get $task_index)
            )
        )
        
        ;; Set Byte to 1 (Pending)
        (i32.store8 (local.get $state_byte_ptr) (i32.const 1))
    )

)
