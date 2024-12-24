module test_ALU();

    reg signed [2:0] num_1;
    reg signed [2:0] num_2;
    reg [3:0] opcode;
    wire signed [2:0] result;
    wire [3:0] flag;
    wire signed [5:0] result_mul;
    wire signed [2:0] remainder;

    ALU ALU(
        .num_1(num_1),
        .num_2(num_2),
        .opcode(opcode),
        .result(result),
        .result_mul(result_mul),
        .remainder(remainder),
        .flag(flag)
    );

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

    integer i, j;
    initial begin
        opcode = ADD;

        for(i =-4; i < 4; i = i + 1) begin
            for(j =-4; j < 4; j = j + 1) begin
                    num_1 = i;
                    num_2 = j;
                    #10;
                $display("ADD num_1 = %d, num_2 = %d, result = %d, expected result = %d, flag = %b", num_1, num_2, result, (num_1+num_2),flag);
            end
        end

        opcode = SUB;

        for(i =-4; i < 4; i = i + 1) begin
            for(j =-4; j < 4; j = j + 1) begin
                    num_1 = i;
                    num_2 = j;
                    #10;
                $display("SUB num_1 = %d, num_2 = %d, result = %d, expected result = %d, flag = %b", num_1, num_2, result,(num_1 - num_2 ), flag);
            end
        end 

        opcode = MUL;

        for(i =-4; i < 4; i = i + 1) begin
            for(j =-4; j < 4; j = j + 1) begin
                    num_1 = i;
                    num_2 = j;
                    #10;
                $display("MUL num_1 = %d, num_2 = %d, result_mul = %d, expected result = %d, flag = %b", num_1, num_2, result_mul, (num_1*num_2), flag);
            end
        end

        opcode = DIV;

        for(i =-4; i < 4; i = i + 1) begin
            for(j =-4; j < 4; j = j + 1) begin
                    num_1 = i;
                    num_2 = j;
                    #10;
                $display("DIV num_1 = %d, num_2 = %d, result = %d, remainder = %d, expected result = %d, expected remainder = %d, flag = %b", num_1, num_2, result, remainder, (num_1 / num_2), (num_1 - (num_1/num_2) * num_2), flag);
            end
        end

    end
endmodule