module hour (
    input clk,
    input rst,
    input en,
    output [3:0] hour_0,
    output [3:0] hour_1,
    output hh_to_dd_en
    );

    counter #(.MAX(9), .MIN(0)) num_0(
        .clk(clk),
        .rst(hh_to_dd_en),
        .en(en),
        .bin_num(hour_0)
    );

    counter #(.MAX(2), .MIN(0)) num_1(
        .clk(clk),
        .rst(hh_to_dd_en),
        .en((hour_0 == 9) && en),
        .bin_num(hour_1)
    );

    wire reset_hour = ((hour_0 == 3) && (hour_1 == 2)) || rst;
    assign hh_to_dd_en = reset_hour & en;

endmodule
