`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/19 15:31:51
// Design Name: 
// Module Name: pcAdd
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


module pcAdd(
        input Reset,             //低电平清零
        input CLK,               //时钟
        input [2:0] PCSrc,       //数据选择器输入  00正常    01立即数   10跳转    11停机
        input [31:0] immediate,  //偏移量
        input [25:0] addr,       //跳转指令的后26位地址，用于拼接
        input [31:0] curPC,
        input [31:0] jal_pos,       
        output reg[31:0] nextPC,  //新指令地址
        output reg[31:0] PC_4
    );
    
    initial begin
        nextPC <= 0;
        PC_4 <= 0;
    end
    
    reg [31:0] pc;
    
    always@(negedge CLK or negedge Reset)
    begin
        if(!Reset) begin
            nextPC <= 32'h00400000;
            PC_4 <= 32'h00400000;
        end
        else begin
            pc <= curPC + 4;
            PC_4 <= curPC + 4;
            case(PCSrc)
                3'b000: nextPC <= curPC + 4;
                3'b001: nextPC <= curPC + 4 + immediate * 4;
                3'b010: nextPC <= {pc[31:28],addr,2'b00};
                3'b011: nextPC <= nextPC;
                3'b100: nextPC <= jal_pos + 4;
            endcase
        end
    end
endmodule
