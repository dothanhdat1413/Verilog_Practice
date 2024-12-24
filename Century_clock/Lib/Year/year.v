module year (
    input clk,
    input rst,
    input en,
    output [3:0] year_0,
    output [3:0] year_1,
    output [3:0] year_2,
    output [3:0] year_3
    );

    counter #(.MAX(9), .MIN(0)) num_0(
        .clk(clk),
        .rst(rst),
        .en(en),
        .bin_num(year_0)
    );

    counter #(.MAX(9), .MIN(0)) num_1(
        .clk(clk),
        .rst(rst),
        .en((year_0 == 9) && en),
        .bin_num(year_1)
    );

    counter #(.MAX(9), .MIN(0)) num_2(
        .clk(clk),
        .rst(rst),
        .en((year_0 == 9) && (year_1 == 9) && en),
        .bin_num(year_2)
    );

    counter #(.MAX(9), .MIN(0)) num_3(
        .clk(clk),
        .rst(rst),
        .en((year_0 == 9) && (year_1 == 9) && (year_2 == 9) && en),
        .bin_num(year_3)
    );

endmodule
