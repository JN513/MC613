module Sdram_Ctrl #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MEM_SIZE = 1024 * 1024 * 64, // 64MB
    parameter SDRAM_CLK_FREQ = 100_000_000, // 100 MHz
    parameter SDRAM_WORD_SIZE = 16, // 16 bits per word
    parameter SDRAM_COL_WIDTH = 13, // Number of column
    parameter SDRAM_ROW_WIDTH = 10, // Number of row
    parameter SDRAM_BANK_WIDTH = 2, // Number of banks
    parameter SDRAM_ADDR_WIDTH = 13
) (
    input  logic sys_clk,
    input  logic sys_rst_n,

    // Processor interface
    input  logic [ADDR_WIDTH-1:0] addr_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    input  logic we_i, // Write enable
    input  logic re_i, // Read enable
    output logic [DATA_WIDTH-1:0] data_o,
    output logic ack_o, // Acknowledge signal

    // SDRAM interface
    inout  logic [15:0] dram_dq,
    output logic [12:0] dram_addr,
    output logic [1:0] dram_ba, // Bank address
    output logic dram_clk, // Clock signal
    output logic dram_cke, // Clock enable
    output logic dram_ldqm, // Load mode register
    output logic dram_udqm, // Data mask signals
    output logic dram_we_n, // Write enable
    output logic dram_cas_n, // Column address strobe
    output logic dram_ras_n, // Row address strobe
    output logic dram_cs_n // Chip select
);

//SDRAM Commands [CS_N,RAS_N,CAS_N,WE_N]
localparam DESL = 4'b1000;                                    //Device deselect
localparam NOP = 4'b0111;                                     //No operation
localparam BST = 4'b0110;                                     //Burst stop
localparam RD = 4'b0101;                                      //For read with auto precharge A10 is '1' else '0'
localparam WRT = 4'b0100;                                     //For write with auto precharge A10 is '1' else '0'
localparam ACT = 4'b0011;                                     //Activate
localparam PRE = 4'b0010;                                     //Precharge. To precharge all banks A10 is '1' else '0'
localparam REF = 4'b0001;                                     //CBR auto-refrsh. For self-refresh toggle CKE along with CS_N
localparam MRS = 4'b0000;                                     //Mode register set

typedef enum logic [3:0] { 
    IDLE = 4'b0000,
    INIT = 4'b0001,
    PRECHARGE = 4'b0010,
    WAIT = 4'b0011,
    AUTO_REFRESH = 4'b0100,
    MODE_REG_SET = 4'b0101,
    ACTIVE = 4'b0111,
    WRITE = 4'b1000,
    READ = 4'b1001,
    READ_DOUT = 4'b1010
} state_t;

    
endmodule