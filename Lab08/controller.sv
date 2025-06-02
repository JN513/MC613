module Sdram_Ctrl #(
    parameter DATA_WIDTH       = 32,
    parameter ADDR_WIDTH       = 32,
    parameter MEM_SIZE         = 1024 * 1024 * 64, // 64MB
    parameter SDRAM_CLK_FREQ   = 100_000_000, // 100 MHz
    parameter SDRAM_WORD_SIZE  = 16, // 16 bits per word
    parameter SDRAM_COL_WIDTH  = 10, // Number of column
    parameter SDRAM_ROW_WIDTH  = 13, // Number of row
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
    output logic busy_o, // Busy signal

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
    WRITE_ACK,
    READ,
    READ_WB
} state_t;

state_t current_state, state_after_wait;
logic [15:0] time_counter;
logic [15:0] read_counter;
logic [3:0] command;
logic [1:0] latency;

logic auto_reflesh_peding;
logic write_operation;

localparam MODE_REGISTER_MODE = 13'b0001000100000; //Latency=2, burst length=1, single access write operation

always_ff @( posedge sys_clk ) begin
    if(!sys_rst_n) begin
        current_state    <= POWER_DOWN;
        state_after_wait <= POWER_DOWN;
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
                current_state    <= WAIT_MEMORY;
                state_after_wait <= MODE_REGISTER_SET;
            end
            MODE_REGISTER_SET: begin
                time_counter     <= 8; // 60 ns REF to REF
                current_state    <= WAIT_MEMORY;
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
                state_after_wait <= WRITE_ACK;
                current_state    <= WAIT_MEMORY;
            end

            WRITE_ACK: begin
                time_counter     <= 0;
                current_state    <= IDLE;
            end

            READ: begin
                read_counter  <= 0; // Reset read counter
                time_counter  <= 0; // Latency for read operation
                current_state <= READ_WB;
            end

            READ_WB: begin
                time_counter     <= 2; // 15 ns TRP
                if(read_counter < latency - 1) begin
                    read_counter <= read_counter + 1; // Increment read counter
                    current_state <= READ_WB; // Stay in READ_WB state until latency is met
                end else begin
                    current_state    <= WAIT_MEMORY;
                    state_after_wait <= IDLE; // After read, go back to IDLE
                end
            end
            default: begin
                current_state <= POWER_DOWN;
            end
        endcase
    end
end


always_ff @(posedge sys_clk) begin
    if(!sys_rst_n) begin
        busy_o      <= 0;
        ack_o       <= 0;
        command     <= DESL; // Device deselect
        dram_dq_out <= 0;
        dram_addr   <= 0;
        dram_ba     <= 0;
        dram_cke    <= 0; // Clock enable low
        dram_ldqm   <= 0; // Load mode register low
        dram_udqm   <= 0; // Data mask signals low
        dram_dq_we  <= 0; // Data write enable low
    end else begin
        case (current_state)
            POWER_DOWN: begin
                command    <= DESL; // Device deselect
                dram_cke   <= 0; // Clock enable low
                dram_ldqm  <= 0; // Load mode register low
                dram_udqm  <= 0; // Data mask signals low
                busy_o     <= 0;
                dram_dq_we <= 0; // Data write enable low
            end
            INITIALIZATION: begin
                dram_cke   <= 1; // Clock enable high
                dram_ldqm  <= 1; // Load mode register low
                dram_udqm  <= 1; // Data mask signals low
            end
            WAIT_MEMORY: begin

            end

            PRECHARGE_INITIALIZATION: begin
                command        <= PRE; // Precharge all banks
                dram_addr[10]  <= 1; // Address is not used in this command
            end

            AUTO_REFRESH_START: begin
                command <= REF; // CBR auto-refresh
            end
            AUTO_REFRESH_FINISH: begin
                command <= REF; // No operation
            end

            MODE_REGISTER_SET: begin
                command         <= MRS; // Mode register set
                dram_addr[12:0] <= MODE_REGISTER_MODE[12:0]; // Set mode register value
                dram_ba         <= 2'b00;
                busy_o          <= 1; // Busy during mode register set

                latency <= (MODE_REGISTER_MODE[6:4]) ? 2'b10 : 2'b11;
            end

            IDLE: begin
                command    <= NOP; // No operation
                busy_o     <= 0;   // Not busy
                dram_dq_we <= 0;   // Data write enable low
                dram_ldqm  <= 0;   // Load mode register low
                dram_udqm  <= 0;   // Data mask signals low
            end

            AUTO_REFLESH: begin
                command <= REF; // CBR auto-refresh
                busy_o  <= 1; // Busy during auto-refresh
            end

            ACTIVATE: begin
                command         <= ACT; // Activate command
                dram_addr[12:0] <= addr_i[22:10]; // Set row address
                dram_ba         <= addr_i[24:23]; // Set bank address
                busy_o          <= 1; // Busy during activation
            end

            WRITE: begin
                command        <= WRT; // Write command
                dram_addr[9:0] <= addr_i[9:0]; // Set cow address
                dram_addr[10]  <= 1; // Auto precharge
                dram_dq_we     <= 1; // Data write enable high
                dram_dq_out    <= data_i[15:0]; // Output data to SDRAM
                dram_ldqm      <= 0; // Load mode register low
                dram_udqm      <= 0; // Data mask signals low
            end

            WRITE_ACK: begin
                ack_o      <= 1; // Acknowledge write operation
                busy_o     <= 0; // Not busy after write
                dram_dq_we <= 0; // Data write enable low
            end

            READ: begin
                command        <= RD; // Read command
                dram_addr[9:0] <= addr_i[9:0]; // Set cow address
                dram_addr[10]  <= 1; // Auto precharge
                dram_ldqm      <= 0; // Load mode register low
                dram_udqm      <= 0; // Data mask signals low
            end

            READ_WB: begin
                if(read_counter >= latency - 1) begin
                    ack_o      <= 1; // Acknowledge read operation
                    busy_o     <= 0; // Not busy after read
                end
                dram_dq_we <= 0; // Data write enable low
                data_o     <= dram_dq_in; // Read data from SDRAM
            end

        endcase
    end
end


// Auto refresh

logic [9:0] refresh_counter;
logic auto_reflesh_en;

always_ff @( posedge sys_clk ) begin
    if(!sys_rst_n) begin
        refresh_counter <= 0;
        auto_reflesh_peding <= 0;
        auto_reflesh_en <= 0;
    end begin
        if(refresh_counter < 782 && auto_reflesh_en) begin
            auto_reflesh_peding <= 0;
            refresh_counter <= refresh_counter + 1;
        end else if(auto_reflesh_en) begin
            auto_reflesh_peding <= 1;
            if(!busy_o)
                refresh_counter <= 0;
        end else if(current_state == IDLE && !auto_reflesh_en) begin
            auto_reflesh_en <= 1'b1;
        end
    end
end

assign {dram_cs_n, dram_ras_n, dram_cas_n, dram_we_n} = command;
assign dram_clk   = sys_clk;
    
endmodule