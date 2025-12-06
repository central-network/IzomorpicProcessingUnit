export default async function () {
    if (  navigator.gpu  )
    {
        const computeShader = String(`
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
            @group(0) @binding(1) var<uniform>               value: f32;
            @group(0) @binding(2) var<storage, read>         input: array<f32>;
            @group(0) @binding(3) var<storage, read_write>  output: array<f32>;
        
            @compute  @workgroup_size( wsize ) 
            fn f32_add ( @builtin ( global_invocation_id) id : vec3u ) {
                output[id.x + id.y] = f32(id.x + id.y);
            }
                
            @compute  @workgroup_size( wsize ) 
            fn f32_mul ( @builtin ( global_invocation_id) id : vec3u ) {
                if ( id.x < index ) { output[id.x] = input[id.x] * value; }
            }
        
            @compute  @workgroup_size( wsize ) 
            fn f32_sub ( @builtin ( global_invocation_id) id : vec3u ) {
                if ( id.x < index ) { output[id.x] = input[id.x] - value; }
            }
        
            @compute  @workgroup_size( wsize ) 
            fn f32_div ( @builtin ( global_invocation_id) id : vec3u ) {
                if ( id.x < index ) { output[id.x] = input[id.x] / value; }
            }
        `);
        
        let pipeline = {},
            device, deviceQueue, bindGroup, workgroupSize, bindingSize, invocations,
            stagingBuffer, inputBuffer, outputBuffer, valueBuffer, indexBuffer;
        
        const gpu = Object.setPrototypeOf({
            maxBufferSize : 0,
            calc ( func, value, input, output = input ) {
        
                const { promise, resolve } = Promise.withResolvers();
                const commandEncoder       = device.createCommandEncoder();
                const passEncoder          = commandEncoder.beginComputePass();

                deviceQueue.writeBuffer(indexBuffer, 0, Uint32Array.of(input.length));
                deviceQueue.writeBuffer(valueBuffer, 0, value);
                deviceQueue.writeBuffer(inputBuffer, 0, input);
                passEncoder.setPipeline(pipeline[func]);
                passEncoder.setBindGroup(0, bindGroup);

                passEncoder.dispatchWorkgroups( workgroupSize, invocations );
            
                passEncoder.end();
                commandEncoder.copyBufferToBuffer(outputBuffer, 0, stagingBuffer, 0, output.byteLength);
                deviceQueue.submit([commandEncoder.finish()]);
            
                stagingBuffer.mapAsync(GPUMapMode.READ, 0, output.byteLength)
                    .then(() => stagingBuffer.getMappedRange(0, output.byteLength))
                    .then(result => output.set(new output.constructor(result)))
                    .then(() => stagingBuffer.unmap())
                    .then(() => resolve(output))
                .catch(console.error);
            
                return promise;
            },
        
            f32_add ( value, input, output ) { return this.calc( "f32_add", Float32Array.of(value), input, output )},
            f32_mul ( value, input, output ) { return this.calc( "f32_mul", Float32Array.of(value), input, output )},
            f32_sub ( value, input, output ) { return this.calc( "f32_sub", Float32Array.of(value), input, output )},
            f32_div ( value, input, output ) { return this.calc( "f32_div", Float32Array.of(value), input, output )},
        
        }, class gPU {}.prototype )
            
        return navigator.gpu
            .requestAdapter({ powerPreference: "high-performance" })
            .then(adapter => adapter.requestDevice())
            .then($device => {
        
                device        = $device
                deviceQueue   = $device.queue;
                bindingSize   = $device.limits.maxStorageBufferBindingSize;
                workgroupSize = $device.limits.maxComputeWorkgroupsPerDimension;
                invocations   = $device.limits.maxComputeInvocationsPerWorkgroup
                    
                indexBuffer   = device.createBuffer({ size : 256, usage : GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
                valueBuffer   = device.createBuffer({ size : 256, usage : GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST }),
                inputBuffer   = device.createBuffer({ size : bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_DST }),
                outputBuffer  = device.createBuffer({ size : bindingSize, usage : GPUBufferUsage.STORAGE  | GPUBufferUsage.COPY_SRC }),
                stagingBuffer = device.createBuffer({ size : bindingSize, usage : GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST });
        
                const bindLayout = device.createBindGroupLayout({
                    label: "gpubg",
                    entries: [
                        { label: "index",  binding : 0, visibility : GPUShaderStage.COMPUTE, buffer : { type: "uniform" } },
                        { label: "value",  binding : 1, visibility : GPUShaderStage.COMPUTE, buffer : { type: "uniform" } },
                        { label: "input",  binding : 2, visibility : GPUShaderStage.COMPUTE, buffer : { type: "read-only-storage" } },
                        { label: "output", binding : 3, visibility : GPUShaderStage.COMPUTE, buffer : { type: "storage" } },
                    ]
                });
        
                bindGroup  = device.createBindGroup({
                    layout  : bindLayout, 
                    entries : [
                        { label: "index",  binding : 0, resource : { buffer: indexBuffer } },
                        { label: "value",  binding : 1, resource : { buffer: valueBuffer } },
                        { label: "input",  binding : 2, resource : { buffer: inputBuffer } },
                        { label: "output", binding : 3, resource : { buffer: outputBuffer } },
                    ]
                });
        
                const module = device.createShaderModule({ code: computeShader });
                const layout = device.createPipelineLayout({ bindGroupLayouts : [ bindLayout ] });
        
                pipeline.f32_add = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_add" }});
                pipeline.f32_mul = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_mul" }});
                pipeline.f32_sub = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_sub" }});
                pipeline.f32_div = device.createComputePipeline({ layout, compute : { module, entryPoint : "f32_div" }});
                
                gpu.maxBufferSize = workgroupSize * invocations;

                return gpu
            })
        .catch(() => Object({ maxBufferSize: 0 }));
    }
    else { return { maxBufferSize: 0 } }
}

