import Processor from "./Processor.js";

/**
 * regular cpu operator manager which uses native loops
 * to reach results
 */
export default class CPUv0 extends Processor {

    hasQueue        = false
    hasMemory       = false
    simdReady       = false
    needsClone      = false
    needsMalloc     = false
    needsAligned    = false
    needsTypedArray = false
    maxCalcLength   = +Infinity

    init () {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.DEVICE_INIT );
        
        try {
            this.deviceState = this.READY;
            this.emit("ready", this);
            resolve(this);
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    exit () {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.DEVICE_EXIT );
        
        try {
            this.deviceState = this.CLOSED;
            this.emit("closed", this);
            resolve(this);
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    handleDataset (dataset, operator) {
        const isArray       = Array.isArray(dataset); 
        const isTypedArray  = ArrayBuffer.isView(dataset);

        if (!isArray && !isTypedArray) {
            throw `Dataset is not an array!`;
        }

        if (this.needsClone) {
            if (isTypedArray && dataset.buffer === this.memory.buffer) {
                return dataset;
            }

            const length        = dataset.length;
            const byteLength    = length * operator.BYTES_PER_ELEMENT;
            const byteOffset    = this.memory.malloc( byteLength );
            const view          = new operator.TypedArray(
                this.memory.buffer, byteOffset, length
            );

            view.set(dataset);

            return view;
        }

        if (isTypedArray) {
            return dataset; 
        }

        return operator.TypedArray.from(dataset);
    }

    prepareInput (source, operator) {
        return this.handleDataset(source, operator)
    }

    prepareOperand (values, operator) {
        if (typeof values === "number") {
            return this.handleDataset(
                operator.TypedArray.of(values), 
                operator
            )
        }
        
        if (typeof values === "undefined") {
            if (false === operator.needsOperand) {
                return operator.TypedArray.of();
            }

            throw `Operator needs operand but values has no content!`
        }

        return values;
    }

    prepareOutput (target, source, input, operator) {

        if (target === true) {
            if (source.buffer) {
                if (source.buffer === this.memory.buffer) {
                    const length        = source.length;
                    const byteLength    = length * operator.BYTES_PER_ELEMENT;
                    const byteOffset    = this.memory.malloc( byteLength );
                    const view          = new operator.TypedArray(
                        this.memory.buffer, byteOffset, length
                    );
    
                    return view;
                }
                return new operator.TypedArray(source.length);
            }
        }

        if (typeof target === "undefined") {
            return input;
        }

        return target;
    }

    static lof ( data ) {
        if (!data) { return 0; }
        return Uint32Array.of(data.length).at();
    }

    import ( data, operator, source ) {
        if (!data) {
            return source ?? operator.TypedArray.of();
        }
        
        if (data === true) {
            return new operator.TypedArray( source.length );
        }
                
        if (typeof data === "number") {
            return operator.TypedArray.of(data);
        }
        
        if (data instanceof operator.TypedArray) {
            return data;
        }
    }

    export (args, target) {
        const rconf = args.at(1);
        const [
            isTargetOutput,
            isTargetInput,
            isTargetTrue,
            isSourceInput,
            isSourceTarget
        ] = rconf;

        return target
    }

    #args (type, source, values, target) {
        const math = this.mathof( source, type );
        const input = this.import( source, math );
        const output = this.import( target, math, input );
        const uniform = this.import( values, math );

        const { buffer:iBuffer, byteOffset: iOffset, length: iLength } = input;
        const { buffer:oBuffer, byteOffset: oOffset } = output;
        const { buffer:uBuffer, byteOffset: uOffset, length: uLength } = uniform;

        const rconf = [
            target === output, 
            target === input,
            target === true, 
            source === input,
            source === target,
        ];

        return Array.of( math, rconf, iLength, uLength, iBuffer, iOffset, oBuffer, oOffset, uBuffer, uOffset );
    }

    #calc (math, rconf, iLength, uLength, iBuffer, iOffset, oBuffer, oOffset, uBuffer, uOffset) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALC );

        const input   = new math.TypedArray(iBuffer, iOffset, iLength); 
        const output  = new math.TypedArray(oBuffer, oOffset, iLength); 
        const uniform = new math.TypedArray(uBuffer, uOffset, uLength); 

        try 
        {
            switch ( uLength ) 
            {
                case 0:
                    switch ( math.type ) 
                    {
                        case Processor.MATH_SQRT : while(iLength--) output[iLength] = Math.sqrt(input[iLength]);  break;
                        case Processor.MATH_CEIL : while(iLength--) output[iLength] = Math.ceil(input[iLength]);  break;
                        case Processor.MATH_FLOOR: while(iLength--) output[iLength] = Math.floor(input[iLength]); break;
                    }
                    resolve();
                break;
    
                case 1:
                    const [v] = uniform;
                    switch ( math.type ) 
                    {
                        case Processor.MATH_ADD: while(iLength--) output[iLength] = input[iLength]  + v; break;
                        case Processor.MATH_MUL: while(iLength--) output[iLength] = input[iLength]  * v; break;
                        case Processor.MATH_DIV: while(iLength--) output[iLength] = input[iLength]  / v; break;
                        case Processor.MATH_SUB: while(iLength--) output[iLength] = input[iLength]  - v; break;
                        case Processor.MATH_REM: while(iLength--) output[iLength] = input[iLength]  % v; break;
                        case Processor.MATH_LT:  while(iLength--) output[iLength] = input[iLength]  < v; break;
                        case Processor.MATH_GT:  while(iLength--) output[iLength] = input[iLength]  > v; break;
                        case Processor.MATH_EQ:  while(iLength--) output[iLength] = input[iLength] == v; break;
                        case Processor.MATH_NE:  while(iLength--) output[iLength] = input[iLength] != v; break;
                        case Processor.MATH_LTE: while(iLength--) output[iLength] = input[iLength] <= v; break;
                        case Processor.MATH_GTE: while(iLength--) output[iLength] = input[iLength] >= v; break;
                        case Processor.MATH_MAX: while(iLength--) output[iLength] = Math.max(input[iLength], v); break;
                        case Processor.MATH_MIN: while(iLength--) output[iLength] = Math.min(input[iLength], v); break;
                    }
                    resolve();
                break;
    
                case iLength:
                    switch ( math.type ) 
                    {
                        case Processor.MATH_ADD: while(iLength--) output[iLength] = input[iLength]  + uniform[iLength]; break;
                        case Processor.MATH_MUL: while(iLength--) output[iLength] = input[iLength]  * uniform[iLength]; break;
                        case Processor.MATH_DIV: while(iLength--) output[iLength] = input[iLength]  / uniform[iLength]; break;
                        case Processor.MATH_SUB: while(iLength--) output[iLength] = input[iLength]  - uniform[iLength]; break;
                        case Processor.MATH_REM: while(iLength--) output[iLength] = input[iLength]  % uniform[iLength]; break;
                        case Processor.MATH_LT:  while(iLength--) output[iLength] = input[iLength]  < uniform[iLength]; break;
                        case Processor.MATH_GT:  while(iLength--) output[iLength] = input[iLength]  > uniform[iLength]; break;
                        case Processor.MATH_EQ:  while(iLength--) output[iLength] = input[iLength] == uniform[iLength]; break;
                        case Processor.MATH_NE:  while(iLength--) output[iLength] = input[iLength] != uniform[iLength]; break;
                        case Processor.MATH_LTE: while(iLength--) output[iLength] = input[iLength] <= uniform[iLength]; break;
                        case Processor.MATH_GTE: while(iLength--) output[iLength] = input[iLength] >= uniform[iLength]; break;
                        case Processor.MATH_MAX: while(iLength--) output[iLength] = Math.max(input[iLength], uniform[iLength]); break;
                        case Processor.MATH_MIN: while(iLength--) output[iLength] = Math.min(input[iLength], uniform[iLength]); break;
                    }
                    resolve();
                break;

                default:
                    reject(new RangeError(`Lengths are NOT calculateable!`));
                break;
            }
        }
        catch (e) { reject(e); }

        return promise;
    }

    add (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_ADD, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    mul (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_MUL, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    div (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_DIV, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    sub (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_SUB, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    rem (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_REM, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    max (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_MAX, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    min (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_MIN, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    lte (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_MAX, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    gte (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_GTE, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    lt (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_LT, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    gt (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_GT, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }
    
    eq (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_EQ, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    ne (source, values, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_NE, source, values, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }

    sqrt (source, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_SQRT, source, undefined, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    ceil (source, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_CEIL, source, undefined, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    floor (source, target) {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.HANDLE_CALL );

        try {
            const args = this.#args(
                Processor.MATH_FLOOR, source, undefined, target
            );

            this.#calc.apply(this, args)
                .then(() => this.export(args, target))
                .then(() => resolve(target))
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }

        return promise;
    }
}