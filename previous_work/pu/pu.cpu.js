export default async function () {
    if (self.WebAssembly) {
        const wasm = new Uint8Array(String(
            '0061736d01000000011c066000017f60017f006000017b6000037f7b7f60000060037f7b7f00028e02100130066d656d6f727902038080048080040130096d7574657841646472037f0001300b746872656164496e646578037f0001300e64617461427974654f6666736574037f0001300b4f46465345545f46554e43037f0001300a4f46465345545f425045037f0001300c4f46465345545f56414c5545037f000130174f46465345545f42595445535f5045525f544852454144037f000130174f46465345545f434f554e545f5045525f544852454144037f000130076633325f616464037f000130076633325f6d756c037f000130076633325f737562037f000130076633325f646976037f000130076933325f616464037f000130076933325f6d756c037f000130076933325f737562037f00031d1c000000000001010101010202020203000404040505050505050504040404017000080610037f0041000b7f0041010b7f0041020b070801046c6f6f70001a080112091c01057008d0700bd2130bd2140bd2150bd2160bd2170bd2180bd2190b0abc051c08002300fe1002040b08002300fe1002080b08002300fe10020c0b08002300fe1002100b08002300fe1002140b0a0023002000fe1702040b0a0023002000fe1702080b0a0023002000fe17020c0b0a0023002000fe1702100b0a0023002000fe1702140b08002305fd0700000b08002305fd0801000b08002305fd0902000b08002305fd0a03000b850103027f017b027f024023022301230628020022006c6a2101200010016a100620010d00000b02402304280200210420044101460440100a21020c010b20044102460440100b21020c010b20044104460440100c21020c010b20044108460440100d21020c010b000b024023072802002103200310026a100720030d00000b2001200220030b1201017f23032802002200044020000f0b000b0900410110036a10080b0900100041016b10050b2f002308d21326002309d2142600230ad2152600230bd2162600230cd2172600230dd2182600230ed2192600fc0d000b28000340200241016b210220002000fd0004002001fde401fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fde601fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fde501fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fde701fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fdae01fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fdb501fd0b0400200041106a210020020d000b0b28000340200241016b210220002000fd0004002001fdb101fd0b0400200041106a210020020d000b0b1c001000044023111009100e100f11050010101011230f10090b101b0b180023004101fe0002001a23004100427ffe0102001a101a0b00f606046e616d6501c2021c000d7468726561642d3e776f726b73010d7468726561642d3e6274796573020d7468726561642d3e666c6f7073030d7468726561642d3e6379636c65040d7468726561642d3e7374617465050d776f726b732d3e746872656164060d62797465732d3e746872656164070d666c6f70732d3e746872656164080d6379636c652d3e746872656164090d73746174652d3e7468726561640a0b76616c75652f4250453a310b0b76616c75652f4250453a320c0b76616c75652f4250453a340d0b76616c75652f4250453a380e09617267756d656e74730f0768616e646c657210076379636c652b2b1107776f726b732d2d12046d61696e13076633325f61646414076633325f6d756c15076633325f73756216076633325f64697617076933325f61646418076933325f6d756c19076933325f7375621a046c6f6f701b046c6f636b0297021c00000100020003000400050006000700080009000a000b000c000d000e050005627974657301066f6666736574020576616c75650305636f756e7404036270650f01000466756e631000110012001303000a627974654f6666736574010576616c75650205636f756e741403000a627974654f6666736574010576616c75650205636f756e741503000a627974654f6666736574010576616c75650205636f756e741603000a627974654f6666736574010576616c75650205636f756e741703000a627974654f6666736574010576616c75650205636f756e741803000a627974654f6666736574010576616c75650205636f756e741903000a627974654f6666736574010576616c75650205636f756e741a001b00050701000463616c6306090100066d656d6f727907f2011200096d7574657841646472010b746872656164496e646578020e64617461427974654f6666736574030b4f46465345545f46554e43040a4f46465345545f42504505114f46465345545f56414c55452f76313238061b4f46465345545f42595445535f5045525f5448524541442f753332071b4f46465345545f434f554e545f5045525f5448524541442f75333208076633325f61646409076633325f6d756c0a076633325f7375620b076633325f6469760c076933325f6164640d076933325f6d756c0e076933325f7375620f0a53544154452f49444c45100a53544154452f4c4f434b110a53544154452f42555359080701000463616c63'
        ).match(/[a-f0-9]{2}/g).map(c => parseInt(c, 16)));

        const deviceMemory = (navigator?.deviceMemory || 1) * 1024 * 1024 * 10;// * 1024;
        const concurrency = (navigator?.hardwareConcurrency || 2) - 1;
        const threadMemory = Math.floor(deviceMemory / concurrency) - Math.floor(deviceMemory / concurrency) % 16 - 256;
        const memoryPages = 65536 || Math.floor(Math.min(deviceMemory / 65536, 65536 * 32768) / 65536);
        const THREAD_HEADER_LENGTH = 48;
        const MUTEXES_START_OFFSET = 64;
        const dataByteOffset = MUTEXES_START_OFFSET + THREAD_HEADER_LENGTH * (concurrency * 2);
        const scriptURL = URL.createObjectURL(new Blob([`
            addEventListener( "message", function (e) {
                WebAssembly
                    .instantiate(e.data.module, [e.data, console])
                    .then(({exports: e}) => { return postMessage(1), e.loop()})
                .catch(console.error)
            }, { once: true });
        `]));

        let module, alignBytes, maxBufferSize = Math.min(deviceMemory, 4096 * 4096 * 10);

        const threads = new Array();
        const memory = new WebAssembly.Memory({
            initial: memoryPages,
            maximum: memoryPages,
            shared: true
        });

        const taskView = new Int32Array(memory.buffer, 0, MUTEXES_START_OFFSET / Int32Array.BYTES_PER_ELEMENT);
        const dataView = new Int32Array(memory.buffer, dataByteOffset);


        const OFFSET_FUNC = 0;
        const OFFSET_BPE = 4;
        const OFFSET_VALUE = 8;
        const OFFSET_BYTES_PER_THREAD = 16;
        const OFFSET_COUNT_PER_THREAD = 20;

        const offsets = {
            OFFSET_FUNC,
            OFFSET_BPE,
            OFFSET_VALUE,
            OFFSET_BYTES_PER_THREAD,
            OFFSET_COUNT_PER_THREAD
        };

        const INDEX_FUNC = OFFSET_FUNC / taskView.BYTES_PER_ELEMENT;
        const INDEX_BPE = OFFSET_BPE / taskView.BYTES_PER_ELEMENT;
        const INDEX_VALUE = OFFSET_VALUE / taskView.BYTES_PER_ELEMENT;
        const INDEX_BYTES_PER_THREAD = OFFSET_BYTES_PER_THREAD / taskView.BYTES_PER_ELEMENT;
        const INDEX_COUNT_PER_THREAD = OFFSET_COUNT_PER_THREAD / taskView.BYTES_PER_ELEMENT;

        const funcref = Object({
            f32_add: 1,
            f32_mul: 2,
            f32_sub: 3,
            f32_div: 4,
            i32_add: 5,
            i32_mul: 6,
            i32_sub: 7,
        })

        const cpu = Object.setPrototypeOf({

            maxBufferSize,

            calc: function (func, value, input, output = input) {
                const { resolve, promise } = Promise.withResolvers();

                Atomics.store(taskView, INDEX_FUNC, funcref[func])
                Atomics.store(taskView, INDEX_BPE, value.BYTES_PER_ELEMENT)

                Reflect.construct(
                    value.constructor, [memory.buffer, taskView.byteOffset]
                ).set(value, INDEX_VALUE)

                Reflect.construct(
                    input.constructor, [memory.buffer, dataView.byteOffset]
                ).set(input)

                let REMAINED_ALIGN_BYTES = input.byteLength - input.byteLength % this.alignBytes;
                let BYTES_PER_THREAD = REMAINED_ALIGN_BYTES / this.concurrency;
                let COUNT_PER_THREAD = BYTES_PER_THREAD / 16;

                Atomics.store(taskView, INDEX_BYTES_PER_THREAD, BYTES_PER_THREAD)
                Atomics.store(taskView, INDEX_COUNT_PER_THREAD, COUNT_PER_THREAD)

                Promise.all(threads.map(w => w.unlock().value))
                    .then(() => {
                        output.set(
                            Reflect.construct(
                                output.constructor, [
                                memory.buffer, dataView.byteOffset, output.length
                            ]
                            )
                        );
                        resolve(output);
                    })

                return promise;
            },

            f32_add(value, input, output) { return this.calc("f32_add", Float32Array.of(value), input, output) },
            f32_mul(value, input, output) { return this.calc("f32_mul", Float32Array.of(value), input, output) },
            f32_sub(value, input, output) { return this.calc("f32_sub", Float32Array.of(value), input, output) },
            f32_div(value, input, output) { return this.calc("f32_div", Float32Array.of(value), input, output) },
            i32_add(value, input, output) { return this.calc("i32_add", Float32Array.of(value), input, output) },
            i32_mul(value, input, output) { return this.calc("i32_mul", Float32Array.of(value), input, output) },
            i32_sub(value, input, output) { return this.calc("i32_sub", Float32Array.of(value), input, output) },

            concurrency,
            alignBytes,
            buffer: memory.buffer,

        }, class cPU { }.prototype)


        function bind(worker, resolve, index) {

            threads.push(worker)

            cpu.concurrency = threads.length;
            cpu.alignBytes = 16 * cpu.concurrency;

            const mutexAddr = MUTEXES_START_OFFSET + (index * THREAD_HEADER_LENGTH);

            Object.defineProperties(worker, {
                mutexAddr: { value: mutexAddr },
                addwork: { value: Atomics.add.bind(Atomics, new Int32Array(memory.buffer, mutexAddr + 4, 1), 0, 1) },
                wait: { value: Atomics.waitAsync.bind(Atomics, new Int32Array(memory.buffer, mutexAddr, 1), 0, 0, 2000) },
                notify: { value: Atomics.notify.bind(Atomics, new Int32Array(memory.buffer, mutexAddr, 1), 0, 1) },
                unlock: { value: function () { return this.addwork(), this.notify(), this.wait(); } },
                headers: { get: function () { return new Int32Array(memory.buffer, this.mutexAddr, THREAD_HEADER_LENGTH / 4); } },
            })

            resolve(worker)
        }

        function drop(worker) {
            worker.onmessage = () => { }
            threads.splice(threads.indexOf(worker), 1)

            cpu.concurrency = threads.length;
            cpu.alignBytes = 16 * cpu.concurrency;

            if (!threads.length) { self.close() }
        }

        function fork(undef, index) {
            const worker = new Worker(scriptURL, { name: "cpu" });
            const { resolve, promise } = Promise.withResolvers()

            worker.addEventListener("error", () => drop(worker))
            worker.addEventListener("messageerror", () => drop(worker))
            worker.addEventListener("message", () => bind(worker, resolve, index), { once: 1 })

            worker.postMessage({
                module,
                memory,
                mutexAddr: MUTEXES_START_OFFSET + (index * THREAD_HEADER_LENGTH),
                dataByteOffset,
                threadIndex: index,
                ...offsets,
                ...funcref
            })

            return promise
        }

        return WebAssembly.compile(wasm)
            .then(compiled => module = compiled)
            .then(() => Array(concurrency).fill().map(fork))
            .then(async booting => Promise.all(booting))
            .then(workers => cpu.concurrency = (cpu.threads = workers).length)
            .then(concurrency => cpu.maxBufferSize = concurrency * threadMemory)
            .then(() => cpu)
            .catch(e => console.error(e), Object({ maxBufferSize: 0 }));
    }
    else { return { maxBufferSize: 0 } }
}

