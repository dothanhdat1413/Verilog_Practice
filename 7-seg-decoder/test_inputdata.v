`timescale 1ps/1ps
module test_7_seg_decoder;
    reg [3:0] bin_num;    
    wire [6:0] seg_num;

    integer i;

    7_seg_decoder DUT(
        .seg_num(seg_num),
        .bin_num(bin_num),
    );

    initial begin
        bin_num = 4'b1111;
    end

    

endmodule