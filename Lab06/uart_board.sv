module UART_BOARD #(
    parameter BIT_RATE = 115200,  // Baud rate
    parameter CLK_FREQ = 50000000 // Clock frequency
) (
    input  logic CLOCK_50,

    input  logic [9:0] SW,
    input  logic [3:0] KEY,

    output logic [9:0] LEDR,
    output logic [0:6] HEX0,
    output logic [0:6] HEX1,
    output logic [0:6] HEX2,
    output logic [0:6] HEX3,
    output logic [0:6] HEX4,
    output logic [0:6] HEX5,

    inout  logic [35:0] GPIO_1
);
    

logic rst_n;
logic clk;
logic rx, tx;

assign rx = GPIO_1[0];
assign GPIO_1[1] = tx;

logic busy_tx, rx_ready, error_parity;
logic [7:0] received_data;
logic [23:0] uart_data;

UART #(
    .BIT_RATE (115200),  // Baud rate (pode ser alterado conforme necessário)
    .CLK_FREQ (50000000) // Clock frequency (pode ser alterado conforme necessário)
) uart_inst (
    .clk           (clk),           // Porta de clock
    .rst_n         (rst_n),         // Sinal de reset ativo baixo
    .rx            (rx),            // Entrada do receptor UART
    .tx            (tx),            // Saída do transmissor UART
    .uart_tx_en    (posedge_btn4),  // Habilita a transmissão
    .uart_tx_data  (SW[7:0]),       // Dados de 8 bits para enviar
    .uart_tx_busy  (busy_tx),       // Indica se há uma transmissão em progresso
    .uart_rx_valid (rx_ready),      // Sinal que indica dados válidos disponíveis na saída
    .uart_rx_data  (received_data), // Dados recebidos de 8 bits
    .parity_error  (error_parity)   // Indica um erro de paridade
);

assign LEDR[0] = busy_tx; // Indica se o transmissor está ocupado
assign LEDR[1] = rx_ready; // Indica se os dados recebidos são válidos
assign LEDR[2] = error_parity; // Indica erro de paridade
assign LEDR[9:3] = 0; // Limpa os LEDs restantes

// Buttons boucing logic

logic btn3_time, btn3_stopwatch;

logic posedge_btn1, posedge_btn2, posedge_btn3, posedge_btn4;
logic [2:0] posedge_reg1, posedge_reg2, posedge_reg3, posedge_reg4;

always_ff @(posedge CLOCK_50 ) begin   
    if(!rst_n) begin
        uart_data <= 0;
    end else begin
        if(rx_ready) begin
            uart_data <= {uart_data[15:0], received_data};
        end
    end
end


always_ff @(posedge CLOCK_50 ) begin   
    posedge_reg1 <= {posedge_reg1[1:0], !KEY[0]};
    posedge_reg2 <= {posedge_reg2[1:0], !KEY[1]};
    posedge_reg3 <= {posedge_reg3[1:0], !KEY[2]};
    posedge_reg4 <= {posedge_reg4[1:0], !KEY[3]};
end

assign rst_n = ~posedge_btn1;
assign clk = CLOCK_50;

assign posedge_btn1 = posedge_reg1[2:1] == 2'b01;
assign posedge_btn2 = posedge_reg2[2:1] == 2'b01;
assign posedge_btn3 = posedge_reg3[2:1] == 2'b01;
assign posedge_btn4 = posedge_reg4[2:1] == 2'b01;

bin2hex U1 (
    .bin (uart_data[3:0]),
    .hex (HEX0)
);
bin2hex U2 (
    .bin (uart_data[7:4]),
    .hex (HEX1)
);
bin2hex U3 (
    .bin (uart_data[11:8]),
    .hex (HEX2)
);
bin2hex U4 (
    .bin (uart_data[15:12]),
    .hex (HEX3)
);
bin2hex U5 (
    .bin (uart_data[19:16]),
    .hex (HEX4)
);
bin2hex U6 (
    .bin (uart_data[23:20]),
    .hex (HEX5)
);


endmodule