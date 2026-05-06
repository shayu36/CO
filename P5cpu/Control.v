`timescale 1ns / 1ps
module Control(
    input [5:0] opcode,
    input [5:0] func,
    output [3:0] type,
    output [1:0] NPCslt,
    output ALUsrc,
    output grfWE,
    output [1:0] RegDst,
    output EXTOp,
    output [1:0] MemtoReg,
    output DMWE,
	output[3:0] t_rs,
	output[3:0] t_rt,
	output[3:0] t
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
	wire add;
	wire sub;
	wire ori;
	wire lw;
	wire sw;
	wire beq;
	wire lui;
	wire j;
	wire jal;
	wire jr;
	wire new;
	assign add=(opcode==6'h0&&func==6'h20);
	assign sub=(opcode==6'h0&&func==6'h22);
	assign ori=(opcode==6'h0d);
	assign lw=(opcode==6'h23);
	assign sw=(opcode==6'h2b);
	assign beq=(opcode==6'h04);
	assign lui=(opcode==6'h0f);
	assign j=(opcode==6'h02);
	assign jal=(opcode==6'h03);
	assign jr=(opcode==6'h0&&func==6'h08);
	assign new=(opcode==6'b111111);
	assign type = (add) ? ADD :
              (sub) ? SUB :
              (ori) ? ORI :
              (lui) ? LUI :
              (lw) ? LW :
              (sw) ? SW :
              (beq) ? BEQ :
              (j) ? J :
              (jal) ? JAL :
              (jr) ? JR :
			  (new)? NEW:
			  4'b1111;
			  
	assign NPCslt = (beq) ? 2'b01 :
                 (j||jal) ? 2'b10 :
                 (jr) ? 2'b11 : 2'b00;	
	assign ALUsrc = (ori | lui | lw | sw) ? 1'b1 : 1'b0;
	assign grfWE = (add | sub | ori | lui | lw | jal) ? 1'b1 : 1'b0;
	assign RegDst = (jal)? 2'b10:(add | sub) ? 2'b01 : 2'b00;
	assign EXTOp = (lw | sw) ? 1'b1 : 1'b0;
	assign MemtoReg = (jal)?2'b10:(lw) ? 2'b01 : 2'b00;
	assign DMWE = (sw) ? 1'b1 : 1'b0;

	assign t_rs = (add) ? 4'h1 :
              (sub) ? 4'h1 :
              (ori) ? 4'h1 :
              (lui) ? 4'hf :
              (lw) ? 4'h1 :
              (sw) ? 4'h1 :
              (beq) ? 4'h0 :
              (j) ? 4'hf :
              (jal) ? 4'hf :
              (jr) ? 4'h0 :
            4'hf;

assign t_rt = (add) ? 4'h1 :
              (sub) ? 4'h1 :
              (ori) ? 4'hf :
              (lui) ? 4'hf :
              (lw) ? 4'hf :
              (sw) ? 4'h2 :
              (beq) ? 4'h0 :
              (j) ? 4'hf :
              (jal) ? 4'hf :
              (jr) ? 4'hf :
               4'hf;

assign t = (add) ? 4'h2 :
           (sub) ? 4'h2 :
           (ori) ? 4'h2 :
           (lui) ? 4'h2 :
           (lw) ? 4'h3 :
           (sw) ? 4'hf :
           (beq) ? 4'hf :
           (j) ? 4'hf :
           (jal) ? 4'h0 :
           (jr) ? 4'hf :
           4'hf;
endmodule
