`timescale 1ns/1ps

module cache_hierarchy_tb();

    // Parameters
    localparam ADDR_WIDTH = 16;
    localparam DATA_WIDTH = 32;
    localparam CACHE_SIZE_L1 = 16;
    localparam CACHE_SIZE_L2 = 32;

    // Clock
    logic clk;
    always #5 clk = ~clk;

    logic rst_n;

    // Processor signals
    logic proc_read_request;
    logic proc_write_request;
    logic [ADDR_WIDTH-1:0] proc_addr;
    logic [DATA_WIDTH-1:0] proc_write_data;
    logic proc_response;
    logic [DATA_WIDTH-1:0] proc_read_data;

    // Interconnect: L1 <-> L2
    logic l1_mem_read_request;
    logic l1_mem_write_request;
    logic [ADDR_WIDTH-1:0] l1_mem_addr;
    logic [DATA_WIDTH-1:0] l1_mem_write_data;
    logic l1_mem_response;
    logic [DATA_WIDTH-1:0] l1_mem_read_data;

    // Interconnect: L2 <-> Memory
    logic l2_mem_read_request;
    logic l2_mem_write_request;
    logic [ADDR_WIDTH-1:0] l2_mem_addr;
    logic [DATA_WIDTH-1:0] l2_mem_write_data;
    logic l2_mem_response;
    logic [DATA_WIDTH-1:0] l2_mem_read_data;

    // Memory model
    logic [DATA_WIDTH-1:0] main_memory [0:255];
    int mem_counter = 0;
    logic mem_busy = 0;

    // L1 Cache Instance
    OUTER_CACHE #(
        .CACHE_SIZE           (CACHE_SIZE_L1),
        .DATA_WIDTH           (DATA_WIDTH),
        .ADDR_WIDTH           (ADDR_WIDTH)
    ) l1_cache (
        .clk                  (clk),
        .rst_n                (rst_n),
        .read_request         (proc_read_request),
        .write_request        (proc_write_request),
        .addr                 (proc_addr),
        .write_data           (proc_write_data),
        .response             (proc_response),
        .read_data            (proc_read_data),

        .memory_read_request  (l1_mem_read_request),
        .memory_write_request (l1_mem_write_request),
        .memory_addr          (l1_mem_addr),
        .memory_write_data    (l1_mem_write_data),
        .memory_response      (l1_mem_response),
        .memory_read_data     (l1_mem_read_data)
    );

    // L2 Cache Instance
    OUTER_CACHE #(
        .CACHE_SIZE           (CACHE_SIZE_L2),
        .DATA_WIDTH           (DATA_WIDTH),
        .ADDR_WIDTH           (ADDR_WIDTH)
    ) l2_cache (
        .clk                  (clk),
        .rst_n                (rst_n),
        .read_request         (l1_mem_read_request),
        .write_request        (l1_mem_write_request),
        .addr                 (l1_mem_addr),
        .write_data           (l1_mem_write_data),
        .response             (l1_mem_response),
        .read_data            (l1_mem_read_data),

        .memory_read_request  (l2_mem_read_request),
        .memory_write_request (l2_mem_write_request),
        .memory_addr          (l2_mem_addr),
        .memory_write_data    (l2_mem_write_data),
        .memory_response      (l2_mem_response),
        .memory_read_data     (l2_mem_read_data)
    );

    // Simulated Memory Response (20 cycle latency)
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            mem_counter <= 0;
            mem_busy <= 0;
            l2_mem_response <= 0;
        end else begin
            l2_mem_response <= 0;
            if (l2_mem_read_request && !mem_busy) begin
                mem_counter <= 20;
                mem_busy <= 1;
            end
            if (mem_busy) begin
                mem_counter <= mem_counter - 1;
                if (mem_counter == 1) begin
                    l2_mem_read_data <= main_memory[l2_mem_addr];
                    l2_mem_response <= 1;
                    mem_busy <= 0;
                end
            end
            if (l2_mem_write_request) begin
                main_memory[l2_mem_addr] <= l2_mem_write_data;
                l2_mem_response <= 1; // write ack immediately for simplicity
            end
        end
    end

    // Test sequence
    initial begin
        $dumpfile("build/cache_hierarchy_tb.vcd");
        $dumpvars(0, cache_hierarchy_tb);

        clk                = 0;
        rst_n              = 0;
        proc_read_request  = 0;
        proc_write_request = 0;
        proc_addr          = 0;
        proc_write_data    = 0;

        // Initialize memory
        $readmemh("mem.hex", main_memory);

        // Reset
        #12;
        rst_n = 1;

        // Read address 0x0010 (L1 miss -> L2 miss -> Mem)
        proc_addr = 16'h0010;
        proc_read_request = 1;
        wait (proc_response);
        proc_read_request = 0;
        $display("Read 0x0010: %h", proc_read_data);

        // Read address 0x0010 again (should be L1 hit)
        #20;
        proc_addr = 16'h0010;
        proc_read_request = 1;
        #20; // wait for response
        //wait (proc_response);
        proc_read_request = 0;
        $display("Read 0x0010 again (L1 hit): %h", proc_read_data);

        // Read address 0x0020 (L1 miss -> L2 miss -> Mem)
        #20;
        proc_addr = 16'h0020;
        proc_read_request = 1;
        wait (proc_response);
        proc_read_request = 0;
        $display("Read 0x0020: %h", proc_read_data);

        // Write to 0x0030
        #20;
        proc_addr = 16'h0030;
        proc_write_data = 32'hABCD1234;
        proc_write_request = 1;
        $display("Writing 0x0030 with data: %h", proc_write_data);
        #20; // wait for response
        //wait (proc_response);
        proc_write_request = 0;

        // Read 0x0030 (should be hit in L1)
        #20;
        proc_addr = 16'h0030;
        proc_read_request = 1;
        #20; // wait for response
        //wait (proc_response);
        proc_read_request = 0;
        $display("Read 0x0030 after write: %h", proc_read_data);

        #100;
        $finish;
    end

endmodule
