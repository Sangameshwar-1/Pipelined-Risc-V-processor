module hazard_detection_unit(
    input [4:0] id_rs1,
    input [4:0] id_rs2,

    input [4:0] ex_rd,
    input       ex_memread,   // only stall for load

    output reg stall
);

always @(*) begin
    if (ex_memread &&
        ((ex_rd == id_rs1) || (ex_rd == id_rs2)) &&
        (ex_rd != 5'd0))
        stall = 1'b1;
    else
        stall = 1'b0;
end

endmodule