module ALU(
    input [2:0] num_1,
    input [2:0] num_2,
    input [3:0] opcode, // chỉ dùng từ 0 - 9, còn lại output = 0 hết
    output [3:0] opcode_out,
    output [6:0] num_1_out,
    output num_1_sign_out,
    output reg [6:0] num_2_out,
    output reg num_2_sign_out,
    output reg [6:0] result_2,
    output reg [6:0] result_1,
    output reg [6:0] result_mul_0_remainder_sign,
    output reg [6:0] remainder_0,

    output reg [3:0] flag // cờ báo trạng thái: overflow, zero, sign, carry 
);
    assign opcode_out = opcode;

    reg [2:0] result;
    reg [5:0] result_mul;
    reg [2:0] remainder;

    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter MUL = 4'b0010;
    parameter DIV = 4'b0011; // chú ý trường hợp chia cho 0
    parameter NEG = 4'b0100; // bù 2 của num_1
    parameter AND = 4'b0101;
    parameter OR  = 4'b0110;
    parameter XOR = 4'b0111;
    parameter NOT = 4'b1000; // đảo của num_1

    parameter OVERFLOW = 4'b1000; // tràn số
    parameter ZERO = 4'b0100; // kết quả là 0
    parameter SIGNED = 4'b0010; // kết quả âm
    parameter CARRY = 4'b0001; // kết quả âm
    parameter NONE = 4'b0000; // không có lỗi
    parameter ERROR = 4'b1111; // có lỗi

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

    wire [2:0] add_result;
    wire [2:0] sub_result;
    wire [5:0] mul_result;
    wire [2:0] div_result;
    wire [2:0] remainder_temp;
    wire [2:0] neg_result;
    reg [2:0] and_result;
    reg [2:0] or_result;
    reg [2:0] xor_result;
    reg [2:0] not_result;

    wire [3:0] add_flag;
    wire [3:0] sub_flag;
    wire [3:0] mul_flag;
    wire [3:0] div_flag;
    wire [3:0] neg_flag;
    reg [3:0] and_flag;
    reg [3:0] or_flag;
    reg [3:0] xor_flag;
    reg [3:0] not_flag;

    add add(
        .num_1(num_1),
        .num_2(num_2),
        .c_in(0),
        .result(add_result),
        .flag(add_flag)
    );

    sub sub(
        .num_1(num_1),
        .num_2(num_2),
        .result(sub_result),
        .flag(sub_flag)
    );

    mul mul(
        .num_1(num_1),
        .num_2(num_2),
        .result(mul_result),
        .flag(mul_flag)
    );

    div div(
        .num_1(num_1),
        .num_2(num_2),
        .result(div_result),
        .remainder(remainder_temp),
        .flag(div_flag)
    );

    neg neg(
        .num(num_1),
        .result(neg_result),
        .flag(neg_flag)
    );

    always @(*) begin : AND_module
        and_result = num_1 & num_2;
        if(and_result == 0) begin
            and_flag = ZERO; // zero
        end else begin
            and_flag = NONE;
        end
    end

    always @(*) begin : OR_module
        or_result = num_1 | num_2;
        if(or_result == 0) begin
            or_flag = ZERO; // zero
        end else begin
            or_flag = NONE;
        end
    end

    always @(*) begin : XOR_module
        xor_result = num_1 ^ num_2;
        if(xor_result == 0) begin
            xor_flag = ZERO; // zero
        end else begin
            xor_flag = NONE;
        end
    end

    always @(*) begin : NOT_module
        not_result = ~num_1;
        if(not_result == 0) begin
            not_flag = ZERO; // zero
        end else begin
            not_flag = NONE;
        end
    end

    always @(*) begin : OPCODE_drive_output
        case(opcode)
            ADD: begin
                result = add_result;
                flag = add_flag[3] ? OVERFLOW : add_flag; 
                result_mul = 0;
                remainder = 0;
            end
            SUB: begin
                result = sub_result;
                flag = sub_flag[3] ? OVERFLOW : sub_flag;
                result_mul = 0;
                remainder = 0;
            end
            NEG: begin
                result = neg_result;
                flag = neg_flag[3] ? OVERFLOW : neg_flag;
                result_mul = 0;
                remainder = 0;
            end
            MUL: begin
                result = 0;
                flag = mul_flag;
                result_mul = mul_result;
                remainder = 0;
            end
            DIV: begin
                result = div_result;
                flag = div_flag[3] ? OVERFLOW : div_flag;
                result_mul = 0;
                remainder = remainder_temp;
            end
            AND: begin
                result = and_result;
                flag = and_flag;
                result_mul = 0;
                remainder = 0;
            end
            OR: begin
                result = or_result;
                flag = or_flag;
                result_mul = 0;
                remainder = 0;
            end
            XOR: begin
                result = xor_result;
                flag = xor_flag;
                result_mul = 0;
                remainder = 0;
            end
            NOT: begin
                result = not_result;
                flag = not_flag;
                result_mul = 0;
                remainder = 0;
            end 
            default: begin
                result = 0;
                flag = ERROR;
                result_mul = 0;
                remainder = 0;
            end
        endcase
    end

    //________________________DISPLAY________________________
    wire [6:0] num_1_seg;
    wire num_1_sign;
    assign num_1_out = num_1_seg;
    assign num_1_sign_out = num_1_sign;
    wire [6:0] num_2_seg;
    wire num_2_sign;
    signed_seven_seg_decoder input_3bit_1(
        .bin_num(num_1),
        .error(0),
        .sign((num_1_sign)),
        .seg_num(num_1_seg)
    );

    signed_seven_seg_decoder input_3bit_2(
        .bin_num(num_2),
        .error(0),
        .sign((num_2_sign)),
        .seg_num(num_2_seg)
    );

    always @(*) begin : Display_input
        if((opcode == NEG) || (opcode == NOT)) begin
            num_2_out = OUT_DEFAULT_ANODE;
            num_2_sign_out = 1'b1;
        end else begin
            num_2_out = num_2_seg;
            num_2_sign_out = num_2_sign;
        end
    end
//______OUTPUT_3bit_______
    wire [6:0] result_seg;
    wire result_sign;

    signed_seven_seg_decoder output_3bit(
        .bin_num(result),
        .error(flag[3]),
        .sign((result_sign)),
        .seg_num(result_seg)
    );

    wire remainder_sign;
    wire [6:0] remainder_seg;
    signed_seven_seg_decoder remainder_3bit(
        .bin_num(remainder),
        .error(flag[3]),
        .sign((remainder_sign)),
        .seg_num(remainder_seg)
    );
// ______OUTPUT_6bit_______
    wire [6:0] result_mul_seg_0;
    wire [6:0] result_mul_seg_1;
    wire mul_result_sign;

    mul_seven_seg_decoder output_6bit(
        .bin_num(result_mul),
        .sign((mul_result_sign)),
        .seg_num_0(result_mul_seg_0),
        .seg_num_1(result_mul_seg_1)
    );

// ______OUTPUT_binary_______
    wire [6:0] result_bin_0;
    wire [6:0] result_bin_1;
    wire [6:0] result_bin_2;
    signed_seven_seg_decoder output_bin_0(
        .bin_num({2'b00,result[0]}),
        .error(flag[3]),
        .seg_num(result_bin_0)
    );

    signed_seven_seg_decoder output_bin_1(
        .bin_num({2'b00,result[1]}),
        .error(flag[3]),
        .seg_num(result_bin_1)
    );

    signed_seven_seg_decoder output_bin_2(
        .bin_num({2'b00,result[2]}),
        .error(flag[3]),
        .seg_num(result_bin_2)
    );

// ______OUTPUT_______

    always @(*) begin : Display_output
        if(opcode == MUL) begin
            result_2 = {(mul_result_sign),6'b111111};
            result_1 = result_mul_seg_1;
            result_mul_0_remainder_sign = result_mul_seg_0;
            remainder_0 = 7'b1111111;
        end else if(opcode == DIV)begin
            result_1 = result_seg;
            result_2 = {(result_sign),6'b111111};
            result_mul_0_remainder_sign = {(remainder_sign),6'b111111};
            remainder_0 = remainder_seg;
        end else if((opcode == AND) || (opcode == OR)||(opcode == XOR)||(opcode == NOT)) begin
            result_2 = result_bin_2;
            result_1 = result_bin_1;
            result_mul_0_remainder_sign = result_bin_0;
            remainder_0 = 7'b1111111;
        end else begin
            result_1 = result_seg;
            result_2 = {(result_sign),6'b111111};
            result_mul_0_remainder_sign = 7'b1111111;
            remainder_0 = 7'b1111111;
        end
    end


endmodule
