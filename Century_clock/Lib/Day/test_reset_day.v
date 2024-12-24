`timescale 1ps/1ps
module test_reset_day ();
    
    reg [3:0] day_0;
    reg [3:0] day_1;
    reg [3:0] month_0;
    reg [3:0] month_1;
    reg [3:0] year_0;
    reg [3:0] year_1;
    reg [3:0] year_2;
    reg [3:0] year_3;
    reg rst;

    wire reset_day;

    task convert;
        input [7:0] day;
        input [7:0] month;
        input [15:0] year;  // Năm là 4 chữ số
        output [3:0] day_0, day_1;
        output [3:0] month_0, month_1;
        output [3:0] year_0, year_1, year_2, year_3;

        begin
            // Gán giá trị cho ngày
            day_0 = day % 10;
            day_1 = day / 10;

            // Gán giá trị cho tháng
            month_0 = month % 10;
            month_1 = month / 10;

            // Gán giá trị cho năm
            year_0 = year % 10;
            year_1 = (year / 10) % 10;
            year_2 = (year / 100) % 10;
            year_3 = (year / 1000) % 10;
            // #20;
            // $display("%t Test:  %0d%0d /  %0d%0d/  %0d%0d%0d%0d, Result: %b ",$time,day_1, day_0, month_1, month_0, year_3, year_2, year_1, year_0, reset_day);
            // #10;

        end
    endtask

    task display;
        begin
            #10;
            $display("%t Test:  %0d%0d /  %0d%0d/  %0d%0d%0d%0d, Result: %b ",$time,day_1, day_0, month_1, month_0, year_3, year_2, year_1, year_0, reset_day);
        end
    endtask

    task check;
        begin
            #20;
            if(reset_day == 1'b1) begin
                $display("%t RESET:  %0d%0d /  %0d%0d/  %0d%0d%0d%0d",$time,day_1, day_0, month_1, month_0, year_3, year_2, year_1, year_0);
            end
            else begin
                $display("%t NOT RESET YET:  %0d%0d /  %0d%0d/  %0d%0d%0d%0d",$time,day_1, day_0, month_1, month_0, year_3, year_2, year_1, year_0);
            end
        end
    endtask

    reset_day reset_day_module(
        .day_0(day_0),
        .day_1(day_1),
        .month_0(month_0),
        .month_1(month_1),
        .year_0(year_0),
        .year_1(year_1),
        .year_2(year_2),
        .year_3(year_3),
        .rst(rst),
        .reset_day(reset_day)
    );


    initial begin
        rst = 1;
        #10;
        rst = 0;
        $display("Begin test");
        convert(30, 1, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 1, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 3, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 3, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20
        convert(29, 4, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 4, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 5, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 5, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 6, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 6, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 7, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 7, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 8, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 8, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 9, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 9, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 10, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 10, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 11, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 11, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(30, 12, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(31, 12, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        $display("Begin test 2");
        convert(28, 2, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 2, 2000, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(27, 2, 2001, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(28, 2, 2001, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;

        convert(28, 2, 2200, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 2, 2200, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(28, 2, 2004, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 2, 2004, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;

        convert(28, 2, 2012, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;
        convert(29, 2, 2312, day_0, day_1, month_0, month_1, year_0, year_1, year_2, year_3);
        check;
        #20;


        $display("End test");
    end

    

endmodule