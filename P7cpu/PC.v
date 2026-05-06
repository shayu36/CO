`timescale 1ns / 1ps
module PC (
    input clk,
    input reset,
    input PC_en,
    input [31:0] NPC,
    output [31:0] PC
);
    reg [31:0] RegPC;
    always @(posedge clk) begin
        if (reset) begin
            RegPC <= 32'h00003000;
        end else begin
            if (PC_en) begin
                RegPC <= NPC;
            end
        end
    end
    assign PC = RegPC;
endmodule
