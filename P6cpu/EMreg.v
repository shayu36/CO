`timescale 1ns / 1ps
module EMreg (
    input clk,
    input reset,
    input [31:0] E_Instr,
    input [31:0] E_PC8,
    input [31:0] E_PC,
    input [31:0] E_Dout,
    input [31:0] E_RD2,
    input [4:0] E_A3,
    output reg [31:0] M_Instr,
    output reg [31:0] M_PC8,
    output reg [31:0] M_PC,
    output reg [31:0] M_Dout,
    output reg [31:0] M_RD2,
    output reg [4:0] M_A3
);

    always @(posedge clk) begin
        if (reset) begin
            M_Instr <= 32'h00000000;
            M_PC8 <= 32'h00000000;
            M_PC <= 32'h00000000;
            M_Dout <= 32'h00000000;
            M_RD2 <= 32'h00000000;
            M_A3 <= 5'b00000;
        end else begin
            M_Instr <= E_Instr;
            M_PC <= E_PC;
            M_PC8 <= E_PC8;
            M_Dout <= E_Dout;
            M_RD2 <= E_RD2;
            M_A3 <= E_A3;
        end
    end

endmodule
