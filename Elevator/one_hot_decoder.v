module one_hot_decoder (
    input [4:0] in_num,
    output reg [3:0] out_num
);

    always @(in_num) begin
        if(in_num[4]) begin
            out_num = 4'b0101;
        end else if (in_num[3]) begin
            out_num = 4'b0100;
        end else if (in_num[2]) begin
            out_num = 4'b0011;
        end else if (in_num[1]) begin
            out_num = 4'b0010;
        end else if (in_num[0]) begin
            out_num = 4'b0001;
        end else begin
            out_num = 4'b1111;
        end
    end
endmodule