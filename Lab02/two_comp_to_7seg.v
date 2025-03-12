module two_comp_to_7seg (
    input wire [31:0] Number,
    output wire [6:0] BCD,
    output wire [6:0] Signal
);

wire is_neg = Number[31];

wire [31:0] absolute = (is_neg) ? ~Number + 1'b1 : Number;

wire [3:0] digit_0;
assign digit_0 = absolute[3:0];

assign Signal = (is_neg) ? 7'b1111110 : 7'b1111111;

bin2hex U1 (
    .bin (digit_0),
    .hex (BCD)
);
    
endmodule