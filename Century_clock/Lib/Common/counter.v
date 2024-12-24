module counter #(
    parameter MAX = 9,
    parameter MIN = 0
)(
    input clk,
    input rst,
    input en,
    output reg [3:0] bin_num
    );
        
    always @(posedge clk) begin

        if (rst) begin
                bin_num <= MIN;
        end 
        else begin
            case (en)
                1'b1: begin
                    if (bin_num == MAX) begin
                        bin_num <= 0;
                    end
                    else begin
                        bin_num <= bin_num + 1;
                    end
                end
                1'b0: bin_num <= bin_num;
            endcase 
        end
        
    end
endmodule