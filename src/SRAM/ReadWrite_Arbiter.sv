module ReadWrite_Arbiter(
    input ACLK,
    input ARESETn,
    input ARVALID,
    input AWVALID,
    input RVALID,
    output logic slave_read_en,
    output logic slave_write_en
);
    logic state, next_state;
    localparam Idle = 1'b0, Arbirtrate = 1'b1;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= Idle;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            Idle: begin
                if(ARVALID & AWVALID) next_state = Arbirtrate;
                else next_state = Idle;
            end
            Arbirtrate: begin
                if(RVALID) next_state = Idle;
                else next_state = Arbirtrate;
            end
            default: next_state = Idle;
        endcase
    end

    always @(*) begin
        case(state)
            Idle: begin
                if({ARVALID, AWVALID} == 2'b01) begin
                    slave_read_en = 1'b0;
                    slave_write_en = 1'b1;
                end
                else if({ARVALID, AWVALID} == 2'b10) begin
                    slave_read_en = 1'b1;
                    slave_write_en = 1'b0;
                end
                else if({ARVALID, AWVALID} == 2'b11) begin
                    slave_read_en = 1'b1;
                    slave_write_en = 1'b0;
                end
                else begin
                    slave_read_en = 1'b1;
                    slave_write_en = 1'b1;
                end
            end
            Arbirtrate: begin
                slave_read_en = 1'b1;
                slave_write_en = 1'b0;                
            end
            default: begin
                slave_read_en = 1'b0;
                slave_write_en = 1'b0;
            end
        endcase
    end

endmodule