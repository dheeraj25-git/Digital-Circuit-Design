`timescale 1ns / 1ps

module testbench;

    // Declare 4-bit register inputs for operands A and B
    reg [3:0] A, B;
    // 3-bit register for selecting ALU operation code
    reg [2:0] opcode;
    // Wire to capture 8-bit output result from ALU
    wire [7:0] result;
    
    // Instantiate the top-level ALU module under test (uut)
    top_module uut(
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    
    initial begin 
        // Test addition: 3 + 1, wait 10 time units, then display result
        A = 4'b0011; B = 4'b0001; opcode = 3'b000; #10;
        $display("ADD: %d + %d = %d", A, B, result);
        
        // Test subtraction: |2 - 3|, wait 10 time units, display output
        A = 4'b0010; B = 4'b0011; opcode = 3'b001; #10;
        $display("SUBTRACT: |%d - %d| = %d", A, B, result);
        
        // Test multiplication: 5 * 10, wait 10 time units, display output
        A = 4'b0101; B = 4'b1010; opcode = 3'b010; #10;
        $display("MULTIPLY: %d * %d = %d", A, B, result);
        
        // Test division: 10 / 5, with division by zero check before display
        A = 4'b1010; B = 4'b0101; opcode = 3'b011; #10;
        if (B == 0) 
            $display("DIVIDE: Division by zero error!");
        else
            $display("DIVIDE: %d / %d = %d", A, B, result);
        
        // Test bitwise AND: 0010 & 0011, show lower 4 bits output only
        A = 4'b0010; B = 4'b0011; opcode = 3'b100; #10;
        $display("BITWISE AND: %b & %b = %b", A, B, result[3:0]);
        
        // Test bitwise OR: 0011 | 1010, show lower 4 bits output only
        A = 4'b0011; B = 4'b1010; opcode = 3'b101; #10;
        $display("BITWISE OR: %b | %b = %b", A, B, result[3:0]);
        
        // Test modulo operation: 12 % 5, wait and display output
        A = 4'b1100; B = 4'b0101; opcode = 3'b110; #10;
        if (B == 0) 
            $display("MODULO: Division by zero error!");
        else
            $display("MODULO: %d modulo %d = %d", A, B, result);
        
        // Test power calculation: 3^2, wait and display output
        A = 4'b0011; B = 4'b0010; opcode = 3'b111; #10;
        $display("POWER: %d ^ %d = %d", A, B, result);
        
        // End simulation
        $finish;
    end    
        
endmodule
