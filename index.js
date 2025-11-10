import enumerate from "./node_modules/niceenum/index.js"

class EventEmitter              extends EventTarget {

    static wListeners    = new WeakMap();
    static mEventClass   = new Map();

    static EventClass       (thisArg, type, tagName) {
        if (typeof tagName === "undefined") {
            tagName = `${thisArg.constructor.name}${type.charAt(0).toUpperCase()}${type.substring(1)}Event`;
        }

        if (this.mEventClass.has(tagName)) {
            return this.mEventClass.get(tagName);
        }

        const eventClass = class extends CustomEvent {
            constructor (type, data) { super(type, {detail: data}); }
        };

        Object.defineProperty(eventClass, "name", { value: tagName });
        Object.defineProperty(eventClass, "eventType", { value: type });
        Object.defineProperty(eventClass.prototype, "data", { enumerable: true, get: function () { return this.detail; } });
        Object.defineProperty(eventClass.prototype, "log", { value: function () { console.log(this, ...arguments) } });
        Object.defineProperty(eventClass.prototype, "warn", { value: function () { console.warn(this, ...arguments) } });
        Object.defineProperty(eventClass.prototype, "error", { value: function () { console.error(this, ...arguments) } });
        Object.defineProperty(eventClass.prototype, Symbol.toStringTag, { value: tagName });

        this.mEventClass.set(tagName, eventClass);

        return eventClass;
    }

    on                      (type, callback, options) {
        this.addListener(type, callback, options);
        return this;
    }

    once                    (type, callback, options) {
        if (options) { options.once = true; }
        else { options = { once: true }; }
        return this.on(type, callback, options);
    }

    ontype                  (type, callback = void 0) {
        this.addListener(type, callback);

        Reflect.defineProperty(this, `on${type}`, {
            value: callback, configurable: true
        });
    }

    emit                    (type, data = this) {
        const event = Reflect.construct(
            EventEmitter.EventClass(this, type),
            Array.of(type, data)
        );

        this.dispatch(event);
        return this;
    }

    dispatch                (event) {
        this.dispatchEvent(event);
    }

    addListener             (type, callback, options) {
        const handlers = this.getListeners( type );
        if (handlers.has(callback)) { return this; }
        handlers.add(callback);
        this.addEventListener(type, callback, options);
    }

    getListeners            (type) {
        if (this[ `[[Listeners]]` ].has(type) === false) {
            this[ `[[Listeners]]` ].set(type, new WeakSet);
        }

        return this[ `[[Listeners]]` ].get(type);
    }

    removeListener          (type, callback) {
        const handlers = this.getListeners( type );
        if (handlers.has(callback) === false) { return this;}
        handlers.delete(callback);
    }

    get [ `[[Listeners]]` ] () { return EventEmitter.wListeners.get(this) || (this[ `[[Listeners]]` ] = new Map); }
    set [ `[[Listeners]]` ] ( value ) { EventEmitter.wListeners.set(this, value) }
}

const replaceWASM               = (buffer, target, offset = 0) => {
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
};

const fallbackHandlers          = {

    f32_vadd                    : async function ( source, values, target = source ) {
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

    f32_add                     : async function ( source, values, target = source ) {
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
    
    f32_vmul                    : async function ( source, values, target = source ) {
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

    f32_mul                     : async function ( source, values, target = source ) {
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
    
    f32_vdiv                    : async function ( source, values, target = source ) {
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
     
    f32_div                     : async function ( source, values, target = source ) {
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
    
    f32_vsub                    : async function ( source, values, target = source ) {
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
    
    f32_sub                     : async function ( source, values, target = source ) {
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
    
    f32_vmax                    : async function ( source, values, target = source ) {
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
    
    f32_max                     : async function ( source, values, target = source ) {
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
    
    f32_vmin                    : async function ( source, values, target = source ) {
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
    
    f32_min                     : async function ( source, values, target = source ) {
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
    
    f32_neg                     : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = -source[i]; }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_abs                     : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.abs(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_sqrt                    : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.sqrt(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_ceil                    : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.ceil(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    },
    
    f32_floor                   : async function ( source, target = source ) {
        return new Promise( (resolve, reject) => {
            
            if (source.length === target.length) {
                let i = target.length;
                while (i--) { target[i] = Math.floor(source[i]); }
                return resolve(target);
            }
    
            reject(`Error: Source length (${source.length}) must be equal to target length (${target.length}).`)
        });
    }
};

export class PUEvent            extends CustomEvent {

    constructor             (type, detail) {
        super(type, {detail})
    }

    get data                    () {
        return this.detail; 
    }
};

export class PU                 extends EventTarget {

    static hardwareConcurrency  = navigator.hardwareConcurrency;

    constructor                 () {
        super(...arguments);
        
        Object.defineProperties(this, {
            handlers : { value: new Object() },
        });
    }

    async init                  () {
        return new Promise( (resolve, reject) => {
            try {
                this.createHandlers()
                this.settle()
        
                this.deviceState = this.INIT;
                this.emit("create", arguments); 
        
                this.check();
                this.release();
                resolve();
            } catch (e) { reject(e); }
        }); 
    }

    async destroy               () { 
        return new Promise( (resolve, reject) => {
            try {
                this.lock();
                this.restore();
                this.deviceState = this.CLOSED;
                this.emit("destroy", arguments) 
                resolve();
            } catch (e) { reject(e); }
        }); 
    }
    
    release                     (args) { 
        this.lockState = this.IDLE;
        this.emit("idle", args);
    }

    lock                        (args) {
        this.lockState = this.LOCKED;
        this.emit("lock", args);
    }

    error                       () { this.emit("error"); }
    ready                       () { this.emit("ready"); }

    log                         () {   console.log(...arguments) }
    warn                        () {  console.warn(...arguments) }
    catch                       () { console.error(...arguments) }
    error                       () { console.error(...arguments) }

    on                          () { return this.addEventListener(...arguments), this; }
    once                        () { return this.addEventListener(...arguments, {once: true}), this; }
    emit                        () { return this.dispatchEvent(new PUEvent(...arguments)), this; }

    check                       () {
        this.deviceState = this.READY;
        this.emit("ready");
    }

    createHandlers              () {
        throw `PU class need has own create handlers function!`
    }

    settle                      () {
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

    restore                     () {
        for (const name in this.handlers) {
            Reflect.deleteProperty(this, name);
        }
        this.emit("restore", this.handlers);
    }

    async calc                  (options, ...args) {
        const handler = fallbackHandlers[ options.funcName ];
        return Reflect.apply( handler, this, args );
    }
}; 

export class CPU                extends PU {

    createHandlers              () {
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

    async init                  () {
        return new Promise(async (resolve, reject) => {
            Object.defineProperties(this, {
                imports : { value: new Map() },
                workers : { value: new Map() },
            });

            if (this.memory === undefined) {
                this.memory = PU.memory ?? CPU.createMemory();
            }

            try {
                WebAssembly
                    .compile(replaceWASM(CPU.wasm, this.memory))
                        .then(module => this.module = module)
                        .then(() => this.createWindowThread())
                        .then(() => this.createWorkerThreads())
                        .then(() => super.init(...arguments))
                        .then(() => resolve(this))
                    .catch((err) => reject(`WebAssembly not instantiated: ${err}`))
            }   
            catch (e) { reject(`WebAssembly not supported: ${e}`)}
        });
    }

    async destroy               () {
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
                    .then(() => resolve(this))
                .catch(reject);
            }
            catch (e) { reject(`CPU destroy failed: ${e}`) }
        });
    }

    async calc                  (options, source, values, target = source) {
        super.lock( arguments );

        return new Promise(async (resolve, reject) => {
            const src = this.import(source);
            const val = this.import(values);
            const dst = this.import(target, false);

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
                });

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
                    .then(() => this.export(dst, arguments[3]))
                    .then(out => resolve(out))
                .catch(err => reject(err))
            .finally(() => this.release(arguments));
        });
    }

    async createWorkerThreads   () {
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

    async createWindowThread    () {
        return new Promise(async (resolve, reject) => {
            const imports = {env: {memory: this.memory}};
            return WebAssembly.instantiate(this.module, imports)
                .then(instance => this.instance = instance)
                .then(() => resolve())
            .catch(e => reject(`WASM instance creation failed: ${e}`));
        });
    } 

    import                      (source, clone = true) {
        if (source.buffer === this.memory.buffer) {
            return source;
        }
        else {
            if (this.imports.has(source)) {
                return this.imports.get(source);
            }
            else {
                try {
                    const TypedArray = source.constructor;
                    const length     = source.length;
                    const byteLength = source.byteLength;
                    const byteOffset = this.memory.malloc(byteLength);
                    const target     = Reflect.construct(
                        TypedArray, [ this.memory.buffer, byteOffset, length ]
                    );
                    
                    this.imports.set( source, target );
                    if (clone) { target.set(source); };
            
                    return target;
                }
                catch (e) { throw e; }
            }
        }
    }

    export                      (view, argview) {
        if (this.imports.has(view)) {
            const dst = this.imports.get(view);

            if (dst !== view) {
                dst.set(view);
            }
            
            return dst;
        }
        
        if (argview) {
            argview.set(view);
            return argview;
        }

        return view;
    }

    grow (byteLength) {
        if (this.memory.buffer.byteLength < byteLength) {
            const deltaByteLenth = Math.abs(this.memory.buffer.byteLength - byteLength);
            const deltaPageSize  = Math.max(Math.ceil(deltaByteLenth / 65536), 0);
            this.memory.grow( deltaPageSize );
        }
    }

    static createMemory         () {
        const initial = 1;
        const maximum = 65536/2;

        const memory = new WebAssembly.Memory({initial, maximum, shared: true});
        const atomic = new Uint32Array(memory.buffer);
        const malloc = Atomics.add.bind(Atomics, atomic, 1);

        malloc(16);

        let freePages = maximum - initial;
        Reflect.defineProperty(memory, "malloc", {
            value: function (byteLength = 0) {
                
                if (byteLength % 16) {
                    byteLength = byteLength + 16 - byteLength % 16;
                }
                
                let byteOffset = malloc(byteLength);
                const byteDiff = byteOffset + byteLength - this.buffer.byteLength;

                if (byteDiff > 0) {
                    const size = Math.max(1, Math.ceil(byteDiff / 65536));
                    freePages -= size;

                    if (freePages < 0) { 
                        throw `Memory size will be exceed: ${freePages}` 
                    }
                    
                    try { this.grow(size); }
                    catch (e) { throw `Memory size exceed: ${e}` }
                    finally { `Memory resized with ${byteDiff} bytes` }
                }

                return byteOffset;
            }
        });

        Reflect.defineProperty(memory, "initial", { value: initial });
        Reflect.defineProperty(memory, "maximum", { value: maximum });
        Reflect.defineProperty(memory, "isDefaultMemory", { value: true });
        Reflect.defineProperty(PU, "memory", { value: memory, configurable: true })

        return memory;
    }

    static wasm                 = Uint8Array.from(
        "0061736d0100000001110260067f7f7f7f7f7f0060047f7f7f7f0002140103656e76066d656d6f72790203808004808004030c0b0000000000000101010101040401700064077a0c076633325f6164640000076633325f7375620001076633325f6d756c0002076633325f6469760003076633325f6d696e0004076633325f6d61780005076633325f6162730006076633325f6e65670007086633325f737172740008086633325f6365696c0009096633325f666c6f6f72000a0466756e630100090a010041000b04000102030a8f180bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde401fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0092380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde401fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70292380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde501fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0093380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde501fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70293380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde601fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0094380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde601fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70294380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde701fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0095380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde701fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70295380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde801fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0096380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde801fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70296380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bee0201027b20072004fd1c002000fd1c012002fd1c022005fd1c032107410120034604402007fd1b02fd090298d588b702210603402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022006fde901fd0b0498d588b7022007fd0c100000001000000000000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022006fd1f0097380298d588b7022007fd0c040000000400000000000000fffffffffdae0121070c010b0b0f0b2003200546044003402007fd1b0341044f04402007fd1b002007fd1b01fd000498d588b7022007fd1b02fd000498d588b702fde901fd0b0498d588b7022007fd0c100000001000000010000000fcfffffffdae0121070c010b0b03402007fd1b0341014f04402007fd1b002007fd1b012a0298d588b7022007fd1b022a0298d588b70297380298d588b7022007fd0c040000000400000004000000fffffffffdae0121070c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde001fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028b380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde101fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028c380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bae0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fde301fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b70291380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd67fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028d380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000bad0101017b20042002fd1c002000fd1c012001fd1c022003fd1c0321042001200346044003402004fd1b0341044f04402004fd1b002004fd1b01fd000498d588b702fd68fd0b0498d588b7022004fd0c1000000010000000fcfffffffcfffffffdae0121040c010b0b03402004fd1b0341014f04402004fd1b002004fd1b012a0298d588b7028e380298d588b7022004fd0c0400000004000000fffffffffffffffffdae0121040c010b0b0f0b000b"
        .match(/(..)/g).map(v => parseInt(v, 16))
    ).buffer;

    static workerCode           = () => {
        self.onmessage = e => {
            const { memory, module, buffer } = e.data;
            const queue     = new Int32Array(buffer);
            const params    = queue.subarray(2);
            const pid       = Number(name);

            const reset     = Atomics.store.bind(Atomics, queue, 0, 0);
            const lock      = Atomics.wait.bind(Atomics, queue, 0);

            WebAssembly
                .instantiate(module, {env: {memory}})
                    .then(instance => {
                        postMessage(pid);

                        const handler = WebAssembly.Table.prototype.get.bind(
                            instance.exports.func
                        );

                        do {
                            lock();
                            handler(queue[1]).apply(null, params);
                            postMessage(0);
                            reset();
                        }
                        while(true);

                    })
            .catch((err) => postMessage(err))
        }
    };

    static workerURL            = URL.createObjectURL(
        new Blob([`(${this.workerCode})()`])
    );
}; 

export class WPU                extends EventTarget {
    static script  = () => {
        onmessage = e => WebAssembly.instantiate(e.data).then(i => {
            const {memory: {buffer}} = e = i.exports;
        });
    }

    init () {
        WebAssembly.compileStreaming(fetch("wpu.wasm")).then(module =>
            new Worker(URL.createObjectURL(
                new Blob([`(${WPU.script})()`])
            )).postMessage(module)
        )
    }
}

export class GPU                extends PU {

    createHandlers              () {
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

    async init                  () {
        return new Promise(async (resolve, reject) => {
            this.acquireDevice()
                    .then(() => this.createBuffers())
                    .then(() => this.createPipelines())
                    .then(() => resolve())
                .catch((err) => reject(`GPU failed: ${err}`))
            .finally(() => super.init(...arguments));
        });
    }

    async destroy               () {
        return new Promise(async (resolve, reject) => {
            this.indexBuffer.destroy();
            this.valueBuffer.destroy();
            this.inputBuffer.destroy();
            this.outputBuffer.destroy();
            this.stagingBuffer.destroy();
            this.device.destroy();
            this.pipelines.clear();
            this.vpipelines.clear();

            Reflect.deleteProperty(this, "indexBuffer");
            Reflect.deleteProperty(this, "valueBuffer");
            Reflect.deleteProperty(this, "inputBuffer");
            Reflect.deleteProperty(this, "outputBuffer");
            Reflect.deleteProperty(this, "stagingBuffer");

            Reflect.deleteProperty(this, "vpipelines");
            Reflect.deleteProperty(this, "pipelines");
            Reflect.deleteProperty(this, "bindingSize");
            Reflect.deleteProperty(this, "workgroupSize");
            Reflect.deleteProperty(this, "invocations");
            
            Reflect.deleteProperty(this, "bindGroup");
            Reflect.deleteProperty(this, "bindLayout");
            
            Reflect.deleteProperty(this, "device");
            Reflect.deleteProperty(this, "adapter");

            super
                .destroy(...arguments)
                .then(resolve)
                .catch(reject);
        });
    }

    async calc                  (options, source, values, target = source) {
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
                    .then(() => this.release(arguments))
                    .then(() => resolve(target))
                .catch(error => reject(error))
            ;
        });
    }

    release                     () {
        if (this.stagingBuffer.mapState === "mapped") {
            this.stagingBuffer.unmap();
        }
    }

    static shader               = String(`
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

    async acquireDevice         () { 
        return navigator.gpu
            .requestAdapter({ powerPreference: "high-performance" })
                .then(adapter => this.adapter = adapter)
                .then(() => this.adapter.requestDevice())
                .then(device => this.device = device)
        ;
    }
    
    createBuffers               () {
        this.bindingSize    = this.device.limits.maxStorageBufferBindingSize;
        this.workgroupSize  = this.device.limits.maxComputeWorkgroupsPerDimension;
        this.invocations    = this.device.limits.maxComputeInvocationsPerWorkgroup;
        
        this.indexBuffer    = this.device.createBuffer({ size : 256, usage : GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
        this.valueBuffer    = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
        this.inputBuffer    = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
        this.outputBuffer   = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_SRC }),
        this.stagingBuffer  = this.device.createBuffer({ size : this.bindingSize, usage : GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST });
    }

    createPipelines             () {
        this.pipelines = new Map();
        this.vpipelines = new Map();

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
};

export class NPU                extends PU {

    createHandlers              () {
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

    async init                  () {
        return this.context ?? navigator.ml
            .createContext({ powerPreference: "default"})
            .then(context => this.context = context)
        .finally(() => super.init(...arguments))
    }

    async destroy               () {
        try {
            this.context?.destroy();
            Reflect.deleteProperty(this, "context");
        }
        catch (e) {}
        finally { super.release(arguments); }
    }

    async calc                  (options, source, values, target = source) {
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

    release                     () {
        try {
            this.graph?.destroy();
            Reflect.deleteProperty(this, "graph");
        }
        catch (e) {}
        finally { super.release(arguments); }
    }    

    dispatch                    (tensors, source, values) {
        const [ dst, src, val ] = tensors;

        this.context.writeTensor(src, source);
        this.context.writeTensor(val, values);
        this.context.dispatch(this.graph, {src, val}, {dst});

        return dst;
    }
};

export class CPU_Native_SingleThread    extends EventEmitter {

    f32_add         (source, values, target) {
        return this.calc({ op: "f32_add" }, source, values, target);
    }

    f32_mul         (source, values, target) {
        return this.calc({ op: "f32_mul" }, source, values, target);
    }

    f32_sub         (source, values, target) {
        return this.calc({ op: "f32_sub" }, source, values, target);
    }

    f32_div         (source, values, target) {
        return this.calc({ op: "f32_div" }, source, values, target);
    }

    f32_rem         (source, values, target) {
        return this.calc({ op: "f32_rem" }, source, values, target);
    }

    f32_max         (source, values, target) {
        return this.calc({ op: "f32_max" }, source, values, target);
    }

    f32_min         (source, values, target) {
        return this.calc({ op: "f32_min" }, source, values, target);
    }

    f32_sqrt        (source, target) {
        return this.calc({ op: "f32_sqrt" }, source, null, target);
    }

    f32_ceil        (source, target) {
        return this.calc({ op: "f32_ceil" }, source, null, target);
    }

    f32_floor       (source, target) {
        return this.calc({ op: "f32_floor" }, source, null, target);
    }

    calc            (config, source, values, target) {
        return new Promise((done, fail) => {
            const opType  = config.op.split("_").at(1);
            const vLength = values.length;
            
            let i = source.length; 

            if (true === (target ??= source)) {
                target = Reflect.construct(
                    source.constructor, [i]
                );
            }
            
            switch (vLength) {
                case 0:
                case NaN:
                case null:
                case false:
                case undefined:
                    switch (opType) {
                        case  "sqrt": while (i--) {target[i] = Math.sqrt(source[i])}  break;
                        case  "ceil": while (i--) {target[i] = Math.ceil(source[i])}  break;
                        case "floor": while (i--) {target[i] = Math.floor(source[i])} break;
                        default: fail(new Error(`Math operation not supported: ${opType}`)); return;
                    }
                    done(target);
                return;

                case 1:
                    const value = values[0];
                    switch (opType) {
                        case   "add": while (i--) {target[i] = source[i] + value} break;
                        case   "mul": while (i--) {target[i] = source[i] * value} break;
                        case   "sub": while (i--) {target[i] = source[i] - value} break;
                        case   "div": while (i--) {target[i] = source[i] / value} break;
                        case   "rem": while (i--) {target[i] = source[i] % value} break;
                        case   "max": while (i--) {target[i] = Math.max(source[i], value)} break;
                        case   "min": while (i--) {target[i] = Math.min(source[i], value)} break;
                        default: fail(new Error(`Operation not supported: ${opType}`)); return;
                    }
                    done(target);
                return;
                
                case source.length:
                    switch (opType) {
                        case   "add": while (i--) {target[i] = source[i] + values[i]} break;
                        case   "mul": while (i--) {target[i] = source[i] * values[i]} break;
                        case   "sub": while (i--) {target[i] = source[i] - values[i]} break;
                        case   "div": while (i--) {target[i] = source[i] / values[i]} break;
                        case   "rem": while (i--) {target[i] = source[i] % values[i]} break;
                        case   "max": while (i--) {target[i] = Math.max(source[i], values[i])} break;
                        case   "min": while (i--) {target[i] = Math.min(source[i], values[i])} break;
                        default: fail(new Error(`Operation not supported: ${opType}`)); return;
                    }
                    done(target);
                return;
                
                default:
                    fail(new Error(`Lengths are not calculatable ${source.length}, ${vLength}`));
                return;
            }
        });
    }

    close           () {
        this.clear()
        this.emit("closed")
    }

    clear           () {
        this.emit("clear")
    }

    init            () {
        this.emit("ready") 
    }

}

export class CPU_Native_MultiThread_DetachBuffer     extends EventEmitter {
    constructor () {
        super(...arguments)

        this.buffer = new ArrayBuffer(0o0 <<- 0x0, { maxByteLength: 16E+7 });
        this.view = {
            Float32Array : new Float32Array(this.buffer),
            Uint32Array : new Uint32Array(this.buffer),
            Uint8Array : new Uint8Array(this.buffer),
        };
    }

    grow (byteLength) { this.buffer.resize( byteLength ) }

    static get workerURL () {

        const onReadyCall = () => {

            const e0 = new Error(`Worker is NOT idle!`);
            let idle = 1;

            addEventListener("message", async e => {
                const {config, source, values, target} = e.data;

                if (!idle) return postMessage(e0)
                else idle = 0;
            
                self.pu
                    .calc(config, source, values, target)
                        .then(t => postMessage(t, [t.buffer]))
                    .catch(e => postMessage(e))
                .finally(() => idle = 1);
            });
            
            postMessage(performance.now());
        };

        const scopeScript = [
            `\n${Object.getPrototypeOf(this.SinglePU)};`,
            `\nself.pu = new ${this.SinglePU};`,
            `\nself.pu.on("ready", ${onReadyCall});`,
            `\nself.pu.init();`,
        ];

        Object.defineProperty(this, "workerURL", {
            value: URL.createObjectURL(
                new Blob( scopeScript )
            )
        });

        return this.workerURL;
    }

    static SinglePU     = CPU_Native_SingleThread;

    workers             = [];

    concurrency         = navigator.hardwareConcurrency;

    f32_add             (source, values, target) {
        return this.calc({ op: "f32_add" }, source, values, target);
    }

    f32_mul             (source, values, target) {
        return this.calc({ op: "f32_mul" }, source, values, target);
    }

    f32_sub             (source, values, target) {
        return this.calc({ op: "f32_sub" }, source, values, target);
    }

    f32_div             (source, values, target) {
        return this.calc({ op: "f32_div" }, source, values, target);
    }

    f32_rem             (source, values, target) {
        return this.calc({ op: "f32_rem" }, source, values, target);
    }

    f32_max             (source, values, target) {
        return this.calc({ op: "f32_max" }, source, values, target);
    }

    f32_min             (source, values, target) {
        return this.calc({ op: "f32_min" }, source, values, target);
    }

    f32_sqrt            (source, target) {
        return this.calc({ op: "f32_sqrt" }, source, null, target);
    }

    f32_ceil            (source, target) {
        return this.calc({ op: "f32_ceil" }, source, null, target);
    }

    f32_floor           (source, target) {
        return this.calc({ op: "f32_floor" }, source, null, target);
    }

    clear               () {
        this.workers.map(w => w.terminate())
        this.workers.length = 0;

        if (typeof this.spu?.close === "function") {
            this.spu.close();
        }

        this.emit("clear")
    }

    close               () {
        this.clear();
        this.emit("closed")
    }

    fail                () {
        const [ error ] = arguments;
        this.emit("error", error);
        this.close(-1);
    }

    fork                () {
        return new Promise((resolve, reject) => {
            const worker = new Worker(this.constructor.workerURL, {name: "cpu"});
            worker.addEventListener("message", e => resolve(worker), {once: true});
            worker.addEventListener("error", e => reject(e), {once: true});
        });
    }

    init                (concurrency = this.concurrency) {
        return new Promise((done, fail) => {
            this.clear();
            
            this.spu = Reflect.construct(this.constructor.SinglePU, this);
            this.spu.on("ready", async () => {
                
                const promises = [];
                
                while (concurrency--)
                    promises.push(this.fork());
    
                promises.map(p => 
                    p.then(worker => this.workers.push(worker))
                    .catch(worker => worker.terminate())
                );
    
                Promise.all(promises).finally(() => {
                    if (this.workers.length > 0) { 
                        this.workers.map((w,i) => w.i = i);
                        this.emit("ready"); 
                        done(this); 
                    } 
                    else { 
                        this.fail(new Error(`No workers created.`));
                        fail(null); 
                    }
                });
            });
            
            this.spu.init();
        });
    }

    calc                (config, source, values, target) {
        return new Promise((done, fail) => {

            const idleWorkers   = this.workers.filter(w => !w.busy);
            
            const workerCount   = idleWorkers.length;
            const calcCount     = source.length;

            const alignLength   = (calcCount % workerCount);
            const threadLength  = (calcCount - alignLength) / workerCount;

            if (true === (target ??= source)) {
                target = Reflect.construct(
                    source.constructor, [ calcCount ]
                );
            }
    
            const promises  = idleWorkers.map((worker, i) => {
                worker.busy = true;
    
                const begin = alignLength + (threadLength * i);
                const end   = begin + threadLength;    
                const data  = Object({config, source: source.subarray(begin, end).slice()});

                const transfers = Array.of(data.source.buffer);

                if (values) {
                    if (values.length === 1) { data.values = values.slice(); }
                    else { data.values = values.subarray(begin,end).slice(); }
                    transfers.push( data.values.buffer );
                }
        
                if (target !== source) {
                    data.target = target.subarray(begin, end).slice();
                    transfers.push( data.target.buffer );
                };
                    
                const promise = new Promise((resolve, reject) => {
                    worker.addEventListener("error", e => reject(e), {once: true});
                    worker.addEventListener("message", e => {
                        e.target.busy = false;
                        
                        if (e.data instanceof Error) {
                            reject(e.data);
                            return;
                        } 
                        
                        target.subarray(begin, end).set(e.data);
                        resolve();
                        return;
                    }, {once: true});
                });

                worker.postMessage(data, transfers);

                return promise;
            });
    
            if (alignLength > 0) {
                promises.push(
                    this.spu.calc(
                        config, 
                        source.subarray(0, alignLength), 
                        values.subarray(0, alignLength), 
                        target.subarray(0, alignLength)
                    )
                );
            };
            
            Promise.all(promises)
                .then(() => done(target))
            .catch(error => fail(error));
        });
    }
}

export class CPU_Native_MultiThread_SharedBuffer     extends EventEmitter {

    constructor () {
        if ("SharedArrayBuffer" in self === false) {
            throw(new Error(`SharedArrayBuffer is not supported!`));
        }
        
        super(...arguments)

        this.buffer = new SharedArrayBuffer(0o0 <<- 0x0, { maxByteLength: 16E+7 });
        this.view = {
            Float32Array : new Float32Array(this.buffer),
            Uint32Array : new Uint32Array(this.buffer),
            Uint8Array : new Uint8Array(this.buffer),
        };
    }

    grow (byteLength) { this.buffer.grow( byteLength ) }

    static get workerURL () {

        const onReadyCall = () => {
            addEventListener("message", e => {

                let isIdle = 1;
                const err0 = new Error(`Worker is NOT idle!`);
                const view = {
                    Float32Array : new Float32Array(e.data),
                    Uint32Array : new Uint32Array(e.data),
                };
    
                addEventListener("message", async e => {
                    const {config, begin, end} = e.data;
    
                    if (!isIdle) return postMessage(err0)
                    else isIdle = 0;
                
                    const source = view[ config.TypedArray ].subarray( begin.source, end.source );
                    const values = view[ config.TypedArray ].subarray( begin.values, end.values );
                    const target = view[ config.TypedArray ].subarray( begin.target, end.target );

                    self.pu
                        .calc(config, source, values, target)
                            .then(() => postMessage(1))
                        .catch(e => postMessage(e))
                    .finally(() => isIdle = 1);
                });
                
                postMessage(performance.now());
            }, {once: true})
        };

        const scopeScript = [
            `\n${Object.getPrototypeOf(this.SinglePU)};`,
            `\nself.pu = new ${this.SinglePU};`,
            `\nself.pu.on("ready", ${onReadyCall});`,
            `\nself.pu.init();`,
        ];

        Object.defineProperty(this, "workerURL", {
            value: URL.createObjectURL(
                new Blob( scopeScript )
            )
        });

        return this.workerURL;
    }

    static SinglePU     = CPU_Native_SingleThread;

    workers             = [];

    concurrency         = navigator.hardwareConcurrency;

    f32_add             (source, values, target) {
        return this.calc({ op: "f32_add", wasmType: "f32", npuType: "float32", gpuType: "float", TypedArray: "Float32Array" }, source, values, target);
    }

    clear               () {
        this.emit("clear")
    }

    close               () {
        this.clear();
        this.emit("closed")
    }

    fail                () {
        const [ error ] = arguments;
        this.emit("error", error);
        this.close(-1);
    }

    fork                () {
        return new Promise((resolve, reject) => {
            const worker = new Worker(this.constructor.workerURL, {name: "cpu"});
            worker.addEventListener("message", e => resolve(worker), {once: true});
            worker.addEventListener("error", e => reject(e), {once: true});
            worker.postMessage(this.buffer);
        });
    }

    init (concurrency = this.concurrency) {
        return new Promise((done, fail) => {

            this.clear();
            
            
            this.spu = Reflect.construct(this.constructor.SinglePU, this);
            this.spu.on("ready", async () => {
                
                const promises = [];
                
                while (concurrency--)
                    promises.push(this.fork());
    
                promises.map(p => 
                    p.then(worker => this.workers.push(worker))
                    .catch(worker => worker.terminate())
                );
    
                Promise.all(promises).finally(() => {
                    if (this.workers.length > 0) { 
                        this.workers.map((w,i) => w.i = i);
                        this.emit("ready"); 
                        done(this); 
                    } 
                    else { 
                        this.fail(new Error(`No workers created.`));
                        fail(null); 
                    }
                });
            });
            
            this.spu.init();
        });
    }

    bind                (worker) {
        return new Promise((resolve, reject) => {
            worker.addEventListener("error", e => reject(e), {once: true});
            worker.addEventListener("message", e => {
                e.target.busy = false;
                
                if (e.data instanceof Error) {
                    reject(e.data);
                    return;
                } 
                
                resolve();
            }, {once: true});
        });
    }

    calc                (config, source, values, target) {
        return new Promise((done, fail) => {

            const idleWorkers   = this.workers.filter(w => !w.busy);
            
            const workerCount   = idleWorkers.length;
            const calcCount     = source.length;

            const alignLength   = (calcCount % workerCount);
            const threadLength  = (calcCount - alignLength) / workerCount;

            let offset          = 0;

            let srcView     , valView   , dstView, 
                srcLength   , valLength , dstLength,
                srcBegin    , valBegin  , dstBegin,
                srcEnd      , valEnd    , dstEnd;

            if (true === (target ??= source)) {
                target = Reflect.construct(
                    source.constructor, [
                        calcCount
                    ]
                );
            }

            srcLength = source.length; 
            valLength = values.length; 
            dstLength = target.length; 

            const requiredByteLength = (
                source.byteLength + 
                values.byteLength + 
                target.byteLength
            ); 

            if (requiredByteLength > this.buffer.byteLength) {
                this.buffer.grow( requiredByteLength );
            }

            if (source.buffer !== this.buffer) {
                srcBegin  = offset;   
                srcEnd    = srcBegin + srcLength;   
                srcView   = this.view[ config.TypedArray ].subarray( srcBegin, srcEnd );
                offset   += srcView.length;
                
                srcView.set( source );
            }
            else {
                srcBegin  = source.byteOffset / source.BYTES_PER_ELEMENT;
                srcEnd    = srcBegin + srcLength;
                srcView   = source;
            }

            if (values.buffer !== this.buffer) {
                valBegin  = offset;   
                valEnd    = valBegin + valLength;
                valView   = this.view[ config.TypedArray ].subarray( valBegin, valEnd );
                offset   += valView.length;

                valView.set( values );
            }
            else {
                valBegin  = values.byteOffset / values.BYTES_PER_ELEMENT;
                valEnd    = valBegin + valLength;
                valView   = values;
            }
            
            if (target.buffer !== this.buffer) {
                dstBegin  = offset;
                dstEnd    = dstBegin + dstLength;
                dstView   = this.view[ config.TypedArray ].subarray( dstBegin, dstEnd );
                offset   += dstView.length;
            }
            else {
                dstBegin  = target.byteOffset / target.BYTES_PER_ELEMENT;
                dstEnd    = dstBegin + dstLength;
                dstView   = target;
            }

            const promises  = idleWorkers.map((worker, i) => {
                worker.busy = true;

                const data  = { 
                    config  : config, 
                    begin   : { 
                        source : srcBegin, 
                        values : valBegin, 
                        target : dstBegin, 
                    },
                    end     : {}
                };

                const threadOffset = alignLength + (threadLength * i);
                data.begin.source += threadOffset;
                data.begin.target += threadOffset;
                
                if (valLength === srcLength) {
                    data.begin.values += threadOffset;
                }
                
                data.end.source = data.begin.source + srcLength;
                data.end.values = data.begin.values + valLength;
                data.end.target = data.begin.target + dstLength;

                worker.postMessage(data);
                
                return this.bind(worker);
            });
    
            if (alignLength > 0) {
                promises.push(
                    this.spu.calc(
                        config, 
                        srcView.subarray(0, alignLength), 
                        valView.subarray(0, alignLength), 
                        dstView.subarray(0, alignLength)
                    )
                );
            };
            
            Promise.all(promises)
                .then(() => {
                    if (target.buffer !== dstView.buffer) {
                        target.set(dstView);
                        return;
                    }
                    if (target.byteOffset !== dstView.byteOffset) {
                        this.view.Uint8Array.copyWithin(
                            target.byteOffset, 
                            dstView.byteOffset,
                            dstView.byteOffset + dstView.byteLength
                        )
                    }
                })
                .then(() => done(target))
            .catch(error => fail(error));
        });
    }
}

export default {
    CPU, GPU, NPU,
    CPU_Native_SingleThread,
    CPU_Native_MultiThread_DetachBuffer,
    CPU_Native_MultiThread_SharedBuffer
}

Object.defineProperties(PU.prototype, {
    IDLE    : { value: enumerate("IDLE") },
    BUSY    : { value: enumerate("BUSY") },
    READY   : { value: enumerate("READY") },
    LOCKED  : { value: enumerate("LOCKED") },
    CLOSED  : { value: enumerate("CLOSED") },
    INIT    : { value: enumerate("INIT") },
});
