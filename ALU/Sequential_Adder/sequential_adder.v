module sequential_adder #(
    parameter WIDTH = 3,
    parameter COUNTER_CYCLE = 3 // số bit của counter để đếm
)(
    input clk,
    input rst,
    input en,
    input C_in_input,
    input [WIDTH-1:0] A_in,
    input [WIDTH-1:0] B_in,
    output reg done,
    output reg [WIDTH-1:0] S,
    output reg C_out
);  
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    reg C_in;
    reg [WIDTH-2:0] C_out_i;
    reg [WIDTH-1:0] S_i;
    reg [COUNTER_CYCLE-1:0] counter;
    integer MAX_CYCLE = WIDTH+1; // số chu kỳ cần để thực hiện phép cộng
    integer i;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        done <= 0;
    end else begin
        if(en) begin
            if(counter == 0) begin
                A <= A_in;
                B <= B_in;
                C_in <= C_in_input;
                
                S_i <= 0;
                C_out_i <= 0;

                S<= 0;
                C_out <= 0;

                done <= 0;
                counter <= counter + 1;

            end else if(counter == MAX_CYCLE) begin
                A <= A;
                B <= B;
                C_in <= C_in;

                S_i <= 0;
                C_out_i <= 0;
                
                S <= S_i;
                C_out <= C_out;

                done <= 1;
                counter <= 0;

            end else begin
                A <= A;
                B <= B;
                C_in <= C_in;

                S_i[0] <= A[0] ^ B[0] ^ C_in;
                C_out_i[0] <= (A[0] & B[0]) | (A[0] & C_in) | (B[0] & C_in);
                for(i = 1; i < WIDTH - 1; i = i + 1) begin 
                    S_i[i] <= A[i] ^ B[i] ^ C_out_i[i-1];
                    C_out_i[i] <= (A[i] & B[i]) | (A[i] & C_out_i[i-1]) | (B[i] & C_out_i[i-1]);
                end

                S_i[WIDTH-1] <= A[WIDTH-1] ^ B[WIDTH-1] ^ C_out_i[WIDTH-2];
                C_out <= (A[WIDTH-1] & B[WIDTH-1]) | (A[WIDTH-1] & C_out_i[WIDTH-2]) | (B[WIDTH-1] & C_out_i[WIDTH-2]); 

                S <= 0;
                done <= 0;
                counter <= counter + 1;
            end
        end else begin
            A <= 0;
            B <= 0;
            C_in <= 0;
            S_i <= 0;
            C_out_i <= 0;

            S <= 0;
            C_out <= 0;

            done <= 0;
            counter <= 0;
        end
    end
end
endmodule