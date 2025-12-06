WebAssembly.instantiateStreaming(fetch("cpu.wasm"), self).then(async wasm => {
    self.cpu = wasm.instance.exports;
    log("CPU loaded");

    // Helper to delay
    const delay = ms => new Promise(r => setTimeout(r, ms));

    function log(msg, data) {
        console.log(msg, data || "");
        const div = document.createElement("div");
        div.textContent = msg + (data ? " " + JSON.stringify(data) : "");
        document.body.appendChild(div);
    }

    try {
        // 1. Sequential Test
        log("--- Test 1: Sequential Requests (Queue Test) ---");
        const len = 1000;
        const source = cpu.new(Float32Array, len);

        // Fill with data
        for (let i = 0; i < len; i++) source[i] = 1;

        log("Firing 3 requests immediately...");

        const p1 = cpu.add(source, source, source);
        const p2 = cpu.add(source, source, source);
        const p3 = cpu.add(source, source, source);

        log("Requests fired. Waiting for results...");

        await p1;
        log("Request 1 completed.");

        await p2;
        log("Request 2 completed.");

        await p3;
        log("Request 3 completed.");

        log("All sequential requests completed.");

        // 2. Burst Test (Race Condition Check)
        log("--- Test 2: Burst Requests (Race Condition Check) ---");
        const burstCount = 20;
        log(`Firing ${burstCount} requests in a loop...`);

        const burstPromises = [];
        for (let i = 0; i < burstCount; i++) {
            burstPromises.push(cpu.add(source, source, source));
        }

        await Promise.all(burstPromises);
        log("All burst requests completed without error.");

        // 2. Wait for auto-close
        log("--- Test 2: Waiting for Auto-Close (1500ms) ---");
        await delay(1500);

        let dump = cpu.dump();
        log("Dump (should be closed):", dump);

        if (dump.active_workers === 0) {
            log("Workers closed successfully.");
        } else {
            log("WARNING: active_workers is " + dump.active_workers);
        }

        log("TEST PASSED");

    } catch (e) {
        log("TEST FAILED: " + e.toString());
        console.error(e);
    }
});
