module Jump_Branch (
    input [`CPU_DATA_BITS-1:0] imm_ext,
    input [`CPU_DATA_BITS-1:0] jb_operand,
    input [`CPU_DATA_BITS-1:0] rs1_data,
    input [`CPU_DATA_BITS-1:0] rs2_data,
    input [4:0] opcode,
    input [2:0] funct3,
    input stall,
    output logic flush,
    output logic [`CPU_DATA_BITS-1:0] jb_out
);

    logic Is_Branch;

    assign jb_out = jb_operand + imm_ext;
    always @(*) begin
        if (opcode == `B_type) begin
            case (funct3)
                3'b000:  // BEQ
                Is_Branch = (rs1_data == rs2_data) ? 1'b1 : 1'b0;
                3'b001:  // BNE
                Is_Branch = (rs1_data != rs2_data) ? 1'b1 : 1'b0;
                3'b100:  // BLT
                Is_Branch = ($signed(rs1_data) < $signed(rs2_data)) ? 1'b1 : 1'b0;
                3'b101:  // BGE
                Is_Branch = ($signed(rs1_data) >= $signed(rs2_data)) ? 1'b1 : 1'b0;
                3'b110:  // BLTU
                Is_Branch = (rs1_data < rs2_data) ? 1'b1 : 1'b0;
                3'b111:  // BGEU
                Is_Branch = (rs1_data >= rs2_data) ? 1'b1 : 1'b0;
                default: Is_Branch = 1'b0;
            endcase
        end 
        else Is_Branch = 1'b0;
    end

    assign flush = ((opcode == `JAL || opcode == `JALR || Is_Branch) && !stall) ? 1'b1 : 1'b0;
endmodule
