// bitwise_or.v
// 4-bit bitwise OR module: ORs A and B, zero-extends to 8 bits.
`timescale 1ns / 1ps

module bitwise_or(
    input [3:0] A,        // First 4-bit operand
    input [3:0] B,        // Second 4-bit operand
    output [7:0] bit_or   // 8-bit output (lower 4 bits used)
    );
    
    assign bit_or = A | B;    // Bitwise OR
endmodule
