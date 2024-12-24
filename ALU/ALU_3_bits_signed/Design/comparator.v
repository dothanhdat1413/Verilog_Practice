// module comparator_mod #(
//     parameter WIDTH = 3
// )(
//     input [WIDTH-1:0] num_1,
//     input [WIDTH-1:0] num_2,
//     output [1:0] result // 00: num_1 = num_2, 01: num_1 > num_2, 10: num_1 < num_2
// );

//     assign result = (num_1 == num_2) ? 2'b00 :((num_1 > num_2) ? 2'b01 : 2'b10);
//     // phần này sẽ code lại theo bộ comparator WIDTH bit

// endmodule

module comparator #( // unsigned comparator
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    output [1:0] result 
);
    parameter EQUAL = 2'b00;
    parameter LARGER = 2'b01; // num_1 > num_2
    parameter SMALLER = 2'b10; // num_1 < num_2

    wire [WIDTH:0] sub_result;
    wire [3:0] flag;
    sub #(
        .WIDTH(WIDTH+1)
    ) sub_compare(
        .num_1({1'b0,num_1}),
        .num_2({1'b0,num_2}),
        .result(sub_result),
        .flag(flag)
    );

    assign result = (sub_result[WIDTH]) ? SMALLER : ((sub_result == 0) ? EQUAL : LARGER);
endmodule