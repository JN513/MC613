`timescale 1ns/1ps

module tb_Time();

    reg clk;
    reg rst_n;
    reg mode;
    reg [5:0] time_to_set;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instancia o módulo Time
    Time #(
        .CLOCK_FREQ(100) // Reduzido para simulação rápida
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .time_to_set(time_to_set),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Geração de clock
    always #5 clk = ~clk; // Período de 10ns = 100MHz (para o CLOCK_FREQ reduzido)

    initial begin
        // Inicialização
        clk = 0;
        rst_n = 0;
        mode = 0;
        time_to_set = 0;

        // Sequência de teste

        // Reset
        #20;
        rst_n = 1;

        // Espera um pouco
        #50;

        // Entra no modo de ajuste de hora
        mode = 1;
        #10;
        mode = 0;
        time_to_set = 6'd12; // Ajustar para 12 horas
        #20;

        // Avança para ajuste de minuto
        mode = 1;
        #10;
        mode = 0;
        time_to_set = 6'd34; // Ajustar para 34 minutos
        #20;

        // Avança para ajuste de segundo
        mode = 1;
        #10;
        mode = 0;
        time_to_set = 6'd56; // Ajustar para 56 segundos
        #20;

        // Sai do modo de ajuste e volta para modo normal
        mode = 1;
        #10;
        mode = 0;
        #100;

        // Espera ver a contagem funcionando
        #500;

        // Finaliza simulação
        $finish;
    end

    // Geração do VCD para visualizar no GTKWave
    initial begin
        $dumpfile("tb_Time.vcd");
        $dumpvars(0, tb_Time);
    end

endmodule
