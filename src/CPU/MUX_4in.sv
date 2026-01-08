module MUX_4in (
    input [`CPU_DATA_BITS-1:0] in1,  //0
    input [`CPU_DATA_BITS-1:0] in2,  //1
    input [`CPU_DATA_BITS-1:0] in3,  //2
    input [`CPU_DATA_BITS-1:0] in4,  //3
    input [1:0] sel,
    output logic [`CPU_DATA_BITS-1:0] mux_out
);

    always @(*) begin
        case (sel)
            2'd0: mux_out = in1;
            2'd1: mux_out = in2;
            2'd2: mux_out = in3;
            default mux_out = in4;
        endcase
    end

endmodule