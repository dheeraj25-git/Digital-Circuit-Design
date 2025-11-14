# Digital-Circuit-Design

A collection of **industry-relevant digital circuit designs** implemented in **Verilog HDL**, targeting **FPGA and ASIC applications**. Each project includes **parameterized modules**, **robust testbenches**, and **simulation waveforms** to demonstrate correctness under real-world constraints.

---

## Projects

### 1. **UART-Style Serial Transceiver** --> serail_commn.xpr
- **8-bit transmitter + receiver** with **parameterized baud rate generator**  
- Loopback verified: `0x9D`, `0x45` → **100% correct reception**  
- Baud tick: 10 clock cycles/bit → 100 ns/bit  
- **Applications**: Embedded communication, SoC interfacing  

### 2. **Asynchronous FIFO with Gray Code CDC** --> fifo.xpr
- **8×8 dual-clock FIFO** (100 MHz write, 50 MHz read)  
- **Gray code pointers** + **2-stage synchronizers** to prevent metastability  
- **Full/empty flags** with wraparound detection (4-bit pointers)  
- Verified: **Full at 8th write**, **empty after 60 ns sync delay**  
- **100% data integrity** across clock domains 
