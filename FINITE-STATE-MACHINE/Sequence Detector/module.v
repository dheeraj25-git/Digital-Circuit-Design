```verilog
`timescale 1ns / 1ps

// =============================================================================
// Module: fsm (Sequence Detector for "101")
// Description:
//   Mealy FSM that detects the sequence "101" in a serial bit stream.
//   Output z = 1 only when the last 3 bits are exactly 1→0→1.
//   States: s0 (no match), s1 (seen '1'), s2 (seen '10')
//   Fully synthesizable. Ideal for digital design interviews and FPGA demos.
// =============================================================================
module fsm (
    input  clk,      // Clock input
    input  reset,    // Active-high synchronous reset
    input  x,        // Serial input bit stream
    output reg z     // Output: 1 if "101" detected, else 0
);

    // =========================================================================
    // State Encoding
    // =========================================================================
    reg [1:0] state, next_state;
    parameter s0 = 2'b00,  // Initial / No match
              s1 = 2'b01,  // Seen '1'
              s2 = 2'b10;  // Seen '10'

    // =========================================================================
    // State Register: Sequential Logic (Clocked)
    // =========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= s0;
        else
            state <= next_state;
    end

    // =========================================================================
    // Next-State & Output Logic: Combinational (Mealy)
    // =========================================================================
    always @(*) begin
        case (state)
            s0: begin
                next_state = x ? s1 : s0;
                z = 1'b0;
            end

            s1: begin
                next_state = x ? s1 : s2;
                z = 1'b0;
            end

            s2: begin
                next_state = x ? s1 : s0;
                z = x ? 1'b1 : 1'b0;  // Detect "101" → z=1 only if x=1
            end

            default: begin
                next_state = s0;
                z = 1'b0;
            end
        endcase
    end

endmodule

// =============================================================================
// Testbench: fsm_tb
// Description:
//   Verifies the "101" sequence detector with input stream: 1 1 0 1 0 1 1
//   Expected z pulses: at 5th, 7th bits → "101" detected twice
//   Uses $monitor for real-time debugging.
// =============================================================================
module fsm_tb;

    // Inputs
    reg clk, reset, x;

    // Output
    wire z;

    // Instantiate Unit Under Test
    fsm uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z)
    );

    // =========================================================================
    // Clock Generation: 100 MHz (10 ns period)
    // =========================================================================
    initial begin
        forever begin
            clk = 0; #5;
            clk = 1; #5;
        end
    end

    // =========================================================================
    // Test Sequence
    // =========================================================================
    initial begin
        // Initialize
        reset = 1;
        x = 0;
        #10;
        reset = 0;
        #10;

        $display("Applying test sequence: 1 1 0 1 0 1 1");

        // Input stream: 1101011
        x = 1; #10;  // Bit 1
        x = 1; #10;  // Bit 2
        x = 0; #10;  // Bit 3
        x = 1; #10;  // Bit 4 → "101" detected (z=1)
        x = 0; #10;  // Bit 5
        x = 1; #10;  // Bit 6 → "101" detected again (z=1)
        x = 1; #10;  // Bit 7

        $display("Test completed. Check z pulses at t=50ns and t=70ns.");
        #20;
        $finish;
    end

    // =========================================================================
    // Real-time Signal Monitoring
    // =========================================================================
    initial begin
        $monitor("time = %0t | clk = %b | reset = %b | x = %b | z = %b",
                 $time, clk, reset, x, z);
    end

endmodule
```
