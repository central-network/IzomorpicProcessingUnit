import Processor from "./Processor.js";

export default class CPUv1 extends Processor {

    concurrency = 4

    init () {
        const { promise, resolve, reject } = this.newPromiseFor( Processor.DEVICE_INIT );
        
        try {
            this.fork()
                .then(() => {
                    this.deviceState = this.READY;
                    this.emit("ready", this);
                    resolve(this);
                })
            .catch(error => reject(error));
        }
        catch (e) { reject(e) }
        
        return promise;
    }

    get workerURL () {
        const workerScript = () => {
            console.log(self);
            postMessage(1);
        };

        const url = URL.createObjectURL(new Blob([
            `(${workerScript})()`,
        ]));

        Object.defineProperty(
            this, "workerURL", { value: url }
        );

        return url;
    }

    workers = []

    onworkerfail (e) {
        console.log("error:", e)
    }

    fork (count = this.concurrency) {
        const {promise, resolve, reject} = Promise.withResolvers();
        
        let i = count;
        while (i--) 
        {
            try {
                const worker = new Worker(this.workerURL);
    
                worker.addEventListener("message", e => {
                    if (this.workers.push(e.target) === count) { resolve();}
                    e.target.onerror = this.onworkerfail.bind(this, e.target);
                }, {once: true});

                worker.onerror = e => reject(e);
            }
            catch (e) { reject(e) }
        }

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

}