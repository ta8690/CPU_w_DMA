module AR_slave_interface(
    input [1:0] state,
    input [1:0] master_req,
    input [2:0] slave_sel_M0_reg,
    input [2:0] slave_sel_M1_reg,
    input control_M_reg,
    
    input ARREADY_S0, 
    input ARREADY_S1,
    input ARREADY_S2, 
    input ARREADY_S3,
    input ARREADY_S4, 
    input ARREADY_S5,
    output logic ARREADY_M0,
    output logic ARREADY_M1
);

    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd0)
                        ARREADY_M0 = ARREADY_S0;
                    else if(slave_sel_M0_reg == 3'd1)
                        ARREADY_M0 = ARREADY_S1;
                    else if(slave_sel_M0_reg == 3'd2)
                        ARREADY_M0 = ARREADY_S2;   
                    else if(slave_sel_M0_reg == 3'd3)
                        ARREADY_M0 = ARREADY_S3;
                    else if(slave_sel_M0_reg == 3'd4)
                        ARREADY_M0 = ARREADY_S4;
                    else
                        ARREADY_M0 = ARREADY_S5;
                end
                else if(master_req == 2'b10) // Master 1 request
                    ARREADY_M0 = 1'b0;
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd0)
                                ARREADY_M0 = ARREADY_S0;
                            else if(slave_sel_M0_reg == 3'd1)
                                ARREADY_M0 = ARREADY_S1;
                            else if(slave_sel_M0_reg == 3'd2)
                                ARREADY_M0 = ARREADY_S2;   
                            else if(slave_sel_M0_reg == 3'd3)
                                ARREADY_M0 = ARREADY_S3;
                            else if(slave_sel_M0_reg == 3'd4)
                                ARREADY_M0 = ARREADY_S4;
                            else
                                ARREADY_M0 = ARREADY_S5;
                        end
                        else ARREADY_M0 = 1'b0;
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd0)
                            ARREADY_M0 = ARREADY_S0;
                        else if(slave_sel_M0_reg == 3'd1)
                            ARREADY_M0 = ARREADY_S1;
                        else if(slave_sel_M0_reg == 3'd2)
                            ARREADY_M0 = ARREADY_S2;   
                        else if(slave_sel_M0_reg == 3'd3)
                            ARREADY_M0 = ARREADY_S3;
                        else if(slave_sel_M0_reg == 3'd4)
                            ARREADY_M0 = ARREADY_S4;
                        else
                            ARREADY_M0 = ARREADY_S5;                   
                    end
                end
                else ARREADY_M0 = 1'b0;
            end
            default: ARREADY_M0 = 1'b0;
       endcase 
    end

    always @(*) begin
       case(state)
            `Read_Addr: begin
                if(master_req == 2'b01) // Master 0 request
                    ARREADY_M1 = 1'b0;
                else if(master_req == 2'b10) begin // Master 1 request
 					if(slave_sel_M1_reg == 3'd1)
                        ARREADY_M1 = ARREADY_S1;
 					else if(slave_sel_M1_reg == 3'd2)
                        ARREADY_M1 = ARREADY_S2;
    				else if(slave_sel_M1_reg == 3'd3)
                        ARREADY_M0 = ARREADY_S3;
 					else if(slave_sel_M1_reg == 3'd4)
                        ARREADY_M1 = ARREADY_S4;   
                    else
                        ARREADY_M1 = ARREADY_S5;             
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg)
                            ARREADY_M1 = 1'b0;             
                        else begin
                            if(slave_sel_M1_reg == 3'd1)
                                ARREADY_M1 = ARREADY_S1;
                            else if(slave_sel_M1_reg == 3'd2)
                                ARREADY_M1 = ARREADY_S2;
                            else if(slave_sel_M1_reg == 3'd3)
                                ARREADY_M0 = ARREADY_S3;
                            else if(slave_sel_M1_reg == 3'd4)
                                ARREADY_M1 = ARREADY_S4;   
                            else
                                ARREADY_M1 = ARREADY_S5;  
                        end
                    end
                    else begin
                        if(slave_sel_M1_reg == 3'd1)
                            ARREADY_M1 = ARREADY_S1;
                        else if(slave_sel_M1_reg == 3'd2)
                            ARREADY_M1 = ARREADY_S2;
                        else if(slave_sel_M1_reg == 3'd3)
                            ARREADY_M0 = ARREADY_S3;
                        else if(slave_sel_M1_reg == 3'd4)
                            ARREADY_M1 = ARREADY_S4;   
                        else
                            ARREADY_M1 = ARREADY_S5;  
                    end
                end
                else ARREADY_M1 = 1'b0;
            end
            default: ARREADY_M1 = 1'b0;
       endcase 
    end

endmodule
