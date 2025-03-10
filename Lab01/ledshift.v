module ledshift #(
    parameter CLK_FREQ = 50_000_000
) (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    output reg [9:0] LEDR
);

localparam DEBOUNCE_CICLES = CLK_FREQ / 4;

reg [9:0] led_reg;

initial begin
    counter_1_debounce <= 32'h0;
    counter_2_debounce <= 32'h0;
    led_reg            <= 10'b0000100000;
end

always @(posedge clk ) begin
    if(counter_1_debounce >= DEBOUNCE_CICLES) begin
        led_reg <= {led_reg[0], led_reg[9:1]};
    end

    if(counter_2_debounce >= DEBOUNCE_CICLES) begin
        led_reg <= {led_reg[8:0], led_reg[9]};
    end
end

reg [31:0] counter_1_debounce, counter_2_debounce;

always @(posedge clk ) begin
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

    if(counter_1_debounce >= DEBOUNCE_CICLES) begin
        counter_1_debounce <= 32'h0;
    end

    if(counter_2_debounce >= DEBOUNCE_CICLES) begin
        counter_2_debounce <= 32'h0;
    end
end

assign LEDR = ~led_reg;

endmodule
