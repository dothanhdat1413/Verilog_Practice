module fulladd(
    input num1, num2, c_in,
    output sum, c_out
    );
        assign sum = num1 ^ num2 ^ c_in;
        assign c_out = (num1 & num2) | (num1 & c_in) | (num2 & c_in);
endmodule

// module divide (
//     input [7:0] num1, num2,
//     output reg [7:0] result,
//     output reg v
//     );
//     integer i;
//     reg [7:0] R;
//     reg [7:0] R_t;
    
//     initial begin
//         R=0;
//         R_t=0;
//     end

//     always @ (num1, num2) begin 
//         if(num2 == 0) begin 
//             result = 2'hFF; 
//             v = 0; 
//         end else begin
//             for(i = 15; i >= 0; i = i + 1)begin
//                 R={R_t << 1, num1[i]};
//                 if(R >= num2)begin
//                     R_t = R - num2;
//                     result[i] = 1;
//                 end else begin
//                     R_t = R;
//                     result[i] = 0;
//                 end
//             end
//             v = 1;
//         end
//     end
// endmodule

