`timescale 1ns / 1ps

module baud_timer # (parameter baud_period = 10)
    (
    input clk,
    input reset,
    input enable,
    output reg baud_tick//to indicate the transmission of a bit
    );
    
    reg [4:0] counter;
    
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            counter <= 0;
            baud_tick <= 0;
        end
        else if(enable)
        begin
            if(counter == baud_period - 1)
            begin
                counter <= 0;
                baud_tick <= 1;
            end
            else
            begin
                counter <=  counter + 1;
                baud_tick <= 0;
            end
        end
        else
        begin
            counter <= 0;
            baud_tick <= 0;
        end
    end
endmodule
