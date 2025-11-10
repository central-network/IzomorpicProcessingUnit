const fs = require("fs");
const cp = require("child_process");

try {
    cp.execSync(`wat2wasm simd.wat --enable-threads`);

    const wasm = fs.readFileSync(`simd.wasm`).toString("hex");
    const code = fs.readFileSync(`index.js`).toString()
        .replace(/(static wasm\s+= Uint8Array\.from\(\s+)"(.*?)"/, `$1"${wasm}"`);
    
    fs.writeFileSync(`index.js`, code);
    fs.unlinkSync(`simd.wasm`);

} catch {}
