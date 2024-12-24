module seven_seg_decoder (
    input [3:0] bin_num,
    output reg [6:0] seg_num // abcdefg
    );

// mô tả hoạt động của bộ decoder - giống bảng chân lý
always @(bin_num) begin
    case (bin_num)
        4'b0000: begin
            seg_num = 7'b1111110;
            end
        4'b0001: begin 
            seg_num = 7'b0110000;
            end
        4'b0010: begin
            seg_num = 7'b1101101;
            end
        4'b0011: begin
            seg_num = 7'b1111001;
            end
        4'b0100: begin
            seg_num = 7'b0110011;
            end
        4'b0101: begin
            seg_num = 7'b1011011;
            end
        4'b0110: begin
            seg_num = 7'b1011111;
            end
        4'b0111: begin
            seg_num = 7'b1110000;
            end
        4'b1000: begin
            seg_num = 7'b1111111;
            end
        4'b1001: begin
            seg_num = 7'b1111011;
            end
        default: begin
            seg_num = 7'b0000000;
            end
    endcase

    seg_num = ~seg_num;
    end

endmodule