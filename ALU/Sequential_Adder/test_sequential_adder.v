module test_sequential_adder();

parameter WIDTH = 3;

    reg clk;
    reg rst;
    reg en;
    reg C_in;
    reg [WIDTH-1:0] A_in;
    reg [WIDTH-1:0] B_in;
    wire done;
    wire [WIDTH-1:0] S;
    wire C_out;

    sequential_adder #(
        .WIDTH(WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
        .C_in_input(C_in),
        .A_in(A_in),
        .B_in(B_in),
        .done(done),
        .S(S),
        .C_out(C_out)
    );

    integer i, j, k;
    integer error;
    always #1 clk = ~clk;

    initial begin
        clk <= 0;
        rst <= 1;
        en <= 0;
        C_in <= 0;
        A_in <= 0;
        B_in <= 0;
        error <= 0;

        #10;
        rst <= 0;
        en <= 1;
        #10;
        for(i = 0; i < 8; i = i + 1) begin
            for(j = 0; j < 8; j = j + 1) begin
                for(k = 0; k < 2; k = k + 1) begin
                    A_in <= i;
                    B_in <= j;
                    C_in <= k;
                    #10;
                end
            end
        end

        if(error == 0) begin
            $display("\t\t\t\t_____________All test PASSED_____________");
        end else begin
            $display("\t\t\t\t_____________%d test FAILED_____________", error);
        end
        #20 $finish;
    end

    always @(done) begin
        // $display("%t A_in = %d, B_in = %d, C_in = %d, S = %d, C_out = %d",$time, A_in, B_in, C_in, S, C_out);
        if(done) begin
            if(A_in + B_in + C_in != {C_out,S}) begin
                error = error + 1;
                $display("Error: A_in + B_in + C_in != S");
                $display("%t A_in = %d, B_in = %d, C_in = %d, S = %d, C_out = %d",$time, A_in, B_in, C_in, S, C_out);
            end
        end
        
    end
endmodule