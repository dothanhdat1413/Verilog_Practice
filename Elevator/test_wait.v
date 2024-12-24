module test_wait();
    
    reg clk;
    reg wait_en;
    reg wait_rst;
    reg wait_st;
    wire wait_done;
    wire wait_check_input;

    wait_test wait_module(
        .en(1), // enable
        .wait_done(wait_done), // Đợi cửa mở xong
        .wait_check_input(wait_check_input),
        .clk(clk), // Xung clock
        .wait_en(wait_en), // Bật bộ đếm chờ
        .wait_rst(wait_rst),// Reset bộ đếm chờ
        .wait_st(wait_st) // Set bộ đếm chờ là xong
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        wait_en = 0;
        wait_rst = 1;
        wait_st = 0;
        #10;
        wait_rst = 0;
        wait_en = 1; // mình cho đếm là 10 đơn vị thời gian, thời gian check input là sau 8 đơn vị thời gian
        #6 wait_rst = 1; // reset
        #2 wait_rst = 0;
        #17 wait_en = 0; // tắt enable
        #20 $finish;
    end
endmodule