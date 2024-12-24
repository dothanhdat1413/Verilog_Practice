
    module convert_to_3_num (
        input [6:0] num,
        output reg [3:0] num_bin_0,
        output reg [3:0] num_bin_1,
        output reg [3:0] num_bin_2
        );
        always @(num) begin
            if(num>=100)begin
                num_bin_2 = 1;
                if((num-100)>=20)begin
                    num_bin_1 = 2;
                    num_bin_0 = num - 120;
                end else if((num-100)>=10)begin
                    num_bin_1 = 1;
                    num_bin_0 = num - 110;
                end else begin
                    num_bin_1 = 0;
                    num_bin_0 = num - 100;
                end
            end else begin
                num_bin_2 = 0;
                if(num >= 90) begin
                    num_bin_1 = 9;
                    num_bin_0 = num - 90;
                end else if(num >= 80) begin
                    num_bin_1 = 8;
                    num_bin_0 = num - 80;
                end else if(num >= 70) begin
                    num_bin_1 = 7;
                    num_bin_0 = num - 70;
                end else if(num >= 60) begin
                    num_bin_1 = 6;
                    num_bin_0 = num - 60;
                end else if(num>=50) begin
                    num_bin_1 = 5;
                    num_bin_0 = num - 50;
                end else if(num>=40) begin
                    num_bin_1 = 4;
                    num_bin_0 = num - 40;
                end else if(num>=30) begin
                    num_bin_1 = 3;
                    num_bin_0 = num - 30;
                end else if(num>=20) begin
                    num_bin_1 = 2;
                    num_bin_0 = num - 20;
                end else if(num>=10) begin
                    num_bin_1 = 1;
                    num_bin_0 = num - 10;
                end else begin
                    num_bin_1 = 0;
                    num_bin_0 = num;
                end
            end
        end
    endmodule