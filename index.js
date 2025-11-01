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

class CPU {
    async f32_add () {
        let [
            dstByteOffset,
            dstLength,

            srcByteOffset,
            srcLength,

            valByteOffset,
            valLength,
        ] = arguments;

        let byteOffset = 0, value, srcValue;

        const dstView = new DataView( this.buffer, dstByteOffset, dstLength * 4 );
        const srcView = new DataView( this.buffer, srcByteOffset, srcLength * 4 );
        const valView = new DataView( this.buffer, valByteOffset, valLength * 4 );

        const BYTES_PER_ELEMENT = 4;

        if (+valLength === 1) {
            value = valView.getFloat32(0, true);
            let i = dstLength;
            while (i--) {
                srcValue = srcView.getFloat32( byteOffset, true );
                dstView.setFloat32( byteOffset, srcValue + value, true ); 
                byteOffset += BYTES_PER_ELEMENT;
            }
        }
    }

    setMemory (memory) {
        this.memory = memory;
        this.buffer = memory.buffer;

        fetch("simd.wasm").then(r => r.arrayBuffer()).then(raw => {
            const wasm = replaceWASM(raw, memory);
            const env = {memory};

            WebAssembly.instantiate(wasm, {env}).then(e => e.instance.exports).then(handlers => {
                for (const handler in handlers) {
                    Object.defineProperty(this, handler, {
                        value: handlers[handler], configurable: true
                    });
                }
            })
        })
    }
} 

class BYTEOFFSET extends Number {}
class BYTELENGTH extends Number {}
class LENGTH extends Number {}

export default class IzomorphicProcessingUnit extends EventTarget {
    static cpuSupport   = Boolean(Math.sqrt(4));
    static wasmSupport  = Reflect.has(self, "WebAssembly");
    static gpuSupport   = Reflect.has(navigator, "gpu");
    static nnSupport    = Reflect.has(navigator, "ml");
    
    constructor () {
        super()

        this.pu = new CPU();
        const ipu = this;

        Object.defineProperties(Float32Array.prototype, {
            add : {
                value : async function ( value, target = this ) {
                    return await ipu.calc("f32_add", target, this, value);
                }
            }
        })
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

        if (typeof value === "number") {
            value = this.memory.Float32Array(1).fill(value)
        }

        if (target === true) {
            target = this.memory.Float32Array(this.length);
        }

        const { byteOffset: dstByteOffset, length: dstLength } = target;
        const { byteOffset: srcByteOffset, length: srcLength } = source;
        const { byteOffset: valByteOffset, length: valLength } = value;

        if (valLength * dstLength * srcLength === 0) {
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

        if (valLength < 1) {
            this.error(this.ERROR_VALUE_LENGTH_MUST_BE_ONE_OR_SRC_LENGTH, arguments);
            return;
        }

        const handler = this.pu[ op ];

        if ( !handler ) {
            throw `Undefined operation: ${op}`
        }
        
        await handler.call( this.pu,
            dstByteOffset, dstLength,
            srcByteOffset, srcLength,
            valByteOffset, valLength,            
        );

        return target;
    }

    setMemory ( memory ) {
        this.memory = memory;
        this.buffer = memory.buffer;
        this.pu.setMemory( memory );
    }
}

CONST.map(e => {
    Object.defineProperty(IzomorphicProcessingUnit, e.toString(), {value: e} );
    Object.defineProperty(IzomorphicProcessingUnit.prototype, e.toString(), {value: e} );
    return e;
});
