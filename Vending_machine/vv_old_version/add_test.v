`timescale 1ps/1ps
module test_add();
    reg [3:0] num_0;
    reg [3:0] num_1;
    reg c_in;
    reg en;

    wire [3:0] sum;

    add adder(
        .num_0(num_0),
        .num_1(num_1),
        .c_in(c_in),
        .en(en),
        .sum(sum)
    );
    always #2 en = ~en;
    initial begin
        en = 0;
        #10;
        num_0 = 4'b0000;
        num_1 = 4'b0000;
        c_in = 0;
        #20;
        num_0 = 4'b0100;
        num_1 = 4'b0100;
        c_in = 1'b1;
        #20;
        num_0 = 4'b0101;
        num_1 = 4'b0101;
        c_in = 1'b0;
        $finish;
    end

    always @(num_0, num_1, c_in) begin
        #5;
        if(sum != ((num_1+num_0+c_in) % 10)) begin
            $display("ERROR, num_0: %d, num_1: %d, c_in: %d, sum: %d", num_0, num_1, c_in, sum);
        end
        else 
            $display("OK, num_0: %d, num_1: %d, c_in: %d, sum: %d", num_0, num_1, c_in, sum);
    end
endmodule