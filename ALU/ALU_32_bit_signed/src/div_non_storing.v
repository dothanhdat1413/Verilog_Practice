module div #(
        parameter WIDTH = 32
    )(
    input [2*WIDTH-1:0] Z_in,
    input [WIDTH-1:0] D_in,
    input clk,
    input reset,
    input en,
    output reg [WIDTH-1:0] Q,
    output reg [WIDTH-1:0] R,
    output reg done,
    output reg [3:0] flag // o, z, s, c
);

    parameter OVERFLOW=3;
    parameter ZERO=2;
    parameter SIGN=1;
    parameter CARRY=0;

    parameter MAX_DIV_CYCLE = WIDTH+1;
    parameter MAX_CORRECT_CYCLE = 2;
    parameter CHECK_OVERFLOW = 2;

    reg [6:0] div_counter; // cho việc chia
    reg [4:0] correct_counter; // cho việc sửa dấu
    reg signed [2*WIDTH:0] S; // lưu Z trong quá trình tính
    reg signed [WIDTH:0] D; // lưu D trong quá trình tính
    reg signed [WIDTH:0] Q_t; // lưu thương tạm
    reg signed [WIDTH:0] D_c; // D_âm
    reg Z_in_sign;    
    reg overflow;

    wire signed [WIDTH:0] D_abs = (D_in[WIDTH-1] == 1) ? D_c : D;
    wire signed [WIDTH:0] S_abs = (S[2*WIDTH] == 1) ? (~S[2*WIDTH:WIDTH] + 1) : S[2*WIDTH:WIDTH];

    always @(posedge clk) begin
        if(div_counter == 0) begin
            D_c <= ~{D_in[WIDTH-1],D_in}+1;
        end else begin
            D_c <= ~D + 1;
        end
        if(div_counter == 0) begin
            Z_in_sign <= Z_in[2*WIDTH-1];
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
            overflow <= 0;
        end else begin
            if(en) begin
                if(div_counter == 0) begin
                    S <= {Z_in[2*WIDTH-1], Z_in}; // có phần mở rộng dấu
                    D <= {D_in[WIDTH-1], D_in}; // có phần mở rộng dấu
                    Q_t <= 0;
                    div_counter <= div_counter + 1;
                    correct_counter <= 0;

                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    overflow <= 0;

                end else if(correct_counter == MAX_CORRECT_CYCLE) begin // thực hiện xong phần sửa cho đúng dấu -> output
                    S <= 0;
                    D <= 0;
                    Q_t <= 0;
                    div_counter <= 0;
                    correct_counter <= 0;

                    Q <= Q_t[WIDTH-1:0];
                    R <= S[2*WIDTH-1:WIDTH];
                    done <= 1;
                    overflow <= 0;

                end else if((div_counter == MAX_DIV_CYCLE) && (correct_counter != 0) && (correct_counter != MAX_CORRECT_CYCLE)) begin // sửa cho đúng dấu
                    if(S[2*WIDTH] ^ D[WIDTH]) begin // khác dấu thì S = S + d, Q = Q - 1 
                        Q_t <= Q_t - 1;
                        S[2*WIDTH:WIDTH] <= S[2*WIDTH:WIDTH] + D;
                    end else begin // cùng dấu thì S = S - D, Q = Q + 1
                        Q_t <= Q_t + 1;
                        S[2*WIDTH:WIDTH] <= S[2*WIDTH:WIDTH] + D_c;
                    end
                    div_counter <= div_counter;
                    correct_counter <= correct_counter + 1; // đang sửa dấu
                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    overflow <= 0;

                end else if((div_counter == MAX_DIV_CYCLE) && (correct_counter == 0)) begin // thực hiện xong phần chia -> chu kì đầu của sửa dấu
                    if((S_abs >= D_abs)||(Z_in_sign ^ S[2*WIDTH])) begin // khi |S| >= |D| hoặc là dấu của S và Z khác nhau (dư)
                        S <= S;
                        D <= D;
                        Q_t[WIDTH] <= ~Q_t[WIDTH-1]; // đảo bit đầu và dịch vào
                        Q_t[WIDTH-1:1] <= Q_t[WIDTH-2:0]; // dịch trái 1 bit
                        Q_t[0] <= 1; // bit cuối là 1 
                        div_counter <= div_counter;
                        correct_counter <= correct_counter + 1; // bắt đầu sửa dấu

                        Q <= 0;
                        R <= 0;
                        done <= 0;
                        overflow <= 0;  

                    end else begin // cùng dấu thì là xong luôn
                        S <= S;
                        D <= D;
                        Q_t <= 0;
                        div_counter <= 0;
                        correct_counter <= correct_counter + 1; // đang sửa dấu

                        Q[WIDTH-1:1] <= Q_t[WIDTH-2:0]; // dịch trái 1 bit
                        Q[0] <= 1; // bit cuối là 1 
                        R <= S[2*WIDTH-1:WIDTH];
                        done <= 1;
                        overflow <= 0;   
                    end 

                end else if(div_counter == CHECK_OVERFLOW )begin // kiểm tra điều kiện overflow
                    if(Z_in_sign == S[2*WIDTH]) begin // cùng dấu là overflow
                        S <= 0;
                        D <= 0;
                        Q_t <= 0;
                        div_counter <= 0;
                        correct_counter <= 0;

                        Q <= 0;
                        R <= 0;
                        done <= 1;
                        overflow <= 1;
                    end else begin
                        if(S[2*WIDTH] ^ D[WIDTH]) begin // kiểm tra dấu
                            S[2*WIDTH:WIDTH] <= S[2*WIDTH-1:WIDTH-1] + D; // thương và số chia khác dấu
                            Q_t[0] <= 0; 
                        end else begin
                            S[2*WIDTH:WIDTH] <= S[2*WIDTH-1:WIDTH-1] + D_c; // thương và số chia cùng dấu
                            Q_t[0] <= 1; 
                        end
                        S[WIDTH-1:0] <= {S[WIDTH-2:0],1'b0}; // phần đuôi thì dịch sang trái là được
                        Q_t[WIDTH:1] <= Q_t[WIDTH-1:0]; // phần đầu dịch trái 1 bit 
                        D <= D; 
                        div_counter <= div_counter + 1;
                        correct_counter <= 0;

                        Q <= 0;
                        R <= 0;
                        done <= 0;
                        overflow <= 0;
                    end
                end else begin // thực hiện phần chia
                    if(S[2*WIDTH] ^ D[WIDTH]) begin // kiểm tra dấu
                        S[2*WIDTH:WIDTH] <= S[2*WIDTH-1:WIDTH-1] + D; // thương và số chia khác dấu
                        Q_t[0] <= 0; 
                    end else begin
                        S[2*WIDTH:WIDTH] <= S[2*WIDTH-1:WIDTH-1] + D_c; // thương và số chia cùng dấu
                        Q_t[0] <= 1; 
                    end
                    S[WIDTH-1:0] <= {S[WIDTH-2:0],1'b0}; // phần đuôi thì dịch sang trái là được
                    Q_t[WIDTH:1] <= Q_t[WIDTH-1:0]; // phần đầu dịch trái 1 bit 
                    D <= D; 
                    div_counter <= div_counter + 1;
                    correct_counter <= 0;

                    Q <= 0;
                    R <= 0;
                    done <= 0;
                    overflow <= 0;
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
                    overflow <= 0;
            end
        end
    end

    always @(*) begin
        flag[OVERFLOW] = overflow;
        if(Q[WIDTH-1] == 1) begin
            flag[SIGN] = 1;
        end else begin
            flag[SIGN] = 0;
        end

        if(Q == 0) begin
            flag[ZERO] = 1;
        end else begin
            flag[ZERO] = 0;
        end
        flag[CARRY] = 0;

    end


endmodule