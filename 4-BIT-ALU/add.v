// add.v
// 4-bit adder module: sums inputs A and B, outputs 8-bit result.
`timescale 1ns / 1ps

module add(
    input [3:0] A,        // First 4-bit operand
    input [3:0] B,        // Second 4-bit operand
    output [7:0] sum      // 8-bit sum output
    );
    
    assign sum = A + B;   // Perform addition and assign the result
endmodule
