`timescale 1ns/1ns

module test_majority ();
    reg [31:0] num;
    wire more_bit_1;

    reg [31:0]  inputdata [32:0] ;
    reg  expected_output [32:0] ;

    majority DUT (
        .num(num),
        .more_bit_1(more_bit_1)
    );  
    integer i, test_fail_count;  
    initial begin : read_file
        test_fail_count = 0;
        $display("_________________________Start test__________________________");
      //  #10;
        $readmemb("K:/OneDrive - Hanoi University of Science and Technology/EDABK Lab/Verilog/Digital-design-lab/Majority/test_input.mem", inputdata);
        $readmemb("K:/OneDrive - Hanoi University of Science and Technology/EDABK Lab/Verilog/Digital-design-lab/Majority/test_output.mem", expected_output); 

        for(i = 0; i < 33; i = i + 1) begin
            num = inputdata[i];
            #10;
            if(more_bit_1 != expected_output[i])begin
                $display("Test failed at %d, more_bit_1=%b, should be %b", i, more_bit_1, expected_output[i]);
                test_fail_count = test_fail_count + 1;
            end
        end
        
        if(test_fail_count) begin
            $display("______________________%2d tests failed________________________", test_fail_count);
        end
        else begin
            $display("______________________All tests passed_______________________");
        end
        $display("__________________________End test___________________________");
    end

endmodule