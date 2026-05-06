`timescale 1ns / 1ps
module Control(
    input [5:0] opcode,
    input [5:0] func,
    output [4:0] type,
    output [1:0] NPCslt,
    output ALUsrc,
    output grfWE,
    output [1:0] RegDst,
    output EXTOp,
    output [1:0] MemtoReg,
    output mfop,
    output start,
	output[3:0] t_rs,
	output[3:0] t_rt,
	output[3:0] t
    );
	parameter ADD   = 5'b00001,
        SUB   = 5'b00010,
        AND= 5'b00011,
        OR = 5'b00100,
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
        MULT  = 5'b10001,
        MULTU = 5'b10010,
        DIV   = 5'b10011,
        DIVU  = 5'b10100,
        MFHI  = 5'b10101,
        MFLO  = 5'b10110,
        MTHI  = 5'b10111,
        MTLO  = 5'b11000,
        BEQ   = 5'b11001,
        BNE   = 5'b11010,
        JAL   = 5'b11011,
        JR    = 5'b11100,
        NEW   = 5'b11101;
	wire add;
    wire sub;
    wire _and;  
    wire _or;
    wire slt;
    wire sltu;
    wire lui;
    wire addi;
    wire andi;
    wire ori;
    wire lb;
    wire lh;
    wire lw;
    wire sb;
    wire sh;
    wire sw;
    wire mult;
    wire multu;
    wire div;
    wire divu;
    wire mfhi;
    wire mflo;
    wire mthi;
    wire mtlo;
    wire beq;
    wire bne;
    wire jal;
    wire jr;
    wire new;
	assign add    = (opcode == 6'h00 && func == 6'h20);
    assign sub    = (opcode == 6'h00 && func == 6'h22);
    assign _and = (opcode == 6'h00 && func == 6'h24);
    assign _or  = (opcode == 6'h00 && func == 6'h25);
    assign slt    = (opcode == 6'h00 && func == 6'h2a);
    assign sltu   = (opcode == 6'h00 && func == 6'h2b);
    assign lui    = (opcode == 6'h0f);
    assign addi   = (opcode == 6'h08);
    assign andi   = (opcode == 6'h0c);
    assign ori    = (opcode == 6'h0d);
    assign lb     = (opcode == 6'h20);
    assign lh     = (opcode == 6'h21);
    assign lw     = (opcode == 6'h23);
    assign sb     = (opcode == 6'h28);
    assign sh     = (opcode == 6'h29);
    assign sw     = (opcode == 6'h2b);
    assign mult   = (opcode == 6'h00 && func == 6'h18);
    assign multu  = (opcode == 6'h00 && func == 6'h19);
    assign div    = (opcode == 6'h00 && func == 6'h1a);
    assign divu   = (opcode == 6'h00 && func == 6'h1b);
    assign mfhi   = (opcode == 6'h00 && func == 6'h10);
    assign mflo   = (opcode == 6'h00 && func == 6'h12);
    assign mthi   = (opcode == 6'h00 && func == 6'h11);
    assign mtlo   = (opcode == 6'h00 && func == 6'h13);
    assign beq    = (opcode == 6'h04);
    assign bne    = (opcode == 6'h05);
    assign jal    = (opcode == 6'h03);
    assign jr     = (opcode == 6'h00 && func == 6'h08);
    assign new    = (opcode == 6'b111111);
	assign type = (add)   ? ADD  :
              (sub)   ? SUB  :
              (_and)   ? AND  :
              (_or)    ? OR   :
              (slt)   ? SLT  :
              (sltu)  ? SLTU :
              (lui)   ? LUI  :
              (addi)  ? ADDI :
              (andi)  ? ANDI :
              (ori)   ? ORI  :
              (lb)    ? LB   :
              (lh)    ? LH   :
              (lw)    ? LW   :
              (sb)    ? SB   :
              (sh)    ? SH   :
              (sw)    ? SW   :
              (mult)  ? MULT :
              (multu) ? MULTU:
              (div)   ? DIV  :
              (divu)  ? DIVU :
              (mfhi)  ? MFHI :
              (mflo)  ? MFLO :
              (mthi)  ? MTHI :
              (mtlo)  ? MTLO :
              (beq)   ? BEQ  :
              (bne)   ? BNE  :
              (jal)   ? JAL  :
              (jr)    ? JR   :
              (new)   ? NEW  :
              5'b11111;

			  
	assign NPCslt = (beq|bne) ? 2'b01 :
                 (jal) ? 2'b10 :
                 (jr) ? 2'b11 : 2'b00;	
	assign ALUsrc = (addi|andi|ori | lui | lw | sw|lb|lh|sb|sh) ? 1'b1 : 1'b0;
	assign grfWE = (add | sub|_and |_or|slt|sltu|addi|andi| ori | lui |lb|lh| lw | jal|mfhi|mflo) ? 1'b1 : 1'b0;
	assign RegDst = (jal)? 2'b10:(add | sub|_or|_and|slt|sltu|mfhi|mflo) ? 2'b01 : 2'b00;
	assign EXTOp = (lw | sw|lb|lh|sb|sh|addi) ? 1'b1 : 1'b0;
	assign MemtoReg = (jal)?2'b10:(lw|lb|lh) ? 2'b01 : 2'b00;
    assign mfop = (mfhi|mflo) ? 1'b1 : 1'b0;
    assign start=(mult|multu|div|divu)?1:0;

	assign t_rs = (add)   ? 4'h1 :
              (sub)   ? 4'h1 :
              (_and)  ? 4'h1 :
              (_or)   ? 4'h1 :
              (slt)   ? 4'h1 :
              (sltu)  ? 4'h1 :
              (addi)  ? 4'h1 :
              (andi)  ? 4'h1 :
              (ori)   ? 4'h1 :
              (lui)   ? 4'hf :
              (lb)    ? 4'h1 :
              (lh)    ? 4'h1 :
              (lw)    ? 4'h1 :
              (sb)    ? 4'h1 :
              (sh)    ? 4'h1 :
              (sw)    ? 4'h1 :
              (beq)   ? 4'h0 :
              (bne)   ? 4'h0 :
              (jal)   ? 4'hf :
              (jr)    ? 4'h0 :
              (mult)  ? 4'h1 :
              (multu) ? 4'h1 :
              (div)   ? 4'h1 :
              (divu)  ? 4'h1 :
              (mfhi)  ? 4'hf :
              (mflo)  ? 4'hf :
              (mthi)  ? 4'h1 :
              (mtlo)  ? 4'h1 :
              (new)   ? 4'hf :
              4'hf;

assign t_rt = (add)   ? 4'h1 :
              (sub)   ? 4'h1 :
              (_and)  ? 4'h1 :
              (_or)   ? 4'h1 :
              (slt)   ? 4'h1 :
              (sltu)  ? 4'h1 :
              (addi)  ? 4'hf :
              (andi)  ? 4'hf :
              (ori)   ? 4'hf :
              (lui)   ? 4'hf :
              (lb)    ? 4'hf :
              (lh)    ? 4'hf :
              (lw)    ? 4'hf :
              (sb)    ? 4'h2 :
              (sh)    ? 4'h2 :
              (sw)    ? 4'h2 :
              (beq)   ? 4'h0 :
              (bne)   ? 4'h0 :
              (jal)   ? 4'hf :
              (jr)    ? 4'hf :
              (mult)  ? 4'h1 :
              (multu) ? 4'h1 :
              (div)   ? 4'h1 :
              (divu)  ? 4'h1 :
              (mfhi)  ? 4'hf :
              (mflo)  ? 4'hf :
              (mthi)  ? 4'hf :
              (mtlo)  ? 4'hf :
              (new)   ? 4'hf :
              4'hf;

assign t = (add)   ? 4'h2 :
           (sub)   ? 4'h2 :
           (_and)  ? 4'h2 :
           (_or)   ? 4'h2 :
           (slt)   ? 4'h2 :
           (sltu)  ? 4'h2 :
           (addi)  ? 4'h2 :
           (andi)  ? 4'h2 :
           (ori)   ? 4'h2 :
           (lui)   ? 4'h2 :
           (lb)    ? 4'h3 :
           (lh)    ? 4'h3 :
           (lw)    ? 4'h3 :
           (sb)    ? 4'hf :
           (sh)    ? 4'hf :
           (sw)    ? 4'hf :
           (beq)   ? 4'hf :
           (bne)   ? 4'hf :
           (jal)   ? 4'h0 :
           (jr)    ? 4'hf :
           (mult)  ? 4'hf :
           (multu) ? 4'hf :
           (div)   ? 4'hf :
           (divu)  ? 4'hf :
           (mfhi)  ? 4'h2 :
           (mflo)  ? 4'h2 :
           (mthi)  ? 4'hf :
           (mtlo)  ? 4'hf :
           (new)   ? 4'hf :
           4'hf;
endmodule
