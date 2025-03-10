module ALu (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [1:0]  ALUCtl,

    output reg [31:0] R,
    output wire Zero,
    output wire Overflow,
    output wire Cout
);

localparam AND = 2 'b00;
localparam OR  = 2 'b01;
localparam ADD = 2 'b10;
localparam SUB = 2 'b11;

assign Zero = ~|R;
assign Overflow = (A[31] & B[31] & ~R[31]) | (~A[31] & ~B[31] & R[31]);
assign Cout = (ALUCtl == ADD) ? (R[31] & B[31]) : 1'b0;

always @(*) begin
    case (ALUCtl)
        AND: R = A & B;
        OR:  R = A | B;
        ADD: R = A + B;
        SUB: R = A - B; 
        default: R = A + B;
    endcase
end

endmodule
