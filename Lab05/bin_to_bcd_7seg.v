module bin_to_bcd_7seg (
    input  wire [6:0] in_bin,
    output reg  [6:0] bcd_units,
    output reg  [6:0] bcd_tens
);

    always @(*) begin
        case (in_bin)
            7'd0:  begin bcd_tens =  7'b1000000; bcd_units =  7'b1000000; end
            7'd1:  begin bcd_tens =  7'b1000000; bcd_units =  7'b1111001; end
            7'd2:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0100100; end
            7'd3:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0110000; end
            7'd4:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0011001; end
            7'd5:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0010010; end
            7'd6:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0000010; end
            7'd7:  begin bcd_tens =  7'b1000000; bcd_units =  7'b1111000; end
            7'd8:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0000000; end
            7'd9:  begin bcd_tens =  7'b1000000; bcd_units =  7'b0010000; end
            7'd10: begin bcd_tens =  7'b1111001; bcd_units =  7'b1000000; end
            7'd11: begin bcd_tens =  7'b1111001; bcd_units =  7'b1111001; end
            7'd12: begin bcd_tens =  7'b1111001; bcd_units =  7'b0100100; end
            7'd13: begin bcd_tens =  7'b1111001; bcd_units =  7'b0110000; end
            7'd14: begin bcd_tens =  7'b1111001; bcd_units =  7'b0011001; end
            7'd15: begin bcd_tens =  7'b1111001; bcd_units =  7'b0010010; end
            7'd16: begin bcd_tens =  7'b1111001; bcd_units =  7'b0000010; end
            7'd17: begin bcd_tens =  7'b1111001; bcd_units =  7'b1111000; end
            7'd18: begin bcd_tens =  7'b1111001; bcd_units =  7'b0000000; end
            7'd19: begin bcd_tens =  7'b1111001; bcd_units =  7'b0010000; end
            7'd20: begin bcd_tens =  7'b0100100; bcd_units =  7'b1000000; end
            7'd21: begin bcd_tens =  7'b0100100; bcd_units =  7'b1111001; end
            7'd22: begin bcd_tens =  7'b0100100; bcd_units =  7'b0100100; end
            7'd23: begin bcd_tens =  7'b0100100; bcd_units =  7'b0110000; end
            7'd24: begin bcd_tens =  7'b0100100; bcd_units =  7'b0011001; end
            7'd25: begin bcd_tens =  7'b0100100; bcd_units =  7'b0010010; end
            7'd26: begin bcd_tens =  7'b0100100; bcd_units =  7'b0000010; end
            7'd27: begin bcd_tens =  7'b0100100; bcd_units =  7'b1111000; end
            7'd28: begin bcd_tens =  7'b0100100; bcd_units =  7'b0000000; end
            7'd29: begin bcd_tens =  7'b0100100; bcd_units =  7'b0010000; end
            7'd30: begin bcd_tens =  7'b0110000; bcd_units =  7'b1000000; end
            7'd31: begin bcd_tens =  7'b0110000; bcd_units =  7'b1111001; end
            7'd32: begin bcd_tens =  7'b0110000; bcd_units =  7'b0100100; end
            7'd33: begin bcd_tens =  7'b0110000; bcd_units =  7'b0110000; end
            7'd34: begin bcd_tens =  7'b0110000; bcd_units =  7'b0011001; end
            7'd35: begin bcd_tens =  7'b0110000; bcd_units =  7'b0010010; end
            7'd36: begin bcd_tens =  7'b0110000; bcd_units =  7'b0000010; end
            7'd37: begin bcd_tens =  7'b0110000; bcd_units =  7'b1111000; end
            7'd38: begin bcd_tens =  7'b0110000; bcd_units =  7'b0000000; end
            7'd39: begin bcd_tens =  7'b0110000; bcd_units =  7'b0010000; end
            7'd40: begin bcd_tens =  7'b0011001; bcd_units =  7'b1000000; end
            7'd41: begin bcd_tens =  7'b0011001; bcd_units =  7'b1111001; end
            7'd42: begin bcd_tens =  7'b0011001; bcd_units =  7'b0100100; end
            7'd43: begin bcd_tens =  7'b0011001; bcd_units =  7'b0110000; end
            7'd44: begin bcd_tens =  7'b0011001; bcd_units =  7'b0011001; end
            7'd45: begin bcd_tens =  7'b0011001; bcd_units =  7'b0010010; end
            7'd46: begin bcd_tens =  7'b0011001; bcd_units =  7'b0000010; end
            7'd47: begin bcd_tens =  7'b0011001; bcd_units =  7'b1111000; end
            7'd48: begin bcd_tens =  7'b0011001; bcd_units =  7'b0000000; end
            7'd49: begin bcd_tens =  7'b0011001; bcd_units =  7'b0010000; end
            7'd50: begin bcd_tens =  7'b0010010; bcd_units =  7'b1000000; end
            7'd51: begin bcd_tens =  7'b0010010; bcd_units =  7'b1111001; end
            7'd52: begin bcd_tens =  7'b0010010; bcd_units =  7'b0100100; end
            7'd53: begin bcd_tens =  7'b0010010; bcd_units =  7'b0110000; end
            7'd54: begin bcd_tens =  7'b0010010; bcd_units =  7'b0011001; end
            7'd55: begin bcd_tens =  7'b0010010; bcd_units =  7'b0010010; end
            7'd56: begin bcd_tens =  7'b0010010; bcd_units =  7'b0000010; end
            7'd57: begin bcd_tens =  7'b0010010; bcd_units =  7'b1111000; end
            7'd58: begin bcd_tens =  7'b0010010; bcd_units =  7'b0000000; end
            7'd59: begin bcd_tens =  7'b0010010; bcd_units =  7'b0010000; end
            7'd60: begin bcd_tens =  7'b0000010; bcd_units =  7'b1000000; end
            7'd61: begin bcd_tens =  7'b0000010; bcd_units =  7'b1111001; end
            7'd62: begin bcd_tens =  7'b0000010; bcd_units =  7'b0100100; end
            7'd63: begin bcd_tens =  7'b0000010; bcd_units =  7'b0110000; end
            7'd64: begin bcd_tens =  7'b0000010; bcd_units =  7'b0011001; end
            7'd65: begin bcd_tens =  7'b0000010; bcd_units =  7'b0010010; end
            7'd66: begin bcd_tens =  7'b0000010; bcd_units =  7'b0000010; end
            7'd67: begin bcd_tens =  7'b0000010; bcd_units =  7'b1111000; end
            7'd68: begin bcd_tens =  7'b0000010; bcd_units =  7'b0000000; end
            7'd69: begin bcd_tens =  7'b0000010; bcd_units =  7'b0010000; end
            7'd70: begin bcd_tens =  7'b1111000; bcd_units =  7'b1000000; end
            7'd71: begin bcd_tens =  7'b1111000; bcd_units =  7'b1111001; end
            7'd72: begin bcd_tens =  7'b1111000; bcd_units =  7'b0100100; end
            7'd73: begin bcd_tens =  7'b1111000; bcd_units =  7'b0110000; end
            7'd74: begin bcd_tens =  7'b1111000; bcd_units =  7'b0011001; end
            7'd75: begin bcd_tens =  7'b1111000; bcd_units =  7'b0010010; end
            7'd76: begin bcd_tens =  7'b1111000; bcd_units =  7'b0000010; end
            7'd77: begin bcd_tens =  7'b1111000; bcd_units =  7'b1111000; end
            7'd78: begin bcd_tens =  7'b1111000; bcd_units =  7'b0000000; end
            7'd79: begin bcd_tens =  7'b1111000; bcd_units =  7'b0010000; end
            7'd80: begin bcd_tens =  7'b0000000; bcd_units =  7'b1000000; end
            7'd81: begin bcd_tens =  7'b0000000; bcd_units =  7'b1111001; end
            7'd82: begin bcd_tens =  7'b0000000; bcd_units =  7'b0100100; end
            7'd83: begin bcd_tens =  7'b0000000; bcd_units =  7'b0110000; end
            7'd84: begin bcd_tens =  7'b0000000; bcd_units =  7'b0011001; end
            7'd85: begin bcd_tens =  7'b0000000; bcd_units =  7'b0010010; end
            7'd86: begin bcd_tens =  7'b0000000; bcd_units =  7'b0000010; end
            7'd87: begin bcd_tens =  7'b0000000; bcd_units =  7'b1111000; end
            7'd88: begin bcd_tens =  7'b0000000; bcd_units =  7'b0000000; end
            7'd89: begin bcd_tens =  7'b0000000; bcd_units =  7'b0010000; end
            7'd90: begin bcd_tens =  7'b0010000; bcd_units =  7'b1000000; end
            7'd91: begin bcd_tens =  7'b0010000; bcd_units =  7'b1111001; end
            7'd92: begin bcd_tens =  7'b0010000; bcd_units =  7'b0100100; end
            7'd93: begin bcd_tens =  7'b0010000; bcd_units =  7'b0110000; end
            7'd94: begin bcd_tens =  7'b0010000; bcd_units =  7'b0011001; end
            7'd95: begin bcd_tens =  7'b0010000; bcd_units =  7'b0010010; end
            7'd96: begin bcd_tens =  7'b0010000; bcd_units =  7'b0000010; end
            7'd97: begin bcd_tens =  7'b0010000; bcd_units =  7'b1111000; end
            7'd98: begin bcd_tens =  7'b0010000; bcd_units =  7'b0000000; end
            7'd99: begin bcd_tens =  7'b0010000; bcd_units =  7'b0010000; end
            default: begin
                bcd_tens  = 7'b1111111;
                bcd_units = 7'b1111111;
            end
        endcase
    end

endmodule
