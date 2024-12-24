`timescale 1ps/1ps
module test_cus_counter();
    reg clk;
    reg rst;
    reg en;
    reg mode;
    wire [4:0] num;
    
    cus_counter DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
        .mode(mode),
        .num(num)
    );

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    en = 0;
    mode = 0;
    #10 rst = 0;
    en = 1;
    mode = 1;
    #20;
    mode = 0;
    #100 $finish;
end

always @(*) begin
    $display("%t num = %b",$time, num);
end
always @(mode) begin
    $display("%t mode = %b",$time, mode);
end

endmodule