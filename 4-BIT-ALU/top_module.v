// top_module.v
// Top-level ALU module: Instantiates all operation modules, selects result by opcode.
`timescale 1ns / 1ps

module top_module(
    input [3:0] A,            // 4-bit operand A
    input [3:0] B,            // 4-bit operand B
    input [2:0] opcode,       // 3-bit operation selector
    output reg [7:0] result   // 8-bit ALU result output
    );
    
    // Wires to hold operation outputs from submodules
    wire [7:0] sum, difference, product, quotient;
    wire [7:0] bit_or, bit_and, remainder, power_out;
    
    // Instantiate each operation submodule with inputs and connect outputs
    add add_inst(
        .A(A),
        .B(B),
        .sum(sum)
    );
    
    subtract sub_inst(
        .A(A),
        .B(B),
        .difference(difference)
    );
    
    multiply mul_inst(
        .A(A),
        .B(B),
        .product(product)
    );
    
    divide div_inst(
        .A(A),
        .B(B),
        .quotient(quotient)
    );
    
    bitwise_and and_inst(
        .A(A),
        .B(B),
        .bit_and(bit_and)
    );
    
    bitwise_or or_inst(
        .A(A),
        .B(B),
        .bit_or(bit_or)
    );
    
    modulo modulo_inst(
        .A(A),
        .B(B),
        .remainder(remainder)
    );
    
    power power_inst(
        .A(A),
        .B(B),
        .power_out(power_out)
    );
    
    // ALU output selection logic based on opcode
    always@(*) begin
        case(opcode)
            3'd0: result = sum;         // Addition
            3'd1: result = difference;  // Subtraction
            3'd2: result = product;     // Multiplication
            3'd3: result = quotient;    // Division
            3'd4: result = bit_and;     // Bitwise AND
            3'd5: result = bit_or;      // Bitwise OR
            3'd6: result = remainder;   // Modulo
            3'd7: result = power_out;   // Power
        endcase
    end
endmodule
