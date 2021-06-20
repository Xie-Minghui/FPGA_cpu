`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/08 12:53:20
// Design Name: 
// Module Name: ALU
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

`include"defines.vh"
module ALU(num1,num2,op,result,sa,hilo_temp,sel,load_usign,overflow,adel,ades);
    input wire  [31:0] num1,num2;
    input wire  [7:0] op;
    input wire [4:0] sa;
    output  wire [31:0] result; 
    output wire overflow,adel,ades;
    output [3:0] sel;
    output load_usign;
    wire [31:0] mult_a,mult_b;
    output  wire [63:0] hilo_temp;
    assign mult_a = ((op == `EXE_MULT_OP) && (num1[31] == 1'b1)) ? (~num1 + 1) : num1;
    assign mult_b = ((op == `EXE_MULT_OP) && (num2[31] == 1'b1)) ? (~num2 + 1) : num2;
    assign hilo_temp = ((op == `EXE_MULT_OP) && (num1[31] ^ num2[31] == 1'b1)) ? ~(mult_a * mult_b)+ 1: mult_a * mult_b;

    assign sel = ((op == `EXE_LB_OP || op == `EXE_LBU_OP || op == `EXE_SB_OP) && (num2[1:0] == 2'b00))? 4'b0001:
        ((op == `EXE_LB_OP || op == `EXE_LBU_OP || op == `EXE_SB_OP) && (num2[1:0] == 2'b01))? 4'b0010:
        ((op == `EXE_LB_OP || op == `EXE_LBU_OP || op == `EXE_SB_OP) && (num2[1:0] == 2'b10))? 4'b0100:
        ((op == `EXE_LB_OP || op == `EXE_LBU_OP || op == `EXE_SB_OP) && (num2[1:0] == 2'b11))? 4'b1000:
        ((op == `EXE_LH_OP || op == `EXE_LHU_OP || op == `EXE_SH_OP) && (num2[1:0] == 2'b00))? 4'b0011:
        ((op == `EXE_LH_OP || op == `EXE_LHU_OP || op == `EXE_SH_OP) && (num2[1:0] == 2'b10))? 4'b1100:
        ((op == `EXE_LW_OP || op == `EXE_SW_OP))? 4'b1111: 4'b0000;
    
    assign adel = ((op == `EXE_LH_OP || op == `EXE_LHU_OP) && (result[0] == 1'b1)) ||
                (op == `EXE_LW_OP && result[1:0] != 2'b00);

    assign ades = (op == `EXE_SH_OP && result[0] == 1'b1) || (op == `EXE_SW_OP && result[1:0] != 2'b00);
    //地址错误，是alu的输出错误，而不是num2错误。

    assign load_usign = (op == `EXE_LBU_OP || op == `EXE_LHU_OP);
    assign overflow = (op == `EXE_ADD_OP || op == `EXE_ADDI_OP) ? ( (num1[31] & num2[31] & (~result[31])) | ((~num1[31]) & (~num2[31]) & result[31]) ) : 
                        (op == `EXE_SUB_OP) ? ( (num1[31] & (~num2[31]) & (~result[31])) | ((~num1[31]) & num2[31] & result[31]) ):1'b0;


    assign result = (op  == `EXE_AND_OP) ? num1 & num2:
                    (op == `EXE_OR_OP) ? num1 | num2:
                    (op == `EXE_XOR_OP) ? num1 ^ num2:
                    (op == `EXE_NOR_OP) ? ~(num1 | num2):
                    (op == `EXE_ANDI_OP) ? num1 & num2:
                    (op == `EXE_XORI_OP) ? num1 ^ num2:
                    (op == `EXE_LUI_OP) ? {num2[15:0],{16{1'b0}}}:
                    (op == `EXE_ORI_OP) ? num1 | num2 :

                    (op == `EXE_SLL_OP) ? (num2 << sa):
                    (op == `EXE_SRL_OP) ? (num2 >> sa):
                    (op == `EXE_SLLV_OP) ? (num2 << num1[4:0]):
                    (op == `EXE_SRLV_OP) ? (num2 >> num1[4:0]):
                    (op == `EXE_SRA_OP) ? ({32{num2[31]}} << (6'd32-{1'b0,sa})) | (num2 >> sa):
                    (op == `EXE_SRAV_OP) ? ({32{num2[31]}} << (6'd32-{1'b0,num1[4:0]})) | (num2 >> num1[4:0]):

                    (op == `EXE_ADD_OP) ? (num1 + num2) :
                    (op == `EXE_ADDU_OP) ? (num1 + num2):
                    (op == `EXE_SUB_OP) ? (num1 - num2):
                    (op == `EXE_SUBU_OP) ? (num1 - num2):
                    (op == `EXE_SLT_OP) ? (((num1 < num2) && (num1[31] == num2[31])) ? 1: (num1[31] == 1 && num2[31] == 0) ? 1 : 0) :
                    (op == `EXE_SLTU_OP) ? (num1 < num2):
                    (op == `EXE_ADDI_OP) ? (num1 + num2):
                    (op == `EXE_ADDIU_OP) ? (num1 + num2):
                    (op == `EXE_SLTI_OP) ? (((num1 < num2) && (num1[31] == num2[31])) ? 1: (num1[31] == 1 && num2[31] == 0) ? 1 : 0) :
                    (op == `EXE_SLTIU_OP) ? (num1 < num2):

                    (op == `EXE_LB_OP || op == `EXE_LBU_OP || op == `EXE_LH_OP || op == `EXE_LHU_OP || op == `EXE_LW_OP ||
                     op == `EXE_SB_OP || op == `EXE_SH_OP || op == `EXE_SW_OP) ? (num1 + num2) : 0;

                    // (op == `EXE_MULT_OP) ?
    // always @(*)begin
    //     case(op)
    //         `EXE_AND_OP:result <= num1 & num2;
    //         `EXE_OR_OP:result <= num1 | num2;
    //         `EXE_XOR_OP:result <= num1 ^ num2;
    //         `EXE_NOR_OP:result <= ~(num1 | num2);
    //         `EXE_ANDI_OP:result <= num1 & num2;
    //         `EXE_XORI_OP:result <= num1 ^ num2;
    //         `EXE_LUI_OP:result <= {num2[15:0],{16{0}}};
    //         `EXE_ORI_OP:result <= num1 | num2;
    //     endcase
    // end
    
endmodule
