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

logic sys_clk;
logic rst_n;
logic dram_dq_we;
logic [15:0] dram_dq_out, dram_dq_in;


initial begin
	rst_n = 1;
    write = 0;
    read  = 0;
end


logic [31:0] write_data;
logic [31:0] read_data;
logic [31:0] addr;
logic write, read, ack, busy, pass, fail;

logic [31:0] counter;

assign LEDR = {pass, fail_addr ,fail};

typedef enum logic [2:0] { 
    INIT,
    DELAY,
    WRITE,
    DELAY_2,
    READ,
    READ_WB,
    COMPAIR,
    DONE
} state_t;

state_t state;

logic [1:0] stt;

initial begin
    state = INIT;
    stt = 0;
    write_data = 32'h000005A5;
    addr = 0;
    counter_addr = 0;
    counter = 0;
end

always_ff @( posedge CLOCK_50 ) begin
    case (stt)
        0: begin
            rst_n <= 0;
            stt <= 1;
        end
        1: begin
            rst_n <= 0;
            stt <= 2;
        end 
        2: begin
            rst_n <= 1;
        end
    endcase
end

logic [25:0] counter_addr;
logic [8:0] fail_addr;

always_ff @( posedge sys_clk ) begin
    read  <= 0;
    write <= 0;

    if(!rst_n) begin
        state      <= INIT;
        pass       <= 0;
        fail       <= 0;
        addr       <= 0;
        counter_addr <= 0;
        fail_addr <= 0;
        write_data <= 32'h000005A5;
    end else begin
        case (state)
            INIT: begin
                state <= DELAY;
            end

            DELAY: begin
                if(counter < 1_000_000) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    state <= WRITE;
                end
            end

            WRITE: begin
                if(!busy) begin
                    write <= 1;
                    state <= DELAY_2;
                end
            end

            DELAY_2: begin
                if(counter < 10) begin
                    counter <= counter + 1;
                end else begin
                    write_data <= 0;
                    counter    <= 0;
                    state <= READ;
                end
            end

            READ: begin
                if(!busy) begin
                    read <= 1;
                    state <= READ_WB;
                end
            end

            READ_WB: begin
                if(ack) begin
                    state <= COMPAIR;
                end
            end

            COMPAIR: begin
                if(read_data[15:0] === write_data[15:0]) begin
                    pass <= 1;
                end else begin
                    //pass <= 0;
                    fail <= 1;
                    fail_addr <= counter_addr;
                end
                if(counter_addr < 0) begin
                    counter_addr <= counter_addr + 1;
                    addr <= addr + 1;
                    write_data <= write_data + 1;
                    state <= INIT;
                end else begin
                    state <= DONE;
                end

            end

            DONE: begin
                
            end
        endcase
    end
end

pll pll1 (
    .refclk   (CLOCK_50), // refclk.clk
    .rst      (~rst_n),   // reset.reset
    .outclk_0 (sys_clk)   // outclk0.clk
);

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

bin2hex U1 (
    .bin (read_data[3:0]),
    .hex (HEX0)
);
bin2hex U2 (
    .bin (read_data[7:4]),
    .hex (HEX1)
);
bin2hex U3 (
    .bin (read_data[11:8]),
    .hex (HEX2)
);
bin2hex U4 (
    .bin (read_data[15:12]),
    .hex (HEX3)
);
bin2hex U5 (
    .bin (0),
    .hex (HEX4)
);
bin2hex U6 (
    .bin (0),
    .hex (HEX5)
);
    
endmodule
