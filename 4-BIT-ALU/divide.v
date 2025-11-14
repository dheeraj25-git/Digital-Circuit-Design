// divide.v
// 4-bit divider module: performs unsigned division of A by B.
`timescale 1ns / 1ps

module divide(
    input [3:0] A,         // Dividend (4-bit)
    input [3:0] B,         // Divisor (4-bit)
    output [7:0] quotient  // 8-bit quotient output
    );
    
    assign quotient = A / B; // Perform division (beware B=0 case)
endmodule
