`timescale 1ns / 1ps
module DEreg (
    input clk,
    input reset,
    input DE_clear,
    input [31:0] D_Instr,
    input [31:0] D_PC8,
    input [31:0] D_PC,
    input [31:0] D_RD1,
    input [31:0] D_RD2,
    input [4:0] D_A3,
    input [31:0] D_ext32,
    input req,
    input [4:0] D_ExcCode,
    input D_BD,
    output reg [31:0] E_Instr,
    output reg [31:0] E_PC8,
    output reg [31:0] E_PC,
    output reg [31:0] E_RD1,
    output reg [31:0] E_RD2,
    output reg [4:0] E_A3,
    output reg [31:0] E_ext32,
    output reg [4:0] DE_ExcCode,
    output reg E_BD
);

    always @(posedge clk) begin
        if (reset | DE_clear|req) begin
            E_Instr <= 32'h00000000;
            E_PC8 <= 32'h00000000;
            E_PC <=(reset)? 32'h00000000: req ? 32'h00004180: D_PC;
            E_BD <= (reset)? 1'b0: req ? 1'b0: D_BD;
            E_RD1 <= 32'h00000000;
            E_RD2 <= 32'h00000000;
            E_A3 <= 5'b00000;
            E_ext32 <= 32'h00000000;
            DE_ExcCode <= 5'b00000;
        end else begin
            E_Instr <= D_Instr;
            E_PC8 <= D_PC8;
            E_PC <= D_PC;
            E_RD1 <= D_RD1;
            E_RD2 <= D_RD2;
            E_A3 <= D_A3;
            E_ext32 <= D_ext32;
            DE_ExcCode <= D_ExcCode;
            E_BD <= D_BD;
        end
    end

endmodule
