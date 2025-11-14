
`timescale 1ns / 1ps
// Module: fifo2 - Asynchronous FIFO
// Description: Implements an asynchronous FIFO with separate write and read clocks,
//              using Gray code for safe clock domain crossing (CDC). Stores 8-bit
//              data (width=8) in a depth=8 memory array, with full and empty flags.
//              Designed for FPGA/ASIC, with two-stage synchronization to prevent
//              metastability. Ideal for buffering data across clock domains (e.g., SoC).
module fifo2 #(
    parameter width = 8,  // Data width (8 bits per entry)
    parameter depth = 8  // FIFO depth (8 entries)
)(
    input wrt_clk, rd_clk,          // Write and read clocks (async)
    input wrt_rst, rd_rst,          // Active-high async resets for write/read domains
    input wrt_en, rd_en,            // Write/read enable signals
    input [width-1:0] data_in,      // Input data to write (8-bit)
    output reg [width-1:0] data_out,// Output data from read (8-bit)
    output full, empty              // Status flags: FIFO full (8 entries), empty (0 entries)
);

// Function: bin_to_gray
// Description: Converts binary to Gray code for safe CDC. Only one bit changes per
//              increment, reducing metastability risk when crossing clock domains.
//              Returns 4-bit Gray code for depth=8 (needs extra bit for wraparound).
function [$clog2(depth):0] bin_to_gray;
    input [$clog2(depth):0] bin;
    bin_to_gray = bin ^ (bin >> 1);  // XOR with right-shifted input
endfunction

// Memory: 8-bit x 8 entries, maps to block RAM (BRAM) or LUTRAM in FPGA
reg [width-1:0] mem [0:depth-1];
// Pointers: 4-bit (3:0) for depth=8, extra bit for wraparound detection
reg [$clog2(depth):0] wrt_ptr, rd_ptr;          // Binary write/read pointers
reg [$clog2(depth):0] wrt_ptr_gray, rd_ptr_gray;// Gray-coded pointers
// Synchronizers: Two-stage FFs to sync pointers across clock domains
reg [$clog2(depth):0] rd_ptr_sync1, rd_ptr_sync2;  // rd_ptr_gray to wrt_clk
reg [$clog2(depth):0] wrt_ptr_sync1, wrt_ptr_sync2;// wrt_ptr_gray to rd_clk
integer i;  // Loop variable for reset

// Full flag: Asserted when write pointer is one full lap (8 entries) ahead
//            Compares Gray-coded pointers, using synchronized rd_ptr_sync2
assign full = ({~wrt_ptr_gray[3], wrt_ptr_gray[2:0]} == rd_ptr_sync2);
// Empty flag: Asserted when synchronized write pointer equals read pointer
assign empty = (rd_ptr_gray == wrt_ptr_sync2);

// Write Domain: Handles writes to mem and syncs rd_ptr_gray to wrt_clk
always @(posedge wrt_clk or posedge wrt_rst) begin
    if (wrt_rst) begin
        // Reset: Clear pointers and memory
        wrt_ptr <= 0;           // Reset write pointer
        wrt_ptr_gray <= 0;      // Reset Gray-coded write pointer
        rd_ptr_sync1 <= 0;      // Reset first sync FF
        rd_ptr_sync2 <= 0;      // Reset second sync FF
        for (i = 0; i < depth; i = i + 1) begin
            mem[i] <= 0;        // Clear memory (like vending machine shelves)
        end
    end
    else begin
        // Always sync rd_ptr_gray to wrt_clk for full flag
        rd_ptr_sync1 <= rd_ptr_gray;   // First FF: Captures potentially unstable rd_ptr_gray
        rd_ptr_sync2 <= rd_ptr_sync1;  // Second FF: Stabilizes for safe comparison
        if (wrt_en && !full) begin
            // Write data to memory at current pointer (lower 3 bits for 0-7)
            mem[wrt_ptr[2:0]] <= data_in;
            wrt_ptr <= wrt_ptr + 1;        // Increment pointer (4-bit, wraps at 16)
            // Convert next pointer to Gray code for CDC
            wrt_ptr_gray <= bin_to_gray(wrt_ptr + 1);
        end
    end
end

// Read Domain: Handles reads from mem and syncs wrt_ptr_gray to rd_clk
always @(posedge rd_clk or posedge rd_rst) begin
    if (rd_rst) begin
        // Reset: Clear pointers and output
        rd_ptr <= 0;            // Reset read pointer
        rd_ptr_gray <= 0;       // Reset Gray-coded read pointer
        data_out <= 0;          // Clear output register
        wrt_ptr_sync1 <= 0;     // Reset first sync FF
        wrt_ptr_sync2 <= 0;     // Reset second sync FF
    end
    else begin
        // Always sync wrt_ptr_gray to rd_clk for empty flag
        wrt_ptr_sync1 <= wrt_ptr_gray;  // First FF: Captures potentially unstable wrt_ptr_gray
        wrt_ptr_sync2 <= wrt_ptr_sync1; // Second FF: Stabilizes for safe comparison
        if (rd_en && !empty) begin
            // Read data from memory at current pointer (lower 3 bits for 0-7)
            data_out <= mem[rd_ptr[2:0]];
            rd_ptr <= rd_ptr + 1;          // Increment pointer (4-bit, wraps at 16)
            // Convert next pointer to Gray code for CDC
            rd_ptr_gray <= bin_to_gray(rd_ptr + 1);
        end
    end
end
endmodule

// Testbench: fifo2_tb
// Description: Tests the async FIFO by writing 8 entries, verifying memory contents,
//              and reading 8 entries. Uses 100 MHz wrt_clk (10 ns) and 50 MHz rd_clk
//              (20 ns) to simulate real async conditions. Displays full/empty flags.
module fifo2_tb;
    parameter width = 8, depth = 8;  // Match FIFO parameters
    reg wrt_clk, rd_clk;             // Write/read clocks
    reg wrt_rst, rd_rst;             // Write/read resets
    reg wrt_en, rd_en;               // Write/read enables
    reg [width-1:0] data_in;         // Input data
    wire [width-1:0] data_out;       // Output data
    wire full, empty;                // Status flags

    // Instantiate FIFO
    fifo2 #(
        .depth(depth),
        .width(width)
    ) uut (
        .wrt_clk(wrt_clk),
        .rd_clk(rd_clk),
        .wrt_rst(wrt_rst),
        .rd_rst(rd_rst),
        .wrt_en(wrt_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Generate write clock: 100 MHz (10 ns period)
    initial begin
        forever begin
            wrt_clk = 1; #5; wrt_clk = 0; #5;
        end
    end

    // Generate read clock: 50 MHz (20 ns period)
    initial begin
        forever begin
            rd_clk = 1; #10; rd_clk = 0; #10;
        end
    end

    // Write Test: Fill FIFO with 8 entries, check mem and full flag
    initial begin
        wrt_rst = 1;    // Assert write reset
        wrt_en = 0;     // Disable writes
        data_in = 0;    // Initialize input
        #10;
        wrt_rst = 0;    // Deassert reset
        #10;            // Wait for stable state
        // Write 8 entries (0 to 7)
        for (integer i = 0; i < depth; i = i + 1) begin
            wrt_en = 1;
            data_in = i;           // Write values 0, 1, ..., 7
            #10;                   // Wait for wrt_clk edge
            $display("t=%0t ns: Write mem[%0d]=%h, full=%b", $time, i, data_in, full);
        end
        wrt_en = 0;                // Stop writes
        #10;
        // Display memory contents after writes
        $display("After writes, mem contents:");
        for (integer i = 0; i < depth; i = i + 1) begin
            $display("mem[%0d]=%h", i, uut.mem[i]);
        end
    end

    // Read Test: Read 8 entries, check data_out and empty flag
    initial begin
        rd_rst = 1;    // Assert read reset
        rd_en = 0;     // Disable reads
        #20;           // Hold reset for 2 rd_clk cycles
        rd_rst = 0;    // Deassert reset
        #20;           // Wait for empty flag to update (2 rd_clk cycles for sync)
        // Read 8 entries
        for (integer i = 0; i < depth; i = i + 1) begin
            rd_en = 1;
            #20;       // Wait full rd_clk cycle for data_out
            $display("t=%0t ns: Read data=%h, Expected=%h, empty=%b, wrt_ptr_sync2=%b", 
                     $time, data_out, i, empty, uut.wrt_ptr_sync2);
        end
        #100;          // Extra time to observe final state
        $finish;       // End simulation
    end
endmodule
