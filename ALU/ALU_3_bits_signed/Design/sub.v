module sub #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    output [WIDTH-1:0] result,
    output [3:0] flag // o, z, s, c
);
    wire [WIDTH-1:0] not_num_2;

    assign not_num_2 = ~num_2;

    add #(
        .WIDTH(WIDTH)
    ) sub_add(
        .num_1(num_1),
        .num_2(not_num_2),
        .c_in(1),
        .result(result),
        .flag(flag)
    );

endmodule