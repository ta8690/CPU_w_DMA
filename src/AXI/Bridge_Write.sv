module Bridge_Write(
    input ACLK,
    input ARESETn,
    //SLAVE INTERFACE FOR MASTERS
    //WRITE ADDRESS
    input [`AXI_ID_BITS-1:0] AWID_M1,
    input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
    input [`AXI_LEN_BITS-1:0] AWLEN_M1,
    input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
    input [1:0] AWBURST_M1,
    input AWVALID_M1,
    output logic AWREADY_M1,

    //WRITE DATA
    input [`AXI_DATA_BITS-1:0] WDATA_M1,
    input [`AXI_STRB_BITS-1:0] WSTRB_M1,
    input WLAST_M1,
    input WVALID_M1,
    output logic WREADY_M1,

    //WRITE RESPONSE
    output logic [`AXI_ID_BITS-1:0] BID_M1,
    output logic [1:0] BRESP_M1,
    output logic BVALID_M1,
    input BREADY_M1,

    //MASTER INTERFACE FOR SLAVES
    //WRITE ADDRESS0
    output logic [`AXI_IDS_BITS-1:0] AWID_S0,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
    output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
    output logic [1:0] AWBURST_S0,
    output logic AWVALID_S0,
    input AWREADY_S0,

    //WRITE DATA0
    output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
    output logic WLAST_S0,
    output logic WVALID_S0,
    input WREADY_S0,

    //WRITE RESPONSE0
    input [`AXI_IDS_BITS-1:0] BID_S0,
    input [1:0] BRESP_S0,
    input BVALID_S0,
    output logic BREADY_S0,

    //WRITE ADDRESS1
    output logic [`AXI_IDS_BITS-1:0] AWID_S1,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
    output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
    output logic [1:0] AWBURST_S1,
    output logic AWVALID_S1,
    input AWREADY_S1,

    //WRITE DATA1
    output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
    output logic WLAST_S1,
    output logic WVALID_S1,
    input WREADY_S1,

    //WRITE RESPONSE1
    input [`AXI_IDS_BITS-1:0] BID_S1,
    input [1:0] BRESP_S1,
    input BVALID_S1,
    output logic BREADY_S1
);

    logic [1:0] state, next_state;
    localparam Idle = 2'd0, Write_Addr = 2'd1, Write_Data = 2'd2, Write_Response = 2'd3;

    logic control_M;
    //register
    logic prev_M;
    logic control_M_reg;
    logic slave_sel;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= 2'b0;
        else state <= next_state;
    end

    always @(*) begin
        if(AWVALID_M1) control_M = 1'b1;
        else control_M = 1'b0;
    end
    
    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) control_M_reg <= 1'b0;
        else if(state == Idle) control_M_reg <= control_M;
    end

    // Decoder
    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) slave_sel <= 1'b0;
        else if(state == Idle) begin
            if(AWADDR_M1[16]) slave_sel <= 1'b1;
            else slave_sel <= 1'b0;
        end
    end

    // AW master interface for slave
    always @(*) begin
        case(state)
            Write_Addr: begin
                if(!slave_sel) begin
                    AWID_S0[3:0] = AWID_M1;
                    AWID_S0[7:4] = 4'd0;
                    AWADDR_S0 = AWADDR_M1;
                    AWLEN_S0 = AWLEN_M1;
                    AWSIZE_S0 = AWSIZE_M1;
                    AWBURST_S0 = AWBURST_M1;
                    AWVALID_S0 = AWVALID_M1;

                    AWID_S1 = `AXI_IDS_BITS'b0;
                    AWADDR_S1 = `AXI_ADDR_BITS'b0;
                    AWLEN_S1 = `AXI_LEN_BITS'b0;
                    AWSIZE_S1 = `AXI_SIZE_BITS'b0;
                    AWBURST_S1 = `AXI_BURST_BITS'b0;
                    AWVALID_S1 = 1'b0;
                end
                else begin
                    AWID_S0 = `AXI_IDS_BITS'b0;
                    AWADDR_S0 = `AXI_ADDR_BITS'b0;
                    AWLEN_S0 = `AXI_LEN_BITS'b0;
                    AWSIZE_S0 = `AXI_SIZE_BITS'b0;
                    AWBURST_S0 = `AXI_BURST_BITS'b0;
                    AWVALID_S0 = 1'b0;

                    AWID_S1[3:0] = AWID_M1;
                    AWID_S1[7:4] = 4'd0;
                    AWADDR_S1 = AWADDR_M1;
                    AWLEN_S1 = AWLEN_M1;
                    AWSIZE_S1 = AWSIZE_M1;
                    AWBURST_S1 = AWBURST_M1;
                    AWVALID_S1 = AWVALID_M1;
                end
            end
            default: begin
                AWID_S0 = `AXI_IDS_BITS'b0;
                AWADDR_S0 = `AXI_ADDR_BITS'b0;
                AWLEN_S0 = `AXI_LEN_BITS'b0;
                AWSIZE_S0 = `AXI_SIZE_BITS'b0;
                AWBURST_S0 = `AXI_BURST_BITS'b0;
                AWVALID_S0 = 1'b0;

                AWID_S1 = `AXI_IDS_BITS'b0;
                AWADDR_S1 = `AXI_ADDR_BITS'b0;
                AWLEN_S1 = `AXI_LEN_BITS'b0;
                AWSIZE_S1 = `AXI_SIZE_BITS'b0;
                AWBURST_S1 = `AXI_BURST_BITS'b0;
                AWVALID_S1 = 1'b0;
            end
        endcase
    end

    // AW slave interface for master
    always @(*) begin
        case(state)
            Write_Addr: begin
                if(!slave_sel) begin
                    AWREADY_M1 = AWREADY_S0;
                end
                else begin
                    AWREADY_M1 = AWREADY_S1;
                end
            end
            default: begin
                AWREADY_M1 = 1'b0;
            end
        endcase
    end

    // W master interface for slave
    always @(*) begin
        case(state)
            Write_Data: begin
                if(!slave_sel) begin
                    // S0
                    WDATA_S0 = WDATA_M1;
                    WSTRB_S0 = WSTRB_M1;
                    WLAST_S0 = WLAST_M1;
                    WVALID_S0 = WVALID_M1;
                    // S1
                    WDATA_S1 = `AXI_DATA_BITS'b0;
                    WSTRB_S1 = `AXI_STRB_BITS'b0;
                    WLAST_S1 = 1'b0;
                    WVALID_S1 = 1'b0;
                end
                else begin
                    // S0
                    WDATA_S0 = `AXI_DATA_BITS'b0;
                    WSTRB_S0 = `AXI_STRB_BITS'b0;
                    WLAST_S0 = 1'b0;
                    WVALID_S0 = 1'b0;
                    // S1
                    WDATA_S1 = WDATA_M1;
                    WSTRB_S1 = WSTRB_M1;
                    WLAST_S1 = WLAST_M1;
                    WVALID_S1 = WVALID_M1;
                end
            end
            default: begin
                // S0
                WDATA_S0 = `AXI_DATA_BITS'b0;
                WSTRB_S0 = `AXI_STRB_BITS'b0;
                WLAST_S0 = 1'b0;
                WVALID_S0 = 1'b0;
                // S1
                WDATA_S1 = `AXI_DATA_BITS'b0;
                WSTRB_S1 = `AXI_STRB_BITS'b0;
                WLAST_S1 = 1'b0;
                WVALID_S1 = 1'b0;
            end
        endcase
    end

    // W master interface for slave
    always @(*) begin
        case(state)
            Write_Data: begin
                if(!slave_sel) begin
                    WREADY_M1 = WREADY_S0;
                end
                else begin
                    WREADY_M1 = WREADY_S1;
                end
            end
            default: begin
                WREADY_M1 = 1'b0;
            end
        endcase
    end

    // B slave interface for master
    always @(*) begin
        case(state)
            Write_Response: begin
                if(!slave_sel) begin
                    BID_M1 = BID_S0;
                    BRESP_M1 = BRESP_S0;
                    BVALID_M1 = BVALID_S0;
                end
                else begin
                    BID_M1 = BID_S1;
                    BRESP_M1 = BRESP_S1;
                    BVALID_M1 = BVALID_S1;
                end
            end
            default: begin
                BID_M1 = `AXI_ID_BITS'b0;
                BRESP_M1 = `AXI_RESP_BITS'b0;
                BVALID_M1 = 1'b0;
            end
        endcase
    end

    // B master interface for slave
    always @(*) begin
        case(state)
            Write_Response: begin
                if(!slave_sel) begin
                    BREADY_S0 = BREADY_M1;
                    BREADY_S1 = 1'b0;
                end
                else begin
                    BREADY_S0 = 1'b0;
                    BREADY_S1 = BREADY_M1;
                end
            end
            default: begin
                BREADY_S0 = 1'b0;
                BREADY_S1 = 1'b0;
            end
        endcase
    end

    always @(*) begin
        case(state)
            Idle: next_state = (AWVALID_M1) ? Write_Addr : Idle;
            Write_Addr: next_state = ((AWVALID_S0 | AWVALID_S1) & AWREADY_M1) ? Write_Data : Write_Addr;
            Write_Data: next_state = ((WVALID_S0 | WVALID_S1) & WREADY_M1) ? Write_Response : Write_Data;
            Write_Response: next_state = ((BREADY_S0 | BREADY_S1) & BVALID_M1) ? Idle : Write_Response;
            default: next_state = Idle;
        endcase
    end
endmodule