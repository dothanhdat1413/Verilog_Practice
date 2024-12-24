module majority (
    input [31:0] num,
    output reg more_bit_1
    );

    integer i, j;
    always @ (num) begin
        j = 0; 
        for(i = 0; i < 32; i = i + 1) begin
            if(num[i]) begin
                j = j + 1;
            end
        end

        if(j > 16) begin
            more_bit_1 = 1;
        end else begin
            more_bit_1 = 0;
        end
    end
endmodule