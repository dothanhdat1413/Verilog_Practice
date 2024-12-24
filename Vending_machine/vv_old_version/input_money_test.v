`timescale 1ps/1ps
module test_input_money();
    reg [2:0] money;
    reg put_money;
    wire [3:0] money_0;
    wire [3:0] money_1;
    wire [3:0] money_2;
    wire [3:0] money_3;
    wire c_out_0;
    wire c_out_1;
    wire c_out_2;

    reg clear;

    input_money DUT(
        .money(money),
        .put_money(put_money),
        .clear(clear),
        .money_0(money_0),
        .money_1(money_1),
        .money_2(money_2),
        .money_3(money_3),
        .c_out_0(c_out_0),
        .c_out_1(c_out_1),
        .c_out_2(c_out_2)
    );

integer  i;

    always #5 put_money = ~ put_money;

    initial begin
        clear = 1;
        put_money = 0;
        money = 3'b000;
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