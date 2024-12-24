module input_money (
    input [2:0] money,
    input put_money,
    input mode, 
    
    input clear,
    output [3:0] money_0,
    output [3:0] money_1,
    output [3:0] money_2,
    output [3:0] money_3
    );

    reg c_out_0;
    reg c_out_1;
    reg c_out_2;

    reg [3:0] money_0_add;
    reg [3:0] money_1_add;
    reg [3:0] money_2_add;
    reg [3:0] money_3_add;

    add add_0(
        .num_1(money_0_add),
        .c_in(0),
        .en(put_money),
        .clear(clear),
        .sum(money_0)
    );

    add add_1(
        .num_1(money_1_add),
        .c_in(c_out_0),
        .en(put_money),
        .clear(clear),
        .sum(money_1)
    );

    add add_2(
        .num_1(money_2_add),
        .c_in(c_out_1),
        .en(put_money),
        .clear(clear),
        .sum(money_2)
    );

    add add_3(
        .num_1(money_3_add),
        .c_in(c_out_2),
        .en(put_money),
        .clear(clear),
        .sum(money_3)
    );

    always @( put_money, money ) begin
        case(money)
            3'b000: begin: money_5
                if(money_0 == 5) begin
                    if(money_1 == 9) begin
                        if(money_2 == 9) begin
                            c_out_0 <= 1;
                            c_out_1 <= 1;
                            c_out_2 <= 1;
                        end else begin
                            c_out_0 <= 1;
                            c_out_1 <= 1;
                            c_out_2 <= 0;
                        end
                    end else begin
                        c_out_0 <= 1;
                        c_out_1 <= 0;
                        c_out_2 <= 0;
                    end
                end else begin
                c_out_0 <= 0;
                c_out_1 <= 0;
                c_out_2 <= 0;
                end
                money_0_add <= 5;
                money_1_add <= 0;
                money_2_add <= 0;
                money_3_add <= 0;
            end
            3'b001: begin: money_10
                money_0_add <= 0;
                money_1_add <= 1;
                money_2_add <= 0;
                money_3_add <= 0;
                if(money_1 == 9) begin
                    if(money_2 == 9) begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 1;
                    end
                    else begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 0;
                    end
                end else begin
                    c_out_0 <= 0;
                    c_out_1 <= 0;
                    c_out_2 <= 0;
                end

            end
            3'b010: begin: money_15
                money_0_add <= 5;
                money_1_add <= 1;
                money_2_add <= 0;
                money_3_add <= 0;
                if(money_0 == 5) begin
                    if(money_1 >= 8 ) begin
                        if(money_2 == 9) begin
                            c_out_0 <= 1;
                            c_out_1 <= 1;
                            c_out_2 <= 1;
                        end else begin
                            c_out_0 <= 1;
                            c_out_1 <= 1;
                            c_out_2 <= 0;
                        end
                    end else begin
                        c_out_0 <= 1;
                        c_out_1 <= 0;
                        c_out_2 <= 0;
                    end 
                end
                else begin : last_0
                    if(money_1 == 9 ) begin
                        if(money_2 == 9) begin
                            c_out_0 <= 0;
                            c_out_1 <= 1;
                            c_out_2 <= 1;
                        end else begin
                            c_out_0 <= 0;
                            c_out_1 <= 1;
                            c_out_2 <= 0;
                        end
                    end else begin
                        c_out_0 <= 0;
                        c_out_1 <= 0;
                        c_out_2 <= 0;
                    end
                end
            end
            3'b011: begin: money_20
                money_0_add <= 0;
                money_1_add <= 2;
                money_2_add <= 0;
                money_3_add <= 0;
                if(money_1 >= 8) begin
                    if(money_2 == 9) begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 1;
                    end else begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 0;
                    end 
                end
                else begin
                    c_out_0 <= 0;
                    c_out_1 <= 0;
                    c_out_2 <= 0;
                end
            end
            3'b100: begin: money_50
                money_0_add <= 0;
                money_1_add <= 5;
                money_2_add <= 0;
                money_3_add <= 0;
                if(money_1 >= 5) begin
                    if(money_2 == 9) begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 1;
                    end else begin
                        c_out_0 <= 0;
                        c_out_1 <= 1;
                        c_out_2 <= 0;
                    end
                end else begin
                    c_out_0 <= 0;
                    c_out_1 <= 0;
                    c_out_2 <= 0;
                end
            end
            default: begin 
                money_0_add <= 0;
                money_1_add <= 0;
                money_2_add <= 0;
                money_3_add <= 0;
                c_out_0 <= 0;
                c_out_1 <= 0;
                c_out_2 <= 0;
            end
        endcase
    end
endmodule