module Time #(
    parameter CLOCK_FREQ = 50_000_000 // 50 MHz
) (
    input  wire clk,
    input  wire rst_n,

    input  wire mode, // time -> set hour -> set minute -> set second

    input  wire [5:0] time_to_set, // time to set
    
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

localparam SECOND      = CLOCK_FREQ;
localparam MINUTE      = 60 * SECOND;
localparam HOUR        = 60 * MINUTE;
localparam HALF_SECOND = CLOCK_FREQ / 2;
localparam HOUR_MAX    = 24;
localparam MINUTE_MAX  = 60;
localparam SECOND_MAX  = 60;

reg [31:0] second_counter;
reg [6:0] hour;
reg [6:0] minute;
reg [6:0] second;

reg [2:0] state;

localparam TIME_MODE       = 2'b00;
localparam SET_HOUR_MODE   = 2'b01;
localparam SET_MINUTE_MODE = 2'b10;
localparam SET_SECOND_MODE = 2'b11;

reg setting_hour, setting_minute, setting_second;

always @(posedge clk ) begin
    setting_hour   <= 0;
    setting_minute <= 0;
    setting_second <= 0;
    
    if(!rst_n) begin
        state          <= 0;
        hour           <= 0;
        minute         <= 0;
        second         <= 0;
        second_counter <= 0;
    end else begin
        if(second_counter < SECOND) begin
            second_counter <= second_counter + 1;
        end else begin
            second_counter <= 0;
            second         <= second + 1;
        end

        if(second >= SECOND_MAX) begin
            second <= 0;
            minute <= minute + 1;
        end

        if(minute >= MINUTE_MAX) begin
            minute <= 0;
            hour   <= hour + 1;
        end

        if(hour >= HOUR_MAX) begin
            hour <= 0;
        end

        case (state)
            TIME_MODE: begin
                if(mode) begin
                    state <= SET_HOUR_MODE;
                end
            end
            SET_HOUR_MODE: begin
                setting_hour <= 1;

                if(mode) begin
                    state <= SET_MINUTE_MODE;
                end else begin
                    hour <= time_to_set;
                end
            end
            SET_MINUTE_MODE: begin
                setting_minute <= 1;

                if(mode) begin
                    state <= SET_SECOND_MODE;
                end else begin
                    minute <= (time_to_set >= MINUTE_MAX) ? 0 : time_to_set;
                end
            end
            SET_SECOND_MODE: begin
                setting_second <= 1;
                
                if(mode) begin
                    state <= TIME_MODE;
                end else begin
                    second <= (time_to_set >= SECOND_MAX) ? 0 : time_to_set;
                end
            end
            default: begin
                state <= TIME_MODE;
            end 
        endcase
    end
end

localparam DELAY = CLOCK_FREQ / 2;

reg [31:0] fade_counter;
reg [6:0] hour_reg;
reg [6:0] minute_reg;
reg [6:0] second_reg;

always @(posedge clk ) begin
    if(!rst_n) begin
        hour_reg     <= 'd100;
        minute_reg   <= 'd100;
        second_reg   <= 'd100;
        fade_counter <= 0;
    end else begin
        if(state == SET_HOUR_MODE) begin
            if(fade_counter == DELAY) begin
                fade_counter <= 0;
            end else if(fade_counter < DELAY / 2) begin
                fade_counter <= fade_counter + 1;
                hour_reg     <= 'd100;
            end else begin
                hour_reg     <= hour;
                fade_counter <= fade_counter + 1;
            end
        end else begin
            hour_reg  <= hour;
        end

        if(state == SET_MINUTE_MODE) begin
            if(fade_counter == DELAY) begin
                fade_counter <= 0;
            end else if(fade_counter < DELAY / 2) begin
                fade_counter <= fade_counter + 1;
                minute_reg     <= 'd100;
            end else begin
                minute_reg     <= minute;
                fade_counter <= fade_counter + 1;
            end  
        end else begin
            minute_reg <= minute;
        end

        if(state == SET_SECOND_MODE) begin
            if(fade_counter == DELAY) begin
                fade_counter <= 0;
            end else if(fade_counter < DELAY / 2) begin
                fade_counter <= fade_counter + 1;
                second_reg     <= 'd100;
            end else begin
                second_reg     <= second;
                fade_counter <= fade_counter + 1;
            end
        end else begin
            second_reg <= second;
        end
    end
end

bin_to_bcd_7seg SECONDS_Decoder (
    .in_bin    (second_reg),
    .bcd_units (HEX0),
    .bcd_tens  (HEX1)
);

bin_to_bcd_7seg MINUTES_Decoder (
    .in_bin    (minute_reg),
    .bcd_units (HEX2),
    .bcd_tens  (HEX3)
);

bin_to_bcd_7seg HOURS_Decoder (
    .in_bin    (hour_reg),
    .bcd_units (HEX4),
    .bcd_tens  (HEX5)
);

endmodule
