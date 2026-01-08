module Bridge_Read(
    input ACLK,
    input ARESETn,
    //SLAVE INTERFACE FOR MASTERS
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
    logic [1:0] state, next_state;
    // localparam  Arbitrate = 2'd0, Read_Addr = 2'd1, Read_Data = 2'd2;

    logic control_M;
    logic read_arbitrate;
    logic [1:0] master_req;
    logic slave_sel_M0, slave_sel_M1;
    //register
    logic prev_M;
    logic control_M_reg;

    logic ARVALID_M0_reg, ARVALID_M1_reg;
    logic slave_sel_M0_reg, slave_sel_M1_reg;


    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) state <= 2'b0;
        else state <= next_state;
    end

    // Decoder
    Read_Decoder read_decode(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .state(state),
        .ARADDR_M0(ARADDR_M0),
        .ARADDR_M1(ARADDR_M1),
        .slave_sel_M1(slave_sel_M1),
        .slave_sel_M0(slave_sel_M0),
        .slave_sel_M1_reg(slave_sel_M1_reg),
        .slave_sel_M0_reg(slave_sel_M0_reg)
    );

    // Arbiter
    Read_Arbiter read_arbiter(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .state(state),
        .ARVALID_M0(ARVALID_M0),
        .ARVALID_M1(ARVALID_M1),
        .slave_sel_M0(slave_sel_M0),
        .slave_sel_M1(slave_sel_M1),
        .ARVALID_M0_reg(ARVALID_M0_reg),
        .ARVALID_M1_reg(ARVALID_M1_reg),
        .master_req(master_req),
        .control_M_reg(control_M_reg)
    );

    AR_master_interface ar_master_interface(
        .state(state),
        .master_req(master_req),
        .slave_sel_M0_reg(slave_sel_M0_reg),
        .slave_sel_M1_reg(slave_sel_M1_reg),
        .control_M_reg(control_M_reg),
        //SLAVE INTERFACE FOR MASTERS
        //READ ADDRESS0
        .ARID_M0(ARID_M0),
        .ARADDR_M0(ARADDR_M0),
        .ARLEN_M0(ARLEN_M0),
        .ARSIZE_M0(ARSIZE_M0),
        .ARBURST_M0(ARBURST_M0),
        .ARVALID_M0(ARVALID_M0),

        //READ ADDRESS1
        .ARID_M1(ARID_M1),
        .ARADDR_M1(ARADDR_M1),
        .ARLEN_M1(ARLEN_M1),
        .ARSIZE_M1(ARSIZE_M1),
        .ARBURST_M1(ARBURST_M1),
        .ARVALID_M1(ARVALID_M1),

        //MASTER INTERFACE FOR SLAVES
        //READ ADDRESS0
        .ARID_S0(ARID_S0),
        .ARADDR_S0(ARADDR_S0),
        .ARSIZE_S0(ARSIZE_S0),
        .ARBURST_S0(ARBURST_S0),
        .ARVALID_S0(ARVALID_S0),

        //READ ADDRESS1
        .ARID_S1(ARID_S1),
        .ARADDR_S1(ARADDR_S1),
        .ARLEN_S1(ARLEN_S1),
        .ARSIZE_S1(ARSIZE_S1),
        .ARBURST_S1(ARBURST_S1),
        .ARVALID_S1(ARVALID_S1),
		
        //READ ADDRESS2
        .ARID_S2(ARID_S2),
        .ARADDR_S2(ARADDR_S2),
        .ARLEN_S2(ARLEN_S2),
        .ARSIZE_S2(ARSIZE_S2),
        .ARBURST_S2(ARBURST_S2),
        .ARVALID_S2(ARVALID_S2),

        //READ ADDRESS3
        .ARID_S3(ARID_S3),
        .ARADDR_S3(ARADDR_S3),
        .ARLEN_S3(ARLEN_S3),
        .ARSIZE_S3(ARSIZE_S3),
        .ARBURST_S3(ARBURST_S3),
        .ARVALID_S3(ARVALID_S3),

        //READ ADDRESS4
        .ARID_S4(ARID_S4),
        .ARADDR_S4(ARADDR_S4),
        .ARLEN_S4(ARLEN_S4),
        .ARSIZE_S4(ARSIZE_S4),
        .ARBURST_S4(ARBURST_S4),
        .ARVALID_S4(ARVALID_S4),

        //READ ADDRESS5
        .ARID_S5(ARID_S5),
        .ARADDR_S5(ARADDR_S5),
        .ARLEN_S5(ARLEN_S5),
        .ARSIZE_S5(ARSIZE_S5),
        .ARBURST_S5(ARBURST_S5),
        .ARVALID_S5(ARVALID_S5)
    );

    AR_slave_interface ar_slave_interface(
        .state(state),
        .master_req(master_req),
        .slave_sel_M0_reg(slave_sel_M0_reg),
        .slave_sel_M1_reg(slave_sel_M1_reg),
        .control_M_reg(control_M_reg),
        
        .ARREADY_S0(ARREADY_S0), 
        .ARREADY_S1(ARREADY_S1),
		.ARREADY_S2(ARREADY_S2),
        .ARREADY_S3(ARREADY_S3),
		.ARREADY_S4(ARREADY_S4),
		.ARREADY_S5(ARREADY_S5),

		.ARREADY_M0(ARREADY_M0),
        .ARREADY_M1(ARREADY_M1)
    );
    
    R_master_interface r_master_interface(
        .state(state),
        .master_req(master_req),
        .slave_sel_M0_reg(slave_sel_M0_reg),
        .slave_sel_M1_reg(slave_sel_M1_reg),
        .control_M_reg(control_M_reg),
        
        .RREADY_M0(RREADY_M0),
        .RREADY_M1(RREADY_M1),

        .RREADY_S0(RREADY_S0),
        .RREADY_S1(RREADY_S1),
        .RREADY_S2(RREADY_S2),
        .RREADY_S3(RREADY_S3),
        .RREADY_S4(RREADY_S4),
        .RREADY_S5(RREADY_S5)
    );

    R_slave_interface r_slave_interface(
        .state(state),
        .master_req(master_req),
        .slave_sel_M0_reg(slave_sel_M0_reg),
        .slave_sel_M1_reg(slave_sel_M1_reg),
        .control_M_reg(control_M_reg),

        //READ DATA0
        .RID_S0(RID_S0),
        .RDATA_S0(RDATA_S0),
        .RRESP_S0(RRESP_S0),
        .RLAST_S0(RLAST_S0),
        .RVALID_S0(RVALID_S0),

        //READ DATA1
        .RID_S1(RID_S1),
        .RDATA_S1(RDATA_S1),
        .RRESP_S1(RRESP_S1),
        .RLAST_S1(RLAST_S1),
        .RVALID_S1(RVALID_S1),

        //READ DATA2
        .RID_S2(RID_S2),
        .RDATA_S2(RDATA_S2),
        .RRESP_S2(RRESP_S2),
        .RLAST_S2(RLAST_S2),
        .RVALID_S2(RVALID_S2),	
        
		//READ DATA3
        .RID_S3(RID_S3),
        .RDATA_S3(RDATA_S3),
        .RRESP_S3(RRESP_S3),
        .RLAST_S3(RLAST_S3),
        .RVALID_S3(RVALID_S3),

        //READ DATA4
        .RID_S4(RID_S4),
        .RDATA_S4(RDATA_S4),
        .RRESP_S4(RRESP_S4),
        .RLAST_S4(RLAST_S4),
        .RVALID_S4(RVALID_S4),

        //READ DATA5
        .RID_S5(RID_S5),
        .RDATA_S5(RDATA_S5),
        .RRESP_S5(RRESP_S5),
        .RLAST_S5(RLAST_S5),
        .RVALID_S5(RVALID_S5),

		//READ DATA0
        .RID_M0(RID_M0),
        .RDATA_M0(RDATA_M0),
        .RRESP_M0(RRESP_M0),
        .RLAST_M0(RLAST_M0),
        .RVALID_M0(RVALID_M0),

        //READ DATA1
        .RID_M1(RID_M1),
        .RDATA_M1(RDATA_M1),
        .RRESP_M1(RRESP_M1),
        .RLAST_M1(RLAST_M1),
        .RVALID_M1(RVALID_M1)
    );


    always @(*) begin
        case(state)
            `Arbitrate: begin
                if(ARVALID_M0 | ARVALID_M1) next_state = `Read_Addr;
                else next_state = `Arbitrate;
            end
            `Read_Addr: begin
                if((ARVALID_S0 | ARVALID_S1) & (ARREADY_M0 | ARREADY_M1)) next_state = `Read_Data;
                else next_state = `Read_Addr;
            end
            `Read_Data: begin
                if((RVALID_M0 | RVALID_M1) & (RREADY_S0 | RREADY_S1) & (RLAST_M0 | RLAST_M1)) next_state = `Arbitrate;
                else next_state = `Read_Data;
            end
            default: next_state = `Arbitrate;
        endcase
    end

endmodule
