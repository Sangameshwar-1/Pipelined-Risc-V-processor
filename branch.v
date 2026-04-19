module branch_datapath(
    input clk,
    input branch,
    input [31:0] instruction,
    output [31:0] pc_out
);

wire [31:0] pc_current;
wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire [31:0] imm_out;
wire [31:0] reg_data1, reg_data2;
wire zero;
wire branch_taken;
wire [31:0] next_pc;

pc pc_reg (
    .clk(clk),
    .pc_in(next_pc),
    .pc_out(pc_current)
);

adder add_pc4 (
    .a(pc_current),
    .b(32'd4),
    .sum(pc_plus4)
);

imm_gen immgen (
    .instr(instruction),
    .imm_out(imm_out)
);

adder add_branch (
    .a(pc_current),
    .b(imm_out),
    .sum(branch_target)
);

reg_file rf (
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(5'b0),
    .wd(32'b0),
    .reg_write(1'b0),
    .rd1(reg_data1),
    .rd2(reg_data2)
);

alu comparator (
    .a(reg_data1),
    .b(reg_data2),
    .zero(zero)
);

and and_gate(branch_taken, branch, zero);

mux2 pc_mux (
    .a(pc_plus4),
    .b(branch_target),
    .sel(branch_taken),
    .y(next_pc)
);

assign pc_out = pc_current;

endmodule
