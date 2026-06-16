# 32-bit Pipelined RISC-V Processor

This repository contains a 32-bit RISC-V processor based on a 5-stage pipeline architecture (IF, ID, EX, MEM, WB), designed and implemented from scratch in Verilog. 

## Architectural Features
* **5-Stage Pipeline:** Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).
* **Advanced Hazard Handling:** * `Forwarding Unit`: Resolves data hazards by bypassing data directly to the ALU, minimizing pipeline stalls.
  * `Hazard Detection Unit`: Injects NOPs (Stall) to handle Load-Use data hazards and Flushes the pipeline to resolve control hazards (branches and jumps).
* **Harvard Architecture:** Separate instruction and data memories.
* **Supported Instruction Set:** * **R-Type:** `add`, `sub`, `and`, `or`, `xor`, `slt`
  * **I-Type:** `addi`, `lw`, `jalr`
  * **S-Type:** `sw`
  * **B-Type:** `beq`, `bge`, `blt`
  * **J-Type:** `jal`

## Test Program & Validation
The processor's functionality is validated using a custom Assembly program that was manually assembled into machine code. The test program calculates the sum of an array's elements using a `for` loop and a function call (`jal`/`jalr`). This effectively tests both data hazard forwarding and control hazard flushing mechanisms under real workload conditions.

## Project Structure
* `src/` - Verilog source files (Datapath, Controlpath, ALU, Registers, Forwarding Unit, etc.)
* `sim/` - Testbench (`tb.v`) and memory initialization file (`memory_data.mem`).
* `docs/` - Pipeline register map, system diagrams, and simulation waveforms.

## How to Run the Simulation (Vivado / ModelSim)
1. Import all `.v` files from the `src/` and `sim/` directories into your simulation tool.
2. Ensure `memory_data.mem` is placed in the correct working directory for the simulator to load it.
3. Set `tb.v` as the top module for the simulation.
4. Run the simulation for approximately `2000ns`.
5. Observe the signals in the `DataMemory` module. The final sum calculated by the program will be written to address `0x60` (decimal `96`).
