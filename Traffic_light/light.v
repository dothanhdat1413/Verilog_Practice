module light #(
    parameter MAX_0 = 0,
    parameter MAX_1 = 3
)(
    input clk,
    input rst,
    input en,
    output [3:0] num_0,
    output [3:0] num_1,
    output done
);

    assign done = (num_0 == 0) && (num_1 == 0);

    counter #(  .MAX(MAX_0), 
                .MODE(1)) 
    counter_num_0(
        .clk(clk),
        .rst(rst | done),
        .en(en & (~done)),
        .bin_num(num_0)
    );
    
    counter #(  .MAX(MAX_1), 
                .MODE(1))
    counter_num_1(
        .clk(clk),
        .rst(rst | done),
        .en((num_0 == 0) & en & (~done)),
        .bin_num(num_1)
    );

endmodule