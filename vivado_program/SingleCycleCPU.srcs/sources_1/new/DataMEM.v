`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 16:32:49
// Design Name: 
// Module Name: DataMEM
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

//RAM
//data memory ���ݴ洢��
module DataMEM(
        /*
            Daddr�����ݴ洢����ַ����˿�
            DataIn�����ݴ洢����������˿�
            DataOut�����ݴ洢����������˿�
            mRD�����ݴ洢���������źţ�Ϊ0��
            mWR�����ݴ洢��д�����źţ�Ϊ0д
            DBDataSrc��ѡ�����ALU������Ƕ���������
            DB,��������ѡ������յ����
        */
        input mRD,
        input mWR,
        input CLK,
        input DBDataSrc,
        input [31:0] DAddr,
        input [31:0] DataIn,
        output reg[31:0] DataOut,
        output reg[31:0] DB
    );
    reg [7:0] ram [0:127];     // �洢�����������reg����    
    integer i;
    initial begin 
        DB <= 16'b0;
        for(i=0;i<128;i=i+1)
            begin
                ram[i]=0;
            end
          
        ram[4] = 8'b00000101; 
        ram[8] = 8'b00000001;
        ram[12]= 8'b00000111; 
        ram[16]= 8'b00010000; 
        ram[20]= 8'b00001001; 
        ram[24]= 8'b00001101; 
        ram[28]= 8'b00011001; 
        ram[32]= 8'b00000100; 
        ram[36]= 8'b00001100; 
        ram[40]= 8'b00011111; 
    end
    
     
    
    always@(mRD or DAddr or DBDataSrc)
    begin
        //��
        DataOut[7:0] = mRD ? ram[DAddr + 3] : 8'bz; // z Ϊ����̬     
        DataOut[15:8] = mRD ? ram[DAddr + 2] : 8'bz;     
        DataOut[23:16] = mRD ? ram[DAddr + 1] : 8'bz;     
        DataOut[31:24] = mRD ? ram[DAddr] : 8'bz;
    
        DB = (DBDataSrc == 0) ? DAddr : DataOut;   //Daddr��ALU������Ľ�������������ݣ�Ҳ�����ǵ�ַ,DataOut�ǴӴ洢����ȡ����ֵ
    end
     
    always@(negedge CLK)
    begin   
        //д
        if(mWR)
            begin
                ram[DAddr] = DataIn[31:24];    
                ram[DAddr + 1] = DataIn[23:16];
                ram[DAddr + 2] = DataIn[15:8];     
                ram[DAddr + 3] = DataIn[7:0];    
            end
        //$display("mwr: %d $12 %d %d %d %d", mWR, ram[12], ram[13], ram[14], ram[15]);
    end
    
endmodule
