module id_ex(
    input clk,
    input reset,
    input flush,

    input  [63:0] pc_in,
    output reg [63:0] pc_out,

    input  [63:0] rd1_in,
    input  [63:0] rd2_in,
    output reg [63:0] rd1_out,
    output reg [63:0] rd2_out,

    input  [63:0] imm_in,
    output reg [63:0] imm_out,

    input  [4:0] rs1_in,
    input  [4:0] rs2_in,
    input  [4:0] rd_in,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    input  alusrc_in,
    input  [1:0] aluop_in,
    input  [2:0] funct3_in,
    input  funct7_5_in,
    output reg alusrc_out,
    output reg [1:0] aluop_out,
    output reg [2:0] funct3_out,
    output reg funct7_5_out,

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
    if (reset || flush) begin
        pc_out       <= 64'd0;
        rd1_out      <= 64'd0;
        rd2_out      <= 64'd0;
        imm_out      <= 64'd0;
        rs1_out      <= 5'd0;
        rs2_out      <= 5'd0;
        rd_out       <= 5'd0;
        alusrc_out   <= 1'b0;
        aluop_out    <= 2'b0;
        funct3_out   <= 3'b0;
        funct7_5_out <= 1'b0;
        branch_out   <= 1'b0;
        memread_out  <= 1'b0;
        memwrite_out <= 1'b0;
        memtoreg_out <= 1'b0;
        regwrite_out <= 1'b0;
    end
    else begin
        pc_out       <= pc_in;
        rd1_out      <= rd1_in;
        rd2_out      <= rd2_in;
        imm_out      <= imm_in;
        rs1_out      <= rs1_in;
        rs2_out      <= rs2_in;
        rd_out       <= rd_in;
        alusrc_out   <= alusrc_in;
        aluop_out    <= aluop_in;
        funct3_out   <= funct3_in;
        funct7_5_out <= funct7_5_in;
        branch_out   <= branch_in;
        memread_out  <= memread_in;
        memwrite_out <= memwrite_in;
        memtoreg_out <= memtoreg_in;
        regwrite_out <= regwrite_in;
    end
end

endmodule