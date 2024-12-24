module test_elevator ();
    reg clk_in;
    reg en;
    reg rst;
    reg [7:0] call;
    reg [4:0] choose;
    reg h_open_in;
    reg h_close_in;
    wire [6:0] cur_fl_out; // dùng module
    wire [4:0] choose_fl_out; // assign
    wire [7:0] call_fl_out; // led
    wire [6:0] door_out_0; // 7 seg
    wire [6:0] door_out_1; // 7 seg
    wire [6:0] move_dir_out_0; // 7 seg
    wire [6:0] move_dir_out_1; // 7 seg
    wire [1:0] hold; // led
    wire [4:0] move_fl_check; // led
    wire [1:0] state_check;
    wire check;

    elevator #(
        .TEST(1)
    )elevator (
        .clk_in(clk_in),
        .en(en),
        .rst(rst),
        .call(call),
        .choose(choose),
        .h_open_in(h_open_in),
        .h_close_in(h_close_in),
        .cur_fl_out(cur_fl_out),
        .choose_fl_out(choose_fl_out),
        .call_fl_out(call_fl_out),
        .door_out_0(door_out_0),
        .door_out_1(door_out_1),
        .move_dir_out_0(move_dir_out_0),
        .move_dir_out_1(move_dir_out_1),
        .hold(hold),
        .move_fl_check(move_fl_check),
        .state_check(state_check),
        .check(check)
    );

    always #1 clk_in = ~clk_in;
    initial begin
        clk_in = 0;
        en = 1;
        rst = 1;
        call = 8'b00000000;
        choose = 5'b00000;
        h_open_in = 1;
        h_close_in = 1; // nút nhấn trên FPGA ko nhấn thì là 1
        // reset, tất cả ko động gì
        #10 rst = 0;
        // call = 8'b10010000; // tầng 5 call down, tầng 3 call up
        // #4 call = 0; // nhả nút call 
        // #10 call = 8'b00000001; // trong lúc đang đi lên tầng 1 call uo 
        // #4 call = 0;
        // #200 choose = 5'b00001; // choose tầng 1 (đang ở tầng 1 rồi)
        // #4 choose = 5'b01000; // choose tầng 4
        // #2 choose = 0; // nhả nút choose
        // #10 call = 8'b00000010; // tầng 2 call down (đang đi lên ở tầng 2)
        // #4 call = 0; // nhả nút call
        choose = 5'b10000; // đi lên tầng 5
        #2 choose = 0; // nhả nút choose
        #50 call = 8'b01100000; // tầng 4 vừa muốn đi lên vừa muốn đi xuống
        #4 call = 0; // nhả nút call
        #14 choose = 5'b10100; // vừa muốn đi xuống vừa muốn đi lên
        #2 choose = 0; // nhả nút choose
        #100 $finish; 
    end

endmodule