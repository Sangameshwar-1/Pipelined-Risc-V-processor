
module barrel_sll(
    input [63:0] in,
    input [63:0] shift_amount,
    output [63:0] out,
    output carry,
    output overflow,
    output zero
);

wire [63:0] stage0, stage1, stage2, stage3, stage4;
muxlayer64 layer0 (
    .in0(in),
    .in1({in[62:0],1'b0}),
    .select(shift_amount[0]),
    .out(stage0)
);
muxlayer64 layer1 (
    .in0(stage0),
    .in1({stage0[61:0],{2{1'b0}}}),
    .select(shift_amount[1]),
    .out(stage1)
);
muxlayer64 layer2 (
    .in0(stage1),
    .in1({stage1[59:0],{4{1'b0}}}),
    .select(shift_amount[2]),
    .out(stage2)
);
muxlayer64 layer3 (
    .in0(stage2),
    .in1({stage2[55:0],{8{1'b0}}}),
    .select(shift_amount[3]),
    .out(stage3)
);
muxlayer64 layer4 (
    .in0(stage3),
    .in1({stage3[47:0],{16{1'b0}}}),
    .select(shift_amount[4]),
    .out(stage4)
);
muxlayer64 layer5 (
    .in0(stage4),
    .in1({stage4[31:0],{32{1'b0}}}),
    .select(shift_amount[5]),
    .out(out)
);

assign carry = 0;
assign overflow = 0;
zero_check zero_inst (
    .a(out),
    .zero(zero)
);

endmodule
