module Branch_Predictor(
    input clk,
    input rst
);

    localparam Taken1 = 2'd0, Taken2 = 2'd1, Not_Taken1 = 2'd2, Not_Taken2 = 2'd3;

    logic [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if(rst) state <= 2'd0;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            Taken1
        endcase
    end
endmodule