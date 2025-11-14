`timescale 1ns / 1ps

module transmitter(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output reg serial_out,
    output reg tx_state
    );
    
    reg [7:0] shift_reg;
    reg [3:0] baud_counter;
    wire baud_tick;
    
    baud_timer #(.baud_period(10)) timer(
    .clk(clk),
    .reset(reset),
    .enable(!load && !reset),
    .baud_tick(baud_tick)
    );
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin 
            serial_out <= 0;
            baud_counter <= 0;
            shift_reg <= 0;
            tx_state <= 0; //0 for no transmission happening
        end
        else if(load)
        begin
            shift_reg <= data_in;
            tx_state <= 0;
            baud_counter <= 0;
            serial_out <= 0;
        end  
        else if(baud_tick && baud_counter <= 8)
        begin 
            serial_out <= shift_reg[0];
            shift_reg <= {1'b0, shift_reg[7:1]};
            baud_counter = baud_counter + 1;
            tx_state <= (baud_counter < 8) ? 1 : 0; // Stay on until 8th bit end   
        end
    end 
    
endmodule
