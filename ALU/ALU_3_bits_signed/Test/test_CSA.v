module test_CSA();
    reg A;
    reg B;
    reg Cin;
    reg Sin;
    wire Cout_0;
    wire Sout_0;
    wire Cout_1;
    wire Sout_1;

    CSA #(
        .MAX(0)
    ) csa_1(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sin(Sin),
        .Cout(Cout_0),
        .Sout(Sout_0)
    );

    CSA #(
        .MAX(1)
    ) csa_2(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sin(Sin),
        .Cout(Cout_1),
        .Sout(Sout_1)
    );

    integer i, j, k, l;
    initial begin
        for(i = 0; i < 2; i = i + 1)
            for(j = 0; j < 2; j = j + 1)
                for(k = 0; k < 2; k = k + 1)
                    for(l = 0; l < 2; l = l + 1) begin
                        A = i;
                        B = j;
                        Cin = k;
                        Sin = l;
                        #10;
                    end
    end

    always @(*) begin
        $display("A = %d, B = %d, Cin = %d, Sin = %d, Cout_0 = %d, Sout_0 = %d, Cout_1 = %d, Sout_1 = %d", A, B, Cin, Sin, Cout_0, Sout_0, Cout_1, Sout_1);
    end


endmodule