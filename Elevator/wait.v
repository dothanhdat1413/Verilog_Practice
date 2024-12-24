module wait_test #(
    parameter WAIT_TIME = 5, // tối đa 15
    parameter WAIT_TIME_CHECK_INPUT = (WAIT_TIME - 1) // tối đa 15
)(  
    input en,
    input clk, // Xung clock
    input wait_en, // Bật bộ đếm chờ
    input wait_rst,// Reset bộ đếm chờ
    input wait_st, // Set bộ đếm chờ là xong
    output reg wait_done, // Đợi cửa mở xong
    output reg wait_check_input
);

    reg [4:0] count; // Đếm tối đa 15 chu kì ( đếm xung lên 15 lần)

    /* 
    input wait_en, // Bật bộ đếm chờ
    input wait_rst, // Reset bộ đếm chờ
    input wait_st, // Set bộ đếm chờ là xong
    output wait_done, // Đợi cửa mở xong
    */
    always @(posedge clk) begin : wait_module // ưu tiên rst nhất, sau đó tới wait_en, cuối cùng là wait_st, chỉ khi ko được enalbe thì mới xét st_wait
        if(wait_rst) begin
            count <= 0;
            wait_done <= 0;
        end else if (en) begin
            if(wait_en) begin
                if(count == WAIT_TIME) begin
                    wait_done <= 1;
                end else begin
                    count <= count + 1;
                end
                if(count == WAIT_TIME_CHECK_INPUT) begin
                    wait_check_input <= 1;
                end else begin
                    wait_check_input <= 0;
                end 
            end else if(wait_st) begin
                count <= WAIT_TIME;
                wait_done <= 1;
            end else begin
                wait_done <= 0;
            end
        end
    end

endmodule