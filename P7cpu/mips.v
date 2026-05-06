module mips (
    input clk,
    input reset,

    input  [31:0] i_inst_rdata,
    output [31:0] i_inst_addr,

    output [31:0] macroscopic_pc,
    input interrupt,
    output [31:0] m_int_addr,
    output [3:0] m_int_byteen,

    output [31:0] m_data_addr,
    output [ 3:0] m_data_byteen,
    output [31:0] m_data_wdata,
    input  [31:0] m_data_rdata,
    output [31:0] m_inst_addr,  

    output         w_grf_we,   
    output [4 : 0] w_grf_addr, 
    output [ 31:0] w_grf_wdata, 

    output [31:0] w_inst_addr
);

    // CPU and Bridge
    wire [31:0] CPU_i_inst_addr;
    wire [31:0] CPU_i_inst_rdata;

    wire [31:0] CPU_macroscopic_pc;
    wire [5:0] CPU_HWInt;

    wire [31:0] CPU_m_data_addr;
    wire [3:0] CPU_m_data_byteen;
    wire [31:0] CPU_m_data_wdata;
    wire [31:0] CPU_m_data_rdata;

    // Timer0 and Bridge
    wire [31:2] t0_Addr;
    wire t0_WE;
    wire [31:0] t0_Din;
    wire [31:0] t0_Dout;
    wire t0_IRQ;

    // Timer1 and Bridge
    wire [31:2] t1_Addr;
    wire t1_WE;
    wire [31:0] t1_Din;
    wire [31:0] t1_Dout;
    wire t1_IRQ;

    CPU CPU (
        .clk  (clk),
        .reset(reset),

        .i_inst_addr (CPU_i_inst_addr),
        .i_inst_rdata(CPU_i_inst_rdata),

        .macroscopic_pc(CPU_macroscopic_pc),
        .HWInt(CPU_HWInt),

        .m_data_addr(CPU_m_data_addr),
        .m_data_byteen(CPU_m_data_byteen),
        .m_data_wdata(CPU_m_data_wdata),
        .m_data_rdata(CPU_m_data_rdata),
        .m_inst_addr(m_inst_addr),
        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr)
    );

    Bridge Bridge (
        // attach CPU
        .CPU_i_inst_addr (CPU_i_inst_addr),
        .CPU_i_inst_rdata(CPU_i_inst_rdata),

        .CPU_macroscopic_pc(CPU_macroscopic_pc),
        .CPU_HWInt(CPU_HWInt),

        .CPU_m_data_addr  (CPU_m_data_addr),
        .CPU_m_data_byteen(CPU_m_data_byteen),
        .CPU_m_data_wdata (CPU_m_data_wdata),
        .CPU_m_data_rdata (CPU_m_data_rdata),

        // attach mips
        .mips_i_inst_addr (i_inst_addr),
        .mips_i_inst_rdata(i_inst_rdata),

        .mips_macroscopic_pc(macroscopic_pc),
        .mips_interrupt(interrupt),
        .mips_m_int_addr(m_int_addr),
        .mips_m_int_byteen(m_int_byteen),

        .mips_m_data_addr  (m_data_addr),
        .mips_m_data_byteen(m_data_byteen),
        .mips_m_data_wdata (m_data_wdata),
        .mips_m_data_rdata (m_data_rdata),

        // attach Timer0
        .timer0_Addr(t0_Addr),
        .timer0_WE  (t0_WE),
        .timer0_Din (t0_Din),
        .timer0_Dout(t0_Dout),
        .timer0_IRQ (t0_IRQ),

        // attach Timer1
        .timer1_Addr(t1_Addr),
        .timer1_WE  (t1_WE),
        .timer1_Din (t1_Din),
        .timer1_Dout(t1_Dout),
        .timer1_IRQ (t1_IRQ)
    );

    TC Timer0 (
        .clk(clk),
        .reset(reset),
        .Addr(t0_Addr),
        .WE(t0_WE),
        .Din(t0_Din),
        .Dout(t0_Dout),
        .IRQ(t0_IRQ)
    );

    TC Timer1 (
        .clk(clk),
        .reset(reset),
        .Addr(t1_Addr),
        .WE(t1_WE),
        .Din(t1_Din),
        .Dout(t1_Dout),
        .IRQ(t1_IRQ)
    );

endmodule
