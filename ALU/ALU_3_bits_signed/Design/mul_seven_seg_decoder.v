module mul_seven_seg_decoder(
    input [5:0] bin_num,
    output sign,
    output reg [6:0] seg_num_0,
    output reg [6:0] seg_num_1
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

    wire [5:0] bin_num_neg;

    neg #(
        .WIDTH(6)
    )neg(
        .num(bin_num),
        .result(bin_num_neg)
    );

    assign sign = ~bin_num[5];

    wire [5:0] bin_num_abs;
    assign bin_num_abs = bin_num[5] ? bin_num_neg : bin_num;

    always @(*) begin
        case(bin_num_abs) 
            6'b0000000: begin
                seg_num_0 = OUT_0_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000001: begin
                seg_num_0 = OUT_1_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000010: begin
                seg_num_0 = OUT_2_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000011: begin
                seg_num_0 = OUT_3_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000100: begin
                seg_num_0 = OUT_4_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000101: begin
                seg_num_0 = OUT_5_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000110: begin
                seg_num_0 = OUT_6_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0000111: begin
                seg_num_0 = OUT_7_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0001000: begin
                seg_num_0 = OUT_8_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0001001: begin
                seg_num_0 = OUT_9_ANODE;
                seg_num_1 = OUT_0_ANODE;
            end
            6'b0001010: begin
                seg_num_0 = OUT_0_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0001011: begin
                seg_num_0 = OUT_1_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0001100: begin
                seg_num_0 = OUT_2_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0001101: begin
                seg_num_0 = OUT_3_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0001110: begin
                seg_num_0 = OUT_4_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0001111: begin
                seg_num_0 = OUT_5_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end
            6'b0010000: begin
                seg_num_0 = OUT_6_ANODE;
                seg_num_1 = OUT_1_ANODE;
            end 
            default: begin
                seg_num_0 = OUT_DEFAULT_ANODE;
                seg_num_1 = OUT_DEFAULT_ANODE;
            end
        endcase
    end
endmodule