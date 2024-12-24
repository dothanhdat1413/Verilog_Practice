module vending_machine (
    input clear, // tương tự trả lại tiền thừa

    input clk_in,
    input rst_clk,
    input en,

    input [2:0] money,

    input get,

    input goods,

    output reg [17:0] state,

    output [6:0] money_0,
    output [6:0] money_1,
    output [6:0] money_2,
    output [6:0] money_3,
    
    output [6:0] goods_0,
    output [6:0] goods_1,
    
    output [6:0] cash_0,
    output [6:0] cash_1
);  
    wire clk;
    reg mode;

    clock clock_module (
        .clk_in(clk_in),
        .rst(rst_clk),
        .clk_out(clk)
    );

    wire [3:0] money_0_bin;
    wire [3:0] money_1_bin;
    wire [3:0] money_2_bin;
    wire [3:0] money_3_bin;

    reg [3:0] cash_0_bin;
    reg [3:0] cash_1_bin;

    reg [3:0] goods_1_bin;
    reg check;

    money money_module(
        .money(money),
        .goods(goods),
        .en(((en_debounced) & clk)),
        .mode(mode),
        .check(check),
        .clear((~clear)),
        .money_0(money_0_bin),
        .money_1(money_1_bin),
        .money_2(money_2_bin),
        .money_3(money_3_bin)
    );

    always @(*)begin: change_mode
        if(get) begin
            mode = 1;
        end
        else begin
            mode = 0;
        end
    end

    always @(*)begin : check_state
        if((money_3_bin+money_2_bin)||(money_1_bin >= 2)||((money_1_bin*10+money_0_bin)>=(goods_1_bin*10))) begin
            state = 18'b000000000111111111;
            check = 1;
        end
        else begin
            state = 18'b111111111000000000;
            check = 0;
        end
    end

    wire en_s, en_r;
    assign en_s = ~ en;
    assign en_r =   en;
    wire en_debounced = en_s | ((~en_r) & en_debounced); 



//___________________________________Display___________________________________
    always @(goods) begin
        case(goods) 
            1'b0: begin
                goods_1_bin = 1;
            end
            1'b1: begin
                goods_1_bin = 2;
            end
        endcase
    end 

    always @(money) begin
        case(money)
            3'b000: begin
                cash_0_bin = 5;
                cash_1_bin = 0;
            end
            3'b001: begin
                cash_0_bin = 0;
                cash_1_bin = 1;
            end
            3'b010: begin
                cash_0_bin = 5;
                cash_1_bin = 1;
            end
            3'b011: begin
                cash_0_bin = 0;
                cash_1_bin = 2;
            end
            3'b100: begin
                cash_0_bin = 0;
                cash_1_bin = 5;
            end
            default: begin
                cash_0_bin = 15;
                cash_1_bin = 15;
            end
        endcase
    end

    seven_seg_decoder money_0_seg(
        .bin_num(money_0_bin),
        .seg_num(money_0)
    );
    seven_seg_decoder money_1_seg(
        .bin_num(money_1_bin),
        .seg_num(money_1)
    );
    seven_seg_decoder money_2_seg(
        .bin_num(money_2_bin),
        .seg_num(money_2)
    );
    seven_seg_decoder money_3_seg(
        .bin_num(money_3_bin),
        .seg_num(money_3)
    );

    seven_seg_decoder goods_0_seg(
        .bin_num(4'b0000),
        .seg_num(goods_0)
    );

    seven_seg_decoder goods_1_seg(
        .bin_num(goods_1_bin),
        .seg_num(goods_1)
    );

    seven_seg_decoder cash_0_seg(
        .bin_num(cash_0_bin),
        .seg_num(cash_0)
    );

    seven_seg_decoder cash_1_seg(
        .bin_num(cash_1_bin),
        .seg_num(cash_1)
    );

endmodule