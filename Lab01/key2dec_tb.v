module key2dec_tb ();

reg  [3:0] KEY;
wire [6:0] HEX0;

key2dec U1 (
    .KEY (KEY),
    .HEX0(HEX0)
);

integer i;

initial begin
    $dumpfile("key2dec_tb.vcd");
    $dumpvars(0, key2dec_tb);

    KEY = 4'b0000;

    for(i = 0; i <= 4'hF; i = i + 1'b1) begin
        #10 KEY = i;
    end

    $finish;
end

endmodule
