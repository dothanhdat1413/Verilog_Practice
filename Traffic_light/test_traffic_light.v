`timescale 1ps/1ps
module test_traffic_light ();
    reg clk_in;
    reg rst;
    reg en;

    reg car;
    wire [6:0] highway_0;
    wire [6:0] highway_1;
    wire [6:0] country_0;
    wire [6:0] country_1;
    wire check;
    wire [3:0] state_out;

    wire [17:0] road;
    reg rst_clk;

traffic_light DUT(
    .clk_in(clk_in),
    .rst(rst),
    .en(en),
    .car(car),
    .highway_0(highway_0),
    .highway_1(highway_1),
    .country_0(country_0),
    .country_1(country_1),
    .check(check),
    .state_out(state_out),
    .road(road),
    .rst_clk(rst_clk)
    );
    
always #1 clk_in = ~clk_in;

initial begin
    rst_clk = 1;
    clk_in = 0;
    rst = 1'b1;
    en =1;
    car =1;
    #10     rst_clk = 0;
    #100
    rst_clk = 0;
    en =1;
    car =1;
    rst =0;
    #1000 $finish;
end

always @(*) begin
    $display("Check state: %b", state_out);
end
endmodule