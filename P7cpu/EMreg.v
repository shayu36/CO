`timescale 1ns / 1ps
module EMreg (
    input clk,
    input reset,
    input EM_clear,
    input [31:0] E_Instr,
    input [31:0] E_PC8,
    input [31:0] E_PC,
    input [31:0] E_Dout,
    input [31:0] E_RD2,
    input [4:0] E_A3,
    input req,
    input [4:0] E_ExcCode,
    input E_BD,
    output reg [31:0] M_Instr,
    output reg [31:0] M_PC8,
    output reg [31:0] M_PC,
    output reg [31:0] M_Dout,
    output reg [31:0] M_RD2,
    output reg [4:0] M_A3,
    output reg [4:0] EM_ExcCode,
    output reg M_BD
);

    always @(posedge clk) begin
        if (reset|EM_clear|req) begin
            M_Instr <= 32'h00000000;
            M_PC8 <= 32'h00000000;
            M_PC <=(reset)? 32'h00000000: req ? 32'h00004180:E_PC;
            M_BD <= (reset)? 1'b0: req ? 1'b0:E_BD;
            M_Dout <= 32'h00000000;
            M_RD2 <= 32'h00000000;
            M_A3 <= 5'b00000;
            EM_ExcCode <= 5'b00000;
        end else begin
            M_Instr <= E_Instr;
            M_PC <= E_PC;
            M_PC8 <= E_PC8;
            M_Dout <= E_Dout;
            M_RD2 <= E_RD2;
            M_A3 <= E_A3;
            EM_ExcCode <= E_ExcCode;
            M_BD <= E_BD;
        end
    end

endmodule
