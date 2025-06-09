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
localparam TWO_SECONDS  = 2 * SYS_CLK_FREQ;

logic sys_clk;
logic rst_n;
logic dram_dq_we;
logic [15:0] dram_dq_out, dram_dq_in;
logic [9:0] sw_reg, leds_reg;
logic read_btn, write_btn;
logic [15:0] write_data;
logic [15:0] read_data, read_data_reg;
logic [24:0] addr;
logic write, read, ack, busy;
logic [23:0] display_data;
logic [31:0] counter;

assign LEDR = leds_reg;

initial begin
    state      = INIT;
    write_data = 0;
    addr       = 0;
    write      = 0;
    read       = 0;
end

typedef enum logic [3:0] { 
    INIT,
    DELAY,
    IDLE,
    READ,
    READ_WB,
    READ_DISPLAY,
    WRITE,
    WRITE_WAIT,
    WRITE_OPERATION,
    WRITE_ACK,
    DELAY_2
} state_t;

state_t state;

always_ff @( posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        leds_reg   <= 0;
        state      <= INIT;
        addr       <= 0;
        write_data <= 0;
        read       <= 0;
        write      <= 0;
    end else begin
        case (state)
            INIT: begin
                read    <= 0;
                write   <= 0;
                state   <= DELAY;
                counter <= 0;
            end

            DELAY: begin
                if(counter < 1_000_000) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    state   <= IDLE;
                end
            end

            IDLE: begin
                read      <= 0;
                write     <= 0;
                addr      <= {6'h0, sw_reg};
                leds_reg  <= 10'h001;
                if(write_btn) begin
                    state <= WRITE;
                end else if(read_btn) begin
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
                read <= 0;
                if(ack) begin
                    state         <= READ_DISPLAY;
                    read_data_reg <= read_data;
                    counter       <= 0;
                end
            end

            READ_DISPLAY: begin
                leds_reg  <= 10'h002;
                if(counter >= TWO_SECONDS) begin
                    counter <= 0;
                    state   <= IDLE;
                end else begin
                    counter <= counter + 1;
                end
            end

            WRITE: begin
                leds_reg  <= 10'h004;
                if(write_btn) begin
                    write_data <= {6'h0, sw_reg};
                    state      <= WRITE_WAIT;
                end
            end

            WRITE_WAIT: begin
                state <= WRITE_OPERATION;
            end

            WRITE_OPERATION: begin
                leds_reg  <= 10'h008;
                if(!busy) begin
                    write <= 1;
                    state <= WRITE_ACK;
                end
            end

            WRITE_ACK: begin
                write <= 0;
                if(ack) begin
                    state <= DELAY_2;
                end
            end

            DELAY_2: begin
                if(counter < 10) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    state   <= IDLE;
                end
            end
        endcase
    end
end

pll pll1 (
    .refclk   (CLOCK_50),  // refclk.clk
    .rst      (~auto_rst), // reset.reset
    .outclk_0 (sys_clk)    // outclk0.clk
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

always_ff @( posedge sys_clk ) begin : DISPLAY_LOGIC
    case (state)
        IDLE :        display_data <= {14'h0, sw_reg};
        WRITE:        display_data <= {14'h0, sw_reg};
        READ_DISPLAY: display_data <= {8'h00, read_data_reg};
        default: display_data <= {14'h0, sw_reg};
    endcase
end

bin2hex U1 (
    .bin (display_data[3:0]),
    .hex (HEX0)
);
bin2hex U2 (
    .bin (display_data[7:4]),
    .hex (HEX1)
);
bin2hex U3 (
    .bin (display_data[11:8]),
    .hex (HEX2)
);
bin2hex U4 (
    .bin (display_data[15:12]),
    .hex (HEX3)
);
bin2hex U5 (
    .bin (display_data[19:16]),
    .hex (HEX4)
);
bin2hex U6 (
    .bin (display_data[23:20]),
    .hex (HEX5)
);

// Reset logic

logic btn_rst, auto_rst;
logic [1:0] stt;

always_ff @( posedge CLOCK_50 ) begin
    case (stt)
        0: begin
            auto_rst <= 0;
            stt      <= 1;
        end
        1: begin
            auto_rst <= 0;
            stt      <= 2;
        end 
        2: begin
            auto_rst <= 1;
        end
    endcase
end

// Buttons boucing logic

logic posedge_btn1, posedge_btn2, posedge_btn3, posedge_btn4;
logic [2:0] posedge_reg1, posedge_reg2, posedge_reg3, posedge_reg4;

initial begin
    stt          = 0;
    posedge_reg1 = 0;
    posedge_reg2 = 0;
    posedge_reg3 = 0;
    posedge_reg4 = 0;
end

always_ff @(posedge sys_clk ) begin   
    posedge_reg1 <= {posedge_reg1[1:0], !KEY[0]};
    posedge_reg2 <= {posedge_reg2[1:0], !KEY[1]};
    posedge_reg3 <= {posedge_reg3[1:0], !KEY[2]};
    posedge_reg4 <= {posedge_reg4[1:0], !KEY[3]};
    sw_reg       <= SW;
end

assign posedge_btn1 = posedge_reg1[2:1] == 2'b01;
assign posedge_btn2 = posedge_reg2[2:1] == 2'b01;
assign posedge_btn3 = posedge_reg3[2:1] == 2'b01;
assign posedge_btn4 = posedge_reg4[2:1] == 2'b01;

assign btn_rst   = ~posedge_btn1;
assign rst_n     = btn_rst & auto_rst;
assign read_btn  = posedge_btn3;
assign write_btn = posedge_btn4;

endmodule
