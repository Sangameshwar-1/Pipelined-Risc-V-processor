module pc_add(
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] sum
);

wire [63:0] carry;
genvar i;

generate
    for (i = 0; i < 64; i = i + 1) begin : adder_loop
        if (i == 0) begin
            assign sum[i]   = a[i] ^ b[i];
            assign carry[i] = a[i] & b[i];
        end
        else begin
            assign sum[i]   = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    end
endgenerate

endmodule
