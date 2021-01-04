`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 20:43:00
// Design Name: 
// Module Name: RegisterFile
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

//寄存器组
module RegisterFile(
        input CLK,                  //时钟
        input [4:0] ReadReg1,    //rs寄存器地址输入端口              rs
        input [4:0] ReadReg2,    //rt寄存器地址输入端口              rt
        input [31:0] WriteData,     //写入寄存器的数据输入端口              busW
        input [4:0] WriteReg,       //将数据写入的寄存器端口，其地址来源rt或rd字段          rd
        input RegWre,               //WE，写使能信号，为1时，在时钟边沿触发写入    RegWr
        input [1:0] jump,                 //jr指令，返回31号寄存器，1是jal写，2是jr读
        output reg[31:0] ReadData1,  //rs寄存器数据输出端口      busA
        output reg[31:0] ReadData2   //rt寄存器数据输出端口      busB
    );
    
    initial begin
        ReadData1 <= 0;                 //赋初值
        ReadData2 <= 0;
    end
    

    reg [31:0] regFile[0:31]; //  寄存器定义必须用reg类型    32个32位的寄存器，reg是指示这个变量是寄存器 
    integer i;      
    initial begin
        for (i = 0; i < 32; i = i+ 1) 
            regFile[i] <= 0;          //把32个寄存器清零 
        regFile[4] <= 10;
        regFile[5] <= 1;
        regFile[29] <= 127;
        //regFile[2] <=1;
    end
    
    always@(ReadReg1 or ReadReg2 or jump) 
    begin
        ReadData1 = (jump == 2'b10)? regFile[31] : regFile[ReadReg1];     //busA=寄存器组[rs(寄存器号)]
        ReadData2 = (jump == 2'b10)? 0 : regFile[ReadReg2];      //busB=寄存器组[rt(寄存器号)]
        //$display("regfile %d %d\n", ReadReg1, ReadReg2);
    end
   
    
    always@(negedge CLK)
    begin
        if( jump == 2'b01)
            i = 31;
        else
            i = WriteReg;    
            
        //$0恒为0，所以写入寄存器的地址不能为0
        if(RegWre && i)  //如果写信号是1且写寄存器不为NULL
            begin               //1，写入当前地址
                    regFile[i] <= WriteData;
            end
    end
endmodule
