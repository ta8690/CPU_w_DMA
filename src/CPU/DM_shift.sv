module DM_shift (
    input [1:0] mem_addr_L2B,
    input [3:0] BWEB,
    input [`CPU_DATA_BITS-1:0] DM_data,
    output logic [`CPU_DATA_BITS-1:0] DM_data_shift,
    output logic [3:0] BWEB_shift
);

    always @(*) begin
        case (mem_addr_L2B)
            2'b01: begin
                BWEB_shift = {BWEB[2:0], 1'b0};
                DM_data_shift = {DM_data[23:0], 8'b0};
            end
            2'b10: begin
                BWEB_shift = {BWEB[1:0], 2'b0};
                DM_data_shift = {DM_data[15:0], 16'b0};
            end
            2'b11: begin
                BWEB_shift = {BWEB[0], 3'b0};
                DM_data_shift = {DM_data[7:0], 24'b0};
            end
            default: begin
                BWEB_shift = BWEB;
                DM_data_shift = DM_data;
            end
        endcase
    end

endmodule
