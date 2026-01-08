module SRAM_wrapper (
    input ACLK,
	input ARESETn,
    // Slave
    // READ ADDRESS
	input [`AXI_IDS_BITS-1:0] ARID_S,
	input [`AXI_ADDR_BITS-1:0] ARADDR_S,
	input [`AXI_LEN_BITS-1:0] ARLEN_S,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_S,
	input [1:0] ARBURST_S,
	input ARVALID_S,
	output logic ARREADY_S,
	// READ DATA
	output logic [`AXI_IDS_BITS-1:0] RID_S,
	output logic [`AXI_DATA_BITS-1:0] RDATA_S,
	output logic [1:0] RRESP_S,
	output logic RLAST_S,
	output logic RVALID_S,
	input RREADY_S,

    // WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] AWID_S,
	input [`AXI_ADDR_BITS-1:0] AWADDR_S,
	input [`AXI_LEN_BITS-1:0] AWLEN_S,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_S,
	input [1:0] AWBURST_S,
	input  AWVALID_S,
	output logic AWREADY_S,
	// WRITE DATA
	input logic [`AXI_DATA_BITS-1:0] WDATA_S,
	input logic [`AXI_STRB_BITS-1:0] WSTRB_S,
	input logic WLAST_S,
	input logic WVALID_S,
	output logic WREADY_S,
	// WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID_S,
	output logic [1:0] BRESP_S,
	output logic BVALID_S,
	input BREADY_S
);

    logic CEB;
    logic WEB;
    logic [3:0] BWEB;
    logic [13:0] A;
    logic [`CPU_DATA_BITS-1:0] DI;
    logic [`CPU_DATA_BITS-1:0] DO;
    logic [31:0] BWEB_ext;

    logic [`AXI_ADDR_BITS-1:0] addr_to_slave_R, addr_to_slave_W;
    logic [`AXI_DATA_BITS-1:0] data_from_slave_R, data_to_slave_W;
    logic slave_read_en, slave_write_en;

    logic dm_addr;
    // assign dm_addr = (A == 14'd0 && !WEB) ? 1'b1 : 1'b0;
    // assign dm_addr = (addr_to_slave_W == 32'h101f8 && !WEB) ? 1'b1 : 1'b0;

    logic read_write_arbiter_en;
    assign read_write_arbiter_en = ARVALID_S & AWVALID_S;


    Slave_Read SR(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        // READ ADDRES
        .ARID(ARID_S),
        .ARADDR(ARADDR_S),
        .ARLEN(ARLEN_S),
        .ARSIZE(ARSIZE_S),
        .ARBURST(ARBURST_S),
        .ARVALID(ARVALID_S),
        .ARREADY(ARREADY_S),
        // READ DATA
        .RID(RID_S),
        .RDATA(RDATA_S),
        .RRESP(RRESP_S),
        .RLAST(RLAST_S),
        .RVALID(RVALID_S),
        .RREADY(RREADY_S),
        .addr_to_slave(addr_to_slave_R),
        .data_from_slave(data_from_slave_R),
        .slave_enable(slave_read_en)
    );

    Slave_Write SW(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        // Slave
        // WRITE ADDRES
        .AWID(AWID_S),
        .AWADDR(AWADDR_S),
        .AWLEN(AWLEN_S),
        .AWSIZE(AWSIZE_S),
        .AWBURST(AWBURST_S),
        .AWVALID(AWVALID_S),
        .AWREADY(AWREADY_S),
        // WRITE DATA
        .WDATA(WDATA_S),
        .WSTRB(WSTRB_S),
        .WLAST(WLAST_S),
        .WVALID(WVALID_S),
        .WREADY(WREADY_S),
        // WRITE RESPONSE
        .BID(BID_S),
        .BRESP(BRESP_S),
        .BVALID(BVALID_S),
        .BREADY(BREADY_S),
        
        .addr_to_slave(addr_to_slave_W),
        .data_to_slave(data_to_slave_W),
        .slave_enable(slave_write_en)
    );
    //////////////////////////////////////////////////////////////////////
    ///////////////////////   ReadWrite_Arbiter   ////////////////////////
    //////////////////////////////////////////////////////////////////////

    ReadWrite_Arbiter rw_arbiter(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .ARVALID(ARVALID_S),
        .AWVALID(AWVALID_S),
        .RVALID(RVALID_S),
        .slave_read_en(slave_read_en),
        .slave_write_en(slave_write_en)
    );

    ////////////////////////////////////////////////////////////////
    ///////////////////////      iSRAM      ////////////////////////
    ////////////////////////////////////////////////////////////////
    assign A = (WVALID_S) ? addr_to_slave_W[15:2] : addr_to_slave_R[15:2];
    assign WEB = ~WVALID_S;

    assign BWEB_ext = {{8{~WSTRB_S[3]}}, {8{~WSTRB_S[2]}}, {8{~WSTRB_S[1]}}, {8{~WSTRB_S[0]}}};
    assign data_from_slave_R = DO;
    assign DI = data_to_slave_W;

    TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
        .SLP(1'b0),
        .DSLP(1'b0),
        .SD(1'b0),
        .PUDELAY(),
        .CLK(ACLK),
        .CEB(CEB),
        .WEB(WEB),
        .A(A),
        .D(DI),
        .BWEB(BWEB_ext),
        .RTSEL(2'b01),
        .WTSEL(2'b01),
        .Q(DO)
    );


endmodule
