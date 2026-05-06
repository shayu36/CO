`timescale 1ns / 1ps
module FDreg (
    input clk,
    input reset,
    input FD_en,
    input FD_clear,
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    input req,
    input [4:0] F_ExcCode,
    input F_BD,
    output reg [31:0] D_Instr,
    output reg [31:0] D_PC,
    output reg [31:0] D_PC8,
    output reg [4:0] FD_ExcCode,
    output reg D_BD
);

    always @(posedge clk) begin
        if (reset | FD_clear|req) begin
            D_Instr <= 32'h00000000;
            D_PC <= (reset) ? 32'h00000000 : req ? 32'h00004180:F_PC;
            D_BD <= (reset) ? 1'b0:req ? 1'b0: F_BD;
            D_PC8 <= 32'h00000000;
            FD_ExcCode <= 5'b00000;
        end else begin
            if (FD_en) begin
                D_Instr <= F_Instr;
                D_PC <= F_PC;
                D_PC8 <= F_PC8;
                FD_ExcCode <= F_ExcCode;
                D_BD <= F_BD;
            end
        end
    end

endmodule
