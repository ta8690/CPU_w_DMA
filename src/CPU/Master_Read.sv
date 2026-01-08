module Master_Read(
    input                             ACLK,
    input                             ARESETn,

    // READ ADDRESS0
	output logic [`AXI_ID_BITS-1:0]   ARID,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR,
	output logic [`AXI_LEN_BITS-1:0]  ARLEN,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE,
	output logic [1:0]                ARBURST,
	output logic                      ARVALID,
	input                             ARREADY,

	// READ DATA0
	input [`AXI_ID_BITS-1:0]          RID,
	input [`AXI_DATA_BITS-1:0]        RDATA,
	input [1:0]                       RRESP,
	input                             RLAST,
	input                             RVALID,
	output logic                      RREADY,

    // CPU signal
    input                             cpu_read_req,
    input [`AXI_ID_BITS-1:0]          cpu_read_id,
    input [`AXI_ADDR_BITS-1:0]        cpu_read_addr,
    input [`AXI_LEN_BITS-1:0]         cpu_arlen,
    input [`AXI_SIZE_BITS-1:0]        cpu_arsize,
    input [1:0]                       cpu_arburst,
    output logic [`AXI_DATA_BITS-1:0] cpu_read_data,
    output logic                      stall_cpu
);

    logic [1:0] state, next_state;
    localparam Idle = 2'd0, Transfer_Addr = 2'd1, Transfer_Data = 2'd2;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= Idle;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            Idle: begin
                if(ARVALID) next_state = Transfer_Addr;
                else next_state = Idle;
            end
            Transfer_Addr: begin
                if(ARVALID & ARREADY) next_state = Transfer_Data;
                else next_state = Transfer_Addr;
            end
            Transfer_Data: begin
                if(RVALID & RREADY & RLAST) next_state = Idle;
                else next_state = Transfer_Data;
            end
            default: next_state = Idle;
        endcase
    end

    // AR Channel
    always @(*) begin
        case(state)
            Idle: begin
                ARVALID = cpu_read_req;
                ARADDR = cpu_read_addr;
                ARID = `AXI_ID_BITS'b0;
                ARLEN = `AXI_LEN_BITS'b0;
                ARSIZE = `AXI_SIZE_BITS'b0;
                ARBURST = 2'b0;
            end
            Transfer_Addr: begin
                ARVALID = cpu_read_req;
                ARADDR = cpu_read_addr;
                ARID = cpu_read_id;
                ARLEN = cpu_arlen - `AXI_LEN_BITS'd1;
                ARSIZE = cpu_arsize;
                ARBURST = cpu_arburst;        
            end
            Transfer_Data: begin
                ARVALID = 1'b0;
                ARADDR = `AXI_ADDR_BITS'b0;
                ARID = `AXI_ID_BITS'b0;
                ARLEN = `AXI_LEN_BITS'b0;
                ARSIZE = `AXI_SIZE_BITS'b0;
                ARBURST = 2'b0;
            end
            default: begin
                ARVALID = 1'b0;
                ARADDR = `AXI_ADDR_BITS'b0;
                ARID = `AXI_ID_BITS'b0;
                ARLEN = `AXI_LEN_BITS'b0;
                ARSIZE = `AXI_SIZE_BITS'b0;
                ARBURST = 2'b0;
            end
        endcase
    end

    // R Channel
    always @(*) begin
        case(state)
            Idle: begin 
                RREADY = 1'b0;
                cpu_read_data = `AXI_DATA_BITS'b0;
            end
            Transfer_Addr: begin
                RREADY = 1'b0;
                cpu_read_data = `AXI_DATA_BITS'b0;
            end
            Transfer_Data: begin
                RREADY = 1'b1;
                cpu_read_data = RDATA;
            end
            default: begin
                RREADY = 1'b0;
                cpu_read_data = `AXI_DATA_BITS'b0;
            end
        endcase
    end

    // CPU Siganls
    always @(*) begin
        case(state)
            Idle: begin
                if(ARVALID) stall_cpu = 1'b1;
                else stall_cpu = 1'b0;
            end
            Transfer_Addr: stall_cpu = 1'b1;
            Transfer_Data: stall_cpu = (RLAST & RVALID & RREADY) ? 1'b0 : 1'b1;
            default: stall_cpu = 1'b0;
        endcase
    end

endmodule