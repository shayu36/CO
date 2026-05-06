`timescale 1ns / 1ps `default_nettype none
module mips (
    input wire clk,
    input wire reset
);
    //F zone /////////////////
    wire [31:0] F_PC;
    wire [31:0] F_PC8;
    wire [31:0] F_NPC;
    wire [31:0] F_Instr;
    //D zone///////////////////
    wire [31:0] D_PC;
    wire [31:0] D_PC8;
    //D_Instruction
    wire [31:0] D_Instr;
    wire [5:0] D_opcode;
    wire [5:0] D_func;
    wire [5:0] D_rs;
    wire [5:0] D_rt;
    wire [5:0] D_rd;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    //D_control
    wire [1:0] D_NPCslt;
    wire [1:0] D_RegDst;
    wire D_EXTOp;
    wire [3:0] D_type;
    wire [3:0] D_t_rs;
    wire [3:0] D_t_rt;
    wire [3:0] D_t;
    //D_ext
    wire [31:0] D_ext32;
    //D_GRF
    wire [4:0] D_A1;
    wire [4:0] D_A2;
    wire [4:0] D_A3;
    wire [31:0] D_RD1;
    wire [31:0] D_RD2;
    //D_CMP
    wire D_zero;

    //E zone/////////////////
    wire [31:0] E_PC;
    wire [31:0] E_PC8;
    wire [31:0] E_ext32;
    wire [31:0] E_RD1;
    wire [31:0] E_RD2;
    wire [4:0] E_A3;
    //E_Instruction
    wire [31:0] E_Instr;
    wire [5:0] E_opcode;
    wire [4:0] E_rs;
    wire [4:0] E_rt;
    wire [5:0] E_func;
    wire [15:0] E_imm16;
    wire [25:0] E_imm26;
    //E_control
    wire [3:0] E_type;
    wire E_ALUsrc;
    wire [3:0] E_t_rs;
    wire [3:0] E_t_rt;
    wire [3:0] E_t;
    //E_ALU
    wire [31:0] E_ALUinputA;
    wire [31:0] E_ALUinputB;
    wire [31:0] E_ALUout;

    //M zone/////////////////
    wire [31:0] M_PC;
    wire [31:0] M_PC8;
    wire [31:0] M_ALUout;
    wire [31:0] M_RD2;
    wire [4:0] M_A3;
    //M_Instruction
    wire [31:0] M_Instr;
    wire [5:0] M_opcode;
    wire [4:0] M_rs;
    wire [4:0] M_rt;
    wire [5:0] M_func;
    wire [15:0] M_imm16;
    wire [25:0] M_imm26;
    //M_Control
    wire [3:0] M_type;
    wire M_DMWE;
    wire [3:0] M_t_rs;
    wire [3:0] M_t_rt;
    wire [3:0] M_t;
    //M_DM
    wire [31:0] M_DMaddr;
    wire [31:0] M_DMWD;
    wire [31:0] M_DMdata;
    wire [7:0] M_DMbyte;

    //W zone/////////////////
    wire [31:0] W_PC;
    wire [31:0] W_PC8;
    wire [4:0] W_A3;
    wire [31:0] W_ALUout;
    wire [31:0] W_DMdata;
    wire [7:0] W_DMbyte;
    //W_Instrution
    wire [31:0] W_Instr;
    wire [5:0] W_opcode;
    wire [4:0] W_rs;
    wire [4:0] W_rt;
    wire [5:0] W_func;
    wire [15:0] W_imm16;
    wire [25:0] W_imm26;
    //W_Control
    wire [3:0] W_type;
    wire W_grfWE;
    wire [1:0] W_MemtoReg;
    wire [3:0] W_t_rs;
    wire [3:0] W_t_rt;
    wire [3:0] W_t;
    //W_GRF
    wire [31:0] W_grfWD;


    //F zone ////////////////
    PC PC (
        .clk(clk),
        .reset(reset),
        .PC_en(PC_en),
        .NPC(F_NPC),
        .PC(F_PC)
    );
    NPC NPC (
        .F_PC(F_PC),
        .imm16(D_imm16),
        .imm26(D_imm26),
        .GRF(D_fixedRD1),
        .NPCslt(D_NPCslt),
        .zero(D_zero),
        .NPC(F_NPC)
    );
    IM F_IM (
        .addr(F_PC),
        .data(F_Instr)
    );
    FDreg FDreg (
        .clk(clk),
        .reset(reset),
        .FD_en(FD_en),
        .FD_clear(FD_clear),
        .F_Instr(F_Instr),
        .F_PC(F_PC),
        .F_PC8(F_PC8),
        .D_Instr(D_Instr),
        .D_PC(D_PC),
        .D_PC8(D_PC8)
    );
    // D zone ////////////////
    Control D_Control (
        .opcode(D_opcode),
        .func(D_func),
        .type(D_type),
        .NPCslt(D_NPCslt),
        .RegDst(D_RegDst),
        .EXTOp(D_EXTOp),
        .t_rs(D_t_rs),
        .t_rt(D_t_rt),
        .t(D_t)
    );
    EXT D_EXT (
        .imm16(D_imm16),
        .EXTOp(D_EXTOp),
        .EXT32(D_ext32)
    );
    grf D_grf (
        .clk(clk),
        .reset(reset),
        .PC(W_PC),
        .A1(D_A1),
        .A2(D_A2),
        .A3(W_A3),
        .grfWE(W_grfWE),
        .grfWD(W_grfWD),
        .RD1(D_RD1),
        .RD2(D_RD2)
    );
    CMP D_CMP (
        .inputA(D_fixedRD1),
        .inputB(D_fixedRD2),
        .type  (D_type),
        .zero  (D_zero)
    );
    DEreg DEreg (
        .clk(clk),
        .reset(reset),
        .D_Instr(D_Instr),
        .DE_clear(DE_clear),
        .D_PC(D_PC),
        .D_PC8(D_PC8),
        .D_RD1(D_fixedRD1),
        .D_RD2(D_fixedRD2),
        .D_A3(D_A3),
        .D_ext32(D_ext32),
        .E_Instr(E_Instr),
        .E_PC(E_PC),
        .E_PC8(E_PC8),
        .E_RD1(E_RD1),
        .E_RD2(E_RD2),
        .E_A3(E_A3),
        .E_ext32(E_ext32)
    );
    //E zone/////////////
    Control E_Control (
        .opcode(E_opcode),
        .func  (E_func),
        .type  (E_type),
        .ALUsrc(E_ALUsrc),
        .t_rs  (E_t_rs),
        .t_rt  (E_t_rt),
        .t     (E_t)
    );
    ALU E_ALU (
        .A(E_ALUinputA),
        .B(E_ALUinputB),
        .type(E_type),
        .out(E_ALUout)
    );
    EMreg EMreg (
        .clk(clk),
        .reset(reset),
        .E_Instr(E_Instr),
        .E_PC(E_PC),
        .E_PC8(E_PC8),
        .E_ALUout(E_ALUout),
        .E_RD2(E_fixedRD2),
        .E_A3(E_A3),
        .M_Instr(M_Instr),
        .M_PC(M_PC),
        .M_PC8(M_PC8),
        .M_ALUout(M_ALUout),
        .M_RD2(M_RD2),
        .M_A3(M_A3)
    );

    //M zone/////////////
    Control M_Control (
        .opcode(M_opcode),
        .func  (M_func),
        .type  (M_type),
        .DMWE  (M_DMWE),
        .t_rs  (M_t_rs),
        .t_rt  (M_t_rt),
        .t     (M_t)
    );
    DM M_DM (
        .clk(clk),
        .reset(reset),
        .DMWE(M_DMWE),
        .PC(M_PC),
        .addr(M_DMaddr),
        .DMWD(M_DMWD),
        .data(M_DMdata),
        .byte(M_DMbyte)
    );
    MWreg MWreg (
        .clk(clk),
        .reset(reset),
        .M_Instr(M_Instr),
        .M_PC(M_PC),
        .M_PC8(M_PC8),
        .M_A3(M_A3),
        .M_ALUout(M_ALUout),
        .M_data(M_DMdata),
        .M_byte(M_DMbyte),
        .W_Instr(W_Instr),
        .W_PC(W_PC),
        .W_PC8(W_PC8),
        .W_A3(W_A3),
        .W_ALUout(W_ALUout),
        .W_data(W_DMdata),
        .W_byte(W_DMbyte)
    );

    //W zone/////////////
    Control W_Control (
        .opcode  (W_opcode),
        .func    (W_func),
        .type    (W_type),
        .grfWE   (W_grfWE),
        .MemtoReg(W_MemtoReg),
        .t_rs    (W_t_rs),
        .t_rt    (W_t_rt),
        .t       (W_t)
    );

    //assign
    //F zone //////////////
    assign F_PC8 = F_PC + 32'h00000008;
    //D zone ///////////////
    assign D_PC8 = D_PC + 32'h00000008;
    assign D_opcode = D_Instr[31:26];
    assign D_func = D_Instr[5:0];
    assign D_rs = D_Instr[25:21];
    assign D_rt = D_Instr[20:16];
    assign D_rd = D_Instr[15:11];
    assign D_imm16 = D_Instr[15:0];
    assign D_imm26 = D_Instr[25:0];
    assign D_A1 = D_rs;
    assign D_A2 = D_rt;
    assign D_A3 = (D_RegDst==2'b00)?D_rt:
                    (D_RegDst==2'b01)?D_rd:
                    (D_RegDst==2'b10)?5'b11111:
                    5'b00000;

    // E zone ////////////////////////////////
    assign E_PC8 = E_PC + 32'h00000008;
    assign E_opcode = E_Instr[31:26];
    assign E_func = E_Instr[5:0];
    assign E_rs = E_Instr[25:21];
    assign E_rt = E_Instr[20:16];
    assign E_imm16 = E_Instr[15:0];
    assign E_imm26 = E_Instr[25:0];
    assign E_ALUinputA = E_fixedRD1;
    assign E_ALUinputB = (E_ALUsrc) ? E_ext32 : E_fixedRD2;

    // M zone ////////////////////////////////
    assign M_PC8 = M_PC + 32'h00000008;
    assign M_opcode = M_Instr[31:26];
    assign M_rs = M_Instr[25:21];
    assign M_rt = M_Instr[20:16];
    assign M_func = M_Instr[5:0];
    assign M_imm16 = M_Instr[15:0];
    assign M_imm26 = M_Instr[25:0];
    assign M_DMaddr = M_ALUout;
    assign M_DMWD = M_fixedRD2;

    // W zone ////////////////////////////////
    assign W_PC8 = W_PC + 32'h00000008;
    assign W_opcode = W_Instr[31:26];
    assign W_rs = W_Instr[25:21];
    assign W_rt = W_Instr[20:16];
    assign W_func = W_Instr[5:0];
    assign W_imm16 = W_Instr[15:0];
    assign W_imm26 = W_Instr[25:0];
    assign W_grfWD=(W_MemtoReg==2'b00)?W_ALUout:
                    (W_MemtoReg==2'b01)?W_DMdata:
                    (W_MemtoReg==2'b10)?W_PC8:
                    {{24{W_DMbyte[7]}},W_DMbyte};


    //forward and stall 

    // forward //////////////
    //fixed data
    wire [31:0] D_fixedRD1;
    wire [31:0] D_fixedRD2;
    wire [31:0] E_fixedRD1;
    wire [31:0] E_fixedRD2;
    wire [31:0] M_fixedRD2;
    // tuse and tnew
    wire [3:0] D_t_rsuse;
    wire [3:0] D_t_rtuse;
    wire [3:0] D_t_new;

    wire [3:0] E_t_rsuse;
    wire [3:0] E_t_rtuse;
    wire [3:0] E_t_new;

    wire [3:0] M_t_rsuse;
    wire [3:0] M_t_rtuse;
    wire [3:0] M_t_new;

    wire [3:0] W_t_rsuse;
    wire [3:0] W_t_rtuse;
    wire [3:0] W_t_new;

    wire E_isPC8;
    wire M_isPC8;

    // zhuanfatonglu 15 lines
    wire D_RD1_from_E_PC8;
    wire D_RD2_from_E_PC8;

    wire D_RD1_from_M_PC8;
    wire D_RD2_from_M_PC8;
    wire E_RD1_from_M_PC8;
    wire E_RD2_from_M_PC8;

    wire D_RD1_from_M;
    wire D_RD2_from_M;
    wire E_RD1_from_M;
    wire E_RD2_from_M;

    wire D_RD1_from_W;
    wire D_RD2_from_W;
    wire E_RD1_from_W;
    wire E_RD2_from_W;
    wire M_RD2_from_W;

    // stall /////////////////////////////////
    wire PC_en;
    wire FD_en;
    wire FD_clear;
    wire DE_clear;
    wire D_stall;

    //fixed data 
    assign D_fixedRD1 = (D_RD1_from_E_PC8)?E_PC8:
                        (D_RD1_from_M_PC8)?M_PC8:
                        (D_RD1_from_M)?M_ALUout:
                        (D_RD1_from_W)?W_grfWD:
                        D_RD1;
    assign D_fixedRD2 = (D_RD2_from_E_PC8)?E_PC8:
                        (D_RD2_from_M_PC8)?M_PC8:
                        (D_RD2_from_M)?M_ALUout:
                        (D_RD2_from_W)?W_grfWD:
                        D_RD2;
    assign E_fixedRD1 = (E_RD1_from_M_PC8)?M_PC8:
                        (E_RD1_from_M)?M_ALUout:
                        (E_RD1_from_W)?W_grfWD:
                        E_RD1;
    assign E_fixedRD2 = (E_RD2_from_M_PC8)?M_PC8:
                        (E_RD2_from_M)?M_ALUout:
                        (E_RD2_from_W)?W_grfWD:
                        E_RD2;
    assign M_fixedRD2 = (M_RD2_from_W) ? W_grfWD : M_RD2;

    // tuse and tnew
    assign D_t_rsuse = D_t_rs;
    assign D_t_rtuse = D_t_rt;
    assign D_t_new = D_t;

    assign E_t_rsuse = (E_t_rs == 4'hf) ? 4'hf : (E_t_rs >= 4'h1) ? (E_t_rs - 4'h1) : 4'h0;
    assign E_t_rtuse = (E_t_rt == 4'hf) ? 4'hf : (E_t_rt >= 4'h1) ? (E_t_rt - 4'h1) : 4'h0;
    assign E_t_new = (E_t == 4'hf) ? 4'hf : (E_t >= 4'h1) ? (E_t - 4'h1) : 4'h0;

    assign M_t_rsuse = (M_t_rs == 4'hf) ? 4'hf : (M_t_rs >= 4'h2) ? (M_t_rs - 4'h2) : 4'h0;
    assign M_t_rtuse = (M_t_rt == 4'hf) ? 4'hf : (M_t_rt >= 4'h2) ? (M_t_rt - 4'h2) : 4'h0;
    assign M_t_new = (M_t == 4'hf) ? 4'hf : (M_t >= 4'h2) ? (M_t - 4'h2) : 4'h0;

    assign W_t_rsuse = (W_t_rs == 4'hf) ? 4'hf : (W_t_rs >= 4'h3) ? (W_t_rs - 4'h3) : 4'h0;
    assign W_t_rtuse = (W_t_rt == 4'hf) ? 4'hf : (W_t_rt >= 4'h3) ? (W_t_rt - 4'h3) : 4'h0;
    assign W_t_new = (W_t == 4'hf) ? 4'hf : (W_t >= 4'h3) ? (W_t - 4'h3) : 4'h0;

    assign E_isPC8 = (E_opcode == 6'b000011) ? 1 : 0;  //jar
    assign M_isPC8 = (M_opcode == 6'b000011) ? 1 : 0;  //jar

    //15 forward roads
    assign D_RD1_from_E_PC8 = (E_isPC8 && E_A3 != 5'b00000 && D_rs == E_A3 && D_t_rsuse != 4'hf && E_t_new != 4'hf && D_t_rsuse >= E_t_new);
    assign D_RD2_from_E_PC8 = (E_isPC8 && E_A3 != 5'b00000 && D_rt == E_A3 && D_t_rtuse != 4'hf && E_t_new != 4'hf && D_t_rtuse >= E_t_new);

    assign D_RD1_from_M_PC8 = (M_isPC8 && M_A3 != 5'b00000 && D_rs == M_A3 && D_t_rsuse != 4'hf && M_t_new != 4'hf && D_t_rsuse >= M_t_new);
    assign D_RD2_from_M_PC8 = (M_isPC8 && M_A3 != 5'b00000 && D_rt == M_A3 && D_t_rtuse != 4'hf && M_t_new != 4'hf && D_t_rtuse >= M_t_new);
    assign E_RD1_from_M_PC8 = (M_isPC8 && M_A3 != 5'b00000 && E_rs == M_A3 && E_t_rsuse != 4'hf && M_t_new != 4'hf && E_t_rsuse >= M_t_new);
    assign E_RD2_from_M_PC8 = (M_isPC8 && M_A3 != 5'b00000 && E_rt == M_A3 && E_t_rtuse != 4'hf && M_t_new != 4'hf && E_t_rtuse >= M_t_new);

    assign D_RD1_from_M = (~M_isPC8 && M_A3 != 5'b00000 && D_rs == M_A3 && D_t_rsuse != 4'hf && M_t_new != 4'hf && D_t_rsuse >= M_t_new);
    assign D_RD2_from_M = (~M_isPC8 && M_A3 != 5'b00000 && D_rt == M_A3 && D_t_rtuse != 4'hf && M_t_new != 4'hf && D_t_rtuse >= M_t_new);
    assign E_RD1_from_M = (~M_isPC8 && M_A3 != 5'b00000 && E_rs == M_A3 && E_t_rsuse != 4'hf && M_t_new != 4'hf && E_t_rsuse >= M_t_new);
    assign E_RD2_from_M = (~M_isPC8 && M_A3 != 5'b00000 && E_rt == M_A3 && E_t_rtuse != 4'hf && M_t_new != 4'hf && E_t_rtuse >= M_t_new);

    assign D_RD1_from_W = (W_A3 != 5'b0 && D_rs == W_A3 && D_t_rsuse != 4'hf && W_t_new != 4'hf && D_t_rsuse >= W_t_new);
    assign D_RD2_from_W = (W_A3 != 5'b0 && D_rt == W_A3 && D_t_rtuse != 4'hf && W_t_new != 4'hf && D_t_rtuse >= W_t_new);
    assign E_RD1_from_W = (W_A3 != 5'b0 && E_rs == W_A3 && E_t_rsuse != 4'hf && W_t_new != 4'hf && E_t_rsuse >= W_t_new);
    assign E_RD2_from_W = (W_A3 != 5'b0 && E_rt == W_A3 && E_t_rtuse != 4'hf && W_t_new != 4'hf && E_t_rtuse >= W_t_new);
    assign M_RD2_from_W = (W_A3 != 5'b0 && M_rt == W_A3 && M_t_rtuse != 4'hf && W_t_new != 4'hf && M_t_rtuse >= W_t_new);

    // stall /////////////////////////////////
    assign PC_en = (D_stall) ? 1'b0 : 1'b1;
    assign FD_en = (D_stall) ? 1'b0 : 1'b1;
    assign FD_clear = 1'b0;
    assign DE_clear = (D_stall) ? 1'b1 : 1'b0;

    wire DE_rs_Stall;
    wire DE_rt_Stall;
    wire DM_rs_Stall;
    wire DM_rt_Stall;
    wire DW_rs_Stall;
    wire DW_rt_Stall;
    assign DE_rs_Stall = (E_A3 != 5'b0 && D_rs == E_A3 && D_t_rsuse != 4'hf && E_t_new != 4'hf && D_t_rsuse < E_t_new);
    assign DE_rt_Stall = (E_A3 != 5'b0 && D_rt == E_A3 && D_t_rtuse != 4'hf && E_t_new != 4'hf && D_t_rtuse < E_t_new);
    assign DM_rs_Stall = (M_A3 != 5'b0 && D_rs == M_A3 && D_t_rsuse != 4'hf && M_t_new != 4'hf && D_t_rsuse < M_t_new);
    assign DM_rt_Stall = (M_A3 != 5'b0 && D_rt == M_A3 && D_t_rtuse != 4'hf && M_t_new != 4'hf && D_t_rtuse < M_t_new);
    assign DW_rs_Stall = (W_A3 != 5'b0 && D_rs == W_A3 && D_t_rsuse != 4'hf && W_t_new != 4'hf && D_t_rsuse < W_t_new);
    assign DW_rt_Stall = (W_A3 != 5'b0 && D_rt == W_A3 && D_t_rtuse != 4'hf && W_t_new != 4'hf && D_t_rtuse < W_t_new);
    assign D_stall = (DE_rs_Stall || DE_rt_Stall || DM_rs_Stall || DM_rt_Stall || DM_rs_Stall || DM_rt_Stall);
endmodule

