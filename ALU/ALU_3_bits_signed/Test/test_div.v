module test_div ();
    reg signed [2:0] num_1;
    reg signed [2:0] num_2;
    wire signed [2:0] result;
    wire signed [2:0] remainder;
    wire [3:0] flag;

    div #(
        .WIDTH(3)
    ) div_1(
        .num_1(num_1),
        .num_2(num_2),
        .result(result),
        .remainder(remainder),
        .flag(flag)
    );

    integer i, j;
    initial begin
        for(i = -4; i<4; i=i+1)
            for(j = -4; j<4; j=j+1) begin
                if(!((i == -4 )&&( j == -4))) begin
                    num_1 = i;
                    num_2 = j;
                    #10;
                end
            end
        $finish;
    end

    always #8 begin
        $display("%t num_1 = %d, num_2 = %d, result = %d, expected result = %d, flag = %b",$time ,num_1, num_2, result,(num_1/num_2),flag);
        #2;
    end

endmodule