`timescale 1ns / 1ps
module ledshift_tb ();

reg clk;
reg [3:0] KEY;
wire [9:0] LED;

ledshift U1 (
    .CLOCK_50(clk),
    .KEY(KEY),
    .LEDR(LED)
);

integer i;

initial begin
    $dumpfile("ledshift_tb.vcd");
    $dumpvars(0, ledshift_tb);

    clk = 1'b0;
    KEY = 4'b0000;

    for(i = 0; i <= 4'hF; i = i + 1'b1) begin
        if(i % 5 == 0) begin
            KEY = 4'b1110;
        end else begin
            KEY = 4'b0111;
        end
    end

    $finish;
end

always #2 clk = ~clk;

endmodule
