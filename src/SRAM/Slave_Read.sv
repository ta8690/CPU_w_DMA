module Slave_Read(
    // Slave
    input                             ACLK,
    input                             ARESETn,
    // READ ADDRESS
	input [`AXI_IDS_BITS-1:0]         ARID,
	input [`AXI_ADDR_BITS-1:0]        ARADDR,
	input [`AXI_LEN_BITS-1:0]         ARLEN,
	input [`AXI_SIZE_BITS-1:0]        ARSIZE,
	input [1:0]                       ARBURST,
	input                             ARVALID,
	output logic                      ARREADY,

	// READ DATA
	output logic [`AXI_IDS_BITS-1:0]  RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0]                RRESP,
	output logic                      RLAST,
	output logic                      RVALID,
	input                             RREADY,
    
    output logic [`AXI_ADDR_BITS-1:0] addr_to_slave,
    input [`AXI_ADDR_BITS-1:0] data_from_slave,
    input slave_enable
);

    logic [1:0] state, next_state;
    localparam Idle = 2'd0, Transfer_Addr = 2'd1, Transfer_Data = 2'd2;

    logic [`AXI_ADDR_BITS-1:0] ARADDR_reg;
    logic [`AXI_IDS_BITS-1:0] ARID_reg;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= Idle;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            Idle: begin
                if(ARVALID & ARREADY) next_state = Transfer_Addr;
                else next_state = Idle;
            end
            Transfer_Addr: begin
                if(RVALID & RREADY) next_state = Transfer_Data;
                else next_state = Transfer_Addr;
            end
            Transfer_Data: begin
                if(RVALID & RREADY & RLAST) next_state = Idle;
                else next_state = Transfer_Data;
            end
            default: next_state = Idle;
        endcase
    end

    always @(*) begin
        case(state)
            Idle:begin
                ARREADY = slave_enable;
                RID = `AXI_IDS_BITS'b0;
                RDATA = `AXI_DATA_BITS'b0;
                RRESP = 2'b0;
                RLAST = 1'b0;
                RVALID = 1'b0;

                addr_to_slave = ARADDR;
            end
            Transfer_Addr: begin
                ARREADY = 1'b0;
                RID = ARID_reg;
                RDATA = data_from_slave;
                RRESP = 2'b0;
                RLAST = 1'b0;
                RVALID = 1'b1;

                addr_to_slave = ARADDR_reg;
            end
            Transfer_Data: begin
                ARREADY = 1'b0;
                RID = ARID_reg;
                RDATA = data_from_slave;
                RRESP = 2'b0;
                RLAST = 1'b1;
                RVALID = 1'b1;

                addr_to_slave = ARADDR_reg;
            end
            default: begin
                ARREADY = 1'b1;
                RID = `AXI_IDS_BITS'b0;
                RDATA = `AXI_DATA_BITS'b0;
                RRESP = 2'b0;
                RLAST = 1'b0;
                RVALID = 1'b0;

                addr_to_slave = `AXI_ADDR_BITS'b0;
            end
        endcase
    end

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) begin
            ARADDR_reg <= `AXI_ADDR_BITS'b0;
            ARID_reg <= `AXI_IDS_BITS'b0;
        end
        else begin
            if(state == Idle) begin
                ARADDR_reg <= ARADDR;
                ARID_reg <= ARID;
            end
        end
    end
endmodule