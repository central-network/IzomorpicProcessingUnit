require("child_process")
    .exec(`wat2wasm simd.wat --enable-threads`)
    .stderr.on("data", e => {throw e})
;

const wasm = require("fs").readFileSync(`simd.wasm`).toString("hex");
const code = require("fs").readFileSync(`index.js`).toString();

require("fs").writeFileSync(`index.js`, 
    code.replace(/(static wasm = (.*)\(\s+)"(.*?)"/, `$1"${wasm}"`)
);
