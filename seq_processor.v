module seq_processor(
    input clk,
    input reset,
    output [63:0] dbg_pc,
    output [31:0] dbg_instr,
    output [63:0] dbg_rd1,
    output [63:0] dbg_rd2,
    output [63:0] dbg_alu_result,
    output dbg_regwrite
);

wire [31:0] if_instr;
wire [63:0] pc_out;
wire [63:0] pc4;

wire        bp_predict_taken;
wire [63:0] bp_predict_target;

wire [31:0] id_instr;
wire [63:0] id_pc;
wire        id_predicted_taken;   
wire [63:0] id_predict_target;    

wire [4:0] rs1    = id_instr[19:15];
wire [4:0] rs2    = id_instr[24:20];
wire [4:0] rd     = id_instr[11:7];
wire [2:0] funct3 = id_instr[14:12];

wire halt_if = (if_instr == 32'h00000000);

reg halt;

always @(posedge clk or posedge reset) begin
    if (reset)
        halt <= 1'b0;
    else if (halt_if)
        halt <= 1'b1;
end

wire branch, memread, memwrite, memtoreg, alusrc, regwrite;
wire [1:0] aluop;

wire stall;

wire [63:0] ex_pc;
wire [63:0] ex_rd1, ex_rd2;
wire [63:0] ex_imm;
wire [4:0]  ex_rs1, ex_rs2, ex_rd;
wire        ex_alusrc;
wire [1:0]  ex_aluop;
wire [2:0]  ex_funct3;
wire        ex_funct7_5;
wire        ex_branch;
wire        ex_memread, ex_memwrite;
wire        ex_memtoreg, ex_regwrite;

wire [63:0] mem_alu_result;
wire [63:0] mem_rd2;
wire [4:0]  mem_rd;
wire        mem_zero;
wire        mem_branch;
wire        mem_memread, mem_memwrite;
wire        mem_memtoreg, mem_regwrite;

wire [63:0] wb_alu_result;
wire [63:0] wb_mem_data;
wire [4:0]  wb_rd;
wire        wb_memtoreg, wb_regwrite;

wire [63:0] rd1, rd2;
wire [63:0] imm;
wire [63:0] id_imm_shifted;
wire [63:0] branch_addr;
wire [63:0] next_pc;
wire [63:0] alu_b, alu_result;
wire [3:0]  alu_opcode;
wire        zero;
wire [63:0] mem_data, write_back;
wire        branch_taken;
wire        id_zero;
wire        mispredict;       
wire        flush_ifid;       

wire [1:0]  forwardA, forwardB;
wire [63:0] alu_in_a, alu_in_b;

reg [31:0] instruction_count;

always @(posedge clk or posedge reset) begin
    if (reset)
        instruction_count <= 0;
    else if (!halt && !stall)
        instruction_count <= instruction_count + 1;
end

pc pc0(
    .clk(clk),
    .reset(reset),
    .pc_in(next_pc),
    .pc_out(pc_out)
);

pc_add add_pc4(
    .a(pc_out),
    .b(64'd4),
    .sum(pc4)
);

instruction_mem im0(
    .addr(pc_out),
    .clk(clk),
    .reset(reset),
    .instr(if_instr)
);

branch_predictor bp0(
    .clk(clk),
    .reset(reset),
    .if_pc(pc_out),
    .if_instr(if_instr),
    .predict_taken(bp_predict_taken),
    .predict_target(bp_predict_target),
    .id_is_branch(branch & (funct3 == 3'b000) & !stall),
    .id_pc(id_pc),
    .id_actual_taken(branch_taken)
);

if_id ifid0(
    .clk(clk),
    .reset(reset),
    .flush(flush_ifid),     
    .stall(stall),
    .pc_in(pc_out),
    .instr_in(if_instr),
    .predicted_taken_in(bp_predict_taken),
    .predict_target_in(bp_predict_target),
    .pc_out(id_pc),
    .instr_out(id_instr),
    .predicted_taken_out(id_predicted_taken),
    .predict_target_out(id_predict_target)
);

register_file rf0(
    .clk(clk),
    .reset(reset),
    .read_reg1(rs1),
    .read_reg2(rs2),
    .write_reg(wb_rd),
    .write_data(write_back),
    .reg_write_en(wb_regwrite & !halt & !halt_if),
    .instruction_count(instruction_count),
    .read_data1(rd1),
    .read_data2(rd2)
);

control_unit cu0(
    .opcode(id_instr[6:0]),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .aluop(aluop),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .regwrite(regwrite)
);

imm_gen ig0(
    .instr(id_instr),
    .imm(imm)
);

assign id_imm_shifted = imm << 1;

pc_add add_branch(
    .a(id_pc),
    .b(id_imm_shifted),
    .sum(branch_addr)
);


wire [63:0] mem_fwd_val = mem_memtoreg ? mem_data : mem_alu_result;

wire [63:0] branch_rs1_val =
    (ex_regwrite && !ex_memread && ex_rd != 5'd0 && ex_rd == rs1) ? alu_result :
    (mem_regwrite && mem_rd != 5'd0 && mem_rd == rs1) ? mem_fwd_val :
    rd1;

wire [63:0] branch_rs2_val =
    (ex_regwrite && !ex_memread && ex_rd != 5'd0 && ex_rd == rs2) ? alu_result :
    (mem_regwrite && mem_rd != 5'd0 && mem_rd == rs2) ? mem_fwd_val :
    rd2;

assign id_zero     = (branch_rs1_val == branch_rs2_val);
assign branch_taken = branch & (funct3 == 3'b000) & id_zero;

wire id_is_branch_instr = branch & (funct3 == 3'b000);
assign mispredict = id_is_branch_instr & (id_predicted_taken != branch_taken);

assign flush_ifid = mispredict & !stall;

hazard_detection_unit hdu0(
    .id_rs1(rs1),
    .id_rs2(rs2),
    .ex_rd(ex_rd),
    .ex_memread(ex_memread),
    .stall(stall)
);

id_ex idex0(
    .clk(clk),
    .reset(reset),
    .flush(stall),          // only stall inserts bubble now

    .pc_in(id_pc),              .pc_out(ex_pc),
    .rd1_in(rd1),               .rd1_out(ex_rd1),
    .rd2_in(rd2),               .rd2_out(ex_rd2),
    .imm_in(imm),               .imm_out(ex_imm),
    .rs1_in(rs1),               .rs1_out(ex_rs1),
    .rs2_in(rs2),               .rs2_out(ex_rs2),
    .rd_in(rd),                 .rd_out(ex_rd),

    .alusrc_in(alusrc),         .alusrc_out(ex_alusrc),
    .aluop_in(aluop),           .aluop_out(ex_aluop),
    .funct3_in(funct3),         .funct3_out(ex_funct3),
    .funct7_5_in(id_instr[30]), .funct7_5_out(ex_funct7_5),

    .branch_in(branch),         .branch_out(ex_branch),
    .memread_in(memread),       .memread_out(ex_memread),
    .memwrite_in(memwrite),     .memwrite_out(ex_memwrite),
    .memtoreg_in(memtoreg),     .memtoreg_out(ex_memtoreg),
    .regwrite_in(regwrite),     .regwrite_out(ex_regwrite)
);

assign alu_in_a = (forwardA == 2'b10) ? mem_alu_result :
                  (forwardA == 2'b01) ? write_back     :
                                        ex_rd1;

assign alu_in_b = (forwardB == 2'b10) ? mem_alu_result :
                  (forwardB == 2'b01) ? write_back     :
                                        ex_rd2;

alu_control ac0(
    .aluop(ex_aluop),
    .funct3(ex_funct3),
    .funct7_5(ex_funct7_5),
    .alu_opcode(alu_opcode)
);

mux2 alu_mux(
    .a(alu_in_b),
    .b(ex_imm),
    .sel(ex_alusrc),
    .y(alu_b)
);

alu_64_bit alu0(
    .a(alu_in_a),
    .b(alu_b),
    .opcode(alu_opcode),
    .result(alu_result),
    .cout(),
    .carry_flag(),
    .overflow_flag(),
    .zero_flag(zero)
);

forwarding_unit fu0(
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .mem_rd(mem_rd),
    .mem_regwrite(mem_regwrite),
    .wb_rd(wb_rd),
    .wb_regwrite(wb_regwrite),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

ex_mem exmem0(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),  .alu_result_out(mem_alu_result),
    .rd2_in(alu_in_b),           .rd2_out(mem_rd2),
    .rd_in(ex_rd),               .rd_out(mem_rd),
    .zero_in(zero),              .zero_out(mem_zero),

    .branch_in(ex_branch),       .branch_out(mem_branch),
    .memread_in(ex_memread),     .memread_out(mem_memread),
    .memwrite_in(ex_memwrite),   .memwrite_out(mem_memwrite),
    .memtoreg_in(ex_memtoreg),   .memtoreg_out(mem_memtoreg),
    .regwrite_in(ex_regwrite),   .regwrite_out(mem_regwrite)
);

data_mem dm0(
    .clk(clk),
    .memread(mem_memread & !halt & !halt_if),
    .reset(reset),
    .memwrite(mem_memwrite & !halt & !halt_if),
    .addr(mem_alu_result),
    .write_data(mem_rd2),
    .read_data(mem_data)
);

mem_wb memwb0(
    .clk(clk),
    .reset(reset),

    .alu_result_in(mem_alu_result),  .alu_result_out(wb_alu_result),
    .mem_data_in(mem_data),          .mem_data_out(wb_mem_data),
    .rd_in(mem_rd),                  .rd_out(wb_rd),
    .memtoreg_in(mem_memtoreg),      .memtoreg_out(wb_memtoreg),
    .regwrite_in(mem_regwrite),      .regwrite_out(wb_regwrite)
);

mux2 wb_mux(
    .a(wb_alu_result),
    .b(wb_mem_data),
    .sel(wb_memtoreg),
    .y(write_back)
);

wire [63:0] id_pc_plus4;
pc_add add_id_pc4(
    .a(id_pc),
    .b(64'd4),
    .sum(id_pc_plus4)
);

assign next_pc = halt         ? pc_out        :
                 stall        ? pc_out        :
                 mispredict   ? (branch_taken ? branch_addr : id_pc_plus4) :
                 bp_predict_taken ? bp_predict_target :
                                pc4;

assign dbg_pc         = pc_out;
assign dbg_instr      = id_instr;
assign dbg_rd1        = rd1;
assign dbg_rd2        = rd2;
assign dbg_alu_result = alu_result;
assign dbg_regwrite   = wb_regwrite;

endmodule