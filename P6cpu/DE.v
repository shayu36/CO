`timescale 1ns / 1ps
module  DE(
    input  [31:0] addr,
    input [31:0] data,
    input [4:0] type,
    output [31:0] fixed_data
);
   parameter LB    = 5'b01011,
        LH    = 5'b01100,
        LW    = 5'b01101;

    wire[15:0] half_data;
    wire [7:0] byte_data;
    assign half_data=(type==LH&&addr[1]==1'b0)?data[15:0]:
                      (type==LH&&addr[1]==1'b1)?data[31:16]:16'b0;
    assign byte_data=(type==LB&&addr[1:0]==2'b00)?data[7:0]:
                    (type==LB&&addr[1:0]==2'b01)?data[15:8]:
                    (type==LB&&addr[1:0]==2'b10)?data[23:16]:
                    (type==LB&&addr[1:0]==2'b11)?data[31:24]:8'b0;
                    
    assign fixed_data = (type == LW) ? data :
                        (type == LH) ? {{16{half_data[15]}}, half_data} : 
                        (type == LB) ? {{24{byte_data[7]}}, byte_data} :32'h0;
                        

    
endmodule
