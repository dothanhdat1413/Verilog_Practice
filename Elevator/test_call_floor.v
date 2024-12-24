module test_call_floor();
    reg clk;
    reg rst;
    reg [7:0] call;
    reg [7:0] off;
    wire [4:0] call_fl;
    wire [7:0] dir_fl;

    call_floor call_floor_module(
        .clk(clk),
        .rst(rst),
        .call(call),
        .off(off),
        .call_fl(call_fl),
        .dir_fl(dir_fl)
    );

    always #1 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        call = 0;
        off = 0;
        #10;
        rst = 0;
        call = 8'b00000001;
        off = 8'b00000000;
        #10;
        call = 8'b00000110;
        off = 8'b00000001;
        #10;
        off = 8'b00001100;
        call = 0;
        $finish;
    end
endmodule