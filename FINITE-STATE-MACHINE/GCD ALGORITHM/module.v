
```verilog
`timescale 1ns / 1ps

// =============================================================================
// Project: GCD Calculator using Euclidean Subtraction Algorithm
// Description:
//   FSM-based GCD calculator using repeated subtraction (Euclidean algorithm).
//   Accepts two 4-bit numbers (0–15), outputs GCD when done.
//   States: IDLE → LOAD → CALC → DONE
//   Fully synthesizable. Ideal for FPGA demos, interviews, and educational use.
// =============================================================================

// ========================================
// MODULE: gcd_calculator (RTL Design)
// ========================================
module gcd_calculator(
    input            clk,        // Clock input
    input            reset,      // Active-high synchronous reset
    input            start,      // Start calculation (pulse)
    input      [3:0] in1,        // First input (0–15)
    input      [3:0] in2,        // Second input (0–15)
    output reg       done,       // Pulse: GCD ready
    output reg [3:0] gcd_out     // Final GCD result
);

    // =========================================================================
    // FSM States
    // =========================================================================
    parameter IDLE = 2'b00,  // Waiting for start
              LOAD = 2'b01,  // Load inputs into registers
              CALC = 2'b10,  // Perform subtraction until equal
              DONE = 2'b11;  // Output GCD, return to IDLE

    // =========================================================================
    // Internal Signals
    // =========================================================================
    reg [1:0] state, next_state;
    reg load_in1, load_in2, check;           // Control signals
    reg [3:0] in1_reg, in2_reg;              // Datapath registers

    // =========================================================================
    // State Register: Sequential Logic
    // =========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // =========================================================================
    // Next-State Logic & Control Signals: Combinational
    // =========================================================================
    always @(*) begin
        next_state = state;
        load_in1 = 0; load_in2 = 0; check = 0; done = 0;

        case (state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
            end

            LOAD: begin
                load_in1 = 1;
                load_in2 = 1;
                next_state = CALC;
            end

            CALC: begin
                if (in1_reg == in2_reg)
                    next_state = DONE;
                else
                    check = (in1_reg > in2_reg);  // Decide which to subtract from
            end

            DONE: begin
                done = 1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // =========================================================================
    // Datapath: Registers & Subtraction Logic
    // =========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in1_reg <= 0;
            in2_reg <= 0;
            gcd_out <= 0;
        end
        else begin
            // Load inputs
            if (load_in1) in1_reg <= in1;
            if (load_in2) in2_reg <= in2;

            // Subtraction in CALC state
            if (state == CALC && in1_reg != in2_reg) begin
                if (check)
                    in1_reg <= in1_reg - in2_reg;  // in1 > in2
                else
                    in2_reg <= in2_reg - in1_reg;  // in2 >= in1
            end

            // Output GCD when DONE
            if (state == DONE)
                gcd_out <= in1_reg;  // GCD is the remaining value
        end
    end

endmodule

// ========================================
// TESTBENCH: gcd_calculator_tb (Self-Contained)
// ========================================
module gcd_calculator_tb;

    // Inputs
    reg clk, reset, start;
    reg [3:0] in1, in2;

    // Outputs
    wire done;
    wire [3:0] gcd_out;

    // Instantiate Unit Under Test
    gcd_calculator uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .in1(in1),
        .in2(in2),
        .done(done),
        .gcd_out(gcd_out)
    );

    // =========================================================================
    // Clock Generation: 100 MHz (10 ns period)
    // =========================================================================
    initial begin
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    // =========================================================================
    // Test Sequence
    // =========================================================================
    initial begin
        $display("Starting GCD Calculator Simulation...");

        // Initialize
        reset = 1; start = 0; in1 = 0; in2 = 0;
        #15;
        reset = 0;
        #10;

        // =============================
        // Test Case 1: GCD(12, 8) = 4
        // =============================
        $display("Test 1: GCD(12, 8)");
        in1 = 12; in2 = 8; start = 1;
        #10;
        start = 0;

        // Wait for done signal
        wait(done);
        #20;

        if (gcd_out == 4)
            $display("TEST 1 PASS: gcd_out = %d", gcd_out);
        else
            $display("TEST 1 FAIL: gcd_out = %d, expected 4", gcd_out);

        $display("Simulation completed.");
        $finish;
    end

    // =========================================================================
    // Real-time Monitoring
    // =========================================================================
    initial begin
        $monitor("Time=%0t | state=%b | in1_reg=%d | in2_reg=%d | gcd_out=%d | done=%b",
                 $time, uut.state, uut.in1_reg, uut.in2_reg, gcd_out, done);
    end

endmodule
```
