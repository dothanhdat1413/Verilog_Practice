module mul_shl(
    input [31:0] M_in,
    input [31:0] Q_in,
    input clk,
    input reset,
    input en,
    output reg done,
    output [63:0] A_out, // M*Q
    output reg [3:0] flag // o, z, s, c
);

reg [5:0] counter;
reg [31:0] M;
reg [31:0] Q;
reg [62:0] temp; // 63 bit
wire temp_s = temp[62];

assign A_out = {temp_s, temp};
// Sử dụng 2 thanh ghi M, Q để kiểm soát việc nhập vào input do việc nối giữa mạch combination & sequential
// Sử dụng thanh ghi temp có định dạng là phần đầu chứa kết quả, phần sau chứa Q để tiết kiệm
parameter MUL_CYCLE = 32;

always @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        done <= 0;
    end else begin
        if(en) begin
            if(counter == 0) begin
                M <= M_in;
                Q <= Q_in;
                temp[62:32] <= 0;
                temp[31:0] <= Q_in;
                done <= 0;
                counter <= counter + 1;
            end else if(counter == 32) begin
                if(temp[0]) begin
                    temp[30:0] <= temp[31:1];
                    temp[62:31] <= {temp_s,temp[62:32]} - M;
                end else begin
                    temp <= {temp_s,temp[62:1]};
                end
                done <= 1;
                counter <= 0;
            end else begin // ở phần này sẽ cho thuật toán nhân vào
                if(temp[0]) begin
                    temp[30:0] <= temp[31:1];
                    temp[62:31] <= {temp_s,temp[62:32]} + M;
                end else begin
                    temp <= {temp_s,temp[62:1]};
                end
                counter <= counter + 1;
                done <= 0;
            end
        end else begin
            counter <= 0;
            done <= 0;
            temp <= 0;
        end
    end
end

endmodule