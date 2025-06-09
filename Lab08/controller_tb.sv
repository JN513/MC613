`timescale 1ns/1ps

module controller_tb ();

localparam SYS_CLK_FREQ = 133_000_000;
localparam CLK_PERIOD = 1_000_000_000 / SYS_CLK_FREQ;

logic sys_clk;
logic rst_n;
logic dram_dq_we;
logic [15:0] dram_dq_out, dram_dq_in;
logic [15:0] write_data;
logic [15:0] read_data, read_data_reg;
logic [24:0] addr;
logic write, read, ack, busy;

// SDRAM mock signals
tri [15:0] DRAM_DQ;
logic [12:0] DRAM_ADDR;
logic [1:0]  DRAM_BA;
logic        DRAM_CLK;
logic        DRAM_CKE;
logic        DRAM_LDQM;
logic        DRAM_UDQM;
logic        DRAM_WE_N;
logic        DRAM_CAS_N;
logic        DRAM_RAS_N;
logic        DRAM_CS_N;

assign dram_dq_in = DRAM_DQ;
assign DRAM_DQ    = (dram_dq_we) ? dram_dq_out : 16'bz;

// DUT
Sdram_Ctrl #(
    .MEM_SIZE         (1024 * 1024 * 64),
    .SDRAM_CLK_FREQ   (133_000_000),
    .SDRAM_WORD_SIZE  (16),
    .SDRAM_COL_WIDTH  (13),
    .SDRAM_ROW_WIDTH  (10),
    .SDRAM_BANK_WIDTH (2),
    .SDRAM_ADDR_WIDTH (13)
) u_sdram_ctrl (
    .sys_clk     (sys_clk),
    .sys_rst_n   (rst_n),
    .addr_i      (addr),
    .data_i      (write_data),
    .we_i        (write),
    .re_i        (read),
    .data_o      (read_data),
    .ack_o       (ack),
    .busy_o      (busy),
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

localparam INITIALIZATION_NS     = 100_000;
localparam INITIALIZATION_CYCLES = INITIALIZATION_NS / CLK_PERIOD;

// Clock generation
always #(CLK_PERIOD/2) sys_clk = ~sys_clk;

// VCD
initial begin
    $dumpfile("controller_tb.vcd");
    $dumpvars(0, controller_tb);
end

// Stimulus
initial begin
    sys_clk     = 0;
    rst_n       = 0;
    addr        = 25'h000_0000;
    write_data  = 16'hABCD;
    read        = 0;
    write       = 0;

    $display("[%0t] >> Iniciando Testbench", $time);

    // Reset
    #(CLK_PERIOD * 2);
    rst_n = 1;
    $display("[%0t] >> Reset desativado", $time);

    #(INITIALIZATION_CYCLES * CLK_PERIOD)

    $display("[%0t] >> Iniciando escrita", $time);

    // WRITE
    @(negedge sys_clk);
    addr       <= 25'h000_0100;
    write_data <= 16'hCAFE;
    write      <= 1;

    @(posedge sys_clk);
    write <= 0;

    $display("[%0t] >> Aguardando ACK da escrita...", $time);
    wait_ack();

    repeat (10) @(posedge sys_clk);

    $display("[%0t] >> Iniciando leitura", $time);

    // READ
    addr <= 25'h000_0100;
    read <= 1;
    @(posedge sys_clk);
    read <= 0;

    $display("[%0t] >> Aguardando ACK da leitura...", $time);
    wait_ack();
    read_data_reg <= read_data;

    $display("[%0t] >> Leitura concluída, dado lido = 0x%04X", $time, read_data_reg);


    $finish;
end

// Espera por transição de ack para 1
task wait_ack;
    wait (ack == 1);
    $display("[%0t] >> ACK recebido", $time);
    wait (ack == 0);
    @(posedge sys_clk);  // espera cair
    $display("[%0t] >> ACK encerrado", $time);
endtask

// Timeout para evitar loop infinito
initial begin
    #(5_000_000 * CLK_PERIOD); // 1ms em simulação (ajuste conforme necessário)
    $display("❗ TIMEOUT: simulação muito longa");
    $finish;
end

endmodule
