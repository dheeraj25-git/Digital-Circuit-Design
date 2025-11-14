# 4-bit Combinational ALU (8 Operations)

**Modular Verilog ALU** with 8 arithmetic/logical operations on 4-bit inputs — fully combinational, synthesis-ready.

---

## Features

- **Inputs**: `A[3:0]`, `B[3:0]` (unsigned)  
- **Output**: `result[7:0]` (8-bit to support overflow)  
- **3-bit Opcode**: Selects one of 8 operations

| Opcode | Operation       |
|--------|-----------------|
| 000    | `A + B`         |
| 001    | `A - B`         |
| 010    | `A * B`         |
| 011    | `A / B` (non-zero) |
| 100    | `A & B`         |
| 101    | `A or B`       |
| 110    | `A % B`         |
| 111    | `A ** B` (power) |

---

## Design Highlights

- **Modular**: Each operation in separate Verilog module  
- **Top-Level**: `case` statement in `always @(*)` selects output  
- **Power**: Implemented with `for` loop in combinational block  
- **Testbench**: Exhaustive opcodes + corner cases (div-by-zero)

---

**Applications**: CPU datapath, DSP, educational cores
