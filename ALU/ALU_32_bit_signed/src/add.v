module add(
    input [31:0] A_in,
    input [31:0] B_in,
    input Ctr_in, // 1: A - B, 0: A + B
    input en,
    input clk,
    output [31:0] S,
    output Cout,
    output reg done,
    output reg [3:0] flag
);  

    parameter OVERFLOW=3;
    parameter ZERO=2;
    parameter SIGN=1;
    parameter CARRY=0;

    reg [31:0] A;
    reg [31:0] B;
    reg Ctr;

    reg counter;

    always @(posedge clk) begin
        if(en) begin
            if(counter == 0) begin
                A <= A_in;
                Ctr <= Ctr_in;
                if(Ctr_in) begin
                    B <= ~B_in;
                end else begin
                    B <= B_in;
                end
                done <= 0;
                counter <= 1;
            end else begin
                if(Cout) begin
                    flag[CARRY] <= 1;
                    flag[OVERFLOW] <= 1;
                end else begin
                    flag[CARRY] <= 0;
                    flag[OVERFLOW] <= 0;
                end

                if(S[31]) begin
                    flag[SIGN] <= 1;
                end else begin
                    flag[SIGN] <= 0;
                end

                if(S == 0) begin
                    flag[ZERO] <= 1;
                end else begin
                    flag[ZERO] <= 0;
                end

                done <= 1;
                counter <= 0;
            end
        end else begin
            done <= 0;
            counter <= 0;
        end
    end

    genvar i;
    wire [6:0] Cout_temp;

    generate
        for(i = 0; i < 7; i = i + 1) begin : CLA_i_gen
            CLA CLA_i(
                .A(A[4*i+3:4*i]),
                .B(B[4*i+3:4*i]),
                .Cin(i == 0 ? Ctr : Cout_temp[i-1]),
                .S(S[4*i+3:4*i]),
                .Cout(Cout_temp[i])
            );
        end
        CLA CLA_7(
            .A(A[31:28]),
            .B(B[31:28]),
            .Cin(Cout_temp[6]),
            .S(S[31:28])
        );
    endgenerate

    assign Cout = A[31]&B[31]&(~S[31]) | (~A[31])&(~B[31])&S[31];

endmodule

module CLA(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);  
    
    wire [3:0] G;
    wire [3:0] P;

    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : P_G_gen
            assign G[i] = A[i] & B[i]; // Khả năng tạo Carry, bất kể đầu vào
            assign P[i] = A[i] | B[i]; // Khả năng lan truyền Carry
        end
    endgenerate

    wire [3:0] Gi_0;
    wire P3_0 = P[3] & P[2] & P[1] & P[0];

    genvar j;
    generate
        assign Gi_0[0] = G[0];
        for(j = 1; j < 4; j = j + 1) begin : Gi_gen
            assign Gi_0[j] = G[j] | (P[j] & Gi_0[j-1]);
        end
    endgenerate

    assign Cout = Gi_0[3] | (P3_0 & Cin);

    wire [2:0] Cout_temp;
    genvar k;
    generate
        FA Sum_0(
            .A(A[0]),
            .B(B[0]),
            .Cin(Cin),
            .S(S[0]),
            .Cout(Cout_temp[0])
        );
        for(k = 1; k < 3; k = k + 1) begin : Sum_gen
            FA Sum_i(
                .A(A[k]),
                .B(B[k]),
                .Cin(Cout_temp[k-1]), // Carry từ FA trước
                .S(S[k]),
                .Cout(Cout_temp[k])
            );
        end
        FA Sum_3(
            .A(A[3]),
            .B(B[3]),
            .Cin(Cout_temp[2]),
            .S(S[3])
        );
    endgenerate
endmodule  

module FA(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin); 
endmodule

