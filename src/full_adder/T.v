// test banch

`timescale 1ns/1ns

module T;
    reg Ain;
    reg Bin;
    reg Cin;
    wire Cout;
    wire Sum;

    full_adder UUT (
        .A(Ain),
        .B(Bin),
        .Ci(Cin),
        .Co(Cout),
        .S(Sum)
    );

    initial
    begin
        Ain = 1'b0;
        Bin = 1'b0;
        Cin = 1'b0;
        #100;
        
        Ain = 1'b1;
        Bin = 1'b0;
        Cin = 1'b0;
        #100;

        Ain = 1'b0;
        Bin = 1'b1;
        Cin = 1'b0;
        #100;

        Ain = 1'b1;
        Bin = 1'b1;
        Cin = 1'b0;
        #100;

        Ain = 1'b0;
        Bin = 1'b0;
        Cin = 1'b1;
        #100;

        Ain = 1'b0;
        Bin = 1'b1;
        Cin = 1'b1;
        #100;
    end

endmodule