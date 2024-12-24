module test_adder();

    reg signed [31:0] A;
    reg signed [31:0] B;
    reg Ctr;
    wire signed [31:0] S;
    wire Cout;

    adder DUT(
        .A(A),
        .B_in(B),
        .Ctr(Ctr),
        .S(S),
        .Cout(Cout)
    );

    wire signed [31:0] S_mul;
    wire Cout_mul;
    adder_mul DUT_mul(
        .A(A),
        .B(B),
        .Ctr(Ctr),
        .S(S_mul),
        .Cout(Cout_mul)
    );

    reg signed [31:0] input_A [1:0]; // Dùng buffer để lưu dữ liệu tạm thời
    reg signed [31:0] input_B; // Dùng buffer để lưu dữ liệu tạm thời
    reg signed [31:0] input_S; // Dùng buffer để lưu dữ liệu tạm thời
    integer file_A, file_B, file_S, i, read_count_A, read_count_B, read_count_S;

    // initial begin
    //     $readmemh("file_A.txt",input_A);
    //     A = input_A[1];
    //     B = input_A[0];
    //     Ctr = 0;
    //     #10
    //     Ctr = 1;
    //     #10
    //     $finish;
    // end
    // always @(*) begin
    //         $display("%d %d = %d, Cout = %d", A, B, S, Cout);
    //         $display("%d %d = %d, Cout = %d", A, B, S_mul, Cout_mul);
    // end
    

    reg signed [2:0] A_t;
    reg signed [2:0] B_t;
    reg [2:0] counter;
    reg reset;

    reg [4:0] temp;
    wire temp_s = temp[4];
    reg clk;
    always #1 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        A_t = -4;
        B_t = 2;
        #10 
        reset = 0;
        #20
        $finish;
    end
    reg done;
    always @(posedge clk) begin
        if(reset) begin
            counter <= 0;
            temp <= 0;
            done <= 0;
        end else begin
            if(counter == 0) begin
                temp[4:3] <= 0;
                temp[2:0] <= B_t;
                counter <= counter + 1;
                done <= 0;
            end else if (counter == 2) begin
                if(temp[0] == 1)begin
                    temp[1:0] <= temp[2:1];
                    temp[4:2] <= {temp_s, temp[4:3]} - A_t;
                end else begin
                    temp <= temp;
                end
                counter <= 0;
                done <= 1;
            end else begin
                if(temp[0]) begin 
                    temp[1:0] <= temp[2:1];
                    temp[4:2] <= {temp_s, temp[4:3]} + A_t;
                end else begin
                    temp <= temp >> 1;
                end
                counter <= counter + 1;
                done <= 0;
            end
        end
    end

    always @(*) begin
        if(done) begin
            $display("%bx%b = %d", A_t, B_t, {temp_s,temp});
        end
    end

endmodule