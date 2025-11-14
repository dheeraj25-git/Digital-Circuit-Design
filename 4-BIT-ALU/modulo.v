// modulo.v
// 4-bit modulo module: finds remainder of A divided by B.
`timescale 1ns / 1ps

module modulo(
    input [3:0] A,           // Dividend (4-bit)
    input [3:0] B,           // Divisor (4-bit)
    output [7:0] remainder   // 8-bit remainder output
    );
    
    assign remainder = A % B; // Modulo/remainder operation
endmodule
