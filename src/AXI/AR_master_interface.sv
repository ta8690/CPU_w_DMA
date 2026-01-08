module AR_master_interface (
    input [1:0] state,
    input [1:0] master_req,
    input [2:0] slave_sel_M0_reg,
    input [2:0] slave_sel_M1_reg,
    input control_M_reg,
    //SLAVE INTERFACE FOR MASTERS
    //READ ADDRESS0
    input [`AXI_ID_BITS-1:0] ARID_M0,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    input [`AXI_LEN_BITS-1:0] ARLEN_M0,
    input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
    input [1:0] ARBURST_M0,
    input ARVALID_M0,

    //READ ADDRESS1
    input [`AXI_ID_BITS-1:0] ARID_M1,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    input [`AXI_LEN_BITS-1:0] ARLEN_M1,
    input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
    input [1:0] ARBURST_M1,
    input ARVALID_M1,

    //MASTER INTERFACE FOR SLAVES
    //READ ADDRESS0
    output logic [`AXI_IDS_BITS-1:0] ARID_S0,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
    output logic [1:0] ARBURST_S0,
    output logic ARVALID_S0,

    //READ ADDRESS1
    output logic [`AXI_IDS_BITS-1:0] ARID_S1,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
    output logic [1:0] ARBURST_S1,
    output logic ARVALID_S1,

    //READ ADDRESS2
    output logic [`AXI_IDS_BITS-1:0] ARID_S2,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
    output logic [1:0] ARBURST_S2,
    output logic ARVALID_S2,

	//READ ADDRESS3
    output logic [`AXI_IDS_BITS-1:0] ARID_S3,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
    output logic [1:0] ARBURST_S3,
    output logic ARVALID_S3,

    //READ ADDRESS1
    output logic [`AXI_IDS_BITS-1:0] ARID_S4,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
    output logic [1:0] ARBURST_S4,
    output logic ARVALID_S4,

    //READ ADDRESS5
    output logic [`AXI_IDS_BITS-1:0] ARID_S5,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
    output logic [1:0] ARBURST_S5,
    output logic ARVALID_S5

);
    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd0) begin
                        ARID_S0[7:4] = 4'b0;
                        ARID_S0[3:0] = ARID_M0;
                        ARADDR_S0 = ARADDR_M0;
                        ARLEN_S0 = ARLEN_M0;
                        ARSIZE_S0 = ARSIZE_M0;
                        ARBURST_S0 = ARBURST_M0;
                        ARVALID_S0 = ARVALID_M0;
                    end
                    else begin
                        ARID_S0 = 8'b0;
                        ARADDR_S0 = `AXI_ADDR_BITS'b0;
                        ARLEN_S0 = `AXI_LEN_BITS'b0;
                        ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                        ARBURST_S0 = 2'b0;
                        ARVALID_S0 = 1'b0;  
                    end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd0) begin
                        ARID_S0[7:4] = 4'b0;
                        ARID_S0[3:0] = ARID_M1;
                        ARADDR_S0 = ARADDR_M1;
                        ARLEN_S0 = ARLEN_M1;
                        ARSIZE_S0 = ARSIZE_M1;
                        ARBURST_S0 = ARBURST_M1;
                        ARVALID_S0 = ARVALID_M1;
                    end
                    else begin
                        ARID_S0 = 8'b0;
                        ARADDR_S0 = `AXI_ADDR_BITS'b0;
                        ARLEN_S0 = `AXI_LEN_BITS'b0;
                        ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                        ARBURST_S0 = 2'b0;
                        ARVALID_S0 = 1'b0;  
                    end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd0) begin
                                ARID_S0[7:4] = 4'b0;
                                ARID_S0[3:0] = ARID_M0;
                                ARADDR_S0 = ARADDR_M0;
                                ARLEN_S0 = ARLEN_M0;
                                ARSIZE_S0 = ARSIZE_M0;
                                ARBURST_S0 = ARBURST_M0;
                                ARVALID_S0 = ARVALID_M0;  
                            end
                            else begin
                                ARID_S0 = 8'b0;
                                ARADDR_S0 = `AXI_ADDR_BITS'b0;
                                ARLEN_S0 = `AXI_LEN_BITS'b0;
                                ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                                ARBURST_S0 = 2'b0;
                                ARVALID_S0 = 1'b0;  
                            end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd0) begin
                                ARID_S0[7:4] = 4'b0;
                                ARID_S0[3:0] = ARID_M1;
                                ARADDR_S0 = ARADDR_M1;
                                ARLEN_S0 = ARLEN_M1;
                                ARSIZE_S0 = ARSIZE_M1;
                                ARBURST_S0 = ARBURST_M1;
                                ARVALID_S0 = ARVALID_M1;  
                            end
                            else begin
                                ARID_S0 = 8'b0;
                                ARADDR_S0 = `AXI_ADDR_BITS'b0;
                                ARLEN_S0 = `AXI_LEN_BITS'b0;
                                ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                                ARBURST_S0 = 2'b0;
                                ARVALID_S0 = 1'b0; 
                            end
                        end
                    end
                    else begin
                        if(slave_sel_M1_reg == 3'd0) begin
                            ARID_S0[7:4] = 4'b0;
                            ARID_S0[3:0] = ARID_M1;
                            ARADDR_S0 = ARADDR_M1;
                            ARLEN_S0 = ARLEN_M1;
                            ARSIZE_S0 = ARSIZE_M1;
                            ARBURST_S0 = ARBURST_M1;
                            ARVALID_S0 = ARVALID_M1;  
                        end
                        else if(slave_sel_M0_reg == 3'd0) begin
                            ARID_S0[7:4] = 4'b0;
                            ARID_S0[3:0] = ARID_M0;
                            ARADDR_S0 = ARADDR_M0;
                            ARLEN_S0 = ARLEN_M0;
                            ARSIZE_S0 = ARSIZE_M0;
                            ARBURST_S0 = ARBURST_M0;
                            ARVALID_S0 = ARVALID_M0;  
                        end
                        else begin
                            ARID_S0 = 8'b0;
                            ARADDR_S0 = `AXI_ADDR_BITS'b0;
                            ARLEN_S0 = `AXI_LEN_BITS'b0;
                            ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                            ARBURST_S0 = 2'b0;
                            ARVALID_S0 = 1'b0;                            
                        end
                    end
                end
                else begin
                    ARID_S0 = 8'b0;
                    ARADDR_S0 = `AXI_ADDR_BITS'b0;
                    ARLEN_S0 = `AXI_LEN_BITS'b0;
                    ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                    ARBURST_S0 = 2'b0;
                    ARVALID_S0 = 1'b0;
                end
            end
            default: begin
                ARID_S0 = 8'b0;
                ARADDR_S0 = `AXI_ADDR_BITS'b0;
                ARLEN_S0 = `AXI_LEN_BITS'b0;
                ARSIZE_S0 = `AXI_SIZE_BITS'b0;
                ARBURST_S0 = 2'b0;
                ARVALID_S0 = 1'b0;
            end
       endcase 
    end


    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd1) begin
                        ARID_S1[7:4] = 4'b0;
                        ARID_S1[3:0] = ARID_M0;
                        ARADDR_S1 = ARADDR_M0;
                        ARLEN_S1 = ARLEN_M0;
                        ARSIZE_S1 = ARSIZE_M0;
                        ARBURST_S1 = ARBURST_M0;
                        ARVALID_S1 = ARVALID_M0;
                    end
					else begin	
                        ARID_S1 = 8'b0;
                        ARADDR_S1 = `AXI_ADDR_BITS'b0;
                        ARLEN_S1 = `AXI_LEN_BITS'b0;
                        ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                        ARBURST_S1 = 2'b0;
                        ARVALID_S1 = 1'b0;  
					end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd1) begin
                        ARID_S1[7:4] = 4'b0;
                        ARID_S1[3:0] = ARID_M1;
                        ARADDR_S1 = ARADDR_M1;
                        ARLEN_S1 = ARLEN_M1;
                        ARSIZE_S1 = ARSIZE_M1;
                        ARBURST_S1 = ARBURST_M1;
                        ARVALID_S1 = ARVALID_M1;  
                    end
					else begin
                        ARID_S1 = 8'b0;
                        ARADDR_S1 = `AXI_ADDR_BITS'b0;
                        ARLEN_S1 = `AXI_LEN_BITS'b0;
                        ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                        ARBURST_S1 = 2'b0;
                        ARVALID_S1 = 1'b0; 
					end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd1) begin
                                ARID_S1[7:4] = 4'b0;
                                ARID_S1[3:0] = ARID_M0;
                                ARADDR_S1 = ARADDR_M0;
                                ARLEN_S1 = ARLEN_M0;
                                ARSIZE_S1 = ARSIZE_M0;
                                ARBURST_S1 = ARBURST_M0;
                                ARVALID_S1 = ARVALID_M0;   
                            end
							else begin
                                ARID_S1 = 8'b0;
                                ARADDR_S1 = `AXI_ADDR_BITS'b0;
                                ARLEN_S1 = `AXI_LEN_BITS'b0;
                                ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                                ARBURST_S1 = 2'b0;
                                ARVALID_S1 = 1'b0;  
							end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd1) begin
                                ARID_S1[7:4] = 4'b0;
                                ARID_S1[3:0] = ARID_M1;
                                ARADDR_S1 = ARADDR_M1;
                                ARLEN_S1 = ARLEN_M1;
                                ARSIZE_S1 = ARSIZE_M1;
                                ARBURST_S1 = ARBURST_M1;
                                ARVALID_S1 = ARVALID_M1;   
                            end
						    else begin
                                ARID_S1 = 8'b0;
                                ARADDR_S1 = `AXI_ADDR_BITS'b0;
                                ARLEN_S1 = `AXI_LEN_BITS'b0;
                                ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                                ARBURST_S1 = 2'b0;
                                ARVALID_S1 = 1'b0;  
                            end

                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd1) begin
                            ARID_S1[7:4] = 4'b0;
                            ARID_S1[3:0] = ARID_M0;
                            ARADDR_S1 = ARADDR_M0;
                            ARLEN_S1 = ARLEN_M0;
                            ARSIZE_S1 = ARSIZE_M0;
                            ARBURST_S1 = ARBURST_M0;
                            ARVALID_S1 = ARVALID_M0; 
                        end
                        else if(slave_sel_M1_reg == 3'd1) begin
                            ARID_S1[7:4] = 4'b0;
                            ARID_S1[3:0] = ARID_M1;
                            ARADDR_S1 = ARADDR_M1;
                            ARLEN_S1 = ARLEN_M1;
                            ARSIZE_S1 = ARSIZE_M1;
                            ARBURST_S1 = ARBURST_M1;
                            ARVALID_S1 = ARVALID_M1;  
                        end
                        else begin
                            ARID_S1 = 8'b0;
                            ARADDR_S1 = `AXI_ADDR_BITS'b0;
                            ARLEN_S1 = `AXI_LEN_BITS'b0;
                            ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                            ARBURST_S1 = 2'b0;
                            ARVALID_S1 = 1'b0;                             
                        end
                    end
                end
                else begin
                    ARID_S1 = 8'b0;
                    ARADDR_S1 = `AXI_ADDR_BITS'b0;
                    ARLEN_S1 = `AXI_LEN_BITS'b0;
                    ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                    ARBURST_S1 = 2'b0;
                    ARVALID_S1 = 1'b0; 
                end
            end
            default: begin
                ARID_S1 = 8'b0;
                ARADDR_S1 = `AXI_ADDR_BITS'b0;
                ARLEN_S1 = `AXI_LEN_BITS'b0;
                ARSIZE_S1 = `AXI_SIZE_BITS'b0;
                ARBURST_S1 = 2'b0;
                ARVALID_S1 = 1'b0;  
            end
       endcase 
    end


    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd2) begin
                        ARID_S2[7:4] = 4'b0;
                        ARID_S2[3:0] = ARID_M0;
                        ARADDR_S2 = ARADDR_M0;
                        ARLEN_S2 = ARLEN_M0;
                        ARSIZE_S2 = ARSIZE_M0;
                        ARBURST_S2 = ARBURST_M0;
                        ARVALID_S2 = ARVALID_M0;
                    end
					else begin	
                        ARID_S2 = 8'b0;
                        ARADDR_S2 = `AXI_ADDR_BITS'b0;
                        ARLEN_S2 = `AXI_LEN_BITS'b0;
                        ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                        ARBURST_S2 = 2'b0;
                        ARVALID_S2 = 1'b0;  
					end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd2) begin
                        ARID_S2[7:4] = 4'b0;
                        ARID_S2[3:0] = ARID_M1;
                        ARADDR_S2 = ARADDR_M1;
                        ARLEN_S2 = ARLEN_M1;
                        ARSIZE_S2 = ARSIZE_M1;
                        ARBURST_S2 = ARBURST_M1;
                        ARVALID_S2 = ARVALID_M1;  
                    end
					else begin
                        ARID_S2 = 8'b0;
                        ARADDR_S2 = `AXI_ADDR_BITS'b0;
                        ARLEN_S2 = `AXI_LEN_BITS'b0;
                        ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                        ARBURST_S2 = 2'b0;
                        ARVALID_S2 = 1'b0; 
					end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd2) begin
                                ARID_S2[7:4] = 4'b0;
                                ARID_S2[3:0] = ARID_M0;
                                ARADDR_S2 = ARADDR_M0;
                                ARLEN_S2 = ARLEN_M0;
                                ARSIZE_S2 = ARSIZE_M0;
                                ARBURST_S2 = ARBURST_M0;
                                ARVALID_S2 = ARVALID_M0;   
                            end
							else begin
                                ARID_S2 = 8'b0;
                                ARADDR_S2 = `AXI_ADDR_BITS'b0;
                                ARLEN_S2 = `AXI_LEN_BITS'b0;
                                ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                                ARBURST_S2 = 2'b0;
                                ARVALID_S2 = 1'b0;  
							end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd2) begin
                                ARID_S2[7:4] = 4'b0;
                                ARID_S2[3:0] = ARID_M1;
                                ARADDR_S2 = ARADDR_M1;
                                ARLEN_S2 = ARLEN_M1;
                                ARSIZE_S2 = ARSIZE_M1;
                                ARBURST_S2 = ARBURST_M1;
                                ARVALID_S2 = ARVALID_M1;   
                            end
						    else begin
                                ARID_S2 = 8'b0;
                                ARADDR_S2 = `AXI_ADDR_BITS'b0;
                                ARLEN_S2 = `AXI_LEN_BITS'b0;
                                ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                                ARBURST_S2 = 2'b0;
                                ARVALID_S2 = 1'b0;  
                            end

                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd2) begin
                            ARID_S2[7:4] = 4'b0;
                            ARID_S2[3:0] = ARID_M0;
                            ARADDR_S2 = ARADDR_M0;
                            ARLEN_S2 = ARLEN_M0;
                            ARSIZE_S2 = ARSIZE_M0;
                            ARBURST_S2 = ARBURST_M0;
                            ARVALID_S2 = ARVALID_M0; 
                        end
                        else if(slave_sel_M1_reg == 3'd2) begin
                            ARID_S2[7:4] = 4'b0;
                            ARID_S2[3:0] = ARID_M1;
                            ARADDR_S2 = ARADDR_M1;
                            ARLEN_S2 = ARLEN_M1;
                            ARSIZE_S2 = ARSIZE_M1;
                            ARBURST_S2 = ARBURST_M1;
                            ARVALID_S2 = ARVALID_M1;  
                        end
                        else begin
                            ARID_S2 = 8'b0;
                            ARADDR_S2 = `AXI_ADDR_BITS'b0;
                            ARLEN_S2 = `AXI_LEN_BITS'b0;
                            ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                            ARBURST_S2 = 2'b0;
                            ARVALID_S2 = 1'b0;                             
                        end
                    end
                end
                else begin
                    ARID_S2 = 8'b0;
                    ARADDR_S2 = `AXI_ADDR_BITS'b0;
                    ARLEN_S2 = `AXI_LEN_BITS'b0;
                    ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                    ARBURST_S2 = 2'b0;
                    ARVALID_S2 = 1'b0; 
                end
            end
            default: begin
                ARID_S2 = 8'b0;
                ARADDR_S2 = `AXI_ADDR_BITS'b0;
                ARLEN_S2 = `AXI_LEN_BITS'b0;
                ARSIZE_S2 = `AXI_SIZE_BITS'b0;
                ARBURST_S2 = 2'b0;
                ARVALID_S2 = 1'b0;  
            end
       endcase 
    end


    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd3) begin
                        ARID_S3[7:4] = 4'b0;
                        ARID_S3[3:0] = ARID_M0;
                        ARADDR_S3 = ARADDR_M0;
                        ARLEN_S3 = ARLEN_M0;
                        ARSIZE_S3 = ARSIZE_M0;
                        ARBURST_S3 = ARBURST_M0;
                        ARVALID_S3 = ARVALID_M0;
                    end
					else begin	
                        ARID_S3 = 8'b0;
                        ARADDR_S3 = `AXI_ADDR_BITS'b0;
                        ARLEN_S3 = `AXI_LEN_BITS'b0;
                        ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                        ARBURST_S3 = 2'b0;
                        ARVALID_S3 = 1'b0;  
					end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd3) begin
                        ARID_S3[7:4] = 4'b0;
                        ARID_S3[3:0] = ARID_M1;
                        ARADDR_S3 = ARADDR_M1;
                        ARLEN_S3 = ARLEN_M1;
                        ARSIZE_S3 = ARSIZE_M1;
                        ARBURST_S3 = ARBURST_M1;
                        ARVALID_S3 = ARVALID_M1;  
                    end
					else begin
                        ARID_S3 = 8'b0;
                        ARADDR_S3 = `AXI_ADDR_BITS'b0;
                        ARLEN_S3 = `AXI_LEN_BITS'b0;
                        ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                        ARBURST_S3 = 2'b0;
                        ARVALID_S3 = 1'b0; 
					end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd3) begin
                                ARID_S3[7:4] = 4'b0;
                                ARID_S3[3:0] = ARID_M0;
                                ARADDR_S3 = ARADDR_M0;
                                ARLEN_S3 = ARLEN_M0;
                                ARSIZE_S3 = ARSIZE_M0;
                                ARBURST_S3 = ARBURST_M0;
                                ARVALID_S3 = ARVALID_M0;   
                            end
							else begin
                                ARID_S3 = 8'b0;
                                ARADDR_S3 = `AXI_ADDR_BITS'b0;
                                ARLEN_S3 = `AXI_LEN_BITS'b0;
                                ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                                ARBURST_S3 = 2'b0;
                                ARVALID_S3 = 1'b0;  
							end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd3) begin
                                ARID_S3[7:4] = 4'b0;
                                ARID_S3[3:0] = ARID_M1;
                                ARADDR_S3 = ARADDR_M1;
                                ARLEN_S3 = ARLEN_M1;
                                ARSIZE_S3 = ARSIZE_M1;
                                ARBURST_S3 = ARBURST_M1;
                                ARVALID_S3 = ARVALID_M1;   
                            end
						    else begin
                                ARID_S3 = 8'b0;
                                ARADDR_S3 = `AXI_ADDR_BITS'b0;
                                ARLEN_S3 = `AXI_LEN_BITS'b0;
                                ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                                ARBURST_S3 = 2'b0;
                                ARVALID_S3 = 1'b0;  
                            end

                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd3) begin
                            ARID_S3[7:4] = 4'b0;
                            ARID_S3[3:0] = ARID_M0;
                            ARADDR_S3 = ARADDR_M0;
                            ARLEN_S3 = ARLEN_M0;
                            ARSIZE_S3 = ARSIZE_M0;
                            ARBURST_S3 = ARBURST_M0;
                            ARVALID_S3 = ARVALID_M0; 
                        end
                        else if(slave_sel_M1_reg == 3'd3) begin
                            ARID_S3[7:4] = 4'b0;
                            ARID_S3[3:0] = ARID_M1;
                            ARADDR_S3 = ARADDR_M1;
                            ARLEN_S3 = ARLEN_M1;
                            ARSIZE_S3 = ARSIZE_M1;
                            ARBURST_S3 = ARBURST_M1;
                            ARVALID_S3 = ARVALID_M1;  
                        end
                        else begin
                            ARID_S3 = 8'b0;
                            ARADDR_S3 = `AXI_ADDR_BITS'b0;
                            ARLEN_S3 = `AXI_LEN_BITS'b0;
                            ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                            ARBURST_S3 = 2'b0;
                            ARVALID_S3 = 1'b0;                             
                        end
                    end
                end
                else begin
                    ARID_S3 = 8'b0;
                    ARADDR_S3 = `AXI_ADDR_BITS'b0;
                    ARLEN_S3 = `AXI_LEN_BITS'b0;
                    ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                    ARBURST_S3 = 2'b0;
                    ARVALID_S3 = 1'b0; 
                end
            end
            default: begin
                ARID_S3 = 8'b0;
                ARADDR_S3 = `AXI_ADDR_BITS'b0;
                ARLEN_S3 = `AXI_LEN_BITS'b0;
                ARSIZE_S3 = `AXI_SIZE_BITS'b0;
                ARBURST_S3 = 2'b0;
                ARVALID_S3 = 1'b0;  
            end
       endcase 
    end

	
    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd4) begin
                        ARID_S4[7:4] = 4'b0;
                        ARID_S4[3:0] = ARID_M0;
                        ARADDR_S4 = ARADDR_M0;
                        ARLEN_S4 = ARLEN_M0;
                        ARSIZE_S4 = ARSIZE_M0;
                        ARBURST_S4 = ARBURST_M0;
                        ARVALID_S4 = ARVALID_M0;
                    end
					else begin	
                        ARID_S4 = 8'b0;
                        ARADDR_S4 = `AXI_ADDR_BITS'b0;
                        ARLEN_S4 = `AXI_LEN_BITS'b0;
                        ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                        ARBURST_S4 = 2'b0;
                        ARVALID_S4 = 1'b0;  
					end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd4) begin
                        ARID_S4[7:4] = 4'b0;
                        ARID_S4[3:0] = ARID_M1;
                        ARADDR_S4 = ARADDR_M1;
                        ARLEN_S4 = ARLEN_M1;
                        ARSIZE_S4 = ARSIZE_M1;
                        ARBURST_S4 = ARBURST_M1;
                        ARVALID_S4 = ARVALID_M1;  
                    end
					else begin
                        ARID_S4 = 8'b0;
                        ARADDR_S4 = `AXI_ADDR_BITS'b0;
                        ARLEN_S4 = `AXI_LEN_BITS'b0;
                        ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                        ARBURST_S4 = 2'b0;
                        ARVALID_S4 = 1'b0; 
					end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd4) begin
                                ARID_S4[7:4] = 4'b0;
                                ARID_S4[3:0] = ARID_M0;
                                ARADDR_S4 = ARADDR_M0;
                                ARLEN_S4 = ARLEN_M0;
                                ARSIZE_S4 = ARSIZE_M0;
                                ARBURST_S4 = ARBURST_M0;
                                ARVALID_S4 = ARVALID_M0;   
                            end
							else begin
                                ARID_S4 = 8'b0;
                                ARADDR_S4 = `AXI_ADDR_BITS'b0;
                                ARLEN_S4 = `AXI_LEN_BITS'b0;
                                ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                                ARBURST_S4 = 2'b0;
                                ARVALID_S4 = 1'b0;  
							end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd4) begin
                                ARID_S4[7:4] = 4'b0;
                                ARID_S4[3:0] = ARID_M1;
                                ARADDR_S4 = ARADDR_M1;
                                ARLEN_S4 = ARLEN_M1;
                                ARSIZE_S4 = ARSIZE_M1;
                                ARBURST_S4 = ARBURST_M1;
                                ARVALID_S4 = ARVALID_M1;   
                            end
						    else begin
                                ARID_S4 = 8'b0;
                                ARADDR_S4 = `AXI_ADDR_BITS'b0;
                                ARLEN_S4 = `AXI_LEN_BITS'b0;
                                ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                                ARBURST_S4 = 2'b0;
                                ARVALID_S4 = 1'b0;  
                            end

                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd4) begin
                            ARID_S4[7:4] = 4'b0;
                            ARID_S4[3:0] = ARID_M0;
                            ARADDR_S4 = ARADDR_M0;
                            ARLEN_S4 = ARLEN_M0;
                            ARSIZE_S4 = ARSIZE_M0;
                            ARBURST_S4 = ARBURST_M0;
                            ARVALID_S4 = ARVALID_M0; 
                        end
                        else if(slave_sel_M1_reg == 3'd4) begin
                            ARID_S4[7:4] = 4'b0;
                            ARID_S4[3:0] = ARID_M1;
                            ARADDR_S4 = ARADDR_M1;
                            ARLEN_S4 = ARLEN_M1;
                            ARSIZE_S4 = ARSIZE_M1;
                            ARBURST_S4 = ARBURST_M1;
                            ARVALID_S4 = ARVALID_M1;  
                        end
                        else begin
                            ARID_S4 = 8'b0;
                            ARADDR_S4 = `AXI_ADDR_BITS'b0;
                            ARLEN_S4 = `AXI_LEN_BITS'b0;
                            ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                            ARBURST_S4 = 2'b0;
                            ARVALID_S4 = 1'b0;                             
                        end
                    end
                end
                else begin
                    ARID_S4 = 8'b0;
                    ARADDR_S4 = `AXI_ADDR_BITS'b0;
                    ARLEN_S4 = `AXI_LEN_BITS'b0;
                    ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                    ARBURST_S4 = 2'b0;
                    ARVALID_S4 = 1'b0; 
                end
            end
            default: begin
                ARID_S4 = 8'b0;
                ARADDR_S4 = `AXI_ADDR_BITS'b0;
                ARLEN_S4 = `AXI_LEN_BITS'b0;
                ARSIZE_S4 = `AXI_SIZE_BITS'b0;
                ARBURST_S4 = 2'b0;
                ARVALID_S4 = 1'b0;  
            end
       endcase 
    end

	
    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd5) begin
                        ARID_S5[7:4] = 4'b0;
                        ARID_S5[3:0] = ARID_M0;
                        ARADDR_S5 = ARADDR_M0;
                        ARLEN_S5 = ARLEN_M0;
                        ARSIZE_S5 = ARSIZE_M0;
                        ARBURST_S5 = ARBURST_M0;
                        ARVALID_S5 = ARVALID_M0;
                    end
					else begin	
                        ARID_S5 = 8'b0;
                        ARADDR_S5 = `AXI_ADDR_BITS'b0;
                        ARLEN_S5 = `AXI_LEN_BITS'b0;
                        ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                        ARBURST_S5 = 2'b0;
                        ARVALID_S5 = 1'b0;  
					end
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd5) begin
                        ARID_S5[7:4] = 4'b0;
                        ARID_S5[3:0] = ARID_M1;
                        ARADDR_S5 = ARADDR_M1;
                        ARLEN_S5 = ARLEN_M1;
                        ARSIZE_S5 = ARSIZE_M1;
                        ARBURST_S5 = ARBURST_M1;
                        ARVALID_S5 = ARVALID_M1;  
                    end
					else begin
                        ARID_S5 = 8'b0;
                        ARADDR_S5 = `AXI_ADDR_BITS'b0;
                        ARLEN_S5 = `AXI_LEN_BITS'b0;
                        ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                        ARBURST_S5 = 2'b0;
                        ARVALID_S5 = 1'b0; 
					end
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd5) begin
                                ARID_S5[7:4] = 4'b0;
                                ARID_S5[3:0] = ARID_M0;
                                ARADDR_S5 = ARADDR_M0;
                                ARLEN_S5 = ARLEN_M0;
                                ARSIZE_S5 = ARSIZE_M0;
                                ARBURST_S5 = ARBURST_M0;
                                ARVALID_S5 = ARVALID_M0;   
                            end
							else begin
                                ARID_S5 = 8'b0;
                                ARADDR_S5 = `AXI_ADDR_BITS'b0;
                                ARLEN_S5 = `AXI_LEN_BITS'b0;
                                ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                                ARBURST_S5 = 2'b0;
                                ARVALID_S5 = 1'b0;  
							end
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd5) begin
                                ARID_S5[7:4] = 4'b0;
                                ARID_S5[3:0] = ARID_M1;
                                ARADDR_S5 = ARADDR_M1;
                                ARLEN_S5 = ARLEN_M1;
                                ARSIZE_S5 = ARSIZE_M1;
                                ARBURST_S5 = ARBURST_M1;
                                ARVALID_S5 = ARVALID_M1;   
                            end
						    else begin
                                ARID_S5 = 8'b0;
                                ARADDR_S5 = `AXI_ADDR_BITS'b0;
                                ARLEN_S5 = `AXI_LEN_BITS'b0;
                                ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                                ARBURST_S5 = 2'b0;
                                ARVALID_S5 = 1'b0;  
                            end

                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd5) begin
                            ARID_S5[7:4] = 4'b0;
                            ARID_S5[3:0] = ARID_M0;
                            ARADDR_S5 = ARADDR_M0;
                            ARLEN_S5 = ARLEN_M0;
                            ARSIZE_S5 = ARSIZE_M0;
                            ARBURST_S5 = ARBURST_M0;
                            ARVALID_S5 = ARVALID_M0; 
                        end
                        else if(slave_sel_M1_reg == 3'd5) begin
                            ARID_S5[7:4] = 4'b0;
                            ARID_S5[3:0] = ARID_M1;
                            ARADDR_S5 = ARADDR_M1;
                            ARLEN_S5 = ARLEN_M1;
                            ARSIZE_S5 = ARSIZE_M1;
                            ARBURST_S5 = ARBURST_M1;
                            ARVALID_S5 = ARVALID_M1;  
                        end
                        else begin
                            ARID_S5 = 8'b0;
                            ARADDR_S5 = `AXI_ADDR_BITS'b0;
                            ARLEN_S5 = `AXI_LEN_BITS'b0;
                            ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                            ARBURST_S5 = 2'b0;
                            ARVALID_S5 = 1'b0;                             
                        end
                    end
                end
                else begin
                    ARID_S5 = 8'b0;
                    ARADDR_S5 = `AXI_ADDR_BITS'b0;
                    ARLEN_S5 = `AXI_LEN_BITS'b0;
                    ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                    ARBURST_S5 = 2'b0;
                    ARVALID_S5 = 1'b0; 
                end
            end
            default: begin
                ARID_S5 = 8'b0;
                ARADDR_S5 = `AXI_ADDR_BITS'b0;
                ARLEN_S5 = `AXI_LEN_BITS'b0;
                ARSIZE_S5 = `AXI_SIZE_BITS'b0;
                ARBURST_S5 = 2'b0;
                ARVALID_S5 = 1'b0;  
            end
       endcase 
    end
endmodule
