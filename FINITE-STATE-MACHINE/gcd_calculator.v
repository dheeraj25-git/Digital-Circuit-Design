`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2025 16:59:23
// Design Name: 
// Module Name: gcd_calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//euclidian algorithm to calculate the gcd by continuous subtraction 
module gcd_calculator(
    input clk,
    input reset,
    input start,
    input [3:0] in1,
    input [3:0] in2,
    output reg done,
    output reg [3:0] gcd_out
    );
    
    parameter IDLE = 2'b00, LOAD = 2'b01, CALC = 2'b10, DONE = 2'b11;
    reg [1:0] state, next_state;
    reg load_in1, load_in2, check;//control signals
    reg [3:0] in1_reg, in2_reg;//datapath registers
    
    always@(posedge clk or posedge reset)
    begin
        if(reset) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    
    always@(*)
    begin
        next_state = state;
        load_in1 = 0; load_in2 = 0; check = 0; done = 0;
        case(state)
            IDLE:   begin
                    if(start) next_state = LOAD; 
                    end 
                     
            LOAD:   begin 
                    load_in1 = 1; load_in2 = 1;
                    next_state = CALC;
                    end
                     
            CALC:   begin
                    if(in1_reg == in2_reg) next_state = DONE;
                    else check = (in1_reg > in2_reg);//to compare the two numbers and decide upon the minuend and subtrahend
                    end                                         
            
            DONE:   begin
                    done = 1;
                    next_state = IDLE;
                    end         
        endcase
    end
    
    always@(posedge clk or posedge reset)
    begin
        if(reset) begin
            in1_reg <= 0;
            in2_reg <= 0;
            gcd_out <= 0;
            
        end
        else begin
            if(load_in1) in1_reg <= in1;
            if(load_in2) in2_reg <= in2;
            if(state == CALC && in1_reg != in2_reg) begin
                if(check)   in1_reg <= in1_reg - in2_reg;
                else        in2_reg <= in2_reg - in1_reg;
            end
            if(state == DONE) gcd_out <= in1_reg;     
        end
    end
endmodule

`timescale 1ns / 1ps
module gcd_calculator_tb;
    reg clk, reset, start;
    reg [3:0] in1, in2;
    wire done;
    wire [3:0] gcd_out;

    gcd_calculator uut (
        .clk(clk), .reset(reset), .start(start),
        .in1(in1), .in2(in2), .done(done), .gcd_out(gcd_out)
    );

    initial begin
        forever begin clk = 1; #5; clk = 0; #5; end
    end

    initial begin
        $display("Starting GCD simulation...");
        reset = 1; start = 0; in1 = 0; in2 = 0;
        #15;
        reset = 0;
        #10;

        // Test 1: GCD(12, 8) = 4
        $display("Test 1: GCD(12, 8)");
        in1 = 12; in2 = 8; start = 1;
        #10;
        start = 0;
        wait(done);
        #20;
        if (gcd_out == 4)
            $display("Test 1 PASS: gcd_out = %d", gcd_out);
        else
            $display("Test 1 FAIL: gcd_out = %d, expected 4", gcd_out);

        $display("Test completed.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | state=%b | in1_reg=%d | in2_reg=%d | gcd_out=%d | done=%b",
                 $time, uut.state, uut.in1_reg, uut.in2_reg, gcd_out, done);
    end
endmodule
