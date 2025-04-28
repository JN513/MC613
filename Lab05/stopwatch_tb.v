`timescale 1ns/1ps

module tb_StopWatch();

    reg clk;
    reg rst_n;
    reg start_stop;
    reg zero;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instancia o módulo StopWatch
    StopWatch #(
        .CLOCK_FREQ(100) // Valor pequeno para simulação rápida
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_stop(start_stop),
        .zero(zero),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Geração de clock: 10ns período (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Inicializa sinais
        clk = 0;
        rst_n = 0;
        start_stop = 0;
        zero = 0;

        // Sequência de teste

        // Reset global
        #20;
        rst_n = 1;

        // Espera um pouco
        #20;

        // Start o cronômetro
        start_stop = 1;
        #10;
        start_stop = 0;

        // Deixa rodar por algum tempo
        #500;

        // Stop o cronômetro
        start_stop = 1;
        #10;
        start_stop = 0;

        // Espera com o cronômetro parado
        #100;

        // Zera o cronômetro
        zero = 1;
        #10;
        zero = 0;

        // Espera mais um pouco
        #100;

        // Finaliza simulação
        $finish;
    end

    initial begin
        $dumpfile("tb_StopWatch.vcd"); // Gera um arquivo de waveform
        $dumpvars(0, tb_StopWatch);
    end

endmodule
