module neg #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] num,
    output [WIDTH-1:0] result,
    output [3:0] flag // o, z, s, c
);  

    wire [WIDTH-1:0] not_num; // bù 1
    wire [3:0] flag_temp;
    assign not_num = ~num;

    add #(
        .WIDTH(WIDTH)
    ) add_1(
        .num_1(not_num),
        .num_2({(WIDTH){1'b0}}),
        .c_in(1'b1),
        .result(result),
        .flag(flag_temp)
    );

    assign flag[0] = 0;
    assign flag[1] = flag_temp[1];
    assign flag[2] = flag_temp[2];
    assign flag[3] = (num == 3'b100); // sau khi đảo dấu thì dấu của input và ouput phải đối nhau, nếu ko thì sẽ tràn số (ko có biểu diễn)

endmodule