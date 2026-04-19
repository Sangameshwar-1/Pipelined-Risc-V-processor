module setlt(
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] result,
    output carry,
    output overflow,
    output zero
);

wire x1, x2;
wire [63:0] temp;

sub64 sub_inst (
    .a(a),
    .b(b),
    .sum(temp),
    .cout(),
    .overflow(x1),
    .zero()
);

assign x2 = temp[63];
xor(result[0], x1, x2);
assign result[63:1] = 63'b0;

assign carry    = 0;
assign overflow = 0;
not(zero, result[0]);

endmodule


module setltu (
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] result,
    output carry,
    output overflow,
    output zero
);

wire cout;

sub64 sub_inst (
    .a(a),
    .b(b),
    .sum(),
    .cout(cout),
    .overflow(),
    .zero()
);

not(result[0], cout);
assign result[63:1] = 63'b0;

assign carry    = 0;
assign overflow = 0;
not(zero, result[0]);

endmodule
