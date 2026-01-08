module Decoder(
    input [`CPU_DATA_BITS-1:0] inst,
    output [2:0] funct3,
    output [4:0] funct5,
    output [6:0] funct7,
    output [4:0] opcode,
    output opcode_LSB,
    output [4:0] rs1_index,
    output [4:0] rs2_index,
    output [4:0] rd_index
);
    assign funct3 = inst[14:12];
    assign funct5 = inst[31:27];
    assign funct7 = inst[31:25];
    assign opcode = inst[6:2];
    assign opcode_LSB = inst[0];
    assign rs1_index = inst[19:15];
    assign rs2_index = inst[24:20];
    assign rd_index = inst[11:7];

endmodule