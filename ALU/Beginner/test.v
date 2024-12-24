`timescale 1ns/1ns
module test_ALU();
    reg [7:0] num1, num2;
    reg [2:0] op;
    wire [7:0] result;
    wire cf, zf, of;

    ALU DUT(
        .num1(num1),
        .num2(num2),
        .op(op),
        .result(result),
        .cf(cf),
        .zf(zf),
        .of(of)
    );

    integer i, j, k; 
    initial begin
        $display("___________________________Bruteforce test____________________________");
        #10;
        for( i = 0; i < 256; i = i + 1) begin
            #10;
            num1 <= i[7:0]; // chỉ lấy 8 bit 
            for( j = 0; j < 256; j = j + 1)begin
                #10;
                num2 <= j[7:0];
                for( k = 0; k < 4; k = k + 1)begin
                    #10;
                    op <= k[2:0];
                end
            end
        end
    end

    reg borrow;

    always @ (num1, num2, op) begin
        case(op)
            3'b000: begin : add_num
                if(({cf,result} != num1 + num2) && (of != cf) && (zf != (result == 0) ) )begin
                    $display("Sum error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
            end
            3'b001: begin : subtract_num
                if(({borrow,result} != num1 - num2) && (cf != borrow) && (zf != (result == 0)) && (of != 0)) begin
                    $display("Subtract error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end 
            end
            3'b010: begin : divide_num
                if((result != num1 / num2) && (of != ~of) && (zf != (result == 0)) && (cf != 0)) begin
                    $display("Devide error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end 
            end            
            3'b011: begin : multiply_bit
                if((result != (num1 & num2)) && (zf != 0) && (of != 0) && (cf != 0)) begin
                        $display("Bit multiply error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
            end
            3'b100: begin : add_bit
                if((result != num1 | num2) && (zf != (result == 0)) && (of != 0) && (cf != 0)) begin
                        $display("Bit add error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
                
            end 
            3'b101: begin : xor_bit
                if((result != num1 ^ num2) && (zf != (result == 0)) && (of != 0) && (cf != 0)) begin
                        $display("Bit xor error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
            end
            3'b110: begin : compare_equal
                if((result != (num1 == num2) ? 1 : 0) && (zf != (result == 0)) && (of != 0) && (cf != 0)) begin
                        $display("Bit compare error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
            end
            3'b111: begin : compare_larger
                if((result != (num1 > num2) ? 1 : 0) && (zf != (result == 0)) && (of != 0) && (cf != 0)) begin
                        $display("Bit compare error: num1 = %b, num2 = %b, result = %b, carry = %b, iszero= %b, overflow = %b", num1, num2, result, cf, zf, of);
                end
            end
        endcase
        $display("___________________________End test____________________________");
    end
endmodule