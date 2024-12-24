module div_4bit  (
    input [7:0] Z_in,
    input [3:0] D_in,
    input clk,
    input reset,
    input en,
    output reg [3:0] Q,
    output reg [3:0] R,
    output reg done,
    output reg [3:0] flag // o, z, s, c
);
    parameter OVERFLOW = 4'b1000;
    
    reg [6:0] div_counter;
    reg [4:0] correct_counter;
    
    reg signed [8:0] S; 
    reg signed [4:0] D; 
    reg signed [4:0] Q_t;   
    reg signed [4:0] D_c; // - D
    reg Z_in_sign;    

    always @(posedge clk) begin
        if(div_counter == 0) begin
            D_c <= ~D_in+1;
        end else begin
            D_c <= ~D + 1;
        end
        if(div_counter == 0) begin
            Z_in_sign <= Z_in[7];
        end else begin
            Z_in_sign <= Z_in_sign;
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            S <= 0;
            D <= 0;
            Q_t <= 0;
            div_counter <= 0;
            correct_counter <= 0;

            Q <= 0;
            R <= 0;
            done <= 0;
            flag <= 0;
        end else begin
            if(en) begin
                if(div_counter == 0) begin
                    if(D_in == 0) begin
                        S <= 0;
                        D <= 0;
                        Q_t <= 0;
                        div_counter <= 0;
                        correct_counter <= 0;

                        Q <= 0;
                        R <= 0;
                        done <= 1;
                        flag <= OVERFLOW;

                    end else begin
                        S <= {Z_in[7], Z_in}; 
                        D <= {D_in[3], D_in}; 
                        Q_t <= 0;
                        div_counter <= div_counter + 1;
                        correct_counter <= 0;

                        Q <= 0;
                        R <= 0;
                        done <= 0;
                        flag <= 0;
                    end

                end else if(correct_counter == 2) begin // tính xong sửa lại dấu
                    S <= 0;
                    D <= 0;
                    Q_t <= 0;
                    div_counter <= 0;
                    correct_counter <= 0;

                    Q <= Q_t[3:0];
                    R <= S[7:4];
                    done <= 1;
                    flag <= 0;  
                end else if((div_counter == 4) && (correct_counter != 0) && (correct_counter != 2)) begin // sửa cho đúng dấu
                    if(S[8] ^ D[4]) begin // sửa dấu
                        Q_t <= Q_t - 1;
                        S[8:4] <= S[8:4] + D;
                    end else begin
                        Q_t <= Q_t + 1;
                        S[8:4] <= S[8:4] + D_c;
                    end
                    div_counter <= div_counter;
                    correct_counter <= correct_counter + 1;
                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    flag <= 0;  

                end else if((div_counter == 4) && (correct_counter == 0)) begin // thực hiện xong phần chia -> sửa dấu
                    if(Z_in_sign ^ S[8]) begin // khác dấu thì phải sửa
                        S <= S;
                        D <= D;
                        Q_t[4] <= ~Q_t[3]; // sửa dấu
                        Q_t[3:1] <= Q_t[4-2:0]; // dịch trái
                        Q_t[0] <= 1;
                        div_counter <= div_counter;
                        correct_counter <= correct_counter + 1; // bắt đầu sửa dấu

                        Q <= 0;
                        R <= 0;
                        done <= 0;
                        flag <= 0;  

                    end else begin // dấu chuẩn thì là xong luôn
                        S <= 0;
                        D <= 0;
                        Q_t <= 0;
                        div_counter <= 0;
                        correct_counter <= 0;

                        Q <= Q_t[3:0];
                        R <= S[7:4];
                        done <= 1;
                        flag <= 0;   
                    end 
                    
                end else begin // thực hiện phần chia
                    if(S[8] ^ D[4]) begin // cùng dấu thì trừ, khác dấu thì cộng 
                        S[8:4] <= S[7:3] + D;
                        Q_t[0] <= 0; 
                    end else begin
                        S[8:4] <= S[7:3] + D_c;
                        Q_t[0] <= 1; 
                    end
                    S[3:0] <= {S[4-2:0],1'b0}; // dịch trái
                    Q_t[4:1] <= Q_t[3:0]; // dịch trái
                    D <= D; 
                    div_counter <= div_counter + 1;
                    correct_counter <= 0;

                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    flag <= 0;
                end
            end else begin
                    S <= 0;
                    D <= 0;
                    Q_t <= 0;
                    div_counter <= 0;
                    correct_counter <= 0;

                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    flag <= 0;
            end
        end
    end
endmodule