

module sub64(
    input [63:0]a,
    input [63:0]b,
    output [63:0]sum,
    output cout,
    output overflow,
    output zero
);

wire [63:0]b_comp;

xor_gate inst(
    .a(b),
    .b({64{1'b1}}),
    .result(b_comp),
    .carry(),
    .overflow(),
    .zero()
);

wire carry;

adder64 inst_1(
    .a(a),
    .b(b_comp),
    .cin(1'b1),
    .sum(sum),
    .cout(carry),
    .overflow(overflow),
    .zero(zero)
);

assign cout = carry;
endmodule