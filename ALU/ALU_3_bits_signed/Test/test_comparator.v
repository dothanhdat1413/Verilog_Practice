module test_comparator ();

    reg [2:0] num_1;
    reg [2:0] num_2;
    wire [1:0] result;

    comparator #(.WIDTH(3))DUT(
        .num_1(num_1),
        .num_2(num_2),
        .result(result) 
    );
    parameter EQUAL = 2'b00;
    parameter LARGER = 2'b01; // num_1 > num_2
    parameter SMALLER = 2'b10; // num_1 < num_2

    integer i,j;
    
    wire [1:0] expected_result = (num_1 == num_2) ? 2'b00 :((num_1 > num_2) ? 2'b01 : 2'b10);


    initial begin
        for(i = 0; i < 8; i = i + 1) begin
            for(j = 0; j < 8; j = j + 1) begin
                num_1 = i;
                num_2 = j;
                #10;
                case(result)
                    EQUAL: begin
                        $display("num_1 = %d, num_2 = %d, result = EQUAL", num_1, num_2);
                    end
                    LARGER: begin
                        $display("num_1 = %d, num_2 = %d, result = LARGER", num_1, num_2);
                    end
                    SMALLER: begin
                        $display("num_1 = %d, num_2 = %d, result = SMALLER", num_1, num_2);
                    end
                endcase
            end
        end
    end

    always @(num_1 or num_2) begin
        if(result != expected_result) begin
            $display("Error: num_1 = %d, num_2 = %d, result = %d, expected_result = %d", num_1, num_2, result, expected_result);
        end
    end



endmodule