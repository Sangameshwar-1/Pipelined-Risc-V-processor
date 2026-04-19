module barrel_srl(
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
    .in1({1'b0,in[63:1]}),
    .select(shift_amount[0]),
    .out(stage0)
);
muxlayer64 layer1 (
    .in0(stage0),
    .in1({{2{1'b0}},stage0[63:2]}),
    .select(shift_amount[1]),
    .out(stage1)
);
muxlayer64 layer2 (
    .in0(stage1),
    .in1({{4{1'b0}},stage1[63:4]}),
    .select(shift_amount[2]),
    .out(stage2)
);
muxlayer64 layer3 (
    .in0(stage2),
    .in1({{8{1'b0}},stage2[63:8]}),
    .select(shift_amount[3]),
    .out(stage3)
);
muxlayer64 layer4 (
    .in0(stage3),
    .in1({{16{1'b0}},stage3[63:16]}),
    .select(shift_amount[4]),
    .out(stage4)
);
muxlayer64 layer5 (
    .in0(stage4),
    .in1({{32{1'b0}},stage4[63:32]}),
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