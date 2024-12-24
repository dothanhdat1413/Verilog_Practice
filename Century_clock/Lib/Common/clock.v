module clock (
    input clk_in, // 50Mhz
    input rst, // active low reset
    output reg clk_out
);
    reg [26:0] clock_count = 0; // count to 50Mhz

    always @(posedge clk_in) begin
        if (rst == 1) begin
            clock_count <= 0;
            clk_out <= 0;
        end
        else begin
            if(clock_count == 6249999) begin // đếm từ 0 đến 12499999 , 1hz = 12499999, 4hz = 3124999, 8hz = 1562499, 16hz = 781249, xung chạy ngày nhanh: 50
                clk_out <= ~clk_out;
                clock_count <= 0;
            end 
            else begin
                clock_count <= clock_count + 1;
            end 
        end
    end
    
endmodule