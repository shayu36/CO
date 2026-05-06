`timescale 1ns / 1ps
module ALU(
    input  [31:0] A,
    input  [31:0] B,
    input  [4:0]  type,
    output [31:0] out
);
    parameter ADD   = 5'b00001,
              SUB   = 5'b00010,
              AND   = 5'b00011,
              OR    = 5'b00100,
              SLT   = 5'b00101,
              SLTU  = 5'b00110,
              LUI   = 5'b00111,
              ADDI  = 5'b01000,
              ANDI  = 5'b01001,
              ORI   = 5'b01010,
              LB    = 5'b01011,
              LH    = 5'b01100,
              LW    = 5'b01101,
              SB    = 5'b01110,
              SH    = 5'b01111,
              SW    = 5'b10000,
              NEW   = 5'b11101;

    wire [31:0] add;
    wire [31:0] sub;
    wire [31:0] _and;
    wire [31:0] _or;
    wire [31:0] slt;
    wire [31:0] sltu;
    wire [31:0] lui;
    wire [31:0] addi;
    wire [31:0] andi;
    wire [31:0] ori;
    wire [31:0] new;

    assign add  = A + B;
    assign sub  = A - B;
    assign _and = A & B;
    assign _or  = A | B;
    assign slt  = ($signed(A) < $signed(B)) ? 32'h00000001 : 32'h00000000;
    assign sltu = (A < B) ? 32'h00000001 : 32'h00000000;
    assign lui  = B << 16;
    assign addi = A + B;
    assign andi = A & B;
    assign ori  = A | B;

    assign out = (type == ADD)   ? add   :
                 (type == SUB)   ? sub   :
                 (type == AND)   ? _and  :
                 (type == OR)    ? _or   :
                 (type == SLT)   ? slt   :
                 (type == SLTU)  ? sltu  :
                 (type == LUI)   ? lui   :
                 (type == ADDI)  ? addi  :
                 (type == ANDI)  ? andi  :
                 (type == ORI)   ? ori   :
                 (type == LB)    ? add   :
                 (type == LH)    ? add   :
                 (type == LW)    ? add   :
                 (type == SB)    ? add   :
                 (type == SH)    ? add   :
                 (type == SW)    ? add   :
                 (type==NEW)     ? add   :
                 32'hffffffff;

endmodule