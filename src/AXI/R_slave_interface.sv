module R_slave_interface(
    input [1:0] state,
    input [1:0] master_req,
    input slave_sel_M0_reg,
    input slave_sel_M1_reg,
    input control_M_reg,

    //READ DATA0
    input [`AXI_IDS_BITS-1:0] RID_S0,
    input [`AXI_DATA_BITS-1:0] RDATA_S0,
    input [1:0] RRESP_S0,
    input RLAST_S0,
    input RVALID_S0,

    //READ DATA1
    input [`AXI_IDS_BITS-1:0] RID_S1,
    input [`AXI_DATA_BITS-1:0] RDATA_S1,
    input [1:0] RRESP_S1,
    input RLAST_S1,
    input RVALID_S1,

    //READ DATA2
    input [`AXI_IDS_BITS-1:0] RID_S2,
    input [`AXI_DATA_BITS-1:0] RDATA_S2,
    input [1:0] RRESP_S2,
    input RLAST_S2,
    input RVALID_S2,

    //READ DATA3
    input [`AXI_IDS_BITS-1:0] RID_S3,
    input [`AXI_DATA_BITS-1:0] RDATA_S3,
    input [1:0] RRESP_S3,
    input RLAST_S3,
    input RVALID_S3,

	//READ DATA4
    input [`AXI_IDS_BITS-1:0] RID_S4,
    input [`AXI_DATA_BITS-1:0] RDATA_S4,
    input [1:0] RRESP_S4,
    input RLAST_S4,
    input RVALID_S4,

    //READ DATA5
    input [`AXI_IDS_BITS-1:0] RID_S5,
    input [`AXI_DATA_BITS-1:0] RDATA_S5,
    input [1:0] RRESP_S5,
    input RLAST_S5,
    input RVALID_S5,
    
	//READ DATA0
    output logic [`AXI_ID_BITS-1:0] RID_M0,
    output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
    output logic [1:0] RRESP_M0,
    output logic RLAST_M0,
    output logic RVALID_M0,

    //READ DATA1
    output logic [`AXI_ID_BITS-1:0] RID_M1,
    output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
    output logic [1:0] RRESP_M1,
    output logic RLAST_M1,
    output logic RVALID_M1
);

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd0) begin
                        RID_M0 = RID_S0[3:0];
                        RDATA_M0 = RDATA_S0;
                        RRESP_M0 = RRESP_S0;
                        RLAST_M0 = RLAST_S0;
                        RVALID_M0 = RVALID_S0;
                    end
                    else if(slave_sel_M0_reg == 3'd1) begin
                        RID_M0 = RID_S1[3:0];
                        RDATA_M0 = RDATA_S1;
                        RRESP_M0 = RRESP_S1;
                        RLAST_M0 = RLAST_S1;
                        RVALID_M0 = RVALID_S1;
                    end
                    else if(slave_sel_M0_reg == 3'd2) begin
                        RID_M0 = RID_S2[3:0];
                        RDATA_M0 = RDATA_S2;
                        RRESP_M0 = RRESP_S2;
                        RLAST_M0 = RLAST_S2;
                        RVALID_M0 = RVALID_S2;
                    end
                    else if(slave_sel_M0_reg == 3'd3) begin
                        RID_M0 = RID_S3[3:0];
                        RDATA_M0 = RDATA_S3;
                        RRESP_M0 = RRESP_S3;
                        RLAST_M0 = RLAST_S3;
                        RVALID_M0 = RVALID_S3;
                    end
                    else if(slave_sel_M0_reg == 3'd4) begin
                        RID_M0 = RID_S4[3:0];
                        RDATA_M0 = RDATA_S4;
                        RRESP_M0 = RRESP_S4;
                        RLAST_M0 = RLAST_S4;
                        RVALID_M0 = RVALID_S4;
                    end
                    else begin                    
                        RID_M0 = RID_S5[3:0];
                        RDATA_M0 = RDATA_S5;
                        RRESP_M0 = RRESP_S5;
                        RLAST_M0 = RLAST_S5;
                        RVALID_M0 = RVALID_S5;                        
                    end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    RID_M0 = `AXI_ID_BITS'b0;
                    RDATA_M0 = `AXI_DATA_BITS;
                    RRESP_M0 = 2'b0;
                    RLAST_M0 = 1'b0;
                    RVALID_M0 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd0) begin
                                RID_M0 = RID_S0[3:0];
                                RDATA_M0 = RDATA_S0;
                                RRESP_M0 = RRESP_S0;
                                RLAST_M0 = RLAST_S0;
                                RVALID_M0 = RVALID_S0;
                            end
                            else if(slave_sel_M0_reg == 3'd1) begin
                                RID_M0 = RID_S1[3:0];
                                RDATA_M0 = RDATA_S1;
                                RRESP_M0 = RRESP_S1;
                                RLAST_M0 = RLAST_S1;
                                RVALID_M0 = RVALID_S1;
                            end
                            else if(slave_sel_M0_reg == 3'd2) begin
                                RID_M0 = RID_S2[3:0];
                                RDATA_M0 = RDATA_S2;
                                RRESP_M0 = RRESP_S2;
                                RLAST_M0 = RLAST_S2;
                                RVALID_M0 = RVALID_S2;
                            end
                            else if(slave_sel_M0_reg == 3'd3) begin
                                RID_M0 = RID_S3[3:0];
                                RDATA_M0 = RDATA_S3;
                                RRESP_M0 = RRESP_S3;
                                RLAST_M0 = RLAST_S3;
                                RVALID_M0 = RVALID_S3;
                            end
                            else if(slave_sel_M0_reg == 3'd4) begin
                                RID_M0 = RID_S4[3:0];
                                RDATA_M0 = RDATA_S4;
                                RRESP_M0 = RRESP_S4;
                                RLAST_M0 = RLAST_S4;
                                RVALID_M0 = RVALID_S4;
                            end
                            else begin                    
                                RID_M0 = RID_S5[3:0];
                                RDATA_M0 = RDATA_S5;
                                RRESP_M0 = RRESP_S5;
                                RLAST_M0 = RLAST_S5;
                                RVALID_M0 = RVALID_S5;                        
                            end
                        end
                        else begin
                            RID_M0 = `AXI_ID_BITS'b0;
                            RDATA_M0 = `AXI_DATA_BITS;
                            RRESP_M0 = 2'b0;
                            RLAST_M0 = 1'b0;
                            RVALID_M0 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd0) begin
                            RID_M0 = RID_S0[3:0];
                            RDATA_M0 = RDATA_S0;
                            RRESP_M0 = RRESP_S0;
                            RLAST_M0 = RLAST_S0;
                            RVALID_M0 = RVALID_S0;
                        end
                        else if(slave_sel_M0_reg == 3'd1) begin
                            RID_M0 = RID_S1[3:0];
                            RDATA_M0 = RDATA_S1;
                            RRESP_M0 = RRESP_S1;
                            RLAST_M0 = RLAST_S1;
                            RVALID_M0 = RVALID_S1;
                        end
                        else if(slave_sel_M0_reg == 3'd2) begin
                            RID_M0 = RID_S2[3:0];
                            RDATA_M0 = RDATA_S2;
                            RRESP_M0 = RRESP_S2;
                            RLAST_M0 = RLAST_S2;
                            RVALID_M0 = RVALID_S2;
                        end
                        else if(slave_sel_M0_reg == 3'd3) begin
                            RID_M0 = RID_S3[3:0];
                            RDATA_M0 = RDATA_S3;
                            RRESP_M0 = RRESP_S3;
                            RLAST_M0 = RLAST_S3;
                            RVALID_M0 = RVALID_S3;
                        end
                        else if(slave_sel_M0_reg == 3'd4) begin
                            RID_M0 = RID_S4[3:0];
                            RDATA_M0 = RDATA_S4;
                            RRESP_M0 = RRESP_S4;
                            RLAST_M0 = RLAST_S4;
                            RVALID_M0 = RVALID_S4;
                        end
                        else begin                    
                            RID_M0 = RID_S5[3:0];
                            RDATA_M0 = RDATA_S5;
                            RRESP_M0 = RRESP_S5;
                            RLAST_M0 = RLAST_S5;
                            RVALID_M0 = RVALID_S5;                        
                        end
                    end
                end
                else begin
                    RID_M0 = `AXI_ID_BITS'b0;
                    RDATA_M0 = `AXI_DATA_BITS;
                    RRESP_M0 = 2'b0;
                    RLAST_M0 = 1'b0;
                    RVALID_M0 = 1'b0;
                end
            end
            default: begin
                RID_M0 = `AXI_ID_BITS'b0;
                RDATA_M0 = `AXI_DATA_BITS;
                RRESP_M0 = 2'b0;
                RLAST_M0 = 1'b0;
                RVALID_M0 = 1'b0;
            end
       endcase 
    end


    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    RID_M1 = `AXI_ID_BITS'b0;
                    RDATA_M1 = `AXI_DATA_BITS;
                    RRESP_M1 = 2'b0;
                    RLAST_M1 = 1'b0;
                    RVALID_M1 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd0) begin
                        RID_M1 = RID_S0[3:0];
                        RDATA_M1 = RDATA_S0;
                        RRESP_M1 = RRESP_S0;
                        RLAST_M1 = RLAST_S0;
                        RVALID_M1 = RVALID_S0;
                    end
                    else if(slave_sel_M1_reg == 3'd1) begin
                        RID_M1 = RID_S1[3:0];
                        RDATA_M1 = RDATA_S1;
                        RRESP_M1 = RRESP_S1;
                        RLAST_M1 = RLAST_S1;
                        RVALID_M1 = RVALID_S1;
                    end
                    else if(slave_sel_M1_reg == 3'd2) begin
                        RID_M1 = RID_S2[3:0];
                        RDATA_M1 = RDATA_S2;
                        RRESP_M1 = RRESP_S2;
                        RLAST_M1 = RLAST_S2;
                        RVALID_M1 = RVALID_S2;
                    end
                    else if(slave_sel_M1_reg == 3'd3) begin
                        RID_M1 = RID_S3[3:0];
                        RDATA_M1 = RDATA_S3;
                        RRESP_M1 = RRESP_S3;
                        RLAST_M1 = RLAST_S3;
                        RVALID_M1 = RVALID_S3;
                    end
                    else if(slave_sel_M1_reg == 3'd4) begin
                        RID_M1 = RID_S4[3:0];
                        RDATA_M1 = RDATA_S4;
                        RRESP_M1 = RRESP_S4;
                        RLAST_M1 = RLAST_S4;
                        RVALID_M1 = RVALID_S4;
                    end
                    else begin
                        RID_M1 = RID_S5[3:0];
                        RDATA_M1 = RDATA_S5;
                        RRESP_M1 = RRESP_S5;
                        RLAST_M1 = RLAST_S5;
                        RVALID_M1 = RVALID_S5;
                    end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            RID_M1 = `AXI_ID_BITS'b0;
                            RDATA_M1 = `AXI_DATA_BITS;
                            RRESP_M1 = 2'b0;
                            RLAST_M1 = 1'b0;
                            RVALID_M1 = 1'b0;  
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd0) begin
                                RID_M1 = RID_S0[3:0];
                                RDATA_M1 = RDATA_S0;
                                RRESP_M1 = RRESP_S0;
                                RLAST_M1 = RLAST_S0;
                                RVALID_M1 = RVALID_S0;
                            end
                            else if(slave_sel_M1_reg == 3'd1) begin
                                RID_M1 = RID_S1[3:0];
                                RDATA_M1 = RDATA_S1;
                                RRESP_M1 = RRESP_S1;
                                RLAST_M1 = RLAST_S1;
                                RVALID_M1 = RVALID_S1;
                            end
                            else if(slave_sel_M1_reg == 3'd2) begin
                                RID_M1 = RID_S2[3:0];
                                RDATA_M1 = RDATA_S2;
                                RRESP_M1 = RRESP_S2;
                                RLAST_M1 = RLAST_S2;
                                RVALID_M1 = RVALID_S2;
                            end
                            else if(slave_sel_M1_reg == 3'd3) begin
                                RID_M1 = RID_S3[3:0];
                                RDATA_M1 = RDATA_S3;
                                RRESP_M1 = RRESP_S3;
                                RLAST_M1 = RLAST_S3;
                                RVALID_M1 = RVALID_S3;
                            end
                            else if(slave_sel_M1_reg == 3'd4) begin
                                RID_M1 = RID_S4[3:0];
                                RDATA_M1 = RDATA_S4;
                                RRESP_M1 = RRESP_S4;
                                RLAST_M1 = RLAST_S4;
                                RVALID_M1 = RVALID_S4;
                            end
                            else begin
                                RID_M1 = RID_S5[3:0];
                                RDATA_M1 = RDATA_S5;
                                RRESP_M1 = RRESP_S5;
                                RLAST_M1 = RLAST_S5;
                                RVALID_M1 = RVALID_S5;
                            end
                        end
                    end
                    else begin
                        if(slave_sel_M1_reg == 3'd0) begin
                            RID_M1 = RID_S0[3:0];
                            RDATA_M1 = RDATA_S0;
                            RRESP_M1 = RRESP_S0;
                            RLAST_M1 = RLAST_S0;
                            RVALID_M1 = RVALID_S0;
                        end
                        else if(slave_sel_M1_reg == 3'd1) begin
                            RID_M1 = RID_S1[3:0];
                            RDATA_M1 = RDATA_S1;
                            RRESP_M1 = RRESP_S1;
                            RLAST_M1 = RLAST_S1;
                            RVALID_M1 = RVALID_S1;
                        end
                        else if(slave_sel_M1_reg == 3'd2) begin
                            RID_M1 = RID_S2[3:0];
                            RDATA_M1 = RDATA_S2;
                            RRESP_M1 = RRESP_S2;
                            RLAST_M1 = RLAST_S2;
                            RVALID_M1 = RVALID_S2;
                        end
                        else if(slave_sel_M1_reg == 3'd3) begin
                            RID_M1 = RID_S3[3:0];
                            RDATA_M1 = RDATA_S3;
                            RRESP_M1 = RRESP_S3;
                            RLAST_M1 = RLAST_S3;
                            RVALID_M1 = RVALID_S3;
                        end
                        else if(slave_sel_M1_reg == 3'd4) begin
                            RID_M1 = RID_S4[3:0];
                            RDATA_M1 = RDATA_S4;
                            RRESP_M1 = RRESP_S4;
                            RLAST_M1 = RLAST_S4;
                            RVALID_M1 = RVALID_S4;
                        end
                        else begin
                            RID_M1 = RID_S5[3:0];
                            RDATA_M1 = RDATA_S5;
                            RRESP_M1 = RRESP_S5;
                            RLAST_M1 = RLAST_S5;
                            RVALID_M1 = RVALID_S5;
                        end
                    end
                end
                else begin
                    RID_M1 = `AXI_ID_BITS'b0;
                    RDATA_M1 = `AXI_DATA_BITS;
                    RRESP_M1 = 2'b0;
                    RLAST_M1 = 1'b0;
                    RVALID_M1 = 1'b0; 
                end
            end
            default: begin
                RID_M1 = `AXI_ID_BITS'b0;
                RDATA_M1 = `AXI_DATA_BITS;
                RRESP_M1 = 2'b0;
                RLAST_M1 = 1'b0;
                RVALID_M1 = 1'b0; 
            end
       endcase 
    end

endmodule
