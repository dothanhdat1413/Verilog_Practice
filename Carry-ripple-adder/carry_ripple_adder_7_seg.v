module carry_ripple_adder_7_seg 
    #(    parameter WIDTH = 6 )(
    input [WIDTH-1:0] input_num1_bin, input_num2_bin,
    input c_in,
    
    output [6:0] output_sum_7_seg_0, // abcdefg
    output [6:0] output_sum_7_seg_1,
    output [6:0] output_sum_7_seg_2,

    output [6:0] output_num1_7_seg_0,
    output [6:0] output_num1_7_seg_1,    

    output [6:0] output_num2_7_seg_0,
    output [6:0] output_num2_7_seg_1
    );

    wire [WIDTH-1:0] cal_sum_bin;
    wire [3:0] output_sum_bin [2:0];
    wire [3:0] output_num_1_bin [1:0];
    wire [3:0] output_num_2_bin [1:0];
    wire c_out;

    carry_ripple_adder #(.WIDTH(WIDTH)) carry_ripple_adder_module(
        .num1(input_num1_bin),
        .num2(input_num2_bin),
        .c_in(c_in),
        .sum(cal_sum_bin),
        .c_out(c_out)
    );
    // ______________________Display______________________
    seven_seg_decoder input_1_seg_0(
        .bin_num(output_num_1_bin[0]),
        .seg_num(output_num1_7_seg_0)
    );
    seven_seg_decoder input_1_seg_1(
        .bin_num(output_num_1_bin[1]),
        .seg_num(output_num1_7_seg_1)
    );
    seven_seg_decoder input_2_seg_0(
        .bin_num(output_num_2_bin[0]),
        .seg_num(output_num2_7_seg_0)
    );
    seven_seg_decoder input_2_seg_1(
        .bin_num(output_num_2_bin[1]),
        .seg_num(output_num2_7_seg_1)
    );

    convert_to_2_num num1_convert(
        .num({1'b0,input_num1_bin}),
        .num_bin_0(output_num_1_bin[0]),
        .num_bin_1(output_num_1_bin[1])
    );
    convert_to_2_num num2_convert(
        .num({1'b0,input_num2_bin}),
        .num_bin_0(output_num_2_bin[0]),
        .num_bin_1(output_num_2_bin[1])
    );
    convert_to_3_num sum_convert(
        .num({c_out, cal_sum_bin}),
        .num_bin_0(output_sum_bin[0]),
        .num_bin_1(output_sum_bin[1]),
        .num_bin_2(output_sum_bin[2])
    );

    seven_seg_decoder sum_seg_0(
        .bin_num(output_sum_bin[0]),
        .seg_num(output_sum_7_seg_0)
    );
    seven_seg_decoder sum_seg_1(
        .bin_num(output_sum_bin[1]),
        .seg_num(output_sum_7_seg_1)
    );
    seven_seg_decoder sum_seg_2(
        .bin_num(output_sum_bin[2]),
        .seg_num(output_sum_7_seg_2)
    );
endmodule
