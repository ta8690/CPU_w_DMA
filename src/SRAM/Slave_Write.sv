module Slave_Write(

    input ACLK,
	input ARESETn,
    // Slave
    // WRITE ADDRES
	input [`AXI_IDS_BITS-1:0] AWID,
	input [`AXI_ADDR_BITS-1:0] AWADDR,
	input [`AXI_LEN_BITS-1:0] AWLEN,
	input [`AXI_SIZE_BITS-1:0] AWSIZE,
	input [1:0] AWBURST,
	input AWVALID,
	output logic AWREADY,
	// WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA,
	input [`AXI_STRB_BITS-1:0] WSTRB,
	input WLAST,
	input WVALID,
	output logic WREADY,
	// WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID,
	output logic [1:0] BRESP,
	output logic BVALID,
	input BREADY,
    
    output logic [`AXI_ADDR_BITS-1:0] addr_to_slave,
    output logic [`AXI_ADDR_BITS-1:0] data_to_slave,
    input slave_enable
);

    logic [1:0] state, next_state;
    localparam Idle = 2'd0, Write_Data = 2'd1, B_Response = 2'd2;

    logic [`AXI_ADDR_BITS-1:0] AWADDR_reg;
    logic [`AXI_IDS_BITS-1:0] AWID_reg;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= Idle;
        else state <= next_state;
    end

    // Next State Logic 
    always @(*) begin
        case(state)
            Idle: begin
                if(AWVALID & AWREADY) next_state = Write_Data;
                else next_state = Idle;
            end
            Write_Data: begin
                if(WVALID & WREADY & WLAST) next_state = B_Response;
                else next_state = Write_Data;
            end
            B_Response: begin
                if(BVALID & BREADY) next_state = Idle;
                else next_state = B_Response;
            end
            default: next_state = Idle;
        endcase
    end

    always @(*) begin
        case(state)
            Idle: begin
                AWREADY = slave_enable;
                WREADY = 1'b0;
                BID = `AXI_IDS_BITS'b0;
                BRESP = 2'b0;
                BVALID = 1'b0;

                addr_to_slave = AWADDR_reg;
                data_to_slave = `AXI_DATA_BITS'b0;
            end
            Write_Data: begin
                AWREADY = 1'b0;
                WREADY = 1'b1;
                BID = `AXI_IDS_BITS'b0;
                BRESP = 2'b0;
                BVALID = 1'b0;

                addr_to_slave = AWADDR_reg;
                data_to_slave = WDATA;
            end
            B_Response: begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = `AXI_IDS_BITS'b0;
                BRESP = 2'b0;
                BVALID = 1'b1;

                addr_to_slave = `AXI_ADDR_BITS'b0;
                data_to_slave = `AXI_DATA_BITS'b0;
            end
            default: begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = `AXI_IDS_BITS'b0;
                BRESP = 2'b0;
                BVALID = 1'b0;

                addr_to_slave = `AXI_ADDR_BITS'b0;
                data_to_slave = `AXI_DATA_BITS'b0;
            end
        endcase    
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) begin
            AWADDR_reg <= `AXI_ADDR_BITS'b0;
            AWID_reg <= `AXI_IDS_BITS'b0;
        end
        else begin
            if(state == Idle) begin
                AWADDR_reg <= AWADDR;
                AWID_reg <= AWID;
            end
        end
    end


endmodule