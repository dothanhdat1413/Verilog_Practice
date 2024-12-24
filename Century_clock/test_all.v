`timescale 1ps/1ps
module test_all();

    reg clk;
    reg rst;
    reg en;

    wire [6:0] bin_num [1:0];

    century_clock clock(
        .clk(clk),
        .rst(rst),
        .en(en),
        .output_second_0(bin_num[0]),
        .output_second_1(bin_num[1])
    );


    always #1 clk = ~ clk;

    initial begin
        clk <= 0;
        rst <= 1;
        en <= 1;
        #2;
        rst <= 0;
        #2;
        $display("Num = %b, %b",bin_num[1], bin_num[0]);
        #2;
        $display("Num = %b, %b",bin_num[1], bin_num[0]);
        #2;
        $display("Num = %b, %b",bin_num[1], bin_num[0]);
        #2;
        $display("Num = %b, %b",bin_num[1], bin_num[0]);

    end

    
endmodule