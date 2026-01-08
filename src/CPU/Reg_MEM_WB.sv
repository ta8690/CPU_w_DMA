module Reg_MEM_WB (
    input clk,
    input rst,
    input [4:0] opcode,
    input opcode_LSB,
    input [2:0] funct3,
    input [5:0] rd_index,
    input [`CPU_DATA_BITS-1:0] alu_out,
    input axi_stall,
    input axi_stall_DM_read,
    //
    input RVALID_Data,
    //
    input [`CPU_DATA_BITS-1:0] ld_data,
    output logic [4:0] MEM_WB_opcode,
    output logic MEM_WB_opcode_LSB,
    output logic [2:0] MEM_WB_funct3,
    output logic [5:0] MEM_WB_rd_index,
    output logic [`CPU_DATA_BITS-1:0] MEM_WB_alu_out,
    output logic [`CPU_DATA_BITS-1:0] MEM_WB_ld_data
);
    logic [`CPU_DATA_BITS-1:0] temp_ld_data;
    logic past_axi_stall_DM_read;

    always @(posedge clk or posedge rst) begin
        if(rst) past_axi_stall_DM_read <= 1'b0;
        else past_axi_stall_DM_read <= axi_stall_DM_read;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) temp_ld_data <= `CPU_DATA_BITS'b0;
        else if(RVALID_Data) temp_ld_data <= ld_data; 
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB_opcode <= 5'b0;
            MEM_WB_opcode_LSB <= 1'b0;
            MEM_WB_funct3 <= 3'b0;
            MEM_WB_rd_index <= 6'b0;
            MEM_WB_alu_out <= `CPU_DATA_BITS'b0;
            MEM_WB_ld_data <= `CPU_DATA_BITS'b0;
        end 
        else begin
            if(!axi_stall) begin
                MEM_WB_opcode <= opcode;
                MEM_WB_opcode_LSB <= opcode_LSB;
                MEM_WB_funct3 <= funct3;
                MEM_WB_rd_index <= rd_index;
                MEM_WB_alu_out <= alu_out;
                if(!past_axi_stall_DM_read)
                    MEM_WB_ld_data <= temp_ld_data;
                else
                    MEM_WB_ld_data <= ld_data;
            end
        end
    end
endmodule
