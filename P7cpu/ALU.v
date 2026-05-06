`timescale 1ns / 1ps
module ALU(
    input  [31:0] A,
    input  [31:0] B,
    input  [5:0]  type,
    output [31:0] out,
    output [4:0] ExcCode
);
    parameter ADD   = 6'b000001,
              SUB   = 6'b000010,
              AND   = 6'b000011,
              OR    = 6'b000100,
              SLT   = 6'b000101,
              SLTU  = 6'b000110,
              LUI   = 6'b000111,
              ADDI  = 6'b001000,
              ANDI  = 6'b001001,
              ORI   = 6'b001010,
              LB    = 6'b001011,
              LH    = 6'b001100,
              LW    = 6'b001101,
              SB    = 6'b001110,
              SH    = 6'b001111,
              SW    = 6'b010000;
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
                 32'hffffffff;

  // interrupt and exception
    wire [32:0] add_overflow_temp;
    wire [32:0] sub_overflow_temp;
    wire overflow;

    assign add_overflow_temp = {A[31], A} + {B[31], B};
    assign sub_overflow_temp = {A[31], A} - {B[31], B};
    assign overflow = ((type == ADD  || type == ADDI || type == LW  || type == LH  || type == LB || 
                        type == SW  || type == SH  || type == SB) && (add_overflow_temp[32] !=              add_overflow_temp[31])) ? 1'b1 : 
                    ((type == SUB) && (sub_overflow_temp[32] != sub_overflow_temp[31])) ? 1'b1:1'b0;

    wire [4:0] ExcCode;
    assign ExcCode = (type == LW && add[1:0] != 2'b00) ? 5'd4 :
                    (type == LH && add[0] != 1'b0) ? 5'd4 :
                    (type == SW && add[1:0] != 2'b00) ? 5'd5 :
                    (type == SH && add[0] != 1'b0) ? 5'd5 :
                    (type == LW && !((add >= 32'h00000000 && add < 32'h00003000) || 
                                    (add >= 32'h00007f00 && add < 32'h00007f0c) || 
                                    (add >= 32'h00007f10 && add < 32'h00007f1c) || 
                                    (add >= 32'h00007f20 && add < 32'h00007f24))) ? 5'd4 :
                    ((type == LH || type == LB) && !((add >= 32'h00000000 && add < 32'h00003000) || 
                                                    (add >= 32'h00007f20 && add < 32'h00007f24))) ? 5'd4 :
                    (type == SW && !((add >= 32'h00000000 && add < 32'h00003000) || 
                                    (add >= 32'h00007f00 && add < 32'h00007f08) || 
                                    (add >= 32'h00007f10 && add < 32'h00007f18) || 
                                    (add >= 32'h00007f20 && add < 32'h00007f24))) ? 5'd5 :
                    ((type == SH || type == SB) && !((add >= 32'h00000000 && add < 32'h00003000) || 
                                                    (add >= 32'h00007f20 && add < 32'h00007f24))) ? 5'd5 :
                    ((type == LW || type == LH || type == LB) && overflow) ? 5'd4 :
                    ((type == SW || type == SH || type == SB) && overflow) ? 5'd5 :
                    ((type == ADD || type == SUB || type == ADDI) && overflow) ? 5'd12 : 
                    5'd0;

endmodule