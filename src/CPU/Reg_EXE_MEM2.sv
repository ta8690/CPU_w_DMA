module Reg_EXE_MEM2 (
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
    input [`CPU_DATA_BITS-1:0] mul_out,
    input [`CPU_DATA_BITS-1:0] alu_csr,
    input axi_stall,
    //
    input RVALID_Data,
    //
    output logic [4:0] EXE_MEM2_opcode,
    output logic EXE_MEM2_opcode_LSB,
    output logic [2:0] EXE_MEM2_funct3,
    output logic EXE_MEM2_funct7_mul,
    output logic [5:0] EXE_MEM2_rd_index,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM2_rs2_data,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM2_mul_out,
    output logic [`CPU_DATA_BITS-1:0] EXE_MEM2_alu_csr
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EXE_MEM2_opcode <= 5'b0;
            EXE_MEM2_opcode_LSB <= 1'b0;
            EXE_MEM2_funct3 <= 3'b0;
            EXE_MEM2_funct7_mul <= 1'b0;
            EXE_MEM2_rd_index <= 6'b0;
            EXE_MEM2_rs2_data <= `CPU_DATA_BITS'b0;
            EXE_MEM2_mul_out <= `CPU_DATA_BITS'b0;
            EXE_MEM2_alu_csr <= `CPU_DATA_BITS'b0;
        end 
        else begin
            if(!axi_stall) begin
                EXE_MEM2_opcode <= opcode;
                EXE_MEM2_opcode_LSB <= opcode_LSB;
                EXE_MEM2_funct3 <= funct3;
                EXE_MEM2_funct7_mul <= funct7_mul;
                EXE_MEM2_rd_index <= rd_index;
                EXE_MEM2_rs2_data <= rs2_data;
                EXE_MEM2_mul_out <= mul_out;
                EXE_MEM2_alu_csr <= alu_csr;
            end
            else begin
                if(RVALID_Data) 
                    EXE_MEM2_opcode_LSB <= 1'b0;
            end
        end
    end

endmodule