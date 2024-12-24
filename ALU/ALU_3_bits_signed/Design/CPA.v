module CPA(
    input num_1, num_2, c_in,
    output sum, c_out
    );
        assign sum = num_1 ^ num_2 ^ c_in;
        assign c_out = (num_1 & num_2) | (num_1 & c_in) | (num_2 & c_in);
endmodule


