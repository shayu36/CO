`timescale 1ns / 1ps
module MWreg (
    input clk,
    input reset,
    input [31:0] M_Instr,
    input [31:0] M_PC8,
    input [31:0] M_PC,
    input [4:0] M_A3,
    input [31:0] M_ALUout,
    input [31:0] M_data,
    input [7:0] M_byte,
    output reg [31:0] W_Instr,
    output reg [31:0] W_PC8,
    output reg [31:0] W_PC,
    output reg [4:0] W_A3,
    output reg [31:0] W_ALUout,
    output reg [31:0] W_data,
    output reg [7:0] W_byte
);

    always @(posedge clk) begin
        if (reset) begin
            W_Instr <= 32'h00000000;
            W_PC8 <= 32'h00000000;
            W_PC <= 32'h00000000;
            W_A3 <= 5'b00000;
            W_ALUout <= 32'h00000000;
            W_data <= 32'h00000000;
        end else begin
            W_Instr <= M_Instr;
            W_PC8 <= M_PC8;
            W_PC <= M_PC;
            W_A3 <= M_A3;
            W_ALUout <= M_ALUout;
            W_data <= M_data;
            W_byte <= M_byte;
        end
    end

endmodule

