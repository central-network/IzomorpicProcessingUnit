
class ComputeChain {
    constructor() {
        this.tasks = [];
        this.compiled = false;
    }

    // Helper to create a task object
    _addTask(opcode, args) {
        if (this.compiled) throw new Error("Chain is already compiled. Cannot add more tasks.");
        this.tasks.push({ opcode, args });
        return this; // Enable chaining
    }

    // Operations
    copy(source, target) {
        return this._addTask('COPY', [source, target]);
    }

    mul(source1, source2, target) {
        return this._addTask('MUL', [source1, source2, target]);
    }

    add(source1, source2, target) {
        return this._addTask('ADD', [source1, source2, target]);
    }

    // Compile: Converts the high-level tasks into a "Command Buffer" simulation
    compile() {
        console.log("--- Compiling Chain ---");

        // Simulation of memory allocation and linking
        this.commandBuffer = this.tasks.map((task, index) => {
            const nextTaskIndex = index < this.tasks.length - 1 ? index + 1 : -1;

            // In a real WASM implementation, these would be memory addresses
            return {
                id: index,
                op: task.opcode,
                inputs: task.args.slice(0, -1), // All but last are inputs
                output: task.args[task.args.length - 1], // Last is output
                next: nextTaskIndex
            };
        });

        this.compiled = true;
        console.log("Compiled Command Buffer:", JSON.stringify(this.commandBuffer, null, 2));
        return this;
    }

    // Run: Executes the command buffer
    run() {
        if (!this.compiled) throw new Error("Chain must be compiled before running.");
        console.log("--- Running Chain ---");

        let currentTaskIndex = 0;
        while (currentTaskIndex !== -1) {
            const task = this.commandBuffer[currentTaskIndex];
            this._executeTask(task);
            currentTaskIndex = task.next;
        }
        console.log("--- Chain Execution Complete ---");
    }

    _executeTask(task) {
        // Simulation of execution logic
        console.log(`[EXEC] Task ${task.id}: ${task.op}`);
        console.log(`       Inputs: ${task.inputs.join(', ')}`);
        console.log(`       Output: ${task.output}`);
        // In reality, this would trigger WASM/GPU compute
    }
}

// --- Usage Example (User's Request) ---

// Mock Data References (simulating pointers or TypedArrays)
const sourcePositionX = "ptr_src_pos_x";
const renderPositionX = "ptr_render_pos_x";
const scaleX = "ptr_scale_x";
const rotationX = "ptr_rot_x";
const locationX = "ptr_loc_x";

const chain = new ComputeChain();

console.log("1. Building Chain...");
chain.copy(sourcePositionX, renderPositionX);
chain.mul(renderPositionX, scaleX, renderPositionX);
chain.mul(renderPositionX, rotationX, renderPositionX);
chain.add(renderPositionX, locationX, renderPositionX);

console.log("2. Compiling...");
chain.compile();

console.log("3. Running...");
chain.run();
