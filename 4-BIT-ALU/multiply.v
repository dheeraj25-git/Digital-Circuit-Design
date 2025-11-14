// multiply.v
// 4-bit multiplier module: multiplies A and B, outputs an 8-bit product.
`timescale 1ns / 1ps

module multiply(
    input [3:0] A,        // First 4-bit operand
    input [3:0] B,        // Second 4-bit operand
    output [7:0] product  // 8-bit product output
    );
    
    assign product = A * B; // Perform multiplication
endmodule
