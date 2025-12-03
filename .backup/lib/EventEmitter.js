export default class EventEmitter extends EventTarget {

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
