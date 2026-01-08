module ALU (
    input [2:0] funct3,
    input [4:0] funct5,
    input [6:0] funct7,
    input [4:0] opcode,
    input [`CPU_DATA_BITS-1:0] operand1,
    input [`CPU_DATA_BITS-1:0] operand2,
    output logic [`CPU_DATA_BITS-1:0] alu_out
);

    logic [`CPU_DATA_BITS-1:0] FB_M;
    logic [`CPU_DATA_BITS-1:0] FA, FB;
    logic FA_S, FB_S;
    logic [7:0] FA_E, FB_E;
    logic [22:0] FA_F, FB_F;
    logic [`CPU_DATA_BITS-2:0] FA_F_ext, FB_F_ext;
    logic [7:0] exp_diff;
    logic [`CPU_DATA_BITS-2:0] FB_F_sh;
    logic [`CPU_DATA_BITS-2:0] FA_F_comp, FB_F_comp;
    logic [`CPU_DATA_BITS-2:0] FS_F_cal, FS_F_comp;
    logic [4:0] FS_shift_num;
    //Normalized
    logic FS_S;
    logic [7:0] FS_E;
    logic [27:0] FS_F;

    //Compute F_shift_num
    logic [28:0] F_num;



    always @(*) begin
        case (opcode)
            `R_type: begin
                case (funct3)
                    3'b000: begin
                        if (funct7[5]) alu_out = operand1 - operand2;
                        else alu_out = operand1 + operand2;
                    end
                    3'b001:  alu_out = operand1 << operand2[4:0];
                    3'b010:  alu_out = ($signed(operand1) < $signed(operand2)) ? 1'b1 : 1'b0;
                    3'b011:  alu_out = (operand1 < operand2) ? 1'b1 : 1'b0;
                    3'b100:  alu_out = operand1 ^ operand2;
                    3'b101: begin
                        // SRA
                        if (funct7[5])
                            alu_out = $signed(
                                operand1
                            ) >>> operand2[4:0];  // padding operand1[31] at MSB
                        // SRL
                        else
                            alu_out = operand1 >> operand2[4:0];  // padding zero at MSB
                    end
                    3'b110:  alu_out = operand1 | operand2;
                    default: alu_out = operand1 & operand2;
                endcase
            end
            `I_type: begin
                case (funct3)
                    3'b000: alu_out = operand1 + operand2;  // ADDI
                    3'b001: alu_out = operand1 << operand2[4:0];  // SLLI
                    3'b101: begin
                        // SRAI
                        if (funct7[5]) alu_out = $signed(operand1) >>> operand2[4:0];
                        // SRLI
                        else
                            alu_out = operand1 >> operand2[4:0];
                    end
                    3'b010:
                    alu_out = ($signed(operand1) < $signed(operand2)) ? 1'b1 : 1'b0;  // SLTI
                    3'b011: alu_out = (operand1 < operand2) ? 1'b1 : 1'b0;  // SLTIU
                    3'b100: alu_out = operand1 ^ operand2;
                    3'b110: alu_out = operand1 | operand2;
                    default: alu_out = operand1 & operand2;
                endcase
            end
            // Compute MEM address
            `LOAD, `STORE, `FLW, `FSW: alu_out = operand1 + operand2;
            // JUMP
            `JALR, `JAL: alu_out = operand1 + 32'd4;
            `AUIPC: alu_out = operand1 + operand2;
            `LUI: alu_out = operand2;

            //////////////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////FADD.S, FSUB.S///////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////////////    
            `F_type: begin  // 32bit single precision
                if ({FS_S, FS_E, FS_F} != 37'd0) begin
                    case (FS_F[4:3])
                        2'b00, 2'b01: alu_out = {FS_S, FS_E, FS_F[27:5]};
                        2'b10: begin
                            if (FS_F[2])  //check stick bit
                                alu_out = {FS_S, FS_E, (FS_F[27:5] + 23'd1)};
                            else begin
                                if (FS_F[5])  //Round to nearest, Tie to even
                                    alu_out = {FS_S, FS_E, (FS_F[27:5] + 23'd1)};
                                else alu_out = {FS_S, FS_E, FS_F[27:5]};
                            end
                        end
                        default: alu_out = {FS_S, FS_E, (FS_F[27:5] + 23'd1)};
                    endcase
                end else alu_out = `CPU_DATA_BITS'd0;
            end
            default: alu_out = `CPU_DATA_BITS'b0;
        endcase
    end

    assign FA = operand1;
    assign FB = operand2;

    assign FB_M = {funct5 ^ FB[31], FB[30:0]};
    assign {FA_S, FA_E, FA_F} = (FA[30:23] > FB[30:23]) ? FA : FB_M;
    assign {FB_S, FB_E, FB_F} = (FA[30:23] > FB[30:23]) ? FB_M : FA;

    assign FA_F_ext = {3'b001, FA_F, 5'b0};
    assign FB_F_ext = {3'b001, FB_F, 5'b0};

    assign exp_diff = FA_E - FB_E;
    assign FB_F_sh = FB_F_ext >> exp_diff;

    assign FA_F_comp = (FA_S) ? ~FA_F_ext + 31'd1 : FA_F_ext;
    assign FB_F_comp = (FB_S) ? ~FB_F_sh + 31'd1 : FB_F_sh;

    assign FS_F_cal = FA_F_comp + FB_F_comp;
    assign FS_F_comp = (FS_F_cal[30]) ? ~FS_F_cal + 31'd1 : FS_F_cal;

    assign FS_S = FS_F_cal[30];
    assign FS_E = (FS_F_comp[29]) ? FA_E + 8'd1 : FA_E - (5'd28 - FS_shift_num);
    assign FS_F = (FS_F_comp[29]) ? FS_F_comp[28:1] : FS_F_comp[27:0] << (5'd28 - FS_shift_num);

    /////////////////////////////////
    assign F_num = FS_F_comp[28:0];

    always @(*) begin
        if (F_num[28] == 1'b1) FS_shift_num = 5'd28;
        else if (F_num[27] == 1'b1) FS_shift_num = 5'd27;
        else if (F_num[26] == 1'b1) FS_shift_num = 5'd26;
        else if (F_num[25] == 1'b1) FS_shift_num = 5'd25;
        else if (F_num[24] == 1'b1) FS_shift_num = 5'd24;
        else if (F_num[23] == 1'b1) FS_shift_num = 5'd23;
        else if (F_num[22] == 1'b1) FS_shift_num = 5'd22;
        else if (F_num[21] == 1'b1) FS_shift_num = 5'd21;
        else if (F_num[20] == 1'b1) FS_shift_num = 5'd20;
        else if (F_num[19] == 1'b1) FS_shift_num = 5'd19;
        else if (F_num[18] == 1'b1) FS_shift_num = 5'd18;
        else if (F_num[17] == 1'b1) FS_shift_num = 5'd17;
        else if (F_num[16] == 1'b1) FS_shift_num = 5'd16;
        else if (F_num[15] == 1'b1) FS_shift_num = 5'd15;
        else if (F_num[14] == 1'b1) FS_shift_num = 5'd14;
        else if (F_num[13] == 1'b1) FS_shift_num = 5'd13;
        else if (F_num[12] == 1'b1) FS_shift_num = 5'd12;
        else if (F_num[11] == 1'b1) FS_shift_num = 5'd11;
        else if (F_num[10] == 1'b1) FS_shift_num = 5'd10;
        else if (F_num[9] == 1'b1) FS_shift_num = 5'd9;
        else if (F_num[8] == 1'b1) FS_shift_num = 5'd8;
        else if (F_num[7] == 1'b1) FS_shift_num = 5'd7;
        else if (F_num[6] == 1'b1) FS_shift_num = 5'd6;
        else if (F_num[5] == 1'b1) FS_shift_num = 5'd5;
        else if (F_num[4] == 1'b1) FS_shift_num = 5'd4;
        else if (F_num[3] == 1'b1) FS_shift_num = 5'd3;
        else if (F_num[2] == 1'b1) FS_shift_num = 5'd2;
        else if (F_num[1] == 1'b1) FS_shift_num = 5'd1;
        else if (F_num[0] == 1'b1) FS_shift_num = 5'd0;
        else FS_shift_num = 5'd0;
    end

endmodule
