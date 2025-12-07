
async function init() {
    console.log("Initializing Branching Logic Test (Conditional Chains)...");

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

    // Result Locations
    const CMP_RESULT_1 = 15000; // T0 comparison result
    const CMP_RESULT_2 = 15004; // T1 comparison result
    const TRUE_PATH_MARKER = 15100; // Written by T10 (True Path)
    const FALSE_PATH_MARKER = 15200; // Written by T20 (False Path)

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
        // SCENARIO 1: 30 > 25 -> TRUE
        // T0: Compare 30 > 25 -> Result = 1.0
        // NEXT_TRUE (offset 0) = 10
        // NEXT_FALSE (offset 8) = 20
        // ===========================
        const t0_ptr = CHAIN_BLOCK_PTR + 128 + (0 * 64);
        i32[(t0_ptr + 0) >> 2] = 10;  // NEXT_TRUE
        i32[(t0_ptr + 8) >> 2] = 20;  // NEXT_FALSE
        i32[(t0_ptr + 32) >> 2] = 1;  // 1 Command
        i32[(t0_ptr + 64) >> 2] = 16000; // Cmd Buf
        // Command: CMP_GT 30.0, 25.0 -> CMP_RESULT_1
        i32[(16000 + 0) >> 2] = 21; // OP_CMP_GT
        f32[(16000 + 4) >> 2] = 30.0;
        f32[(16000 + 8) >> 2] = 25.0;
        i32[(16000 + 12) >> 2] = CMP_RESULT_1;

        // T10 (True Path): Write 1.0 to TRUE_PATH_MARKER
        const t10_ptr = CHAIN_BLOCK_PTR + 128 + (10 * 64);
        i32[(t10_ptr + 0) >> 2] = -1; // End
        i32[(t10_ptr + 8) >> 2] = -1;
        i32[(t10_ptr + 32) >> 2] = 1;
        i32[(t10_ptr + 64) >> 2] = 16100;
        i32[(16100 + 0) >> 2] = 1; // OP_ADD
        f32[(16100 + 4) >> 2] = 1.0;
        f32[(16100 + 8) >> 2] = 0.0;
        i32[(16100 + 12) >> 2] = TRUE_PATH_MARKER;

        // T20 (False Path): Write 1.0 to FALSE_PATH_MARKER  
        const t20_ptr = CHAIN_BLOCK_PTR + 128 + (20 * 64);
        i32[(t20_ptr + 0) >> 2] = -1;
        i32[(t20_ptr + 8) >> 2] = -1;
        i32[(t20_ptr + 32) >> 2] = 1;
        i32[(t20_ptr + 64) >> 2] = 16200;
        i32[(16200 + 0) >> 2] = 1; // OP_ADD
        f32[(16200 + 4) >> 2] = 1.0;
        f32[(16200 + 8) >> 2] = 0.0;
        i32[(16200 + 12) >> 2] = FALSE_PATH_MARKER;

        // ACTIVATE T0
        console.log("Activating T0 (30 > 25 comparison)...");
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
            const cmp1 = f32[CMP_RESULT_1 >> 2];
            const truePath = f32[TRUE_PATH_MARKER >> 2];
            const falsePath = f32[FALSE_PATH_MARKER >> 2];

            console.log(`CMP(30>25)=${cmp1}, TruePath=${truePath}, FalsePath=${falsePath}`);

            if (truePath === 1 && falsePath === 0) {
                console.log("✅ TRUE PATH TAKEN! (30 > 25 is TRUE)");
            } else if (falsePath === 1 && truePath === 0) {
                console.log("❌ FALSE PATH TAKEN (Unexpected)");
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
