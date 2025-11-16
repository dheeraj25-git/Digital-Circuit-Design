### 1. **Vending Machine FSM**
- **Finite State Machine** with 3 states: `WAIT`, `VEND`, `DONE`  
- Accepts **nickel (5¢)** and **dime (10¢)**  
- Dispenses at **15¢**, returns **correct change (0–15¢)**  
- Verified: **100% correct** for overpay and exact pay  
- **Applications**: Embedded control, IoT devices, educational demos

### 2. **Sequence Detector for "101" (Mealy FSM)**
- Detects **overlapping "101"** in serial bit stream  
- **Mealy machine**: Output depends on state + input  
- Verified with **1101011** → **z = 1 at 5th and 7th bits**  
- **Zero false positives**, **100% detection accuracy**  
- **Applications**: Digital communication, pattern matching, CRC

- ### 3. **GCD Calculator (Euclidean Subtraction)**
- **FSM-based** GCD using **repeated subtraction**  
- Accepts **4-bit inputs (0–15)**  
- Verified: **GCD(12, 8) = 4** in 8 cycles  
- **Single-file design + testbench** for easy reuse  
- **Applications**: DSP, cryptography, embedded math
