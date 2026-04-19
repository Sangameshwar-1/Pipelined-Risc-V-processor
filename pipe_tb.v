`include "add.v"
`include "sub.v"
`include "and.v"
`include "or.v"
`include "xor.v"
`include "slt_u.v"
`include "zero64.v"
`include "barrel_setup.v"
`include "barrel_sll.v"
`include "barrel_srl.v"
`include "barrel_sra.v"
`include "alu.v"
`include "pc.v"
`include "pc_add.v"
`include "pc_mux.v"
`include "shift_left1.v"
`include "instruction_mem.v"
`include "register_file.v"
`include "control_unit.v"
`include "alu_control.v"
`include "imm_gen.v"
`include "data_mem.v"
`include "mux2.v"
`include "if_id.v"
`include "id_ex.v"
`include "ex_mem.v"
`include "mem_wb.v"
`include "forwarding_unit.v"
`include "hazard_detection_unit.v"
`include "branch_predictor.v"
`include "seq_processor.v"

module pipe_tb;

reg clk;
reg reset;
integer cycle_count;

wire [63:0] dbg_pc;
wire [31:0] dbg_instr;
wire [63:0] dbg_rd1;
wire [63:0] dbg_rd2;
wire [63:0] dbg_alu_result;
wire        dbg_regwrite;

seq_processor uut(
    .clk(clk),
    .reset(reset),
    .dbg_pc(dbg_pc),
    .dbg_instr(dbg_instr),
    .dbg_rd1(dbg_rd1),
    .dbg_rd2(dbg_rd2),
    .dbg_alu_result(dbg_alu_result),
    .dbg_regwrite(dbg_regwrite)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    cycle_count = 0;
    #20 reset = 0;
end

always @(posedge clk) begin
    if (!reset) begin
        cycle_count = cycle_count + 1;

        $display("------------------------------------------------------------------------");
        $display("Cycle: %0d | Time: %0t", cycle_count, $time);
        $display("PC: %h | IF_INSTR: %h | ID_INSTR: %h",
                  uut.pc_out, uut.if_instr, uut.id_instr);
        $display("rs1=%0d rs2=%0d rd=%0d | rd1=%h rd2=%h",
                  uut.rs1, uut.rs2, uut.rd,
                  uut.rd1, uut.rd2);
        $display("ALU_RESULT: %h | REGWRITE: %b | WB_RD: %0d | WB_REGWRITE: %b",
                  uut.alu_result, uut.ex_regwrite,
                  uut.wb_rd, uut.wb_regwrite);
        $display("BP_PREDICT: %b | ACTUAL_TAKEN: %b | MISPREDICT: %b",
                  uut.id_predicted_taken, uut.branch_taken, uut.mispredict);

        if (uut.halt) begin
            $display("========================================");
            $display("HALT detected. Simulation finished.");
            $display("Total execution cycles: %0d", cycle_count);
            $display("========================================");
            $finish;
        end
    end
end

endmodule
