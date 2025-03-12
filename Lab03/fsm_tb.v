`timescale 1ns / 1ps
module fsm_tb();

reg clk, rst;
reg r50, r100, r200;
wire cafe, t50, t100, t200;
wire [1:0] state_o;

parameter  CLK_FREQ = 2;
localparam FOUR_SECONDS = CLK_FREQ * 4;

fsm #(
    .CLK_FREQ(CLK_FREQ)
) u1 (
    .clk  (clk),
    .rst  (rst),
    .r50  (r50),
    .r100 (r100),
    .r200 (r200),
    .cafe (cafe),
    .t50  (t50),
    .t100 (t100),
    .t200 (t200),
    .state_o (state_o)
);

initial begin
    $dumpfile("build/fsm_tb.vcd");
    $dumpvars(0, fsm_tb);

    clk  = 1'b0;
    rst  = 1'b1;
    r50  = 1'b0;
    r100 = 1'b0;
    r200 = 1'b0;

    #4 rst = 1'b0;

    // Teste: Inserindo 250 sem troco
    #4 r100 = 1'b1; #2 r100 = 1'b0;
    #4 r100 = 1'b1; #2 r100 = 1'b0;
    #4 r50  = 1'b1; #2 r50  = 1'b0;
    #4;
    if (cafe !== 1'b1) begin $display("Erro: Cafe nao foi servido!"); $stop; end
    if (t50 !== 1'b0 || t100 !== 1'b0 || t200 !== 1'b0) begin $display("Erro: Troco incorreto!"); $stop; end
    if (state_o !== 2'b11) begin $display("Erro: Estado incorreto, esperado DELAY!"); $stop; end

    // Espera tempo do estado DELAY
    repeat (FOUR_SECONDS) #3;
    if (state_o !== 2'b00) begin 
    $display("Erro: Nao retornou ao estado IDLE!, estado atual:"); 
    $display(state_o);
    $stop; end

    // Teste: Inserindo 300 (troco de 50)
    #4 r200 = 1'b1; #2 r200 = 1'b0;
    #4 r100 = 1'b1; #2 r100 = 1'b0;
    #4;
    if (cafe !== 1'b1) begin $display("Erro: Cafe nao foi servido!"); $stop; end
    if (t50 !== 1'b1) begin $display("Erro: Troco incorreto!"); $stop; end
    if (state_o !== 2'b11) begin $display("Erro: Estado incorreto, esperado DELAY!"); $stop; end

    // Espera tempo do estado DELAY
    repeat (FOUR_SECONDS) #4;
    if (state_o !== 2'b00) begin $display("Erro: Nao retornou ao estado IDLE!"); $stop; end

    // Teste: Inserindo 400 (troco de 150)
    #4 r200 = 1'b1; #2 r200 = 1'b0;
    #4 r200 = 1'b1; #2 r200 = 1'b0;
    #4;
    if (cafe !== 1'b1) begin $display("Erro: Cafe nao foi servido!"); $stop; end
    if (t50 !== 1'b1 || t100 !== 1'b1) begin $display("Erro: Troco incorreto!"); $stop; end
    if (state_o !== 2'b11) begin $display("Erro: Estado incorreto, esperado DELAY!"); $stop; end

    // Espera tempo do estado DELAY
    repeat (FOUR_SECONDS) #4;
    if (state_o !== 2'b00) begin $display("Erro: Nao retornou ao estado IDLE!"); $stop; end

    // Teste: Inserindo 250 em ciclos separados
    #4 r50 = 1'b1; #2 r50 = 1'b0;
    #4 r100 = 1'b1; #2 r100 = 1'b0;
    #4 r100 = 1'b1; #2 r100 = 1'b0;
    #4;
    if (cafe !== 1'b1) begin $display("Erro: Cafe nao foi servido!"); $stop; end
    if (t50 !== 1'b0 || t100 !== 1'b0) begin $display("Erro: Troco incorreto!"); $stop; end
    if (state_o !== 2'b11) begin $display("Erro: Estado incorreto, esperado DELAY!"); $stop; end

    // Espera tempo do estado DELAY
    repeat (FOUR_SECONDS) #4;
    if (state_o !== 2'b00) begin $display("Erro: Nao retornou ao estado IDLE!"); $stop; end

    // Teste: Inserindo valores inválidos e garantindo que não há café antes dos 250
    #4 r50 = 1'b1; #2 r50 = 1'b0;
    #4;
    if (cafe !== 1'b0) begin $display("Erro: Cafe servido antes do esperado!"); $stop; end

    $display("Testes finalizados com sucesso!");
    $finish;
end

always #1 clk = ~clk;

endmodule