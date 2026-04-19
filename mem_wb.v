module mem_wb(
    input clk,
    input reset,

    input  [63:0] alu_result_in,
    output reg [63:0] alu_result_out,

    input  [63:0] mem_data_in,
    output reg [63:0] mem_data_out,

    input  [4:0] rd_in,
    output reg [4:0] rd_out,

    input  memtoreg_in,
    input  regwrite_in,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alu_result_out <= 64'd0;
        mem_data_out   <= 64'd0;
        rd_out         <= 5'd0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end
    else begin
        alu_result_out <= alu_result_in;
        mem_data_out   <= mem_data_in;
        rd_out         <= rd_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
    end
end

endmodule