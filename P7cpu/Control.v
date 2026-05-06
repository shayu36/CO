`timescale 1ns / 1ps
module Control(
    input [5:0] opcode,
    input [4:0] rs,
    input [5:0] func,
    output [5:0] type,
    output [1:0] NPCslt,
    output ALUsrc,
    output grfWE,
    output [1:0] RegDst,
    output EXTOp,
    output [1:0] MemtoReg,
    output mfop,
    output cpop,
    output cpWE,
    output [4:0] ExcCode,
    output start,
	output[3:0] t_rs,
	output[3:0] t_rt,
	output[3:0] t
    );
	parameter NOP=6'b000000,
        ADD   = 6'b000001,
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
        SW    = 6'b010000,
        MULT  = 6'b010001,
        MULTU = 6'b010010,
        DIV   = 6'b010011,
        DIVU  = 6'b010100,
        MFHI  = 6'b010101,
        MFLO  = 6'b010110,
        MTHI  = 6'b010111,
        MTLO  = 6'b011000,
        BEQ   = 6'b011001,
        BNE   = 6'b011010,
        JAL   = 6'b011011,
        JR    = 6'b011100,
        MFC0  = 6'b011101,
        MTC0  = 6'b011110,
        SYSCALL=6'b011111,
        ERET  = 6'b100000;
    wire nop;
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
    wire mfc0;
    wire mtc0;
    wire syscall;
    wire eret;
    wire [4:0] ExcCode;
    assign nop    = (opcode == 6'h00 && func == 6'h00);
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
    assign mfc0   = (opcode == 6'h10 && rs == 5'h0);
    assign mtc0   = (opcode == 6'h10 && rs == 5'h4);
    assign syscall= (opcode == 6'h00 && func == 6'b001100);
    assign eret   = (opcode == 6'b010000 && func == 6'b011000);
	assign type = (nop)?NOP  :
              (add)   ? ADD  :
              (sub)   ? SUB  :
              (_and)  ? AND  :
              (_or)   ? OR   :
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
              (mfc0)  ? MFC0 :
              (mtc0)  ? MTC0 :
              (syscall)?SYSCALL:
              (eret)  ? ERET :
              6'b111111;

			  
	assign NPCslt = (beq|bne) ? 2'b01 :
                 (jal) ? 2'b10 :
                 (jr) ? 2'b11 : 2'b00;	
	assign ALUsrc = (addi|andi|ori | lui | lw | sw|lb|lh|sb|sh) ? 1'b1 : 1'b0;
	assign grfWE = (add | sub|_and |_or|slt|sltu|addi|andi| ori | lui |lb|lh| lw | jal|mfhi|mflo|mfc0) ? 1'b1 : 1'b0;
	assign RegDst = (jal)? 2'b10:(add | sub|_or|_and|slt|sltu|mfhi|mflo) ? 2'b01 : 2'b00;
	assign EXTOp = (lw | sw|lb|lh|sb|sh|addi) ? 1'b1 : 1'b0;
	assign MemtoReg = (jal)?2'b10:(lw|lb|lh) ? 2'b01 : 2'b00;
    assign mfop = (mfhi|mflo) ? 1'b1 : 1'b0;
    assign cpop =(mfc0)?1'b1:1'b0;
    assign cpWE =(mtc0)?1'b1:1'b0;
    assign start=(mult|multu|div|divu)?1:0;
    assign ExcCode=(type==SYSCALL)?5'd8:(type==6'b111111)?5'd10:5'd0;

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
              (mfc0)  ? 4'hf :
              (mtc0)  ? 4'hf :
              (nop)   ? 4'hf :
              (syscall)?4'hf :
              (eret)  ? 4'hf :
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
              (mfc0)  ? 4'hf :
              (mtc0)  ? 4'h2 :
              (nop)   ? 4'hf :
              (syscall)?4'hf :
              (eret)  ? 4'hf :
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
           (mfc0)  ? 4'h3 :
           (mtc0)  ? 4'hf :
           (nop)   ? 4'hf :
           (syscall)?4'hf :
           (eret)  ? 4'hf :
           4'hf;
endmodule
