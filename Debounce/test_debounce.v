`timescale 1ps / 1ps

module test_debounce();

    reg clk;
    reg reset;
    reg button_in;
    wire button_out;

    always #1 clk = ~clk;
    debounce #(
        .DEBOUNCE_DELAY(100) // 200 lần xung đảo mới debounce
    )DUT(
        .clk(clk),
        .reset(reset),
        .button_in(button_in),
        .button_out(button_out)
    );

    integer i;
    initial begin
        #10;
        clk = 0;
        reset = 1;
        button_in = 0;
        #10 reset = 0; // 
        for ( i = 0; i < 11; i = i + 1) begin // nhấp nháy 9 lần
            #20 button_in = ~button_in;
        end

        #500 button_in = 0; // thả nút nhấn
        #10 button_in = 1; // nhấn nút
        for ( i = 0; i < 30; i = i + 1) begin // nhấp nháy 9 lần
            #20 button_in = ~button_in;
        end
        #10 button_in = 0; // thả nút nhấn
        #500 button_in = 1; // nhấn nút
        #1000 $finish;
    end

    always @(*) begin
        if(button_out) begin
            $display("%t Button is pressed", $time);
        end else begin
            $display("Button is released");
        end
    end

endmodule