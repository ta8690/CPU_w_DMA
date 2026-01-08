module Controller (
    input [4:0] opcode,
    input [6:0] ID_EXE_funct7,
    input [4:0] ID_EXE_opcode,
    input [4:0] EXE_MEM_opcode,
    input [4:0] EXE_MEM2_opcode,
    input [2:0] EXE_MEM_funct3,
    input [2:0] EXE_MEM2_funct3,
    input EXE_MEM_funct7_mul,
    input EXE_MEM2_funct7_mul,
    input [4:0] MEM_WB_opcode,
    input MEM_WB_opcode_LSB,
    output logic alu_operand1_sel,
    output logic alu_operand2_sel,
    output logic jb_operand_sel,
    output logic ID_EXE_mul_en,
    output logic EXE_MEM_mul_en,
    output logic EXE_MEM2_mul_en,
    output logic csr_en,
    output logic [3:0] BWEB,
    output logic [1:0] float_int_data_sel,
    output logic RegWrite,
    output logic wb_data_sel
);


    // alu_operand1_sel: 1->pc, 0->rs1
    always @(*) begin
        case (ID_EXE_opcode)
            `R_type, `LOAD, `I_type, `STORE, `FLW, `FSW, `F_type: alu_operand1_sel = 1'b0;
            default: alu_operand1_sel = 1'b1;  // `JALR, `AUIPC, `JAL     
        endcase
    end

    // alu_operand2_sel: 1->imm, 0->rs2
    always @(*) begin
        case (ID_EXE_opcode)
            `R_type, `F_type: alu_operand2_sel = 1'b0;
            default: alu_operand2_sel = 1'b1;  //  `LOAD, `I_type, `STORE, `JALR, `AUIPC, `JAL    
        endcase
    end

    // jb_operand_sel: 1->rs1, 0->pc **Compute next_pc**
    always @(*) begin
        case (opcode)
            `JAL, `B_type: jb_operand_sel = 1'b0;
            default: jb_operand_sel = 1'b1;  // `JALR    
        endcase
    end

    // alu_mul_csr_sel
    assign ID_EXE_mul_en = (ID_EXE_opcode == `R_type && ID_EXE_funct7[0]) ? 1'b1 : 1'b0;
    assign EXE_MEM_mul_en = (EXE_MEM_opcode == `R_type && EXE_MEM_funct7_mul) ? 1'b1 : 1'b0;
    assign EXE_MEM2_mul_en = (EXE_MEM2_opcode == `R_type && EXE_MEM2_funct7_mul) ? 1'b1 : 1'b0;
    assign csr_en = (EXE_MEM_opcode == `CSR) ? 1'b1 : 1'b0;

    // BWEB
    always @(*) begin
        if (EXE_MEM2_opcode == `STORE || EXE_MEM2_opcode == `FSW) begin
            case (EXE_MEM2_funct3)
                3'b000:  BWEB = 4'b0001;  // SB
                3'b001:  BWEB = 4'b0011;  // SH
                3'b010:  BWEB = 4'b1111;  // SW
                default: BWEB = 4'b0000;
            endcase
        end else BWEB = 4'b0000;
    end
    // float_int_data_sel
    always @(*) begin
        if (opcode == `F_type) float_int_data_sel = 2'b11;
        else if (opcode == `FSW) float_int_data_sel = 2'b01;
        else float_int_data_sel = 2'b00;
    end

    assign RegWrite = (MEM_WB_opcode != `B_type && MEM_WB_opcode != `STORE && MEM_WB_opcode != `FSW && MEM_WB_opcode != 5'b11111) ? 1'b1 : 1'b0;
    assign wb_data_sel = (MEM_WB_opcode == `LOAD || MEM_WB_opcode == `FLW) ? 1'b0 : 1'b1;


endmodule
