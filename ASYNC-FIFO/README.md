# 8×8 Dual-Clock FIFO (100 MHz Write, 50 MHz Read)

**Fully verified asynchronous FIFO** with robust clock domain crossing.

---

## Key Features

1. **8×8 Dual-Clock FIFO**  
   - Write clock: **100 MHz**  
   - Read clock: **50 MHz**

2. **Gray Code Pointers + 2-Stage Synchronizers**  
   - Eliminates metastability in cross-clock domains

3. **Full/Empty Flags with Wraparound Detection**  
   - 4-bit pointers ensure reliable status

4. **Verified Behavior**  
   - Full flag asserts after **8th write**  
   - Empty flag after **60 ns sync delay**

5. **100% Data Integrity**  
   - No corruption across clock domains

---

**Ideal for high-speed data buffering, AXI/AXI-Lite bridges, sensor interfaces, and DSP pipelines.**
