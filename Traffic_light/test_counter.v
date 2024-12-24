module test_counter ();
    reg clk;
    reg rst;
    reg en;
    wire [3:0] bin_num;

    counter #(
        .MAX(9),
        .MIN(0),
        .MODE(1)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
        .bin_num(bin_num)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        en = 0;
        #10 rst = 0;
        #10 en = 1;
        #100 $finish;
    end

    always @(posedge clk) begin
        $display ("time: %t, bin_num: %d", $time, bin_num);
    end

endmodule