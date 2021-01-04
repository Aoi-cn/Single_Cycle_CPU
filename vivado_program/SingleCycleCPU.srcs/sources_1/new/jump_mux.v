`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 19:11:36
// Design Name: 
// Module Name: jump_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jump_mux(
    input [1:0] jump,
    input [31:0] addr2,
    input [31:0] writedata,
    output reg[31:0] result2
    );
    //jump
    //0£¬Ð´Êý¾Ý£»
    //1£¬jal
    always@(addr2 or jump or writedata)
        begin
            result2 <= (jump == 2'b01) ? addr2 : writedata;
        end
endmodule
