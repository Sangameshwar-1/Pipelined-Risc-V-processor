
module alu_64_bit(
    input [63:0] a,
    input [63:0] b,
    input [3:0] opcode,
    output [63:0] result,
    output cout,
    output carry_flag,
    output overflow_flag,
    output zero_flag
);

wire [63:0] result_add, result_sll, result_slt, result_sltu, result_xor, result_srl, result_or, result_and, result_sub, result_sra;
wire carry_add, carry_sll, carry_slt, carry_sltu, carry_xor, carry_srl, carry_or, carry_and, carry_sub, carry_sra;
wire overflow_add, overflow_sll, overflow_slt, overflow_sltu, overflow_xor, overflow_srl, overflow_or, overflow_and, overflow_sub, overflow_sra;
wire zero_add, zero_sll, zero_slt, zero_sltu, zero_xor, zero_srl, zero_or, zero_and, zero_sub, zero_sra;

adder64 add_inst(.a(a), .b(b), .cin(1'b0), .sum(result_add), .cout(carry_add), .overflow(overflow_add), .zero(zero_add));
barrel_sll sll_inst(.in(a), .shift_amount(b), .out(result_sll), .carry(carry_sll), .overflow(overflow_sll), .zero(zero_sll));
setlt slt_inst(.a(a), .b(b), .result(result_slt), .carry(carry_slt), .overflow(overflow_slt), .zero(zero_slt));
setltu sltu_inst(.a(a), .b(b), .result(result_sltu), .carry(carry_sltu), .overflow(overflow_sltu), .zero(zero_sltu));
xor_gate xor_op_inst(.a(a), .b(b), .result(result_xor), .carry(carry_xor), .overflow(overflow_xor), .zero(zero_xor));
barrel_srl srl_inst(.in(a), .shift_amount(b), .out(result_srl), .carry(carry_srl), .overflow(overflow_srl), .zero(zero_srl));
or_gate or_op_inst(.a(a), .b(b), .result(result_or), .carry(carry_or), .overflow(overflow_or), .zero(zero_or));
and_gate and_op_inst(.a(a), .b(b), .result(result_and), .carry(carry_and), .overflow(overflow_and), .zero(zero_and));
sub64 sub_inst(.a(a), .b(b), .sum(result_sub), .cout(carry_sub), .overflow(overflow_sub), .zero(zero_sub));
barrel_sra sra_inst(.in(a), .shift_amount(b), .out(result_sra), .carry(carry_sra), .overflow(overflow_sra), .zero(zero_sra));

assign result = (opcode == 4'b0000) ? result_add :
                 (opcode == 4'b0001) ? result_sll :
                 (opcode == 4'b0010) ? result_slt :
                 (opcode == 4'b0011) ? result_sltu :
                 (opcode == 4'b0100) ? result_xor :
                 (opcode == 4'b0101) ? result_srl :
                 (opcode == 4'b0110) ? result_or :
                 (opcode == 4'b0111) ? result_and :
                 (opcode == 4'b1000) ? result_sub :
                 (opcode == 4'b1101) ? result_sra : 64'b0;

assign carry_flag = (opcode == 4'b0000) ? carry_add :
                    (opcode == 4'b0001) ? carry_sll :
                    (opcode == 4'b0010) ? carry_slt :
                    (opcode == 4'b0011) ? carry_sltu :
                    (opcode == 4'b0100) ? carry_xor :
                    (opcode == 4'b0101) ? carry_srl :
                    (opcode == 4'b0110) ? carry_or :
                    (opcode == 4'b0111) ? carry_and :
                    (opcode == 4'b1000) ? carry_sub :
                    (opcode == 4'b1101) ? carry_sra : 1'b0;

assign overflow_flag = (opcode == 4'b0000) ? overflow_add :
                       (opcode == 4'b0001) ? overflow_sll :
                       (opcode == 4'b0010) ? overflow_slt :
                       (opcode == 4'b0011) ? overflow_sltu :
                       (opcode == 4'b0100) ? overflow_xor :
                       (opcode == 4'b0101) ? overflow_srl :
                       (opcode == 4'b0110) ? overflow_or :
                       (opcode == 4'b0111) ? overflow_and :
                       (opcode == 4'b1000) ? overflow_sub :
                       (opcode == 4'b1101) ? overflow_sra : 1'b0;

assign zero_flag = (opcode == 4'b0000) ? zero_add :
                   (opcode == 4'b0001) ? zero_sll :
                   (opcode == 4'b0010) ? zero_slt :
                   (opcode == 4'b0011) ? zero_sltu :
                   (opcode == 4'b0100) ? zero_xor :
                   (opcode == 4'b0101) ? zero_srl :
                   (opcode == 4'b0110) ? zero_or :
                   (opcode == 4'b0111) ? zero_and :
                   (opcode == 4'b1000) ? zero_sub :
                   (opcode == 4'b1101) ? zero_sra : 1'b0;
endmodule