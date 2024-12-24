module choose_floor #(parameter WIDTH = 5
)(
    input clk,
    input rst,
    input [WIDTH-1:0] choose,
    input [WIDTH-1:0] off,
    output reg [WIDTH-1:0] choose_fl
); 
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < WIDTH; i = i + 1) begin
            if(rst == 1'b1) begin
                choose_fl[i] <= 0;
            end else if(choose[i]) begin
                choose_fl[i] <= 1;
            end else if(off[i]) begin
                choose_fl[i] <= 0;
            end else begin
                choose_fl[i] <= choose_fl[i];
            end
        end
    end
endmodule