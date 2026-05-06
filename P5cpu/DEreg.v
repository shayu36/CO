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
    output reg [31:0] E_Instr,
    output reg [31:0] E_PC8,
    output reg [31:0] E_PC,
    output reg [31:0] E_RD1,
    output reg [31:0] E_RD2,
    output reg [4:0] E_A3,
    output reg [31:0] E_ext32
);

    always @(posedge clk) begin
        if (reset | DE_clear) begin
            E_Instr <= 32'h00000000;
            E_PC8 <= 32'h00000000;
            E_PC <= 32'h00000000;
            E_RD1 <= 32'h00000000;
            E_RD2 <= 32'h00000000;
            E_A3 <= 5'b00000;
            E_ext32 <= 32'h00000000;
        end else begin
            E_Instr <= D_Instr;
            E_PC8 <= D_PC8;
            E_PC <= D_PC;
            E_RD1 <= D_RD1;
            E_RD2 <= D_RD2;
            E_A3 <= D_A3;
            E_ext32 <= D_ext32;
        end
    end

endmodule
