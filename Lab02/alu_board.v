module alu_board (
    input  wire CLOCK_50,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    input  wire [3:0] KEY,
    output wire [0:6] HEX0,
    output wire [0:6] HEX1,
    output wire [0:6] HEX2,
    output wire [0:6] HEX3,
    output wire [0:6] HEX4,
    output wire [0:6] HEX5
);

wire [31:0] Number_A, Number_B, Result;
wire [1:0] Alu_op;
wire Alu_Zero, Alu_Overflow, Alu_Cout;

assign Alu_op = SW[9:8];
assign Number_A = {{28{SW[7]}},SW[7:4]};
assign Number_B = {{28{SW[3]}},SW[3:0]};

two_comp_to_7seg A1(
    .Number (Number_A),
    .BCD    (HEX4),
    .Signal (HEX5)
);

two_comp_to_7seg B1(
    .Number (Number_B),
    .BCD    (HEX2),
    .Signal (HEX3)
);

two_comp_to_7seg R1(
    .Number (Result),
    .BCD    (HEX0),
    .Signal (HEX1)
);

Alu Alu (
    .A        (Number_A),
    .B        (Number_B),
    .ALUCtl   (Alu_op),
    .R        (Result),
    .Zero     (Alu_Zero),
    .Overflow (Alu_Overflow),
    .Cout     (Alu_Cout)
);

assign LEDR[0] = Alu_Zero;
assign LEDR[1] = Alu_Overflow;
assign LEDR[2] = Alu_Cout;

assign LEDR[9:3] = 7'b0000000;

endmodule
