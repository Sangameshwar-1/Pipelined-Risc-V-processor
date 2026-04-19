module instruction_mem_tb;

reg [63:0] addr;
wire [31:0] instr;

instruction_mem imem (
    .addr(addr),
    .instr(instr)
);

initial begin
    addr = 0;   #5;
    $display("instr @0 = %h", instr);

    addr = 4;   #5;
    $display("instr @4 = %h", instr);

    addr = 8;   #5;
    $display("instr @8 = %h", instr);

    $finish;
end

endmodule
