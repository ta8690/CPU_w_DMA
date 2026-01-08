module Read_Arbiter(
    input ACLK,
    input ARESETn,
    input [1:0] state,
    input ARVALID_M0,
    input ARVALID_M1,
    input [2:0] slave_sel_M0,
    input [2:0] slave_sel_M1,
    output logic ARVALID_M0_reg,
    output logic ARVALID_M1_reg,
    output logic [1:0] master_req,
    output logic control_M_reg
);
    logic read_arbitrate;
    logic control_M;
    logic prev_M;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) ARVALID_M0_reg <= 1'b0;
        else if(state == `Arbitrate) ARVALID_M0_reg <= ARVALID_M0;
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) ARVALID_M1_reg <= 1'b0;
        else if(state == `Arbitrate) ARVALID_M1_reg <= ARVALID_M1;
    end

    always @(*) begin
        case({ARVALID_M1_reg, ARVALID_M0_reg})
            2'b00: master_req = 2'b00;
            2'b01: master_req = 2'b01;
            2'b10: master_req = 2'b10;
            default: master_req = 2'b11;
        endcase
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) prev_M <= 1'b0;
        else if(read_arbitrate) prev_M <= control_M;
    end


    always @(*) begin
        if(state == `Arbitrate && (ARVALID_M0 & ARVALID_M1) == 1'b1) begin
            if(slave_sel_M0 == slave_sel_M1)
                read_arbitrate = 1'b1;
            else
                read_arbitrate = 1'b0;
        end
        else read_arbitrate = 1'b0;
    end

    always @(*) begin
        if(read_arbitrate)
            control_M = ~prev_M;
        else 
            control_M = prev_M;
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) control_M_reg <= 1'b0;
        else if(state == `Arbitrate) control_M_reg <= control_M;
    end

endmodule
