module multiplier #(
    parameter N = 4
) (
    input wire clk,
    input wire rst_n,

    input wire set,
    output reg ready,

    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [2*N-1:0] r
);

`ifdef SINGLE_CYCLE
always @(posedge clk) begin
    ready <= 0;

    if(!rst_n) begin
        r <= 0;
    end else if(set) begin
        r     <= a * b;
        ready <= 1;
    end
end

`else
reg [2*N-1:0] b_reg;
reg [N-1:0] a_reg;

localparam IDLE = 2'b00;
localparam RUN  = 2'b01;
localparam DONE = 2'b10;
reg [1:0] state;

always @(posedge clk) begin
    ready <= 0;

    if(!rst_n) begin
        r     <= 0;
        b_reg <= 0;
        a_reg <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if(set) begin
                    r     <= 0;
                    a_reg <= a;
                    b_reg <= b;
                    state <= RUN;
                end else begin
                    state <= IDLE;
                end
            end 
            RUN: begin
                r <= (a_reg[0] ? r + b_reg : r);
                b_reg <= b_reg << 1;
                a_reg <= a_reg >> 1;

                if(~|a_reg) begin
                    state <= DONE;
                end else begin
                    state <= RUN;
                end
            end 
            DONE: begin
                ready <= 1;
                state <= IDLE;
            end
            default: state <= IDLE; 
        endcase
    end
end

`endif
    
endmodule