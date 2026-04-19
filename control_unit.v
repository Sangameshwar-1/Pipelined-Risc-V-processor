module control_unit (
    input  [6:0] opcode,

    output reg branch,
    output reg memread,
    output reg memtoreg,
    output reg [1:0] aluop,
    output reg memwrite,
    output reg alusrc,
    output reg regwrite
);

always @(*) begin
    branch   = 0;
    memread  = 0;
    memtoreg = 0;
    aluop    = 2'b00;
    memwrite = 0;
    alusrc   = 0;
    regwrite = 0;

    if (opcode == 7'b0110011) begin
        regwrite = 1;
        alusrc   = 0;
        aluop    = 2'b10;
    end

    else if (opcode == 7'b0010011) begin
        regwrite = 1;
        alusrc   = 1;
        aluop    = 2'b00;
    end

    else if (opcode == 7'b0000011) begin
        regwrite = 1;
        memread  = 1;
        memtoreg = 1;
        alusrc   = 1;
        aluop    = 2'b00;
    end

    else if (opcode == 7'b0100011) begin
        memwrite = 1;
        alusrc   = 1;
        aluop    = 2'b00;
    end

    else if (opcode == 7'b1100011) begin
        branch = 1;
        alusrc = 0;
        aluop  = 2'b01;
    end

end

endmodule
