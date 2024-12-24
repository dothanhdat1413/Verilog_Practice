module day (
    input clk,
    input rst,
    input en,

    input [3:0] month_0,
    input [3:0] month_1,
    input [3:0] year_0,
    input [3:0] year_1,
    input [3:0] year_2,
    input [3:0] year_3,

    output [3:0] day_0,
    output [3:0] day_1,
    output dd_to_mm_en, 
    output leap,
    output leap_0_0,// năm nhuận xxab với a là chẵn, b là 4 hoặc 8 và ab khác 00
    output leap_0_1,// năm nhuận xxab với ab = 00 và xx chia hết 4
    output leap_0_1_var,
    output leap_1// năm nhuận xxab với a là lẻ, b là 2 hoặc 6
    );

    counter #(.MAX(9), .MIN(1)) num_0(
        .clk(clk),
        .rst(dd_to_mm_en), // đây là trường hợp đặc biệt cần được reset về 1
        .en(en),
        .bin_num(day_0)
    );

    counter #(.MAX(3), .MIN(0)) num_1(
        .clk(clk),
        .rst(dd_to_mm_en),
        .en((day_0 == 9) && en),
        .bin_num(day_1)
    );

    wire reset_day;

    reset_day reset_day_module(
        .day_0(day_0),
        .day_1(day_1),
        .month_0(month_0),
        .month_1(month_1),
        .year_0(year_0),
        .year_1(year_1),
        .year_2(year_2),
        .year_3(year_3),
        .rst(rst),
        .reset_day(reset_day),
        .leap(leap),
        .leap_0_0(leap_0_0),
        .leap_0_1(leap_0_1),
        .leap_0_1_var(leap_0_1_var),
        .leap_1(leap_1)
    );

    assign dd_to_mm_en = reset_day & en;

endmodule