module ex_mem(
    input clk,
    input reset,

    input  [63:0] alu_result_in,
    output reg [63:0] alu_result_out,

    input  [63:0] rd2_in,
    output reg [63:0] rd2_out,

    input  [4:0] rd_in,
    output reg [4:0] rd_out,

    input  zero_in,
    output reg zero_out,

    input  branch_in,
    input  memread_in,
    input  memwrite_in,
    output reg branch_out,
    output reg memread_out,
    output reg memwrite_out,

    input  memtoreg_in,
    input  regwrite_in,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alu_result_out <= 64'd0;
        rd2_out        <= 64'd0;
        rd_out         <= 5'd0;
        zero_out       <= 1'b0;
        branch_out     <= 1'b0;
        memread_out    <= 1'b0;
        memwrite_out   <= 1'b0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end
    else begin
        alu_result_out <= alu_result_in;
        rd2_out        <= rd2_in;
        rd_out         <= rd_in;
        zero_out       <= zero_in;
        branch_out     <= branch_in;
        memread_out    <= memread_in;
        memwrite_out   <= memwrite_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
    end
end

endmodule