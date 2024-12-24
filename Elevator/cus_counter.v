module cus_counter #(
    parameter MAX = 5'b10000,
    parameter MIN = 5'b00001,
    parameter WIDTH = 5,
    parameter TIME = 3
)(
    input mode,
    input clk,
    input en,
    input rst,
    output reg [(WIDTH-1):0] num
    );

    integer i;
    reg [1:0] clock_count = 0; // count to 0.25 clk in

    always @(posedge clk) begin
        if(rst == 1'b1) begin
            num <= MIN;
            clock_count <= 0;
        end else if (en == 1'b1) begin
            if(clock_count == TIME) begin // đếm từ 0 đến 12499999 ,0.5hz = 25000000 1hz = 12499999, 4hz = 3124999, 8hz = 1562499, 16hz = 781249, xung chạy ngày nhanh: 50
                clock_count <= 0;
                case(mode) 
                    1'b0: begin // Tăng
                        num[0] <= num[WIDTH-1];
                        for(i = 1; i < WIDTH; i = i + 1) begin
                            num[i] <= num[i-1];
                        end
                    end
                    1'b1: begin // Giảm
                        num[WIDTH-1] <= num[0];
                        for(i = WIDTH-1; i > 0; i = i - 1) begin
                            num[i-1] <= num[i];
                        end
                    end
                endcase
            end else begin
                clock_count <= clock_count + 1;
            end 
        end
    end 
endmodule