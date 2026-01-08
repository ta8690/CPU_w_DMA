`include "../include/AXI_define.svh"
`include "../include/define_CPU.sv"
//AXI
`include "../src/AXI/AXI.sv"
`include "../src/AXI/Bridge_Read.sv"
`include "../src/AXI/Bridge_Write.sv"
`include "../src/AXI/Read_Decoder.sv"
`include "../src/AXI/Read_Arbiter.sv"
`include "../src/AXI/AR_master_interface.sv"
`include "../src/AXI/AR_slave_interface.sv"
`include "../src/AXI/R_master_interface.sv"
`include "../src/AXI/R_slave_interface.sv"
//SRAM
`include "../src/SRAM/SRAM_wrapper.sv"
`include "../src/SRAM/Slave_Read.sv"
`include "../src/SRAM/Slave_Write.sv"
`include "../src/SRAM/ReadWrite_Arbiter.sv"
//ROM
`include "../src/ROM/ROM_wrapper.sv"
//CPU 
`include "../src/CPU/CPU_wrapper.sv"
`include "../src/CPU/Master_Read.sv"
`include "../src/CPU/Master_Write.sv"
`include "../src/CPU/ALU.sv"
`include "../src/CPU/Controller.sv"
`include "../src/CPU/CSR.sv"
`include "../src/CPU/DM_shift.sv"
`include "../src/CPU/Decoder.sv"
`include "../src/CPU/RegIndex_Filter.sv"
`include "../src/CPU/Hazard_Detector.sv"
`include "../src/CPU/Imm_Extend.sv"
`include "../src/CPU/Jump_Branch.sv"
`include "../src/CPU/LOAD_Unit.sv"
`include "../src/CPU/MUL.sv"
`include "../src/CPU/MUX_2in.sv"
`include "../src/CPU/MUX_4in.sv"
`include "../src/CPU/Program_Counter.sv"
`include "../src/CPU/Reg_ID_EXE.sv"
`include "../src/CPU/Reg_IF_ID.sv"
`include "../src/CPU/Reg_EXE_MEM.sv"
`include "../src/CPU/Reg_EXE_MEM2.sv"
`include "../src/CPU/Reg_MEM_WB.sv"
`include "../src/CPU/RegFile.sv"
`include "../src/CPU/F_RegFile.sv"
module top (
    input clk, 
    input rst,
    input clk2,
    input rst2,
    input [31:0] ROM_out,
    input DRAM_valid,
    input DRAM_Q,
    output ROM_read,
    output ROM_enable,
    output [11:0] ROM_address,
    output DRAM_CSn,
    output [3:0] DRAM_WEn,
    output DRAM_RASn,
    output DRAM_CASn,
    output [10:0] DRAM_A,
    output [31:0] DRAM_D
);
  
// ---------------------------------master--------------------------------- //
    // ---------master0------------ //
    // Read address channel signals
    logic    [`AXI_ID_BITS-1:0]      ARID_M0;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_M0;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_M0;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_M0;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_M0;   // Read address burst type
    logic                            ARVALID_M0;   // Read address valid
    logic                            ARREADY_M0;   // Read address ready

    // Read data channel signals
    logic    [`AXI_ID_BITS-1:0]      RID_M0;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_M0;     // Read data
    logic                            RLAST_M0;     // Read last
    logic                            RVALID_M0;    // Read valid
    logic                            RREADY_M0;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_M0;     // Read response

    // ----------master1---------- //
    // Write address channel signals
    logic    [`AXI_ID_BITS-1:0]      AWID_M1;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    AWADDR_M1;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     AWLEN_M1;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    AWSIZE_M1;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   AWBURST_M1;   // Write address burst type
    logic                            AWVALID_M1;   // Write address valid
    logic                            AWREADY_M1;   // Write address ready

    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_M1;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_M1;     // Write strobe
    logic                            WLAST_M1;     // Write last
    logic                            WVALID_M1;    // Write valid
    logic                            WREADY_M1;    // Write ready
    // Write response channel signals
    logic    [`AXI_ID_BITS-1:0]      BID_M1;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_M1;     // Write response
    logic                            BVALID_M1;    // Write response valid
    logic                            BREADY_M1;    // Write response ready
    // Read address channel signals
    logic    [`AXI_ID_BITS-1:0]      ARID_M1;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_M1;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_M1;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_M1;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_M1;   // Read address burst type
    logic                            ARVALID_M1;   // Read address valid
    logic                            ARREADY_M1;   // Read address ready

    // Read data channel signals
    logic    [`AXI_ID_BITS-1:0]      RID_M1;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_M1;     // Read data
    logic                            RLAST_M1;     // Read last
    logic                            RVALID_M1;    // Read valid
    logic                            RREADY_M1;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_M1;     // Read response

// ---------------------------------slave--------------------------------- //
    // ----------slave0---------- //
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]      ARID_S0;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]     ARADDR_S0;    // Read address
    logic    [`AXI_LEN_BITS-1:0]      ARLEN_S0;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]     ARSIZE_S0;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]    ARBURST_S0;   // Read address burst type
    logic                             ARVALID_S0;   // Read address valid
    logic                             ARREADY_S0;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]      RID_S0;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]     RDATA_S0;     // Read data
    logic                             RLAST_S0;     // Read last
    logic                             RVALID_S0;    // Read valid
    logic                             RREADY_S0;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]     RRESP_S0;     // Read response

    // ----------slave1---------- //
    // Write address channel signals
    logic    [`AXI_IDS_BITS-1:0]      AWID_S1;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]     AWADDR_S1;    // Write address
    logic    [`AXI_LEN_BITS-1:0]      AWLEN_S1;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]     AWSIZE_S1;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]    AWBURST_S1;   // Write address burst type

    logic                             AWVALID_S1;   // Write address valid
    logic                             AWREADY_S1;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_S1;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_S1;     // Write strobe
    logic                            WLAST_S1;     // Write last
    logic                            WVALID_S1;    // Write valid
    logic                            WREADY_S1;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]     BID_S1;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_S1;     // Write response
    logic                            BVALID_S1;    // Write response valid
    logic                            BREADY_S1;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]     ARID_S1;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_S1;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_S1;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_S1;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_S1;   // Read address burst type
    logic                            ARVALID_S1;   // Read address valid
    logic                            ARREADY_S1;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]     RID_S1;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_S1;     // Read data
    logic                            RLAST_S1;     // Read last
    logic                            RVALID_S1;    // Read valid
    logic                            RREADY_S1;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_S1;     // Read response

    // ----------slave2---------- //
    // Write address channel signals
    logic    [`AXI_IDS_BITS-1:0]     AWID_S2;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    AWADDR_S2;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     AWLEN_S2;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    AWSIZE_S2;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   AWBURST_S2;   // Write address burst type

    logic                            AWVALID_S2;   // Write address valid
    logic                            AWREADY_S2;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_S2;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_S2;     // Write strobe
    logic                            WLAST_S2;     // Write last
    logic                            WVALID_S2;    // Write valid
    logic                            WREADY_S2;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]     BID_S2;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_S2;     // Write response
    logic                            BVALID_S2;    // Write response valid
    logic                            BREADY_S2;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]     ARID_S2;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_S2;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_S2;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_S2;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_S2;   // Read address burst type
    logic                            ARVALID_S2;   // Read address valid
    logic                            ARREADY_S2;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]     RID_S2;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_S2;     // Read data
    logic                            RLAST_S2;     // Read last
    logic                            RVALID_S2;    // Read valid
    logic                            RREADY_S2;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_S2;     // Read response

    // ----------slave3---------- //
    // Write address channel signals
    logic    [`AXI_IDS_BITS-1:0]     AWID_S3;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    AWADDR_S3;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     AWLEN_S3;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    AWSIZE_S3;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   AWBURST_S3;   // Write address burst type

    logic                            AWVALID_S3;   // Write address valid
    logic                            AWREADY_S3;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_S3;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_S3;     // Write strobe
    logic                            WLAST_S3;     // Write last
    logic                            WVALID_S3;    // Write valid
    logic                            WREADY_S3;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]     BID_S3;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_S3;     // Write response
    logic                            BVALID_S3;    // Write response valid
    logic                            BREADY_S3;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]     ARID_S3;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_S3;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_S3;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_S3;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_S3;   // Read address burst type
    logic                            ARVALID_S3;   // Read address valid
    logic                            ARREADY_S3;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]     RID_S3;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_S3;     // Read data
    logic                            RLAST_S3;     // Read last
    logic                            RVALID_S3;    // Read valid
    logic                            RREADY_S3;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_S3;     // Read response

    // ----------slave4---------- //
    // Write address channel signals
    logic    [`AXI_IDS_BITS-1:0]     AWID_S4;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    AWADDR_S4;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     AWLEN_S4;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    AWSIZE_S4;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   AWBURST_S4;   // Write address burst type
 
    logic                            AWVALID_S4;   // Write address valid
    logic                            AWREADY_S4;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_S4;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_S4;     // Write strobe
    logic                            WLAST_S4;     // Write last
    logic                            WVALID_S4;    // Write valid
    logic                            WREADY_S4;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]     BID_S4;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_S4;     // Write response
    logic                            BVALID_S4;    // Write response valid
    logic                            BREADY_S4;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]     ARID_S4;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_S4;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_S4;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_S4;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_S4;   // Read address burst type
    logic                            ARVALID_S4;   // Read address valid
    logic                            ARREADY_S4;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]     RID_S4;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_S4;     // Read data
    logic                            RLAST_S4;     // Read last
    logic                            RVALID_S4;    // Read valid
    logic                            RREADY_S4;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_S4;     // Read response

    // ----------slave5---------- //
    // Write address channel signals
    logic    [`AXI_IDS_BITS-1:0]     AWID_S5;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    AWADDR_S5;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     AWLEN_S5;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    AWSIZE_S5;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   AWBURST_S5;   // Write address burst type
 
    logic                            AWVALID_S5;   // Write address valid
    logic                            AWREADY_S5;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    WDATA_S5;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    WSTRB_S5;     // Write strobe
    logic                            WLAST_S5;     // Write last
    logic                            WVALID_S5;    // Write valid
    logic                            WREADY_S5;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]     BID_S5;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    BRESP_S5;     // Write response
    logic                            BVALID_S5;    // Write response valid
    logic                            BREADY_S5;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]     ARID_S5;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    ARADDR_S5;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     ARLEN_S5;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    ARSIZE_S5;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   ARBURST_S5;   // Read address burst type
    logic                            ARVALID_S5;   // Read address valid
    logic                            ARREADY_S5;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]     RID_S5;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    RDATA_S5;     // Read data
    logic                            RLAST_S5;     // Read last
    logic                            RVALID_S5;    // Read valid
    logic                            RREADY_S5;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    RRESP_S5;     // Read response


    // CPU
    CPU_wrapper cpu(
        .ACLK(clk),
        .ARESETn(~rst),

        .AWID_M1(AWID_M1),
        .AWADDR_M1(AWADDR_M1),
        .AWLEN_M1(AWLEN_M1),
        .AWSIZE_M1(AWSIZE_M1),
        .AWBURST_M1(AWBURST_M1),
        .AWVALID_M1(AWVALID_M1),
        .AWREADY_M1(AWREADY_M1),

        .WDATA_M1(WDATA_M1),
        .WSTRB_M1(WSTRB_M1),
        .WLAST_M1(WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .WREADY_M1(WREADY_M1),

        .BID_M1(BID_M1),
        .BRESP_M1(BRESP_M1),
        .BVALID_M1(BVALID_M1),
        .BREADY_M1(BREADY_M1),

        .ARID_M0(ARID_M0),
        .ARADDR_M0(ARADDR_M0),
        .ARLEN_M0(ARLEN_M0),
        .ARSIZE_M0(ARSIZE_M0),
        .ARBURST_M0(ARBURST_M0),
        .ARVALID_M0(ARVALID_M0),
        .ARREADY_M0(ARREADY_M0),

        .RID_M0(RID_M0),
        .RDATA_M0(RDATA_M0),
        .RRESP_M0(RRESP_M0),
        .RLAST_M0(RLAST_M0),
        .RVALID_M0(RVALID_M0),
        .RREADY_M0(RREADY_M0),

        .ARID_M1(ARID_M1),
        .ARADDR_M1(ARADDR_M1),
        .ARLEN_M1(ARLEN_M1),
        .ARSIZE_M1(ARSIZE_M1),
        .ARBURST_M1(ARBURST_M1),
        .ARVALID_M1(ARVALID_M1),
        .ARREADY_M1(ARREADY_M1),

        .RID_M1(RID_M1),
        .RDATA_M1(RDATA_M1),
        .RRESP_M1(RRESP_M1),
        .RLAST_M1(RLAST_M1),
        .RVALID_M1(RVALID_M1),
        .RREADY_M1(RREADY_M1)
    );

    // Bridge
    AXI axi_duv_bridge(
        .ACLK       (clk),
        .ARESETn    (~rst),
        //SLAVE INTERFACE FOR MASTERS
        // WRITE
        .AWID_M1    (AWID_M1),
        .AWADDR_M1  (AWADDR_M1),
        .AWLEN_M1   (AWLEN_M1),
        .AWSIZE_M1  (AWSIZE_M1),
        .AWBURST_M1 (AWBURST_M1),
        .AWVALID_M1 (AWVALID_M1),
        .AWREADY_M1 (AWREADY_M1),
        .WDATA_M1   (WDATA_M1),
        .WSTRB_M1   (WSTRB_M1),
        .WLAST_M1   (WLAST_M1),
        .WVALID_M1  (WVALID_M1),
        .WREADY_M1  (WREADY_M1),
        .BID_M1     (BID_M1),
        .BRESP_M1   (BRESP_M1),
        .BVALID_M1  (BVALID_M1),
        .BREADY_M1  (BREADY_M1),
        // READ
        .ARID_M0    (ARID_M0),
        .ARADDR_M0  (ARADDR_M0),
        .ARLEN_M0   (ARLEN_M0),
        .ARSIZE_M0  (ARSIZE_M0),
        .ARBURST_M0 (ARBURST_M0),
        .ARVALID_M0 (ARVALID_M0),
        .ARREADY_M0 (ARREADY_M0),
        .RID_M0     (RID_M0),
        .RDATA_M0   (RDATA_M0),
        .RRESP_M0   (RRESP_M0),
        .RLAST_M0   (RLAST_M0),
        .RVALID_M0  (RVALID_M0),
        .RREADY_M0  (RREADY_M0),
        .ARID_M1    (ARID_M1),
        .ARADDR_M1  (ARADDR_M1),
        .ARLEN_M1   (ARLEN_M1),
        .ARSIZE_M1  (ARSIZE_M1),
        .ARBURST_M1 (ARBURST_M1),
        .ARVALID_M1 (ARVALID_M1),
        .ARREADY_M1 (ARREADY_M1),
        .RID_M1     (RID_M1),
        .RDATA_M1   (RDATA_M1),
        .RRESP_M1   (RRESP_M1),
        .RLAST_M1   (RLAST_M1),
        .RVALID_M1  (RVALID_M1),
        .RREADY_M1  (RREADY_M1),
        // MASTER INTERFACE FOR SLAVES
        // WRITE
        // Slave 1
        .AWID_S1    (AWID_S1),
        .AWADDR_S1  (AWADDR_S1),
        .AWLEN_S1   (AWLEN_S1),
        .AWSIZE_S1  (AWSIZE_S1),
        .AWBURST_S1 (AWBURST_S1),
        .AWVALID_S1 (AWVALID_S1),
        .AWREADY_S1 (AWREADY_S1),
        .WDATA_S1   (WDATA_S1),
        .WSTRB_S1   (WSTRB_S1),
        .WLAST_S1   (WLAST_S1),
        .WVALID_S1  (WVALID_S1),
        .WREADY_S1  (WREADY_S1),
        .BID_S1     (BID_S1),
        .BRESP_S1   (BRESP_S1),
        .BVALID_S1  (BVALID_S1),
        .BREADY_S1  (BREADY_S1),
        //Slave 2
        .AWID_S2    (AWID_S2),
        .AWADDR_S2  (AWADDR_S2),
        .AWLEN_S2   (AWLEN_S2),
        .AWSIZE_S2  (AWSIZE_S2),
        .AWBURST_S2 (AWBURST_S2),
        .AWVALID_S2 (AWVALID_S2),
        .AWREADY_S2 (AWREADY_S2),
        .WDATA_S2   (WDATA_S2),
        .WSTRB_S2   (WSTRB_S2),
        .WLAST_S2   (WLAST_S2),
        .WVALID_S2  (WVALID_S2),
        .WREADY_S2  (WREADY_S2),
        .BID_S2     (BID_S2),
        .BRESP_S2   (BRESP_S2),
        .BVALID_S2  (BVALID_S2),
        .BREADY_S2  (BREADY_S2),
        // READ
        // Slave 0
        .ARID_S0    (ARID_S0),
        .ARADDR_S0  (ARADDR_S0),
        .ARLEN_S0   (ARLEN_S0),
        .ARSIZE_S0  (ARSIZE_S0),
        .ARBURST_S0 (ARBURST_S0),
        .ARVALID_S0 (ARVALID_S0),
        .ARREADY_S0 (ARREADY_S0),
        .RID_S0     (RID_S0),
        .RDATA_S0   (RDATA_S0),
        .RRESP_S0   (RRESP_S0),
        .RLAST_S0   (RLAST_S0),
        .RVALID_S0  (RVALID_S0),
        .RREADY_S0  (RREADY_S0),
        // Slave 1
        .ARID_S1    (ARID_S1),
        .ARADDR_S1  (ARADDR_S1),
        .ARLEN_S1   (ARLEN_S1),
        .ARSIZE_S1  (ARSIZE_S1),
        .ARBURST_S1 (ARBURST_S1),
        .ARVALID_S1 (ARVALID_S1),
        .ARREADY_S1 (ARREADY_S1),
        .RID_S1     (RID_S1),
        .RDATA_S1   (RDATA_S1),
        .RRESP_S1   (RRESP_S1),
        .RLAST_S1   (RLAST_S1),
        .RVALID_S1  (RVALID_S1),
        .RREADY_S1  (RREADY_S1),
        // Slave 2
        .ARID_S2    (ARID_S2),
        .ARADDR_S2  (ARADDR_S2),
        .ARLEN_S2   (ARLEN_S2),
        .ARSIZE_S2  (ARSIZE_S2),
        .ARBURST_S2 (ARBURST_S2),
        .ARVALID_S2 (ARVALID_S2),
        .ARREADY_S2 (ARREADY_S2),
        .RID_S2     (RID_S2),
        .RDATA_S2   (RDATA_S2),
        .RRESP_S2   (RRESP_S2),
        .RLAST_S2   (RLAST_S2),
        .RVALID_S2  (RVALID_S2),
        .RREADY_S2  (RREADY_S2),

        // Slave 3
        .ARID_S3    (ARID_S3),
        .ARADDR_S3  (ARADDR_S3),
        .ARLEN_S3   (ARLEN_S3),
        .ARSIZE_S3  (ARSIZE_S3),
        .ARBURST_S3 (ARBURST_S3),
        .ARVALID_S3 (ARVALID_S3),
        .ARREADY_S3 (ARREADY_S3),
        .RID_S3     (RID_S3),
        .RDATA_S3   (RDATA_S3),
        .RRESP_S3   (RRESP_S3),
        .RLAST_S3   (RLAST_S3),
        .RVALID_S3  (RVALID_S3),
        .RREADY_S3  (RREADY_S3),

        // Slave 4
        .ARID_S4    (ARID_S4),
        .ARADDR_S4  (ARADDR_S4),
        .ARLEN_S4   (ARLEN_S4),
        .ARSIZE_S4  (ARSIZE_S4),
        .ARBURST_S4 (ARBURST_S4),
        .ARVALID_S4 (ARVALID_S4),
        .ARREADY_S4 (ARREADY_S4),
        .RID_S4     (RID_S4),
        .RDATA_S4   (RDATA_S4),
        .RRESP_S4   (RRESP_S4),
        .RLAST_S4   (RLAST_S4),
        .RVALID_S4  (RVALID_S4),
        .RREADY_S4  (RREADY_S4),

        // Slave 5
        .ARID_S5    (ARID_S5),
        .ARADDR_S5  (ARADDR_S5),
        .ARLEN_S5   (ARLEN_S5),
        .ARSIZE_S5  (ARSIZE_S5),
        .ARBURST_S5 (ARBURST_S5),
        .ARVALID_S5 (ARVALID_S5),
        .ARREADY_S5 (ARREADY_S5),
        .RID_S5     (RID_S5),
        .RDATA_S5   (RDATA_S5),
        .RRESP_S5   (RRESP_S5),
        .RLAST_S5   (RLAST_S5),
        .RVALID_S5  (RVALID_S5),
        .RREADY_S5  (RREADY_S5)
	);

    ROM_wrapper ROM(
        .ACLK   (clk),
        .ARESETn(~rst),
        // READ ADDRESS
        .ARID   (ARID_S0),
        .ARADDR (ARADDR_S0),
        .ARLEN  (ARLEN_S0),
        .ARSIZE (ARSIZE_S0),
        .ARBURST(ARBURST_S0),
        .ARVALID(ARVALID_S0),
        .ARREADY(ARREADY_S0),
        // READ DATA
        .RID    (RID_S0),
        .RDATA  (RDATA_S0),
        .RRESP  (RRESP_S0),
        .RLAST  (RLAST_S0),
        .RVALID (RVALID_S0),
        .RREADY (RREADY_S0),
        .ROM_out(ROM_out),
        .ROM_read(ROM_read),
        .ROM_enable(ROM_enable),
        .ROM_address(ROM_address)
    ); 

    // SRAM
    SRAM_wrapper IM1
    (
        .ACLK  (clk),
        .ARESETn  (~rst),
        // READ ADDRESS
        .ARID_S   (ARID_S1),
        .ARADDR_S (ARADDR_S1),
        .ARLEN_S  (ARLEN_S1),
        .ARSIZE_S (ARSIZE_S1),
        .ARBURST_S(ARBURST_S1),
        .ARVALID_S(ARVALID_S1),
        .ARREADY_S(ARREADY_S1),
        // READ DATA
        .RID_S    (RID_S1),
        .RDATA_S  (RDATA_S1),
        .RRESP_S  (RRESP_S1),
        .RLAST_S  (RLAST_S1),
        .RVALID_S (RVALID_S1),
        .RREADY_S (RREADY_S1),
        // WRITE ADDRESS
        .AWID_S   (AWID_S1),
        .AWADDR_S (AWADDR_S1),
        .AWLEN_S  (AWLEN_S1),
        .AWSIZE_S (AWSIZE_S1),
        .AWBURST_S(AWBURST_S1),
        .AWVALID_S(AWVALID_S1),
        .AWREADY_S(AWREADY_S1),
        // WRITE DATA
        .WDATA_S  (WDATA_S1),
        .WSTRB_S  (WSTRB_S1),
        .WLAST_S  (WLAST_S1),
        .WVALID_S (WVALID_S1),
        .WREADY_S (WREADY_S1),
        // WRITE RESPONSE
        .BID_S    (BID_S1),
        .BRESP_S  (BRESP_S1),
        .BVALID_S (BVALID_S1),
        .BREADY_S (BREADY_S1)
    );

    // SRAM
    SRAM_wrapper DM1
    (
        .ACLK  (clk),
        .ARESETn  (~rst),
        // READ ADDRESS
        .ARID_S   (ARID_S2),
        .ARADDR_S (ARADDR_S2),
        .ARLEN_S  (ARLEN_S2),
        .ARSIZE_S (ARSIZE_S2),
        .ARBURST_S(ARBURST_S2),
        .ARVALID_S(ARVALID_S2),
        .ARREADY_S(ARREADY_S2),
        // READ DATA
        .RID_S    (RID_S2),
        .RDATA_S  (RDATA_S2),
        .RRESP_S  (RRESP_S2),
        .RLAST_S  (RLAST_S2),
        .RVALID_S (RVALID_S2),
        .RREADY_S (RREADY_S2),
        // WRITE ADDRESS
        .AWID_S   (AWID_S2),
        .AWADDR_S (AWADDR_S2),
        .AWLEN_S  (AWLEN_S2),
        .AWSIZE_S (AWSIZE_S2),
        .AWBURST_S(AWBURST_S2),
        .AWVALID_S(AWVALID_S2),
        .AWREADY_S(AWREADY_S2),
        // WRITE DATA
        .WDATA_S  (WDATA_S2),
        .WSTRB_S  (WSTRB_S2),
        .WLAST_S  (WLAST_S2),
        .WVALID_S (WVALID_S2),
        .WREADY_S (WREADY_S2),
        // WRITE RESPONSE
        .BID_S    (BID_S2),
        .BRESP_S  (BRESP_S2),
        .BVALID_S (BVALID_S2),
        .BREADY_S (BREADY_S2)
    );



    
endmodule