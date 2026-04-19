`include "pc.v"
`include "instruction_mem.v"
`include "register_file.v"
`include "control_unit.v"

module full_check_tb;

reg clk, reset;

wire [63:0] pc_out;
wire [63:0] pc_next;

wire [31:0] instr;
wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;

wire branch, memread, memtoreg, memwrite, alusrc, regwrite;
wire [1:0] aluop;

reg rf_we;
reg [63:0] rf_wdata;
wire [63:0] rd1, rd2;


pc pc0 (
    .clk(clk),
    .reset(reset),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

assign pc_next = pc_out + 64'd4;


instruction_mem im0 (
    .addr(pc_out),
    .instr(instr)
);


assign opcode = instr[6:0];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign rd     = instr[11:7];


control_unit cu0 (
    .opcode(opcode),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .aluop(aluop),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .regwrite(regwrite)
);


register_file rf0 (
    .clk(clk),
    .reset(reset),
    .read_reg1(rs1),
    .read_reg2(rs2),
    .write_reg(rd),
    .write_data(rf_wdata),
    .reg_write_en(rf_we),
    .read_data1(rd1),
    .read_data2(rd2)
);


always @(*) begin
    if (regwrite && rd != 0) begin
        rf_we    = 1;
        rf_wdata = pc_out + 200;   // visible test value
    end else begin
        rf_we    = 0;
        rf_wdata = 0;
    end
end


always #5 clk = ~clk;


initial begin
    clk = 0;
    reset = 1;

    repeat (2) @(posedge clk);
    reset = 0;

    #160 $finish;
end


always @(posedge clk) begin
    if (!reset) begin
        #1;
        $display(
        "pc=%0d instr=%h op=%b rd=%0d rs1=%0d rs2=%0d | regwrite=%b alusrc=%b memr=%b memw=%b br=%b | r1=%0d r2=%0d",
        pc_out, instr, opcode, rd, rs1, rs2,
        regwrite, alusrc, memread, memwrite, branch,
        rd1, rd2);
    end
end


endmodule
