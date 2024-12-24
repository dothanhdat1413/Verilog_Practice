`timescale 1ps/1ps
module test_7_seg_decoder;
    reg [3:0] bin_num;    
    wire [6:0] seg_num;

    integer i;

    7_seg_decoder DUT(
        .seg_num(seg_num),
        .bin_num(bin_num),
    );

    initial begin
        bin_num = 4'b1111;
    end

    for (i=0;i<15;i=i+1 ) begin
        #10;
        case (i)
            0 : begin
                bin_num = 4'b0000;
                if(seg_num != 7'b1111110) begin
                    $display("Error: 0");
                end
            end
            1 : begin
                bin_num = 4'b0001;
                if(seg_num != 7'b0110000) begin 
                    $display("Error: 1");
                end
            end
            2 : begin
                bin_num = 4'b0010;
                if(seg_num != 7'b1101101) begin
                    $display("Error: 2");
                end
            end
            3 : begin
                bin_num = 4'b0011;
                if(seg_num != 7'b1111001) begin 
                    $display("Error: 3");
                end
            end
            4 : begin
                bin_num = 4'b0100;
                if(seg_num != 7'b0110011) begin
                    $display("Error: 4");
                end
            end
            5 : begin
                bin_num = 4'b0101;
                if(seg_num != 7'b1011011) begin
                    $display("Error: 5");
                end
            end
            6 : begin 
                bin_num = 4'b0110;
                if(seg_num != 7'b1011111) begin
                    $display("Error: 6");
                end
            end
            7 : begin
                bin_num = 4'b0111;
                if(seg_num != 7'b1110000) begin
                    $display("Error: 7");
                end
            end
            8 : begin 
                bin_num = 4'b1000;
                if(seg_num != 7'b1111111) begin
                    $display("Error: 8");
                end
            end
            9 : begin 
                bin_num = 4'b1001;
                if(seg_num != 7'b1111011) begin
                    $display("Error: 9");
                end
            end
            10: begin
                bin_num = 4'b1010;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 10");
                end
            end
            11: begin 
                bin_num = 4'b1011;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 11");
                end
            end
            12: begin 
                bin_num = 4'b1100;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 12");
                end
            end
            13: begin 
                bin_num = 4'b1101;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 13");
                end
            end
            14: begin
                bin_num = 4'b1110;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 14");
                end
            end
            15: begin 
                bin_num = 4'b1111;
                if(seg_num != 7'b0000000) begin
                    $display("Error: 15");
                end
            end 
            default: begin
                bin_num = 4'b0000;
                if(seg_num != 7'b1111110) begin
                    $display("Error: 0");
                end
            end
        endcase
    end


endmodule