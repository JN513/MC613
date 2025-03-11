module bin2dec_tb ();

reg  [3:0] KEY;
wire [6:0] HEX0;

wire [3:0] key_not;

bin2dec U1 (
    .bin (KEY),
    .dec (HEX0)
);

integer i;

initial begin
    $dumpfile("build/bin2dec_tb.vcd");
    $dumpvars(0, bin2dec_tb);

    KEY = 4'b0000;

    for(i = 0; i <= 4'hF; i = i + 1'b1) begin
        #10 KEY = i;

        #1

        $display("KEY = %b, HEX0 = %b", KEY, HEX0);

        if(KEY > 'd9) begin
            if (HEX0 != 7'b0110000) begin
                $display("Error: HEX0 = %b", HEX0);
                $finish;
            end
        end
    end

    $finish;
end

assign key_not = ~KEY;

endmodule
