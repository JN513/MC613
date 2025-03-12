module fsm_board #(
    parameter CLK_FREQ = 50_000_000
) (
    input  wire CLOCK_50,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    input  wire [3:0] KEY,
    output wire [0:6] HEX0
);

localparam DEBOUNCE_CICLES = CLK_FREQ / 8;

wire rst;
wire r50, r100, r200;
wire [1:0] state_o;
wire cafe, t50, t100, t200;

reg [31:0] debounce_counter1, debounce_counter2, debounce_counter3, debounce_counter4;

wire posedge_btn1, posedge_btn2, posedge_btn3, posedge_btn4;
reg [2:0] posedge_reg1, posedge_reg2, posedge_reg3, posedge_reg4;
reg aux1, aux2, aux3, aux4;

initial begin
    debounce_counter1 = 32'h0;
    debounce_counter2 = 32'h0;
    debounce_counter3 = 32'h0;
    debounce_counter4 = 32'h0;
    posedge_reg1      = 3'b000;
    posedge_reg2      = 3'b000;
    posedge_reg3      = 3'b000;
    posedge_reg4      = 3'b000;
end

always @(posedge CLOCK_50 ) begin
    aux1 <= 1'b0;
    aux2 <= 1'b0;
    aux3 <= 1'b0;
    aux4 <= 1'b0;

    if(debounce_counter1 >= DEBOUNCE_CICLES) begin
        aux1 <= 1'b1;
    end

    if(debounce_counter2 >= DEBOUNCE_CICLES) begin
        aux2 <= 1'b1;
    end

    if(debounce_counter3 >= DEBOUNCE_CICLES) begin
        aux3 <= 1'b1;
    end

    if(debounce_counter4 >= DEBOUNCE_CICLES) begin
        aux4 <= 1'b1;
    end

    posedge_reg1 <= {posedge_reg1[1:0], aux1};
    posedge_reg2 <= {posedge_reg2[1:0], aux2};
    posedge_reg3 <= {posedge_reg3[1:0], aux3};
    posedge_reg4 <= {posedge_reg4[1:0], aux4};
end

always @(posedge CLOCK_50 ) begin
    if(!KEY[0]) begin
        debounce_counter1 <= debounce_counter1 + 1'b1;
    end else begin
        debounce_counter1 <= 32'h0;
    end

    if(!KEY[1]) begin
        debounce_counter2 <= debounce_counter2 + 1'b1;
    end else begin
        debounce_counter2 <= 32'h0;
    end

    if(!KEY[2]) begin
        debounce_counter3 <= debounce_counter3 + 1'b1;
    end else begin
        debounce_counter3 <= 32'h0;
    end

    if(!KEY[3]) begin
        debounce_counter4 <= debounce_counter4 + 1'b1;
    end else begin
        debounce_counter4 <= 32'h0;
    end
end

fsm #(
    .CLK_FREQ(CLK_FREQ)
) u1 (
    .clk  (CLOCK_50),
    .rst  (rst),
    .r50  (r50),
    .r100 (r100),
    .r200 (r200),
    .cafe (cafe),
    .t50  (t50),
    .t100 (t100),
    .t200 (t200),
    .state_o (state_o)
);

assign LEDR[9:0]    = {t200, t100, t50, cafe, 4'b0000, state_o};
assign posedge_btn1 = posedge_reg1[2:1] == 2'b01;
assign posedge_btn2 = posedge_reg2[2:1] == 2'b01;
assign posedge_btn3 = posedge_reg3[2:1] == 2'b01;
assign posedge_btn4 = posedge_reg4[2:1] == 2'b01;

assign r50  = posedge_btn1;
assign r100 = posedge_btn2;
assign r200 = posedge_btn3;
assign rst  = posedge_btn4;

endmodule
