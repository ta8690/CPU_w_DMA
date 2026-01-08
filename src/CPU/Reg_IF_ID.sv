module Reg_IF_ID(
    input clk,
    input rst,
    input [`CPU_DATA_BITS-1:0] pc,
    input [`CPU_DATA_BITS-1:0] inst,
    input stall,
    input axi_stall,
    input axi_stall_IM_read,
    //
    input RVALID_Inst,
    //
    input flush,
    output logic [`CPU_DATA_BITS-1:0] IF_ID_pc,
    output logic [`CPU_DATA_BITS-1:0] IF_ID_inst
);

    logic  [`CPU_DATA_BITS-1:0] temp_inst;
    logic past_axi_stall_IM_read;

    always @(posedge clk or posedge rst) begin
        if(rst) past_axi_stall_IM_read <= 1'b0;
        else past_axi_stall_IM_read <= axi_stall_IM_read;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) temp_inst <= `CPU_DATA_BITS'b0;
        else if(RVALID_Inst) temp_inst <= inst; 
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IF_ID_pc <= `CPU_DATA_BITS'b0;
            IF_ID_inst <= `CPU_DATA_BITS'b0;
        end
        else begin
            if(stall | axi_stall) begin
                IF_ID_pc <= IF_ID_pc;
                IF_ID_inst <= IF_ID_inst;
            end
            else if(flush) begin
                IF_ID_pc <= `CPU_DATA_BITS'b0;
                IF_ID_inst <= `CPU_DATA_BITS'b0;
            end
            else begin
                IF_ID_pc <= pc;
                if(!past_axi_stall_IM_read)
                    IF_ID_inst <= temp_inst;
                else
                    IF_ID_inst <= inst;
            end
        end
    end


endmodule