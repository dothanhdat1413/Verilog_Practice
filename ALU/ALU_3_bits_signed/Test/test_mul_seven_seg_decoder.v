module test_mul_seven_seg_decoder();

    reg signed [5:0] bin_num;
    wire sign;
    wire [6:0] seg_num_0;
    wire [6:0] seg_num_1;

    mul_seven_seg_decoder mul_seven_seg_decoder(
        .bin_num(bin_num),
        .sign(sign),
        .seg_num_0(seg_num_0),
        .seg_num_1(seg_num_1)
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
    
    reg [3:0] out_num_1;
    reg [3:0] out_num_0;

    integer i;
    initial begin
        for(i = -16; i < 13; i = i + 1) begin
            bin_num = i;
            #10;
            $display("bin_num = %d, sign = %d, out = %d%d", bin_num, sign, out_num_1 , out_num_0 );
        end
    end

    always @(*) begin
        case(seg_num_0)
            OUT_0_ANODE: begin
                out_num_0 = 4'b0000;
            end
            OUT_1_ANODE: begin
                out_num_0 = 4'b0001;
            end
            OUT_2_ANODE: begin
                out_num_0 = 4'b0010;
            end
            OUT_3_ANODE: begin
                out_num_0 = 4'b0011;
            end
            OUT_4_ANODE: begin
                out_num_0 = 4'b0100;
            end
            OUT_5_ANODE: begin
                out_num_0 = 4'b0101;
            end
            OUT_6_ANODE: begin
                out_num_0 = 4'b0110;
            end
            OUT_7_ANODE: begin
                out_num_0 = 4'b0111;
            end
            OUT_8_ANODE: begin
                out_num_0 = 4'b1000;
            end
            OUT_9_ANODE: begin
                out_num_0 = 4'b1001;
            end
            OUT_DEFAULT_ANODE: begin
                out_num_0 = 4'b1111;
            end
        endcase
        case(seg_num_1)
            OUT_0_ANODE: begin
                out_num_1 = 4'b0000;
            end
            OUT_1_ANODE: begin
                out_num_1 = 4'b0001;
            end
            OUT_2_ANODE: begin
                out_num_1 = 4'b0010;
            end
            OUT_3_ANODE: begin
                out_num_1 = 4'b0011;
            end
            OUT_4_ANODE: begin
                out_num_1 = 4'b0100;
            end
            OUT_5_ANODE: begin
                out_num_1 = 4'b0101;
            end
            OUT_6_ANODE: begin
                out_num_1 = 4'b0110;
            end
            OUT_7_ANODE: begin
                out_num_1 = 4'b0111;
            end
            OUT_8_ANODE: begin
                out_num_1 = 4'b1000;
            end
            OUT_9_ANODE: begin
                out_num_1 = 4'b1001;
            end
            OUT_DEFAULT_ANODE: begin
                out_num_1 = 4'b0000;
            end
        endcase 
    end


endmodule