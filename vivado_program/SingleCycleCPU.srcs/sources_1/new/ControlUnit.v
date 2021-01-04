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
        input zero,         //ALU运算结果是否为0，为0时候为1
        input [5:0] op,     //指令的操作码
        input [5:0] func,
        output reg PCWre,       //PC是否更改的信号量，为0时候不更改，否则可以更改   
        output reg InsMemRW,    //指令寄存器的状态操作符，为0的时候写指令寄存器，否则为读指令寄存器
        output reg RegDst,      //写寄存器组寄存器的地址，为0的时候地址来自rt，为1的时候地址来自rd
        output reg RegWre,      //寄存器组写使能，为1的时候可写
        output reg ALUSrcA,     //控制ALU数据A的选择端的输入，为0的时候，来自寄存器堆data1输出，为1的时候来自移位数sa
        output reg ALUSrcB,     //控制ALU数据B的选择端的输入，为0的时候，来自寄存器堆data2输出，为1时候来自扩展过的立即数
        output reg [2:0]PCSrc,  //获取下一个pc的地址的数据选择器的选择端输入,0为pc+4，1为branch，2为jump
        output reg [2:0]ALUOp,  //ALU 8种运算功能选择(000-111)
        output reg mRD,         //数据存储器读控制信号，为0读
        output reg mWR,         //数据存储器写控制信号，为0写
        output reg DBDataSrc,   //数据保存的选择端，为0来自ALU运算结果的输出，为1来自数据寄存器（Data MEM）的输出       
        output reg [1:0] jump         //0是数据，1是jal, 2是jr
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
        DBDataSrc = (op == 6'b100011) ? 1 : 0;      //lw,为1时输出取出的数，不然输出ALU结果
        jump = 0;   //0是数据，01是写跳转地址(jal),10是读跳转地址(jr)
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
