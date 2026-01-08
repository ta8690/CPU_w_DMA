module R_master_interface(
    input [1:0] state,
    input [1:0] master_req,
    input slave_sel_M0_reg,
    input slave_sel_M1_reg,
    input control_M_reg,

    input RREADY_M0, 
    input RREADY_M1,
    output logic RREADY_S0,
    output logic RREADY_S1,
	output logic RREADY_S2,
	output logic RREADY_S3,
	output logic RREADY_S4,
	output logic RREADY_S5
);

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd0)
                        RREADY_S0 = RREADY_M0;
                    else 
                        RREADY_S0 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd0)
                        RREADY_S0 = RREADY_M1;
                    else 
                        RREADY_S0 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                            if(slave_sel_M0_reg == 3'd0)
                                RREADY_S0 = RREADY_M0;
                            else 
                                RREADY_S0 = 1'b0;
                        end
                        else begin
                            if(slave_sel_M1_reg == 3'd0) 
                                RREADY_S0 = RREADY_M1;
                            else 
                                RREADY_S0 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M1_reg == 3'd0)
                            RREADY_S0 = RREADY_M1;
                        else if(slave_sel_M0_reg == 3'd0)
                            RREADY_S0 = RREADY_M0;  
                        else RREADY_S0 = 1'b0;            
                    end
                end
                else RREADY_S0 = 1'b0;
            end
            default: RREADY_S0 = 1'b0;
       endcase 
    end


    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd1) 
                        RREADY_S1 = RREADY_M0;
                    else
                        RREADY_S1 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd1) 
                        RREADY_S1 = RREADY_M1;
                    else
                        RREADY_S1 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                    		if(slave_sel_M0_reg == 3'd1) 
                        		RREADY_S1 = RREADY_M0;
                    		else
                        		RREADY_S1 = 1'b0;
                        end
                        else begin
                    		if(slave_sel_M1_reg == 3'd1) 
                        		RREADY_S1 = RREADY_M1;
                    		else
                        		RREADY_S1 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd1)
                            RREADY_S1 = RREADY_M0; 
                        else if(slave_sel_M1_reg == 3'd1)
                            RREADY_S1 = RREADY_M1;   
                        else RREADY_S1 = 1'b0;
                    end
                end
                else RREADY_S1 = 1'b0;
            end
            default: RREADY_S1 = 1'b0;
       endcase 
    end

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd2) 
                        RREADY_S2 = RREADY_M0;
                    else
                        RREADY_S2 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd2) 
                        RREADY_S2 = RREADY_M1;
                    else
                        RREADY_S2 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                    		if(slave_sel_M0_reg == 3'd2) 
                        		RREADY_S2 = RREADY_M0;
                    		else
                        		RREADY_S2 = 1'b0;
                        end
                        else begin
                    		if(slave_sel_M1_reg == 3'd2) 
                        		RREADY_S2 = RREADY_M1;
                    		else
                        		RREADY_S2 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd2)
                            RREADY_S2 = RREADY_M0; 
                        else if(slave_sel_M1_reg == 3'd2)
                            RREADY_S2 = RREADY_M1;   
                        else RREADY_S2 = 1'b0;
                    end
                end
                else RREADY_S2 = 1'b0;
            end
            default: RREADY_S2 = 1'b0;
       endcase 
    end

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd3) 
                        RREADY_S3 = RREADY_M0;
                    else
                        RREADY_S3 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd3) 
                        RREADY_S3 = RREADY_M1;
                    else
                        RREADY_S3 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                    		if(slave_sel_M0_reg == 3'd3) 
                        		RREADY_S3 = RREADY_M0;
                    		else
                        		RREADY_S3 = 1'b0;
                        end
                        else begin
                    		if(slave_sel_M1_reg == 3'd3) 
                        		RREADY_S3 = RREADY_M1;
                    		else
                        		RREADY_S3 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd3)
                            RREADY_S3 = RREADY_M0; 
                        else if(slave_sel_M1_reg == 3'd3)
                            RREADY_S3 = RREADY_M1;   
                        else RREADY_S3 = 1'b0;
                    end
                end
                else RREADY_S3 = 1'b0;
            end
            default: RREADY_S3 = 1'b0;
       endcase 
    end

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd4) 
                        RREADY_S4 = RREADY_M0;
                    else
                        RREADY_S4 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd4) 
                        RREADY_S4 = RREADY_M1;
                    else
                        RREADY_S4 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                    		if(slave_sel_M0_reg == 3'd4) 
                        		RREADY_S4 = RREADY_M0;
                    		else
                        		RREADY_S4 = 1'b0;
                        end
                        else begin
                    		if(slave_sel_M1_reg == 3'd4) 
                        		RREADY_S4 = RREADY_M1;
                    		else
                        		RREADY_S4 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd4)
                            RREADY_S4 = RREADY_M0; 
                        else if(slave_sel_M1_reg == 3'd4)
                            RREADY_S4 = RREADY_M1;   
                        else RREADY_S4 = 1'b0;
                    end
                end
                else RREADY_S4 = 1'b0;
            end
            default: RREADY_S4 = 1'b0;
       endcase 
    end

    always @(*) begin
       case(state)
            `Read_Data: begin
                if(master_req == 2'b01) begin // Master 0 request
                    if(slave_sel_M0_reg == 3'd5) 
                        RREADY_S5 = RREADY_M0;
                    else
                        RREADY_S5 = 1'b0;
                end
                else if(master_req == 2'b10) begin // Master 1 request
                    if(slave_sel_M1_reg == 3'd5) 
                        RREADY_S5 = RREADY_M1;
                    else
                        RREADY_S5 = 1'b0;
                end
                else if(master_req == 2'b11) begin // Master 0 and Master 1 request at same time
                    if(slave_sel_M1_reg == slave_sel_M0_reg) begin
                        if(!control_M_reg) begin
                    		if(slave_sel_M0_reg == 3'd5) 
                        		RREADY_S5 = RREADY_M0;
                    		else
                        		RREADY_S5 = 1'b0;
                        end
                        else begin
                    		if(slave_sel_M1_reg == 3'd5) 
                        		RREADY_S5 = RREADY_M1;
                    		else
                        		RREADY_S5 = 1'b0;
                        end
                    end
                    else begin
                        if(slave_sel_M0_reg == 3'd5)
                            RREADY_S5 = RREADY_M0; 
                        else if(slave_sel_M1_reg == 3'd5)
                            RREADY_S5 = RREADY_M1;   
                        else RREADY_S5 = 1'b0;
                    end
                end
                else RREADY_S5 = 1'b0;
            end
            default: RREADY_S5 = 1'b0;
       endcase 
    end

endmodule
