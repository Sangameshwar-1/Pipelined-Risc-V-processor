module zero_check(
    input [63:0]a,
    output zero
);

genvar i;

wire [62:0] or_var;
or(or_var[0],a[0],a[1]);
generate
    for(i=2;i<64;i=i+1) begin
        or(or_var[i-1],or_var[i-2],a[i]);
    end
endgenerate
not(zero,or_var[62]);
endmodule