`timescale 1ns/1ns
module test_CRA();
    reg [6:0] num1, num2 ;
    reg c_in;
    wire [6:0] sum;
    wire c_out;

    carry_ripple_adder #(.WIDTH(6))DUT (
        .num1(num1),
        .num2(num2),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
    );

    integer i, j, k;
    initial begin
	$display("___________________________Random test____________________________");
        #10;
        for( i = 0; i < 10; i = i + 1)begin
            #10;
            num1 <= $random;
            num2 <= $random;
            c_in <= $random;
        end

    $display("___________________________Bruteforce test____________________________");
        #10;
        for( i = 0; i < 256; i = i + 1) begin
            #10;
            num1 <= i[6:0]; // chỉ lấy 8 bit 
            for( j = 0; j < 256; j = j + 1)begin
                #10;
                num2 <= j[6:0];
                for( k = 0; k < 2; k = k + 1)begin
                    #10;
                    c_in <= k[0:0];
                end
            end
        end
    end

    always @(num1, num2, c_in)begin
        if({c_out,sum} != num1 + num2 + c_in)begin
            $display("Error: num1 = %b, num2 = %b, c_in = %b, sum = %b, c_out = %b", num1, num2, c_in, sum, c_out);
        end
    end



endmodule