module shift_left1(
    input  [63:0] in,
    output [63:0] out
);

wire cout;
wire overflow;
wire zero;

adder64 add_inst(
    .a(in),
    .b(in),
    .cin(1'b0),
    .sum(out),
    .cout(cout),
    .overflow(overflow),
    .zero(zero)
);

endmodule

