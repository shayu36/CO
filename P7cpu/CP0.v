`timescale 1ns / 1ps
`define SR_IM SR[15:10]//on|off
`define SR_EXL SR[1]//0:interrupt is correct
`define SR_IE SR[0]

`define cause_BD cause[31]
`define cause_IP cause[15:10]//isinterrupt
`define cause_ExcCode cause[6:2] 
module CP0 (
    input clk,
    input reset,
    input en,
    input [5:0] type,
    input [31:0] DMaddr,
    input [31:0] DMdata,
    input [31:0] DMWD,
    input [4:0] addr,
    input [31:0] data,
    input [31:0] VPC,
    input BDIn,
    input [4:0] ExcCode,
    input [5:0] HWInt,
    input EXLclr,
    output [31:0] CP0out,
    output [31:0] EPCout,
    output req
);
    parameter
        LB    = 6'b001011,
        LH    = 6'b001100,
        LW    = 6'b001101,
        SB    = 6'b001110,
        SH    = 6'b001111,
        SW    = 6'b010000;


    wire [4:0] new_error;
    wire [4:0] fixedExcCode;
    assign fixedExcCode=(ExcCode<=5'd4)?ExcCode:
                        (type==6'b100001)?new_error:5'd0;

    reg [31:0] SR;
    reg [31:0] cause;
    reg [31:0] EPC;
    reg [31:0] PRId;
    reg [31:0] a18;
    reg [31:0] a19;

    always @(posedge clk) begin
        if (reset) begin
            SR <= 32'h0;
            cause <= 32'h0;
            EPC <= 32'h0;
            PRId <= 32'h24373313;
            a18<=32'h0;
            a19<=32'h0;
        end else begin
            `cause_IP <= HWInt;
            if (en && ~req) begin
                if (addr == 5'd12) begin
                    SR <= data;
                end else if (addr == 5'd14) begin
                    EPC <= data;
                end
            end
            if (req) begin
                `SR_EXL <= 1'b1;
                EPC <= (BDIn) ? VPC - 32'h00000004 : VPC;
                `cause_BD <= BDIn;
                `cause_ExcCode <= (~`SR_EXL && `SR_IE && (`SR_IM & HWInt)) ? 5'b00000 : fixedExcCode;
            end
            if (EXLclr) begin
                `SR_EXL <= 1'b0;
            end
        end
    end

    assign EPCout = EPC;
    assign req = (~`SR_EXL && ((`SR_IE && (`SR_IM & HWInt)) || (fixedExcCode)));
    assign CP0out = (addr == 5'd12) ? SR :
                    (addr == 5'd13) ? cause :
                    (addr == 5'd14) ? EPC :
                    (addr == 5'd15) ? PRId :
                    32'h0;



endmodule
