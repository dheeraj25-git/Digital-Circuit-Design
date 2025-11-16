`timescale 1ns / 1ps


module basic_vending(
    input clk, reset, nickel, dime, dispense_in,
    output reg dispense_out, done,
    output reg [3:0] change_out
    );
    
    parameter WAIT = 2'b00, VEND = 2'b01, DONE = 2'b10;
    reg [4:0] money;
    reg [1:0] state, next_state;
    
    always@(posedge clk or posedge reset)
    begin
        if(reset) begin
            state <= WAIT;
            money <= 0;
        end
            
        else begin
            state <= next_state;
        end
    end
    
    always@(*) 
    begin
        case(state)
        WAIT:   begin
                if(dispense_in && money >= 15) next_state = VEND;
                else next_state = WAIT;
                end   
                
        VEND:   begin
                if(money == 15) begin change_out = 0; end
                else begin change_out = money - 15; end
                
                money = 0;
                dispense_out = 1;
                done = 1;
                next_state = DONE;
                end
                
        DONE:   begin
                    next_state = WAIT;
                end
                        
        endcase
    end
    
    always@(posedge clk or posedge reset)
    begin
        if(state == WAIT) begin 
            dispense_out <= 0;
            change_out <= 0;
            done <= 0;
            
            if(nickel)      money <= money + 5;
            else if(dime)   money <= money + 10;
        end
        
        else if(state == DONE) begin 
        money <= 0;
        dispense_out <= 0;
        change_out <= 0;
        done <= 0;
        end
        
        else begin 
            dispense_out <= 0;
            change_out <= 0;
            done <= 0;
        end           
        
    end
    
endmodule

`timescale 1ns / 1ps
module tb_basic_vending;
    reg clk, reset, nickel, dime, dispense_in;
    wire dispense_out, done;
    wire [3:0] change_out;

    basic_vending uut (
        .clk(clk), .reset(reset), .nickel(nickel), .dime(dime), .dispense_in(dispense_in),
        .dispense_out(dispense_out), .done(done), .change_out(change_out)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Starting Vending Machine Test...");
        reset = 1; nickel = 0; dime = 0; dispense_in = 0;
        #15;
        reset = 0;
        #10;

        // Test 1: Two nickels (10¢) + dime (20¢) = dispense + 5¢ change
        $display("Test 1: Two nickels + dime");
        nickel = 1; #10; nickel = 0;  // 5¢
        nickel = 1; #10; nickel = 0;  // 10¢
        dime = 1; #10; dime = 0;      // 20¢
        dispense_in = 1; #10; dispense_in = 0;
        #10;  // Wait for VEND→DONE
        $display("Money=%d, Dispense=%b, Change=%d, Done=%b", uut.money, dispense_out, change_out, done);
        
        // Test 2: Dime + nickel = exactly 15¢, no change
        $display("Test 2: Dime + nickel");
        #10;  // Back to WAIT
        dime = 1; #10; dime = 0;      // 10¢
        nickel = 1; #10; nickel = 0;  // 15¢
        dispense_in = 1; #10; dispense_in = 0;
        #10;
        $display("Money=%d, Dispense=%b, Change=%d, Done=%b", uut.money, dispense_out, change_out, done);

        $display("Test completed!");
        $finish;
    end

    initial begin
        $monitor("t=%0t | state=%b | money=%d | nickel=%b | dime=%b | dispense=%b | change=%d | done=%b",
                 $time, uut.state, uut.money, nickel, dime, dispense_in, change_out, done);
    end


endmodule