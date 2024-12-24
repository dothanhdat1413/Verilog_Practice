module ALU (
    input [7:0] num1, num2,
    input [2:0] op,
    output reg [7:0] result,
    output reg cf, zf, of
);
    task fulladd;
        input num1, num2, c_in;
        output sum, c_out;
            begin
                sum = num1 ^ num2 ^ c_in;
                c_out = (num1 & num2) | (num1 & c_in) | (num2 & c_in);
            end
    endtask

    always @ (num1, num2, op) begin
        case(op)
            3'b000: begin : add_num
                {cf,result} = num1 + num2;
                of = cf;
                zf = (result == 0);
            end
            3'b001: begin : subtract_num
                reg borrow;
                {borrow,result} = num1 - num2;
                cf = borrow;
                zf = (result == 0);
                of = 0; 
            end
            3'b010: begin : divide_num
                reg [7:0] R;
                reg [7:0] R_t;
                integer i;
                R = R << 8;
                R_t = R_t << 8;
                if(num2 == 0) begin 
                    result = 2'hFF; 
                    of = 1; 
                end else begin
                    for(i = 15; i >= 0; i = i - 1)begin
                        R={R_t << 1, num1[i]};
                        if(R >= num2)begin
                            R_t = R - num2;
                            result[i] = 1;
                        end else begin
                            R_t = R;
                            result[i] = 0;
                        end
                    end
                    of = 0;
                end
                zf = (result == 0);
                cf = 0;
            end
            3'b011: begin : multiply_bit
                result = num1 & num2;
                zf = 0;
                of = 0;
                cf = 0; 
            end
            3'b100: begin : add_bit
                result = num1 | num2;
                zf = (result == 0);
                of = 0;
                cf = 0;
            end 
            3'b101: begin : xor_bit
                result = num1 ^ num2;
                zf = (result == 0);
                of = 0;
                cf = 0;
            end
            3'b110: begin : compare_equal
                result = (num1 == num2) ? 1 : 0;
                zf = (result == 0);
                of = 0;
                cf = 0;
            end
            3'b111: begin : compare_larger
                result = (num1 > num2) ? 1 : 0;
                zf = (result == 0);
                of = 0;
                cf = 0;
            end
        endcase
    end
endmodule

