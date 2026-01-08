module LOAD_Unit (
    input [2:0] funct3,
    input [`CPU_DATA_BITS-1:0] ld_data,
    output logic [`CPU_DATA_BITS-1:0] ld_data_aligned
);
    always @(*) begin
        case (funct3)
            3'b000:  ld_data_aligned = {{24{ld_data[7]}}, ld_data[7:0]};  // LH
            3'b001:  ld_data_aligned = {{16{ld_data[15]}}, ld_data[15:0]};  // LH
            3'b010:  ld_data_aligned = ld_data;  // LW
            3'b100:  ld_data_aligned = {24'b0, ld_data[7:0]};  // LBU
            3'b101:  ld_data_aligned = {16'b0, ld_data[15:0]};  //LHU
            default: ld_data_aligned = `CPU_DATA_BITS'b0;  // LW
        endcase
    end


endmodule
