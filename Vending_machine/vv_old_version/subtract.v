module subtract (
    input unsigned [3:0] num_1, 
    input b_in,
    input en,
    input clear,
    output reg [3:0] result
    );

    always @(posedge en) begin
        if(clear) begin
            result <= 4'b0000;
        end
        else begin
            if(result >= (num_1 + b_in)) begin
                result <= result - num_1 - b_in;
            end
            else begin
                result <= result + 10 - num_1 - b_in;
            end
        end
    end

endmodule


