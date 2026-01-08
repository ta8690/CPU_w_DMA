module Master_Write (
    input                             ACLK,
    input                             ARESETn,

    output logic [  `AXI_ID_BITS-1:0] AWID,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR,
    output logic [ `AXI_LEN_BITS-1:0] AWLEN,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE,
    output logic [               1:0] AWBURST,  //only INCR type
    output logic                      AWVALID,
    input                             AWREADY,

    output logic [`AXI_DATA_BITS-1:0] WDATA,
    output logic [`AXI_STRB_BITS-1:0] WSTRB,
    output logic                      WLAST,
    output logic                      WVALID,
    input                             WREADY,

    input        [  `AXI_ID_BITS-1:0] BID,
    input        [               1:0] BRESP,
    input                             BVALID,
    output logic                      BREADY,
    //CPU Signals
    input        [              31:0] cpu_write_addr,
    input        [               3:0] BWEB,
    input        [`AXI_DATA_BITS-1:0] cpu_write_data,
    input        [  `AXI_ID_BITS-1:0] cpu_write_id,
    input        [ `AXI_LEN_BITS-1:0] cpu_awlen,
    input        [`AXI_SIZE_BITS-1:0] cpu_awsize,
    input        [               1:0] cpu_awburst,
    input                             cpu_write_req,
    output logic                      bvalid_out,
    output logic                      stall_cpu
);


    logic [1:0] state, next_state;
    localparam Idle = 2'd0, Transfer_Addr = 2'd1, Write_Data = 2'd2, B_Response = 2'd3;

    always @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) state <= Idle;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            Idle: begin
                if (AWVALID) next_state = Transfer_Addr;
                else next_state = Idle;
            end
            Transfer_Addr: begin
                if (AWVALID & AWREADY) next_state = Write_Data;
                else next_state = Transfer_Addr;
            end
            Write_Data: begin
                if ((WVALID & WREADY & WLAST)) next_state = B_Response;
                else next_state = Write_Data;
            end
            B_Response: begin
                if (BVALID & BREADY) next_state = Idle;
                else next_state = B_Response;
            end
        endcase
    end

    always @(*) begin
        case (state)
            Idle: begin
                AWVALID = cpu_write_req;
                AWADDR = cpu_write_addr;
                AWLEN = cpu_awlen;
                AWSIZE = cpu_awsize;
                AWID = cpu_write_id;
                AWBURST = cpu_awburst;
            end
            Transfer_Addr: begin
                AWVALID = 1'b1;
                AWADDR = cpu_write_addr;
                AWLEN = cpu_awlen;
                AWSIZE = cpu_awsize;
                AWID = cpu_write_id;
                AWBURST = cpu_awburst;
            end
            Write_Data: begin
                AWVALID = 1'b0;
                AWADDR = cpu_write_addr;
                AWLEN = cpu_awlen;
                AWSIZE = `AXI_SIZE_BITS'b0;
                AWID = `AXI_ID_BITS'b0;
                AWBURST = 2'b0;
            end
            B_Response: begin
                AWVALID = 1'b0;
                AWADDR = `AXI_DATA_BITS'b0;
                AWLEN = `AXI_LEN_BITS'b0;
                AWSIZE = `AXI_SIZE_BITS'b0;
                AWID = `AXI_ID_BITS'b0;
                AWBURST = 2'b0;
            end
            default: begin
                AWVALID = 1'b0;
                AWADDR = `AXI_DATA_BITS'b0;
                AWLEN = `AXI_LEN_BITS'b0;
                AWSIZE = `AXI_SIZE_BITS'b0;
                AWID = `AXI_ID_BITS'b0;
                AWBURST = 2'b0;
            end
        endcase
    end

    always @(*) begin
        case (state)
            Idle: begin
                WDATA  = `AXI_DATA_BITS'b0;
                WSTRB  = `AXI_STRB_BITS'b0;
                WLAST  = 1'b0;
                WVALID = 1'b0;
            end
            Transfer_Addr: begin
                WDATA  = `AXI_DATA_BITS'b0;
                WSTRB  = `AXI_STRB_BITS'b0;
                WLAST  = 1'b0;
                WVALID = 1'b0;
            end
            Write_Data: begin
                WDATA  = cpu_write_data;
                WSTRB  = BWEB;
                WLAST  = 1'b1;
                WVALID = 1'b1;
            end
            B_Response: begin
                WDATA  = `AXI_DATA_BITS'b0;
                WSTRB  = `AXI_STRB_BITS'b0;
                WLAST  = 1'b0;
                WVALID = 1'b0;
            end
        endcase
    end
    always @(*) begin
        case (state)
            Idle: stall_cpu = (cpu_write_req) ? 1'b1 : 1'b0;
            Transfer_Addr: stall_cpu = 1'b1;
            Write_Data: stall_cpu = 1'b1;
            B_Response: stall_cpu = (BVALID & BREADY) ? 1'b0 : 1'b1;
        endcase
    end

    assign BREADY = (state == B_Response) ? 1'b1 : 1'b0;


endmodule
