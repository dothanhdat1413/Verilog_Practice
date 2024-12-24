module second (
    input clk,
    input rst,
    input en,
    output [3:0] second_0,
    output [3:0] second_1,
    output ss_to_min_en
    );

    counter #(.MAX(9),.MIN(0)) num_0(
        .clk(clk),
        .rst(ss_to_min_en),
        .en(en),
        .bin_num(second_0)
    );

    counter #(.MAX(5),.MIN(0)) num_1(
        .clk(clk),
        .rst(ss_to_min_en),
        .en((second_0 == 9) && en),
        .bin_num(second_1)
    );

    wire reset_second = ((second_0 == 9) && (second_1 == 5)) || rst;
    assign ss_to_min_en = reset_second & en;

endmodule
