`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/17 16:31:00
// Design Name: 
// Module Name: ControlUnit
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

//Control Unit
module ControlUnit(
        input zero,         //ALU�������Ƿ�Ϊ0��Ϊ0ʱ��Ϊ1
        input [5:0] op,     //ָ��Ĳ�����
        input [5:0] func,
        output reg PCWre,       //PC�Ƿ���ĵ��ź�����Ϊ0ʱ�򲻸��ģ�������Ը���   
        output reg InsMemRW,    //ָ��Ĵ�����״̬��������Ϊ0��ʱ��дָ��Ĵ���������Ϊ��ָ��Ĵ���
        output reg RegDst,      //д�Ĵ�����Ĵ����ĵ�ַ��Ϊ0��ʱ���ַ����rt��Ϊ1��ʱ���ַ����rd
        output reg RegWre,      //�Ĵ�����дʹ�ܣ�Ϊ1��ʱ���д
        output reg ALUSrcA,     //����ALU����A��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data1�����Ϊ1��ʱ��������λ��sa
        output reg ALUSrcB,     //����ALU����B��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data2�����Ϊ1ʱ��������չ����������
        output reg [2:0]PCSrc,  //��ȡ��һ��pc�ĵ�ַ������ѡ������ѡ�������,0Ϊpc+4��1Ϊbranch��2Ϊjump
        output reg [2:0]ALUOp,  //ALU 8�����㹦��ѡ��(000-111)
        output reg mRD,         //���ݴ洢���������źţ�Ϊ0��
        output reg mWR,         //���ݴ洢��д�����źţ�Ϊ0д
        output reg DBDataSrc,   //���ݱ����ѡ��ˣ�Ϊ0����ALU�������������Ϊ1�������ݼĴ�����Data MEM�������       
        output reg [1:0] jump         //0�����ݣ�1��jal, 2��jr
    );
    
    initial begin
        PCWre = 1;
        InsMemRW = 1;
        RegWre = 1;
        mRD = 0;
        mWR = 0;
        DBDataSrc = 0;
        jump = 0;
    end
    
    always@(op or zero or func) 
    begin
        PCWre = (op == 6'b111111) ? 0 : 1;   //halt
        InsMemRW = (op == 6'b111111) ? 0 : 1;    
        mWR = (op == 6'b101011) ? 1 : 0;     //sw
        mRD = (op == 6'b100011) ? 1 : 0;     //lw
        DBDataSrc = (op == 6'b100011) ? 1 : 0;      //lw,Ϊ1ʱ���ȡ����������Ȼ���ALU���
        jump = 0;   //0�����ݣ�01��д��ת��ַ(jal),10�Ƕ���ת��ַ(jr)
        case(op)
            6'b000000:
                case(func)
                    //add
                    6'b100000:
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            ALUSrcA = 0;
                            ALUSrcB = 0;
                            PCSrc = 2'b000;
                            ALUOp = 3'b000;
                        end
                     //sub
                    6'b100010:
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            ALUSrcA = 0;
                            ALUSrcB = 0;
                            PCSrc = 2'b000;
                            ALUOp = 3'b001;
                        end
                    //jr
                    6'b001000:
                        begin
                            RegDst = 1;
                            RegWre = 0;
                            ALUSrcA = 0;
                            ALUSrcB = 0;
                            jump = 2'b10;
                            PCSrc = 3'b100;
                            ALUOp = 3'b000;
                        end
                    //sll
                    6'b000000:
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            ALUSrcA = 1;
                            ALUSrcB = 0;
                            PCSrc = 2'b000;
                            ALUOp = 3'b010;
                        end                
                    //slt
                    6'b101010:
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            ALUSrcA = 0;
                            ALUSrcB = 0;
                            PCSrc = 2'b000;
                            ALUOp = 3'b110;
                        end
            endcase        
            //addi
            6'b001000:
                begin
                    RegDst = 0;
                    RegWre = 1;
                    ALUSrcA = 0;
                    ALUSrcB = 1;
                    PCSrc = 2'b000;
                    ALUOp = 3'b000;
                end
            //bne
            6'b000101:
                begin
                    RegDst = 0;
                    RegWre = 0;
                    ALUSrcA = 0;
                    ALUSrcB = 0;
                    PCSrc = zero ? 2'b000 : 2'b001;
                    ALUOp = 3'b001;
                end
            //slti
            6'b001010:
                begin
                    RegDst = 0;
                    RegWre = 1;
                    ALUSrcA = 0;
                    ALUSrcB = 1;
                    PCSrc = 2'b000;
                    ALUOp = 3'b101;
                end
            //beq
            6'b000100:
                begin
                    RegDst = 0;
                    RegWre = 0;
                    ALUSrcA = 0;
                    ALUSrcB = 0;
                    PCSrc = zero ? 2'b001 : 2'b000;
                    ALUOp = 3'b001;
                end
            //sw
            6'b101011:
                begin
                    RegDst = 0;
                    RegWre = 0;
                    ALUSrcA = 0;
                    ALUSrcB = 1;
                    PCSrc = 2'b000;
                    ALUOp = 3'b000;
                end
            //lw
            6'b100011:
                begin
                    RegDst = 0;
                    RegWre = 1;
                    ALUSrcA = 0;
                    ALUSrcB = 1;
                    PCSrc = 2'b000;
                    ALUOp = 3'b000;
                end
            //j
            6'b000010:
                begin
                    RegDst = 0;
                    RegWre = 0;
                    ALUSrcA = 0;
                    ALUSrcB = 0;
                    PCSrc = 2'b010;
                    ALUOp = 3'b000;
                end
            //jal
            6'b000011:
                begin
                    RegDst = 0;
                    RegWre = 1;
                    ALUSrcA = 0;
                    ALUSrcB = 0;
                    PCSrc = 3'b010;
                    ALUOp = 3'b000;
                    jump = 2'b01;
                end
            //halt
            6'b111111:
                begin
                    RegDst = 0;
                    RegWre = 0;
                    ALUSrcA = 0;
                    ALUSrcB = 0;
                    PCSrc = 2'b011;
                    ALUOp = 3'b000;
                end
//ori
//            6'b010000:
//                begin
//                    ExtSel = 1;
//                    RegDst = 0;
//                    RegWre = 1;
//                    ALUSrcA = 0;
//                    ALUSrcB = 1;
//                    PCSrc = 2'b00;
//                    ALUOp = 3'b011;
//                end
//            //and
//            6'b010001:
//                begin
//                    ExtSel = 0;
//                    RegDst = 1;
//                    RegWre = 1;
//                    ALUSrcA = 0;
//                    ALUSrcB = 0;
//                    PCSrc = 2'b00;
//                    ALUOp = 3'b100;
//                end
//            //or
//            6'b010010:
//                begin
//                    ExtSel = 0;
//                    RegDst = 1;
//                    RegWre = 1;
//                    ALUSrcA = 0;
//                    ALUSrcB = 0;
//                    PCSrc = 2'b00;
//                    ALUOp = 3'b011;
//                end
        endcase
    end
endmodule
