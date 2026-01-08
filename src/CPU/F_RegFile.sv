module F_RegFile(
    input clk,
    input rst,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    input [5:0] MEM_WB_rd_index,
    input [`CPU_DATA_BITS-1:0] wb_data,
    input RegWrite,
    output [`CPU_DATA_BITS-1:0] frs1_data,
    output [`CPU_DATA_BITS-1:0] frs2_data
);

    logic [`CPU_DATA_BITS-1:0] f_register [0:31];
    
    assign frs1_data = f_register[rs1_index];
    assign frs2_data = f_register[rs2_index];

    integer i;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i=0;i<32;i=i+1)
                f_register[i] <= `CPU_DATA_BITS'b0;
        end
        else begin
            if(RegWrite & MEM_WB_rd_index[5]) 
                f_register[MEM_WB_rd_index[4:0]] <= wb_data;
        end
    end

endmodule