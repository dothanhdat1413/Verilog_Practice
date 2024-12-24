module mul_booth_mod_4bit(
    input [3:0] M_in,
    input [3:0] Q_in,
    input clk,
    input reset,
    input en,
    output reg done,
    output [7:0] A_out, // M*Q
    output reg [3:0] flag // o, z, s, c
);

reg [5:0] counter;
reg signed [3:0] M;
reg signed [3:0] Q;
reg [9:0] temp; // 4x2 + 3 - 1 = 66
wire [1:0] temp_s = {temp[9], temp[9]}; // 2 bit

// assign A_out = {temp_s, temp[9:4]};
assign A_out = temp[9:1];

wire signed [4:0] b_M;
wire signed [4:0] b_2M;
wire signed [4:0] b_M_in;
wire signed [4:0] b_2M_in;

assign b_2M = ~{M,1'b0}+1; // 5 bit
assign b_M[3:0] = ~M + 1; // 5 bit // cần xét trường hợp M gần bằng max, tức là ~M + 1 có thể vượt phạm vi lưu trữ
assign b_M[4] = b_M[3]; // mở rộng dấu 
assign b_2M_in = ~{M_in,1'b0}+1; // 5 bit
assign b_M_in[3:0] = ~M_in + 1; // 5 bit
assign b_M_in[4] = b_M_in[3]; // mở rộng dấu 

reg signed [4:0] booth_p; // 5 bit chọn từ booth selector

always @(*) begin // booth selector
    if((counter == 1) || (counter == 0)) begin
        case ({Q_in[1:0],1'b0}) // chọn từ 3 bit cuối
            3'b000: booth_p = 0;
            3'b001: booth_p = {M_in[3], M_in}; // M
            3'b010: booth_p = {M_in[3], M_in};
            3'b011: booth_p = {M_in, 1'b0}; // 2M
            3'b100: booth_p = b_2M_in;
            3'b101: booth_p = {b_M_in[3], b_M_in}; // -M
            3'b110: booth_p = b_M_in;
            3'b111: booth_p = 0;
        endcase
    end else begin // ko phải chu kì đầu
        case (temp[2:0]) // chọn từ 3 bit cuối
            3'b000: booth_p = 0;
            3'b001: booth_p = {M[3], M}; // M
            3'b010: booth_p = {M[3], M};
            3'b011: booth_p = {M, 1'b0}; // 2M
            3'b100: booth_p = b_2M;
            3'b101: booth_p = b_M;
            3'b110: booth_p = b_M;
            3'b111: booth_p = 0;
        endcase
    end
end

parameter MUL_CYCLE = 3;
always @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        done <= 0;
    end else begin
        if(en) begin
            if(counter == 0) begin
                M <= M_in;
                Q <= Q_in;
                temp[9:7] <= 0;
                temp[6:0] <= {Q_in[3], Q_in[3],Q_in, 1'b0};// 
                done <= 0;
                counter <= counter + 1;
            end else if(counter == MUL_CYCLE) begin
                temp[9:5] <= {temp_s, temp[9:7]} + booth_p;
                temp[4:0] <= temp[6:2];
                counter <= 0;
                done <= 1;
            end else begin
                temp[9:5] <= {temp_s, temp[9:7]} + booth_p;
                temp[4:0] <= temp[6:2];
                done <= 0;
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            done <= 0;
            temp <= 0;
        end
    end
end

endmodule