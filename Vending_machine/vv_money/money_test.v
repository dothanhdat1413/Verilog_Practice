`timescale 1ps/1ps
module test_money();
    reg [2:0] money;
    reg goods;
    reg en;
    reg mode;
    reg check;
    reg clear;
    wire [3:0] money_0_bin;
    wire [3:0] money_1_bin;
    wire [3:0] money_2_bin;
    wire [3:0] money_3_bin;
    

    money money_module(
        .money(money),
        .goods(goods),
        .en(en),
        .mode(mode),
        .check(check),
        .clear(clear),
        .money_0(money_0_bin),
        .money_1(money_1_bin),
        .money_2(money_2_bin),
        .money_3(money_3_bin)
    );

    integer  i;

    always #5 en = ~ en;

    initial begin
        clear = 1;
        en = 0;
        money = 3'b000;
        mode = 1'b0;
        #11
        clear = 0;
        money = 3'b000;
        #10
        money = 3'b000;
        #10
        money = 3'b000;
        // #10
        // money = 3'b000;
        for (i=0;i<201;i=i+1) begin
            money = 3'b001;//5
            #10;
        end
        $finish;
    end

    always @(posedge put_money) begin
        #2
        $display("%t Money = %d%d%d%d, add: %d",$time, money_3,money_2,money_1,money_0, money);
        // if((money_3*1000 + money_2*100 + money_1*10 + money_0)% 5) begin
        // $display("%t ERROR", $time);
        // end
    end
endmodule