module RegFile(
    input clk,
    input rst,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    input [5:0] MEM_WB_rd_index,
    input [`CPU_DATA_BITS-1:0] wb_data,
    input RegWrite,
    output [`CPU_DATA_BITS-1:0] rs1_data,
    output [`CPU_DATA_BITS-1:0] rs2_data
);

    logic [`CPU_DATA_BITS-1:0] int_register [0:31];
    
    assign rs1_data = int_register[rs1_index];
    assign rs2_data = int_register[rs2_index];

    integer i;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i=0;i<32;i=i+1)
                int_register[i] <= `CPU_DATA_BITS'b0;
        end
        else begin
            if(RegWrite && !MEM_WB_rd_index[5] && MEM_WB_rd_index[4:0] != 5'b0) 
                int_register[MEM_WB_rd_index[4:0]] <= wb_data;
        end
    end

endmodule