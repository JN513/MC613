module bin2hex (
    input wire [3:0] bin,
    output reg [6:0] hex
);

always @(*) begin
    case (bin)
        4'b0000: dec = 7'b0000001;
        4'b0001: dec = 7'b1001111;
        4'b0010: dec = 7'b0010010;
        4'b0011: dec = 7'b0000110;
        4'b0100: dec = 7'b1001100;
        4'b0101: dec = 7'b0100100;
        4'b0110: dec = 7'b0100000;
        4'b0111: dec = 7'b0001111;
        4'b1000: dec = 7'b0000000;
        4'b1001: dec = 7'b0001100;
        4'b1010: dec = 7'b0001000;
        4'b1011: dec = 7'b1100000;
        4'b1100: dec = 7'b0110001;
        4'b1101: dec = 7'b1000010;
        4'b1110: dec = 7'b0110000;
        4'b1111: dec = 7'b0111000;
        default: dec = 7'b1111111;
    endcase
end
    
endmodule
