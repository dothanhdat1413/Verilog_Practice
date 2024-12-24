module div #(
    parameter WIDTH = 3 // thật ra là bộ chia này ko có tính tổng quát, chỉ áp dụng với trường hợp này
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    output reg [WIDTH-1:0] result,
    output reg [WIDTH-1:0] remainder,
    output reg [3:0] flag // o, z, s, c
);
    parameter OVERFLOW = 4'b1000; // tràn số
    parameter ZERO = 4'b0100; // kết quả là 0
    parameter SIGNED = 4'b0010; // kết quả âm
    parameter CARRY = 4'b0001; // kết quả âm
    parameter NONE = 4'b0000; // không có lỗi
    parameter ERROR = 4'b1111; // có lỗi

    wire [WIDTH-1:0] num_1_neg;
    wire [WIDTH-1:0] num_2_neg;



    neg #(
        .WIDTH(WIDTH)
    ) neg_1(
        .num(num_1),
        .result(num_1_neg)
    ); // còn flag chưa nối, bỏ qua xem có lỗi ko

    neg #(
        .WIDTH(WIDTH)
    ) neg_2(
        .num(num_2),
        .result(num_2_neg)
    ); // còn flag chưa nối, bỏ qua xem có lỗi ko

    wire [WIDTH-1:0] num_1_abs;
    wire [WIDTH-1:0] num_2_abs;
    reg [WIDTH-1:0] remainder_abs;
    reg [WIDTH-1:0] result_abs;

    assign num_1_abs = num_1[WIDTH-1] ? num_1_neg : num_1; // âm thì đảo dấu
    assign num_2_abs = num_2[WIDTH-1] ? num_2_neg : num_2; // âm thì đảo dấu

    wire [1:0] compare_result;  
    parameter DIVIDEND_LARGER = 2'b01;  // num_1 > num_2
    parameter DIVISOR_LARGER = 2'b10; // num_1 < num_2
    parameter EQUAL = 2'b00; // num_1 = num_2

    comparator #(
        .WIDTH(WIDTH)
    ) comparator_1(
        .num_1(num_1_abs),
        .num_2(num_2_abs),
        .result(compare_result)
    );  

    reg [1:0] signed_check;
    parameter SIGNED_DIVIDEND = 2'b01; // num_1 âm
    parameter SIGNED_DIVISOR = 2'b10; // num_2 âm
    parameter SIGNED_BOTH = 2'b11; // cả 2 âm
    parameter UNSIGNED_BOTH = 2'b00; // cả 2 dương

    always @(*) begin : Signed_check
        if(num_1[WIDTH-1] & num_2[WIDTH-1]) begin
            signed_check = SIGNED_BOTH;
        end else if(num_1[WIDTH-1] == 1 && num_2[WIDTH-1] == 0) begin
            signed_check = SIGNED_DIVIDEND;
        end else if(num_1[WIDTH-1] == 0 && num_2[WIDTH-1] == 1) begin
            signed_check = SIGNED_DIVISOR;
        end else begin
            signed_check = UNSIGNED_BOTH;
        end
    end

    always @(*) begin : Absolute_divider
        if(num_2_abs == 1) begin
            remainder_abs = 0;
            result_abs = num_1_abs;
        end else begin
            case(compare_result)
                DIVISOR_LARGER: begin
                    remainder_abs = num_1_abs;
                    result_abs = 0;
                end
                EQUAL: begin
                    remainder_abs = 0;
                    result_abs = 1;
                end
                DIVIDEND_LARGER: begin
                    if(num_1_abs == 4) begin
                        if(num_2_abs == 2) begin   // TH 4/2
                            remainder_abs = 0;
                            result_abs = 2;
                        end else if(num_2_abs == 3)begin // TH 4/3
                            remainder_abs = 1;
                            result_abs = 1;
                        end else begin
                            remainder_abs = 0;
                            result_abs = 0;
                        end
                    end else if(num_1_abs == 3) begin // TH 3/2
                        remainder_abs = 1;
                        result_abs = 1;
                    end else begin
                        remainder_abs = 0;
                        result_abs = 0;
                    end
                end
                default: begin
                    remainder_abs = 0;
                    result_abs = 0;
                end
            endcase
        end
    end

    wire [WIDTH-1:0] remainder_temp_neg;
    wire [WIDTH-1:0] result_temp_neg;
    neg #(
        .WIDTH(WIDTH)
    ) neg_remain_temp(
        .num(remainder_abs),
        .result(remainder_temp_neg)
    ); // còn flag chưa nối, bỏ qua xem có lỗi ko

    neg #(
        .WIDTH(WIDTH)
    ) neg_result_temp(
        .num(result_abs),
        .result(result_temp_neg)
    ); // còn flag chưa nối, bỏ qua xem có lỗi ko

    always @(*) begin : output_result
        // Xử lý ngoại lệ
        if((num_1 | num_2) == 0 ) begin
            result = 0;
            remainder = 0;
            flag = ERROR;
        end else if (num_2 == 0) begin
            result = 0;
            remainder = 0;
            flag = OVERFLOW; // chia cho 0 -> tràn số
        end else begin
            case(signed_check)
                SIGNED_BOTH: begin
                    result = result_abs;
                    remainder = remainder_temp_neg;
                end
                SIGNED_DIVIDEND: begin
                    result = result_temp_neg;
                    remainder = remainder_temp_neg;
                end
                SIGNED_DIVISOR: begin
                    result = result_temp_neg;
                    remainder = remainder_abs;

                end
                UNSIGNED_BOTH: begin
                    result = result_abs;
                    remainder = remainder_abs;
                end
                default: begin
                    result = 0;
                    remainder = 0;
                end
            endcase
            flag[0] = 0; // ko carry
            flag[1] = result[WIDTH-1];
            flag[2] = (result == 0) ? 1'b1 : 1'b0;
            flag[3] = 0; // ko tràn số
        end
    end    
endmodule
