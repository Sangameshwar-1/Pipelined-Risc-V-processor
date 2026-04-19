module and_gate(
    input [63:0]a,
    input [63:0]b,
    output [63:0]result,
    output carry,
    output overflow,
    output zero
);

genvar i;
generate 
    for(i=0;i<64;i=i+1) begin
        and(result[i],a[i],b[i]);
    end
endgenerate

assign carry=0;
assign overflow=0;
zero_check isnt(
    .a(result),
    .zero(zero)
);
endmodule