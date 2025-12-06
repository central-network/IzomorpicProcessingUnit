async function init() {
    console.log("Initializing Chain Architecture Test (v128 Smart Pool)...");

    // 1. Shared Memory
    const memory = new WebAssembly.Memory({
        initial: 10,
        maximum: 10,
        shared: true
    });

    const f32 = new Float32Array(memory.buffer);
    const i32 = new Int32Array(memory.buffer);

    // Memory Offsets
    const WORKER_MEMORY_BASE = 5120;
    const WORKER_HEADER_SIZE = 64;
    const GLOBAL_HEADER_SIZE = 64;

    // Chain Offsets
    // Let's place the Chain Block at offset 10000 (safe distance)
    const CHAIN_BLOCK_PTR = 10000;
    // Chain Block Structure: 
    // 0-63: Chain Header
    // 64-127: Task State Block
    // 128-4223: Task Headers

    // 2. Load Modules
    try {
        const [workerBytes, taskBytes, managerBytes] = await Promise.all([
            fetch('chain_worker.wasm').then(r => r.arrayBuffer()),
            fetch('chain_task.wasm').then(r => r.arrayBuffer()),
            fetch('chain_manager.wasm').then(r => r.arrayBuffer())
        ]);

        const workerModule = await WebAssembly.compile(workerBytes);
        const taskModule = await WebAssembly.compile(taskBytes);
        const managerModule = await WebAssembly.compile(managerBytes);

        // Instantiate Manager to setup Chain
        const managerInstance = await WebAssembly.instantiate(managerModule, {
            env: { memory: memory }
        });

        // Initialize Chain Block
        console.log("Initializing Chain Block...");
        managerInstance.exports.init_chain(CHAIN_BLOCK_PTR);

        // Setup 3 Tasks (ADD, SUB, MUL)
        // Task 0: Add 10 + 20 = 30
        const T0_TARGET = 15000;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 0, 1); // Op 1 = ADD
        const t0_ptr = CHAIN_BLOCK_PTR + 128 + (0 * 64);
        i32[(t0_ptr + 32) >> 2] = 1; // 1 Command
        i32[(t0_ptr + 64) >> 2] = 16000; // Cmd Buf 0
        // Write Command 0
        i32[(16000 + 0) >> 2] = 1;
        f32[(16000 + 4) >> 2] = 10.0;
        f32[(16000 + 8) >> 2] = 20.0;
        i32[(16000 + 12) >> 2] = T0_TARGET;

        // Task 15: Sub 100 - 50 = 50
        const T15_TARGET = 15004;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 15, 2); // Op 2 = SUB
        const t15_ptr = CHAIN_BLOCK_PTR + 128 + (15 * 64);
        i32[(t15_ptr + 32) >> 2] = 1;
        i32[(t15_ptr + 64) >> 2] = 16016; // Cmd Buf 1
        // Write Command 1
        i32[(16016 + 0) >> 2] = 2;
        f32[(16016 + 4) >> 2] = 100.0;
        f32[(16016 + 8) >> 2] = 50.0;
        i32[(16016 + 12) >> 2] = T15_TARGET;

        // Task 63: Mul 5 * 5 = 25
        const T63_TARGET = 15008;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 63, 3); // Op 3 = MUL
        const t63_ptr = CHAIN_BLOCK_PTR + 128 + (63 * 64);
        i32[(t63_ptr + 32) >> 2] = 1;
        i32[(t63_ptr + 64) >> 2] = 16032; // Cmd Buf 2
        // Write Command 2
        i32[(16032 + 0) >> 2] = 3;
        f32[(16032 + 4) >> 2] = 5.0;
        f32[(16032 + 8) >> 2] = 5.0;
        i32[(16032 + 12) >> 2] = T63_TARGET;

        // ACTIVATE TASKS
        console.log("Activating Tasks...");
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 0);
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 15);
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 63);


        // 3. Spawn Workers
        const workerCount = 4;
        const workers = [];

        const workerCode = `
onmessage = async (e) => {
    const { memory, workerModule, taskModule, id, createEpoch, chainPtr } = e.data;
    const f32 = new Float32Array(memory.buffer);
    
    // Helper to write epoch
    // Base = 5120 + 64 + (id * 64)
    const BASE = 5120 + 64 + (id * 64);
    
    // 1. WORKER_CREATE_EPOCH (Offset 28)
    // (BASE + 28) -> f32 index = (BASE + 28) >> 2
    f32[(BASE + 28) >> 2] = createEpoch; 

    try {
        // Instantiate Task Module first
        const taskInstance = await WebAssembly.instantiate(taskModule, {
            env: { memory: memory } 
        });

        // Instantiate Worker Module with import
        const workerInstance = await WebAssembly.instantiate(workerModule, {
            env: { memory: memory },
            task: { execute_task: taskInstance.exports.execute_task }
        });
        
        console.log(\`Worker \${id} Starting...\`);
        if (workerInstance.exports.start) {
            // Pass Chain Pointer to start
            workerInstance.exports.start(id, performance.now(), chainPtr);
        }
        
        // 4. WORKER_CLOSE_EPOCH (Offset 40)
        // We reach here after start returns
        f32[(BASE + 40) >> 2] = performance.now();
        
        console.log(\`Worker \${id} Exited.\`);

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

            // 0. WINDOW_CREATE_EPOCH (Offset 12)
            const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
            f32[(base + 12) >> 2] = performance.now();

            // 1. WINDOW_DEPLOY_EPOCH (Offset 16)
            f32[(base + 16) >> 2] = performance.now();

            worker.postMessage({
                memory: memory,
                workerModule: workerModule,
                taskModule: taskModule,
                id: i,
                createEpoch: performance.now(),
                chainPtr: CHAIN_BLOCK_PTR
            });
        }

        // Monitoring Loop
        let interval = setInterval(() => {
            let output = "";
            for (let i = 0; i < workerCount; i++) {
                const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
                output += `[W${i}: ${i32[(base + 8) >> 2]}] `;
            }
            console.log("States:", output);

            const r0 = f32[T0_TARGET >> 2];
            const r1 = f32[T15_TARGET >> 2];
            const r2 = f32[T63_TARGET >> 2];

            if (r0 !== 0 || r1 !== 0 || r2 !== 0) {
                console.log(`Results: T0=${r0} (Exp 30), T15=${r1} (Exp 50), T63=${r2} (Exp 25)`);
            }

            if (r0 === 30 && r1 === 50 && r2 === 25) {
                console.log("ALL TASKS COMPLETED SUCCESSFULLY! 🎉");
                // Stop early? No, let them idle loop to test stability.
            }

        }, 1000);

        // Kill after 5s
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