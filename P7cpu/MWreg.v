`timescale 1ns / 1ps
module MWreg (
    input clk,
    input reset,
    input MW_clear,
    input req,
    input [31:0] M_Instr,
    input [31:0] M_PC8,
    input [31:0] M_PC,
    input [4:0] M_A3,
    input [31:0] M_Dout,
    input [31:0] M_data,
    output reg [31:0] W_Instr,
    output reg [31:0] W_PC8,
    output reg [31:0] W_PC,
    output reg [4:0] W_A3,
    output reg [31:0] W_Dout,
    output reg [31:0] W_data
);

    always @(posedge clk) begin
        if (reset|MW_clear|req) begin
            W_Instr <= 32'h00000000;
            W_PC8 <= 32'h00000000;
            W_PC <= 32'h00000000;
            W_A3 <= 5'b00000;
            W_Dout <= 32'h00000000;
            W_data <= 32'h00000000;
        end else begin
            W_Instr <= M_Instr;
            W_PC8 <= M_PC8;
            W_PC <= M_PC;
            W_A3 <= M_A3;
            W_Dout <= M_Dout;
            W_data <= M_data;
        end
    end

endmodule

