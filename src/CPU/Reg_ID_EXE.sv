module Reg_ID_EXE(
    input clk,
    input rst,
    input [`CPU_DATA_BITS-1:0] pc,
    input [`CPU_DATA_BITS-1:0] inst,
    input [`CPU_DATA_BITS-1:0] imm_ext,
    input [4:0] opcode,
    input opcode_LSB,
    input [2:0] funct3,
    input [4:0] funct5,
    input [6:0] funct7,
    input [5:0] rs1_index,
    input [5:0] rs2_index,
    input [5:0] rd_index,
    input [`CPU_DATA_BITS-1:0] rs1_data,
    input [`CPU_DATA_BITS-1:0] rs2_data,
    input stall,
    input axi_stall,
    output logic [`CPU_DATA_BITS-1:0] ID_EXE_pc,
    output logic [`CPU_DATA_BITS-1:0] ID_EXE_inst,
    output logic [`CPU_DATA_BITS-1:0] ID_EXE_imm_ext,
    output logic [4:0] ID_EXE_opcode,
    output logic ID_EXE_opcode_LSB,
    output logic [2:0] ID_EXE_funct3,
    output logic [4:0] ID_EXE_funct5,
    output logic [6:0] ID_EXE_funct7,
    output logic [5:0] ID_EXE_rs1_index,
    output logic [5:0] ID_EXE_rs2_index,
    output logic [5:0] ID_EXE_rd_index,
    output logic [`CPU_DATA_BITS-1:0] ID_EXE_rs1_data,
    output logic [`CPU_DATA_BITS-1:0] ID_EXE_rs2_data
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ID_EXE_pc <= `CPU_DATA_BITS'b0;
            ID_EXE_inst <= `CPU_DATA_BITS'b0;
            ID_EXE_imm_ext <= `CPU_DATA_BITS'b0;
            ID_EXE_opcode <= 5'b0;
            ID_EXE_opcode_LSB <= 1'b0;
            ID_EXE_funct3 <= 3'b0;
            ID_EXE_funct5 <= 5'b0;
            ID_EXE_funct7 <= 7'b0;
            ID_EXE_rs1_index <= 6'b0;
            ID_EXE_rs2_index <= 6'b0;
            ID_EXE_rd_index <= 6'b0;
            ID_EXE_rs1_data <= `CPU_DATA_BITS'b0;
            ID_EXE_rs2_data <= `CPU_DATA_BITS'b0;
        end
        else begin
            if(axi_stall) begin
                ID_EXE_pc <= ID_EXE_pc;
                ID_EXE_inst <= ID_EXE_inst;
                ID_EXE_imm_ext <= ID_EXE_imm_ext;
                ID_EXE_opcode <= ID_EXE_opcode;
                ID_EXE_opcode_LSB <= ID_EXE_opcode_LSB;
                ID_EXE_funct3 <= ID_EXE_funct3;
                ID_EXE_funct5 <= ID_EXE_funct5;
                ID_EXE_funct7 <= ID_EXE_funct7;
                ID_EXE_rs1_index <= ID_EXE_rs1_index;
                ID_EXE_rs2_index <= ID_EXE_rs2_index;
                ID_EXE_rd_index <= ID_EXE_rd_index;
                ID_EXE_rs1_data <= ID_EXE_rs1_data;
                ID_EXE_rs2_data <= ID_EXE_rs2_data;
            end
            else if(stall) begin
                ID_EXE_pc <= ID_EXE_pc;
                ID_EXE_inst <= ID_EXE_inst;
                ID_EXE_imm_ext <= ID_EXE_imm_ext;
                ID_EXE_opcode <= 5'b11111;
                ID_EXE_opcode_LSB <= 1'b0;
                ID_EXE_funct3 <= 3'b0;
                ID_EXE_funct5 <= 5'b0;
                ID_EXE_funct7 <= 7'b0;
                ID_EXE_rs1_index <= ID_EXE_rs1_index;
                ID_EXE_rs2_index <= ID_EXE_rs2_index;
                ID_EXE_rd_index <= ID_EXE_rd_index;
                ID_EXE_rs1_data <= ID_EXE_rs1_data;
                ID_EXE_rs2_data <= ID_EXE_rs2_data;
            end
            else begin
                ID_EXE_pc <= pc;
                ID_EXE_inst <= inst;
                ID_EXE_imm_ext <= imm_ext;
                ID_EXE_opcode <= opcode;
                ID_EXE_opcode_LSB <= opcode_LSB;
                ID_EXE_funct3 <= funct3;
                ID_EXE_funct5 <= funct5;
                ID_EXE_funct7 <= funct7;
                ID_EXE_rs1_index <= rs1_index;
                ID_EXE_rs2_index <= rs2_index;
                ID_EXE_rd_index <= rd_index;
                ID_EXE_rs1_data <= rs1_data;
                ID_EXE_rs2_data <= rs2_data;
            end
        end
    end


endmodule