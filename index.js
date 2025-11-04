import enumerate from "./node_modules/niceenum/index.js"

const ff = class extends Float32Array {
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
};

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

    initial = target.create || Math.floor((target.buffer?.byteLength || target.byteLength) / 65536);
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

export const fallbackHandlers = {

    f32_vadd : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] + v; }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },

    f32_add : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;

            if (values.length === target.length) {
                while (i--) { target[i] = source[i] + values[i]; }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vadd(
                    source, values, target
                ).then(resolve);
            }

            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_vmul : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] * v; }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },

    f32_mul : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === target.length) {
                while (i--) { target[i] = source[i] * values[i]; }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vmul(
                    source, values, target
                ).then(resolve);
            }
    
            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_vdiv : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] / v; }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },
     
    f32_div : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === target.length) {
                while (i--) { target[i] = source[i] / values[i]; }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vdiv(
                    source, values, target
                ).then(resolve);
            }
    
            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_vsub : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = source[i] - v; }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },
    
    f32_sub : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === target.length) {
                while (i--) { target[i] = source[i] - values[i]; }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vsub(
                    options, source, values, target
                ).then(resolve);
            }
    
            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_vmax : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = Math.max(source[i], v); }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },
    
    f32_max : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === target.length) {
                while (i--) { target[i] = Math.max(source[i], values[i]); }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vmax(
                    source, values, target
                ).then(resolve);
            }
    
            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_vmin : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === 1) {
                let v = values.at(0);
                while (i--) { target[i] = Math.min(source[i], v); }
                return resolve(target);
            }
    
            reject(`Error: Value length (${values.length}) must be 1.`)
        });
    },
    
    f32_min : async function ( source, values, target = source ) {
        return new Promise( (resolve, reject) => {
            let i = target.length;
    
            if (values.length === target.length) {
                while (i--) { target[i] = Math.min(source[i], values[i]); }
                return resolve(target);
            }

            if (values.length === 1) {
                return this.f32_vmin(
                    source, values, target
                ).then(resolve);
            }
    
            reject(`Error: Value length (${values.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_neg : async function ( options, source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = -source[i]; }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_abs : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.abs(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_sqrt : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.sqrt(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_ceil : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.ceil(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_floor : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.floor(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }
}

export class PUEvent extends CustomEvent {
    constructor (type, detail) { super(type, {detail})}
    get data () { return this.detail; }
}

export class PU extends EventTarget {
    static hardwareConcurrency = navigator.hardwareConcurrency;

    handlers = {}

    create      () { 
        this.createHandlers()
        this.settleHandlers()

        this.deviceState = this.INIT;
        this.emit("create", arguments); 

        this.check();
    }

    destroy     () { 
        this.handlers    = {};
        this.deviceState = this.CLOSED;
        this.emit("destroy", arguments) 
    }
    
    release     ( args ) { 
        this.lockState = this.IDLE;
        this.emit("idle", args);
    }

    lock        ( args ) {
        this.lockState = this.LOCKED;
        this.emit("lock", args);
    }

    error       () { this.emit("error"); }
    ready       () { this.emit("ready"); }

    log         () {   console.log(...arguments) }
    warn        () {  console.warn(...arguments) }
    catch       () { console.error(...arguments) }
    error       () { console.error(...arguments) }

    on          () { return this.addEventListener(...arguments), this; }
    once        () { return this.addEventListener(...arguments, {once: true}), this; }
    emit        () { return this.dispatchEvent(new PUEvent(...arguments)), this; }

    check () {
        this.lockState   = this.IDLE;
        this.deviceState = this.READY;
        this.emit("ready");
    }

    createHandlers () {
        throw `PU class need has own create handlers function!`
    }

    settleHandlers () {
        const properties = {};
        const prototype = Object.getPrototypeOf(this);
        
        for (const name in this.handlers) {
            properties[ name ]  = { 
                value           : this.handlers[name], 
                configurable    : true 
            };
        }

        Object.defineProperties(prototype, properties);
    }

    restore () {
        for (const name in this.handlers) {
            Reflect.deleteProperty(this, name);
        }
        this.emit("restore", this.handlers);
    }

    async calc (options, ...args) {
        const handler = fallbackHandlers[ options.funcName ];
        return Reflect.apply( handler, this, args );
    }
} 

Object.defineProperties(PU.prototype, {
    IDLE    : { value: enumerate("IDLE") },
    BUSY    : { value: enumerate("BUSY") },
    READY   : { value: enumerate("READY") },
    LOCKED  : { value: enumerate("LOCKED") },
    CLOSED  : { value: enumerate("CLOSED") },
    INIT    : { value: enumerate("INIT") },
});

export class CPU extends PU {

    static createMemory () {
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

        Reflect.defineProperty(memory, "isDefaultMemory", { value: true });
        Reflect.defineProperty(PU, "memory", { value: memory, configurable: true })

        return memory;
    }

    static wasm = Uint8Array.from(
        "0061736d0100000001110260067f7f7f7f7f7f0060047f7f7f7f0002140103656e76066d656d6f72790203808004808004030c0b0000000000000101010101040401700064077a0c076633325f6164640000076633325f7375620001076633325f6d756c0002076633325f6469760003076633325f6d696e0004076633325f6d61780005076633325f6162730006076633325f6e65670007086633325f737172740008086633325f6365696c0009096633325f666c6f6f72000a0466756e630100090a010041000b04000102030a8f180bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde401fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0092380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde401fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70292380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde501fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0093380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde501fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70293380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde601fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0094380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde601fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70294380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde701fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0095380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde701fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70295380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde801fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0096380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde801fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70296380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde901fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0097380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde901fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70297380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde001fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028b380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde101fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028c380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde301fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b70291380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd67fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028d380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd68fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028e380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000b"
        .match(/(..)/g).map(v => parseInt(v, 16))
    ).buffer;

    static workerURL = URL.createObjectURL(
        new Blob([`(`, () => {
                self.onmessage = e => {
                    const { memory, module, buffer } = e.data;
                    const atomic = new Int32Array(buffer);
                    const args = atomic.subarray(2);
                    const f = atomic.at.bind(atomic, 1);
                    const pid = Number(name)
                    WebAssembly
                        .instantiate(module, {env: {memory}})
                            .then(({exports: {func}}) => {
                                postMessage(pid);
                                let cycle = 0;
                                while (++cycle) {
                                    Atomics.store(atomic, 0, 0);
                                    Atomics.wait(atomic, 0);
                                    func.get(atomic[1]).apply(null, args);
                                    postMessage(null);
                                }
                            })
                    .catch((err) => postMessage(err))
                }
            }, `)`, `()`
        ])
    );

    imports     = new WeakMap();
    workers     = new Map();

    createHandlers () {
        const refTable = this.instance.exports.func;

        for (const name in this.instance.exports) {
            if (Reflect.has(fallbackHandlers, name)) {
                let i = -1, length = refTable.length;
                while (++i < length) {
                    if (refTable.get(i) === this.instance.exports[name]) {
                        const options = {funcName: name, refIndex: i};
                        this.handlers[ name ] = this.calc.bind(this, options);
                        break;
                    }
                }
            }
        }
    }

    async createWorkerThreads () {
        return Promise.all(new Array(PU.hardwareConcurrency).fill().map(() => {
            return new Promise((resolve, reject) => {
                const pid    = this.workers.size + 1;
                const worker = new Worker(CPU.workerURL, {name: pid});
                const buffer = new SharedArrayBuffer(8*4);
                const atomic = new Int32Array(buffer);
                
                worker.postMessage({
                    module: this.module,
                    memory: this.memory, 
                    buffer: buffer
                });
    
                Object.defineProperty(worker, "pid", { value: pid })
                Object.defineProperty(worker, "settask", { value: Int32Array.prototype.set.bind(atomic) })
                Object.defineProperty(worker, "unlock", { value: Atomics.notify.bind(Atomics, atomic, 0, 1, 1) })
        
                worker.addEventListener(
                    "message", e => {
                        if (e.data != pid) {
                            return reject(pid)
                        } else resolve(pid)
                    }, {once: true}
                );
    
                this.workers.set(pid, worker);
            })
        }))
    }

    async createWindowThread () {
        return new Promise(async (resolve, reject) => {
            const imports = {env: {memory: this.memory}};
            return WebAssembly.instantiate(this.module, imports)
                .then(instance => this.instance = instance)
                .then(() => resolve())
            .catch(e => reject(`WASM instance creation failed: ${e}`));
        });
    } 


    async create () {
        return new Promise(async (resolve, reject) => {
            if (this.module) { return resolve(); }

            if (this.memory === undefined) {
                this.memory = PU.memory ?? CPU.createMemory();
            }

            try {
                WebAssembly
                    .compile(replaceWASM(CPU.wasm, this.memory))
                        .then(module => this.module = module)
                        .then(() => this.createWindowThread())
                        .then(() => this.createWorkerThreads())
                        .then(() => resolve())
                    .catch((err) => reject(`WebAssembly not instantiated: ${err}`))
                .finally(() => super.create(...arguments))
            }   
            catch (e) { reject(`WebAssembly not supported: ${e}`)}
        });
    }

    async destroy () {
        return new Promise(async (resolve, reject) => {
            try {
                if (this.memory?.isDefaultMemory) {
                    Reflect.deleteProperty(PU, "memory");
                    Reflect.deleteProperty(this, "memory");
                }
    
                Reflect.deleteProperty(this, "module");

                this.workers.forEach(w => w.terminate()); // Terminate all workers
                this.workers.clear(); // Clear the workers map
                this.imports.clear();
                
                Promise
                    .resolve(super.destroy(...arguments))
                    .then(() => resolve())
                .catch(reject);
            }
            catch (e) { reject(`CPU destroy failed: ${e}`) }
        });
    }

    import (view) {
        if (view.buffer === this.memory.buffer) {
            return view;
        }

        if (this.imports.has(view)) {
            return this.imports.get(view);
        }

        const byteLength = view.byteLength;
        const byteOffset = this.memory.malloc(byteLength);
        const bufferView = Reflect.construct(
            view.constructor, Array.of(
                this.memory.buffer, byteOffset, view.length
            )
        );

        bufferView.set(view);
        this.imports.set(view, bufferView);

        return bufferView;
    }

    export (view) {
        if (this.imports.has(view)) {
            const dst = this.imports.get(view);
            if (dst !== view) {
                dst.set(view);
            }
            return dst;
        }
        return view;
    }

    async calc ( options, source, values, target = source ) {
        super.lock( arguments );

        return new Promise(async (resolve, reject) => {
            const src = this.import(source);
            const val = this.import(values);
            const dst = this.import(target);

            const { byteOffset: srcByteOffset, length: srcLength } = src;
            const { byteOffset: valByteOffset, length: valLength } = val;
            const { byteOffset: dstByteOffset, length: dstLength } = dst;
    
            const promises          = new Array();
            const concurrency       = this.workers.size;
            const alignByteLength   = (dst.byteLength) % (16 * concurrency);
            const byteLength        = (dst.byteLength - alignByteLength) / concurrency;
            const length            = (byteLength / dst.BYTES_PER_ELEMENT);
            const alignedLength     = (alignByteLength / dst.BYTES_PER_ELEMENT);
            
            let workerByteOffset    = (alignByteLength);
            
            if (valLength === 1) {
                this.workers.forEach(worker => {
                    const { promise, resolve: done, reject: fail } = Promise.withResolvers();

                    worker.settask([
                        1,
                        options.refIndex, 
                        srcByteOffset + workerByteOffset, length,
                        valByteOffset                   , 1,
                        dstByteOffset + workerByteOffset, length, 
                    ]);

                    workerByteOffset += byteLength;
    
                    worker.addEventListener("error", fail, {once: true});
                    worker.addEventListener("message", done, {once: true});
                    worker.addEventListener("messageerror", fail, {once: true});
    
                    worker.unlock();
                    promises.push(promise);
                })

                if (alignByteLength) {
                    promises.push( super[ options.funcName ](
                        src.subarray(0, alignedLength),
                        val.subarray(0, valLength),
                        dst.subarray(0, alignedLength),
                    ));
                }
            }

            return Promise
                .all(promises)
                    .then(() => this.export(dst))
                    .then(out => resolve(out))
                .catch(err => reject(err))
            .finally(() => this.release(arguments));
        });
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
        fn f32_add ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] + value[id.x]; }
        }
            
        @compute  @workgroup_size( wsize ) 
        fn f32_mul ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] * value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_sub ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] - value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_div ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] / value[id.x]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_max ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = max(input[id.x], value[id.x]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_min ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = min(input[id.x], value[id.x]); }
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

        @compute  @workgroup_size( wsize ) 
        fn f32_vadd ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] + value[0]; }
        }
            
        @compute  @workgroup_size( wsize ) 
        fn f32_vmul ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] * value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_vsub ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] - value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_vdiv ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = input[id.x] / value[0]; }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_vmax ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = max(input[id.x], value[0]); }
        }
    
        @compute  @workgroup_size( wsize ) 
        fn f32_vmin ( @builtin ( global_invocation_id) id : vec3u ) {
            if ( id.x < index ) { output[id.x] = min(input[id.x], value[0]); }
        }
    `);

    pipelines = new Map();
    vpipelines = new Map();

    async acquireDevice () { 
        return navigator.gpu
            .requestAdapter({ powerPreference: "high-performance" })
                .then(adapter => this.adapter = adapter)
                .then(() => this.adapter.requestDevice())
                .then(device => this.device = device)
        ;
    }
    
    createBuffers () {
        this.bindingSize    = this.device.limits.maxStorageBufferBindingSize;
        this.workgroupSize  = this.device.limits.maxComputeWorkgroupsPerDimension;
        this.invocations    = this.device.limits.maxComputeInvocationsPerWorkgroup;
        
        this.indexBuffer    = this.device.createBuffer({ size : 256, usage : GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
        this.valueBuffer    = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
        this.inputBuffer    = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
        this.outputBuffer   = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_SRC }),
        this.stagingBuffer  = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST });
    }

    createPipelines () {

        this.bindLayout    = this.device.createBindGroupLayout({
            label: "gpubg",
            entries: [
                { label: "index",  binding : 0, visibility : GPUShaderStage.COMPUTE, buffer : { type: "uniform" } },
                { label: "value",  binding : 1, visibility : GPUShaderStage.COMPUTE, buffer : { type: "read-only-storage" } },
                { label: "input",  binding : 2, visibility : GPUShaderStage.COMPUTE, buffer : { type: "read-only-storage" } },
                { label: "output", binding : 3, visibility : GPUShaderStage.COMPUTE, buffer : { type: "storage" } },
            ]
        });
        
        this.bindGroup      = this.device.createBindGroup({
            layout  : this.bindLayout, 
            entries : [
                { label: "index",  binding : 0, resource : { buffer: this.indexBuffer } },
                { label: "value",  binding : 1, resource : { buffer: this.valueBuffer } },
                { label: "input",  binding : 2, resource : { buffer: this.inputBuffer } },
                { label: "output", binding : 3, resource : { buffer: this.outputBuffer } },
            ]
        });

        const module = this.device.createShaderModule({ code: this.constructor.shader });
        const layout = this.device.createPipelineLayout({ bindGroupLayouts : [ this.bindLayout ] });

        this.pipelines.set("f32_add"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_add"   }, label: "f32_add"}));
        this.pipelines.set("f32_mul"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_mul"   }, label: "f32_mul"}));
        this.pipelines.set("f32_sub"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sub"   }, label: "f32_sub"}));
        this.pipelines.set("f32_div"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_div"   }, label: "f32_div"}));
        this.pipelines.set("f32_max"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_max"   }, label: "f32_max"}));
        this.pipelines.set("f32_min"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_min"   }, label: "f32_min"}));
        this.pipelines.set("f32_neg"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_neg"   }, label: "f32_neg"}));
        this.pipelines.set("f32_abs"  , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_abs"   }, label: "f32_abs"}));
        this.pipelines.set("f32_sqrt" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sqrt"  }, label: "f32_sqrt"}));
        this.pipelines.set("f32_ceil" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_ceil"  }, label: "f32_ceil"}));
        this.pipelines.set("f32_floor", this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_floor" }, label: "f32_floor"}));
        this.vpipelines.set("f32_add" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vadd"  }, label: "f32_vadd"}));
        this.vpipelines.set("f32_mul" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vmul"  }, label: "f32_vmul"}));
        this.vpipelines.set("f32_sub" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vsub"  }, label: "f32_vsub"}));
        this.vpipelines.set("f32_div" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vdiv"  }, label: "f32_vdiv"}));
        this.vpipelines.set("f32_max" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vmax"  }, label: "f32_vmax"}));
        this.vpipelines.set("f32_min" , this.device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_vmin"  }, label: "f32_vmin"}));

        this.vpipelines.set("f32_neg",  this.pipelines.get("f32_neg"));
        this.vpipelines.set("f32_abs",  this.pipelines.get("f32_abs"));
        this.vpipelines.set("f32_sqrt", this.pipelines.get("f32_sqrt"));
        this.vpipelines.set("f32_ceil", this.pipelines.get("f32_ceil"));
        this.vpipelines.set("f32_floor",this.pipelines.get("f32_floor"));

        this.pipelines.set("f32_vadd",  this.vpipelines.get("f32_add"));
        this.pipelines.set("f32_vmul",  this.vpipelines.get("f32_mul"));
        this.pipelines.set("f32_vsub",  this.vpipelines.get("f32_sub"));
        this.pipelines.set("f32_vdiv",  this.vpipelines.get("f32_div"));
        this.pipelines.set("f32_vmax",  this.vpipelines.get("f32_max"));
        this.pipelines.set("f32_vmin",  this.vpipelines.get("f32_min"));
    }

    createHandlers () {
        this.handlers.f32_add   = this.calc.bind( this, {funcName: "f32_add"} );
        this.handlers.f32_mul   = this.calc.bind( this, {funcName: "f32_mul"} );
        this.handlers.f32_sub   = this.calc.bind( this, {funcName: "f32_sub"} );
        this.handlers.f32_div   = this.calc.bind( this, {funcName: "f32_div"} );
        this.handlers.f32_max   = this.calc.bind( this, {funcName: "f32_max"} );
        this.handlers.f32_min   = this.calc.bind( this, {funcName: "f32_min"} );
        this.handlers.f32_neg   = this.calc.bind( this, {funcName: "f32_neg"} );
        this.handlers.f32_abs   = this.calc.bind( this, {funcName: "f32_abs"} );
        this.handlers.f32_sqrt  = this.calc.bind( this, {funcName: "f32_sqrt"} );
        this.handlers.f32_ceil  = this.calc.bind( this, {funcName: "f32_ceil"} );
        this.handlers.f32_floor = this.calc.bind( this, {funcName: "f32_floor"} );
        this.handlers.f32_vadd  = this.calc.bind( this, {funcName: "f32_vadd"} );
        this.handlers.f32_vmul  = this.calc.bind( this, {funcName: "f32_vmul"} );
        this.handlers.f32_vsub  = this.calc.bind( this, {funcName: "f32_vsub"} );
        this.handlers.f32_vdiv  = this.calc.bind( this, {funcName: "f32_vdiv"} );
        this.handlers.f32_vmax  = this.calc.bind( this, {funcName: "f32_vmax"} );
        this.handlers.f32_vmin  = this.calc.bind( this, {funcName: "f32_vmin"} );
    }

    async create () {
        return new Promise(async (resolve, reject) => {
            this.acquireDevice()
                    .then(() => this.createBuffers())
                    .then(() => this.createPipelines())
                    .then(() => resolve())
                .catch((err) => reject(`GPU failed: ${err}`))
            .finally(() => super.create(...arguments));
        });
    }

    async destroy () {
        super.destroy(...arguments)
    }

    async calc ( options, source, values, target = source ) {
        super.lock( arguments );

        return new Promise((resolve, reject) => {
            
            const byteLength        = target.byteLength;
            const commandEncoder    = this.device.createCommandEncoder();
            const passEncoder       = commandEncoder.beginComputePass();
    
            this.device.queue.writeBuffer(this.indexBuffer, 0, Uint32Array.of(target.length));
            this.device.queue.writeBuffer(this.valueBuffer, 0, values);
            this.device.queue.writeBuffer(this.inputBuffer, 0, source);
            
            if (values.length === 1) {
                passEncoder.setPipeline( this.vpipelines.get(options.funcName) );
            }
            else if (source.length === target.length) {
                passEncoder.setPipeline( this.pipelines.get(options.funcName) );
            }
            else {
                return reject(`Error: Source length (${source.length}) must be 1 or equal to target length (${target.length}).`)
            }
    
            passEncoder.setBindGroup(0, this.bindGroup);
            passEncoder.dispatchWorkgroups( this.workgroupSize, this.invocations );
            passEncoder.end();
        
            commandEncoder.copyBufferToBuffer(
                this.outputBuffer, 0, 
                this.stagingBuffer, 0, byteLength
            );
            
            this.device.queue.submit([commandEncoder.finish()]);
    
            const output = new Uint8Array(
                target.buffer, target.byteOffset, byteLength
            );
            
            this.stagingBuffer
                .mapAsync(GPUMapMode.READ, 0, byteLength)
                    .then(() => this.stagingBuffer.getMappedRange(0, byteLength))
                    .then(buffer => output.set( new Uint8Array( buffer ) ))
                    .then(() => resolve(target))
                .catch(error => reject(error))
            .finally(() => this.release(arguments));
        });
    }

    release () {
        if (this.stagingBuffer.mapState === "mapped") {
            this.stagingBuffer.unmap();
        }
        
        super.release(arguments);
    }
};

export class NPU extends PU {

    async create () {
        return this.context ?? navigator.ml
            .createContext({ powerPreference: "default"})
            .then(context => this.context = context)
        .finally(() => super.create(...arguments))
    }

    async destroy () {
        try {
            this.context?.destroy();
            Reflect.deleteProperty(this, "context");
        }
        catch (e) {}
        finally { super.release(arguments); }
    }

    createHandlers () {
        this.handlers.f32_add   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.add, dataType: "float32" } );
        this.handlers.f32_mul   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.mul, dataType: "float32" } );
        this.handlers.f32_sub   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.sub, dataType: "float32" } );
        this.handlers.f32_div   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.div, dataType: "float32" } );
        this.handlers.f32_max   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.max, dataType: "float32" } );
        this.handlers.f32_min   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.min, dataType: "float32" } );
        this.handlers.f32_neg   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.neg, dataType: "float32" } );
        this.handlers.f32_abs   = this.calc.bind(this, { builder: MLGraphBuilder.prototype.abs, dataType: "float32" } );
        this.handlers.f32_sqrt  = this.calc.bind(this, { builder: MLGraphBuilder.prototype.sqrt, dataType: "float32" } );
        this.handlers.f32_ceil  = this.calc.bind(this, { builder: MLGraphBuilder.prototype.ceil, dataType: "float32" } );
        this.handlers.f32_floor = this.calc.bind(this, { builder: MLGraphBuilder.prototype.floor, dataType: "float32" } );
        this.handlers.f32_vadd  = this.handlers.f32_add;
        this.handlers.f32_vmul  = this.handlers.f32_mul;
        this.handlers.f32_vsub  = this.handlers.f32_sub;
        this.handlers.f32_vdiv  = this.handlers.f32_div;
        this.handlers.f32_vmax  = this.handlers.f32_max;
        this.handlers.f32_vmin  = this.handlers.f32_min;
    }

    async calc ( options, source, values, target = source ) {
        super.lock( arguments );
        
        return new Promise(async (resolve, reject) => {
            const graphBuilder  = new MLGraphBuilder( this.context );
            const buildOptions  = {
                dst : Reflect.apply(
                    options.builder, graphBuilder, Array.of(
                        graphBuilder.input( 'src', { dataType: options.dataType, shape: [ source.length ] }),
                        graphBuilder.input( 'val', { dataType: options.dataType, shape: [ values.length ] })
                    )
                )
            };

            const createTensors = () => Promise.all([
                this.context.createTensor({ dataType: options.dataType, shape: [ target.length ], readable: true }),
                this.context.createTensor({ dataType: options.dataType, shape: [ source.length ], writable: true }),
                this.context.createTensor({ dataType: options.dataType, shape: [ values.length ], writable: true }),
            ]);

            graphBuilder
                .build( buildOptions )
                    .then(graph     => createTensors(this.graph = graph))
                    .then(tensors   => this.dispatch(tensors, source, values))
                    .then(out       => this.context.readTensor( out, target ))
                    .then(()        => resolve(target))
                .catch(error => reject(error))
            .finally(() => this.release(arguments));
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
        try {
            this.graph?.destroy();
            Reflect.deleteProperty(this, "graph");
        }
        catch (e) {}
        finally { super.release(arguments); }
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
            neg     : { value : function ( target = this )        { return ipu.calc( "f32_neg",   target, this ); } },
            abs     : { value : function ( target = this )        { return ipu.calc( "f32_abs",   target, this ); } },
            sqrt    : { value : function ( target = this )        { return ipu.calc( "f32_sqrt",  target, this ); } },
            ceil    : { value : function ( target = this )        { return ipu.calc( "f32_ceil",  target, this ); } },
            floor   : { value : function ( target = this )        { return ipu.calc( "f32_floor", target, this ); } },
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
