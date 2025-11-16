class Enum extends Number {}


Object.defineProperty(Enum.prototype, "toString", {value: function (){ return this.constructor.name }})     
Object.defineProperty(Enum.prototype, "valueOf", {value: function (){ return this.constructor.value }})     
Object.defineProperty(Enum.prototype, Symbol.toPrimitive, {value: function (hint){
    return (hint === "number") && this.valueOf() || this.toString();
}});

const enums = new Map()
const caches = new Array();

function enumerate ( name = `UNDEFINED`, value, cache = enums ) {
    if (cache instanceof Map) {
        if (cache.has(name)) { return cache.get(name) };
        if (cache.has(value)) {
            const ref = cache.get(value);
            
            if (ref.toString() === name) {
                return ref;
            }
    
            throw new ReferenceError(
                `Enum value of ${value} used for ${ref} {${value}}`
            );
        };
    }

    if (typeof value !== "number") {
        if (typeof enumerate.iterate === "number") {
            value = enumerate.iterate++;
        }
        else {
            value = Array
                .from(`${name}`)
                .map((c,i) => c.charCodeAt()*++i)
                .reduce((v,p) => v+p, 0)
            ;   
        }
    }
    
    const object = new class extends Enum {} (value);
    const prototype = Object.getPrototypeOf(object);
    const constructor = Reflect.get(object, "constructor");

    Object.defineProperty(constructor, "value", {value: value});     
    Object.defineProperty(constructor, "name", {value: name});     
    Object.defineProperty(prototype, Symbol.toStringTag, {value: name });     

    if (cache instanceof Map) {
        cache.set(value, object);
        cache.set(name, object);
        cache.set(object, object);

        if (caches.includes(cache) === false) {
            caches.push(cache);
        }
    }

    return object;
}

const definitions = {
    is : { value : function ( value ) { return value - this === 0; } },
    not : { value : function ( value ) { return value - this !== 0; } },
    nice : { value : function () { return enumerate.valueOf( this ); } }
};

Object.defineProperties(Number.prototype, definitions);
Object.defineProperties(BigInt.prototype, definitions);

Object.defineProperty(enumerate, "iterate",  { value: false, writable: true });
Object.defineProperty(enumerate, "valueOf",  { value: function ( any ) {
    return caches.find(cache => cache.has(any))?.get(any)
} });

Object.defineProperty(enumerate, "on", { value: function ( constructor, name, value) {
    const cache = new Map();
    const nenum = enumerate(name, value, cache);

    Object.defineProperty(constructor, name, { value: nenum });
    Object.defineProperty(constructor.prototype, name, { value: nenum });
    
    if (Reflect.has(constructor, "enum") === false) {
        Object.defineProperty(constructor, "enum", { value: Map.prototype.get.bind(cache) });
    }

    return nenum;
} });

export default enumerate;