module bin2hex_tb ();

reg  [3:0] KEY;
wire [6:0] HEX0;

wire [3:0] key_not;

bin2hex U1 (
    .bin (KEY),
    .hex (HEX0)
);

integer i;

initial begin
    $dumpfile("build/bin2hex_tb.vcd");
    $dumpvars(0, bin2hex_tb);

    KEY = 4'b0000;

    for(i = 0; i <= 4'hF; i = i + 1'b1) begin
        #10 KEY = i;

        #1

        $display("KEY = %b, HEX0 = %b", KEY, HEX0);
    end

    $finish;
end

assign key_not = ~KEY;

endmodule
