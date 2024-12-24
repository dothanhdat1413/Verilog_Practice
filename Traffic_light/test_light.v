`timescale 1ps/1ps
module test_light ();
    reg clk;
    reg rst;
    reg en;
    wire done;
    wire [3:0] num_0;
    wire [3:0] num_1;

    light #(
        .MAX_0(0),
        .MAX_1(2)
    )DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
        .num_0_test(num_0),
        .num_1_test(num_1),
        .done(done)
    );

    always #1 clk = ~clk;

    always @(posedge clk) begin
        $display ("time: %t, count: %d%d, done: %d", $time,num_1, num_0,done);
    end

    initial begin
        clk = 0;
        rst = 1;
        en = 0;
        #10 rst = 0;
        #1 en = 1;
        #40 en = 0;
        #100 $finish;
    end

endmodule