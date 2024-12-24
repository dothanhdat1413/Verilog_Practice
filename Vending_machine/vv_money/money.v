module money (
    input [2:0] money,
    input goods,

    input en,

    input mode, 
    input check,
    
    input clear,
    output [3:0] money_0,
    output [3:0] money_1,
    output [3:0] money_2,
    output [3:0] money_3
    );

    reg c_out_0;
    reg c_out_1;
    reg c_out_2;

    reg [3:0] money_0_cal;
    reg [3:0] money_1_cal;
    reg [3:0] money_2_cal;
    reg [3:0] money_3_cal;

    calculate cal_0(
        .num_1(money_0_cal),
        .c_in(0),
        .mode(mode),
        .en(en),
        .clear(clear),
        .sum(money_0)
    );

    calculate cal_1(
        .num_1(money_1_cal),
        .c_in(c_out_0),
        .mode(mode),
        .en(en),
        .clear(clear),
        .sum(money_1)
    );

    calculate cal_2(
        .num_1(money_2_cal),
        .c_in(c_out_1),
        .mode(mode),
        .en(en),
        .clear(clear),
        .sum(money_2)
    );

    calculate cal_3(
        .num_1(money_3_cal),
        .c_in(c_out_2),
        .mode(mode),
        .en(en),
        .clear(clear),
        .sum(money_3)
    );

    always @(*) begin
        case (mode)
            1'b0: begin: ADD
                case(money)
                    3'b000: begin: money_5
                        if(money_0 == 5) begin
                            if(money_1 == 9) begin
                                if(money_2 == 9) begin
                                    c_out_0 = 1;
                                    c_out_1 = 1;
                                    c_out_2 = 1;
                                end else begin
                                    c_out_0 = 1;
                                    c_out_1 = 1;
                                    c_out_2 = 0;
                                end
                            end else begin
                                c_out_0 = 1;
                                c_out_1 = 0;
                                c_out_2 = 0;
                            end
                        end else begin
                        c_out_0 = 0;
                        c_out_1 = 0;
                        c_out_2 = 0;
                        end
                        money_0_cal = 5;
                        money_1_cal = 0;
                        money_2_cal = 0;
                        money_3_cal = 0;
                    end
                    3'b001: begin: money_10
                        money_0_cal = 0;
                        money_1_cal = 1;
                        money_2_cal = 0;
                        money_3_cal = 0;
                        if(money_1 == 9) begin
                            if(money_2 == 9) begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 1;
                            end
                            else begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 0;
                            end
                        end else begin
                            c_out_0 = 0;
                            c_out_1 = 0;
                            c_out_2 = 0;
                        end

                    end
                    3'b010: begin: money_15
                        money_0_cal = 5;
                        money_1_cal = 1;
                        money_2_cal = 0;
                        money_3_cal = 0;
                        if(money_0 == 5) begin
                            if(money_1 >= 8 ) begin
                                if(money_2 == 9) begin
                                    c_out_0 = 1;
                                    c_out_1 = 1;
                                    c_out_2 = 1;
                                end else begin
                                    c_out_0 = 1;
                                    c_out_1 = 1;
                                    c_out_2 = 0;
                                end
                            end else begin
                                c_out_0 = 1;
                                c_out_1 = 0;
                                c_out_2 = 0;
                            end 
                        end
                        else begin : last_0
                            if(money_1 == 9 ) begin
                                if(money_2 == 9) begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 1;
                                end else begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 0;
                                end
                            end else begin
                                c_out_0 = 0;
                                c_out_1 = 0;
                                c_out_2 = 0;
                            end
                        end
                    end
                    3'b011: begin: money_20
                        money_0_cal = 0;
                        money_1_cal = 2;
                        money_2_cal = 0;
                        money_3_cal = 0;
                        if(money_1 >= 8) begin
                            if(money_2 == 9) begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 1;
                            end else begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 0;
                            end 
                        end
                        else begin
                            c_out_0 = 0;
                            c_out_1 = 0;
                            c_out_2 = 0;
                        end
                    end
                    3'b100: begin: money_50
                        money_0_cal = 0;
                        money_1_cal = 5;
                        money_2_cal = 0;
                        money_3_cal = 0;
                        if(money_1 >= 5) begin
                            if(money_2 == 9) begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 1;
                            end else begin
                                c_out_0 = 0;
                                c_out_1 = 1;
                                c_out_2 = 0;
                            end
                        end else begin
                            c_out_0 = 0;
                            c_out_1 = 0;
                            c_out_2 = 0;
                        end
                    end
                    default: begin 
                        money_0_cal = 0;
                        money_1_cal = 0;
                        money_2_cal = 0;
                        money_3_cal = 0;
                        c_out_0 = 0;
                        c_out_1 = 0;
                        c_out_2 = 0;
                    end
                endcase
            end
            1'b1: begin: SUBTRACT
                if(check) begin
                    case(goods)
                        1'b0: begin
                            money_0_cal = 0;
                            money_1_cal = 1;
                            money_2_cal = 0;
                            money_3_cal = 0; 
                            if((money_1 == 4'b0000)) begin
                                if(money_2 != 4'b0000) begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 0;
                                end else begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 1;
                                end
                            end else begin
                                c_out_0 = 0;
                                c_out_1 = 0;
                                c_out_2 = 0;
                            end
                        end
                        1'b1: begin
                            money_0_cal = 0;
                            money_1_cal = 2;
                            money_2_cal = 0;
                            money_3_cal = 0;
                            if(money_1 == 4'b0000) begin
                                if(money_2 != 4'b0000) begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 0;
                                end else begin
                                    c_out_0 = 0;
                                    c_out_1 = 1;
                                    c_out_2 = 1;
                                end
                            end else begin
                                c_out_0 = 0;
                                c_out_1 = 0;
                                c_out_2 = 0;
                            end
                        end
                    endcase
                end else begin
                    money_0_cal = 0;
                    money_1_cal = 0;
                    money_2_cal = 0;
                    money_3_cal = 0;
                    c_out_0 = 0;
                    c_out_1 = 0;
                    c_out_2 = 0;
                end
            end
        endcase
    end
endmodule