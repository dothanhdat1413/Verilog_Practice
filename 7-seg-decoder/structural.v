module 7_seg_decoder (
    input [3:0] bin_num // ABCD
    output [6:0] seg_num // abcdefg
    );
    
    /*
    Cần mô tả các cổng cụ thể của bộ decoder này, có thể cần dùng các cổng logic có sẵn
    */
    wire _b, _c, _d;
    wire _b_d, _bc, c_d, b_c;
    wire bd, cd, _c_d, bd_c, b_d;
        not(
            .output(_b),
            .input(bin_num[2])
        );// ~b
        not(
            .output(_c),
            .input(bin_num[1])
        );// ~c
        not(
            .output(_d),
            .input(bin_num[0])
        );// ~d

            and(
                .output(_b_d),
                .input1(_b),
                .input2(_d)
            );// ~b & ~d
            and(
                .output(_bc),
                .input1(_b),
                .input2(bin_num[1])
            );// ~b & c
            and(
                .output(c_d),
                .input1(bin_num[1]),
                .input2(_d)
            );// c & ~d
            and(
                .output(b_c),
                .input1(bin_num[2]),
                .input2(_c)
            );// b & ~c

            and(
                .output(bd),
                .input1(bin_num[2]),
                .input2(bin_num[0])
            );// b & d
            and(
                .output(cd),
                .input1(bin_num[1]),
                .input2(bin_num[0])
            );// c & d
            and(
                .output(_c_d),
                .input1(_c),
                .input2(_d)
            );// ~c & ~d
            and(
                .output(bd_c),
                .input1(bd),
                .input2(_c)
            );// b & d & ~c
            and(
                .output(b_d),
                .input1(bin_num[2]),
                .input2(_d)
            );// b & ~d
// seg_num[6]
    nor(
        .output(seg_num[6]),
        .input1(_b_d),
        .input2(bin_num[1]),
        .input3(bd),
        .input4(bin_num[3])
    );// (~b & ~d) | (c) | (b & d) | (a)
// seg_num[5]
    nor(
        .output(seg_num[5]),
        .input1(_b),
        .input2(_c_d),
        .input3(cd)
    );// (~b) | (~c & ~d) | (c & d)
// seg_num[4]
    nor(
        .output(seg_num[4]),
        .input1(_c),
        .input2(bin_num[0]),
        .input3(bin_num[2])
    );// (~c) | (d) | (b)
// seg_num[3]
    nor(
        .output(seg_num[3]),
        .input1(_b_d),
        .input2(_bc),
        .input3(bd_c),
        .input4(c_d),
        .input5(bin_num[3])
    );// (~b & ~d) | (~b & c) | (b & ~c & d) | (c & ~d) | (a)
// seg_num[2]
    nor(
        .output(seg_num[2]),
        .input1(_b_d),
        .input2(c_d)
    );// (~b & ~d) | (c & ~d)
// seg_num[1]
    nor(
        .output(seg_num[1]),
        .input1(_c_d),
        .input2(b_c),
        .input3(b_d),
        .input4(bin_num[3])
    );// (~c & ~d) | (b & ~c) | (b & ~d) | (a)
// seg_num[0]
    nor(
        .output(seg_num[0]),
        .input1(_bc),
        .input2(b_c),
        .input3(bin_num[3]),
        .input4(c_d)
    );// (~b & c) | (b & ~c) | (a) | (c & ~d)

endmodule