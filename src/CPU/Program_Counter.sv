module Program_Counter(
    input clk,
    input rst,
    input stall,
    input axi_stall,
    input [`CPU_DATA_BITS-1:0] next_pc,
    output logic [`CPU_DATA_BITS-1:0] pc
);

    always @(posedge clk or posedge rst) begin
        if(rst) pc <= `CPU_DATA_BITS'b0;
        else begin
            if(!stall & !axi_stall)
                pc <= next_pc;
        end
    end

endmodule