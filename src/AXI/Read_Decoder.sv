module Read_Decoder(
    input ACLK,
    input ARESETn,
    input [1:0] state,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    output logic [2:0] slave_sel_M1,
    output logic [2:0] slave_sel_M0,
    output logic [2:0] slave_sel_M1_reg,
    output logic [2:0] slave_sel_M0_reg
);

    always @(*) begin
        if(state == `Arbitrate) begin
            if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b0) slave_sel_M0 = 3'd0; // select Slave 0
            else if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b0001) slave_sel_M0 = 3'd1; // select Slave 1
            else if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b0010) slave_sel_M0 = 3'd2; // select Slave 1
            else if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b0110) slave_sel_M0 = 3'd3; // select Slave 1
            else if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b0101) slave_sel_M0 = 3'd4; // select Slave 1
            else if({ARADDR_M0[29:28], ARADDR_M0[17:16]} == 4'b1000) slave_sel_M0 = 3'd5; // select Slave 1
            else slave_sel_M0 = 3'd0;
        end
        else slave_sel_M0 = 3'd0;
    end

    always @(*) begin
        if(state == `Arbitrate) begin
            if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b0) slave_sel_M1 = 3'd0; // select Slave 0
            else if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b0001) slave_sel_M1 = 3'd1; // select Slave 1
            else if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b0010) slave_sel_M1 = 3'd2; // select Slave 1
            else if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b0110) slave_sel_M1 = 3'd3; // select Slave 1
            else if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b0101) slave_sel_M1 = 3'd4; // select Slave 1
            else if({ARADDR_M1[29:28], ARADDR_M1[17:16]} == 4'b1000) slave_sel_M1 = 3'd5; // select Slave 1
            else slave_sel_M1 = 3'd0;
        end
        else slave_sel_M1 = 3'd0;
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) slave_sel_M0_reg <= 3'b0;
        else if(state == `Arbitrate)
            slave_sel_M0_reg <= slave_sel_M0;
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) slave_sel_M1_reg <= 3'b0;
        else if(state == `Arbitrate)
            slave_sel_M1_reg <= slave_sel_M1;
    end

endmodule