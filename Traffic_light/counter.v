module counter #(
    parameter MAX = 9,
    parameter MIN = 0,
    parameter MODE = 0
)(
    input clk,
    input rst,
    input en,
    output reg [3:0] bin_num
    );

    always @(posedge clk) begin

        if (rst) begin
            case (MODE)
                1'b0: begin : reset_increase
                bin_num <= MIN; // reset dùng tương đương như preload, khi giá trị sau reset và preload bằng nhau
                end
                1'b1:begin : reset_decrease
                    bin_num <= MAX; // reset dùng tương đương như preload, khi giá trị sau reset và preload bằng nhau
                end
            endcase
        end 
        else begin
            case (en)
                1'b1: begin
                    case (MODE)
                        1'b0: if (bin_num == 9) begin : count_increase
                                    bin_num <= 0;
                                end
                                else begin
                                    bin_num <= bin_num + 1;
                                end
                        1'b1: if (bin_num == 0) begin : count_decrease
                                    bin_num <= 9;
                                end
                                else begin
                                    bin_num <= bin_num - 1;
                                end
                    endcase
                    // if (bin_num == MAX) begin
                    //     bin_num <= 0;
                    // end
                    // else begin
                    //     bin_num <= bin_num + 1;
                    // end
                end
                1'b0: bin_num <= bin_num;
            endcase 
        end
        
    end
endmodule