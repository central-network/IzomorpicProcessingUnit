import EventEmitter from "./EventEmitter.js";
import enumerate from "./enumerate.js"

export const kHeaders = `deviceBuffer`;

export default class Processor extends EventEmitter {

    static OFFSET_DEVICE_STATE              =  0;
    static OFFSET_DEVICE_EPOCH_LAST         =  4;
    static OFFSET_DEVICE_EPOCH_CONSTRUCT    =  8;
    static OFFSET_DEVICE_EPOCH_INIT_BEGIN   = 12;
    static OFFSET_DEVICE_EPOCH_INIT_END     = 16;
    static OFFSET_DEVICE_EPOCH_EXIT_BEGIN   = 20;
    static OFFSET_DEVICE_EPOCH_EXIT_END     = 24;
    static OFFSET_DEVICE_EPOCH_FAILURE      = 28;
    static OFFSET_DEVICE_EPOCH_MAINTAIN     = 32;
    static OFFSET_DEVICE_EPOCH_CLEAR        = 36;
    static OFFSET_DEVICE_EPOCH_CALL_BEGIN   = 40;
    static OFFSET_DEVICE_EPOCH_CALL_END     = 44;
    static OFFSET_DEVICE_EPOCH_CALC_BEGIN   = 48;
    static OFFSET_DEVICE_EPOCH_CALC_END     = 52;

    static LENGTH_DEVICE_HEADERS            = 56;

    [ kHeaders ] = new DataView(new ArrayBuffer(Processor.LENGTH_DEVICE_HEADERS))
    
    constructor () {
        super()
        this.renewDeviceEpochConstruct();
        this.setDeviceState(Processor.CLOSED);
    }

    malloc      () { throw `Device has no malloc method!` }

    init        () { throw `Device has no init method!` }
    exit        () { throw `Device has no exit method!` }
    clear       () { throw `Device has no clear method!` }
    failure     () { throw `Device has no failure method!` }
    maintain    () { throw `Device has no maintain method!` }
    log         () { throw `Device has no log method!` }
    #args       () { throw `Device has no private args method!` }
    #calc       () { throw `Device has no private calc method!` }

    add         () { throw `Device has no ADD method!` }
    div         () { throw `Device has no DIV method!` }
    mul         () { throw `Device has no MUL method!` }
    sub         () { throw `Device has no SUB method!` }
    max         () { throw `Device has no MAX method!` }
    min         () { throw `Device has no MIN method!` }
    rem         () { throw `Device has no REM method!` }
    lt          () { throw `Device has no LT method!` }
    lte         () { throw `Device has no LTE method!` }
    gt          () { throw `Device has no GT method!` }
    gte         () { throw `Device has no GTE method!` }
    eq          () { throw `Device has no EQ method!` }
    ne          () { throw `Device has no NE method!` }
    floor       () { throw `Device has no FLOOR method!` }
    ceil        () { throw `Device has no CEIL method!` }
    sqrt        () { throw `Device has no SQRT method!` }


    getDeviceEpochLast              () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_LAST, true); }
    getDeviceEpochConstruct         () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CONSTRUCT, true); }
    getDeviceEpochInitBegin         () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_INIT_BEGIN, true); }
    getDeviceEpochInitEnd           () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_INIT_END, true); }
    getDeviceEpochExitBegin         () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_EXIT_BEGIN, true); }
    getDeviceEpochExitEnd           () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_EXIT_END, true); }
    getDeviceEpochFailure           () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_FAILURE, true); }
    getDeviceEpochMaintain          () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_MAINTAIN, true); }
    getDeviceEpochClear             () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CLEAR, true); }
    getDeviceEpochCallBegin         () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CALL_BEGIN, true); }
    getDeviceEpochCallEnd           () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CALL_END, true); }
    getDeviceEpochCalcBegin         () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CALC_BEGIN, true); }
    getDeviceEpochCalcEnd           () { return this[ kHeaders ].getFloat32(Processor.OFFSET_DEVICE_EPOCH_CALC_END, true); }

    setDeviceEpochLast              ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_LAST, value, true); }    
    setDeviceEpochConstruct         ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CONSTRUCT, value, true); }    
    setDeviceEpochInitBegin         ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_INIT_BEGIN, value, true); }    
    setDeviceEpochInitEnd           ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_INIT_END, value, true); }    
    setDeviceEpochExitBegin         ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_EXIT_BEGIN, value, true); }    
    setDeviceEpochExitEnd           ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_EXIT_END, value, true); }    
    setDeviceEpochFailure           ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_FAILURE, value, true); }    
    setDeviceEpochMaintain          ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_MAINTAIN, value, true); }    
    setDeviceEpochClear             ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CLEAR, value, true); }    
    setDeviceEpochCallBegin         ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CALL_BEGIN, value, true); }    
    setDeviceEpochCallEnd           ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CALL_END, value, true); }    
    setDeviceEpochCalcBegin         ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CALC_BEGIN, value, true); }    
    setDeviceEpochCalcEnd           ( value ) { this[ kHeaders ].setFloat32(Processor.OFFSET_DEVICE_EPOCH_CALC_END, value, true); }    

    renewDeviceEpochConstruct       () { this.setDeviceEpochConstruct(this.renewDeviceEpochLast()) }    
    renewDeviceEpochInitBegin       () { this.setDeviceEpochInitBegin(this.renewDeviceEpochLast()) }    
    renewDeviceEpochInitEnd         () { this.setDeviceEpochInitEnd(this.renewDeviceEpochLast()) }    
    renewDeviceEpochExitBegin       () { this.setDeviceEpochExitBegin(this.renewDeviceEpochLast()) }    
    renewDeviceEpochExitEnd         () { this.setDeviceEpochExitEnd(this.renewDeviceEpochLast()) }    
    renewDeviceEpochFailure         () { this.setDeviceEpochFailure(this.renewDeviceEpochLast()) }    
    renewDeviceEpochMaintain        () { this.setDeviceEpochMaintain(this.renewDeviceEpochLast()) }    
    renewDeviceEpochClear           () { this.setDeviceEpochClear(this.renewDeviceEpochLast()) }    
    renewDeviceEpochCallBegin       () { this.setDeviceEpochCallBegin(this.renewDeviceEpochLast()) }    
    renewDeviceEpochCallEnd         () { this.setDeviceEpochCallEnd(this.renewDeviceEpochLast()) }    
    renewDeviceEpochCalcBegin       () { this.setDeviceEpochCalcBegin(this.renewDeviceEpochLast()) }    
    renewDeviceEpochCalcEnd         () { this.setDeviceEpochCalcEnd(this.renewDeviceEpochLast()) }    

    getDeviceState  () { return this[ kHeaders ].getUint32(Processor.OFFSET_DEVICE_STATE, true); }
    setDeviceState  ( value ) { this[ kHeaders ].setUint32(Processor.OFFSET_DEVICE_STATE, value, true); }

    pnow            () { return performance.now() }

    newPromiseFor   ( type ) {
        const { promise, resolve, reject } = Promise.withResolvers();

        if ( Processor.HANDLE_CALL.is( type ) ) {
            this.renewDeviceEpochCallBegin();
            return {
                promise,
                resolve : ( ...args ) => {
                    this.renewDeviceEpochCallEnd();
                    resolve.apply( promise, args );
                },
                reject  : ( ...args ) => {
                    this.renewDeviceEpochCallEnd();
                    reject.apply( promise, args );
                }
            }
        }

        if ( Processor.HANDLE_CALC.is( type ) ) {
            this.renewDeviceEpochCalcBegin();
            return {
                promise,
                resolve : ( ...args ) => {
                    this.renewDeviceEpochCalcEnd();
                    resolve.apply( promise, args );
                },
                reject  : ( ...args ) => {
                    this.renewDeviceEpochCalcEnd();
                    reject.apply( promise, args );
                }
            }
        }

        if ( Processor.DEVICE_INIT.is( type ) ) {
            this.renewDeviceEpochInitBegin();
            return {
                promise,
                resolve : ( ...args ) => {
                    this.renewDeviceEpochInitEnd();
                    resolve.apply( promise, args );
                },
                reject  : ( ...args ) => {
                    this.renewDeviceEpochInitEnd();
                    reject.apply( promise, args );
                }
            }
        }

        if ( Processor.DEVICE_EXIT.is( type ) ) {
            this.renewDeviceEpochExitBegin();
            return {
                promise,
                resolve : ( ...args ) => {
                    this.renewDeviceEpochExitEnd();
                    resolve.apply( promise, args );
                },
                reject  : ( ...args ) => {
                    this.renewDeviceEpochExitEnd();
                    reject.apply( promise, args );
                }
            }
        }
    }

    renewDeviceEpochLast  () {
        const epoch = this.pnow();
        this.setDeviceEpochLast(epoch);
        return epoch;
    }

    mathof (arrayLike, type ) {
        switch (type) {

            case Processor.MATH_FLOOR: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_FLOOR;
                    
                default: throw `Source data type is not available for floor calc!`;
            }

            case Processor.MATH_CEIL: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_CEIL;
                    
                default: throw `Source data type is not available for ceil calc!`;
            }

            case Processor.MATH_SQRT: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_SQRT;
                    
                default: throw `Source data type is not available for square calc!`;
            }

            case Processor.MATH_LT: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_LT;
                    
                default: throw `Source data type is not available for little then calc!`;
            }

            case Processor.MATH_GT: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_GT;
                    
                default: throw `Source data type is not available for greater then calc!`;
            }

            case Processor.MATH_EQ: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_EQ;
                    
                default: throw `Source data type is not available for equal calc!`;
            }

            case Processor.MATH_NE: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_NE;
                    
                default: throw `Source data type is not available for not equal calc!`;
            }

            case Processor.MATH_LTE: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_LTE;
                    
                default: throw `Source data type is not available for little or equal calc!`;
            }

            case Processor.MATH_GTE: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_GTE;
                    
                default: throw `Source data type is not available for greater or equal calc!`;
            }

            case Processor.MATH_ADD: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_ADD;
                    
                default: throw `Source data type is not available for add calc!`;
            }

            case Processor.MATH_MUL: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_MUL;
                    
                default: throw `Source data type is not available for multiply calc!`;
            }

            case Processor.MATH_DIV: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_DIV;
                    
                default: throw `Source data type is not available for divide calc!`;
            }

            case Processor.MATH_SUB: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_SUB;
                    
                default: throw `Source data type is not available for substract calc!`;
            }

            case Processor.MATH_REM: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_REM;
                    
                default: throw `Source data type is not available for remain calc!`;
            }

            case Processor.MATH_MAX: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_MAX;
                    
                default: throw `Source data type is not available for maximum calc!`;
            }

            case Processor.MATH_MIN: switch (true) {
                case Array.isArray(arrayLike): 
                case arrayLike instanceof Float32Array: 
                    return Processor.F32_MIN;
                    
                default: throw `Source data type is not available for minimum calc!`;
            }
        }

        throw `Math type is not defined: ${type    }`;
    }

    findValueIndexing       (values, source) {
        const i = Processor.lof(values);
        const s = Processor.lof(source);

        switch (i) {
            case 0: return Processor.NO_NEED_VALUE_FOR_METHOD;
            case 1: return Processor.ONE_VALUE_FOR_ALL_SOURCE;
            case s: return Processor.ONE_VALUE_PER_ONE_SOURCE;
        }
    }

    set deviceState ( value ) { this.setDeviceState( value ) }
    get deviceState () { return enumerate.valueOf(this.getDeviceState()) }

    get epoch () { 
        const data = { __proto__: null };
        const item = { __proto__: null };


        data.init           = structuredClone(item);
        data.init.begin     = this.getDeviceEpochInitBegin();
        data.init.end       = this.getDeviceEpochInitEnd();
        data.init.elapsed   = data.init.end - data.init.begin;

        data.exit           = structuredClone(item);
        data.exit.begin     = this.getDeviceEpochExitBegin();
        data.exit.end       = this.getDeviceEpochExitEnd();
        data.exit.elapsed   = data.exit.end - data.exit.begin;

        data.call           = structuredClone(item);
        data.call.begin     = this.getDeviceEpochCallBegin();
        data.call.end       = this.getDeviceEpochCallEnd();
        data.call.elapsed   = data.call.end - data.call.begin;

        data.calc           = structuredClone(item);
        data.calc.begin     = this.getDeviceEpochCalcBegin();
        data.calc.end       = this.getDeviceEpochCalcEnd();
        data.calc.elapsed   = data.calc.end - data.calc.begin;

        data.lastEpoch      = this.getDeviceEpochLast();
        data.aliveTime      = data.exit.end - data.init.begin;

        return data;
    }
};

Object.defineProperty(Processor.prototype, "deviceState", Object.assign(
    Object.getOwnPropertyDescriptor(Processor.prototype, "deviceState"), {
        enumerable: true
    }
));

Object.defineProperty(Processor.prototype, "epoch", Object.assign(
    Object.getOwnPropertyDescriptor(Processor.prototype, "epoch"), {
        enumerable: true
    }
));

Object.defineProperties(Processor.prototype, {
    READY  : { value: enumerate.on(Processor, "READY") },
    CLOSED : { value: enumerate.on(Processor, "CLOSED") },
});

Object.defineProperties(Processor.prototype, {
    HANDLE_CALL : { value: enumerate.on(Processor, "HANDLE_CALL") },
    HANDLE_CALC : { value: enumerate.on(Processor, "HANDLE_CALC") },
    DEVICE_INIT : { value: enumerate.on(Processor, "DEVICE_INIT") },
    DEVICE_EXIT : { value: enumerate.on(Processor, "DEVICE_EXIT") },
});

Object.defineProperties(Processor.prototype, {
    NO_NEED_VALUE_FOR_METHOD : { value: enumerate.on(Processor, "NO_NEED_VALUE_FOR_METHOD") },
    ONE_VALUE_FOR_ALL_SOURCE : { value: enumerate.on(Processor, "ONE_VALUE_FOR_ALL_SOURCE") },
    ONE_VALUE_PER_ONE_SOURCE : { value: enumerate.on(Processor, "ONE_VALUE_PER_ONE_SOURCE") },
});


Object.defineProperties(Processor.prototype, {
    TARGET_FROM_SOURCE_REWRITE : { value: enumerate.on(Processor, "TARGET_FROM_SOURCE_REWRITE") },
    TARGET_FROM_TRUE_PARAMETER : { value: enumerate.on(Processor, "TARGET_FROM_TRUE_PARAMETER") },
});


Object.defineProperties(Processor.prototype, {
    BUFFER : { value: enumerate.on(Processor, "BUFFER") },
    ARRAY_BUFFER : { value: enumerate.on(Processor, "ARRAY_BUFFER") },
    SHARED_ARRAY_BUFFER : { value: enumerate.on(Processor, "SHARED_ARRAY_BUFFER") },
});

Object.defineProperties(Processor.prototype, {
    PRIMITIVE : { value: enumerate.on(Processor, "PRIMITIVE") },
    ARRAY : { value: enumerate.on(Processor, "ARRAY") },
    DATAVIEW : { value: enumerate.on(Processor, "DATAVIEW") },
    TYPED_ARRAY : { value: enumerate.on(Processor, "TYPED_ARRAY") },
});

Object.defineProperties(Processor.prototype, {
    F32_ADD     : { value: enumerate.on(Processor, "F32_ADD") },
    F32_MUL     : { value: enumerate.on(Processor, "F32_MUL") },
    F32_DIV     : { value: enumerate.on(Processor, "F32_DIV") },
    F32_SUB     : { value: enumerate.on(Processor, "F32_SUB") },
    F32_REM     : { value: enumerate.on(Processor, "F32_REM") },
    F32_MAX     : { value: enumerate.on(Processor, "F32_MAX") },
    F32_MIN     : { value: enumerate.on(Processor, "F32_MIN") },
    F32_LT      : { value: enumerate.on(Processor, "F32_LT") },
    F32_LTE     : { value: enumerate.on(Processor, "F32_LTE") },
    F32_GT      : { value: enumerate.on(Processor, "F32_GT") },
    F32_GTE     : { value: enumerate.on(Processor, "F32_GTE") },
    F32_EQ      : { value: enumerate.on(Processor, "F32_EQ") },
    F32_NE      : { value: enumerate.on(Processor, "F32_NE") },
    F32_SQRT    : { value: enumerate.on(Processor, "F32_SQRT") },
    F32_CEIL    : { value: enumerate.on(Processor, "F32_CEIL") },
    F32_FLOOR   : { value: enumerate.on(Processor, "F32_FLOOR") },
});

Object.defineProperties(Processor.prototype, {
    MATH_ADD    : { value: enumerate.on(Processor, "MATH_ADD") },
    MATH_MUL    : { value: enumerate.on(Processor, "MATH_MUL") },
    MATH_DIV    : { value: enumerate.on(Processor, "MATH_DIV") },
    MATH_SUB    : { value: enumerate.on(Processor, "MATH_SUB") },
    MATH_MAX    : { value: enumerate.on(Processor, "MATH_MAX") },
    MATH_MIN    : { value: enumerate.on(Processor, "MATH_MIN") },
    MATH_REM    : { value: enumerate.on(Processor, "MATH_REM") },
    MATH_LT     : { value: enumerate.on(Processor, "MATH_LT") },
    MATH_LTE    : { value: enumerate.on(Processor, "MATH_LTE") },
    MATH_GT     : { value: enumerate.on(Processor, "MATH_GT") },
    MATH_GTE    : { value: enumerate.on(Processor, "MATH_GTE") },
    MATH_EQ     : { value: enumerate.on(Processor, "MATH_EQ") },
    MATH_NE     : { value: enumerate.on(Processor, "MATH_NE") },
    MATH_SQRT   : { value: enumerate.on(Processor, "MATH_SQRT") },
    MATH_CEIL   : { value: enumerate.on(Processor, "MATH_CEIL") },
    MATH_FLOOR  : { value: enumerate.on(Processor, "MATH_FLOOR") },
});

Object.defineProperties(Processor.prototype, {
    GPU_FLOAT16 : { value: enumerate.on(Processor, "GPU_FLOAT16") },
    GPU_FLOAT32 : { value: enumerate.on(Processor, "GPU_FLOAT32") },
    GPU_FLOAT64 : { value: enumerate.on(Processor, "GPU_FLOAT64") },
});

Object.defineProperties(Processor.prototype, {
    CPU_FLOAT16 : { value: enumerate.on(Processor, "CPU_FLOAT16") },
    CPU_FLOAT32 : { value: enumerate.on(Processor, "CPU_FLOAT32") },
    CPU_FLOAT64 : { value: enumerate.on(Processor, "CPU_FLOAT64") },
});

Object.defineProperties(Processor.prototype, {
    NPU_FLOAT16 : { value: enumerate.on(Processor, "NPU_FLOAT16") },
    NPU_FLOAT32 : { value: enumerate.on(Processor, "NPU_FLOAT32") },
    NPU_FLOAT64 : { value: enumerate.on(Processor, "NPU_FLOAT64") },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_ADD), {
    type                : { value: Processor.MATH_ADD },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    simdAvailable       : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_MUL), {
    type                : { value: Processor.MATH_MUL },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    simdAvailable       : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_DIV), {
    type                : { value: Processor.MATH_DIV },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    simdAvailable       : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_SUB), {
    type                : { value: Processor.MATH_SUB },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    simdAvailable       : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_REM), {
    type                : { value: Processor.MATH_REM },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_MAX), {
    type                : { value: Processor.MATH_MAX },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_MIN), {
    type                : { value: Processor.MATH_MIN },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_LT), {
    type                : { value: Processor.MATH_LT },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_LTE), {
    type                : { value: Processor.MATH_LTE },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_GT), {
    type                : { value: Processor.MATH_GT },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_GTE), {
    type                : { value: Processor.MATH_GTE },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_NE), {
    type                : { value: Processor.MATH_NE },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_EQ), {
    type                : { value: Processor.MATH_EQ },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: true },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});


Object.defineProperties(Object.getPrototypeOf(Processor.F32_SQRT), {
    type                : { value: Processor.MATH_SQRT },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: false },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});


Object.defineProperties(Object.getPrototypeOf(Processor.F32_CEIL), {
    type                : { value: Processor.MATH_CEIL },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: false },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.F32_FLOOR), {
    type                : { value: Processor.MATH_FLOOR },
    TypedArray          : { value: Float32Array },
    BYTES_PER_ELEMENT   : { value: Float32Array.BYTES_PER_ELEMENT },
    needsOperand        : { value: false },
    gpuDataType         : { value: Processor.GPU_FLOAT32 },
    npuDataType         : { value: Processor.NPU_FLOAT32 },
    cpuDataType         : { value: Processor.CPU_FLOAT32 },
});

Object.defineProperties(Object.getPrototypeOf(Processor.MATH_ADD),   {operand : { value: "+" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_MUL),   {operand : { value: "*" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_DIV),   {operand : { value: "/" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_SUB),   {operand : { value: "-" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_REM),   {operand : { value: "%" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_MAX),   {funcName : { value: "max" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_MIN),   {funcName : { value: "min" }});
 
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_LT),    {operand : { value: "<" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_LTE),   {operand : { value: "<=" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_GT),    {operand : { value: ">" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_GTE),   {operand : { value: ">=" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_EQ),    {operand : { value: "==" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_NE),    {operand : { value: "!=" }});
 
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_SQRT),  {funcName : { value: "sqrt" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_CEIL),  {funcName : { value: "ceil" }});
Object.defineProperties(Object.getPrototypeOf(Processor.MATH_FLOOR), {funcName : { value: "floor" }});










