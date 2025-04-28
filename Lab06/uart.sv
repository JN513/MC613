module UART #(
    parameter BIT_RATE = 115200,  // Baud rate
    parameter CLK_FREQ = 50000000 // Clock frequency
) (
    input  logic clk,
    input  logic rst_n,

    input  logic rx,
    output logic tx,

    input  logic uart_tx_en,
    input  logic [7:0] uart_tx_data,
    output logic uart_tx_busy,

    output logic uart_rx_valid,
    output logic [7:0] uart_rx_data,
    
    output logic parity_error
);
    

UART_TX #(
    .BAUD_RATE  (BIT_RATE),
    .CLK_FREQ   (CLK_FREQ)
) uart_tx (
    .clk             (clk),
    .rst_n           (rst_n),

    .wr_bit_period_i (1'b0),
    .bit_period_i    (CLK_FREQ / BIT_RATE - 1),

    .uart_tx_en      (uart_tx_en),
    .uart_tx_data    (uart_tx_data),
    .uart_txd        (tx),
    .uart_tx_busy    (uart_tx_busy)
);

UART_RX #(
    .BAUD_RATE       (BIT_RATE),
    .CLK_FREQ        (CLK_FREQ)
) uart_rx (
    .clk                  (clk),
    .rst_n                (rst_n),

    .wr_bit_period_i      (1'b0),
    .bit_period_i         (CLK_FREQ / BIT_RATE - 1),

    .uart_rxd             (rx),
    .uart_rx_en           (1'b1),
    .uart_rx_valid        (uart_rx_valid),
    .uart_rx_data         (uart_rx_data),
    .uart_rx_parity_error (parity_error)
);

endmodule