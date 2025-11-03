import enumerate from "./node_modules/niceenum/index.js"

function replaceWASM(buffer, target, offset = 0) {
    const offsetMagic = 0x26e22a98;
    const memoryMagic = 0x00010000;
    
    function encodeLeb128 (value) {
        if (!value) { return [0] }

        const bytes = [];
        let byte;

        do {
            byte = value & 0x7F;
            if (value = value >>> 7) {
                byte = byte | 0x80;
            }
            bytes.push(byte);
        } while (value > 0); 

        return bytes;
    }

    function findBufferIndex (buffer, search, offset = 0) {
        return new Uint8Array(buffer, offset).findIndex((v, i, t) => 
            search.every((b, j) => b === t[j + i])
        );
    }

    function replaceData (buffer, search, replace, max = -1) {
        if (search.length !== replace.length) {
            throw `Search and replace lengths must be equal (${search.length} !== ${replace.length})`;
        }
        
        let array = new Uint8Array(buffer);
        let index = findBufferIndex(buffer, search, 0);

        const length = search.length;
        while (index !== -1 && max--) {
            array.set(replace, index);
            
            array = array.subarray(index + length);
            index = array.findIndex((v, i, t) => 
                search.every((b, j) => b === t[j + i])
            );
        }
    }

    function alignOffset (buffer, offset = 0, magic = offsetMagic) {

        offset  = encodeLeb128(offset);
        magic   = encodeLeb128(magic);

        const search = new Uint8Array( magic );
        const replace = new Uint8Array( magic.length ).fill(1);
        
        replace.set( offset );
        replaceData( buffer, search, replace );
        
        return buffer;
    }
    
    function resizeMemory (buffer, initial, maximum, shared, magic) {

        initial = encodeLeb128(initial);
        maximum = encodeLeb128(maximum);
        magic   = encodeLeb128(magic);

        const search = new Uint8Array( [ ...magic, ...magic ] );
        const replace = new Uint8Array( search.length );

        replace.set( initial );
        replace.set( maximum, initial.length );
        replaceData( buffer, search, replace, 1 );
        
        return buffer;
    }

    let initial;
    let maximum;
    let shared;

    if (Reflect.has(target, "byteOffset")) {
        offset ||= target.byteOffset;
    }

    if (Reflect.has(target, "memory")) {
        target = Reflect.get(target, "memory");
    }

    initial = target.initial || Math.floor((target.buffer?.byteLength || target.byteLength) / 65536);
    maximum = target.maximum || initial;
    shared  = typeof (target.buffer || target).grow === "function";

    alignOffset(buffer, offset, offsetMagic);

    const view          = new Uint8Array(buffer);
    const magic         = encodeLeb128(memoryMagic);
    const memoptLength  = 1 + magic.length * 2;
    const memoptBegin   = findBufferIndex(buffer, magic)-1;
    const sec2LenAt     = findBufferIndex(buffer, [2, 20, 1]) + 1;
    const sec2End       = memoptBegin + memoptLength;
    const sec3End       = view.indexOf(0, sec2End);
    const sec3          = view.subarray(sec2End, sec3End);
    const newHeader     = [shared && 3 || 1].concat(encodeLeb128(initial)).concat(encodeLeb128(maximum)).concat(...sec3);
    const croplen       = (sec3End - memoptBegin) - newHeader.length;
    const dataBegin     = view.findIndex((v,i) => v && i > sec3End);
    
    view[ sec2LenAt ] -= croplen;

    view.set(newHeader.concat(new Array(croplen).fill(0)), memoptBegin);
    view.copyWithin(dataBegin-croplen, dataBegin)

    buffer = buffer.slice(0, buffer.byteLength - croplen)
    
    return buffer;
}

export const iLE = Boolean(new DataView(Uint32Array.of(1).buffer).getUint8(0));

export const CONST = [
    enumerate("ERROR_SOURCE_AND_TARGET_MUST_HAS_EQUAL_LENGTH"),
    enumerate("ERROR_VALUE_LENGTH_EXCEES_SOURCE_LENGTH"),
    enumerate("ERROR_VALUE_LENGTH_MUST_BE_ONE_OR_SRC_LENGTH"),
    enumerate("ERROR_SOURCE_TARGET_VALUE_ALL_NEEDS_LENGTH"),
    enumerate("FLOAT"),
    enumerate("INT"),
    enumerate("UINT"),
    enumerate("BIGINT"),
    enumerate("BIGUINT"),
    enumerate("BIGVEC"),
    enumerate("ADD"),
    enumerate("MUL"),
    enumerate("SUB"),
    enumerate("DIV"),
    enumerate("REM"),
    enumerate("EQ"),
    enumerate("MAX_EPOCH"),
    enumerate("ANYPU"),
    enumerate("CPU"),
    enumerate("GPU"),
    enumerate("NPU"),
    enumerate("DATAVIEW"),
    enumerate("INT8ARRAY"),
    enumerate("INT16ARRAY"),
    enumerate("INT32ARRAY"),
    enumerate("BIGINT64ARRAY"),
    enumerate("UINT8ARRAY"),
    enumerate("UINT16ARRAY"),
    enumerate("UINT32ARRAY"),
    enumerate("BIGUINT64ARRAY"),
    enumerate("BIGVEC128ARRAY"),
    enumerate("FLOAT16ARRAY"),
    enumerate("FLOAT32ARRAY"),
    enumerate("FLOAT64ARRAY"),
];

export class PUEvent extends CustomEvent {
    constructor ( type, detail ) {
        super( type, {detail} )
    }

    get data () { return this.detail; }
}

export class PU extends EventTarget {

    static IDLE    = enumerate("IDLE");
    static BUSY    = enumerate("BUSY");
    static READY   = enumerate("READY");
    static CLOSED  = enumerate("CLOSED");

    static setMemory ( memory ) {
        this.memory = memory ;
    }

    release () {

    }

    enable ( handlers = {} ) {
        for (const name in handlers) {
            Reflect.defineProperty(this, name, {
                value: handlers[name], configurable: true
            })
        }

        this.deviceState = PU.READY;
        this.emit("ready", this);

        return this;
    }

    on () {
        this.addEventListener(...arguments);
        return this;
    }

    once () {
        this.addEventListener(...arguments, {once: true});
        return this;
    }

    emit () {
        this.dispatchEvent(new PUEvent(...arguments));
        return this;
    }

    check () {

    }

    disable () {
        Array.of(   
            "f32_add",  "f32_mul",  "f32_div",  "f32_sub", 
            "f32_max",  "f32_min",  "f32_neg",  "f32_abs", 
            "f32_sqrt", "f32_ceil", "f32_floor"
        ).forEach(Reflect.deleteProperty.bind(Reflect, this))
    }

    f32_add ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] + v; }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = source[i] + values[i]; }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_mul ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] * v; }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = source[i] * values[i]; }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_div ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] / v; }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = source[i] / values[i]; }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_sub ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] - v; }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = source[i] - values[i]; }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_max ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = Math.max(source[i], v); }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = Math.max(source[i], values[i]); }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_min ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = Math.min(source[i], v); }
                return resolve(target);
            }

            if (values.length === target.length) {
                while (i--) { target[i] = Math.min(source[i], values[i]); }
                return resolve(target);
            }

            reject(`Error: Value length (${values.length}) must be 1 or equal to target length (${target.length}).`)
        });
    }

    f32_neg ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = -source[i]; }
                return resolve(target);
            }

            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }

    f32_abs ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.abs(source[i]); }
                return resolve(target);
            }

            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }

    f32_sqrt ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.sqrt(source[i]); }
                return resolve(target);
            }

            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }

    f32_ceil ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.ceil(source[i]); }
                return resolve(target);
            }

            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }

    f32_floor ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.floor(source[i]); }
                return resolve(target);
            }

            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }

    log () { console.log(...arguments) }
    warn () { console.warn(...arguments) }
    catch () { console.error(...arguments) }
    error () { console.error(...arguments) }
} 

export class CPU extends PU {

    static wasm = Uint8Array.from(
        "0061736d0100000001110260067f7f7f7f7f7f0060047f7f7f7f0002140103656e76066d656d6f72790203808004808004030c0b000000000000010101010107730b076633325f6164640000076633325f7375620001076633325f6d756c0002076633325f6469760003076633325f6d696e0004076633325f6d61780005076633325f6162730006076633325f6e65670007086633325f737172740008086633325f6365696c0009096633325f666c6f6f72000a0a8f180bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde401fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0092380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde401fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70292380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde501fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0093380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde501fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70293380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde601fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0094380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde601fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70294380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde701fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0095380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde701fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70295380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde801fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0096380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde801fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70296380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072000fd1c002002fd1c012004fd1c022001fd1c032107410120054604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde901fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0097380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2005200146044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde901fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70297380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bae0101017b20042000fd1c002002fd1c012003fd1c022001fd1c0321042003200146044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde001fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028b380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042000fd1c002002fd1c012003fd1c022001fd1c0321042003200146044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde101fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028c380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042000fd1c002002fd1c012003fd1c022001fd1c0321042003200146044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde301fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b70291380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042000fd1c002002fd1c012003fd1c022001fd1c0321042003200146044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd67fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028d380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042000fd1c002002fd1c012003fd1c022001fd1c0321042003200146044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd68fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028e380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000b"
        .match(/(..)/g).map(v => parseInt(v, 16))
    ).buffer;

    static get memory () {
        const memory = new WebAssembly.Memory({initial: 100, maximum: 100, shared: true});
        const atomic = new Uint32Array(memory.buffer);
        const malloc = Atomics.add.bind(Atomics, atomic, 1);

        malloc(16);

        Reflect.defineProperty(memory, "malloc", {
            value: function (byteLength = 0) {
                if (byteLength % 16) {
                    byteLength += 16 - byteLength % 16;
                }
                return malloc(byteLength);
            }
        });

        Reflect.defineProperty(this, "memory", { value: memory })

        return memory;
    }

    constructor (memory = new.target.memory) {
        super()
        
        this.memory = memory;
        this.buffer = memory.buffer;

        try {
            const wasm = replaceWASM(CPU.wasm, this.memory);
            const opts = {env: {memory: this.memory}};

            WebAssembly
                .instantiate(wasm, opts)
                    .then(ws => {
                        const handlers = new Object(null);

                        for(const func in ws.instance.exports) {
                            handlers[ func ] = this.calc.bind(
                                this, ws.instance.exports[ func ]
                            );
                        }

                        this.enable(handlers);
                    })
                .catch(e => this.warn(`WebAssembly not instantiated: ${e}`))
            .finally(() => this.check());
        }   
        catch (e) { this.error(`WebAssembly not supported: ${e}`)}
    }

    Float32Array = class extends Float32Array {

        constructor ( buffer, byteOffset = 0, length = (buffer.byteLength - byteOffset)/4 ) {
            let byteLength;

            if (typeof buffer === "number") {
                length      = buffer;
                byteLength  = length * 4;
                byteOffset  = CPU.memory.malloc(byteLength);
                buffer      = CPU.memory.buffer;
            }

            if (buffer !== CPU.memory.buffer) {
                const tempView = new Float32Array( buffer, byteOffset, length );
                byteLength  = tempView.byteLength;
                byteOffset  = CPU.memory.malloc(byteLength);
                buffer      = CPU.memory.buffer;
                const destView = new Float32Array( buffer, byteOffset, length );
                destView.set( tempView );
            }

            super( buffer, byteOffset, length );
        }

        static from ( values = [], mapFn = v => v, thisArg = null ) {
            const length        = values.length || 0;
            const byteLength    = length * 4;
            const byteOffset    = CPU.memory.malloc(byteLength);
            const view          = new this(length);

            view.set(values.map(mapFn, thisArg));
            return view;
        }

        static of ( ...values ) {
            return this.from( values );
        }
    }

    import (view) {
        if (view.buffer === this.buffer) {
            return view;
        }

        const byteLength = view.byteLength;
        const byteOffset = this.memory.malloc(byteLength);
        const bufferView = Reflect.construct(
            view.constructor, Array.of(
                this.buffer, byteOffset, view.length
            )
        );

        bufferView.set( view );

        return bufferView;
    }

    export (view, byteOffset) {
        if (view.buffer !== this.buffer) {
            view.set(
                Reflect.construct(
                    view.constructor, Array.of(
                        this.buffer, byteOffset, view.length
                    )
                )
            );
        }
    }

    calc ( handler, source, values, target = source ) {
        return new Promise(async (resolve, reject) => {
            try {
                const { byteOffset: srcByteOffset, length: srcLength } = this.import(source);
                const { byteOffset: valByteOffset, length: valLength } = this.import(values);
                const { byteOffset: dstByteOffset, length: dstLength } = this.import(target);
        
                await handler(
                    dstByteOffset, dstLength, 
                    srcByteOffset, srcLength, 
                    valByteOffset, valLength
                );

                this.export(
                     target, dstByteOffset 
                );

                resolve(target)

            } catch (error) { reject(error) }
        })
    }
} 

export class GPU extends PU {

    static shader = String(`
        const wsize : u32 = 256;
        struct Inputs {
            // workgroup_id is a uniform built-in value.
            // local_invocation_index is a non-uniform built-in value.
            
            @builtin ( num_workgroups ) numWorkgroups : vec3u, 
            @builtin ( workgroup_id ) wgid : vec3<u32>,
            @builtin ( local_invocation_index ) lid : u32,
            @builtin ( local_invocation_id ) local_id : vec3u,     
            @builtin ( global_invocation_id ) id : vec3u, 

        }
        
        @group(0) @binding(0) var<uniform>               index: u32;
        @group(0) @binding(1) var<storage, read>         value: array<f32>;
        @group(0) @binding(2) var<storage, read>         input: array<f32>;
        @group(0) @binding(3) var<storage, read_write>  output: array<f32>;

        @compute  @workgroup_size( wsize ) 
        fn f32_add_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] + value[id.x]; }
        }
            
        @compute  @workgroup_size( wsize ) 
        fn f32_mul_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] * value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_sub_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] - value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_div_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] / value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_max_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = max(input[id.x], value[id.x]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_min_n ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = min(input[id.x], value[id.x]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_add ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] + value[0]; }
        }
            
        @compute  @workgroup_size( wsize ) 
        fn f32_mul ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] * value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_sub ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] - value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_div ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] / value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_max ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = max(input[id.x], value[0]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_min ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = min(input[id.x], value[0]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_neg ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = -input[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_abs ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = abs(input[id.x]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_sqrt ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = sqrt(input[id.x]); }
        }

        @compute  @workgroup_size( wsize ) 
        fn f32_ceil ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = ceil(input[id.x]); }
        }

        @compute  @workgroup_size( wsize ) 
        fn f32_floor ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = floor(input[id.x]); }
        }
    `);

    constructor () {
        super();

        navigator.gpu
            .requestAdapter({ powerPreference: "high-performance" })
                .then(adapter => adapter.requestDevice())
                .then(device => {
                    this.device         = device;
                    this.deviceQueue    = device.queue;
                    this.bindingSize    = device.limits.maxStorageBufferBindingSize;
                    this.workgroupSize  = device.limits.maxComputeWorkgroupsPerDimension;
                    this.invocations    = device.limits.maxComputeInvocationsPerWorkgroup;
                        
                    this.indexBuffer    = device.createBuffer({ size : 256, usage : GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
                    this.valueBuffer    = device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
                    this.inputBuffer    = device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
                    this.outputBuffer   = device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_SRC }),
                    this.stagingBuffer  = device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST });
            
                    const bindLayout    = device.createBindGroupLayout({
                        label: "gpubg",
                        entries: [
                            { label: "index",  binding : 0, visibility : GPUShaderStage.COMPUTE, buffer : { type: "uniform" } },
                            { label: "value",  binding : 1, visibility : GPUShaderStage.COMPUTE, buffer : { type: "read-only-storage" } },
                            { label: "input",  binding : 2, visibility : GPUShaderStage.COMPUTE, buffer : { type: "read-only-storage" } },
                            { label: "output", binding : 3, visibility : GPUShaderStage.COMPUTE, buffer : { type: "storage" } },
                        ]
                    });
            
                    this.bindGroup      = device.createBindGroup({
                        layout  : bindLayout, 
                        entries : [
                            { label: "index",  binding : 0, resource : { buffer: this.indexBuffer } },
                            { label: "value",  binding : 1, resource : { buffer: this.valueBuffer } },
                            { label: "input",  binding : 2, resource : { buffer: this.inputBuffer } },
                            { label: "output", binding : 3, resource : { buffer: this.outputBuffer } },
                        ]
                    });
            
                    const module = device.createShaderModule({ code: this.constructor.shader });
                    const layout = device.createPipelineLayout({ bindGroupLayouts : [ bindLayout ] });
            
                    const f32_add   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_add" }});
                    const f32_mul   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_mul" }});
                    const f32_sub   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sub" }});
                    const f32_div   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_div" }});
                    const f32_max   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_max" }});
                    const f32_min   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_min" }});
                    const f32_neg   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_neg" }});
                    const f32_abs   = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_abs" }});
                    const f32_sqrt  = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sqrt" }});
                    const f32_ceil  = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_ceil" }});
                    const f32_floor = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_floor" }});

                    f32_add.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_add_n" }});
                    f32_mul.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_mul_n" }});
                    f32_sub.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sub_n" }});
                    f32_div.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_div_n" }});
                    f32_max.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_max_n" }});
                    f32_min.n = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_min_n" }});

                    this.maxBufferSize = this.workgroupSize * this.invocations;
                    
                    const handlers = {
                        f32_add   : this.calc.bind( this, f32_add ),
                        f32_mul   : this.calc.bind( this, f32_mul ),
                        f32_sub   : this.calc.bind( this, f32_sub ),
                        f32_div   : this.calc.bind( this, f32_div ),
                        f32_max   : this.calc.bind( this, f32_max ),
                        f32_min   : this.calc.bind( this, f32_min ),
                        f32_neg   : this.calc.bind( this, f32_neg ),
                        f32_abs   : this.calc.bind( this, f32_abs ),
                        f32_sqrt  : this.calc.bind( this, f32_sqrt ),
                        f32_ceil  : this.calc.bind( this, f32_ceil ),
                        f32_floor : this.calc.bind( this, f32_floor ),
                    };

                    this.enable(handlers);
                })
            .catch(e => this.error(`GPU failed: ${e}`))
        .finally(() => this.check());
    }

    calc ( pipeline, source, values, target = source ) {
        return new Promise((resolve, reject) => {

            if (values.length > 1) {
                pipeline = pipeline.n;
            }
                        
            const byteLength        = target.byteLength;
            const commandEncoder    = this.device.createCommandEncoder();
            const passEncoder       = commandEncoder.beginComputePass();
    
            this.deviceQueue.writeBuffer(this.indexBuffer, 0, Uint32Array.of(target.length));
            this.deviceQueue.writeBuffer(this.valueBuffer, 0, values);
            this.deviceQueue.writeBuffer(this.inputBuffer, 0, source);
    
            passEncoder.setPipeline( pipeline );
            passEncoder.setBindGroup(0, this.bindGroup);
            passEncoder.dispatchWorkgroups( this.workgroupSize, this.invocations );
            passEncoder.end();
        
            commandEncoder.copyBufferToBuffer(
                this.outputBuffer, 0, 
                this.stagingBuffer, 0, byteLength
            );
            
            this.deviceQueue.submit([commandEncoder.finish()]);
    
            const output = new Uint8Array(
                target.buffer, target.byteOffset, byteLength
            );
            
            return this.stagingBuffer
                .mapAsync(GPUMapMode.READ, 0, byteLength)
                    .then(() => this.stagingBuffer.getMappedRange(0, byteLength))
                    .then(buffer => output.set( new Uint8Array( buffer ) ))
                    .then(() => resolve(target))
                .catch(error => reject(error))
            .finally(() => this.release());
        });
    }

    release () {
        if (this.stagingBuffer.mapState === "mapped") {
            this.stagingBuffer.unmap();
        }
        
        super.release();
    }
}

export class NPU extends PU {

    constructor () {
        super();

        navigator.ml
            .createContext({ powerPreference: "default"})
                .then(context => {
                    this.context = context;

                    const handlers = {
                        f32_add   : this.calc.bind(this, MLGraphBuilder.prototype.add, "float32" ),
                        f32_mul   : this.calc.bind(this, MLGraphBuilder.prototype.mul, "float32" ),
                        f32_sub   : this.calc.bind(this, MLGraphBuilder.prototype.sub, "float32" ),
                        f32_div   : this.calc.bind(this, MLGraphBuilder.prototype.div, "float32" ),
                        f32_max   : this.calc.bind(this, MLGraphBuilder.prototype.max, "float32" ),
                        f32_min   : this.calc.bind(this, MLGraphBuilder.prototype.min, "float32" ),
                        f32_neg   : this.calc.bind(this, MLGraphBuilder.prototype.neg, "float32" ),
                        f32_abs   : this.calc.bind(this, MLGraphBuilder.prototype.abs, "float32" ),
                        f32_sqrt  : this.calc.bind(this, MLGraphBuilder.prototype.sqrt, "float32" ),
                        f32_ceil  : this.calc.bind(this, MLGraphBuilder.prototype.ceil, "float32" ),
                        f32_floor : this.calc.bind(this, MLGraphBuilder.prototype.floor, "float32" ),
                    };

                    this.enable(handlers);
                })
            .catch((err) => this.error(err))
        .finally(() => this.check());
    }

    calc ( builder, dataType, source, values, target = source ) {
        return new Promise((resolve, reject) => {
            const graphBuilder  = new MLGraphBuilder( this.context );
            const buildOptions  = {
                dst : Reflect.apply(
                    builder, graphBuilder, Array.of(
                        graphBuilder.input( 'src', { dataType, shape: [ source.length ] }),
                        graphBuilder.input( 'val', { dataType, shape: [ values.length ] })
                    )
                )
            };

            const createTensors = () => Promise.all([
                this.context.createTensor({ dataType, shape: [ target.length ], readable: true }),
                this.context.createTensor({ dataType, shape: [ source.length ], writable: true }),
                this.context.createTensor({ dataType, shape: [ values.length ], writable: true }),
            ]);

            graphBuilder
                .build( buildOptions )
                    .then(graph     => createTensors(this.graph = graph))
                    .then(tensors   => this.dispatch(tensors, source, values))
                    .then(out       => this.context.readTensor( out, target ))
                    .then(()        => resolve(target))
                .catch(error => reject(error))
            .finally(() => this.release());
        });
    }

    dispatch ( tensors, source, values ) {
        const [ dst, src, val ] = tensors;

        this.context.writeTensor(src, source);
        this.context.writeTensor(val, values);
        this.context.dispatch(this.graph, {src, val}, {dst});

        return dst;
    }

    release () {
        this.graph.destroy();
        Reflect.deleteProperty(this, "graph");
        super.release();
    }
    
}

export default class IPU extends EventTarget {
    static cpuSupport   = Boolean(Math.sqrt(4));
    static wasmSupport  = Reflect.has(self, "WebAssembly");
    static gpuSupport   = Reflect.has(navigator, "gpu");
    static nnSupport    = Reflect.has(navigator, "ml");

    integrate () {
        const ipu = this;

        Object.defineProperties( Object.getPrototypeOf(Uint8Array).prototype, {
            add     : { value : function ( value, target = this ) { return ipu.calc( "f32_add", target, this, value ); } },
            mul     : { value : function ( value, target = this ) { return ipu.calc( "f32_mul", target, this, value ); } },
            div     : { value : function ( value, target = this ) { return ipu.calc( "f32_div", target, this, value ); } },
            sub     : { value : function ( value, target = this ) { return ipu.calc( "f32_sub", target, this, value ); } },
            max     : { value : function ( value, target = this ) { return ipu.calc( "f32_max", target, this, value ); } },
            min     : { value : function ( value, target = this ) { return ipu.calc( "f32_min", target, this, value ); } },
            neg     : { value : function ( target = this ) { return ipu.calc( "f32_neg",   target, this ); } },
            abs     : { value : function ( target = this ) { return ipu.calc( "f32_abs",   target, this ); } },
            sqrt    : { value : function ( target = this ) { return ipu.calc( "f32_sqrt",  target, this ); } },
            ceil    : { value : function ( target = this ) { return ipu.calc( "f32_ceil",  target, this ); } },
            floor   : { value : function ( target = this ) { return ipu.calc( "f32_floor", target, this ); } },
        });
    }

    constructor ( puType ) {
        super();

        switch ( +puType ) {
            case +new.target.GPU : this.pu = new GPU(); break;
            case +new.target.NPU : this.pu = new NPU(); break;
            case +new.target.CPU : this.pu = new CPU(); break;
                         default : this.pu = new  PU(); break;
        };
    }

    static setMemory ( memory ) {
        this.memory = memory ;
    }

    typedArray ( op = "f32_any", ...args ) {

        const tagName = {
            f32 : "Float32Array",
            u32 : "Uint32Array",
        }[ op.split(/_/).at(0) ];

        if (Reflect.has(this.memory, tagName)) {
            return this.memory[ tagName ]( ...args );
        }

        return Reflect.construct( 
            self[ tagName ], args 
        );
    }

    error () {
        throw new Error(...arguments)
    }

    async calc () {
        let [
            op,
            target,
            source,
            value,
        ] = arguments;

        const handler = Reflect.get( this.pu, op );
        if ( !handler ) throw `Undefined operation: ${op}`;

        if (typeof value === "number") {
            value = this.typedArray(op, 1).fill(value);
        }
        else
        if (value === undefined) {
            value = {};
        }

        if (target === true) {
            target = this.typedArray(op, source.length);
        }
        else
        if (target === undefined) {
            target = source;
        }
        
        const { byteOffset: dstByteOffset, length: dstLength } = target;
        const { byteOffset: srcByteOffset, length: srcLength } = source;
        const { byteOffset: valByteOffset, length: valLength } = value;

        if (dstLength * srcLength === 0) {
            this.error(this.ERROR_SOURCE_TARGET_VALUE_ALL_NEEDS_LENGTH, arguments);
            return;
        }

        if (srcLength - dstLength) {
            this.error(this.ERROR_SOURCE_AND_TARGET_MUST_HAS_EQUAL_LENGTH, arguments);
            return;
        }

        if (valLength > srcLength) {
            this.error(this.ERROR_VALUE_LENGTH_EXCEES_SOURCE_LENGTH, arguments);
            return;
        }
        
        await Reflect.apply(
            handler, this.pu, Array.of(
                dstByteOffset, dstLength,
                srcByteOffset, srcLength,
                valByteOffset, valLength,            
            )
        );

        return target;
    }
}

const proto = Reflect.get( IPU, "prototype" );

CONST.forEach(e => {
    const prop = e.toString();
    Object.defineProperty(IPU, prop, {value: e} );
    Object.defineProperty(proto, prop, {value: e} );
});
