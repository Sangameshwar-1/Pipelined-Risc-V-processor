module comparator3(
    input [2:0] a,
    input [2:0] b,
    output eq
);

wire x0, x1, x2;

xnor (x0, a[0], b[0]);
xnor (x1, a[1], b[1]);
xnor (x2, a[2], b[2]);

and (eq, x0, x1, x2);

endmodule
