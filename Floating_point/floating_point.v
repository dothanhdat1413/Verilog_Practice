module floating_point (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);
    wire a_s, b_s, c_s;
    wire [7:0] a_e, b_e, c_e;
    wire [22:0] a_m, b_m, c_m;

    assign a_s = a[31];
    assign b_s = b[31];
    assign a_e = a[30:23];
    assign b_e = b[30:23]; 
    assign a_m = a[22:0];
    assign b_m = b[22:0];
    
    

endmodule