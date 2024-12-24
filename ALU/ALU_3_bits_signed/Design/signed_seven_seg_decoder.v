module signed_seven_seg_decoder (
    input [2:0] bin_num,
    input error,
    output reg sign,
    output reg [6:0] seg_num // gfedcba - từ a -> g tương ứng từ 0 -> 6
    );


    parameter OUT_0_ANODE = 7'b1000000; 
    parameter OUT_1_ANODE = 7'b1111001; 
    parameter OUT_2_ANODE = 7'b0100100; 
    parameter OUT_3_ANODE = 7'b0110000; 
    parameter OUT_4_ANODE = 7'b0011001; 
    parameter OUT_5_ANODE = 7'b0010010; 
    parameter OUT_6_ANODE = 7'b0000010; 
    parameter OUT_7_ANODE = 7'b1110000; 
    parameter OUT_8_ANODE = 7'b0000000; 
    parameter OUT_9_ANODE = 7'b0010000; 
    parameter OUT_DEFAULT_ANODE = 7'b1111111;

    always @(bin_num) begin
        if(error == 1'b1) begin
            seg_num = OUT_DEFAULT_ANODE;
            sign = 1;
        end else begin
            sign = ~bin_num[2];
            case(bin_num)
                3'b100: begin
                    seg_num = OUT_4_ANODE;
                end
                3'b101: begin
                    seg_num = OUT_3_ANODE;
                end
                3'b110: begin
                    seg_num = OUT_2_ANODE;
                end
                3'b111: begin
                    seg_num = OUT_1_ANODE;
                end
                3'b000: begin
                    seg_num = OUT_0_ANODE;
                end
                3'b001: begin
                    seg_num = OUT_1_ANODE;
                end
                3'b010: begin
                    seg_num = OUT_2_ANODE;
                end
                3'b011: begin
                    seg_num = OUT_3_ANODE;
                end
                default: begin
                    seg_num = OUT_DEFAULT_ANODE;
                end
            endcase
        end
    end

endmodule