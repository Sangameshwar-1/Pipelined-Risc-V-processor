module branch_predictor (
    input         clk,
    input         reset,

    input  [63:0] if_pc,
    input  [31:0] if_instr,        
    output        predict_taken,   
    output [63:0] predict_target,  

    input         id_is_branch,    
    input  [63:0] id_pc,           
    input         id_actual_taken  
);

    reg [1:0] bht [0:15];

    integer i;
    wire [3:0] if_index = if_pc[5:2];
    wire       if_is_beq = (if_instr[6:0] == 7'b1100011) && (if_instr[14:12] == 3'b000);

    wire [63:0] if_imm = {{52{if_instr[31]}},
                          if_instr[31],
                          if_instr[7],
                          if_instr[30:25],
                          if_instr[11:8]};
    wire [63:0] if_imm_shifted = if_imm << 1;

    assign predict_taken  = if_is_beq & bht[if_index][1];
    assign predict_target = if_pc + if_imm_shifted;

    wire [3:0] id_index = id_pc[5:2];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                bht[i] <= 2'b00;   // initialise to Strongly Not Taken
        end
        else if (id_is_branch) begin
            if (id_actual_taken) begin
                if (bht[id_index] < 2'b11)
                    bht[id_index] <= bht[id_index] + 2'b01;
            end
            else begin
                if (bht[id_index] > 2'b00)
                    bht[id_index] <= bht[id_index] - 2'b01;
            end
        end
    end

endmodule
