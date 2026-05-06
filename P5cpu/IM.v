`timescale 1ns / 1ps
module IM (
    input  [31:0] addr,
    output [31:0] data
);
    reg [31:0] ROM[0:4095];
	wire [31:0] ROM_addr;
    initial begin
        $readmemh("code.txt", ROM, 0, 4095);
    end
	assign ROM_addr	= (addr - 32'h00003000) >> 2;
    assign data = ROM[ROM_addr];
endmodule
