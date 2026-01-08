module CSR (
    input clk,
    input rst,
    input [6:0] imm_ext_L7B,
    input [31:0] ID_EXE_pc,
    input stall,
    input axi_stall,
    output logic [31:0] csr_o
);
    localparam RDINSTRETH = 7'b1000_001, RDINSTRET = 7'b0000_001, RDCYCLEH = 7'b1000_000, RDCYCLE = 7'b0000_000;

    logic [63:0] cycle, instret;
    logic cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) cycle <= 64'b0;
        else cycle <= cycle + 64'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instret <= 64'b0;
            cnt <= 1'b0;
        end 
        else begin
            cnt <= 1'b1;
            if (cnt == 1'b0) instret <= 64'd1;
            else if (!stall && ID_EXE_pc != 32'b0 & !axi_stall) instret <= instret + 64'd1;
        end
    end

    always @(*) begin
        case (imm_ext_L7B)
            RDINSTRETH: csr_o = instret[63:32];
            RDINSTRET:  csr_o = instret[31:0];
            RDCYCLEH:   csr_o = cycle[63:32];
            default:    csr_o = cycle[31:0];  //RDCYCLE
        endcase
    end
endmodule
