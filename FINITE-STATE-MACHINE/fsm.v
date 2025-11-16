`timescale 1ns / 1ps
//sequence detector for 101
module fsm(
input clk, reset, x,
output reg z
    );
    reg[1:0] state, next_state;
    parameter s0=2'b00, s1=2'b01, s2=2'b10;
    
    always@(posedge clk or posedge reset)
    begin
    if(reset) state<=s0;
    else state <= next_state;
    end
    
    always@(*)
    begin
    case(state)
    s0: begin
    next_state= x?s1:s0;
    z=0;
    end
    
    s1: begin
    next_state= x?s1:s2;
    z=0;
    end
    
    s2: begin
    next_state= x?s1:s0;
    z=x?1:0;
    end
    
    default: begin
    next_state=s0;
    z=0;
    end
    
    endcase
    end
endmodule

module fsm_tb;

reg clk, reset, x;
wire z;

fsm uut(
.clk(clk),
.reset(reset),
.x(x),
.z(z)
);

initial 
begin
forever begin clk =0;#5; clk=1; #5; end
end

initial 
begin
reset =1;
x=0;
#10;

reset = 0;
#10;

$display("applying test sequence 1101011");
x=1; #10;
x=1; #10;
x=0; #10;
x=1; #10;
x=0; #10;
x=1; #10;
x=1; #10;
$display("test completed...");
$finish;
end

initial begin
$monitor("time = %0t | clk = %b | reset = %b | x = %b | z = %b", $time, clk, reset, x, z);
end
endmodule