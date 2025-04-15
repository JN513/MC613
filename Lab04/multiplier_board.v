//`define SINGLE_CYCLE 1
module multiplier_board (
    input  wire CLOCK_50,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    input  wire [3:0] KEY,
    output wire [0:6] HEX0,
    output wire [0:6] HEX1,
    output wire [0:6] HEX2,
    output wire [0:6] HEX3,
    output wire [0:6] HEX4
);

wire rst_n = !posedge_btn4;
wire [9:0] r;

multiplier #(
    .N(5)
) dut (
    .clk   (CLOCK_50),
    .rst_n (rst_n),
    .set   (posedge_reg1),
    .ready (),
    .a(SW[9:5]),
    .b(SW[4:0]),
    .r(r)
);

bin2hex U1 (
    .bin (r[3:0]),
    .hex (HEX0)
);

bin2hex U2 (
    .bin (r[7:4]),
    .hex (HEX1)
);

bin2hex U3 (
    .bin ({2'b00, r[9:8]}),
    .hex (HEX2)
);

bin2hex U4 (
    .bin (SW[3:0]),
    .hex (HEX3)
);

bin2hex U5 (
    .bin (SW[8:5]),
    .hex (HEX4)
);

wire posedge_btn1, posedge_btn4;
reg [2:0] posedge_reg1, posedge_reg4;

initial begin
    posedge_reg1      = 3'b000;
    posedge_reg4      = 3'b000;
end

always @(posedge CLOCK_50 ) begin
    posedge_reg1 <= {posedge_reg1[1:0], !KEY[0]};
    posedge_reg4 <= {posedge_reg4[1:0], !KEY[3]};
end

assign posedge_btn1 = posedge_reg1[2:1] == 2'b01;
assign posedge_btn4 = posedge_reg4[2:1] == 2'b01;

endmodule
