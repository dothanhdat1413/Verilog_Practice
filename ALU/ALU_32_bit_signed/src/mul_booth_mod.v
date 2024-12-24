module mul(
    input [31:0] M_in,
    input [31:0] Q_in,
    input clk,
    input reset,
    input en,
    output reg done,
    output [63:0] A_out, // M*Q
    output reg [3:0] flag // o, z, s, c
);

    parameter OVERFLOW=3;
    parameter ZERO=2;
    parameter SIGN=1;
    parameter CARRY=0;

reg [5:0] counter;
reg signed [31:0] M;
reg signed [31:0] Q;
reg signed [66:0] temp; // 32x2 + 3 - 1 = 66
wire signed [1:0] temp_s = {temp[66], temp[66]}; // 2 bit

// assign A_out = {temp_s, temp[65:4]};
assign A_out = temp[64:1];

// wire signed [32:0] b_M;
// wire signed [32:0] b_2M;
// wire signed [32:0] b_M_in;
// wire signed [32:0] b_2M_in;

// assign b_2M = ~{M,1'b0}+1; // 33 bit
// assign b_M = ~M + 1; // 33 bit // cần xét trường hợp M nằm ở biên, tức là ~M + 1 có thể vượt phạm vi lưu trữ 
// assign b_2M_in = ~{M_in,1'b0}+1; // 33 bit
// assign b_M_in = ~M_in + 1; // 33 bit 

// reg signed [32:0] booth_p; // 33 bit chọn từ booth selector

// always @(*) begin // booth selector
//     if((counter == 1) || (counter == 0)) begin
//         case ({Q_in[1:0],1'b0}) // chọn từ 3 bit cuối
//             3'b000: booth_p <= 0;
//             3'b001: booth_p <= {M_in[31], M_in}; // M
//             3'b010: booth_p <= {M_in[31], M_in};
//             3'b011: booth_p <= {M_in, 1'b0}; // 2M
//             3'b100: booth_p <= b_2M_in; 
//             3'b101: booth_p <= {b_M_in}; // -M
//             3'b110: booth_p <= b_M_in;
//             3'b111: booth_p <= 0;
//         endcase
//     end else begin // ko phải chu kì đầu
//         case (temp[2:0]) // chọn từ 3 bit cuối
//             3'b000: booth_p <= 0;
//             3'b001: booth_p <= {M[31], M}; // M
//             3'b010: booth_p <= {M[31], M};
//             3'b011: booth_p <= {M, 1'b0}; // 2M
//             3'b100: booth_p <= b_2M;
//             3'b101: booth_p <= b_M;
//             3'b110: booth_p <= b_M;
//             3'b111: booth_p <= 0;
//         endcase
//     end
// end

// parameter MUL_CYCLE = 17;
// always @(posedge clk) begin
//     if(reset) begin
//         M <= 0;
//         Q <= 0;
//         temp <= 0;
//         counter <= 0;
//         done <= 0;
//         flag <= 0;
//     end else begin
//         if(en) begin
//             if(counter == 0) begin
//                 M <= M_in;
//                 Q <= Q_in;
//                 temp[65:35] <= 0;
//                 temp[34:0] <= {Q_in[31], Q_in[31],Q_in, 1'b0};// 32 + 3
//                 done <= 0;
//                 counter <= counter + 1;
//             end else if(counter == MUL_CYCLE) begin
//                 temp[65:33] <= {temp_s, temp[65:35]} + booth_p;
//                 temp[32:0] <= temp[34:2];
//                 counter <= 0;
//                 done <= 1;
//             end else begin
//                 temp[65:33] <= {temp_s, temp[65:35]} + booth_p;
//                 temp[32:0] <= temp[34:2];
//                 done <= 0;
//                 counter <= counter + 1;
//             end
//         end else begin
//             temp <= temp;
//             M <= M;
//             Q <= Q;
//             counter <= 0;
//             done <= 0;
//         end
//     end
// end


wire signed [33:0] b_M;
wire signed [33:0] b_2M;
wire signed [33:0] b_M_in;
wire signed [33:0] b_2M_in;

assign b_2M = -2*M; // 33 bit
assign b_M = - M; // 33 bit // cần xét trường hợp M nằm ở biên, tức là ~M + 1 có thể vượt phạm vi lưu trữ 
assign b_2M_in = -2*M_in; // 33 bit
assign b_M_in = - M_in; // 33 bit 

reg signed [33:0] booth_p; // 33 bit chọn từ booth selector

always @(*) begin // booth selector
    if((counter == 0)) begin
        case ({Q_in[1:0],1'b0}) // chọn từ 3 bit cuối
            3'b000: booth_p <= 0;
            3'b001: booth_p <= {M_in[31], M_in[31], M_in}; // M
            3'b010: booth_p <= {M_in[31], M_in[31], M_in};
            3'b011: booth_p <= {M_in[31],M_in, 1'b0}; // 2M
            3'b100: booth_p <= b_2M_in; 
            3'b101: booth_p <= {b_M_in}; // -M
            3'b110: booth_p <= b_M_in;
            3'b111: booth_p <= 0;
        endcase
    end else begin // ko phải chu kì đầu
        case (temp[2:0]) // chọn từ 3 bit cuối
            3'b000: booth_p <= 0;
            3'b001: booth_p <= {M[31], M[31], M}; // M
            3'b010: booth_p <= {M[31], M[31], M};
            3'b011: booth_p <= {M[31], M, 1'b0}; // 2M
            3'b100: booth_p <= b_2M;
            3'b101: booth_p <= b_M;
            3'b110: booth_p <= b_M;
            3'b111: booth_p <= 0;
        endcase
    end
end

parameter MUL_CYCLE = 17;
always @(posedge clk) begin
    if(reset) begin
        M <= 0;
        Q <= 0;
        temp <= 0;
        counter <= 0;
        done <= 0;
        flag <= 0;
    end else begin
        if(en) begin
            if(counter == 0) begin
                M <= M_in;
                Q <= Q_in;
                temp[66:35] <= 0;
                temp[34:0] <= {Q_in[31], Q_in[31],Q_in, 1'b0};// 32 + 3
                done <= 0;
                counter <= counter + 1;
            end else if(counter == MUL_CYCLE) begin
                temp[66:33] <= {temp_s, temp[66:35]} + booth_p; // cộng 34 bit
                temp[32:0] <= temp[34:2];
                counter <= 0;
                done <= 1;
            end else begin
                temp[66:33] <= {temp_s, temp[66:35]} + booth_p;
                temp[32:0] <= temp[34:2];
                done <= 0;
                counter <= counter + 1;
            end
        end else begin
            temp <= temp;
            M <= M;
            Q <= Q;
            counter <= 0;
            done <= 0;
        end
    end
end

always @(*) begin
    flag[OVERFLOW] = 0;
    flag[CARRY] = 0;
    if(A_out == 0) begin
        flag[ZERO] = 1;
    end else begin
        flag[ZERO] = 0;
    end

    if(A_out[63]) begin
        flag[SIGN] = 1;
    end else begin
        flag[SIGN] = 0;
    end
end

endmodule