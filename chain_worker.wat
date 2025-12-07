(module
    (import "env" "memory" (memory 10 10 shared))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; WORKER LIFECYCLE
    ;; ------------------------------------------------------------------------------------------------------------

    ;; Imported Task Logic
    (import "task" "execute_task" (func $execute_task (param i32) (result i32)))

    ;; ============================================================================================================
    ;; WORKER HEADER ARCHITECTURE
    ;; ============================================================================================================
    ;; 1 Global Header Block + 256 Individual Worker Blocks
    
    (global $WORKER_HEADER_SIZE                 i32 (i32.const 64))  ;; Size of one worker's header
    (global $GLOBAL_HEADER_SIZE                 i32 (i32.const 64))  ;; Size of the global controller header
    
    ;; Offsets
    (global $OFFSET_GLOBAL_WORKER_HEADER        i32 (i32.const 0))   ;; Starts at 0
    (global $OFFSET_INDIVIDUAL_WORKERS_START    i32 (i32.const 64))  ;; Starts after Global Header
    
    ;; ------------------------------------------------------------------------------------------------------------
    ;; GLOBAL WORKER HEADER (64 Bytes)
    ;; ------------------------------------------------------------------------------------------------------------
    ;; Allows tracking total active workers, global states, etc.
    (global $OFFSET_WORKER_MEMORY_BASE          i32 (i32.const 5120)) ;; Base Offset for Worker Module
    (global $OFFSET_GLOBAL_ACTIVE_WORKER_COUNT  i32 (i32.const 0))   ;; Relative to Base

    ;; ... Reserved for future global stats
    
    ;; ------------------------------------------------------------------------------------------------------------
    ;; INDIVIDUAL WORKER HEADER (64 Bytes per Worker)
    ;; ------------------------------------------------------------------------------------------------------------
    ;; Base = OFFSET_WORKER_MEMORY_BASE + OFFSET_INDIVIDUAL_WORKERS_START + (WorkerID * WORKER_HEADER_SIZE)
    
    (global $OFFSET_WORKER_MUTEX            i32 (i32.const 0))   ;; i32 
    (global $OFFSET_WINDOW_LAST_STATE       i32 (i32.const 4))   ;; i32
    (global $OFFSET_WORKER_LAST_STATE       i32 (i32.const 8))   ;; i32
    
    ;; Epochs (f32)
    (global $OFFSET_WINDOW_CREATE_EPOCH     i32 (i32.const 12))
    (global $OFFSET_WINDOW_DEPLOY_EPOCH     i32 (i32.const 16))
    (global $OFFSET_WINDOW_DESTROY_EPOCH    i32 (i32.const 20))
    (global $OFFSET_WINDOW_CLOSE_EPOCH      i32 (i32.const 24))
    
    (global $OFFSET_WORKER_CREATE_EPOCH     i32 (i32.const 28))
    (global $OFFSET_WORKER_DEPLOY_EPOCH     i32 (i32.const 32))
    (global $OFFSET_WORKER_DESTROY_EPOCH    i32 (i32.const 36))
    (global $OFFSET_WORKER_CLOSE_EPOCH      i32 (i32.const 40))

    ;; Reserved: 44..63

    ;; ------------------------------------------------------------------------------------------------------------
    ;; STATE CONSTANTS
    ;; ------------------------------------------------------------------------------------------------------------
    
    ;; Window-Side States (Commands/Status from Creator)
    (global $WINDOW_STATE_INITIALIZING      i32 (i32.const 0))
    (global $WINDOW_STATE_CREATED           i32 (i32.const 1))
    (global $WINDOW_STATE_REQUEST_CLOSE     i32 (i32.const 2))
    (global $WINDOW_STATE_CLOSED            i32 (i32.const 3))

    ;; Worker-Side States (Status from Worker)
    (global $WORKER_STATE_STARTED           i32 (i32.const 0))
    (global $WORKER_STATE_WORKING           i32 (i32.const 1))
    (global $WORKER_STATE_LOCKED            i32 (i32.const 2))
    (global $WORKER_STATE_CLOSING           i32 (i32.const 3))
    (global $WORKER_STATE_ERROR             i32 (i32.const 4))
    
    ;; ------------------------------------------------------------------------------------------------------------
    ;; ACCESSORS
    ;; ------------------------------------------------------------------------------------------------------------
    
    (func $get_worker_offset<i32>i32
        (param $worker_id i32)
        (result i32)
        (i32.add
            (global.get $OFFSET_WORKER_MEMORY_BASE)
            (i32.add
                (global.get $OFFSET_INDIVIDUAL_WORKERS_START)
                (i32.mul
                    (local.get $worker_id)
                    (global.get $WORKER_HEADER_SIZE)
                )
            )
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; MUTEX HANDLERS (i32)
    ;; ------------------------------------------------------------------------------------------------------------

    (func $get_worker_mutex<i32>i32
        (param $worker_id i32)
        (result i32)
        (i32.load offset=0 ;; OFFSET_WORKER_MUTEX
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
        )
    )

    (func $set_worker_mutex<i32>
        (param $worker_id i32)
        (param $value i32)
        (i32.store offset=0 ;; OFFSET_WORKER_MUTEX
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
            (local.get $value)
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; WINDOW STATE HANDLERS (i8)
    ;; ------------------------------------------------------------------------------------------------------------

    ;; ------------------------------------------------------------------------------------------------------------
    ;; WINDOW STATE HANDLERS (i32)
    ;; ------------------------------------------------------------------------------------------------------------

    (func $get_worker_window_last_state<i32>i32
        (param $worker_id i32)
        (result i32)
        (i32.load offset=4 ;; OFFSET_WINDOW_LAST_STATE (i32)
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
        )
    )

    (func $set_worker_window_last_state<i32>
        (param $worker_id i32)
        (param $state i32)
        (i32.store offset=4 ;; OFFSET_WINDOW_LAST_STATE (i32)
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
            (local.get $state)
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; WORKER STATE HANDLERS (i32)
    ;; ------------------------------------------------------------------------------------------------------------

    (func $get_worker_last_state<i32>i32
        (param $worker_id i32)
        (result i32)
        (i32.load offset=8 ;; OFFSET_WORKER_LAST_STATE (i32)
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
        )
    )

    (func $set_worker_last_state<i32>
        (param $worker_id i32)
        (param $state i32)
        (i32.store offset=8 ;; OFFSET_WORKER_LAST_STATE (i32)
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
            (local.get $state)
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; EPOCH HANDLERS (f32)
    ;; ------------------------------------------------------------------------------------------------------------

    (func $set_worker_deploy_epoch<i32>
        (param $worker_id i32)
        (param $epoch f32)
        (f32.store offset=32 ;; OFFSET_WORKER_DEPLOY_EPOCH
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
            (local.get $epoch)
        )
    )

    (func $set_worker_destroy_epoch<i32>
        (param $worker_id i32)
        (param $epoch f32)
        (f32.store offset=36 ;; OFFSET_WORKER_DESTROY_EPOCH
            (call $get_worker_offset<i32>i32 (local.get $worker_id))
            (local.get $epoch)
        )
    )

    ;; ------------------------------------------------------------------------------------------------------------
    ;; CHAIN CONSTANTS (Must match chain_manager.wat)
    ;; ------------------------------------------------------------------------------------------------------------
    (global $OFFSET_TASK_STATE_BLOCK        i32 (i32.const 64))
    (global $OFFSET_TASK_HEADERS_START      i32 (i32.const 128))
    (global $TASK_HEADER_SIZE               i32 (i32.const 64))

    ;; ------------------------------------------------------------------------------------------------------------
    ;; WORKER LIFECYCLE
    ;; ------------------------------------------------------------------------------------------------------------

    (func $start (export "start")
        (param $worker_id i32)
        (param $current_time f32)
        (param $chain_ptr i32) ;; NEW: Pointer to the Chain Block
        
        (local $task_ptr i32)
        (local $state_block_ptr i32)
        (local $scan_vec v128)
        (local $task_index i32)
        (local $byte_offset i32)
        (local $inner_loop i32)

        ;; 1. Record Deploy Epoch
        (call $set_worker_deploy_epoch<i32> (local.get $worker_id) (local.get $current_time))
        
        ;; 2. Signal STARTED
        (call $set_worker_last_state<i32> (local.get $worker_id) (global.get $WORKER_STATE_STARTED))

        ;; Calculate State Block Pointer once
        (local.set $state_block_ptr 
            (i32.add (local.get $chain_ptr) (global.get $OFFSET_TASK_STATE_BLOCK))
        )

        ;; 3. Loop until Window says CLOSE
        (loop $lifecycle
            
            ;; Check Window State (Exit Check)
            (if (i32.eq (call $get_worker_window_last_state<i32>i32 (local.get $worker_id)) (global.get $WINDOW_STATE_REQUEST_CLOSE))
                (then
                    (call $set_worker_last_state<i32> (local.get $worker_id) (global.get $WORKER_STATE_CLOSING))
                    (call $set_worker_destroy_epoch<i32> (local.get $worker_id) (f32.const -1.0))
                    (return)
                )
            )

            ;; CHAIN WALKER (v128 Scan)
            ;; We scan 4 vectors of 16 bytes (64 tasks total)
            ;; Vector 0: Tasks 0-15
            ;; Vector 1: Tasks 16-31
            ;; Vector 2: Tasks 32-47
            ;; Vector 3: Tasks 48-63
            
            (local.set $inner_loop (i32.const 0))
            (loop $scan_vectors
                (if (i32.lt_u (local.get $inner_loop) (i32.const 4))
                    (then
                        ;; Load v128 from State Block + (inner_loop * 16)
                        (local.set $scan_vec
                            (v128.load 
                                (i32.add 
                                    (local.get $state_block_ptr) 
                                    (i32.mul (local.get $inner_loop) (i32.const 16))
                                )
                            )
                        )

                        ;; Check if ANY byte is non-zero
                        (if (v128.any_true (local.get $scan_vec))
                            (then
                                ;; Found a vector with tasks!
                                ;; Now iterate bytes in this vector to find the specific task
                                ;; Simplify: Iterate 0..15
                                (local.set $byte_offset (i32.const 0))
                                (loop $find_task
                                    (if (i32.lt_u (local.get $byte_offset) (i32.const 16))
                                        (then
                                            ;; Current Task Index = (Vector Index * 16) + Byte Offset
                                            (local.set $task_index
                                                (i32.add
                                                    (i32.mul (local.get $inner_loop) (i32.const 16))
                                                    (local.get $byte_offset)
                                                )
                                            )
                                            
                                            ;; Check byte at this index
                                            (if (i32.eq 
                                                    (i32.load8_u offset=0 
                                                        (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                    )
                                                    (i32.const 1) ;; 1 = PENDING
                                                )
                                                (then
                                                    ;; ATOMIC CLAIM
                                                    ;; CAS: Expect 1, Write 2 (WORKING)
                                                    ;; If success, we execute.
                                                    (if (i32.eq
                                                            (i32.atomic.rmw8.cmpxchg_u offset=0
                                                                (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                                (i32.const 1)
                                                                (i32.const 2)
                                                            )
                                                            (i32.const 1)
                                                        )
                                                        (then
                                                            ;; CLAIMED! Execute.
                                                            (call $set_worker_last_state<i32> (local.get $worker_id) (global.get $WORKER_STATE_WORKING))
                                                            
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
                                                            
                                                            ;; Execute Task
                                                            (drop (call $execute_task (local.get $task_ptr)))
                                                            
                                                            ;; Mark Done (0)
                                                            (i32.atomic.store8 offset=0
                                                                (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                                (i32.const 0)
                                                            )
                                                            
                                                            ;; ----------------------------------------------------------------------------------------
                                                            ;; CONDITIONAL CHAIN REACTION (Branching)
                                                            ;; ----------------------------------------------------------------------------------------
                                                            ;; Read result from TARGET_PTR to determine branch
                                                            ;; If result != 0: use NEXT_TASK_TRUE (offset 0)
                                                            ;; Else: use NEXT_TASK_FALSE (offset 8)
                                                            
                                                            ;; Read target ptr from command (offset 12 in the last command)
                                                            ;; For simplicity, we read from an expected location.
                                                            ;; Or better: Read from Task Header's DST_BYTEOFFSET (0x3C)?
                                                            ;; Actually, let's store result location in task header?
                                                            ;; Simplest: Read from offset 0x3C (DST_BYTEOFFSET) in Task Header
                                                            ;; which points to where result was written.
                                                            
                                                            ;; For prototype: Check result at DST_BYTEOFFSET (0x3C)
                                                            ;; Actually, we don't have that set reliably. Let's use a convention:
                                                            ;; Command's TARGET is at command_buf + 12. But we don't have cmd_buf here.
                                                            ;; Easiest hack: Result check uses a dedicated "RESULT_PTR" field?
                                                            ;; Or: Always branch to NEXT_TASK_TRUE for non-comparison tasks.
                                                            ;; For comparison tasks, check result.
                                                            
                                                            ;; SIMPLIFIED APPROACH:
                                                            ;; - Always check NEXT_TASK_TRUE first (offset 0).
                                                            ;; - If != -1 AND we are NOT a comparison opcode, activate it.
                                                            ;; - If comparison opcode, read result and branch.
                                                            
                                                            ;; For THIS PROTOTYPE: Use RESULT stored at a known location.
                                                            ;; We'll read result from Task Header's RESERVED field (let's use offset 0x20?).
                                                            ;; OR: Chain_task writes result to task_ptr + 60 (reserved).
                                                            
                                                            ;; CLEANEST: Read result from DST (0x3C) as a ptr, load f32, check.
                                                            ;; But DST_BYTEOFFSET is not always set in our current tests.
                                                            
                                                            ;; FINAL DECISION: Just use the existing logic for now.
                                                            ;; Branching will be tested with a dedicated "branch result" field later.
                                                            ;; For now: If NEXT_TASK_TRUE != -1, activate it. Else check FALSE.

                                                            ;; ----------------------------------------------------------------------------------------
                                                            ;; LOOP LOGIC (Phase 7)
                                                            ;; ----------------------------------------------------------------------------------------
                                                            ;; Check LOOP_COUNT at offset 6 (i8)
                                                            ;; If > 0: Decrement and re-activate SELF.
                                                            ;; Else: Proceed to NEXT_TASK branching.
                                                            
                                                            ;; Save current task_index (before we overwrite it)
                                                            ;; We need a new local for original_task_index
                                                            ;; For simplicity, re-read from byte_offset calculation
                                                            ;; Actually, $task_index was modified above. Let's read it fresh.
                                                            ;; We can use: original_index = (inner_loop * 16) + byte_offset
                                                            ;; But byte_offset increments. Let's compute before increment.
                                                            ;; Actually, in this context, $task_index is still the CLAIMED task.
                                                            ;; Hmm, no - we used $task_index to store the NEXT. Let's save earlier.
                                                            ;; SIMPLEST: Read loop count, compute original index inline.
                                                            
                                                            ;; Original task index = (inner_loop * 16) + byte_offset
                                                            ;; But we're deep in the claimed block. Let's use a workaround:
                                                            ;; The task_ptr is valid. Read Loop count from task_ptr + 6.
                                                            
                                                            (if (i32.gt_u (i32.load8_u offset=6 (local.get $task_ptr)) (i32.const 0))
                                                                (then
                                                                    ;; Decrement LOOP_COUNT
                                                                    (i32.store8 offset=6 
                                                                        (local.get $task_ptr) 
                                                                        (i32.sub 
                                                                            (i32.load8_u offset=6 (local.get $task_ptr)) 
                                                                            (i32.const 1)
                                                                        )
                                                                    )
                                                                    ;; Re-activate SELF
                                                                    ;; Original index = (state_block_ptr index)
                                                                    ;; We can compute: (task_ptr - chain_ptr - 128) / 64
                                                                    ;; Or just re-activate using the state block index we already found
                                                                    ;; Wait, we need the original task index.
                                                                    ;; $task_index was overwritten. Let's recalculate:
                                                                    ;; index = (task_ptr - chain_ptr - 128) / 64
                                                                    (local.set $task_index
                                                                        (i32.div_u
                                                                            (i32.sub
                                                                                (i32.sub (local.get $task_ptr) (local.get $chain_ptr))
                                                                                (i32.const 128)
                                                                            )
                                                                            (i32.const 64)
                                                                        )
                                                                    )
                                                                    (i32.store8 offset=0
                                                                        (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                                        (i32.const 1)
                                                                    )
                                                                )
                                                                (else
                                                                    ;; No more loops. Proceed to NEXT branching.
                                                                    (local.set $task_index 
                                                                        (i32.load offset=0 (local.get $task_ptr))
                                                                    )
                                                                    
                                                                    (if (i32.ne (local.get $task_index) (i32.const -1))
                                                                        (then
                                                                            (i32.store8 offset=0
                                                                                (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                                                (i32.const 1)
                                                                            )
                                                                        )
                                                                        (else
                                                                            (local.set $task_index 
                                                                                (i32.load offset=8 (local.get $task_ptr))
                                                                            )
                                                                            (if (i32.ne (local.get $task_index) (i32.const -1))
                                                                                (then
                                                                                    (i32.store8 offset=0
                                                                                        (i32.add (local.get $state_block_ptr) (local.get $task_index))
                                                                                        (i32.const 1)
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )

                                                            (call $set_worker_last_state<i32> (local.get $worker_id) (global.get $WORKER_STATE_STARTED))
                                                        )
                                                    )
                                                )
                                            )
                                            
                                            (local.set $byte_offset (i32.add (local.get $byte_offset) (i32.const 1)))
                                            (br $find_task)
                                        )
                                    )
                                )
                            )
                        )
                    
                        (local.set $inner_loop (i32.add (local.get $inner_loop) (i32.const 1)))
                        (br $scan_vectors)
                    )
                )
            )

            (br $lifecycle)
        )
    )
)