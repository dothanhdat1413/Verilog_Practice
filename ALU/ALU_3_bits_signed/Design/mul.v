module mul #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    output [WIDTH*2-1:0] result, // cần gấp đôi số bit
    output [3:0] flag // o, z, s, c
);  

    wire [WIDTH-1:0] Sout [WIDTH:0]; // nhân số WIDTH bit thì cần WIDTH + 1 nhớ 
    wire [WIDTH-1:0] Cout [WIDTH:0];
    genvar i, j;

    generate// hàng thứ 0
        for(i = 0; i < WIDTH; i = i + 1) begin : CSA_1_0
            if(i != (WIDTH -1)) begin
                CSA #( .MAX(0))CSA_0 (
                    .A(num_1[0]),
                    .B(num_2[i]),
                    .Sin(0),
                    .Cin(0),
                    .Sout(Sout[0][i]),
                    .Cout(Cout[0][i])
                );
            end else begin
                CSA #( .MAX(1))CSA_0 (
                    .A(num_1[0]),
                    .B(num_2[i]),
                    .Sin(0),
                    .Cin(0),
                    .Sout(Sout[0][i]),
                    .Cout(Cout[0][i])
                );
            end
        end
    endgenerate

    generate// hàng thứ 1
        for(i = 0; i < WIDTH; i = i + 1) begin : CSA_1_1
            if(i != (WIDTH -1)) begin
                CSA #( .MAX(0))CSA_1 (
                    .A(num_1[1]),
                    .B(num_2[i]),
                    .Sin(Sout[0][i+1]), // (do dịch bit hàng hiện tại sang phải nên thẳng hàng sẽ là phần tử lớn hơn 1 cột hàng trước)
                    .Cin(Cout[0][i]),
                    .Sout(Sout[1][i]),
                    .Cout(Cout[1][i])
                );
            end else begin
                CSA #( .MAX(1))CSA_1 (
                    .A(num_1[1]),
                    .B(num_2[i]),
                    .Sin(1),          // (do dịch bit hàng hiện tại sang phải nên thẳng hàng sẽ là phần tử lớn hơn 1 cột hàng trước)
                    .Cin(Cout[0][i]), // cout đến từ phần tử cùng cột phía trước
                    .Sout(Sout[1][i]),
                    .Cout(Cout[1][i])
                );
            end
        end
    endgenerate

    generate  // hàng thứ 2 -> hàng thứ WIDTH -1
        for(j = 2; j < WIDTH; j = j + 1 ) begin  : CSA_i_1
            if(j != (WIDTH -1)) begin
                for(i = 0; i < WIDTH; i = i + 1) begin : CSA_i_2
                    if(i != (WIDTH -1)) begin
                        CSA #(.MAX(0))CSA (
                            .A(num_1[j]),
                            .B(num_2[i]),
                            .Sin(Sout[j-1][i]),
                            .Cin(Cout[j-1][i]),
                            .Sout(Sout[j][i]),
                            .Cout(Cout[j][i])
                        );
                    end else begin
                        CSA #( .MAX(1))CSA (
                            .A(num_1[j]),
                            .B(num_2[i]),
                            .Sin(Sout[j-1][i]),
                            .Cin(Sout[j-1][i]),
                            .Sout(Sout[j][i]),
                            .Cout(Cout[j][i])
                        );
                    end
                end
            end else begin
                for(i = 0; i < WIDTH; i = i + 1) begin : CSA_i_3
                    if(i != (WIDTH -1)) begin
                        CSA #(.MAX(1))CSA_i (
                            .A(num_1[j]),
                            .B(num_2[i]),
                            .Sin(Sout[j-1][i+1]),
                            .Cin(Cout[j-1][i]),
                            .Sout(Sout[j][i]),
                            .Cout(Cout[j][i])
                        );
                    end else begin
                        CSA #( .MAX(0))CSA_i (
                            .A(num_1[j]),
                            .B(num_2[i]),
                            .Sin(0),
                            .Cin(Cout[j-1][i]),
                            .Sout(Sout[j][i]),
                            .Cout(Cout[j][i])
                        );
                    end
                end
            end
        end
    endgenerate

    generate // hàng thứ WIDTH (nhân số dài WIDTH thì cần WIDTH + 1 hàng)
        CPA CPA(
            .num_1(Cout[WIDTH-1][0]),
            .num_2(Sout[WIDTH-1][1]),
            .c_in(0),
            .sum(Sout[WIDTH][0]),
            .c_out(Cout[WIDTH][0])
        );

        for(i = 1; i < WIDTH; i = i + 1) begin : CPA_end
            if(i != (WIDTH-1)) begin
                CPA CPA(
                    .num_1(Cout[WIDTH-1][i]),
                    .num_2(Sout[WIDTH-1][i+1]),
                    .c_in(Cout[WIDTH][i-1]),
                    .sum(Sout[WIDTH][i]),
                    .c_out(Cout[WIDTH][i])
                );
            end else begin
                CPA CPA(
                    .num_1(Cout[WIDTH-1][i]),
                    .num_2(1),
                    .c_in(Cout[WIDTH][i-1]),
                    .sum(Sout[WIDTH][i]),
                    .c_out(Cout[WIDTH][i])
                );
            end
        end
    endgenerate

    generate // kết quả
        for(i = 0; i < WIDTH; i = i + 1) begin: result_1
            assign result[i] = Sout[i][0];
        end

        for(i = WIDTH; i < WIDTH*2; i = i + 1) begin: result_1_0
            assign result[i] = Sout[WIDTH][i-WIDTH];
        end
    endgenerate

    assign flag[0] = 0;
    assign flag[1] = result[WIDTH*2-1];
    assign flag[2] = (result == 0) ? 1'b1 : 1'b0;
    assign flag[3] = 0;

endmodule