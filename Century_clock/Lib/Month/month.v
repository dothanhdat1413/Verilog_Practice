module month (
    input clk,
    input rst,
    input en,
    output [3:0] month_0,
    output [3:0] month_1,
    output mon_to_yy_en
    );

    counter #(.MAX(9), .MIN(1)) num_0(
        .clk(clk),
        .rst(mon_to_yy_en), // đây là trường hợp đặc biệt cần reset về 1
        .en(en),
        .bin_num(month_0)
    );

    counter #(.MAX(1), .MIN(0)) num_1(
        .clk(clk),
        .rst(mon_to_yy_en),
        .en((month_0 == 9) && en),
        .bin_num(month_1)
    );

    wire reset_month = ((month_0 == 2) && (month_1 == 1)) || rst;
    assign mon_to_yy_en = reset_month & en;

endmodule
