module Reg_EXE_MEM (
    input clk,
    input rst,
    input [4:0] opcode,
    input opcode_LSB,
    input [2:0] funct3,
    input funct7_mul,
    input [5:0] rd_index,
    input [`CPU_DATA_BITS-1:0] rs2_data,
    input [`CPU_DATA_BITS-1:0] operand1,
    input [`CPU_DATA_BITS-1:0] operand2,
    input [`CPU_DATA_BITS-1:0] alu_out,
    input [`CPU_DATA_BITS-1:0] csr_o,
    input axi_stall,
    //
    output logic [4:0] EXE_MEM_opcode,
    output logic EXE_MEM_opcode_LSB,
    output logic [2:0] EXE_MEM_funct3,
    output logic EXE_MEM_funct7_mul,
    output logic [5:0] EXE_MEM_rd_index,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM_rs2_data,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM_operand1,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM_operand2,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM_alu_out,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM_csr_o
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EXE_MEM_opcode <= 5'b0;
            EXE_MEM_opcode_LSB <= 1'b0;
            EXE_MEM_funct3 <= 3'b0;
            EXE_MEM_funct7_mul <= 1'b0;
            EXE_MEM_rd_index <= 6'b0;
            EXE_MEM_rs2_data <= `CPU_DATA_BITS'b0;
            EXE_MEM_operand1 <= `CPU_DATA_BITS'b0;
            EXE_MEM_operand2 <= `CPU_DATA_BITS'b0;
            EXE_MEM_alu_out <= `CPU_DATA_BITS'b0;
            EXE_MEM_csr_o <= `CPU_DATA_BITS'b0;
        end 
        else begin
            if(!axi_stall) begin
                EXE_MEM_opcode <= opcode;
                EXE_MEM_opcode_LSB <= opcode_LSB;
                EXE_MEM_funct3 <= funct3;
                EXE_MEM_funct7_mul <= funct7_mul;
                EXE_MEM_rd_index <= rd_index;
                EXE_MEM_rs2_data <= rs2_data;
                EXE_MEM_operand1 <= operand1;
                EXE_MEM_operand2 <= operand2;
                EXE_MEM_alu_out <= alu_out;
                EXE_MEM_csr_o <= csr_o;
            end
        end
    end

endmodule
