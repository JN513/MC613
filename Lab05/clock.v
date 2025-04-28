module Clock (
    input  wire CLOCK_50,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    input  wire [3:0] KEY,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);
    
reg state; // 0 clock 1 stopwatch
wire rst_n;
wire btn3_time, btn3_stopwatch;

wire posedge_btn1, posedge_btn2, posedge_btn3, posedge_btn4;
reg [2:0] posedge_reg1, posedge_reg2, posedge_reg3, posedge_reg4;

wire [6:0] hex0_time, hex1_time, hex2_time, hex3_time, hex4_time, hex5_time;
wire [6:0] hex0_stopwatch, hex1_stopwatch, hex2_stopwatch, hex3_stopwatch, hex4_stopwatch, hex5_stopwatch;

// Instanciação do módulo Time
Time #(
    .CLOCK_FREQ  (50_000_000) // Definindo a frequência de clock como 50 MHz
) inst_time (
    .clk         (CLOCK_50), // Conectando o sinal de clock ao módulo
    .rst_n       (rst_n), // Conectando o reset negativo ao módulo
    .mode        (btn3_time), // Indica qual modo: tempo, ajuste de hora, minuto e segundo
    .time_to_set (SW), // Valor para definir (hora, minuto ou segundo)
    
    .HEX0        (hex0_time), // Saída numérica em formato 7-segmento
    .HEX1        (hex1_time),
    .HEX2        (hex2_time),
    .HEX3        (hex3_time),
    .HEX4        (hex4_time),
    .HEX5        (hex5_time)
);

// Instanciação do módulo StopWatch
StopWatch #(
    .CLOCK_FREQ  (50_000_000) // Definindo a frequência de clock como 50 MHz
) inst_stopwatch (
    .clk        (CLOCK_50), // Conectando o sinal de clock ao módulo
    .rst_n      (rst_n), // Conectando o reset negativo ao módulo
    .start_stop (btn3_stopwatch), // Indica se deve iniciar ou parar o cronômetro
    .zero       (posedge_btn2), // Limpa o tempo do cronômetro
    
    .HEX0       (hex0_stopwatch), // Saída numérica em formato 7-segmento para as dezenas de segundos
    .HEX1       (hex1_stopwatch), // Saída numérica em formato 7-segmento para os segundos
    .HEX2       (hex2_stopwatch),
    .HEX3       (hex3_stopwatch),
    .HEX4       (hex4_stopwatch),
    .HEX5       (hex5_stopwatch)  // Saídas adicionais que podem ser usadas para exibir o tempo em painéis LED ou displays 7-segmento
);


always @(posedge CLOCK_50 ) begin
    if(!rst_n) begin
        state <= 0;
    end else begin
        if(posedge_btn4) begin
            state <= ~state;
        end
    end
    
    posedge_reg1 <= {posedge_reg1[1:0], !KEY[0]};
    posedge_reg2 <= {posedge_reg2[1:0], !KEY[1]};
    posedge_reg3 <= {posedge_reg3[1:0], !KEY[2]};
    posedge_reg4 <= {posedge_reg4[1:0], !KEY[3]};
end

assign rst_n = ~posedge_btn1;

assign posedge_btn1 = posedge_reg1[2:1] == 2'b01;
assign posedge_btn2 = posedge_reg2[2:1] == 2'b01;
assign posedge_btn3 = posedge_reg3[2:1] == 2'b01;
assign posedge_btn4 = posedge_reg4[2:1] == 2'b01;

assign HEX0 = (state) ? hex0_stopwatch : hex0_time;
assign HEX1 = (state) ? hex1_stopwatch : hex1_time;
assign HEX2 = (state) ? hex2_stopwatch : hex2_time;
assign HEX3 = (state) ? hex3_stopwatch : hex3_time;
assign HEX4 = (state) ? hex4_stopwatch : hex4_time;
assign HEX5 = (state) ? hex5_stopwatch : hex5_time;

assign btn3_time = (!state) ? posedge_btn3 : 1'b0;
assign btn3_stopwatch = (state) ? posedge_btn3 : 1'b0;

endmodule