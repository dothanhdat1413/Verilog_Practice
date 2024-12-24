module add (
    input unsigned [3:0] num_1, 
    input c_in,
    input en,
    input clear,
    output [3:0] sum
    // output reg c_out
    );

    reg [3:0] temp;
    assign sum = temp;

    always @(posedge en) begin
        if(clear) begin
            temp <= 4'b0000;
            // c_out <= 0;
        end
        else begin
            if((temp + num_1 + c_in ) > 9) begin
                temp <= ((temp + num_1 + {3'b0,c_in}) - 4'b1010);
                // c_out <= 1'b1;
            end
            else begin
                temp <= temp + num_1 + {3'b0,c_in};
                // c_out <= 1'b0;
            end
        end
    end
endmodule


