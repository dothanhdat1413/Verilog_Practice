module test_mul ();
    reg signed [2:0] num_1;
    reg signed [2:0] num_2;
    wire signed [5:0] result;
    wire [3:0] flag;

    mul #(
        .WIDTH(3)
    ) mul_1(
        .num_1(num_1),
        .num_2(num_2),
        .result(result),
        .flag(flag)
    );

    integer i, j;
    initial begin
        for(i = -4; i<4; i=i+1)
            for(j = -4; j<4; j=j+1) begin
                num_1 = i;
                num_2 = j;
                #10;
            end

        $finish;
    end

    always @(result) begin
        $display("num_1 = %d, num_2 = %d, result = %d, expected result = %d, flag = %b", num_1, num_2, result,(num_1*num_2),flag);
    end
endmodule