
async function init() {
    console.log("Initializing Worker Lifecycle Test...");

    // 1. Shared Memory
    const memory = new WebAssembly.Memory({
        initial: 10,
        maximum: 10,
        shared: true
    });

    // View for state checking
    const u8 = new Uint8Array(memory.buffer);
    const WORKER_HEADER_SIZE = 64;
    const GLOBAL_HEADER_SIZE = 64; // Offset individual starts at 64
    const WORKER_MEMORY_BASE = 5120; // Must match WAT

    function getWorkerIndices(id) {
        // Base = 5120 + 64 + (id * 64)
        const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (id * WORKER_HEADER_SIZE);
        return {
            mutex: base + 0,           // i32
            windowLastState: base + 4, // i32
            workerLastState: base + 8, // i32
            // Epochs Start at 12 (0x0C)
            epochsStart: base + 12
        };
    }

    // View for float reading
    const f32 = new Float32Array(memory.buffer);
    // View for i32 reading (easier for states now)
    const i32 = new Int32Array(memory.buffer);

    // 2. Load Module
    try {
        const response = await fetch('chain_worker.wasm');
        const bytes = await response.arrayBuffer();
        const module = await WebAssembly.compile(bytes);

        // 3. Spawn Workers
        const workerCount = 4;
        const workers = [];

        const workerCode = `
onmessage = async (e) => {
    const { memory, module, id, createEpoch } = e.data;
    const f32 = new Float32Array(memory.buffer);
    
    // Helper to write epoch
    // Base = 5120 + 64 + (id * 64)
    const BASE = 5120 + 64 + (id * 64);
    
    // 1. WORKER_CREATE_EPOCH (Offset 28)
    // (BASE + 28) -> f32 index = (BASE + 28) >> 2
    f32[(BASE + 28) >> 2] = createEpoch; 

    try {
        const instance = await WebAssembly.instantiate(module, {
            env: { memory: memory } 
        });
        
        console.log(\`Worker \${id} Starting...\`);
        if (instance.exports.start) {
            // Pass ID and Current Time (Deploy Epoch)
            instance.exports.start(id, performance.now());
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
            const createTime = performance.now();
            const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
            f32[(base + 12) >> 2] = createTime;

            // 1. WINDOW_DEPLOY_EPOCH (Offset 16)
            f32[(base + 16) >> 2] = performance.now();

            worker.postMessage({
                memory: memory,
                module: module,
                id: i,
                createEpoch: performance.now() // For worker to log as its "receive" time approx? 
                // Actually WORKER_CREATE_EPOCH is "onmessage alındı". Worker does it.
            });
        }

        // 4. Controller Logic (Window)
        console.log("Monitoring Workers...");

        let interval = setInterval(() => {
            let output = "";
            let allStarted = true;

            for (let i = 0; i < workerCount; i++) {
                const idx = getWorkerIndices(i);
                // States are i32 now, reading from i32 array
                // Index is byte_offset >> 2
                const wState = i32[idx.workerLastState >> 2];
                output += `[W${i}: ${wState}] `;

                if (wState === 0) allStarted = false;
            }
            console.log("States:", output);

            // Log Epochs for Worker 0 occasionally
            const base0 = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE; // Worker 0
            const deployEpoch = f32[(base0 + 32) >> 2]; // WORKER_DEPLOY_EPOCH (Offset 32)
            if (deployEpoch > 0) {
                console.log(`W0 Deploy Epoch: ${deployEpoch}`);
            }

        }, 1000);

        // After 3 seconds, kill them all
        setTimeout(() => {
            console.log("Sending CLOSE command...");
            // WINDOW_DESTROY_EPOCH (Offset 20)
            const destroyTime = performance.now();

            for (let i = 0; i < workerCount; i++) {
                const idx = getWorkerIndices(i);
                // Set Window State to CLOSE (2)
                Atomics.store(i32, idx.windowLastState >> 2, 2);

                // Write Destroy Epoch
                const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE + (i * WORKER_HEADER_SIZE);
                f32[(base + 20) >> 2] = destroyTime;
            }
        }, 3000);

        setTimeout(() => {
            clearInterval(interval);
            console.log("Test Finished. Final Epoch Check for Worker 0:");
            const base = WORKER_MEMORY_BASE + GLOBAL_HEADER_SIZE;
            const epochs = {
                WinCreate: f32[(base + 12) >> 2],
                WinDeploy: f32[(base + 16) >> 2],
                WinDestroy: f32[(base + 20) >> 2],
                WinClose: f32[(base + 24) >> 2],
                WorkCreate: f32[(base + 28) >> 2],
                WorkDeploy: f32[(base + 32) >> 2],
                WorkDestroy: f32[(base + 36) >> 2],
                WorkClose: f32[(base + 40) >> 2],
            };
            console.table(epochs);

        }, 5000);

    } catch (e) {
        console.error("Test Failed:", e);
    }
}

init();