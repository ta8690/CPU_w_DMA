module MUL (
    input [4:0] opcode,
    input [2:0] funct3,
    input funct7_mul,
    input [31:0] operand1,
    input [31:0] operand2,
    output logic [31:0] mul_out
);

    logic [63:0] temp;
    logic [63:0] op1, op2;
    always @(*) begin
        if (opcode == `R_type && funct7_mul) begin
            case (funct3)
                3'b000, 3'b011: begin
                    op1 = {32'b0, operand1[31:0]};
                    op2 = {32'b0, operand2[31:0]};
                end
                3'b010: begin
                    op1 = {{32{operand1[31]}}, operand1[31:0]};
                    op2 = {32'b0, operand2[31:0]};
                end
                3'b001: begin
                    op1 = {{32{operand1[31]}}, operand1[31:0]};
                    op2 = {{32{operand2[31]}}, operand2[31:0]};
                end
                default: begin
                    op1 = 64'b0;
                    op2 = 64'b0;
                end
            endcase
        end else begin
            op1 = 64'b0;
            op2 = 64'b0;
        end
    end

    assign temp = op1 * op2;

    always @(*) begin
        case (funct3)
            3'b000:  mul_out = temp[31:0];
            default: mul_out = temp[63:32];
        endcase
    end

endmodule
