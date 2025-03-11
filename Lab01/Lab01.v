module Lab01 (
    input  wire CLOCK_50,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    input  wire [3:0] KEY,
    output wire [0:6] HEX0
);

`define LEDSHIFT 1

`ifdef  KEY2DEC

key2dec U1 (
    .KEY (KEY),
    .HEX0(HEX0)
);

`elsif LEDSHIFT

ledshift U1 (
    .CLOCK_50(CLOCK_50),
    .KEY     (KEY),
    .LEDR    (LEDR)
);

`else

swxor U1 (
    .SW       (SW),
    .LEDR     (LEDR)
);

`endif
    
endmodule
