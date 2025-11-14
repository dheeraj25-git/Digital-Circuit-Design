// subtract.v
// 4-bit subtractor module: outputs absolute difference as 8 bits.
`timescale 1ns / 1ps

module subtract(
    input [3:0] A,            // First 4-bit operand
    input [3:0] B,            // Second 4-bit operand
    output reg [7:0] difference // 8-bit difference output
    );
    
    always@(*) begin
        if(A > B)
            difference = A - B;    // If A greater, subtract B from A
        else
            difference = B - A;    // If B greater or equal to A, subtract A from B
    end 
endmodule
