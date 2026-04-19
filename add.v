module adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

wire x1,x2,x3;
xor(x1,a,b);
xor(sum,x1,cin);
and(x2,a,b);
and(x3,x1,cin);
or(cout,x3,x2);

endmodule

module adder64(
    input [63:0]a,
    input [63:0]b,
    input cin,
    output [63:0]sum,
    output cout,
    output overflow,
    output zero
);

wire [63:0]carry;

adder FA0(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(carry[0])
);

genvar i;
generate
    for(i=1;i<64;i=i+1) begin
        adder FA(
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i-1]),
            .sum(sum[i]),
            .cout(carry[i])
        );
    end
endgenerate

zero_check sum_inst(
    .a(sum),
    .zero(zero)
);

assign cout=carry[63];
xor(overflow,carry[62],carry[63]);

endmodule