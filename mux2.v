module mux2 (
    input  [63:0] a,
    input  [63:0] b,
    input  sel,
    output [63:0] y
);

wire sel_bar;
wire [63:0] a_and;
wire [63:0] b_and;

not (sel_bar, sel);

genvar i;

generate
    for (i = 0; i < 64; i = i + 1) begin : mux_loop
        and (a_and[i], a[i], sel_bar);
        and (b_and[i], b[i], sel);
        or  (y[i], a_and[i], b_and[i]);
    end
endgenerate

endmodule
