module Imm_Extend(
    input [`CPU_DATA_BITS-1:0] inst,
    output logic [`CPU_DATA_BITS-1:0] imm_ext
);
    logic [4:0] opcode;
    assign opcode = inst[6:2];

    always @(*) begin
        case(opcode)
            `LOAD, `I_type, `JALR, `CSR, `FLW: imm_ext = {{20{inst[31]}}, inst[31:20]};
            `STORE, `FSW: imm_ext = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            `B_type: imm_ext = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            `AUIPC, `LUI: imm_ext = {inst[31:12], 12'b0};
            `JAL: imm_ext = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            default: imm_ext = `CPU_DATA_BITS'b0;
        endcase
    end


endmodule