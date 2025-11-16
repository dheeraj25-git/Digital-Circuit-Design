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
```
