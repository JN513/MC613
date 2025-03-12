module fsm #(
    parameter CLK_FREQ = 50_000_000
) (
    input wire clk,
    input wire rst,
    
    input wire r50,
    input wire r100,
    input wire r200,

    output reg cafe,
    output reg t50,
    output reg t100,
    output reg t200,

    output wire [1:0] state_o
);

localparam FOUR_SECONDS = CLK_FREQ * 4;

reg [1:0] state;
reg [31:0] time_count;

localparam IDLE    = 2'b00;
localparam RECEIVE = 2'b01;
localparam TROCO   = 2'b10;
localparam DELAY   = 2'b11;

// total == 250 cafe <= 1

assign state_o = state;
reg [11:0] cafe_count;

always @(posedge clk ) begin
    if(rst) begin
        state      <= IDLE;
        cafe_count <= 12'b0;
        time_count <= 32'h0;
    end else begin
        case (state)
            IDLE: begin
                cafe       <= 1'b0;
                t50        <= 1'b0;
                t100       <= 1'b0;
                t200       <= 1'b0;
                time_count <= 32'h0;
                if(r50) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd50;
                end else if(r100) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd100;
                end else if(r200) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd200;
                end
            end 

            RECEIVE: begin
                if(cafe_count >= 'd250) begin
                    state      <= TROCO;
                end else if(r50) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd50;
                end else if(r100) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd100;
                end else if(r200) begin
                    state      <= RECEIVE;
                    cafe_count <= cafe_count + 'd200;
                end
            end

            TROCO: begin
                if(cafe_count == 'd300) begin
                    cafe <= 1'b1;
                    t50  <= 1'b1;
                end else if(cafe_count == 'd350) begin
                    cafe <= 1'b1;
                    t100 <= 1'b1;
                end else if(cafe_count == 'd400) begin
                    cafe <= 1'b1;
                    t50  <= 1'b1;
                    t100 <= 1'b1;
                end
                
                cafe       <= 1'b1;
                state      <= DELAY;
                cafe_count <= 12'b0;
            end

            DELAY: begin
                if(time_count >= FOUR_SECONDS) begin
                    state      <= IDLE;
                end else begin
                    time_count <= time_count + 1'b1;
                end
            end

            default: state <= IDLE; 
        endcase
    end
end
    
endmodule
