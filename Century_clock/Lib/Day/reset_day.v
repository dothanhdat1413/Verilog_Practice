module reset_day (
    input [3:0] day_0,
    input [3:0] day_1,
    input [3:0] month_0,
    input [3:0] month_1,
    input [3:0] year_0,
    input [3:0] year_1,
    input [3:0] year_2,
    input [3:0] year_3,
    input rst,
    output reg reset_day,
    output leap,
    output leap_0_0,// năm nhuận xxab với a là chẵn, b là 4 hoặc 8 và ab khác 00
    output leap_0_1,// năm nhuận xxab với ab = 00 và xx chia hết 4
    output leap_0_1_var,
    output leap_1// năm nhuận xxab với a là lẻ, b là 2 hoặc 6
);
    // wire leap;
    // wire leap_0_0;// năm nhuận xxab với a là chẵn, b là 4 hoặc 8 và ab khác 00
    // wire leap_0_1;// năm nhuận xxab với ab = 00 và xx chia hết 4
    // wire leap_0_1_var;
    // wire leap_1;// năm nhuận xxab với a là lẻ, b là 2 hoặc 6

    assign leap_0_0 = ((year_1[0] == 0) && (year_0[1] == 0) && (year_0[0] == 0)) && ( (year_1 != 4'b0000) || (year_0 != 4'b0000)); // ab chẵn, b là 4 hoặc 8 và ko đồng thời bằng ko
    assign leap_0_1_var = ((year_3[0] == 0) && (year_2[1] == 0) && (year_2[0] == 0)) || ((year_3[0] == 1) && (year_2[1] == 1) && (year_2[0] == 0)); 
    assign leap_0_1 = (year_0 == 0) && (year_1 == 0) && leap_0_1_var;
    assign leap_1 = (year_1[0] == 1) && (year_0[1] == 1) && (year_0[0] == 0);

    assign leap = leap_0_0 + leap_0_1 + leap_1;

    always @(*) begin
        if ((month_0[0] == 1'b0) && (month_0[2] == 1'b1)) begin : Month_4_6
            reset_day <= ((day_1[0] == 1) && (day_1[1] == 1) && day_0[0] == 0) || rst; // check ngày 30
        end
        else if ((month_0[0] == 1'b1) && (month_0[3] == 1'b1)) begin : Month_9 
            reset_day <= ((day_1[0] == 1) && (day_1[1] == 1) && day_0[0] == 0) || rst; // check ngày 30
        end
        else if ((month_1[0] == 1'b1) && (month_0[0] == 1'b1)) begin : Month_11
            reset_day <= ((day_1[0] == 1) && (day_1[1] == 1) && day_0[0] == 0) || rst; // check ngày 30
        end
        else if ((month_1[0] == 1'b0) && (month_0[1] == 1'b1) && (month_0[0] == 1'b0)) begin : Month_2
            if(!leap) begin
                reset_day <= ((day_1[1] == 1) && (day_1[0] == 0) && (day_0[3] == 1) && (day_0[0] == 0)) || rst;
            end
            else begin : max_29
                reset_day <= ((day_1[1] == 1) && (day_1[0] == 0) && (day_0[3] == 1) && (day_0[0] == 1)) || rst;
            end
        end 
        else begin : Month_1_3_5_7_8_10_12
            reset_day <= ((day_1[0] == 1) && (day_1[1] == 1) && day_0[0] == 1) || rst; // check ngày 31
        end
    end


endmodule