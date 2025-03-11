`timescale 1ns / 1ps
module swxor_tb ();
    
wire [9:0] LEDR;
reg  [9:0] SW;

swxor U1 (
    .SW (SW),
    .LEDR(LEDR)
);

integer i;

initial begin
    $dumpfile("build/swxor_tb.vcd");
    $dumpvars(0, swxor_tb);

    SW = 10'b0000000000;

    for (i = 0; i <= 10'h3FF ; i = i + 1'b1 ) begin
        #10 SW = i;
    end

    $finish;
end

endmodule