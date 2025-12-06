export default async function () {
    if (  navigator.ml  )
    {
        let context;
        const npu = Object.setPrototypeOf({
            maxBufferSize : 2048 * 2048,
            calc ( dataType, func, uniform, source, target = source ) 
            {
                const { promise, resolve }  = Promise.withResolvers();
                const builder               = new MLGraphBuilder( context );

                builder.build({ 
                        input : builder[ func ](
                            builder.input( 'output', { dataType, shape: [ source.length ] }),
                            builder.input( 'value',  { dataType, shape: [ uniform.length ] }),
                        ) 
                    })
                    .then( graph => 
                        Promise.all([
                            context.createTensor({ dataType, shape: [source.length], readable: true }),
                            context.createTensor({ dataType, shape: [target.length], writable: true }),
                            context.createTensor({ dataType, shape: [uniform.length], writable: true }),
                            graph
                        ])
                    )
                    .then(([ input, output, value, graph ]) => {
                        context.writeTensor( output, source );
                        context.writeTensor( value, uniform );
                        context.dispatch( graph, { output, value }, { input });

                        return graph.destroy(), context.readTensor( input );
                    })
                    .then( result => target.set( new target.constructor( result ) ))
                    .then( () => resolve( target ) )
                ;

                return promise
            },
        
            f32_add ( value, input, output ) { return this.calc( "float32", "add", Float32Array.of(value), input, output )},
            f32_mul ( value, input, output ) { return this.calc( "float32", "mul", Float32Array.of(value), input, output )},
            f32_sub ( value, input, output ) { return this.calc( "float32", "sub", Float32Array.of(value), input, output )},
            f32_div ( value, input, output ) { return this.calc( "float32", "div", Float32Array.of(value), input, output )},
        
        }, class nPU {}.prototype )
            
        return navigator.ml
            .createContext({ deviceType: "npu", powerPreference: "low-power" })
            .then(ctx  => { return context = ctx, npu; })
        .catch(() => Object({ maxBufferSize: 0 }));
    }
    else { return { maxBufferSize: 0 } }
}

