module forwarding_unit(
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,

    input [4:0]  mem_rd,
    input        mem_regwrite,

    input [4:0]  wb_rd,
    input        wb_regwrite,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    if (mem_regwrite && (mem_rd != 5'd0) && (mem_rd == ex_rs1))
        forwardA = 2'b10;  // EX hazard
    else if (wb_regwrite && (wb_rd != 5'd0) && (wb_rd == ex_rs1))
        forwardA = 2'b01;  // MEM hazard
    else
        forwardA = 2'b00;  // no hazard

    if (mem_regwrite && (mem_rd != 5'd0) && (mem_rd == ex_rs2))
        forwardB = 2'b10;  // EX hazard
    else if (wb_regwrite && (wb_rd != 5'd0) && (wb_rd == ex_rs2))
        forwardB = 2'b01;  // MEM hazard
    else
        forwardB = 2'b00;  // no hazard
end

endmodule