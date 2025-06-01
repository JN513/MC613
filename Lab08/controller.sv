module Sdram_Ctrl #(
    parameter DATA_WIDTH       = 32,
    parameter ADDR_WIDTH       = 16,
    parameter MEM_SIZE         = 1024 * 1024 * 64, // 64MB
    parameter SDRAM_CLK_FREQ   = 100_000_000, // 100 MHz
    parameter SDRAM_WORD_SIZE  = 16, // 16 bits per word
    parameter SDRAM_COL_WIDTH  = 13, // Number of column
    parameter SDRAM_ROW_WIDTH  = 10, // Number of row
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
    input  logic [15:0] dram_dq_in,
    output logic [15:0] dram_dq_out,
    output logic [12:0] dram_addr,
    output logic [1:0] dram_ba,    // Bank address
    output logic dram_clk,         // Clock signal
    output logic dram_cke,         // Clock enable
    output logic dram_ldqm,        // Load mode register
    output logic dram_udqm,        // Data mask signals
    output logic dram_we_n,        // Write enable
    output logic dram_cas_n,       // Column address strobe
    output logic dram_ras_n,       // Row address strobe
    output logic dram_cs_n,         // Chip select
    output logic dram_dq_we
);

//SDRAM Commands [CS_N,RAS_N,CAS_N,WE_N]
localparam DESL = 4'b1000; //Device deselect
localparam NOP  = 4'b0111; //No operation
localparam BST  = 4'b0110; //Burst stop
localparam RD   = 4'b0101; //For read with auto precharge A10 is '1' else '0'
localparam WRT  = 4'b0100; //For write with auto precharge A10 is '1' else '0'
localparam ACT  = 4'b0011; //Activate
localparam PRE  = 4'b0010; //Precharge. To precharge all banks A10 is '1' else '0'
localparam REF  = 4'b0001; //CBR auto-refrsh. For self-refresh toggle CKE along with CS_N
localparam MRS  = 4'b0000; //Mode register set

localparam INITIALIZATION_NS     = 100_000;
localparam CLK_PERIOD            = 7.52;
localparam INITIALIZATION_CYCLES = INITIALIZATION_NS / CLK_PERIOD;

typedef enum logic [3:0] { 
    POWER_DOWN,
    INITIALIZATION,
    WAIT_MEMORY,
    PRECHARGE_INITIALIZATION,
    AUTO_REFRESH_START,
    AUTO_REFRESH_FINISH,
    MODE_REGISTER_SET,
    IDLE,
    AUTO_REFLESH,
    ACTIVATE,
    PRECHARGE,
    WRITE,
    READ,
    READ_WB
} state_t;

state_t current_state, state_after_wait;
logic [15:0] time_counter;
logic [3:0] command;

logic auto_reflesh_peding;
logic write_operation;

localparam MODE_REGISTER_MODE = 16'b0000000000000000; // Example mode register value, adjust as needed

always_ff @( posedge sys_clk ) begin
    if(!sys_rst_n) begin
        current_state    <= POWER_DOWN;
        state_after_wait <= POWER_DOWN;
        dram_dq_we       <= 0;
        dram_addr        <= 0;
    end else begin
        case (current_state)
            POWER_DOWN: current_state <= INITIALIZATION;
            WAIT_MEMORY: begin
                if(time_counter <= 1) begin
                    current_state <= state_after_wait;
                end else begin
                    time_counter  <= time_counter - 1;
                end
            end
            INITIALIZATION: begin
                time_counter     <= INITIALIZATION_CYCLES;
                current_state    <= WAIT_MEMORY;
                state_after_wait <= PRECHARGE_INITIALIZATION;
            end
            PRECHARGE_INITIALIZATION: begin
                time_counter     <= 2; // 15 ns PRE to ACT
                current_state    <= WAIT_MEMORY;
                state_after_wait <= AUTO_REFRESH_START;
            end
            AUTO_REFRESH_START: begin
                time_counter     <= 8; // 60 ns REF to REF
                current_state    <= WAIT_MEMORY;
                state_after_wait <= AUTO_REFRESH_FINISH;
            end
            AUTO_REFRESH_FINISH: begin
                time_counter     <= 8; // 60 ns REF to REF
                current_state <= WAIT_MEMORY;
                state_after_wait <= MODE_REGISTER_SET;
            end
            MODE_REGISTER_SET: begin
                time_counter     <= 8; // 60 ns REF to REF
                current_state  <= WAIT_MEMORY;
                state_after_wait <= IDLE;
            end
            IDLE: begin
                if(auto_reflesh_peding) begin
                    current_state <= AUTO_REFLESH;
                end else if(we_i || re_i) begin
                    current_state <= ACTIVATE;
                end else begin
                    current_state <= IDLE;
                end
            end
            AUTO_REFLESH: begin
                time_counter     <= 8; // 60 ns REF to REF
                current_state    <= WAIT_MEMORY;
                state_after_wait <= IDLE;
            end
            ACTIVATE: begin
                time_counter     <= 2; // 15 ns TRCD
                current_state    <= IDLE;
                state_after_wait <= (write_operation) ? WRITE : READ;
            end

            WRITE: begin
                time_counter     <= 2; // 15 ns TRP
                state_after_wait <= IDLE;
                current_state    <= WAIT_MEMORY;
            end

            READ: begin
                current_state <= READ_WB;
            end

            READ_WB: begin
                time_counter     <= 2; // 15 ns TRP
                current_state    <= WAIT_MEMORY;
                state_after_wait <= IDLE;
            end
            default: begin
                current_state <= POWER_DOWN;
            end
        endcase
    end
end


assign {dram_cs_n, dram_ras_n, dram_cas_n, dram_we_n} = command;
assign dram_clk   = sys_clk;
    
endmodule