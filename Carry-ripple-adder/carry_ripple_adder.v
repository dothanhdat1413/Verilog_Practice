module carry_ripple_adder 
    #(    parameter WIDTH = 6 )(
    input [WIDTH-1:0] num1, num2,
    input c_in,
    output [WIDTH-1:0] sum,
    output  c_out
    );

    genvar i;
    wire [(WIDTH -2):0] c_out_t;
	
    fulladd add_bit_0(
        .num1(num1[0]),
        .num2(num2[0]),
        .c_in(c_in),
        .sum(sum[0]),
        .c_out(c_out_t[0])
        );
    generate
        for(i = 1; i < WIDTH-1; i = i + 1) begin: add_middle_bit
            fulladd add_bit(
                .num1(num1[i]),
                .num2(num2[i]),
                .c_in(c_out_t[i-1]),
                .sum(sum[i]),
                .c_out(c_out_t[i])
                );
        end
    endgenerate

    fulladd add_bit_7(
        .num1(num1[WIDTH-1]),
        .num2(num2[WIDTH-1]),
        .c_in(c_out_t[WIDTH-2]),
        .sum(sum[WIDTH-1]),
        .c_out(c_out)
    );
    
endmodule