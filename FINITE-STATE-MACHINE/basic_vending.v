```verilog
`timescale 1ns / 1ps

// =============================================================================
// Module: basic_vending
// Description: 
//   A simple FSM-based vending machine that accepts nickels (5¢) and dimes (10¢).
//   Dispenses item when total >= 15¢ and returns change if overpaid.
//   States: WAIT → VEND → DONE → WAIT
//   Designed for educational/demo use. Fully synthesizable on FPGA/ASIC.
// =============================================================================
module basic_vending(
    input clk,           // System clock (e.g., 100 MHz)
    input reset,         // Active-high synchronous reset
    input nickel,        // Pulse: insert 5¢ coin
    input dime,          // Pulse: insert 10¢ coin
    input dispense_in,   // Pulse: user requests dispense (when ready)
    output reg dispense_out,  // Pulse: item dispensed
    output reg done,          // Pulse: transaction complete
    output reg [3:0] change_out // Change in cents (0–15)
);

    // =========================================================================
    // Parameters: FSM States
    // =========================================================================
    parameter WAIT = 2'b00,  // Waiting for coins or dispense request
              VEND = 2'b01,  // Dispensing item & calculating change
              DONE = 2'b10;  // Transaction finished, return to WAIT

    // =========================================================================
    // Internal Registers
    // =========================================================================
    reg [4:0] money;         // Accumulated money (0–31 cents max)
    reg [1:0] state, next_state;  // Current and next FSM state

    // =========================================================================
    // State Register: Sequential Logic (Clocked)
    // =========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= WAIT;
            money <= 0;
        end
        else begin
            state <= next_state;
        end
    end

    // =========================================================================
    // Next-State Logic: Combinational
    // =========================================================================
    always @(*) begin
        case (state)
            WAIT: begin
                if (dispense_in && money >= 15)
                    next_state = VEND;
                else
                    next_state = WAIT;
            end

            VEND: begin
                // Calculate change and reset money
                if (money == 15)
                    change_out = 0;
                else
                    change_out = money - 15;

                money = 0;
                dispense_out = 1;
                done = 1;
                next_state = DONE;
            end

            DONE: begin
                next_state = WAIT;
            end

            default: next_state = WAIT;
        endcase
    end

    // =========================================================================
    // Output & Money Update Logic: Sequential (Clocked)
    // =========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dispense_out <= 0;
            change_out   <= 0;
            done         <= 0;
            money        <= 0;
        end
        else if (state == WAIT) begin
            // Reset outputs
            dispense_out <= 0;
            change_out   <= 0;
            done         <= 0;

            // Accumulate coins (only one coin per cycle)
            if (nickel)
                money <= money + 5;
            else if (dime)
                money <= money + 10;
        end
        else if (state == DONE) begin
            // Clear all outputs after one cycle
            money        <= 0;
            dispense_out <= 0;
            change_out   <= 0;
            done         <= 0;
        end
        else begin
            // VEND state: outputs already set in combinational block
            // Keep them low in sequential to avoid glitches
            dispense_out <= 0;
            change_out   <= 0;
            done         <= 0;
        end
    end

endmodule

// =============================================================================
// Testbench: tb_basic_vending
// Description:
//   Verifies basic_vending module with two test cases:
//     1. Two nickels + dime → dispense + 5¢ change
//     2. Dime + nickel → dispense + 0¢ change
//   Uses $monitor for real-time signal tracing.
// =============================================================================
module tb_basic_vending;

    // Inputs
    reg clk, reset, nickel, dime, dispense_in;

    // Outputs
    wire dispense_out, done;
    wire [3:0] change_out;

    // Instantiate the Unit Under Test (UUT)
    basic_vending uut (
        .clk(clk),
        .reset(reset),
        .nickel(nickel),
        .dime(dime),
        .dispense_in(dispense_in),
        .dispense_out(dispense_out),
        .done(done),
        .change_out(change_out)
    );

    // =========================================================================
    // Clock Generation: 100 MHz (10 ns period)
    // =========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =========================================================================
    // Test Sequence
    // =========================================================================
    initial begin
        $display("Starting Vending Machine Test...");

        // Initialize inputs
        reset = 1; nickel = 0; dime = 0; dispense_in = 0;
        #15;
        reset = 0;
        #10;

        // =============================
        // Test 1: 5 + 5 + 10 = 20¢ → 5¢ change
        // =============================
        $display("Test 1: Two nickels + dime");
        nickel = 1; #10; nickel = 0; // +5¢
        nickel = 1; #10; nickel = 0; // +5¢ (total 10¢)
        dime   = 1; #10; dime   = 0; // +10¢ (total 20¢)
        dispense_in = 1; #10; dispense_in = 0;
        #10; // Wait for VEND → DONE
        $display("Result: Money=%d, Dispense=%b, Change=%d, Done=%b",
                 uut.money, dispense_out, change_out, done);

        // =============================
        // Test 2: 10 + 5 = 15¢ → 0¢ change
        // =============================
        #10; // Return to WAIT
        $display("Test 2: Dime + nickel");
        dime   = 1; #10; dime   = 0; // +10¢
        nickel = 1; #10; nickel = 0; // +5¢ (total 15¢)
        dispense_in = 1; #10; dispense_in = 0;
        #10;
        $display("Result: Money=%d, Dispense=%b, Change=%d, Done=%b",
                 uut.money, dispense_out, change_out, done);

        $display("Test completed!");
        $finish;
    end

    // =========================================================================
    // Real-time Monitoring
    // =========================================================================
    initial begin
        $monitor("t=%0t | state=%b | money=%d | nickel=%b | dime=%b | dispense_in=%b | change=%d | done=%b",
                 $time, uut.state, uut.money, nickel, dime, dispense_in, change_out, done);
    end

endmodule
```
