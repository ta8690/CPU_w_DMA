module CPU_wrapper (
    input ACLK,
    input ARESETn,
    //READ ADDRESS0
    output logic [`AXI_ID_BITS-1:0] ARID_M0,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_M0,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
    output logic [1:0] ARBURST_M0,
    output logic ARVALID_M0,
    input ARREADY_M0,

    //READ DATA0
    input [`AXI_ID_BITS-1:0] RID_M0,
    input [`AXI_DATA_BITS-1:0] RDATA_M0,
    input [1:0] RRESP_M0,
    input RLAST_M0,
    input RVALID_M0,
    output logic RREADY_M0,

    //READ ADDRESS1
    output logic [`AXI_ID_BITS-1:0] ARID_M1,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    output logic [`AXI_LEN_BITS-1:0] ARLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
    output logic [1:0] ARBURST_M1,
    output logic ARVALID_M1,
    input ARREADY_M1,

    //READ DATA1
    input [`AXI_ID_BITS-1:0] RID_M1,
    input [`AXI_DATA_BITS-1:0] RDATA_M1,
    input [1:0] RRESP_M1,
    input RLAST_M1,
    input RVALID_M1,
    output logic RREADY_M1,

    //WRITE ADDRESS
    output logic [`AXI_ID_BITS-1:0] AWID_M1,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1,
    output logic [`AXI_LEN_BITS-1:0] AWLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
    output logic [1:0] AWBURST_M1,
    output logic AWVALID_M1,
    input AWREADY_M1,

    //WRITE DATA
    output logic [`AXI_DATA_BITS-1:0] WDATA_M1,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M1,
    output logic WLAST_M1,
    output logic WVALID_M1,
    input WREADY_M1,

    //WRITE RESPONSE
    input [`AXI_ID_BITS-1:0] BID_M1,
    input [1:0] BRESP_M1,
    input BVALID_M1,
    output logic BREADY_M1
);
    logic clk, rst;
    assign clk = ACLK;
    assign rst = ~ARESETn;
    logic [1:0] rst_n;
    logic [`CPU_DATA_BITS-1:0] pc, next_pc, pc_add4;
    logic [`CPU_DATA_BITS-1:0] inst, inst_original;
    logic [`CPU_DATA_BITS-1:0] IF_ID_pc, IF_ID_inst;

    logic [4:0] rs1_index, rs2_index, rd_index;
    logic [`CPU_DATA_BITS-1:0] rs1_data, rs2_data;
    logic [`CPU_DATA_BITS-1:0] imm_ext, ID_EXE_imm_ext;
    logic [`CPU_DATA_BITS-1:0] ID_EXE_pc;
    logic [`CPU_DATA_BITS-1:0] ID_EXE_inst;
    logic [5:0] ID_EXE_rs1_index;
    logic [5:0] ID_EXE_rs2_index;
    logic [5:0] ID_EXE_rd_index, EXE_MEM_rd_index, MEM_WB_rd_index;
    logic [`CPU_DATA_BITS-1:0] ID_EXE_rs1_data;
    logic [`CPU_DATA_BITS-1:0] ID_EXE_rs2_data, EXE_MEM_rs2_data;
    logic [4:0] opcode, ID_EXE_opcode, EXE_MEM_opcode, MEM_WB_opcode;
    logic opcode_LSB, ID_EXE_opcode_LSB, EXE_MEM_opcode_LSB, MEM_WB_opcode_LSB;
    logic [2:0] funct3, ID_EXE_funct3, EXE_MEM_funct3, MEM_WB_funct3;
    logic [4:0] funct5, ID_EXE_funct5;
    logic [6:0] funct7, ID_EXE_funct7;
    logic EXE_MEM_funct7_mul;

    logic [`CPU_DATA_BITS-1:0] rs1_data_mux_1, rs2_data_mux_1;
    logic [`CPU_DATA_BITS-1:0] rs1_data_mux_2, rs2_data_mux_2;
    logic [`CPU_DATA_BITS-1:0] rs1_data_mux_3, rs2_data_mux_3;

    logic [`CPU_DATA_BITS-1:0] operand1, EXE_MEM_operand1;
    logic [`CPU_DATA_BITS-1:0] operand2, EXE_MEM_operand2;
    logic [`CPU_DATA_BITS-1:0] alu_out, EXE_MEM_alu_out, MEM_WB_alu_out;
    logic [`CPU_DATA_BITS-1:0] csr_o, EXE_MEM_csr_o;
    logic [`CPU_DATA_BITS-1:0] alu_csr, mul_alu_csr;

    logic [1:0] IF_ID_rs1_data_sel, IF_ID_rs2_data_sel;
    logic [1:0] ID_EXE_rs1_data_sel, ID_EXE_rs2_data_sel;

    logic [3:0] BWEB, BWEB_shift;
    logic alu_operand1_sel, alu_operand2_sel;
    logic jb_operand_sel;
    logic mul_en, csr_en;
    logic [`CPU_DATA_BITS-1:0] mul_out;
    logic wb_data_sel;

    logic [`CPU_DATA_BITS-1:0] jb_operand, jb_out;

    logic [`CPU_DATA_BITS-1:0] DM_data_shift;

    logic stall, stall_delay, flush, flush_delay;

    logic read_signal_IM;
    logic read_signal_DM, write_signal_DM;

    logic [`CPU_DATA_BITS-1:0] ld_data, MEM_WB_ld_data, ld_data_aligned;
    logic [`CPU_DATA_BITS-1:0] wb_data;
    logic RegWrite;

    logic [5:0] n_rs1_index;
    logic [5:0] n_rs2_index;
    logic [5:0] n_rd_index;
    logic [1:0] float_int_data_sel;
    logic [`CPU_DATA_BITS-1:0] frs1_data;
    logic [`CPU_DATA_BITS-1:0] frs2_data;


    logic ID_EXE_mul_en;
    logic EXE_MEM_mul_en;
    logic EXE_MEM2_mul_en;
    logic [4:0] EXE_MEM2_opcode;
    logic EXE_MEM2_opcode_LSB;
    logic [2:0] EXE_MEM2_funct3;
    logic EXE_MEM2_funct7_mul;
    logic [5:0] EXE_MEM2_rd_index;
    logic [`CPU_DATA_BITS-1:0] EXE_MEM2_rs2_data;
    logic [`CPU_DATA_BITS-1:0] EXE_MEM2_mul_out;
    logic [`CPU_DATA_BITS-1:0] EXE_MEM2_alu_csr;

    logic dm_addr;
    assign dm_addr = (mul_alu_csr[15:2] == 14'd49 && write_signal_DM) ? 1'b1 : 1'b0;

    // AXI signal
    logic axi_stall, axi_stall_IM_read, axi_stall_DM_read, axi_stall_DM_write;

    assign axi_stall = axi_stall_IM_read | axi_stall_DM_read | axi_stall_DM_write;

    always @(posedge clk or posedge rst) begin
        if (rst) read_signal_IM <= 1'b0;
        else if(axi_stall_DM_write & !axi_stall_IM_read) read_signal_IM <= 1'b0;
        else read_signal_IM <= 1'b1;
    end

    assign pc_add4 = pc + `CPU_DATA_BITS'd4;

    MUX_2in jb_pc_mux (
        .in1(jb_out),
        .in2(pc_add4),
        .sel(flush),
        .mux_out(next_pc)
    );

    Program_Counter pc_unit (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .axi_stall(axi_stall),
        .next_pc(next_pc),
        .pc(pc)
    );


    Master_Read MR_inst(
    .ACLK(clk),
    .ARESETn(~rst),

    // READ ADDRESS0
	.ARID(ARID_M0),
	.ARADDR(ARADDR_M0),
	.ARLEN(ARLEN_M0),
	.ARSIZE(ARSIZE_M0),
	.ARBURST(ARBURST_M0),
	.ARVALID(ARVALID_M0),
	.ARREADY(ARREADY_M0),

	// READ DATA0
	.RID(RID_M0),
	.RDATA(RDATA_M0),
	.RRESP(RRESP_M0),
	.RLAST(RLAST_M0),
	.RVALID(RVALID_M0),
	.RREADY(RREADY_M0),

    // CPU signal
    .cpu_read_req(read_signal_IM),
    .cpu_read_id(4'd0),
    .cpu_read_addr(pc),
    .cpu_arlen(4'd0),
    .cpu_arsize(3'b010),
    .cpu_arburst(2'b01),
    .cpu_read_data(inst),
    .stall_cpu(axi_stall_IM_read)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) rst_n <= 1'b0;
        // else rst_n <= 1'b1;
        else rst_n <= (rst_n < 2'd2) ? rst_n + 1'b1 : rst_n;
    end
    // assign inst = (rst_n == 2'd2) ? inst_original : `CPU_DATA_BITS'b0;

    Reg_IF_ID reg_IF_ID (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .inst(inst),
        .stall(stall),
        .axi_stall(axi_stall),
        .axi_stall_IM_read(axi_stall_IM_read),
        .RVALID_Inst(RVALID_M0),
        .flush(flush),
        .IF_ID_pc(IF_ID_pc),
        .IF_ID_inst(IF_ID_inst)
    );

    Controller control_unit (
        // Input
        .opcode(opcode),
        .ID_EXE_funct7(ID_EXE_funct7),
        .ID_EXE_opcode(ID_EXE_opcode),
        .EXE_MEM_opcode(EXE_MEM_opcode),
        .EXE_MEM2_opcode(EXE_MEM2_opcode),
        .EXE_MEM_funct3(EXE_MEM_funct3),
        .EXE_MEM2_funct3(EXE_MEM2_funct3),
        .EXE_MEM_funct7_mul(EXE_MEM_funct7_mul),
        .EXE_MEM2_funct7_mul(EXE_MEM2_funct7_mul),
        .MEM_WB_opcode(MEM_WB_opcode),
        .MEM_WB_opcode_LSB(MEM_WB_opcode_LSB),
        // Output
        .alu_operand1_sel(alu_operand1_sel),
        .alu_operand2_sel(alu_operand2_sel),
        .jb_operand_sel(jb_operand_sel),
        .ID_EXE_mul_en(ID_EXE_mul_en),
        .EXE_MEM_mul_en(EXE_MEM_mul_en),
        .EXE_MEM2_mul_en(EXE_MEM2_mul_en),
        .csr_en(csr_en),
        .BWEB(BWEB),
        .RegWrite(RegWrite),
        .float_int_data_sel(float_int_data_sel),
        .wb_data_sel(wb_data_sel)
    );

    Hazard_Detector hazard_detect (
        .opcode(opcode),
        .ID_EXE_opcode(ID_EXE_opcode),
        .EXE_MEM_opcode(EXE_MEM_opcode),
        .EXE_MEM2_opcode(EXE_MEM2_opcode),
        .MEM_WB_opcode(MEM_WB_opcode),
        .ID_EXE_opcode_LSB(ID_EXE_opcode_LSB),
        .EXE_MEM_opcode_LSB(EXE_MEM_opcode_LSB),
        .EXE_MEM2_opcode_LSB(EXE_MEM2_opcode_LSB),
        .MEM_WB_opcode_LSB(MEM_WB_opcode_LSB),
        .rs1_index(n_rs1_index),
        .rs2_index(n_rs2_index),
        .ID_EXE_rs1_index(ID_EXE_rs1_index),
        .ID_EXE_rs2_index(ID_EXE_rs2_index),
        .ID_EXE_rd_index(ID_EXE_rd_index),
        .EXE_MEM_rd_index(EXE_MEM_rd_index),
        .EXE_MEM2_rd_index(EXE_MEM2_rd_index),
        .MEM_WB_rd_index(MEM_WB_rd_index),
        .ID_EXE_mul_en(ID_EXE_mul_en),
        .EXE_MEM_mul_en(EXE_MEM_mul_en),
        .EXE_MEM2_mul_en(EXE_MEM2_mul_en),
        .IF_ID_rs1_data_sel(IF_ID_rs1_data_sel),
        .IF_ID_rs2_data_sel(IF_ID_rs2_data_sel),
        .ID_EXE_rs1_data_sel(ID_EXE_rs1_data_sel),
        .ID_EXE_rs2_data_sel(ID_EXE_rs2_data_sel),
        .stall(stall)
    );

    Decoder decoder_unit (
        .inst(IF_ID_inst),
        .funct3(funct3),
        .funct5(funct5),
        .funct7(funct7),
        .opcode(opcode),
        .opcode_LSB(opcode_LSB),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rd_index(rd_index)
    );

    RegIndex_Filter regindex_filter_unit (
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rd_index(rd_index),
        .opcode(opcode),
        .n_rs1_index(n_rs1_index),
        .n_rs2_index(n_rs2_index),
        .n_rd_index(n_rd_index)
    );

    Imm_Extend imm_ext_unit (
        .inst(IF_ID_inst),
        .imm_ext(imm_ext)
    );

    RegFile regfile (
        .clk(clk),
        .rst(rst),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .MEM_WB_rd_index(MEM_WB_rd_index),
        .wb_data(wb_data),
        .RegWrite(RegWrite),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    F_RegFile f_regfile (
        .clk(clk),
        .rst(rst),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .MEM_WB_rd_index(MEM_WB_rd_index),
        .wb_data(wb_data),
        .RegWrite(RegWrite),
        .frs1_data(frs1_data),
        .frs2_data(frs2_data)
    );

    MUX_2in f_int_mux_a (
        .in1(frs1_data),
        .in2(rs1_data),
        .sel (float_int_data_sel[1]),
        .mux_out (rs1_data_mux_1)
    );
    MUX_2in f_int_mux_b (
        .in1(frs2_data),
        .in2(rs2_data),
        .sel (float_int_data_sel[0]),
        .mux_out (rs2_data_mux_1)
    );


    MUX_4in forwarding_a (
        .in1(rs1_data_mux_1),
        .in2(alu_csr),
        .in3(mul_alu_csr),
        .in4(wb_data),
        .sel(IF_ID_rs1_data_sel),
        .mux_out(rs1_data_mux_2)
    );
    MUX_4in forwarding_b (
        .in1(rs2_data_mux_1),
        .in2(alu_csr),
        .in3(mul_alu_csr),
        .in4(wb_data),
        .sel(IF_ID_rs2_data_sel),
        .mux_out(rs2_data_mux_2)
    );

    MUX_2in mux_jb (
        .in1(rs1_data_mux_2),
        .in2(IF_ID_pc),
        .sel(jb_operand_sel),
        .mux_out(jb_operand)
    );

    Jump_Branch jb_unit (
        .imm_ext(imm_ext),
        .jb_operand(jb_operand),
        .rs1_data(rs1_data_mux_2),
        .rs2_data(rs2_data_mux_2),
        .opcode(opcode),
        .funct3(funct3),
        .stall(stall),
        .flush(flush),
        .jb_out(jb_out)
    );

    Reg_ID_EXE reg_id_exe (
        .clk(clk),
        .rst(rst),
        // Input
        .axi_stall(axi_stall),
        .pc(IF_ID_pc),
        .inst(IF_ID_inst),
        .imm_ext(imm_ext),
        .opcode(opcode),
        .opcode_LSB(opcode_LSB),
        .funct3(funct3),
        .funct5(funct5),
        .funct7(funct7),
        .rs1_index(n_rs1_index),
        .rs2_index(n_rs2_index),
        .rd_index(n_rd_index),
        .rs1_data(rs1_data_mux_2),
        .rs2_data(rs2_data_mux_2),
        .stall(stall),
        // Output
        .ID_EXE_pc(ID_EXE_pc),
        .ID_EXE_inst(ID_EXE_inst),
        .ID_EXE_imm_ext(ID_EXE_imm_ext),
        .ID_EXE_opcode(ID_EXE_opcode),
        .ID_EXE_opcode_LSB(ID_EXE_opcode_LSB),
        .ID_EXE_funct3(ID_EXE_funct3),
        .ID_EXE_funct5(ID_EXE_funct5),
        .ID_EXE_funct7(ID_EXE_funct7),
        .ID_EXE_rs1_index(ID_EXE_rs1_index),
        .ID_EXE_rs2_index(ID_EXE_rs2_index),
        .ID_EXE_rd_index(ID_EXE_rd_index),
        .ID_EXE_rs1_data(ID_EXE_rs1_data),
        .ID_EXE_rs2_data(ID_EXE_rs2_data)
    );

    MUX_4in forwarding_c (
        .in1(ID_EXE_rs1_data),
        .in2(alu_csr),
        .in3(mul_alu_csr),
        .in4(wb_data),
        .sel(ID_EXE_rs1_data_sel),
        .mux_out(rs1_data_mux_3)
    );
    MUX_4in forwarding_d (
        .in1(ID_EXE_rs2_data),
        .in2(alu_csr),
        .in3(mul_alu_csr),
        .in4(wb_data),
        .sel(ID_EXE_rs2_data_sel),
        .mux_out(rs2_data_mux_3)
    );

    MUX_2in mux_pc_rs1 (
        .in1(ID_EXE_pc),
        .in2(rs1_data_mux_3),
        .sel(alu_operand1_sel),
        .mux_out(operand1)
    );
    MUX_2in mux_imm_rs2 (
        .in1(ID_EXE_imm_ext),
        .in2(rs2_data_mux_3),
        .sel(alu_operand2_sel),
        .mux_out(operand2)
    );


    ALU alu_unit (
        .funct3  (ID_EXE_funct3),
        .funct5  (ID_EXE_funct5),
        .funct7  (ID_EXE_funct7),
        .opcode  (ID_EXE_opcode),
        .operand1(operand1),
        .operand2(operand2),
        .alu_out (alu_out)
    );

    CSR csr_unit (
        .clk(clk),
        .rst(rst),
        .axi_stall(axi_stall),
        .imm_ext_L7B(ID_EXE_imm_ext[7:1]),
        .ID_EXE_pc(ID_EXE_pc),
        .stall(stall),
        .csr_o(csr_o)
    );

    Reg_EXE_MEM reg_exe_mem (
        .clk(clk),
        .rst(rst),
        // Input
        .axi_stall(axi_stall),
        .opcode(ID_EXE_opcode),
        .opcode_LSB(ID_EXE_opcode_LSB),
        .funct3(ID_EXE_funct3),
        .funct7_mul(ID_EXE_funct7[0]),
        .rd_index(ID_EXE_rd_index),
        .rs2_data(rs2_data_mux_3),
        .operand1(operand1),
        .operand2(operand2),
        .alu_out(alu_out),
        .csr_o(csr_o),
        // Output
        .EXE_MEM_opcode(EXE_MEM_opcode),
        .EXE_MEM_opcode_LSB(EXE_MEM_opcode_LSB),
        .EXE_MEM_funct3(EXE_MEM_funct3),
        .EXE_MEM_funct7_mul(EXE_MEM_funct7_mul),
        .EXE_MEM_rd_index(EXE_MEM_rd_index),
        .EXE_MEM_rs2_data(EXE_MEM_rs2_data),
        .EXE_MEM_operand1(EXE_MEM_operand1),
        .EXE_MEM_operand2(EXE_MEM_operand2),
        .EXE_MEM_alu_out(EXE_MEM_alu_out),
        .EXE_MEM_csr_o(EXE_MEM_csr_o)
    );

    MUX_2in mux_alu_csr (
        .in1(EXE_MEM_csr_o),
        .in2(EXE_MEM_alu_out),
        .sel(csr_en),
        .mux_out(alu_csr)
    );

    MUL multiplier (
        .opcode(EXE_MEM_opcode),
        .funct3(EXE_MEM_funct3),
        .funct7_mul(EXE_MEM_funct7_mul),
        .operand1(EXE_MEM_operand1),
        .operand2(EXE_MEM_operand2),
        .mul_out(mul_out)
    );

    Reg_EXE_MEM2 reg_exe_mem2 (
        .clk(clk),
        .rst(rst),
        // Input
        .axi_stall(axi_stall),
        .RVALID_Data(RVALID_M1),
        .opcode(EXE_MEM_opcode),
        .opcode_LSB(EXE_MEM_opcode_LSB),
        .funct3(EXE_MEM_funct3),
        .funct7_mul(EXE_MEM_funct7_mul),
        .rd_index(EXE_MEM_rd_index),
        .rs2_data(EXE_MEM_rs2_data),
        .mul_out(mul_out),
        .alu_csr(alu_csr),
        // Output
        .EXE_MEM2_opcode(EXE_MEM2_opcode),
        .EXE_MEM2_opcode_LSB(EXE_MEM2_opcode_LSB),
        .EXE_MEM2_funct3(EXE_MEM2_funct3),
        .EXE_MEM2_funct7_mul(EXE_MEM2_funct7_mul),
        .EXE_MEM2_rd_index(EXE_MEM2_rd_index),
        .EXE_MEM2_rs2_data(EXE_MEM2_rs2_data),
        .EXE_MEM2_mul_out(EXE_MEM2_mul_out),
        .EXE_MEM2_alu_csr(EXE_MEM2_alu_csr)
    );

    MUX_2in mux_mul_alu_csr (
        .in1(EXE_MEM2_mul_out),
        .in2(EXE_MEM2_alu_csr),
        .sel(EXE_MEM2_mul_en),
        .mux_out(mul_alu_csr)
    );

    DM_shift dm_shift_unit (
        .mem_addr_L2B(mul_alu_csr[1:0]),
        .BWEB(BWEB),
        .DM_data(EXE_MEM2_rs2_data),
        .DM_data_shift(DM_data_shift),
        .BWEB_shift(BWEB_shift)
    );

    // read_signal_DM
    assign read_signal_DM  = ((EXE_MEM2_opcode == `LOAD || EXE_MEM2_opcode == `FLW) && EXE_MEM2_opcode_LSB == 1'b1) ? 1'b1 : 1'b0;
    // write_signal_DM
    assign write_signal_DM = (EXE_MEM2_opcode == `STORE || EXE_MEM2_opcode == `FSW) ? 1'b1 : 1'b0;

    Master_Read MR_data(
    .ACLK(clk),
    .ARESETn(~rst),

    // READ ADDRESS1
	.ARID(ARID_M1),
	.ARADDR(ARADDR_M1),
	.ARLEN(ARLEN_M1),
	.ARSIZE(ARSIZE_M1),
	.ARBURST(ARBURST_M1),
	.ARVALID(ARVALID_M1),
	.ARREADY(ARREADY_M1),

	// READ DATA1
	.RID(RID_M1),
	.RDATA(RDATA_M1),
	.RRESP(RRESP_M1),
	.RLAST(RLAST_M1),
	.RVALID(RVALID_M1),
	.RREADY(RREADY_M1),

    // CPU signal
    .cpu_read_req(read_signal_DM),
    .cpu_read_id(4'd0),
    .cpu_read_addr(mul_alu_csr),
    .cpu_arlen(4'd0),
    .cpu_arsize(3'b010),
    .cpu_arburst(2'b01),
    .cpu_read_data(ld_data),
    .stall_cpu(axi_stall_DM_read)
    );

    Master_Write MW_data(
        .ACLK(clk),
        .ARESETn(~rst),

        //WRITE ADDRESS
        .AWID(AWID_M1),
        .AWADDR(AWADDR_M1),
        .AWLEN(AWLEN_M1),
        .AWSIZE(AWSIZE_M1),
        .AWBURST(AWBURST_M1),
        .AWVALID(AWVALID_M1),
        .AWREADY(AWREADY_M1),

        //WRITE DATA
        .WDATA(WDATA_M1),
        .WSTRB(WSTRB_M1),
        .WLAST(WLAST_M1),
        .WVALID(WVALID_M1),
        .WREADY(WREADY_M1),

        //WRITE RESPONSE
        .BID(BID_M1),
        .BRESP(BRESP_M1),
        .BVALID(BVALID_M1),
        .BREADY(BREADY_M1),

        //CPU SIGNALS
        .cpu_write_req(write_signal_DM),
        .cpu_write_id(4'd0),
        .cpu_write_addr(mul_alu_csr),
        .cpu_awlen(4'd0),
        .cpu_awsize(3'b010),
        .cpu_awburst(2'b01),
        .stall_cpu(axi_stall_DM_write),
        .BWEB(BWEB_shift),
        .cpu_write_data(DM_data_shift)
    );


    Reg_MEM_WB reg_mem_wb (
        .clk(clk),
        .rst(rst),
        // Input
        .axi_stall(axi_stall),
        .axi_stall_DM_read(axi_stall_DM_read),
        .RVALID_Data(RVALID_M1),
        .opcode(EXE_MEM2_opcode),
        .opcode_LSB(EXE_MEM2_opcode_LSB),
        .funct3(EXE_MEM2_funct3),
        .rd_index(EXE_MEM2_rd_index),
        .ld_data(ld_data),
        .alu_out(mul_alu_csr),
        // Output
        .MEM_WB_opcode(MEM_WB_opcode),
        .MEM_WB_opcode_LSB(MEM_WB_opcode_LSB),
        .MEM_WB_funct3(MEM_WB_funct3),
        .MEM_WB_rd_index(MEM_WB_rd_index),
        .MEM_WB_alu_out(MEM_WB_alu_out),
        .MEM_WB_ld_data(MEM_WB_ld_data)
    );

    LOAD_Unit load_unit (
        .funct3(MEM_WB_funct3),
        .ld_data(MEM_WB_ld_data),
        .ld_data_aligned(ld_data_aligned)
    );

    MUX_2in mux_wb (
        .in1(MEM_WB_alu_out),
        .in2(ld_data_aligned),
        .sel(wb_data_sel),
        .mux_out(wb_data)
    );
endmodule
