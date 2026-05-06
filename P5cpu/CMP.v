`timescale 1ns / 1ps
module CMP(
    input [31:0] inputA,
    input [31:0] inputB,
    input [3:0] type,
    output zero
    );
    parameter BEQ = 4'b0110;
    
    assign zero=(type==BEQ&&inputA==inputB)?1'b1:1'b0;

endmodule
