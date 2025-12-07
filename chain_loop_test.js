
async function init() {
    console.log("Initializing Loop Logic Test (Self-Reactivating Tasks)...");

    const memory = new WebAssembly.Memory({
        initial: 10,
        maximum: 10,
        shared: true
    });

    const f32 = new Float32Array(memory.buffer);
    const i32 = new Int32Array(memory.buffer);
    const u8 = new Uint8Array(memory.buffer);

    const WORKER_MEMORY_BASE = 5120;
    const WORKER_HEADER_SIZE = 64;
    const GLOBAL_HEADER_SIZE = 64;

    const CHAIN_BLOCK_PTR = 10000;

    // Accumulator Location
    const ACCUMULATOR = 15000;

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
        // TASK 0: ADD *ACCUMULATOR + 10 -> ACCUMULATOR
        // LOOP_COUNT = 3 (will run 4 times total: initial + 3 loops)
        // Actually LOOP_COUNT = 3 means 3 more iterations after first.
        // Expected: 0 + 10 = 10 -> 10 + 10 = 20 -> 20 + 10 = 30 -> 30 + 10 = 40
        // ===========================
        const t0_ptr = CHAIN_BLOCK_PTR + 128 + (0 * 64);
        i32[(t0_ptr + 0) >> 2] = -1;   // NEXT_TRUE (after loop done)
        i32[(t0_ptr + 8) >> 2] = -1;   // NEXT_FALSE
        u8[t0_ptr + 6] = 3;            // LOOP_COUNT = 3
        i32[(t0_ptr + 32) >> 2] = 1;   // 1 Command
        i32[(t0_ptr + 64) >> 2] = 16000; // Cmd Buf

        // Command: ADD_PTR *ACCUMULATOR + 10 -> ACCUMULATOR
        i32[(16000 + 0) >> 2] = 11; // OP_ADD_PTR
        i32[(16000 + 4) >> 2] = ACCUMULATOR; // OpA = PTR to accumulator
        f32[(16000 + 8) >> 2] = 10.0;
        i32[(16000 + 12) >> 2] = ACCUMULATOR;

        // Initialize Accumulator
        f32[ACCUMULATOR >> 2] = 0.0;

        // ACTIVATE T0
        console.log("Activating T0 (LOOP_COUNT=3, will add 10 four times)...");
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 0);

        // Spawn Workers
        const workerCount = 2;
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
            const acc = f32[ACCUMULATOR >> 2];
            const loops = u8[t0_ptr + 6];
            console.log(`Accumulator=${acc} (Exp 40), LoopsRemaining=${loops}`);

            if (acc === 40) {
                console.log("🔁 LOOP COMPLETE! 10 + 10 + 10 + 10 = 40");
            }
        }, 500);

        setTimeout(() => {
            console.log("Sending CLOSE command...");
            for (let i = 0; i < workerCount; i++) {
                const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
                Atomics.store(i32, (base + 4) >> 2, 2);
            }
        }, 4000);

        setTimeout(() => {
            clearInterval(interval);
            console.log("Test Finished.");
        }, 5000);

    } catch (e) {
        console.error("Test Failed:", e);
    }
}

init();
