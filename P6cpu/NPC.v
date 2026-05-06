`timescale 1ns / 1ps
module NPC (
    input [31:0] F_PC,
    input [15:0] imm16,
    input [25:0] imm26,
    input [31:0] GRF,
    input [1:0] NPCslt,
    input zero,
    input sign,
    input [31:0] sign_out,
    output [31:0] NPC
);
    parameter PCPLUS4 = 2'b00, IMM16 = 2'b01, IMM26 = 2'b10, GRFconst = 2'b11;
    wire [31:0] PCplus4;
    wire [31:0] signEXT;
    wire [31:0] NPC_imm16;
    wire [31:0] NPC_imm26;
    wire [31:0] NPC_GRF;

    assign PCplus4 = F_PC + 32'h00000004;
    assign signEXT = {{14{imm16[15]}}, imm16, 2'b00};
    assign NPC_imm16 = F_PC + signEXT;
    assign NPC_imm26 = {F_PC[31:28], imm26, 2'b00};
    assign NPC_GRF = GRF;

    assign NPC=(NPCslt==PCPLUS4)?PCplus4:
			   (NPCslt==IMM16&&!zero)?PCplus4:
			   (NPCslt==IMM16&&zero)?NPC_imm16:
			   (NPCslt==GRFconst)?NPC_GRF:
			   NPC_imm26;
endmodule
