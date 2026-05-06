`timescale 1ns / 1ps
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] type,
    output [31:0] out
    );
	parameter ADD = 4'b0001,
          SUB = 4'b0010,
          ORI = 4'b0011,
          LW   = 4'b0100,
          SW   = 4'b0101,
          BEQ  = 4'b0110,
          LUI  = 4'b0111,
          J    = 4'b1000,
          JAL  = 4'b1001,
          JR   = 4'b1010,
		  NEW  = 4'b1011;
	wire[31:0] add;
	assign add=A+B;
	wire[31:0] sub;
	assign sub=A-B;
	wire[31:0] ori;
	assign ori=A|B;
	wire[31:0] lui;
	assign lui=B<<16;	
	assign out=(type==ADD)?add:
				(type==SUB)?sub:
				(type==ORI)?ori:
				(type==LW)?add:
				(type==SW)? add:
				(type==BEQ)?add:
				(type==LUI)?lui:
				(type==NEW)?add:
				32'hffffffff;
endmodule
