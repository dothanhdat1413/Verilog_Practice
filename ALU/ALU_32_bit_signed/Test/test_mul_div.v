module test_mul_div();
    parameter WIDTH = 32;

    reg signed [WIDTH-1:0] M_in;
    reg signed [WIDTH-1:0] Q_in;

    // reg signed [3:0] M_in;
    // reg signed [3:0] Q_in;


    reg clk;
    reg reset;
    reg en;
    reg en_shr;
    wire signed [WIDTH*2-1:0] A_out;
    wire signed [WIDTH*2-1:0] A_out_shr;
    // wire signed [7:0] A_out;

    wire done;
    wire done_shr;
    mul_shl DUT(
        .M_in(M_in),
        .Q_in(Q_in),
        .clk(clk),
        .reset(reset),
        .en(en_shr),
        .done(done_shr),
        .A_out(A_out_shr),
        .flag(flag)
    );

    mul_booth_mod DUT_booth(
        .M_in(M_in),
        .Q_in(Q_in),
        .clk(clk),
        .reset(reset),
        .en(en),
        .done(done),
        .A_out(A_out)
    );

    // reg signed [7:0] Z_in;
    // reg signed [3:0] D_in;
    // wire signed [3:0] Q;
    // wire signed [3:0] R;

    reg signed [WIDTH*2-1:0] Z_in;
    reg signed [WIDTH-1:0] D_in;
    wire signed [WIDTH-1:0] Q;
    wire signed [WIDTH-1:0] R;
    wire [3:0] div_flag;
    wire done_div;

    div  #(
        .WIDTH(WIDTH)
    ) DUT_div(
        .Z_in(Z_in),
        .D_in(D_in),
        .clk(clk),
        .reset(reset),
        .en(en),
        .Q(Q),
        .R(R),
        .done(done_div),
        .flag(div_flag)
    );

/* // test 4 bit mul_booth_mod
    mul_booth_mod_4bit DUT_booth(
        .M_in(M_in),
        .Q_in(Q_in),
        .clk(clk),
        .reset(reset),
        .en(en),
        .done(done),
        .A_out(A_out),
        .flag(flag)
    );
*/
    always #1 clk = ~clk;
/* // test mul
    initial begin
        clk = 0;
        reset = 1;
        en = 0;
        en_shr = 0;
        #10
        reset = 0;
        en = 1;
        en_shr = 1;
        M_in = 6;
        Q_in = -6;
        #37 en = 0;
        #30;

        en = 1;
        M_in = 7;
        Q_in = -7;
        #37 en = 0;
        #30;
        M_in = 10;
        Q_in = -10;
        #37 en = 0;
        #30;
        M_in = -151;
        Q_in = -10000;
        #100 $finish;
    end

    always @(*) begin
        if(done) begin
            $display("%t A_out = %d",$time, A_out);
        end
        if(done_shr) begin
            $display("%t A_out_shr = %d",$time, A_out_shr);
        end
    end
*/

// /* test div 4 bit
    initial begin
        clk = 1;
        reset = 1;
        en = 0;
        Z_in = 9;
        D_in = -4;

        print_output(Z_in, D_in, Q, R, done_div);


        #10 reset = 0;
        en = 1;
        Z_in = 9;
        D_in = 0;
        print_output(Z_in, D_in, Q, R, done_div);
        #100;
                print_output(Z_in, D_in, Q, R, done_div);
        #10;
        Z_in = 8;
        D_in = 4;
        print_output(Z_in, D_in, Q, R, done_div);
        #10 $finish;

    end

    // always @(*) begin
    //     if(done_div) begin
    //         #1; 
    //         if(div_flag == 4'b1000) begin
    //             $display("\t\t\t\t_________________OVERFLOW_________________");
    //         end
    //         $display("%t Z= %d, D = %d, Q = %d, R = %d",$time,Z_in, D_in, Q, R);

    //     end
    // end
// */
    task print_output; 
        input signed [WIDTH*2-1:0] Z_in;
        input signed [WIDTH-1:0] D_in;
        input signed [WIDTH-1:0] Q;
        input signed [WIDTH-1:0] R;
        input done_div;
    begin
        while(done_div == 0) begin
            #1;
        end
        if(div_flag == 4'b1000) begin
        $display("\t\t\t\t_________________OVERFLOW_________________");
        end else begin
        $display("%t Z= %d, D = %d, Q = %d, R = %d",$time,Z_in, D_in, Q, R);
        end
    end 
    endtask

endmodule