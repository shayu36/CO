`timescale 1ns / 1ps
module DM (
    input clk,
    input reset,
    input DMWE,
    input [31:0] PC,
    input [31:0] addr,
    input [31:0] DMWD,
    output [31:0] data,
    output [7:0] byte 
);
    reg [31:0] RAM[0:3071];
    wire [1:0] addrslt;
    assign addrslt = addr[1:0];
    wire [31:0] DMaddr;
    assign DMaddr = addr >> 2;
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 3072; i = i + 1) begin
                RAM[i] <= 32'h00000000;
            end
        end else begin
            if (DMWE) begin
                $display("%d@%h: *%h <= %h", $time, PC, addr, DMWD);
                RAM[DMaddr] <= DMWD;
            end
        end
    end
    assign data = RAM[DMaddr];
    assign byte = RAM[DMaddr][addrslt*8+:8];
endmodule
