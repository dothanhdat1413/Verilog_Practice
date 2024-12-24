module CSA #(
    parameter MAX = 0
)(
    input A,
    input B,
    input Cin,
    input Sin,
    output Cout,
    output Sout
);
    generate
        if(MAX == 0) begin
            assign Sout = (A & B) ^ Cin ^ Sin;
            assign Cout = (Cin & Sin) | (Cin & A & B) | (A & B & Sin);
        end else begin
            assign Sout = (!(A&B)) ^ Cin ^ Sin;
            assign Cout = (Cin & Sin) | (Cin & (!(A&B))) | ((!(A&B)) & Sin); // ở rìa thì cần nhân và đảo
        end

    endgenerate
endmodule