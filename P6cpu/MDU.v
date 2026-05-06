`timescale 1ns / 1ps
module MDU (
    input clk,
    input reset,
    input start,
    input [31:0] A,
    input [31:0] B,
    input[4:0] type,
    output busy,
    output [31:0] MDUout
);
    parameter MULT  = 5'b10001,
        MULTU = 5'b10010,
        DIV   = 5'b10011,
        DIVU  = 5'b10100,
        MFHI  = 5'b10101,
        MFLO  = 5'b10110,
        MTHI  = 5'b10111,
        MTLO  = 5'b11000;
    reg[4:0] cnt;
	reg[31:0] HI;
	reg [31:0] LO;
    always @(posedge clk) begin 
        if(reset) begin
            HI<=32'h0;
            LO<=32'h0;
            cnt<=5'd0;
        end
        else begin
            if(start) begin
                if (type == MULT || type == MULTU) begin
                    cnt <= 5'd5;
                end
                else if (type == DIV || type == DIVU) begin
                    cnt <= 5'd10;
                end
            end
            if(cnt!=0) begin
                cnt<=cnt-5'b1;
            end
            
            if(type==MULT) begin
                {HI,LO}<=$signed(A)*$signed(B);
            end
            else if(type==MULTU) begin
                {HI,LO}<=A*B;
            end
            else if(type==DIV) begin
                if(B!=32'h0) begin
                    HI<=$signed(A)%$signed(B);
                    LO<=$signed(A)/$signed(B);
                end  
            end
            else if(type==DIVU) begin
                if(B!=32'h0) begin
                    HI<=A%B;
                    LO<=A/B;
                end
            end
            else if(type==MTHI) begin
                HI<=A;
            end
            else if(type==MTLO) begin
                LO<=A;
            end
        end
    end
    assign MDUout=(type==MFHI)?HI:(type==MFLO)?LO:32'h0;

    assign busy=(cnt!=5'b0)?1:0;
endmodule
