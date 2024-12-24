module 7_seg_decoder (
    input [3:0] bin_num,
    output [6:0] seg_num // abcdefg
    );

// cần mô tả quá trình đầu vào đầu ra của dữ liệu 
assign seg_num[6] = ~((~bin_num[2] & ~bin_num[0]) | (bin_num[1]) | (bin_num[2] & bin_num[0]) | (bin_num[3]));
assign seg_num[5] = ~((~bin_num[2]) | (~bin_num[1] & ~bin_num[0]) | (bin_num[1] & bin_num[0]));
assign seg_num[4] = ~((~bin_num[1]) | (bin_num[0]) | (bin_num[2]));
assign seg_num[3] = ~((~bin_num[2] & ~bin_num[0]) | (~bin_num[2] & bin_num[1]) | (bin_num[2] & ~bin_num[1] & bin_num[0]) | (bin_num[1] & ~bin_num[0]) | (bin_num[3]));
assign seg_num[2] = ~((~bin_num[2] & ~bin_num[0]) | (bin_num[1] & ~bin_num[0]));
assign seg_num[1] = ~((~bin_num[1] & ~bin_num[0]) | (bin_num[2] & ~bin_num[1]) | (bin_num[2] & ~bin_num[0]) | (bin_num[3]));
assign seg_num[0] = ~((~bin_num[2] & bin_num[1]) | (bin_num[2] & ~bin_num[1]) | (bin_num[3]) | (bin_num[1] & ~bin_num[0]));

endmodule