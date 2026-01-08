module AXI (

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

    //READ ADDRESS0
    input [`AXI_ID_BITS-1:0] ARID_M0,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    input [`AXI_LEN_BITS-1:0] ARLEN_M0,
    input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
    input [1:0] ARBURST_M0,
    input ARVALID_M0,
    output logic ARREADY_M0,

    //READ DATA0
    output logic [`AXI_ID_BITS-1:0] RID_M0,
    output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
    output logic [1:0] RRESP_M0,
    output logic RLAST_M0,
    output logic RVALID_M0,
    input RREADY_M0,

    //READ ADDRESS1
    input [`AXI_ID_BITS-1:0] ARID_M1,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    input [`AXI_LEN_BITS-1:0] ARLEN_M1,
    input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
    input [1:0] ARBURST_M1,
    input ARVALID_M1,
    output logic ARREADY_M1,

    //READ DATA1
    output logic [`AXI_ID_BITS-1:0] RID_M1,
    output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
    output logic [1:0] RRESP_M1,
    output logic RLAST_M1,
    output logic RVALID_M1,
    input RREADY_M1,

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
    output logic BREADY_S1,

    //WRITE ADDRESS2
    output logic [`AXI_IDS_BITS-1:0] AWID_S2,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
    output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
    output logic [1:0] AWBURST_S2,
    output logic AWVALID_S2,
    input AWREADY_S2,

    //WRITE DATA2
    output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
    output logic WLAST_S2,
    output logic WVALID_S2,
    input WREADY_S2,

    //WRITE RESPONSE2
    input [`AXI_IDS_BITS-1:0] BID_S2,
    input [1:0] BRESP_S2,
    input BVALID_S2,
    output logic BREADY_S2,

    //READ ADDRESS0
    output logic [`AXI_IDS_BITS-1:0] ARID_S0,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
    output logic [1:0] ARBURST_S0,
    output logic ARVALID_S0,
    input ARREADY_S0,

    //READ DATA0
    input [`AXI_IDS_BITS-1:0] RID_S0,
    input [`AXI_DATA_BITS-1:0] RDATA_S0,
    input [1:0] RRESP_S0,
    input RLAST_S0,
    input RVALID_S0,
    output logic RREADY_S0,

    //READ ADDRESS1
    output logic [`AXI_IDS_BITS-1:0] ARID_S1,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
    output logic [1:0] ARBURST_S1,
    output logic ARVALID_S1,
    input ARREADY_S1,

    //READ DATA1
    input [`AXI_IDS_BITS-1:0] RID_S1,
    input [`AXI_DATA_BITS-1:0] RDATA_S1,
    input [1:0] RRESP_S1,
    input RLAST_S1,
    input RVALID_S1,
    output logic RREADY_S1,

    //READ ADDRESS2
    output logic [`AXI_IDS_BITS-1:0] ARID_S2,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
    output logic [1:0] ARBURST_S2,
    output logic ARVALID_S2,
    input ARREADY_S2,

    //READ DATA2
    input [`AXI_IDS_BITS-1:0] RID_S2,
    input [`AXI_DATA_BITS-1:0] RDATA_S2,
    input [1:0] RRESP_S2,
    input RLAST_S2,
    input RVALID_S2,
    output logic RREADY_S2,

    //READ ADDRESS3
    output logic [`AXI_IDS_BITS-1:0] ARID_S3,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
    output logic [1:0] ARBURST_S3,
    output logic ARVALID_S3,
    input ARREADY_S3,

    //READ DATA3
    input [`AXI_IDS_BITS-1:0] RID_S3,
    input [`AXI_DATA_BITS-1:0] RDATA_S3,
    input [1:0] RRESP_S3,
    input RLAST_S3,
    input RVALID_S3,
    output logic RREADY_S3,

    //READ ADDRESS4
    output logic [`AXI_IDS_BITS-1:0] ARID_S4,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
    output logic [1:0] ARBURST_S4,
    output logic ARVALID_S4,
    input ARREADY_S4,

    //READ DATA4
    input [`AXI_IDS_BITS-1:0] RID_S4,
    input [`AXI_DATA_BITS-1:0] RDATA_S4,
    input [1:0] RRESP_S4,
    input RLAST_S4,
    input RVALID_S4,
    output logic RREADY_S4,

    //READ ADDRESS5
    output logic [`AXI_IDS_BITS-1:0] ARID_S5,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
    output logic [1:0] ARBURST_S5,
    output logic ARVALID_S5,
    input ARREADY_S5,

    //READ DATA5
    input [`AXI_IDS_BITS-1:0] RID_S5,
    input [`AXI_DATA_BITS-1:0] RDATA_S5,
    input [1:0] RRESP_S5,
    input RLAST_S5,
    input RVALID_S5,
    output logic RREADY_S5
);
    //---------- you should put your design here ----------//
    Bridge_Read axi_bridge_read (
        .ACLK(ACLK),
        .ARESETn(ARESETn),

        // Master 0 (讀取請求)
        .ARID_M0(ARID_M0),
        .ARADDR_M0(ARADDR_M0),
        .ARLEN_M0(ARLEN_M0),
        .ARSIZE_M0(ARSIZE_M0),
        .ARBURST_M0(ARBURST_M0),
        .ARVALID_M0(ARVALID_M0),
        .ARREADY_M0(ARREADY_M0),

        // Master 0 (讀取數據)
        .RID_M0(RID_M0),
        .RDATA_M0(RDATA_M0),
        .RRESP_M0(RRESP_M0),
        .RLAST_M0(RLAST_M0),
        .RVALID_M0(RVALID_M0),
        .RREADY_M0(RREADY_M0),

        // Master 1 (讀取請求)
        .ARID_M1(ARID_M1),
        .ARADDR_M1(ARADDR_M1),
        .ARLEN_M1(ARLEN_M1),
        .ARSIZE_M1(ARSIZE_M1),
        .ARBURST_M1(ARBURST_M1),
        .ARVALID_M1(ARVALID_M1),
        .ARREADY_M1(ARREADY_M1),

        // Master 1 (讀取數據)
        .RID_M1(RID_M1),
        .RDATA_M1(RDATA_M1),
        .RRESP_M1(RRESP_M1),
        .RLAST_M1(RLAST_M1),
        .RVALID_M1(RVALID_M1),
        .RREADY_M1(RREADY_M1),

        // Slave 0 (讀取請求)
        .ARID_S0(ARID_S0),
        .ARADDR_S0(ARADDR_S0),
        .ARLEN_S0(ARLEN_S0),
        .ARSIZE_S0(ARSIZE_S0),
        .ARBURST_S0(ARBURST_S0),
        .ARVALID_S0(ARVALID_S0),
        .ARREADY_S0(ARREADY_S0),

        // Slave 0 (讀取數據)
        .RID_S0(RID_S0),
        .RDATA_S0(RDATA_S0),
        .RRESP_S0(RRESP_S0),
        .RLAST_S0(RLAST_S0),
        .RVALID_S0(RVALID_S0),
        .RREADY_S0(RREADY_S0),

        // Slave 1 (讀取請求)
        .ARID_S1(ARID_S1),
        .ARADDR_S1(ARADDR_S1),
        .ARLEN_S1(ARLEN_S1),
        .ARSIZE_S1(ARSIZE_S1),
        .ARBURST_S1(ARBURST_S1),
        .ARVALID_S1(ARVALID_S1),
        .ARREADY_S1(ARREADY_S1),

        // Slave 1 (讀取數據)
        .RID_S1(RID_S1),
        .RDATA_S1(RDATA_S1),
        .RRESP_S1(RRESP_S1),
        .RLAST_S1(RLAST_S1),
        .RVALID_S1(RVALID_S1),
        .RREADY_S1(RREADY_S1),

        // Slave 2 (讀取請求)
        .ARID_S2(ARID_S2),
        .ARADDR_S2(ARADDR_S2),
        .ARLEN_S2(ARLEN_S2),
        .ARSIZE_S2(ARSIZE_S2),
        .ARBURST_S2(ARBURST_S2),
        .ARVALID_S2(ARVALID_S2),
        .ARREADY_S2(ARREADY_S2),

        // Slave 2 (讀取數據)
        .RID_S2(RID_S2),
        .RDATA_S2(RDATA_S2),
        .RRESP_S2(RRESP_S2),
        .RLAST_S2(RLAST_S2),
        .RVALID_S2(RVALID_S2),
        .RREADY_S2(RREADY_S2),

        // Slave 3 (讀取請求)
        .ARID_S3(ARID_S3),
        .ARADDR_S3(ARADDR_S3),
        .ARLEN_S3(ARLEN_S3),
        .ARSIZE_S3(ARSIZE_S3),
        .ARBURST_S3(ARBURST_S3),
        .ARVALID_S3(ARVALID_S3),
        .ARREADY_S3(ARREADY_S3),

        // Slave 3 (讀取數據)
        .RID_S3(RID_S3),
        .RDATA_S3(RDATA_S3),
        .RRESP_S3(RRESP_S3),
        .RLAST_S3(RLAST_S3),
        .RVALID_S3(RVALID_S3),
        .RREADY_S3(RREADY_S3),

        // Slave 4 (讀取請求)
        .ARID_S4(ARID_S4),
        .ARADDR_S4(ARADDR_S4),
        .ARLEN_S4(ARLEN_S4),
        .ARSIZE_S4(ARSIZE_S4),
        .ARBURST_S4(ARBURST_S4),
        .ARVALID_S4(ARVALID_S4),
        .ARREADY_S4(ARREADY_S4),

        // Slave 4 (讀取數據)
        .RID_S4(RID_S4),
        .RDATA_S4(RDATA_S4),
        .RRESP_S4(RRESP_S4),
        .RLAST_S4(RLAST_S4),
        .RVALID_S4(RVALID_S4),
        .RREADY_S4(RREADY_S4),

        // Slave 5 (讀取請求)
        .ARID_S5(ARID_S5),
        .ARADDR_S5(ARADDR_S5),
        .ARLEN_S5(ARLEN_S5),
        .ARSIZE_S5(ARSIZE_S5),
        .ARBURST_S5(ARBURST_S5),
        .ARVALID_S5(ARVALID_S5),
        .ARREADY_S5(ARREADY_S5),

        // Slave 5 (讀取數據)
        .RID_S5(RID_S5),
        .RDATA_S5(RDATA_S5),
        .RRESP_S5(RRESP_S5),
        .RLAST_S5(RLAST_S5),
        .RVALID_S5(RVALID_S5),
        .RREADY_S5(RREADY_S5)

    );


    Bridge_Write axi_bridge_write (
        .ACLK(ACLK),
        .ARESETn(ARESETn),

        // Master 1 (寫入請求)
        .AWID_M1(AWID_M1),
        .AWADDR_M1(AWADDR_M1),
        .AWLEN_M1(AWLEN_M1),
        .AWSIZE_M1(AWSIZE_M1),
        .AWBURST_M1(AWBURST_M1),
        .AWVALID_M1(AWVALID_M1),
        .AWREADY_M1(AWREADY_M1),

        // Master 1 (寫入數據)
        .WDATA_M1 (WDATA_M1),
        .WSTRB_M1 (WSTRB_M1),
        .WLAST_M1 (WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .WREADY_M1(WREADY_M1),

        // Master 1 (寫入回應)
        .BID_M1(BID_M1),
        .BRESP_M1(BRESP_M1),
        .BVALID_M1(BVALID_M1),
        .BREADY_M1(BREADY_M1),

        // Slave 0 (寫入請求)
        .AWID_S0(AWID_S0),
        .AWADDR_S0(AWADDR_S0),
        .AWLEN_S0(AWLEN_S0),
        .AWSIZE_S0(AWSIZE_S0),
        .AWBURST_S0(AWBURST_S0),
        .AWVALID_S0(AWVALID_S0),
        .AWREADY_S0(AWREADY_S0),

        // Slave 0 (寫入數據)
        .WDATA_S0 (WDATA_S0),
        .WSTRB_S0 (WSTRB_S0),
        .WLAST_S0 (WLAST_S0),
        .WVALID_S0(WVALID_S0),
        .WREADY_S0(WREADY_S0),

        // Slave 0 (寫入回應)
        .BID_S0(BID_S0),
        .BRESP_S0(BRESP_S0),
        .BVALID_S0(BVALID_S0),
        .BREADY_S0(BREADY_S0),

        // Slave 1 (寫入請求)
        .AWID_S1(AWID_S1),
        .AWADDR_S1(AWADDR_S1),
        .AWLEN_S1(AWLEN_S1),
        .AWSIZE_S1(AWSIZE_S1),
        .AWBURST_S1(AWBURST_S1),
        .AWVALID_S1(AWVALID_S1),
        .AWREADY_S1(AWREADY_S1),

        // Slave 1 (寫入數據)
        .WDATA_S1 (WDATA_S1),
        .WSTRB_S1 (WSTRB_S1),
        .WLAST_S1 (WLAST_S1),
        .WVALID_S1(WVALID_S1),
        .WREADY_S1(WREADY_S1),

        // Slave 1 (寫入回應)
        .BID_S1(BID_S1),
        .BRESP_S1(BRESP_S1),
        .BVALID_S1(BVALID_S1),
        .BREADY_S1(BREADY_S1)
    );

endmodule
