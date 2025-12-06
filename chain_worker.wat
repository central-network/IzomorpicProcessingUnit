(module
    (import "env" "memory" (memory 10 10 shared))

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
    ;; WORKER LIFECYCLE
    ;; ------------------------------------------------------------------------------------------------------------

    (func $start (export "start")
        (param $worker_id i32)
        (param $current_time f32)
        
        ;; 1. Record Deploy Epoch
        (call $set_worker_deploy_epoch<i32> 
            (local.get $worker_id)
            (local.get $current_time)
        )
        
        ;; 2. Signal STARTED
        (call $set_worker_last_state<i32> 
            (local.get $worker_id) 
            (global.get $WORKER_STATE_STARTED)
        )

        ;; 3. Loop until Window says CLOSE
        (loop $lifecycle
            
            ;; Check Window State
            (if (i32.eq 
                    (call $get_worker_window_last_state<i32>i32 (local.get $worker_id))
                    (global.get $WINDOW_STATE_REQUEST_CLOSE)
                )
                (then
                    ;; Acknowledge Closing
                    (call $set_worker_last_state<i32> 
                        (local.get $worker_id) 
                        (global.get $WORKER_STATE_CLOSING)
                    )
                    
                    ;; Record Destroy Epoch (Simulated end time, for now reusing start time or need another source)
                    ;; Since we don't have clock, we can't write real end time unless imported.
                    ;; We will skip writing DESTROY epoch here or write same time for prototype.
                    ;; Or better: JS writes Destroy Epoch? 
                    ;; User description: "worker_destroy_epoch: f32 (kapatma protokolü başlangıcı, wasm)"
                    ;; Okay, we will write it here. But what value? $current_time is old.
                    ;; We'll just write 0.0 or duplicate for now as placeholder, or import a time func?
                    ;; User didn't specify import. Let's send 0.0 to mark "we reached here".
                    
                    (call $set_worker_destroy_epoch<i32>
                        (local.get $worker_id)
                        (f32.const -1.0) ;; MARKER
                    )

                    (return) ;; Exit Worker
                )
            )

            ;; Simulated Work / Locking Test
            (if (i32.eq
                    (i32.atomic.rmw.cmpxchg offset=0 ;; OFFSET_WORKER_MUTEX
                        (call $get_worker_offset<i32>i32 (local.get $worker_id))
                        (i32.const 0) 
                        (i32.const 1) 
                    )
                    (i32.const 0) 
                )
                (then
                    ;; LOCKED! Signal State
                    (call $set_worker_last_state<i32> 
                        (local.get $worker_id) 
                        (global.get $WORKER_STATE_LOCKED)
                    )
                    
                    ;; Unlock
                    (call $set_worker_mutex<i32> 
                        (local.get $worker_id) 
                        (i32.const 0)
                    )
                    
                    ;; Back to WORKING state
                    (call $set_worker_last_state<i32> 
                        (local.get $worker_id) 
                        (global.get $WORKER_STATE_WORKING)
                    )
                )
            )
            
            (br $lifecycle)
        )
    )
)