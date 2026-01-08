module ROM_wrapper (
    input ACLK,
	input ARESETn,
    // Slave
    // READ ADDRESS
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output logic ARREADY,
	// READ DATA
	output logic [`AXI_IDS_BITS-1:0] RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0] RRESP,
	output logic RLAST,
	output logic RVALID,
	input RREADY,
    input [31:0] ROM_out,
    output logic ROM_read,
    output logic ROM_enable,
    output logic [11:0] ROM_address
);

    logic [31:0] addr_from_slave;

    assign ROM_address = addr_from_slave[13:2];

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) begin
            ROM_enable <= 1'b0;
            ROM_read <= 1'b0;
        end
        else begin
            ROM_enable <= 1'b1;
            ROM_read <= 1'b1;
        end
    end

    Slave_Read SR_ROM(
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        // READ ADDRES
        .ARID(ARID),
        .ARADDR(ARADDR),
        .ARLEN(ARLEN),
        .ARSIZE(ARSIZE),
        .ARBURST(ARBURST),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        // READ DATA
        .RID(RID),
        .RDATA(RDATA),
        .RRESP(RRESP),
        .RLAST(RLAST),
        .RVALID(RVALID),
        .RREADY(RREADY),
        .addr_to_slave(addr_from_slave),
        .data_from_slave(ROM_out),
        .slave_enable(1'b1)
    );

endmodule