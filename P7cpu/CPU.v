`timescale 1ns / 1ps
module CPU (
    input wire clk,
    input wire reset,
    input wire [31:0] i_inst_rdata,
    input wire [31:0] m_data_rdata,
    output [31:0] macroscopic_pc,
    input [5:0] HWInt,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 : 0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
    assign i_inst_addr = F_PC;
    assign F_Instr = i_inst_rdata;

    assign macroscopic_pc = M_PC;
    assign m_data_addr = M_DMaddr;
    assign m_data_wdata = M_fixed_DMWD;
    assign m_data_byteen = M_DMWE;
    assign m_inst_addr = M_PC;
    assign M_DMdata = m_data_rdata;

    assign w_inst_addr = W_PC;
    assign w_grf_we = W_grfWE;
    assign w_grf_addr = W_A3;
    assign w_grf_wdata = W_grfWD;


    //Interupt and exception
    wire [4:0] F_ExcCode;
    assign F_ExcCode=(F_PC[1:0]!=2'b00||!(F_PC >= 32'h00003000 && F_PC < 32'h00007000))?5'd4:5'd0;
    wire [31:0] F_fixedInstr;
    assign F_fixedInstr = (F_ExcCode) ? 32'h00000000 : F_Instr;
    assign D_fixedExcCode = (FD_ExcCode != 5'd0) ? FD_ExcCode : D_ExcCode;
    assign E_fixedExcCode = (DE_ExcCode != 5'd0) ? DE_ExcCode : E_ExcCode;
    assign M_ExcCode = EM_ExcCode;

    //F zone /////////////////
    wire [31:0] F_PC;
    wire [31:0] F_PC8;
    wire [31:0] F_NPC;
    wire [31:0] F_oldPC;
    wire [31:0] F_Instr;
    wire [4:0] FD_ExcCode;
    wire F_BD;
    //D zone///////////////////
    wire [31:0] D_PC;
    wire [31:0] D_PC8;
    wire [4:0] D_ExcCode;
    wire [4:0] D_fixedExcCode;
    wire [4:0] DE_ExcCode;
    wire D_BD;
    wire D_isjump;
    assign D_isjump=(D_type==6'b011001||D_type==6'b011010||D_type==6'b011011||D_type==6'b011100)?1'b1:1'b0;
    assign F_BD = (D_isjump) ? 1'b1 : 1'b0;
    wire D_iseret;
    assign D_iseret = (D_type == 6'b100000) ? 1'b1 : 1'b0;
    assign F_PC = (D_iseret) ? EPC : F_oldPC;
    //D_Instruction
    wire [31:0] D_Instr;
    wire [5:0] D_opcode;
    wire [5:0] D_func;
    wire [4:0] D_rs;
    wire [5:0] D_rt;
    wire [5:0] D_rd;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    //D_control
    wire [1:0] D_NPCslt;
    wire [1:0] D_RegDst;
    wire D_EXTOp;
    wire [5:0] D_type;
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
    wire [4:0] E_ExcCode;
    wire [4:0] E_fixedExcCode;
    wire [4:0] EM_ExcCode;
    wire E_BD;
    //E_Instruction
    wire [31:0] E_Instr;
    wire [5:0] E_opcode;
    wire [4:0] E_rs;
    wire [4:0] E_rt;
    wire [4:0] E_rd;
    wire [5:0] E_func;
    wire [15:0] E_imm16;
    wire [25:0] E_imm26;
    //E_control
    wire [5:0] E_type;
    wire E_ALUsrc;
    wire E_mfop;
    wire E_start;
    wire [3:0] E_t_rs;
    wire [3:0] E_t_rt;
    wire [3:0] E_t;
    //E_ALU
    wire [31:0] E_ALUinputA;
    wire [31:0] E_ALUinputB;
    wire [31:0] E_ALUout;
    //E_MDU
    wire [31:0] E_MDUout;
    wire [31:0] E_Dout;
    wire E_busy;

    //M zone/////////////////
    wire [31:0] M_PC;
    wire [31:0] M_PC8;
    wire [31:0] M_Dout;
    wire [31:0] M_fixedDout;
    assign M_fixedDout = (M_cpop) ? M_CP0out : M_Dout;
    wire [31:0] M_RD2;
    wire [4:0] M_A3;
    wire [4:0] M_ExcCode;
    wire M_BD;
    //M_Instruction
    wire [31:0] M_Instr;
    wire [5:0] M_opcode;
    wire [4:0] M_rs;
    wire [4:0] M_rt;
    wire [4:0] M_rd;
    wire [5:0] M_func;
    wire [15:0] M_imm16;
    wire [25:0] M_imm26;
    //M_Control
    wire [5:0] M_type;
    wire M_cpop;
    wire M_cpWE;
    wire [3:0] M_DMWE;
    wire [3:0] M_t_rs;
    wire [3:0] M_t_rt;
    wire [3:0] M_t;
    //M_DE
    wire [31:0] M_fixed_DMdata;
    //M_BE
    wire [31:0] M_fixed_DMWD;
    //M_DM
    wire [31:0] M_DMaddr;
    wire [31:0] M_DMWD;
    wire [31:0] M_DMdata;
    //M_CP0
    wire M_iseret;
    assign M_iseret = (M_type == 6'b100000) ? 1'b1 : 1'b0;
    wire [31:0] EPC;
    wire [31:0] M_CP0out;
    wire req;

    //W zone/////////////////
    wire [31:0] W_PC;
    wire [31:0] W_PC8;
    wire [4:0] W_A3;
    wire [31:0] W_Dout;
    wire [31:0] W_DMdata;
    //W_Instrution
    wire [31:0] W_Instr;
    wire [5:0] W_opcode;
    wire [4:0] W_rs;
    wire [4:0] W_rt;
    wire [5:0] W_func;
    wire [15:0] W_imm16;
    wire [25:0] W_imm26;
    //W_Control
    wire [5:0] W_type;
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
        .PC(F_oldPC)
    );
    NPC NPC (
        .F_PC(F_PC),
        .imm16(D_imm16),
        .imm26(D_imm26),
        .GRF(D_fixedRD1),
        .NPCslt(D_NPCslt),
        .zero(D_zero),
        .req(req),
        .NPC(F_NPC)
    );
    FDreg FDreg (
        .clk(clk),
        .reset(reset),
        .FD_en(FD_en),
        .FD_clear(FD_clear),
        .F_Instr(F_fixedInstr),
        .F_PC(F_PC),
        .F_PC8(F_PC8),
        .req(req),
        .F_ExcCode(F_ExcCode),
        .F_BD(F_BD),
        .D_Instr(D_Instr),
        .D_PC(D_PC),
        .D_PC8(D_PC8),
        .FD_ExcCode(FD_ExcCode),
        .D_BD(D_BD)
    );
    // D zone ////////////////
    Control D_Control (
        .opcode(D_opcode),
        .rs(D_rs),
        .func(D_func),
        .type(D_type),
        .NPCslt(D_NPCslt),
        .RegDst(D_RegDst),
        .EXTOp(D_EXTOp),
        .ExcCode(D_ExcCode),
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
        .req(req),
        .D_ExcCode(D_fixedExcCode),
        .D_BD(D_BD),
        .E_Instr(E_Instr),
        .E_PC(E_PC),
        .E_PC8(E_PC8),
        .E_RD1(E_RD1),
        .E_RD2(E_RD2),
        .E_A3(E_A3),
        .E_ext32(E_ext32),
        .DE_ExcCode(DE_ExcCode),
        .E_BD(E_BD)
    );
    //E zone/////////////
    Control E_Control (
        .opcode(E_opcode),
        .rs    (E_rs),
        .func  (E_func),
        .type  (E_type),
        .ALUsrc(E_ALUsrc),
        .mfop  (E_mfop),
        .start (E_start),
        .t_rs  (E_t_rs),
        .t_rt  (E_t_rt),
        .t     (E_t)
    );
    ALU E_ALU (
        .A(E_ALUinputA),
        .B(E_ALUinputB),
        .type(E_type),
        .out(E_ALUout),
        .ExcCode(E_ExcCode)
    );
    MDU E_MDU (
        .clk(clk),
        .reset(reset),
        .req(req),
        .A(E_ALUinputA),
        .B(E_ALUinputB),
        .start(E_start),
        .type(E_type),
        .MDUout(E_MDUout),
        .busy(E_busy)
    );
    EMreg EMreg (
        .clk(clk),
        .reset(reset),
        .EM_clear(EM_clear),
        .E_Instr(E_Instr),
        .E_PC(E_PC),
        .E_PC8(E_PC8),
        .E_Dout(E_Dout),
        .E_RD2(E_fixedRD2),
        .E_A3(E_A3),
        .req(req),
        .E_ExcCode(E_fixedExcCode),
        .E_BD(E_BD),
        .M_Instr(M_Instr),
        .M_PC(M_PC),
        .M_PC8(M_PC8),
        .M_Dout(M_Dout),
        .M_RD2(M_RD2),
        .M_A3(M_A3),
        .EM_ExcCode(EM_ExcCode),
        .M_BD(M_BD)
    );

    //M zone/////////////
    Control M_Control (
        .opcode(M_opcode),
        .rs    (M_rs),
        .func  (M_func),
        .type  (M_type),
        .cpop  (M_cpop),
        .cpWE  (M_cpWE),
        .t_rs  (M_t_rs),
        .t_rt  (M_t_rt),
        .t     (M_t)
    );
    DE M_DE (
        .addr(M_DMaddr),
        .data(M_DMdata),
        .type(M_type),
        .fixed_data(M_fixed_DMdata)
    );
    BE M_BE (
        .addr(M_DMaddr),
        .data(M_DMWD),
        .type(M_type),
        .DMWE(M_DMWE),
        .req(req),
        .fixed_data(M_fixed_DMWD)
    );
    CP0 M_CP0 (
        .clk(clk),
        .reset(reset),
        .en(M_cpWE),
        .type(M_type),
        .DMaddr(M_DMaddr),
        .DMdata(M_fixed_DMdata),
        .DMWD(M_fixed_DMWD),
        .addr(M_rd),
        .data(M_fixedRD2),
        .VPC(M_PC),
        .BDIn(M_BD),
        .ExcCode(M_ExcCode),
        .HWInt(HWInt),
        .EXLclr(M_iseret),
        .CP0out(M_CP0out),
        .EPCout(EPC),
        .req(req)
    );
    MWreg MWreg (
        .clk(clk),
        .reset(reset),
        .MW_clear(MW_clear),
        .req(req),
        .M_Instr(M_Instr),
        .M_PC(M_PC),
        .M_PC8(M_PC8),
        .M_A3(M_A3),
        .M_Dout(M_fixedDout),
        .M_data(M_fixed_DMdata),
        .W_Instr(W_Instr),
        .W_PC(W_PC),
        .W_PC8(W_PC8),
        .W_A3(W_A3),
        .W_Dout(W_Dout),
        .W_data(W_DMdata)
    );

    //W zone/////////////
    Control W_Control (
        .opcode  (W_opcode),
        .rs      (W_rs),
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
    assign E_rd = E_Instr[15:11];
    assign E_imm16 = E_Instr[15:0];
    assign E_imm26 = E_Instr[25:0];
    assign E_ALUinputA = E_fixedRD1;
    assign E_ALUinputB = (E_ALUsrc) ? E_ext32 : E_fixedRD2;
    assign E_Dout = (E_mfop) ? E_MDUout : E_ALUout;
    // M zone ////////////////////////////////
    assign M_PC8 = M_PC + 32'h00000008;
    assign M_opcode = M_Instr[31:26];
    assign M_rs = M_Instr[25:21];
    assign M_rt = M_Instr[20:16];
    assign M_rd = M_Instr[15:11];
    assign M_func = M_Instr[5:0];
    assign M_imm16 = M_Instr[15:0];
    assign M_imm26 = M_Instr[25:0];
    assign M_DMaddr = M_Dout;
    assign M_DMWD = M_fixedRD2;

    // W zone ////////////////////////////////
    assign W_PC8 = W_PC + 32'h00000008;
    assign W_opcode = W_Instr[31:26];
    assign W_rs = W_Instr[25:21];
    assign W_rt = W_Instr[20:16];
    assign W_func = W_Instr[5:0];
    assign W_imm16 = W_Instr[15:0];
    assign W_imm26 = W_Instr[25:0];
    assign W_grfWD=(W_MemtoReg==2'b00)?W_Dout:
                    (W_MemtoReg==2'b01)?W_DMdata:
                    (W_MemtoReg==2'b10)?W_PC8:
					32'h0;

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
    wire EM_clear;
    wire MW_clear;
    wire D_stall;

    //fixed data 
    assign D_fixedRD1 = (D_RD1_from_E_PC8)?E_PC8:
                        (D_RD1_from_M_PC8)?M_PC8:
                        (D_RD1_from_M)?M_Dout:
                        (D_RD1_from_W)?W_grfWD:
                        D_RD1;
    assign D_fixedRD2 = (D_RD2_from_E_PC8)?E_PC8:
                        (D_RD2_from_M_PC8)?M_PC8:
                        (D_RD2_from_M)?M_Dout:
                        (D_RD2_from_W)?W_grfWD:
                        D_RD2;
    assign E_fixedRD1 = (E_RD1_from_M_PC8)?M_PC8:
                        (E_RD1_from_M)?M_Dout:
                        (E_RD1_from_W)?W_grfWD:
                        E_RD1;
    assign E_fixedRD2 = (E_RD2_from_M_PC8)?M_PC8:
                        (E_RD2_from_M)?M_Dout:
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
    assign PC_en = (D_stall&&~req) ? 1'b0 : 1'b1;
    assign FD_en = (D_stall) ? 1'b0 : 1'b1;
    assign FD_clear = 1'b0;
    assign DE_clear = (D_stall) ? 1'b1 : 1'b0;
    assign EM_clear = 1'b0;
    assign MW_clear = 1'b0;

    wire DE_rs_Stall;
    wire DE_rt_Stall;
    wire DM_rs_Stall;
    wire DM_rt_Stall;
    wire DW_rs_Stall;
    wire DW_rt_Stall;
    wire D_ismult;
    wire DE_MDU_stall;

    assign DE_rs_Stall = (E_A3 != 5'b0 && D_rs == E_A3 && D_t_rsuse != 4'hf && E_t_new != 4'hf && D_t_rsuse < E_t_new);
    assign DE_rt_Stall = (E_A3 != 5'b0 && D_rt == E_A3 && D_t_rtuse != 4'hf && E_t_new != 4'hf && D_t_rtuse < E_t_new);
    assign DM_rs_Stall = (M_A3 != 5'b0 && D_rs == M_A3 && D_t_rsuse != 4'hf && M_t_new != 4'hf && D_t_rsuse < M_t_new);
    assign DM_rt_Stall = (M_A3 != 5'b0 && D_rt == M_A3 && D_t_rtuse != 4'hf && M_t_new != 4'hf && D_t_rtuse < M_t_new);
    assign DW_rs_Stall = (W_A3 != 5'b0 && D_rs == W_A3 && D_t_rsuse != 4'hf && W_t_new != 4'hf && D_t_rsuse < W_t_new);
    assign DW_rt_Stall = (W_A3 != 5'b0 && D_rt == W_A3 && D_t_rtuse != 4'hf && W_t_new != 4'hf && D_t_rtuse < W_t_new);
    assign D_ismult = (D_type == 6'b010001 || D_type == 6'b010010 || D_type == 6'b010011 || D_type == 6'b010100 || D_type == 6'b010101 || D_type == 6'b010110 || D_type == 6'b010111 || D_type == 6'b011000) ? 1'b1 : 1'b0;
    assign DE_MDU_stall = D_ismult && (E_start || E_busy);
    assign D_stall = ((D_iseret && E_type == 6'b011110 && E_rd == 5'b01110)||(D_iseret && M_type == 6'b011110 && M_rd == 5'b01110)||DE_MDU_stall||DE_rs_Stall || DE_rt_Stall || DM_rs_Stall || DM_rt_Stall || DM_rs_Stall || DM_rt_Stall);
endmodule

