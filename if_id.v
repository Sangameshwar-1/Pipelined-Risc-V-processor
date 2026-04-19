module if_id(
    input clk,
    input reset,
    input flush,
    input stall,

    input [63:0] pc_in,
    input [31:0] instr_in,
    input        predicted_taken_in,
    input [63:0] predict_target_in,

    output reg [63:0] pc_out,
    output reg [31:0] instr_out,
    output reg        predicted_taken_out,
    output reg [63:0] predict_target_out
);

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        pc_out              <= 64'd0;
        instr_out           <= 32'd0;
        predicted_taken_out <= 1'b0;
        predict_target_out  <= 64'd0;
    end
    else if (!stall) begin
        pc_out              <= pc_in;
        instr_out           <= instr_in;
        predicted_taken_out <= predicted_taken_in;
        predict_target_out  <= predict_target_in;
    end
end

endmodule