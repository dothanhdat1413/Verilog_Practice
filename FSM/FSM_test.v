module FSM 
#(
    parameter A = 1'b0,
    parameter B = 1'b1
)(
    input clk,
    input rst,
    input x,
    output reg out  
);


reg state;

always @(posedge clk ) begin
    if(rst == 1'b1) begin
        state <= A;
        out <= 1'b0;
    end
    else begin
        if( state == A) begin
            if(x == 0) begin
                state <= B;
                out <= 1'b1;
            end
            else begin
                state <= A;
                out <= 1'b0;
            end
        end
        else begin
            if(x==0) begin
                state <= B;
                out <= 1'b0;
            end
            else begin
                state <= B;
                out <= 1'b0;
            end
        end
    end
end 
    
endmodule