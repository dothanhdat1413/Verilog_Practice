module majority (
    input [31:0] num,
    output more_bit_1
    );

    wire [2:0] sum_2_bit [15:0]; //  16 cặp 2 bit
    wire [3:0] sum_4_bit [7:0];  //  8 cặp 4 bit
    wire [4:0] sum_8_bit [3:0];  //  4 cặp 8 bit
    wire [5:0] sum_16_bit [1:0]; //  2 cặp 16 bit
    wire [6:0] sum_32_bit;       //  tổng số bit 1
    
    genvar  i;
    generate 
        for(i=0; i<16; i=i+1) begin : sum_2_bit_16
            assign sum_2_bit[i] = num[(i*2)] + num [(i*2-1)];
        end
        for(i=0; i<8; i=i+1) begin : sum_4_bit_8
            assign sum_4_bit[i] = sum_2_bit[(i*2)] + sum_2_bit[(i*2-1)];
        end
        for(i=0; i<4; i=i+1) begin : sum_8_bit_4
            assign sum_8_bit[i] = sum_4_bit[(i*2)] + sum_4_bit[(i*2-1)];
        end
        for(i=0; i<2; i=i+1) begin : sum_16_bit_2
            assign sum_16_bit[i] = sum_8_bit[(i*2)] + sum_8_bit[(i*2-1)];
        end
        assign sum_32_bit = sum_16_bit[0] + sum_16_bit[1];
    endgenerate

    assign more_bit_1 = (sum_32_bit > 16) ? 1'b1 : 1'b0;
endmodule