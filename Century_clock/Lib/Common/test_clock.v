`timescale 10ns/10ns
module test_clock();

    reg clk_in;
    reg rst;
    wire clk_out;

    clock test(
        .clk_in(clk_in),
        .rst(rst),
        .clk_out(clk_out)
    );

    always #2 clk_in = ~ clk_in;

    integer count_0 = 0;
    integer count_1 = 0;

    initial begin
        $display ("Start test");    
        clk_in = 0;
        rst = 1;
        #2 rst = 0;
        #1000000000 $finish;
    end

    always @(clk_in) begin
        count_0 <= count_0 + 1;
        if(count_0 == 49999999) begin
            count_0 <= 0;
            $display("50 000 000");
        end
    end

    always @(clk_out) begin
        count_1 <= count_1 + 1;
        if(count_1 == 1) begin
            count_1 <= 0;
            $display("1hz");
        end
    end

endmodule