module pc_mux (
    input [63:0] pc4,
    input [63:0] branch_addr,
    input branch_taken,
    output [63:0] next_pc
);
assign next_pc = branch_taken ? branch_addr : pc4;
endmodule
