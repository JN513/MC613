// O tamanho da cache em linhas e calculado com base no tamanho do index, seguindo as formulas:
// INDEX_WIDTH = ADDR_WIDTH - TAG_WIDTH - OFFSET_WIDTH
// CACHE_SIZE = 2 ** INDEX_WIDTH
// com o tamanho da cache em bytes sendo dado por:
// CACHE_SIZE * DATA_WIDTH / 8
// nesse caso temos:
// INDEX_WIDTH = 16 - 10 - 2 = 4
// CACHE_SIZE = 2 ** 4 = 16
// CACHE_SIZE * DATA_WIDTH / 8 = 16 * 32 / 8 = 64 bytes

module INNER_CACHE #(
    parameter DATA_WIDTH   = 32,
    parameter ADDR_WIDTH   = 16,
    parameter TAG_WIDTH    = 10,
    parameter OFFSET_WIDTH = 2
)(
    input logic clk,
    input logic rst_n,
    
    // Cache interface
    input logic [ADDR_WIDTH-1:0] addr,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic write_enable,
    output logic [DATA_WIDTH-1:0] data_out,
    
    // Status signals
    output logic hit,
    output logic miss
);


localparam INDEX_WIDTH = ADDR_WIDTH - TAG_WIDTH - OFFSET_WIDTH;
localparam CACHE_SIZE = 2 ** INDEX_WIDTH;

logic [TAG_WIDTH-1:0] tags [0:CACHE_SIZE-1];
logic [DATA_WIDTH-1:0] cache_data [0:CACHE_SIZE-1];
logic valid [0:CACHE_SIZE-1];
logic [INDEX_WIDTH-1:0] index;

integer i;

assign index    = addr[ADDR_WIDTH-1:OFFSET_WIDTH];
assign hit      = valid[index] && (tags[index] == addr[ADDR_WIDTH-1:OFFSET_WIDTH + TAG_WIDTH]);
assign data_out = cache_data[index];
assign miss     = !hit;

always_ff @( posedge clk ) begin : CACHE_LOGIC
    if(!rst_n) begin
        for(i = 0; i < CACHE_SIZE; i++) begin
            valid[i] <= 1'b0;
        end
    end else begin
        if(write_enable) begin
            cache_data[index] <= data_in;
            tags[index] <= addr[ADDR_WIDTH-1:OFFSET_WIDTH + TAG_WIDTH];
            valid[index] <= 1'b1;
        end
    end
end

endmodule