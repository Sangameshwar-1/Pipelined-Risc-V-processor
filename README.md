
#  5-Stage Pipelined RISC-V Processor with 2-Bit Branch Predictor
 
A 64-bit Verilog implementation of a **5-stage pipelined RISC-V processor**, built by extending a sequential datapath into a fully pipelined architecture with hazard handling and branch prediction.
 
---
##  Simulation
 
### Run (Icarus Verilog)
 
```bash
iverilog pipe_tb.v
vvp a.out
```
 
### View Waveforms
 
```bash
gtkwave dump.vcd
```
 
---
 
##  Output Files
 
- `register-file.txt` → final register values
- `dump.vcd` → waveform
- Console logs → execution trace
---
 

##  Overview
 
This project implements a **classic 5-stage RISC-V pipeline**:
 
- **IF** – Instruction Fetch  
- **ID** – Instruction Decode  
- **EX** – Execute  
- **MEM** – Memory Access  
- **WB** – Write Back  
To ensure correctness and performance, the processor includes:
 
- Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB)
- Data forwarding unit
- Hazard detection unit
- Early branch resolution (ID stage)
- Branch comparator forwarding
- 2-bit branch predictor (BHT)
- Halt mechanism
---
 
## Supported Instructions (RV64I Subset)
 
### R-Type
- `ADD`, `SUB`, `AND`, `OR`, `XOR`
### I-Type
- `ADDI`, `LD`
### S-Type
- `SD`
### B-Type
- `BEQ`
---
 
## ⚙️ Key Features
 
###  1. Pipelining
- 5-stage pipeline enables **parallel execution of instructions**
- Improves throughput compared to sequential design
---
 
###  2. Data Forwarding
Resolves data hazards without stalling:
 
- MEM → EX forwarding
- WB → EX forwarding
---
 
###  3. Load-Use Hazard Detection
When forwarding is not enough:
 
```asm
ld  x9, 0(x0)
add x12, x9, x3
```
 
Solution:
 
- Insert **1-cycle stall**
- Freeze PC and IF/ID
- Flush ID/EX (insert bubble)
---
 
###  4. Branch Handling (Optimized)
 
- Branch resolved in **ID stage** (faster than EX)
- Incorrect instruction is **flushed**
- Only **1-cycle penalty**
---
 
### 🔮 5. 2-Bit Branch Predictor
 
- 16-entry Branch History Table (BHT)
- Indexed using `PC[5:2]`
| State | Meaning            | Prediction |
| ----- | ------------------ | ---------- |
| 00    | Strongly Not Taken | Not Taken  |
| 01    | Weakly Not Taken   | Not Taken  |
| 10    | Weakly Taken       | Taken      |
| 11    | Strongly Taken     | Taken      |
 
---
 
##  Architecture Breakdown
 
###  IF – Instruction Fetch
 
- Fetch instruction from memory
- Compute `PC + 4`
- Choose next PC (branch, stall, prediction)
###  ID – Instruction Decode
 
- Decode instruction
- Read registers
- Generate immediate
- Detect hazards
- Resolve branch
###  EX – Execute
 
- ALU operations
- Uses forwarded data if required
###  MEM – Memory Access
 
- Load/store operations
###  WB – Write Back
 
- Write result to register file
---
 
## Project Structure
 
```
.
├── add.v
├── sub.v
├── and.v
├── or.v
├── xor.v
├── alu.v
├── alu_control.v
├── pc.v
├── pc_add.v
├── instruction_mem.v
├── data_mem.v
├── register_file.v
├── control_unit.v
├── imm_gen.v
├── if_id.v
├── id_ex.v
├── ex_mem.v
├── mem_wb.v
├── forwarding_unit.v
├── hazard_detection_unit.v
├── branch_predictor.v
├── seq_processor.v
└── pipe_tb.v
```
 
---
 
##  Test Program
 
Example instructions used for validation:
 
```asm
addi x2, x0, 5
addi x3, x0, 10
add  x1, x2, x3
sub  x2, x2, x3
and  x4, x3, x3
and  x5, x3, x4
or   x6, x2, x4
or   x7, x2, x3
sd   x1, 0(x5)
ld   x10, 0(x5)
sd   x6, 24(x5)
ld   x11, 24(x5)
beq  x4, x5, +8
add  x13, x1, x10
```
 
 Followed by **4 NOPs** to flush pipeline
 
---
 
##  Expected Output
 
| Register | Value |
| -------- | ----- |
| x1       | 15    |
| x2       | -5    |
| x3       | 10    |
| x10      | 15    |
| x11      | -5    |
| x13      | 30    |
 
Instruction count = **20**
 
- 15 instructions
- 4 NOPs
- 1 flushed instruction
---
 
 
##  Design Highlights
 
- MEM forwarding has higher priority than WB
- Register file uses **internal forwarding**
- Branch resolved early (ID stage)
- Pipeline uses **flush + stall coordination**
- Halt triggered by `0x00000000`
---
 
##  Team
 
**Team Avengers – Team 19**
 
- A. Harsha Vardhan
- S. V. Santhosh
- S. Sangameshwar
---
 
## Learning Outcomes
 
This project provides hands-on experience with:
 
- Processor pipeline design
- Hazard handling (data + control)
- Forwarding logic
- Branch prediction
- Verilog-based CPU implementation
- Simulation & verification
---
 
## 📚 References
 
- RISC-V ISA Specification
- Computer Organization & Design (Patterson & Hennessy)
- Project documentation (IPA Pipeline Project)
---
