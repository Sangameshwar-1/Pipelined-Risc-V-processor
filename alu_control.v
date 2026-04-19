module alu_control (
    input  [1:0] aluop,
    input  [2:0] funct3,
    input        funct7_5,
    output reg [3:0] alu_opcode
);

always @(*) begin
    alu_opcode = 4'b0000;  // default = add

    if (aluop == 2'b10) begin
        case (funct3)

            3'b000: begin
                if (funct7_5 == 1'b0)
                    alu_opcode = 4'b0000;  // add
                else
                    alu_opcode = 4'b1000;  // sub
            end

            3'b111: alu_opcode = 4'b0111;  // and
            3'b110: alu_opcode = 4'b0110;  // or
            3'b100: alu_opcode = 4'b0100;  // xor
            3'b010: alu_opcode = 4'b0010;  // slt
            3'b011: alu_opcode = 4'b0011;  // sltu
            3'b001: alu_opcode = 4'b0001;  // sll
            3'b101: begin
                if (funct7_5 == 1'b0)
                    alu_opcode = 4'b0101;  // srl
                else
                    alu_opcode = 4'b1101;  // sra
            end
        endcase
    end

    else if (aluop == 2'b01) begin
        alu_opcode = 4'b1000;  // sub (for comparison)
    end

    else if (aluop == 2'b00) begin
        alu_opcode = 4'b0000;  // add
    end
end

endmodule
