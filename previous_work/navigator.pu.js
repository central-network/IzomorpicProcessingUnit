import * as common from "./common.js"

import puCPU from "./pu/pu.cpu.js"
import puGPU from "./pu/pu.gpu.js"
import puNPU from "./pu/pu.npu.js"
import puBPU from "./pu/pu.bpu.js"

let bpu, gpu, npu, cpu;

const IS_BPU_ENABLED = false;
const IS_GPU_ENABLED = true;
const IS_CPU_ENABLED = true;
const IS_NPU_ENABLED = true;

export default class LocalNavigatorProcessorService {

    #queue = new Array();
    isIdle = false;
    #processors = new Array()

    hasBPU = false
    hasGPU = false
    hasNPU = false
    hasCPU = false

    maxBufferSize = 0
    bytesCalculated = 0

    get hasJob() { return this.#queue.length > 0; }
    get next() { return this.#queue.splice(0, 1).at(0); }
    get time() { return performance.timeOrigin; }
    get now() { return performance.now(); }


    constructor() {
        Promise
            .all([puBPU(), puGPU(), puNPU(), puCPU()])
            .then(PUs => {

                this.#processors.push.apply(
                    this.#processors, [bpu, gpu, npu, cpu] = PUs
                )

                if (this.hasBPU = IS_BPU_ENABLED && Boolean(bpu.maxBufferSize)) {
                    this.maxBufferSize += bpu.maxBufferSize;
                }

                if (this.hasGPU = IS_GPU_ENABLED && Boolean(gpu.maxBufferSize)) {
                    this.maxBufferSize += gpu.maxBufferSize;
                }

                if (this.hasNPU = IS_NPU_ENABLED && Boolean(npu.maxBufferSize)) {
                    this.maxBufferSize += npu.maxBufferSize;
                }

                if (this.hasCPU = IS_CPU_ENABLED && Boolean(cpu.maxBufferSize)) {
                    this.maxBufferSize += cpu.maxBufferSize;
                }

                if (this.maxBufferSize) {
                    this.maxBufferSize -= this.maxBufferSize % 16;
                }

                PUs.forEach(p => p.byteRegulateFactor = 1)

                this.isIdle = true;
            })
            .then(async () => this.processQueue())
            .then(async () => {
                const {
                    bpuProcessRatio = 0,
                    gpuProcessRatio = 0,
                    npuProcessRatio = 0,
                    cpuProcessRatio = 0,
                } = await this.calc(
                    "f32_mul",
                    Math.random(),
                    new Float32Array(14433442).map(Math.random)
                );

                const totalProcessRatio = (
                    bpuProcessRatio +
                    gpuProcessRatio +
                    npuProcessRatio +
                    cpuProcessRatio
                );

                const totalUnitCount = (
                    (bpuProcessRatio && 1 || 0) +
                    (gpuProcessRatio && 1 || 0) +
                    (npuProcessRatio && 1 || 0) +
                    (cpuProcessRatio && 1 || 0)
                );

                const avgRatioPerUnit = totalProcessRatio / totalUnitCount;

                bpu.byteRegulateFactor = bpuProcessRatio && (avgRatioPerUnit / bpuProcessRatio) || 0;
                gpu.byteRegulateFactor = gpuProcessRatio && (avgRatioPerUnit / gpuProcessRatio) || 0;
                npu.byteRegulateFactor = npuProcessRatio && (avgRatioPerUnit / npuProcessRatio) || 0;
                cpu.byteRegulateFactor = cpuProcessRatio && (avgRatioPerUnit / cpuProcessRatio) || 0;

                console.error({
                    bpuByteRegulateFactor: bpu.byteRegulateFactor,
                    gpuByteRegulateFactor: gpu.byteRegulateFactor,
                    npuByteRegulateFactor: npu.byteRegulateFactor,
                    cpuByteRegulateFactor: cpu.byteRegulateFactor,
                })
            })
            .catch(console.error)
            ;
    }

    calc(func, value, input, output = input) {
        if (output !== input) {
            if (!(output instanceof input.constructor)) {
                output = new input.constructor(input.length);
            }

            output.set(input.subarray(0, output.length));
        }

        return new Promise(resolve => {
            const job = Object({
                __proto__: null,
                func,
                value,
                input,
                output,
                length: input.length,
                byteLength: input.byteLength,
                jobUuid: common.generateUUID()
            });

            Reflect.defineProperty(job, "resolve", {
                value: resolve
            });

            this.#queue.push(job);
            this.processQueue();
        })
    }

    async distrubute(job) {
        const { func, value, output: input } = job;

        const promises = new Array();
        const BYTES_PER_ELEMENT = input.BYTES_PER_ELEMENT;

        let bpuInput,
            gpuInput,
            npuInput,
            cpuInput,

            byteOffset = 0,
            byteLength = input.byteLength;

        let loopProtect = 12;
        while (byteLength > 0) {

            if (!loopProtect--) {
                throw { maxloopreached: byteLength }
            }

            if (byteLength && this.hasBPU) {
                const bpuByteOffset = 0;
                const bpuByteLength = bpu.maxBufferSize * bpu.byteRegulateFactor + input.byteLength % 48;
                const bpuBegin = bpuByteOffset / BYTES_PER_ELEMENT;
                const bpuEnd = bpuBegin + bpuByteLength / BYTES_PER_ELEMENT;

                bpuInput = input.subarray(bpuBegin, bpuEnd);

                byteLength -= bpuByteLength;
                byteOffset += bpuByteLength;

                job.bpuStartedAt = this.now;
                job.bpuUnitBytes = bpuByteLength;

                promises.push(
                    bpu[func](value, bpuInput).then(() => {
                        job.bpuFinishedAt = this.now
                        job.bpuElapsedTime = this.now - job.bpuStartedAt;
                        job.bpuProcessRatio = job.bpuElapsedTime / job.bpuUnitBytes * 1e6;
                    })
                );
            }

            if (byteLength && this.hasGPU) {
                const gpuByteOffset = byteOffset;
                const gpuByteLength = Math.min(byteLength, gpu.maxBufferSize) * gpu.byteRegulateFactor;
                const gpuBegin = gpuByteOffset / BYTES_PER_ELEMENT;
                const gpuEnd = gpuBegin + gpuByteLength / BYTES_PER_ELEMENT;

                gpuInput = input.subarray(gpuBegin, gpuEnd);

                byteLength -= gpuByteLength;
                byteOffset += gpuByteLength;

                job.gpuStartedAt = this.now;
                job.gpuUnitBytes = gpuByteLength;

                promises.push(
                    gpu[func](value, gpuInput).then(() => {
                        job.gpuFinishedAt = this.now;
                        job.gpuElapsedTime = this.now - job.gpuStartedAt;
                        job.gpuProcessRatio = job.gpuElapsedTime / job.gpuUnitBytes * 1e6;
                    })
                );
            }

            if (byteLength && this.hasNPU) {
                const npuByteOffset = byteOffset;
                const npuByteLength = Math.min(byteLength, npu.maxBufferSize) * npu.byteRegulateFactor;
                const npuBegin = npuByteOffset / BYTES_PER_ELEMENT;
                const npuEnd = npuBegin + npuByteLength / BYTES_PER_ELEMENT;

                npuInput = input.subarray(npuBegin, npuEnd);

                byteLength -= npuByteLength;
                byteOffset += npuByteLength;

                job.npuStartedAt = this.now;
                job.npuUnitBytes = npuByteLength;

                promises.push(
                    npu[func](value, npuInput).then(() => {
                        job.npuFinishedAt = this.now;
                        job.npuElapsedTime = this.now - job.npuStartedAt;
                        job.npuProcessRatio = job.npuElapsedTime / job.npuUnitBytes * 1e6;
                    })
                );
            }

            if (byteLength && this.hasCPU) {
                const cpuByteOffset = byteOffset;
                const cpuByteLength = Math.min(byteLength, cpu.maxBufferSize) * cpu.byteRegulateFactor;
                const cpuBegin = cpuByteOffset / BYTES_PER_ELEMENT;
                const cpuEnd = cpuBegin + cpuByteLength / BYTES_PER_ELEMENT;

                cpuInput = input.subarray(cpuBegin, cpuEnd);

                byteLength -= cpuByteLength;
                byteOffset += cpuByteLength;

                job.cpuStartedAt = this.now;
                job.cpuUnitBytes = cpuByteLength;

                promises.push(
                    cpu[func](value, cpuInput).then(() => {
                        job.cpuFinishedAt = this.now;
                        job.cpuElapsedTime = this.now - job.cpuStartedAt;
                        job.cpuProcessRatio = job.cpuElapsedTime / job.cpuUnitBytes * 1e6;
                    })
                );
            }
        }

        if (byteLength) {
            if (byteOffset) {
                throw "another job cycle required.."
            }
            throw "this device has no power?"
        }

        Promise.all(promises)
            .then(() => this.bytesCalculated += input.byteLength)
            .then(() => this.finalizeJob(job))
            //.then(() => console.warn( func, value, this.bytesCalculated ) )
            .catch(console.error);
    }

    f32_add(value, input) { return this.calc("f32_add", value, input) }
    f32_mul(value, input) { return this.calc("f32_mul", value, input) }
    f32_sub(value, input) { return this.calc("f32_sub", value, input) }
    f32_div(value, input) { return this.calc("f32_div", value, input) }

    processQueue() {
        if (this.isIdle && this.hasJob) {
            this.isIdle = false;
            const job = this.next;
            job.startedAt = this.now;
            this.distrubute(job);
            job.timeOrigin = this.time;
        }
    }

    finalizeJob(job) {
        job.finishedAt = this.now;
        job.elapsedTime = job.finishedAt - job.startedAt;

        job.resolve(job);
        this.isIdle = true;
        this.processQueue();
    }
}