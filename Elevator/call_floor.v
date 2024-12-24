module call_floor #(
    parameter WIDTH = 5
)(
    input clk,
    input rst,
    input [(WIDTH*2-2)-1:0] call, // 8 phần
    input [(WIDTH*2-2)-1:0] off, // 8 phần
    output [WIDTH-1:0] call_fl, // 5 tầng
    output reg [(WIDTH*2-2)-1:0] dir_fl // 8 phần
); 

    assign call_fl[WIDTH-1] = dir_fl[WIDTH*2-2 -1]; // Tầng cao nhất
    assign call_fl[0] = dir_fl[0]; // Tầng thấp nhất
    genvar j;
    generate 
        for (j = 1; j < WIDTH-1; j = j + 1) begin : call_fl_gen// Bắt đầu từ tầng 2 (chỉ số call_fl là 1), kết thúc ở tầng width-1 (chỉ số là width-2)
            assign call_fl[j] = dir_fl[j*2-1] | dir_fl[j*2]; // j*2-1 là tầng này chọn đi xuống, j*2 là tầng này chọn đi lên 
        end
    endgenerate


    always @(posedge clk) begin : top // khi bấm nút call_fl cái thì bật lên 1, khi bấm tắt cái thì cho về 0, ko bấm thì giữ nguyên
        if(rst == 1'b1) begin // Nếu ban đầu rst thì tắt đi
            dir_fl[WIDTH*2-2-1] <= 0;
        end else if(call[WIDTH*2-2-1]) begin // Nếu call tầng này thì bật nó lên
            dir_fl[WIDTH*2-2-1] <= 1;
        end else if(off[WIDTH*2-2-1]) begin // Nếu xong rồi tắt nó đi thì tắt
            dir_fl[WIDTH*2-2-1] <= 0;
        end else begin // Nếu ko ai làm gì thì thôi giữ nguyên
            dir_fl[WIDTH*2-2-1] <= dir_fl[WIDTH*2-2-1];
        end
    end

    always @(posedge clk) begin : bot
        if(rst == 1'b1) begin
            dir_fl[0] <= 0;
        end else if(call[0]) begin
            dir_fl[0] <= 1;
        end else if(off[0]) begin
            dir_fl[0] <= 0;
        end else begin
            dir_fl[0] <= dir_fl[0];
        end
    end

    integer i;
    always @(posedge clk) begin : mid
        for (i = 1; i < WIDTH-1; i = i + 1) begin // Bắt đầu từ tầng 2 (chỉ số call_fl là 1), kết thúc ở tầng width-1 (chỉ số là width-2)
            if(rst == 1'b1) begin
                dir_fl[i*2-1] <= 0; // Tầng này chọn đi xuống
            end else if(call[i*2-1]) begin
                dir_fl[i*2-1] <= 1; // bật
            end else if(off[i*2-1])begin
                dir_fl[i*2-1] <= 0; // Tắt
            end else begin
                dir_fl[i*2-1] <= dir_fl[i*2-1]; // giữ nguyên
            end
        end
        for (i = 1; i < WIDTH-1; i = i + 1) begin // Bắt đầu từ tầng 2 (chỉ số call_fl là 1), kết thúc ở tầng width-1 (chỉ số là width-2)
            if(rst == 1'b1) begin
                dir_fl[i*2] <= 0; // Tầng này chọn đi lên
            end else if(call[i*2]) begin
                dir_fl[i*2] <= 1; // bật
            end else if(off[i*2])begin
                dir_fl[i*2] <= 0; // Tắt
            end else begin
                dir_fl[i*2] <= dir_fl[i*2]; // giữ nguyên
            end
        end
    end

endmodule