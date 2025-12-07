
async function init() {
    console.log("Initializing Data Flow Test (Output -> Input Chaining)...");

    const memory = new WebAssembly.Memory({
        initial: 10,
        maximum: 10,
        shared: true
    });

    const f32 = new Float32Array(memory.buffer);
    const i32 = new Int32Array(memory.buffer);

    const WORKER_MEMORY_BASE = 5120;
    const WORKER_HEADER_SIZE = 64;
    const GLOBAL_HEADER_SIZE = 64;

    const CHAIN_BLOCK_PTR = 10000;

    // Data Flow Locations (Shared between tasks)
    const DATA_SLOT_1 = 15000; // T0 Output -> T15 Input
    const DATA_SLOT_2 = 15004; // T15 Output -> T63 Input
    const FINAL_RESULT = 15008; // T63 Output

    try {
        const [workerBytes, taskBytes, managerBytes] = await Promise.all([
            fetch('chain_worker.wasm').then(r => r.arrayBuffer()),
            fetch('chain_task.wasm').then(r => r.arrayBuffer()),
            fetch('chain_manager.wasm').then(r => r.arrayBuffer())
        ]);

        const workerModule = await WebAssembly.compile(workerBytes);
        const taskModule = await WebAssembly.compile(taskBytes);
        const managerModule = await WebAssembly.compile(managerBytes);

        const managerInstance = await WebAssembly.instantiate(managerModule, {
            env: { memory: memory }
        });

        console.log("Initializing Chain Block...");
        managerInstance.exports.init_chain(CHAIN_BLOCK_PTR);

        // ===========================
        // TASK 0: 10 + 20 = 30
        // Output: DATA_SLOT_1
        // Next: Task 15
        // ===========================
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 0, 1, 15); // Op ADD, Next 15
        const t0_ptr = CHAIN_BLOCK_PTR + 128 + (0 * 64);
        i32[(t0_ptr + 32) >> 2] = 1; // 1 Command
        i32[(t0_ptr + 64) >> 2] = 16000; // Cmd Buf Ptr
        // Command: ADD 10.0, 20.0 -> DATA_SLOT_1
        i32[(16000 + 0) >> 2] = 1; // OP_ADD
        f32[(16000 + 4) >> 2] = 10.0;
        f32[(16000 + 8) >> 2] = 20.0;
        i32[(16000 + 12) >> 2] = DATA_SLOT_1;

        // ===========================
        // TASK 15: DATA_SLOT_1 * 2 = 60
        // Input: DATA_SLOT_1 (will read 30)
        // Output: DATA_SLOT_2
        // Next: Task 63
        // ===========================
        // NOTE: chain_task.wat reads OpA/OpB as immediate f32 values.
        // To read FROM memory, we need a different command structure.
        // For this prototype, we'll use a workaround:
        // OpA will be a POINTER, and we modify execute_task to dereference if Opcode > 10? 
        // OR: We use FUNC_INDEX for a "load-from-pointer" variant.
        // SIMPLER: Let's use a "MUL_PTR" opcode (e.g., 11) where OpA is a PTR.
        // This requires a small chain_task.wat update.
        // 
        // ALTERNATIVE (No WASM change): Write the next command AFTER T0 executes?
        // That breaks "pre-configuration".
        //
        // DECISION: Add OP_ADD_PTR (11), OP_SUB_PTR (12), etc. to chain_task.wat.
        //           OpA is a PTR, OpB is immediate.
        //
        // For now, let's demonstrate with a simpler indirect: T15's OpA IS the value at DATA_SLOT_1.
        // We can't do this without a WASM update. Let me add OP_MUL_PTR.

        // >>> THIS REQUIRES A WASM UPDATE. Proceeding with that first. <<<
        // For the sake of this test setup, I'll assume OP_MUL_PTR = 13.

        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 15, 13, 63); // Op MUL_PTR (13), Next 63
        const t15_ptr = CHAIN_BLOCK_PTR + 128 + (15 * 64);
        i32[(t15_ptr + 32) >> 2] = 1;
        i32[(t15_ptr + 64) >> 2] = 16016;
        // Command: MUL *DATA_SLOT_1, 2.0 -> DATA_SLOT_2
        i32[(16016 + 0) >> 2] = 13; // OP_MUL_PTR
        i32[(16016 + 4) >> 2] = DATA_SLOT_1; // PTR to OpA
        f32[(16016 + 8) >> 2] = 2.0; // OpB immediate
        i32[(16016 + 12) >> 2] = DATA_SLOT_2;

        // ===========================
        // TASK 63: DATA_SLOT_2 - 10 = 50
        // ===========================
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 63, 12, -1); // Op SUB_PTR (12), End
        const t63_ptr = CHAIN_BLOCK_PTR + 128 + (63 * 64);
        i32[(t63_ptr + 32) >> 2] = 1;
        i32[(t63_ptr + 64) >> 2] = 16032;
        // Command: SUB *DATA_SLOT_2, 10.0 -> FINAL_RESULT
        i32[(16032 + 0) >> 2] = 12; // OP_SUB_PTR
        i32[(16032 + 4) >> 2] = DATA_SLOT_2; // PTR to OpA
        f32[(16032 + 8) >> 2] = 10.0;
        i32[(16032 + 12) >> 2] = FINAL_RESULT;

        // ACTIVATE ONLY TASK 0
        console.log("Activating ONLY Task 0 (Igniting Data Flow Chain)...");
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 0);

        // Spawn Workers
        const workerCount = 4;
        const workers = [];

        const workerCode = `
onmessage = async (e) => {
    const { memory, workerModule, taskModule, id, chainPtr } = e.data;
    try {
        const taskInstance = await WebAssembly.instantiate(taskModule, {
             env: { memory: memory } 
        });
        const workerInstance = await WebAssembly.instantiate(workerModule, {
            env: { memory: memory },
            task: { execute_task: taskInstance.exports.execute_task }
        });
        if (workerInstance.exports.start) {
            workerInstance.exports.start(id, performance.now(), chainPtr);
        }
    } catch (err) {
        console.error(\`Worker \${id} Error:\`, err);
    }
};
        `;

        const blob = new Blob([workerCode], { type: 'application/javascript' });
        const workerUrl = URL.createObjectURL(blob);

        for (let i = 0; i < workerCount; i++) {
            const worker = new Worker(workerUrl);
            workers.push(worker);
            worker.postMessage({
                memory: memory,
                workerModule: workerModule,
                taskModule: taskModule,
                id: i,
                chainPtr: CHAIN_BLOCK_PTR
            });
        }

        let interval = setInterval(() => {
            const r1 = f32[DATA_SLOT_1 >> 2];
            const r2 = f32[DATA_SLOT_2 >> 2];
            const r3 = f32[FINAL_RESULT >> 2];
            console.log(`Data Flow: Slot1=${r1} (Exp 30), Slot2=${r2} (Exp 60), Final=${r3} (Exp 50)`);

            if (r1 === 30 && r2 === 60 && r3 === 50) {
                console.log("DATA FLOW COMPLETE! ➡️ 30 ➡️ 60 ➡️ 50 🎉");
            }
        }, 1000);

        setTimeout(() => {
            console.log("Sending CLOSE command...");
            for (let i = 0; i < workerCount; i++) {
                const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
                Atomics.store(i32, (base + 4) >> 2, 2);
            }
        }, 5000);

        setTimeout(() => {
            clearInterval(interval);
            console.log("Test Finished.");
        }, 7000);

    } catch (e) {
        console.error("Test Failed:", e);
    }
}

init();
