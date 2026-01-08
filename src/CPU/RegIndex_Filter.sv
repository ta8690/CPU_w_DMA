module RegIndex_Filter(
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    input [4:0] rd_index,
    input [4:0] opcode,
    output logic [5:0] n_rs1_index,
    output logic [5:0] n_rs2_index,
    output logic [5:0] n_rd_index
);

//R-type, S-type, B-type, FSW, FADD.s, FSUB.S use rs2
logic [4:0] use_rs2_index;
logic [4:0] use_rd_index;
assign use_rs2_index = (opcode == `R_type || opcode == `STORE || opcode == `B_type || opcode == `FSW || opcode == `F_type)? rs2_index:5'd0;
assign use_rd_index = (opcode == `STORE || opcode == `B_type || opcode == `FSW)? 5'd0:rd_index;


always @(*) begin
    case(opcode)
        5'b00001:begin//FLW
            n_rs1_index = {1'b0, rs1_index};
            n_rs2_index = {1'b0, use_rs2_index};
            n_rd_index = {1'b1, use_rd_index};
        end
        5'b01001:begin//FSW
            n_rs1_index = {1'b0, rs1_index};
            n_rs2_index = {1'b1, use_rs2_index};
            n_rd_index = {1'b0, use_rd_index};
        end
        5'b10100:begin//FADD.S, FSUB.S
            n_rs1_index = {1'b1, rs1_index};
            n_rs2_index = {1'b1, use_rs2_index};
            n_rd_index = {1'b1, use_rd_index};          
        end
        default:begin
            n_rs1_index = {1'b0, rs1_index};
            n_rs2_index = {1'b0, use_rs2_index};
            n_rd_index = {1'b0, use_rd_index};  
        end
    endcase
end


endmodule