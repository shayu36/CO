`timescale 1ns / 1ps
module FDreg (
    input clk,
    input reset,
    input FD_en,
    input FD_clear,
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    output reg [31:0] D_Instr,
    output reg [31:0] D_PC,
    output reg [31:0] D_PC8
);

    always @(posedge clk) begin
        if (reset|FD_clear) begin
            D_Instr <= 32'h00000000;
            D_PC <= 32'h00000000;
            D_PC8 <= 32'h00000000;
        end else begin
            if (FD_en) begin
                D_Instr <= F_Instr;
                D_PC <= F_PC;
                D_PC8 <= F_PC8;
            end
        end
    end

endmodule
