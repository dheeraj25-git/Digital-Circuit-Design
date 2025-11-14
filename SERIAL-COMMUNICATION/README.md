# 8-bit Serial Communication with Parameterized Baud Rate Generator

**Fully synthesizable, loopback-verified UART-like core** for embedded and SoC applications.

---

## Features

- **8-bit Transmitter + Receiver**  
  - 8-N-1 format (8 data bits, no parity, 1 stop bit)

- **Parameterized Baud Rate Generator**  
  - Configurable clock divider  
  - **Baud tick**: `10 clock cycles/bit` → **100 ns/bit** at 100 MHz

- **Loopback Verified**  
  - `0x9D` → 100% correct reception  
  - `0x45` → 100% correct reception

- **Applications**  
  - Embedded communication  
  - SoC interfacing  
  - FPGA debug consoles  
  - Sensor data logging
