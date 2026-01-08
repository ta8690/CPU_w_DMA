module MUX_2in(
    input [`CPU_DATA_BITS-1:0] in1,//1
    input [`CPU_DATA_BITS-1:0] in2,//0
    input sel,
    output logic [`CPU_DATA_BITS-1:0] mux_out
);

    assign mux_out = (sel)? in1 : in2;

endmodule