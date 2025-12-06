
async function init() {
    console.log("Initializing Chain Reaction Test (Domino Effect)...");

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

    const CHAIN_BLOCK_PTR = 10000;

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

        // Instantiate Manager
        const managerInstance = await WebAssembly.instantiate(managerModule, {
            env: { memory: memory }
        });

        // Initialize Chain Block
        console.log("Initializing Chain Block...");
        managerInstance.exports.init_chain(CHAIN_BLOCK_PTR);

        // Setup Chain: T0 -> T15 -> T63

        // Task 0: Add 10 + 20 = 30. NEXT -> 15
        const T0_TARGET = 15000;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 0, 1, 15); // Op 1, Next 15
        const t0_ptr = CHAIN_BLOCK_PTR + 128 + (0 * 64);
        i32[(t0_ptr + 32) >> 2] = 1;
        i32[(t0_ptr + 64) >> 2] = 16000;
        // Command 0
        i32[(16000 + 0) >> 2] = 1;
        f32[(16000 + 4) >> 2] = 10.0;
        f32[(16000 + 8) >> 2] = 20.0;
        i32[(16000 + 12) >> 2] = T0_TARGET;

        // Task 15: Sub 100 - 50 = 50. NEXT -> 63
        const T15_TARGET = 15004;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 15, 2, 63); // Op 2, Next 63
        const t15_ptr = CHAIN_BLOCK_PTR + 128 + (15 * 64);
        i32[(t15_ptr + 32) >> 2] = 1;
        i32[(t15_ptr + 64) >> 2] = 16016;
        // Command 1
        i32[(16016 + 0) >> 2] = 2;
        f32[(16016 + 4) >> 2] = 100.0;
        f32[(16016 + 8) >> 2] = 50.0;
        i32[(16016 + 12) >> 2] = T15_TARGET;

        // Task 63: Mul 5 * 5 = 25. NEXT -> -1 (End)
        const T63_TARGET = 15008;
        managerInstance.exports.prepare_task(CHAIN_BLOCK_PTR, 63, 3, -1); // Op 3, Next -1
        const t63_ptr = CHAIN_BLOCK_PTR + 128 + (63 * 64);
        i32[(t63_ptr + 32) >> 2] = 1;
        i32[(t63_ptr + 64) >> 2] = 16032;
        // Command 2
        i32[(16032 + 0) >> 2] = 3;
        f32[(16032 + 4) >> 2] = 5.0;
        f32[(16032 + 8) >> 2] = 5.0;
        i32[(16032 + 12) >> 2] = T63_TARGET;

        // ACTIVATE ONLY TASK 0
        console.log("Activating ONLY Task 0 (Igniting Chain)...");
        managerInstance.exports.activate_task(CHAIN_BLOCK_PTR, 0);


        // 3. Spawn Workers
        const workerCount = 4;
        const workers = [];

        const workerCode = `
onmessage = async (e) => {
    const { memory, workerModule, taskModule, id, createEpoch, chainPtr } = e.data;
    const f32 = new Float32Array(memory.buffer);
    const BASE = 5120 + 64 + (id * 64);
    f32[(BASE + 28) >> 2] = createEpoch; 

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
                console.log("CHAIN REACTION COMPLETE! 🔗💥");
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
