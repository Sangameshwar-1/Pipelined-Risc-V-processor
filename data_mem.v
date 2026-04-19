module data_mem(
    input clk,
    input memread,
    input memwrite,
    input reset,
    input [63:0] addr,
    input [63:0] write_data,
    output reg [63:0] read_data
);

reg [7:0] mem [0:1023];

integer i;

initial begin
    for (i = 0; i < 1024; i = i + 1)
        mem[i] = 8'd0;
end

always @(posedge clk) begin
    if (memwrite) begin
        mem[addr]     <= write_data[7:0];
        mem[addr + 1] <= write_data[15:8];
        mem[addr + 2] <= write_data[23:16];
        mem[addr + 3] <= write_data[31:24];
        mem[addr + 4] <= write_data[39:32];
        mem[addr + 5] <= write_data[47:40];
        mem[addr + 6] <= write_data[55:48];
        mem[addr + 7] <= write_data[63:56];
    end
end

always @(*) begin
    if (memread) begin
        read_data = {
            mem[addr + 7],
            mem[addr + 6],
            mem[addr + 5],
            mem[addr + 4],
            mem[addr + 3],
            mem[addr + 2],
            mem[addr + 1],
            mem[addr]
        };
    end
    else begin
        read_data = 64'd0;
    end
end

endmodule
