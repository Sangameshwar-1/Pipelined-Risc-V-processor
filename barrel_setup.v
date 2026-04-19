module mux2to1(
    input select,
    input in0,
    input in1,
    output out
);
wire not_select, and_0, and_1;
not(not_select, select);
and(and_0, in0, not_select);
and(and_1, in1, select);
or(out, and_0, and_1);
endmodule

module muxlayer64(
    input [63:0] in0,
    input [63:0] in1,
    input select,
    output [63:0] out
);
genvar i;
generate
    for (i=0;i<64;i=i+1) begin
        mux2to1 mux_inst (
            .select(select),
            .in0(in0[i]),
            .in1(in1[i]),
            .out(out[i])
        );
    end
endgenerate
endmodule