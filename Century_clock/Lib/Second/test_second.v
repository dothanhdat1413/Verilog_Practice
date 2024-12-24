`timescale 1ps/1ps
module test_second();

    reg clk;
    reg rst;
    reg en;

    wire [3:0] bin_num [1:0];

    second test_second(
        .clk(clk),
        .rst(rst),
        .en(en),
        .second_0(bin_num[0]),
        .second_1(bin_num[1])
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