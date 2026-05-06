`timescale 1ns / 1ps
module CMP(
    input [31:0] inputA,
    input [31:0] inputB,
    input [5:0] type,
    output sign,
    output[31:0] sign_out,
    output zero
    );
    parameter BEQ   = 5'b11001,
        BNE   = 5'b11010;
    
    assign zero=(type==BEQ&&inputA==inputB)?1'b1:
                (type==BNE&&inputA!=inputB)?1'b1:1'b0;
    assign sign=(type==5'b11101);
endmodule
