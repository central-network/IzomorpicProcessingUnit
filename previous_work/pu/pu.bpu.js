export default async function () {
    const bpu = Object.setPrototypeOf({

        maxBufferSize : 4096 * 1e3,

        calc ( func, value, input, output = input ) 
        {
            let i = Math.min( output.length, input.length );

            switch ( func ) {
                case "add": while (i--) { output[i] = input[i] + value; }; break;
                case "mul": while (i--) { output[i] = input[i] * value; }; break;
                case "sub": while (i--) { output[i] = input[i] - value; }; break;
                case "div": while (i--) { output[i] = input[i] / value; }; break;
            }

            return new Promise(resolve => resolve(output));
        },
    
        f32_add ( value, input, output ) { return this.calc( "add", value, input, output )},
        f32_mul ( value, input, output ) { return this.calc( "mul", value, input, output )},
        f32_sub ( value, input, output ) { return this.calc( "sub", value, input, output )},
        f32_div ( value, input, output ) { return this.calc( "div", value, input, output )},
    
    }, class bPU {}.prototype )
        
    return bpu;
}

