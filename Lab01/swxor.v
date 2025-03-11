module swxor (
    input  wire [9:0] SW,
    output wire [9:0] LEDR
);

assign LEDR[9] = SW[9] ^SW[8];
assign LEDR[8] = SW[8] ^SW[7];
assign LEDR[7] = SW[7] ^SW[6];
assign LEDR[6] = SW[6] ^SW[5];
assign LEDR[5] = SW[5] ^SW[4];
assign LEDR[4] = SW[4] ^SW[3];
assign LEDR[3] = SW[3] ^SW[2];
assign LEDR[2] = SW[2] ^SW[1];
assign LEDR[1] = SW[1] ^SW[0];
assign LEDR[0] = 1'b0; // Sempre apagado

endmodule
