module debounce #(
    // Định nghĩa số xung clock cần chờ để debounce (phụ thuộc vào tần số clock và yêu cầu debounce).
    // Ví dụ: Nếu clock 50 MHz và bạn muốn debounce khoảng 10ms, cần 500,000 xung clock.
    parameter DEBOUNCE_DELAY = 500000
)(
    input clk,           // Clock của hệ thống (FPGA clock)
    input reset,         // Tín hiệu reset
    input button_in,     // Tín hiệu vào từ nút nhấn (chưa được debounce)
    output reg button_out // Tín hiệu ra sau khi debounce
);


    reg [19:0] counter;      // Counter đếm số lượng xung clock (bit-width tuỳ thuộc vào giá trị DEBOUNCE_DELAY)
    reg button_sync_0;       // Lưu trữ trạng thái nút nhấn (đồng bộ với clock)
    reg button_sync_1;       // Lưu trữ trạng thái nút nhấn (đồng bộ với clock)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            button_out <= 0;
            button_sync_0 <= 0;
            button_sync_1 <= 0;
        end
        else begin
            // Đồng bộ nút nhấn với clock
            button_sync_0 <= button_in;
            button_sync_1 <= button_sync_0;

            // Nếu tín hiệu button_sync_1 thay đổi, bắt đầu đếm
            if (button_sync_1 != button_out) begin // khi tín hiệu đầu vào thay đổi khác tín hiệu đầu ra
                counter <= counter + 1;
                if (counter >= DEBOUNCE_DELAY) begin
                    // Khi counter đủ lớn, cập nhật trạng thái nút nhấn
                    button_out <= button_sync_1;
                    counter <= 0;  // Reset counter
                end
            end
            else begin
                // Reset counter nếu tín hiệu button_sync_1 không thay đổi
                counter <= 0;
            end
        end
    end
endmodule