`timescale 1ns / 1ps

module receiver(
    input clk,
    input reset,
    input serial_in,
    input rx_enable,
    output reg rx_state,
    output reg [7:0] data_out
    );
    
    reg [3:0] baud_counter;
    reg [7:0] shift_reg;
    wire baud_tick;
    
    baud_timer #(.baud_period(10)) timer(
    .clk(clk),
    .reset(reset),
    .enable(!reset && rx_enable),
    .baud_tick(baud_tick)
    );
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin 
            data_out <= 8'b0;
            shift_reg <= 8'b0;
            rx_state <= 0;//to indicate the system isnt receiving any data
            baud_counter <= 0;
        end
        else if (rx_enable && baud_tick) 
        begin
            if (baud_counter <= 8) 
            begin
                shift_reg <= {serial_in, shift_reg[7:1]};
                baud_counter <= baud_counter + 1;
                rx_state <= (baud_counter < 8) ? 1 : 0;
                if (baud_counter <= 8)
                    data_out <= {serial_in, shift_reg[7:1]};
            end
        end 
        else if (!rx_enable) 
        begin
            baud_counter <= 0;
            rx_state <= 0;
        end
    end
        
endmodule
