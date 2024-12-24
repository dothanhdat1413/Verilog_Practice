module add #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    input c_in,
    output [WIDTH-1:0] result,
    output [3:0] flag // o, z, s, c
);  

    wire carry;

    genvar i;
    wire [(WIDTH -2):0] c_out_t;
	
    CPA add_bit_0(
        .num_1(num_1[0]),
        .num_2(num_2[0]),
        .c_in(c_in),
        .sum(result[0]),
        .c_out(c_out_t[0])
        );
    generate
        for(i = 1; i < WIDTH-1; i = i + 1) begin: add_middle_bit
            CPA add_bit(
                .num_1(num_1[i]),
                .num_2(num_2[i]),
                .c_in(c_out_t[i-1]),
                .sum(result[i]),
                .c_out(c_out_t[i])
                );
        end
    endgenerate

    CPA add_bit_max(
        .num_1(num_1[WIDTH-1]),
        .num_2(num_2[WIDTH-1]),
        .c_in(c_out_t[WIDTH-2]),
        .sum(result[WIDTH-1]),
        .c_out(carry)
    );

    assign flag[0] = result[WIDTH-1]&(!num_1[WIDTH-1])&(!num_2[WIDTH-1]) | (!result[WIDTH-1])&num_1[WIDTH-1]&num_2[WIDTH-1];
    assign flag[1] = result[WIDTH-1];
    assign flag[2] = (result == 0) ? 1'b1 : 1'b0;
    assign flag[3] = result[WIDTH-1]&(!num_1[WIDTH-1])&(!num_2[WIDTH-1]) | (!result[WIDTH-1])&num_1[WIDTH-1]&num_2[WIDTH-1];

endmodule