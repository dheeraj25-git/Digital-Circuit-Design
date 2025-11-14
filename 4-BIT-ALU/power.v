// power.v
// 4-bit power module: Raises A to the power B (= A^B), returns 8 bits.
`timescale 1ns / 1ps

module power(
    input [3:0] A,            // Base, 4 bits
    input [3:0] B,            // Exponent, 4 bits
    output reg [7:0] power_out // 8-bit output
    );

    integer i;                // Loop counter
    reg [7:0] a;              // Working variable for result

    always @(*) begin
        a = 1;                // Initialize result to 1
        for (i = 0; i < B; i = i + 1) begin
            a = a * A;        // Repeated multiplication for power
        end
        power_out = a;        // Final result assigned
    end
endmodule
