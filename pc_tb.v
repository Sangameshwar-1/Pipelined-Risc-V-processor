module pc_tb;

reg clk;
reg reset;
reg [63:0] pc_in;
wire [63:0] pc_out;

pc uut (
    .clk(clk),
    .reset(reset),
    .pc_in(pc_in),
    .pc_out(pc_out)
);

always #5 clk = ~clk;

initial begin
    $display("time  reset  pc_in  pc_out");

    clk = 0;
    reset = 1;
    pc_in = 0;

    #10 reset = 0;

    pc_in = 4;   #10;
    pc_in = 8;   #10;
    pc_in = 12;  #10;
    pc_in = 16;  #10;

    $finish;
end

always @(posedge clk)
    $display("%0t   %b     %d     %d", $time, reset, pc_in, pc_out);

endmodule
