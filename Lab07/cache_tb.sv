`timescale 1ns/1ps

module cache_tb();

    // Parameters
    localparam DATA_WIDTH   = 32;
    localparam ADDR_WIDTH   = 16;
    localparam TAG_WIDTH    = 10;
    localparam OFFSET_WIDTH = 2;

    // DUT interface
    logic clk;
    logic rst_n;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic write_enable;
    logic [DATA_WIDTH-1:0] data_out;
    logic hit;
    logic miss;

    // Clock generation
    always #5 clk = ~clk;

    // DUT instantiation
    INNER_CACHE #(
        .DATA_WIDTH   (DATA_WIDTH),
        .ADDR_WIDTH   (ADDR_WIDTH),
        .TAG_WIDTH    (TAG_WIDTH),
        .OFFSET_WIDTH (OFFSET_WIDTH)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .addr         (addr),
        .data_in      (data_in),
        .write_enable (write_enable),
        .data_out     (data_out),
        .hit          (hit),
        .miss         (miss)
    );

    // Test procedure
    initial begin
        // VCD
        $dumpfile("build/cache_tb.vcd");
        $dumpvars(0, cache_tb);

        // Init
        clk = 0;
        rst_n = 0;
        addr = 0;
        data_in = 0;
        write_enable = 0;

        // Reset
        #12;
        rst_n = 1;

        // Write data at address 0x0010
        addr = 16'h0010;
        data_in = 32'hAABBCCDD;
        write_enable = 1;
        #10;

        // Write at address 0x0020 (different index)
        addr = 16'h0020;
        data_in = 32'h11223344;
        #10;

        // Disable write
        write_enable = 0;

        // Read back address 0x0010 (expect HIT)
        addr = 16'h0010;
        #10;
        $display("READ 0x0010 -> DATA: %h, HIT: %b, MISS: %b", data_out, hit, miss);

        // Read back address 0x0020 (expect HIT)
        addr = 16'h0020;
        #10;
        $display("READ 0x0020 -> DATA: %h, HIT: %b, MISS: %b", data_out, hit, miss);

        // Read from address 0x0030 (not written - expect MISS)
        addr = 16'h0030;
        #10;
        $display("READ 0x0030 -> DATA: %h, HIT: %b, MISS: %b", data_out, hit, miss);

        // End simulation
        #20;
        $finish;
    end

endmodule
