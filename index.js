WebAssembly.instantiateStreaming(fetch("cpu.wasm"), self).then(async wasm => {
    self.cpu = wasm.instance.exports;
    console.error({ cpu });

    let test_length = 40000000;

    const source = cpu.new(Float32Array, test_length);
    const values = cpu.new(Float32Array, test_length);
    const target = cpu.new(Float32Array, test_length);

    while (test_length--) {
        source[test_length] = Math.random()
        values[test_length] = 100 * Math.random()
    }

    console.table([
        { view: source, offset: source.byteOffset, length: source.length, buffer: source.buffer },
        { view: values, offset: values.byteOffset, length: values.length, buffer: values.buffer },
        { view: target, offset: target.byteOffset, length: target.length, buffer: target.buffer },
    ]);

    self.makeTest = async () => {
        cpu.add(source, values, target).then(() => {
            console.warn(target);
        })
    };

    makeTest();

    console.warn(cpu.dump());
});