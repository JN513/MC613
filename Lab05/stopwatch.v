module StopWatch #(
    parameter CLOCK_FREQ = 50_000_000 // 50 MHz
) (
    input  wire clk,
    input  wire rst_n,

    input  wire start_stop,
    input  wire zero,

    
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

localparam SECOND          = CLOCK_FREQ;
localparam CENTISECOND     = CLOCK_FREQ / 100;
localparam MINUTE          = 60 * SECOND;
localparam HOUR            = 60 * MINUTE;
localparam HALF_SECOND     = CLOCK_FREQ / 2;
localparam HOUR_MAX        = 24;
localparam MINUTE_MAX      = 99;
localparam SECOND_MAX      = 60;
localparam CENTISECOND_MAX = 99;

reg [31:0] centisecond_counter;
reg [6:0] centisecond;
reg [6:0] second;
reg [6:0] minute;
reg state; // 0 stop, 1 run

always @(posedge clk ) begin
    if(!rst_n) begin
        state               <= 0;
        centisecond         <= 0;
        centisecond_counter <= 0;
        second              <= 0;
        minute              <= 0;
    end else begin
        if(start_stop) begin
            state <= !state;
        end

        if(state) begin
           if(centisecond_counter == CENTISECOND) begin
                centisecond_counter <= 0;
                centisecond         <= centisecond + 1;
            end else begin
                centisecond_counter <= centisecond_counter + 1;
            end

            if(centisecond == CENTISECOND_MAX) begin
                centisecond <= 0;
                second      <= second + 1;
            end
            if(second == SECOND_MAX) begin
                second <= 0;
                minute <= minute + 1;
            end
            if(minute == MINUTE_MAX) begin
                minute <= 0;
            end
        end

        if(zero) begin
            centisecond <= 0;
            second      <= 0;
            minute      <= 0;
        end
    end
end


bin_to_bcd_7seg SECONDS_Decoder (
    .in_bin    (centisecond),
    .bcd_units (HEX0),
    .bcd_tens  (HEX1)
);

bin_to_bcd_7seg MINUTES_Decoder (
    .in_bin    (second),
    .bcd_units (HEX2),
    .bcd_tens  (HEX3)
);

bin_to_bcd_7seg HOURS_Decoder (
    .in_bin    (minute),
    .bcd_units (HEX4),
    .bcd_tens  (HEX5)
);

endmodule
