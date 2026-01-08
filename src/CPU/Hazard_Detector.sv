module Hazard_Detector (
    input [4:0] opcode,
    input [4:0] ID_EXE_opcode,
    input [4:0] EXE_MEM_opcode,
    input [4:0] EXE_MEM2_opcode,
    input [4:0] MEM_WB_opcode,
    input ID_EXE_opcode_LSB,
    input EXE_MEM_opcode_LSB,
    input EXE_MEM2_opcode_LSB,
    input MEM_WB_opcode_LSB,
    input [5:0] rs1_index,
    input [5:0] rs2_index,
    input [5:0] ID_EXE_rs1_index,
    input [5:0] ID_EXE_rs2_index,
    input [5:0] ID_EXE_rd_index,
    input [5:0] EXE_MEM_rd_index,
    input [5:0] EXE_MEM2_rd_index,
    input [5:0] MEM_WB_rd_index,
    input ID_EXE_mul_en,
    input EXE_MEM_mul_en,
    input EXE_MEM2_mul_en,
    output logic [1:0] IF_ID_rs1_data_sel,
    output logic [1:0] IF_ID_rs2_data_sel,
    output logic [1:0] ID_EXE_rs1_data_sel,
    output logic [1:0] ID_EXE_rs2_data_sel,
    output logic stall
);

    logic IF_ID_rs1_ID_EXE_rd_is_equal, IF_ID_rs2_ID_EXE_rd_is_equal;
    logic IF_ID_rs1_EXE_MEM_rd_is_equal, IF_ID_rs2_EXE_MEM_rd_is_equal;
    logic IF_ID_rs1_EXE_MEM2_rd_is_equal, IF_ID_rs2_EXE_MEM2_rd_is_equal;
    logic IF_ID_rs1_MEM_WB_rd_is_equal, IF_ID_rs2_MEM_WB_rd_is_equal;

    logic ID_EXE_rs1_MEM_WB_rd_is_equal, ID_EXE_rs2_MEM_WB_rd_is_equal;
    logic ID_EXE_rs1_EXE_MEM_rd_is_equal, ID_EXE_rs2_EXE_MEM_rd_is_equal;
    logic ID_EXE_rs1_EXE_MEM2_rd_is_equal, ID_EXE_rs2_EXE_MEM2_rd_is_equal;

    logic ID_EXE_use_rd, EXE_MEM_use_rd, EXE_MEM2_use_rd, MEM_WB_use_rd;

    logic IF_ID_src_ID_EXE_dst_is_equal, IF_ID_src_EXE_MEM_dst_is_equal, IF_ID_src_EXE_MEM2_dst_is_equal;


    // IF/ID src equals ID/EXE dst
    assign IF_ID_rs1_ID_EXE_rd_is_equal = (rs1_index == ID_EXE_rd_index) ? 1'b1 : 1'b0;
    assign IF_ID_rs2_ID_EXE_rd_is_equal = (rs2_index == ID_EXE_rd_index) ? 1'b1 : 1'b0;

    // IF/ID src equals EXE/MEM dst
    assign IF_ID_rs1_EXE_MEM_rd_is_equal = (rs1_index == EXE_MEM_rd_index) ? 1'b1 : 1'b0;
    assign IF_ID_rs2_EXE_MEM_rd_is_equal = (rs2_index == EXE_MEM_rd_index) ? 1'b1 : 1'b0;

    // IF/ID src equals EXE/MEM2 dst
    assign IF_ID_rs1_EXE_MEM2_rd_is_equal = (rs1_index == EXE_MEM2_rd_index) ? 1'b1 : 1'b0;
    assign IF_ID_rs2_EXE_MEM2_rd_is_equal = (rs2_index == EXE_MEM2_rd_index) ? 1'b1 : 1'b0;

    // IF/ID src equals MEM/WB dst
    assign IF_ID_rs1_MEM_WB_rd_is_equal = (rs1_index == MEM_WB_rd_index) ? 1'b1 : 1'b0;
    assign IF_ID_rs2_MEM_WB_rd_is_equal = (rs2_index == MEM_WB_rd_index) ? 1'b1 : 1'b0;

    // 3: MEM/WB to IF/ID Forwarding, 2: EXE/MEM2 to IF/ID Forwarding, 1: EXE/MEM to IF/ID Forwarding, 0: Direct
    always @(*) begin
        if (IF_ID_rs1_EXE_MEM_rd_is_equal & EXE_MEM_use_rd) IF_ID_rs1_data_sel = 2'd1;
        else if(IF_ID_rs1_EXE_MEM2_rd_is_equal & EXE_MEM2_use_rd) IF_ID_rs1_data_sel = 2'd2;
        else if(IF_ID_rs1_MEM_WB_rd_is_equal & MEM_WB_use_rd) IF_ID_rs1_data_sel = 2'd3;
        else IF_ID_rs1_data_sel = 2'd0;
    end
    // 3: MEM/WB to IF/ID Forwarding, 2: EXE/MEM2 to IF/ID Forwarding, 1: EXE/MEM to IF/ID Forwarding, 0: Direct
    always @(*) begin
        if (IF_ID_rs2_EXE_MEM_rd_is_equal & EXE_MEM_use_rd) IF_ID_rs2_data_sel = 2'd1;
        else if(IF_ID_rs2_EXE_MEM2_rd_is_equal & EXE_MEM2_use_rd) IF_ID_rs2_data_sel = 2'd2;
        else if(IF_ID_rs2_MEM_WB_rd_is_equal & MEM_WB_use_rd) IF_ID_rs2_data_sel = 2'd3;    
        else IF_ID_rs2_data_sel = 2'd0;
    end

    // ID/EXE src equals MEM/WB dst
    assign ID_EXE_rs1_MEM_WB_rd_is_equal = (ID_EXE_rs1_index == MEM_WB_rd_index) ? 1'b1 : 1'b0;
    assign ID_EXE_rs2_MEM_WB_rd_is_equal = (ID_EXE_rs2_index == MEM_WB_rd_index) ? 1'b1 : 1'b0;

    // ID/EXE src equals EXE/MEM dst
    assign ID_EXE_rs1_EXE_MEM_rd_is_equal = (ID_EXE_rs1_index == EXE_MEM_rd_index) ? 1'b1 : 1'b0;
    assign ID_EXE_rs2_EXE_MEM_rd_is_equal = (ID_EXE_rs2_index == EXE_MEM_rd_index) ? 1'b1 : 1'b0;

    // ID/EXE src equals EXE/MEM dst
    assign ID_EXE_rs1_EXE_MEM2_rd_is_equal = (ID_EXE_rs1_index == EXE_MEM2_rd_index) ? 1'b1 : 1'b0;
    assign ID_EXE_rs2_EXE_MEM2_rd_is_equal = (ID_EXE_rs2_index == EXE_MEM2_rd_index) ? 1'b1 : 1'b0;

    // 3: MEM/WB to ID/EXE Forwarding, 2: EXE/MEM2 to ID/EXE Forwarding, 1: EXE/MEM to ID/EXE Forwarding, 0: Direct
    always @(*) begin
        if (ID_EXE_rs1_EXE_MEM_rd_is_equal & EXE_MEM_use_rd) ID_EXE_rs1_data_sel = 2'd1;
        else if (ID_EXE_rs1_EXE_MEM2_rd_is_equal & EXE_MEM2_use_rd) ID_EXE_rs1_data_sel = 2'd2;
        else if (ID_EXE_rs1_MEM_WB_rd_is_equal & MEM_WB_use_rd) ID_EXE_rs1_data_sel = 2'd3;
        else ID_EXE_rs1_data_sel = 2'd0;
    end
    // 3: MEM/WB to ID/EXE Forwarding, 2: EXE/MEM2 to ID/EXE Forwarding, 1: EXE/MEM to ID/EXE Forwarding, 0: Direct
    always @(*) begin
        if (ID_EXE_rs2_EXE_MEM_rd_is_equal & EXE_MEM_use_rd) ID_EXE_rs2_data_sel = 2'd1;
        else if (ID_EXE_rs2_EXE_MEM2_rd_is_equal & EXE_MEM2_use_rd) ID_EXE_rs2_data_sel = 2'd2;
        else if (ID_EXE_rs2_MEM_WB_rd_is_equal & MEM_WB_use_rd) ID_EXE_rs2_data_sel = 2'd3;
        else ID_EXE_rs2_data_sel = 2'd0;
    end

    // Which instruction type has rd register
    always @(*) begin
        if(ID_EXE_rd_index != 6'b0 /*&& ID_EXE_opcode_LSB*/) begin
            case (ID_EXE_opcode)
                `STORE, `FSW, `B_type, 5'b11111: ID_EXE_use_rd = 1'b0;
                default: ID_EXE_use_rd = 1'b1;
            endcase
        end
        else ID_EXE_use_rd = 1'b0;
    end

    always @(*) begin
        if(EXE_MEM_rd_index != 6'b0 /*&& EXE_MEM_opcode_LSB*/) begin
            case (EXE_MEM_opcode)
                `STORE, `FSW, `B_type, 5'b11111: EXE_MEM_use_rd = 1'b0;
                default: EXE_MEM_use_rd = 1'b1;
            endcase
        end
        else EXE_MEM_use_rd = 1'b0;
    end

    always @(*) begin
        if(EXE_MEM2_rd_index != 6'b0 /*&& EXE_MEM2_opcode_LSB*/) begin
            case (EXE_MEM2_opcode)
                `STORE, `FSW, `B_type, 5'b11111: EXE_MEM2_use_rd = 1'b0;
                default: EXE_MEM2_use_rd = 1'b1;
            endcase
        end
        else EXE_MEM2_use_rd = 1'b0;
    end

    always @(*) begin
        if(MEM_WB_rd_index != 6'b0 /*&& MEM_WB_opcode_LSB*/) begin
            case (MEM_WB_opcode)
                `STORE, `FSW, `B_type, 5'b11111: MEM_WB_use_rd = 1'b0;
                default: MEM_WB_use_rd = 1'b1;
            endcase
        end
        else MEM_WB_use_rd = 1'b0;
    end

    assign IF_ID_src_ID_EXE_dst_is_equal = (IF_ID_rs1_ID_EXE_rd_is_equal | IF_ID_rs2_ID_EXE_rd_is_equal) & ID_EXE_use_rd;
    assign IF_ID_src_EXE_MEM_dst_is_equal = (IF_ID_rs1_EXE_MEM_rd_is_equal | IF_ID_rs2_EXE_MEM_rd_is_equal) & EXE_MEM_use_rd;
    assign IF_ID_src_EXE_MEM2_dst_is_equal = (IF_ID_rs1_EXE_MEM2_rd_is_equal | IF_ID_rs2_EXE_MEM2_rd_is_equal) & EXE_MEM2_use_rd;

    // stall
    always @(*) begin
        if(opcode == `JALR) begin
            if((IF_ID_rs1_ID_EXE_rd_is_equal & ID_EXE_use_rd) /*| (IF_ID_rs1_EXE_MEM_rd_is_equal & EXE_MEM_use_rd)*/)
                stall = 1'b1;
            else if((EXE_MEM_opcode == `LOAD || EXE_MEM_opcode == `FLW || EXE_MEM_mul_en) && (IF_ID_rs1_EXE_MEM_rd_is_equal & EXE_MEM_use_rd))
                stall = 1'b1;
            else if((EXE_MEM2_opcode == `LOAD || EXE_MEM2_opcode == `FLW) && (IF_ID_rs1_EXE_MEM2_rd_is_equal & EXE_MEM2_use_rd))
                stall = 1'b1;
            else 
                stall = 1'b0;
        end
        else if(opcode == `B_type) begin
            if(IF_ID_src_ID_EXE_dst_is_equal /*| IF_ID_src_EXE_MEM_dst_is_equal*/)
                stall = 1'b1;
            else if((EXE_MEM_opcode == `LOAD || EXE_MEM_opcode == `FLW || EXE_MEM_mul_en) && IF_ID_src_EXE_MEM_dst_is_equal)
                stall = 1'b1;
            else if((EXE_MEM2_opcode == `LOAD || EXE_MEM2_opcode == `FLW) && IF_ID_src_EXE_MEM2_dst_is_equal)
                stall = 1'b1;
            else
                stall = 1'b0;
        end
        else if(ID_EXE_mul_en)
            stall = (IF_ID_src_ID_EXE_dst_is_equal) ? 1'b1 : 1'b0;
        else begin // LW Data Hazard
            if((ID_EXE_opcode == `LOAD || ID_EXE_opcode == `FLW) && IF_ID_src_ID_EXE_dst_is_equal)
                stall = 1'b1;
            else if((EXE_MEM_opcode == `LOAD || EXE_MEM_opcode == `FLW) && IF_ID_src_EXE_MEM_dst_is_equal)
                stall = 1'b1;
            else 
                stall = 1'b0;
        end
    end
endmodule
