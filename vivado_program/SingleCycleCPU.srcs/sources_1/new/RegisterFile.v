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

//�Ĵ�����
module RegisterFile(
        input CLK,                  //ʱ��
        input [4:0] ReadReg1,    //rs�Ĵ�����ַ����˿�              rs
        input [4:0] ReadReg2,    //rt�Ĵ�����ַ����˿�              rt
        input [31:0] WriteData,     //д��Ĵ�������������˿�              busW
        input [4:0] WriteReg,       //������д��ļĴ����˿ڣ����ַ��Դrt��rd�ֶ�          rd
        input RegWre,               //WE��дʹ���źţ�Ϊ1ʱ����ʱ�ӱ��ش���д��    RegWr
        input [1:0] jump,                 //jrָ�����31�żĴ�����1��jalд��2��jr��
        output reg[31:0] ReadData1,  //rs�Ĵ�����������˿�      busA
        output reg[31:0] ReadData2   //rt�Ĵ�����������˿�      busB
    );
    
    initial begin
        ReadData1 <= 0;                 //����ֵ
        ReadData2 <= 0;
    end
    

    reg [31:0] regFile[0:31]; //  �Ĵ������������reg����    32��32λ�ļĴ�����reg��ָʾ��������ǼĴ��� 
    integer i;      
    initial begin
        for (i = 0; i < 32; i = i+ 1) 
            regFile[i] <= 0;          //��32���Ĵ������� 
        regFile[4] <= 10;
        regFile[5] <= 1;
        regFile[29] <= 127;
        //regFile[2] <=1;
    end
    
    always@(ReadReg1 or ReadReg2 or jump) 
    begin
        ReadData1 = (jump == 2'b10)? regFile[31] : regFile[ReadReg1];     //busA=�Ĵ�����[rs(�Ĵ�����)]
        ReadData2 = (jump == 2'b10)? 0 : regFile[ReadReg2];      //busB=�Ĵ�����[rt(�Ĵ�����)]
        //$display("regfile %d %d\n", ReadReg1, ReadReg2);
    end
   
    
    always@(negedge CLK)
    begin
        if( jump == 2'b01)
            i = 31;
        else
            i = WriteReg;    
            
        //$0��Ϊ0������д��Ĵ����ĵ�ַ����Ϊ0
        if(RegWre && i)  //���д�ź���1��д�Ĵ�����ΪNULL
            begin               //1��д�뵱ǰ��ַ
                    regFile[i] <= WriteData;
            end
    end
endmodule
