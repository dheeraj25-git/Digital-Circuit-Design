`timescale 1ns / 1ps

module transceive_tb;
    reg clk, reset;
    reg load, rx_enable;
    reg [7:0] data_in;
    wire serial_out, tx_state, rx_state, tx_baud_tick, rx_baud_tick;
    wire [7:0] data_out;
    
    transmitter tx(
    .clk(clk),
    .reset(reset),
    .load(load),
    .data_in(data_in),
    .serial_out(serial_out),
    .tx_state(tx_state)
    );
    
    receiver rx(
    .clk(clk),
    .reset(reset),
    .serial_in(serial_out),//connecting the input port of the receiver to the output port of transmitter
    .rx_enable(rx_enable),
    .rx_state(rx_state),
    .data_out(data_out)
    );
    
    assign tx_baud_tick = tx.baud_tick;
    assign rx_baud_tick = rx.baud_tick;
    
    initial 
    begin
        forever begin clk=1; #5; clk=0; #5; end//clock period is kept to be 5ns
    end  
    
    initial 
    begin
        data_in = 8'h9d;
        reset = 1;
        load = 1;
        rx_enable = 0;//no data is loaded
        #10;
        
        reset = 0; #10; 
        
        data_in = 8'h9d; 
        load = 1;//data is loaded 
        rx_enable = 0;
        #10;
        
        load = 0;
        rx_enable = 1; #910;
        
        /*
        needs 10 clock cycles to transmit one bit which corresponds to 100 ns of time period
        hence it needs 80 clock cycles to transmit a byte which corresponds to 800 ns of time period  
        each bit is transmitted on the negative edge of a baud_tick.   
        each baud_tick goes high at the 9th clock cycle with a positive edge
        and falls to zero with a negative edge, triggering the transmission of a bit
        the received data is dumped to the data_out register at the 9th baud_tick 
        */
        
        if(data_out == 8'h9d)
        begin
            $display("TEST PASSED: received %h", data_out);
        end
        else
        begin
            $display("TEST FAILED: received %h", data_out);
        end

        data_in = 8'h45; 
        load = 1;//data is loaded 
        rx_enable = 0;
        #10;
        
        load = 0;
        rx_enable = 1; #910;
        if(data_out == 8'h45)
        begin
            $display("TEST PASSED: received %h", data_out);
        end
        else
        begin
            $display("TEST FAILED: received %h", data_out);
        end
    
    $finish;
        end  
        
endmodule
