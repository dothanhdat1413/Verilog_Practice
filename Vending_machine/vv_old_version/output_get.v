module output_get (
    input goods,
    input get,
    input clear,
    output [3:0] money_0,
    output [3:0] money_1,
    output [3:0] money_2,
    output [3:0] money_3

    // output wire b_out_0,
    // output wire b_out_1,
    // output wire b_out_2,
    // output wire b_out_3
    );

    reg b_out_0;
    reg b_out_1;
    reg b_out_2;

    reg [3:0] money_0_subtract;
    reg [3:0] money_1_subtract;
    reg [3:0] money_2_subtract;
    reg [3:0] money_3_subtract;

    subtract subtract_0(
        .num_1(money_0_subtract),
        .b_in(0),
        .en(put_money),
        .clear(clear),
        .result(money_0)
    );

    subtract subtract_1(
        .num_1(money_1_subtract),
        .b_in(b_out_0),
        .en(put_money),
        .clear(clear),
        .result(money_1)
    );

    subtract subtract_2(
        .num_1(money_2_subtract),
        .b_in(b_out_1),
        .en(put_money),
        .clear(clear),
        .result(money_2)
    );

    subtract subtract_3(
        .num_1(money_3_subtract),
        .b_in(b_out_2),
        .en(put_money),
        .clear(clear),
        .result(money_3)
    );

    always @(posedge get) begin
        case(goods)
            1'b0: begin
                money_0_subtract <= 0;
                money_1_subtract <= 1;
                money_2_subtract <= 0;
                money_3_subtract <= 0;

                if()
            end
            1'b1: begin
                money_0_subtract <= 0;
                money_1_subtract <= 2;
                money_2_subtract <= 0;
                money_3_subtract <= 0;
            end
        endcase
    end
endmodule