// bitwise_and.v
// 4-bit bitwise AND module: ANDs A and B, zero-extends to 8 bits.
`timescale 1ns / 1ps

module bitwise_and(
    input [3:0] A,        // First 4-bit operand
    input [3:0] B,        // Second 4-bit operand
    output [7:0] bit_and  // 8-bit output (lower 4 bits used)
    );
    
    assign bit_and = A & B;   // Bitwise AND
endmodule
