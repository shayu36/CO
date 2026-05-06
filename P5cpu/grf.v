`timescale 1ns / 1ps
module grf (
    input clk,
    input reset,
    input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input grfWE,
    input [31:0] grfWD,
    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] GRF[0:31];
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                GRF[i] <= 32'h00000000;
            end
        end else begin
            if (grfWE) begin
                if (A3 != 0) begin
                    GRF[A3] <= grfWD;
                    $display("%d@%h: $%d <= %h", $time, PC, A3, grfWD);
                end
            end
        end
    end
    assign RD1 = GRF[A1];
    assign RD2 = GRF[A2];

endmodule
