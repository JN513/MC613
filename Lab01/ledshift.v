module ledshift #(
    parameter CLK_FREQ = 50_000_000
) (
    input  wire CLOCK_50,
    input  wire [3:0] KEY,
    output wire [9:0] LEDR
);

localparam DEBOUNCE_CICLES = CLK_FREQ / 8;


wire posedge_btn1, posedge_btn2;
reg btn_pressed1, btn_pressed2;
reg [2:0] posedge_reg1, posedge_reg2;
reg [9:0] led_reg;

initial begin
    counter_1_debounce = 32'h0;
    counter_2_debounce = 32'h0;
    led_reg            = 10'b0000100000;
    posedge_reg1       = 3'b000;
    posedge_reg2       = 3'b000;
end

always @(posedge CLOCK_50 ) begin
    btn_pressed1 <= 1'b0;
    btn_pressed2 <= 1'b0;

    posedge_reg1 <= {posedge_reg1[1:0], btn_pressed1};
    posedge_reg2 <= {posedge_reg2[1:0], btn_pressed2};

    if(counter_1_debounce >= DEBOUNCE_CICLES) begin
        btn_pressed1 <= 1'b1;
    end

    if(counter_2_debounce >= DEBOUNCE_CICLES) begin
        btn_pressed2 <= 1'b1;
    end

    if(posedge_btn1 && !led_reg[0]) begin
        led_reg <= led_reg >> 1'b1;
    end

    if(posedge_btn2 && !led_reg[9]) begin
        led_reg <= led_reg << 1'b1;
    end
end

reg [31:0] counter_1_debounce, counter_2_debounce;

always @(posedge CLOCK_50 ) begin
    if(!KEY[0]) begin
        counter_1_debounce <= counter_1_debounce + 1'b1;
    end else begin
        counter_1_debounce <= 32'h0;
    end

    if(!KEY[3]) begin
        counter_2_debounce <= counter_2_debounce + 1'b1;
    end else begin
        counter_2_debounce <= 32'h0;
    end
end

assign posedge_btn1 = ~posedge_reg1[2] & posedge_reg1[1];
assign posedge_btn2 = ~posedge_reg2[2] & posedge_reg2[1];

assign LEDR = led_reg;

endmodule
