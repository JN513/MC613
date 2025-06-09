module Controller_Board (
    input  logic CLOCK_50,
    input  logic [9:0] SW,
    output logic [9:0] LEDR,
    input  logic [3:0] KEY,
    output logic [0:6] HEX0,
    output logic [0:6] HEX1,
    output logic [0:6] HEX2,
    output logic [0:6] HEX3,
    output logic [0:6] HEX4,
    output logic [0:6] HEX5,

    // SDRAM interface
    inout  logic [15:0] DRAM_DQ,
    output logic [12:0] DRAM_ADDR,
    output logic [1:0]  DRAM_BA,    // Bank address
    output logic        DRAM_CLK,   // Clock signal
    output logic        DRAM_CKE,   // Clock enable
    output logic        DRAM_LDQM,  // Load mode register
    output logic        DRAM_UDQM,  // Data mask signals
    output logic        DRAM_WE_N,  // Write enable
    output logic        DRAM_CAS_N, // Column address strobe
    output logic        DRAM_RAS_N, // Row address strobe
    output logic        DRAM_CS_N   // Chip select
);

localparam SYS_CLK_FREQ = 133_000_000;

logic sys_clk;
logic rst_n;
logic dram_dq_we;
logic [15:0] dram_dq_out, dram_dq_in;
logic [15:0] write_data;
logic [15:0] read_data, read_data_reg;
logic [24:0] addr;
logic write, read, ack, busy;



Sdram_Ctrl #(
    .MEM_SIZE         (1024 * 1024 * 64), // 64MB
    .SDRAM_CLK_FREQ   (133_000_000), // 100 MHz
    .SDRAM_WORD_SIZE  (16), // 16 bits per word
    .SDRAM_COL_WIDTH  (13),
    .SDRAM_ROW_WIDTH  (10),
    .SDRAM_BANK_WIDTH (2),
    .SDRAM_ADDR_WIDTH (13)
) u_sdram_ctrl (
    .sys_clk     (sys_clk),
    .sys_rst_n   (rst_n),

    // Processor interface
    .addr_i      (addr),
    .data_i      (write_data),
    .we_i        (write),
    .re_i        (read),
    .data_o      (read_data),
    .ack_o       (ack),
    .busy_o      (busy),

    // SDRAM interface
    .dram_dq_in  (dram_dq_in),
    .dram_dq_out (dram_dq_out),
    .dram_addr   (DRAM_ADDR),
    .dram_ba     (DRAM_BA),
    .dram_clk    (DRAM_CLK),
    .dram_cke    (DRAM_CKE),
    .dram_ldqm   (DRAM_LDQM),
    .dram_udqm   (DRAM_UDQM),
    .dram_we_n   (DRAM_WE_N),
    .dram_cas_n  (DRAM_CAS_N),
    .dram_ras_n  (DRAM_RAS_N),
    .dram_cs_n   (DRAM_CS_N),
    .dram_dq_we  (dram_dq_we)
);

assign dram_dq_in = DRAM_DQ;
assign DRAM_DQ    = (dram_dq_we) ? dram_dq_out : 16'bz;


endmodule
