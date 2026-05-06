`timescale 1ns / 1ps
module EXT (
    input [15:0] imm16,
    input EXTOp,
    output [31:0] EXT32
);
    assign EXT32 = (EXTOp == 0) ? {16'b0, imm16} : {{16{imm16[15]}}, imm16};
endmodule
