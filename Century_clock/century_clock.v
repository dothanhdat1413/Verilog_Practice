module century_clock ( // test giờ phút giây
    input clk_in,
    input rst, 
    input rst_clk,
    input en,
    input display_mode,
    input run_mode,

    input manual_ss_yy_en,
    input manual_min_mon_en,
    input manual_hh_dd_en,

    output clk,
    output leap,
    output leap_0_0,// năm nhuận xxab với a là chẵn, b là 4 hoặc 8 và ab khác 00
    output leap_0_1,// năm nhuận xxab với ab = 00 và xx chia hết 4
    output leap_0_1_var,
    output leap_1,// năm nhuận xxab với a là lẻ, b là 2 hoặc 6
    
    output [6:0] output_yy_0,
    output [6:0] output_yy_1,
    output [6:0] output_ss_yy_2,
    output [6:0] output_ss_yy_3,
    output [6:0] output_min_mon_0,
    output [6:0] output_min_mon_1,
    output [6:0] output_hour_day_0,
    output [6:0] output_hour_day_1
);  

    clock clock_module (
        .clk_in(clk_in),
        .rst(rst_clk),
        .clk_out(clk)
    );


    wire [3:0] second_bin [1:0];
    wire [3:0] minute_bin [1:0];
    wire [3:0] hour_bin [1:0];
    wire [3:0] day_bin [1:0];
    wire [3:0] month_bin [1:0];
    wire [3:0] year_bin [3:0];

    reg [3:0] output_yy[1:0];
    reg [3:0] output_ss_yy[1:0];
    reg [3:0] output_min_mon[1:0];
    reg [3:0] output_hour_day[1:0];
    
    wire ss_to_min_en;
    wire min_to_hh_en;
    wire hh_to_dd_en;
    wire dd_to_mm_en;
    wire mm_to_yy_en;

    reg second_en;
    reg minute_en;
    reg hour_en;
    reg day_en;
    reg month_en;
    reg year_en;

//  _______________________Init & connect module_____________________________

    second second_module (
        .clk(clk),
        .rst(rst),
        .en(second_en),
        .second_0(second_bin[0]),
        .second_1(second_bin[1]),
        .ss_to_min_en(ss_to_min_en)
    );

    minute minute_module (
        .clk(clk),
        .rst(rst),
        .en(minute_en),
        .minute_0(minute_bin[0]),
        .minute_1(minute_bin[1]),
        .min_to_hh_en(min_to_hh_en)
    );

    hour hour_module (
        .clk(clk),
        .rst(rst),
        .en(hour_en),
        .hour_0(hour_bin[0]),
        .hour_1(hour_bin[1]),
        .hh_to_dd_en(hh_to_dd_en)
    );

    day day_module (
        .clk(clk),
        .rst(rst),
        .en(day_en),
        .month_0(month_bin[0]),
        .month_1(month_bin[1]),
        .year_0(year_bin[0]),
        .year_1(year_bin[1]),
        .year_2(year_bin[2]),
        .year_3(year_bin[3]),
        .day_0(day_bin[0]),
        .day_1(day_bin[1]),
        .dd_to_mm_en(dd_to_mm_en),
        .leap(leap),
        .leap_0_0(leap_0_0),// năm nhuận xxab với a là chẵn, b là 4 hoặc 8 và ab khác 00
        .leap_0_1(leap_0_1),// năm nhuận xxab với ab = 00 và xx chia hết 4
        .leap_0_1_var(leap_0_1_var),
        .leap_1(leap_1)// năm nhuận xxab với a là lẻ, b là 2 hoặc 6
    );

    month month_module (
        .clk(clk),
        .rst(rst),
        .en(month_en),
        .month_0(month_bin[0]),
        .month_1(month_bin[1]),
        .mon_to_yy_en(mm_to_yy_en)
    );

    year year_module (
        .clk(clk),
        .rst(rst),
        .en(year_en),
        .year_0(year_bin[0]),
        .year_1(year_bin[1]),
        .year_2(year_bin[2]),
        .year_3(year_bin[3])
    );

// ______________________________Run mode____________________________________

    always @(run_mode) begin : Choose_run_mode
        case (en) 
            0: begin
                second_en = 1'b0;
                minute_en = 1'b0;
                hour_en = 1'b0;
                day_en = 1'b0;
                month_en = 1'b0;
                year_en = 1'b0;
            end

            1: begin
                case (run_mode)
                    0: begin : Normal_mode
                        second_en = 1'b1;
                        minute_en = ss_to_min_en;
                        hour_en = min_to_hh_en;
                        day_en = hh_to_dd_en;
                        month_en = dd_to_mm_en;
                        year_en = mm_to_yy_en;
                    end
                    1: begin : Manual_mode
                        case (display_mode)
                            0:  begin
                                second_en = manual_ss_yy_en;
                                minute_en = manual_min_mon_en;
                                hour_en = manual_hh_dd_en;
                                day_en = 1'b0;
                                month_en = 1'b0;
                                year_en = 1'b0;
                            end
                            1:  begin
                                second_en = 1'b0;
                                minute_en = 1'b0;
                                hour_en = 1'b0;
                                day_en = manual_hh_dd_en;
                                month_en = manual_min_mon_en;
                                year_en = manual_ss_yy_en;
                            end
                        endcase
                    end
                endcase
            end
        endcase
        
    end

// ______________________________Display_____________________________________

    always @(display_mode) begin : Choose_display_mode
        case (display_mode) 
            0: begin : Hour_Minute_Second
                output_yy[0] = 4'b1111; // turn off led
                output_yy[1] = 4'b1111; // turn off led

                output_ss_yy[0] = second_bin [0];
                output_ss_yy[1] = second_bin [1];

                output_min_mon[0] = minute_bin [0];
                output_min_mon[1] = minute_bin [1];

                output_hour_day[0] = hour_bin[0];
                output_hour_day[1] = hour_bin[1];
            end
            1: begin : Day_Month_Year
                output_yy[0] = year_bin[0];
                output_yy[1] = year_bin[1];

                output_ss_yy[0] = year_bin[2]; 
                output_ss_yy[1] = year_bin[3]; 

                output_min_mon[0] = month_bin[0];
                output_min_mon[1] = month_bin[1];

                output_hour_day[0] = day_bin[0];
                output_hour_day[1] = day_bin[1];
            end
        endcase
    end
    
    seven_seg_decoder year_0_seg (
        .bin_num(output_yy[0]),
        .seg_num(output_yy_0)
    );

    seven_seg_decoder year_1_seg (
        .bin_num(output_yy[1]),
        .seg_num(output_yy_1)
    );

    seven_seg_decoder second_year_2_seg (
        .bin_num(output_ss_yy[0]),
        .seg_num(output_ss_yy_2)
    );

    seven_seg_decoder second_year_3_seg (
        .bin_num(output_ss_yy[1]),
        .seg_num(output_ss_yy_3)
    );
    
    seven_seg_decoder minute_month_0_seg (
        .bin_num(output_min_mon[0]),
        .seg_num(output_min_mon_0)
    );

    seven_seg_decoder minute_month_1_seg (
        .bin_num(output_min_mon[1]),
        .seg_num(output_min_mon_1)
    );

    seven_seg_decoder hour_day_0_seg (
        .bin_num(output_hour_day[0]),
        .seg_num(output_hour_day_0)
    );

    seven_seg_decoder hour_day_1_seg (
        .bin_num(output_hour_day[1]),
        .seg_num(output_hour_day_1)
    );



endmodule