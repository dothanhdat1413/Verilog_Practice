module test_unit();

parameter DUT_CHOOSE = 0;
// 0: ADD
// 1: SUB
// 2: MUL
// 3: DIV 

parameter ADD_A_SIZE = 1000;
parameter ADD_B_SIZE = 1000;
parameter ADD_C_SIZE = 1000;
parameter ADD_Cout_SIZE = 1000;
parameter ADD_A_WIDTH = 32;
parameter ADD_B_WIDTH = 32;
parameter ADD_C_WIDTH = 32;
parameter ADD_Cout_WIDTH = 1;

parameter SUB_A_SIZE = 1000;
parameter SUB_B_SIZE = 1000;
parameter SUB_C_SIZE = 1000;
parameter SUB_Cout_SIZE = 1000;
parameter SUB_A_WIDTH = 32;
parameter SUB_B_WIDTH = 32;
parameter SUB_C_WIDTH = 32;
parameter SUB_Cout_WIDTH = 1;

parameter MUL_M_SIZE = 1000;
parameter MUL_Q_SIZE = 1000;
parameter MUL_A_SIZE = 1000;
parameter MUL_M_WIDTH = 32;
parameter MUL_Q_WIDTH = 32;
parameter MUL_A_WIDTH = 64;

parameter DIV_Z_SIZE = 1000;
parameter DIV_D_SIZE = 1000;
parameter DIV_Q_SIZE = 1000;
parameter DIV_R_SIZE = 1000;
parameter DIV_Z_WIDTH = 64;
parameter DIV_D_WIDTH = 32;
parameter DIV_Q_WIDTH = 32;
parameter DIV_R_WIDTH = 32;

parameter INPUT_A_32        = "./input_data/ADD&SUB_input_A.txt";
parameter INPUT_B_32        = "./input_data/ADD&SUB_input_B.txt";
parameter OUTPUT_C_ADD      = "./input_data/ADD_output_C.txt";
parameter OUTPUT_Cout_ADD   = "./input_data/ADD_output_Cout.txt";
parameter OUTPUT_C_SUB      = "./input_data/SUB_output_C.txt";
parameter OUTPUT_Cout_SUB   = "./input_data/SUB_output_Cout.txt";

parameter INPUT_M_MUL       = "./input_data/MUL_input_M.txt";
parameter INPUT_Q_MUL       = "./input_data/MUL_input_Q.txt";
parameter OUTPUT_A_MUL      = "./input_data/MUL_output_A.txt";

parameter INPUT_Z_DIV       = "./input_data/DIV_input_Z.txt";
parameter INPUT_D_DIV       = "./input_data/DIV_input_D.txt";
parameter OUTPUT_Q_DIV      = "./input_data/DIV_output_Q.txt";
parameter OUTPUT_R_DIV      = "./input_data/DIV_output_R.txt";
parameter OUTPUT_FLAG_OVERFLOW_DIV = "./input_data/DIV_flag_overflow.txt";

reg clk;
always #1 clk = ~clk;
reg reset;
reg en;

reg signed [ADD_A_WIDTH-1:0] ADD_input_A [0:(ADD_A_SIZE-1)];
reg signed [ADD_B_WIDTH-1:0] ADD_input_B [0:(ADD_B_SIZE-1)];
reg signed [ADD_C_WIDTH-1:0] ADD_output_C [0:(ADD_C_SIZE-1)];
reg signed ADD_output_Cout [0:(ADD_Cout_SIZE-1)];

reg signed [SUB_A_WIDTH-1:0] SUB_input_A [0:(SUB_A_SIZE-1)];
reg signed [SUB_B_WIDTH-1:0] SUB_input_B [0:(SUB_B_SIZE-1)];
reg signed [SUB_C_WIDTH-1:0] SUB_output_C [0:(SUB_C_SIZE-1)];
reg signed SUB_output_Cout [0:(SUB_Cout_SIZE-1)];

reg signed [MUL_M_WIDTH-1:0] MUL_input_M [0:(MUL_M_SIZE-1)];
reg signed [MUL_Q_WIDTH-1:0] MUL_input_Q [0:(MUL_Q_SIZE-1)];
reg signed [MUL_A_WIDTH-1:0] MUL_output_A [0:(MUL_A_SIZE-1)];

reg signed [DIV_Z_WIDTH-1:0] DIV_input_Z [0:(DIV_Z_SIZE-1)];
reg signed [DIV_D_WIDTH-1:0] DIV_input_D [0:(DIV_D_SIZE-1)];
reg signed [DIV_Q_WIDTH-1:0] DIV_output_Q [0:(DIV_Q_SIZE-1)];
reg signed [DIV_R_WIDTH-1:0] DIV_output_R [0:(DIV_R_SIZE-1)];
reg DIV_flag_overflow [0:(DIV_R_SIZE-1)];

reg signed [ADD_A_WIDTH-1:0] ADD_DUT_input_A;
reg signed [ADD_B_WIDTH-1:0] ADD_DUT_input_B;
wire signed [ADD_C_WIDTH-1:0] ADD_DUT_output_C;
wire signed ADD_DUT_output_Cout;

reg signed [SUB_A_WIDTH-1:0] SUB_DUT_input_A;
reg signed [SUB_B_WIDTH-1:0] SUB_DUT_input_B;
wire signed [SUB_C_WIDTH-1:0] SUB_DUT_output_C;
wire signed SUB_DUT_output_Cout;

reg signed [MUL_M_WIDTH-1:0] MUL_DUT_input_M;
reg signed [MUL_Q_WIDTH-1:0] MUL_DUT_input_Q;
wire signed [MUL_A_WIDTH-1:0] MUL_DUT_output_A;
wire MUL_DUT_done;

reg signed [DIV_Z_WIDTH-1:0] DIV_DUT_input_Z;
reg signed [DIV_D_WIDTH-1:0] DIV_DUT_input_D;
wire signed [DIV_Q_WIDTH-1:0] DIV_DUT_output_Q;
wire signed [DIV_R_WIDTH-1:0] DIV_DUT_output_R;
wire DIV_DUT_done;
wire [3:0] DIV_DUT_flag;
parameter OVERFLOW_BIT = 3;

adder ADD_DUT(
    .A(ADD_DUT_input_A),
    .B_in(ADD_DUT_input_B),
    .Ctr(1'b0),
    .S(ADD_DUT_output_C),
    .Cout(ADD_DUT_output_Cout)
);

adder SUB_DUT(
    .A(SUB_DUT_input_A),
    .B_in(SUB_DUT_input_B),
    .Ctr(1'b1),
    .S(SUB_DUT_output_C),
    .Cout(SUB_DUT_output_Cout)
);

mul MUL_DUT(
    .M_in(MUL_DUT_input_M),
    .Q_in(MUL_DUT_input_Q),
    .clk(clk),
    .reset(reset),
    .en(en),
    .done(MUL_DUT_done),
    .A_out(MUL_DUT_output_A)
);

div #(.WIDTH(DIV_D_WIDTH))DIV_DUT(
    .Z_in(DIV_DUT_input_Z),
    .D_in(DIV_DUT_input_D),
    .clk(clk),
    .reset(reset),
    .en(en),
    .done(DIV_DUT_done),
    .Q(DIV_DUT_output_Q),
    .R(DIV_DUT_output_R),
    .flag(DIV_DUT_flag)
);

integer i;
integer ADD_ERROR = 0;
integer SUB_ERROR = 0;
integer MUL_ERROR = 0;
integer DIV_ERROR = 0;

initial begin
    clk = 0;
    reset = 1;
    en = 0;
// /*
    $readmemh(INPUT_A_32, ADD_input_A);
    $readmemh(INPUT_B_32, ADD_input_B);
    $readmemh(OUTPUT_C_ADD, ADD_output_C);
    $readmemh(OUTPUT_Cout_ADD, ADD_output_Cout);

    $readmemh(INPUT_A_32, SUB_input_A);
    $readmemh(INPUT_B_32, SUB_input_B);
    $readmemh(OUTPUT_C_SUB, SUB_output_C);
    $readmemh(OUTPUT_Cout_SUB, SUB_output_Cout);

    $readmemh(INPUT_M_MUL, MUL_input_M);
    $readmemh(INPUT_Q_MUL, MUL_input_Q);
    $readmemh(OUTPUT_A_MUL, MUL_output_A);

    $readmemh(INPUT_Z_DIV, DIV_input_Z);
    $readmemh(INPUT_D_DIV, DIV_input_D);
    $readmemh(OUTPUT_Q_DIV, DIV_output_Q);
    $readmemh(OUTPUT_R_DIV, DIV_output_R);
    $readmemh(OUTPUT_FLAG_OVERFLOW_DIV, DIV_flag_overflow);
// */
// /*
    // for(i = 0; i < ADD_A_SIZE; i = i + 1) begin
    //     ADD_DUT_input_A = ADD_input_A[i];
    //     ADD_DUT_input_B = ADD_input_B[i];
    //     #3;
    //     if(ADD_DUT_output_C != ADD_output_C[i] || ADD_DUT_output_Cout != ADD_output_Cout[i]) begin
    //         if(ADD_DUT_output_Cout != ADD_output_Cout[i]) begin
    //             ADD_ERROR = ADD_ERROR + 1;
    //             // $display("%t ADD test failed at %d line",$time, i+1);
    //             // $display("Input: %h + %h = %d Carry out %b", ADD_DUT_input_A, ADD_DUT_input_B, ADD_DUT_output_C, ADD_DUT_output_Cout);
    //             // $display("Expected output: %h %h", ADD_output_C[i], ADD_output_Cout[i]);
    //         end else if (ADD_output_Cout[i] == 0) begin // không bị overflow
    //             ADD_ERROR = ADD_ERROR + 1;
    //             // $display("%t ADD test failed at %d line (NO Carry out)",$time, i+1);
    //             // $display("Input: %h + %h = %h Carry out %b", ADD_DUT_input_A, ADD_DUT_input_B, ADD_DUT_output_C, ADD_DUT_output_Cout);
    //             // $display("Expected output: %h %h", ADD_output_C[i], ADD_output_Cout[i]);
    //         end
    //     end
    //     #2;
    // end
    // if(ADD_ERROR == 0) begin
    //     $display($time,"______________________________________________ADD test passed___________________________________________");
    // end else begin
    //     $display("___________________________________________ADD passed %d/%d test cases___________________________________", ADD_A_SIZE - ADD_ERROR, ADD_A_SIZE);
    // end

    // for(i = 0; i < SUB_A_SIZE; i = i + 1) begin
    //     SUB_DUT_input_A = SUB_input_A[i];
    //     SUB_DUT_input_B = SUB_input_B[i];
    //     #3;
    //     if(SUB_DUT_output_C != SUB_output_C[i] || SUB_DUT_output_Cout != SUB_output_Cout[i]) begin
    //         if(SUB_DUT_output_Cout != SUB_output_Cout[i]) begin
    //             SUB_ERROR = SUB_ERROR + 1;
    //             // $display("%t SUB test failed at %d line",$time, i+1);
    //             // $display("Input: %h - %h = %h Carry out %b", SUB_DUT_input_A, SUB_DUT_input_B, SUB_DUT_output_C, SUB_DUT_output_Cout);
    //             // $display("Expected output: %h %h", SUB_output_C[i], SUB_output_Cout[i]);
    //         end else if (SUB_output_Cout[i] == 0) begin // không bị overflow
    //             SUB_ERROR = SUB_ERROR + 1;
    //             // $display("%t SUB test failed at %d line (NO Carry out)",$time, i+1);
    //             // $display("Input: %h - %h = %h Carry out %b", SUB_DUT_input_A, SUB_DUT_input_B, SUB_DUT_output_C, SUB_DUT_output_Cout);
    //             // $display("Expected output: %h %h", SUB_output_C[i], SUB_output_Cout[i]);
    //         end
    //     end
    //     #2;
    // end

    // if(SUB_ERROR == 0) begin
    //     $display("______________________________________________SUB test passed___________________________________________");
    // end else begin
    //     $display("___________________________________________SUB passed %d/%d test cases___________________________________", SUB_A_SIZE - SUB_ERROR, SUB_A_SIZE);
    // end
// */   
// /*   
        #1;
        reset = 0;
        en = 1;
    for(i = 0; i < MUL_M_SIZE; i = i + 1) begin
        #1;
        MUL_DUT_input_M = MUL_input_M[i];
        MUL_DUT_input_Q = MUL_input_Q[i];
        #2;
        while(MUL_DUT_done == 0) begin
            // #1;
        end
        if(MUL_DUT_output_A != MUL_output_A[i]) begin
            MUL_ERROR = MUL_ERROR + 1;
            $display("%t MUL test failed at %d line",$time, i+1);
            $display("Input: %h * %h = %h", MUL_DUT_input_M, MUL_DUT_input_Q, MUL_DUT_output_A);
            $display("Expected output: %h", MUL_output_A[i]);
        end
        #1;
    end

    if(MUL_ERROR == 0) begin
        $display("______________________________________________MUL test passed___________________________________________");
    end else begin
        $display("___________________________________________MUL passed %d/%d test cases___________________________________", MUL_M_SIZE - MUL_ERROR, MUL_M_SIZE);
    end
// */
    #4;
    en = 1;
    reset = 0;
    // /*
    DIV_DUT_input_Z = DIV_input_Z[0];
    DIV_DUT_input_D = DIV_input_D[0];
            // $display("DIV_DUT_input_Z = %h, DIV_DUT_input_D = %h, INPUT DATA: %h %h\n", DIV_DUT_input_Z, DIV_DUT_input_D, DIV_input_Z[0], DIV_input_D[0]);
    #1;
    i = 0;
    for(i = 0; i < DIV_Z_SIZE; i = i + 1) begin
        if(DIV_DUT_done == 1) begin
            DIV_DUT_input_Z = DIV_input_Z[i];
            DIV_DUT_input_D = DIV_input_D[i];
            en = 1; 
        end
        #4;
            // $display("DIV_DUT_input_Z = %h, DIV_DUT_input_D = %h, INPUT DATA: %h %h\n", DIV_DUT_input_Z, DIV_DUT_input_D, DIV_input_Z[i], DIV_input_D[i]);
            // #1;
        while(DIV_DUT_done != 1) begin
            // $display (" %t i = %d DIV_DUT_done = %d CALCULATING...",$time, i, DIV_DUT_done);
            #1;
        end

        if(DIV_DUT_output_Q != DIV_output_Q[i] || DIV_DUT_output_R != DIV_output_R[i] || DIV_DUT_flag[OVERFLOW_BIT] != DIV_flag_overflow[i])   begin
            if(DIV_DUT_flag[OVERFLOW_BIT] != DIV_flag_overflow[i]) begin
                DIV_ERROR = DIV_ERROR + 1;
                $display("%t DIV test failed at i = %d, at %d line, Expected OVERFLOW = %d",$time, i, i+1, DIV_flag_overflow[i]);
                $display("DUT output: %h (%d) / %h (%d) = %h (%d) R %h (%d), OVERFLOW = %d", DIV_DUT_input_Z, DIV_DUT_input_Z, DIV_DUT_input_D, DIV_DUT_input_D, DIV_DUT_output_Q, DIV_DUT_output_Q, DIV_DUT_output_R, DIV_DUT_output_R, DIV_DUT_flag[OVERFLOW_BIT]);
                $display("Expected output: Q =  %h (%d); R = %h (%d), OVERFLOW = %d", DIV_output_Q[i], DIV_output_Q[i], DIV_output_R[i], DIV_output_R[i], DIV_flag_overflow[i]);
            end else if(DIV_flag_overflow[i] == 0) begin
                DIV_ERROR = DIV_ERROR + 1;
                $display("%t DIV test failed at i = %d, at %d line (NO OVERFLOW)",$time, i, i+1);
                $display("DUT output: %h (%d) / %h (%d) = %h (%d) R %h (%d), OVERFLOW = %d", DIV_DUT_input_Z, DIV_DUT_input_Z, DIV_DUT_input_D, DIV_DUT_input_D, DIV_DUT_output_Q, DIV_DUT_output_Q, DIV_DUT_output_R, DIV_DUT_output_R, DIV_DUT_flag[OVERFLOW_BIT]);
                $display("Expected output: Q =  %h (%d); R = %h (%d), OVERFLOW = %d", DIV_output_Q[i], DIV_output_Q[i], DIV_output_R[i], DIV_output_R[i], DIV_flag_overflow[i]);
            end
        end
    end

    if(DIV_ERROR == 0) begin
        $display("______________________________________________DIV test passed___________________________________________");
    end else begin
        $display("___________________________________________DIV passed %d/%d test cases___________________________________", DIV_Z_SIZE - DIV_ERROR, DIV_Z_SIZE);
    end

    $finish;

end

endmodule