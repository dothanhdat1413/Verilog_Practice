module minute (
    input clk,
    input rst,
    input en,
    output [3:0] minute_0,
    output [3:0] minute_1,
    output min_to_hh_en
    );

    counter #(.MAX(9), .MIN(0)) num_0(
        .clk(clk),
        .rst(min_to_hh_en),
        .en(en),
        .bin_num(minute_0)
    );

    counter #(.MAX(5), .MIN(0)) num_1(
        .clk(clk),
        .rst(min_to_hh_en),
        .en((minute_0 == 9) && en),
        .bin_num(minute_1)
    );

    wire reset_minute = ((minute_0 == 9) && (minute_1 == 5)) || rst;
    assign min_to_hh_en = reset_minute & en;

endmodule
