`timescale 1ns / 1ps
module Bridge (
    // attach CPU
    input  [31:0] CPU_i_inst_addr,
    output [31:0] CPU_i_inst_rdata,

    input  [31:0] CPU_macroscopic_pc,
    output [ 5:0] CPU_HWInt,

    input  [31:0] CPU_m_data_addr,
    input  [ 3:0] CPU_m_data_byteen,
    input  [31:0] CPU_m_data_wdata,
    output [31:0] CPU_m_data_rdata,

    // attach mips
    output [31:0] mips_i_inst_addr,
    input  [31:0] mips_i_inst_rdata,

    output [31:0] mips_macroscopic_pc,
    input mips_interrupt,
    output [31:0] mips_m_int_addr,
    output [3:0] mips_m_int_byteen,

    output [31:0] mips_m_data_addr,
    output [ 3:0] mips_m_data_byteen,
    output [31:0] mips_m_data_wdata,
    input  [31:0] mips_m_data_rdata,

    // attach Timer0
    output [31:2] timer0_Addr,
    output timer0_WE,
    output [31:0] timer0_Din,
    input [31:0] timer0_Dout,
    input timer0_IRQ,

    // attach Timer1
    output [31:2] timer1_Addr,
    output timer1_WE,
    output [31:0] timer1_Din,
    input [31:0] timer1_Dout,
    input timer1_IRQ
);

    wire isDM;
    wire isTimer0;
    wire isTimer1;
    wire isInterrupt;

    assign isDM = (CPU_m_data_addr >= 32'h00000000 && CPU_m_data_addr < 32'h00003000) ? 1'b1 : 1'b0;
    assign isTimer0 = (CPU_m_data_addr >= 32'h00007f00 && CPU_m_data_addr < 32'h00007f0c) ? 1'b1 : 1'b0;
    assign isTimer1 = (CPU_m_data_addr >= 32'h00007f10 && CPU_m_data_addr < 32'h00007f1c) ? 1'b1 : 1'b0;
    assign isInterrupt = (CPU_m_data_addr >= 32'h00007f20 && CPU_m_data_addr < 32'h00007f24) ? 1'b1 : 1'b0;

    assign CPU_HWInt = {3'b0, mips_interrupt, timer1_IRQ, timer0_IRQ};

    // mips and CPU
    assign mips_i_inst_addr = CPU_i_inst_addr;
    assign CPU_i_inst_rdata = mips_i_inst_rdata;

    assign mips_macroscopic_pc = CPU_macroscopic_pc;
    assign mips_m_int_addr = CPU_m_data_addr;
    assign mips_m_int_byteen = (isDM) ? 4'h0 :
                           (isTimer0) ? 4'h0 :
                           (isTimer1) ? 4'h0 :
                           (isInterrupt) ? CPU_m_data_byteen :
                           4'h0;

    assign mips_m_data_addr = CPU_m_data_addr;
    assign mips_m_data_byteen = (isDM) ? CPU_m_data_byteen :
                            (isTimer0) ? 4'h0 :
                            (isTimer1) ? 4'h0 :
                            (isInterrupt) ? 4'h0 :
                            4'h0;
    assign mips_m_data_wdata = CPU_m_data_wdata;

    // Timer0 and CPU
    assign timer0_Addr = CPU_m_data_addr[31:2];
    assign timer0_WE = (isDM) ? 1'b0 :
                   (isTimer0) ? (&CPU_m_data_byteen) :
                   (isTimer1) ? 1'b0 :
                   (isInterrupt) ? 1'b0 :
                   1'b0;
    assign timer0_Din = CPU_m_data_wdata;

    // Timer1 and CPU
    assign timer1_Addr = CPU_m_data_addr[31:2];
    assign timer1_WE = (isDM) ? 1'b0 :
                   (isTimer0) ? 1'b0 :
                   (isTimer1) ? (&CPU_m_data_byteen) :
                   (isInterrupt) ? 1'b0 :
                   1'b0;
    assign timer1_Din = CPU_m_data_wdata;

    // alloutput and CPU
    assign CPU_m_data_rdata = (isDM) ? mips_m_data_rdata :
                          (isTimer0) ? timer0_Dout :
                          (isTimer1) ? timer1_Dout :
                          (isInterrupt) ? 32'h00000000 :
                          32'h00000000;

endmodule
