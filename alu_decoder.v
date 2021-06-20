`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 13:26:29
// Design Name: 
// Module Name: alu_decoder
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
module alu_decoder(funct,op,alu_control,break,syscall,eret,reserve);
input[5:0] funct;
input [5:0] op;
output reg[7:0] alu_control;
output reg break,syscall,eret,reserve;

always@(*)begin
	break <= 1'b0;
	syscall <= 1'b0;
	eret <= 1'b0;
	reserve <= 1'b0;
    case(op)
    	`EXE_NOP:
    		case(funct)
    			`EXE_AND:alu_control <= `EXE_AND_OP;
    			`EXE_OR:alu_control <= `EXE_OR_OP;
    			`EXE_XOR:alu_control <= `EXE_XOR_OP;
    			`EXE_NOR:alu_control <= `EXE_NOR_OP;
    			`EXE_SLL:alu_control <= `EXE_SLL_OP;
    			`EXE_SRL:alu_control <= `EXE_SRL_OP;
    			`EXE_SRA:alu_control <= `EXE_SRA_OP;
    			`EXE_SLLV:alu_control <= `EXE_SLLV_OP;
    			`EXE_SRLV:alu_control <= `EXE_SRLV_OP;
    			`EXE_SRAV:alu_control <= `EXE_SRAV_OP;
    			`EXE_MFHI:alu_control <= `EXE_MFHI_OP;
    			`EXE_MFLO:alu_control <= `EXE_MFLO_OP;
    			`EXE_MTHI:alu_control <= `EXE_MTHI_OP;
    			`EXE_MTLO:alu_control <= `EXE_MTLO_OP;
    			`EXE_ADD:alu_control <= `EXE_ADD_OP;
    			`EXE_ADDU:alu_control <= `EXE_ADDU_OP;
    			`EXE_SUB:alu_control <= `EXE_SUB_OP;
    			`EXE_SUBU:alu_control <= `EXE_SUBU_OP;
    			`EXE_SLT:alu_control <= `EXE_SLT_OP;
    			`EXE_SLTU:alu_control <= `EXE_SLTU_OP;
    			`EXE_MULT:alu_control <= `EXE_MULT_OP;
    			`EXE_MULTU:alu_control <= `EXE_MULTU_OP;
    			`EXE_DIV:alu_control <= `EXE_DIV_OP;
    			`EXE_DIVU:alu_control <= `EXE_DIVU_OP;
    			`EXE_JR:alu_control <= `EXE_JR_OP;
    			`EXE_JALR:alu_control <= `EXE_JALR_OP;
    			`EXE_BREAK:begin alu_control <= `EXE_BREAK_OP; break <= 1'b1;end
    			`EXE_SYSCALL:begin alu_control <= `EXE_SYSCALL_OP; syscall <= 1'b1; end
				default:begin alu_control <= 8'bxxxxxxxx; reserve <= 1'b1;end
    		endcase
		
		`EXE_ANDI:alu_control <= `EXE_ANDI_OP;
		`EXE_XORI:alu_control <= `EXE_XORI_OP;
		`EXE_LUI:alu_control <= `EXE_LUI_OP;
		`EXE_ORI:alu_control <= `EXE_ORI_OP;
		`EXE_ADDI:alu_control <= `EXE_ADDI_OP;
		`EXE_ADDIU:alu_control <= `EXE_ADDIU_OP;
		`EXE_SLTI:alu_control <= `EXE_SLTI_OP;
		`EXE_SLTIU:alu_control <= `EXE_SLTIU_OP;
		6'b010000:begin
		     case(funct)
				6'b011000:
					eret <= 1'b1;
				// default:reserve <= 1'b1;
			endcase
			alu_control<= 8'b00000000; 
		end
		`EXE_J:alu_control <= `EXE_J_OP;
		`EXE_JAL:alu_control <= `EXE_JAL_OP;
		`EXE_BEQ:alu_control <= `EXE_BEQ_OP;
		`EXE_BGTZ:alu_control <= `EXE_BGTZ_OP;
		`EXE_BLEZ:alu_control <= `EXE_BLEZ_OP;
		`EXE_BNE:alu_control <= `EXE_BNE_OP;
		//下面的语句要注释掉，并且特权指令的判断要提前，因为下面这4个是根据rt判断的，但是他的funct跟特权指令的op
		//冲突，而且下面4个指令不需要经过ALU，所以直接注释掉。
//		`EXE_BLTZ:alu_control <= `EXE_BLTZ_OP;
//		`EXE_BLTZAL:alu_control <= `EXE_BLTZAL_OP;
//		`EXE_BGEZ:alu_control <= `EXE_BGEZ_OP;
//		`EXE_BGEZAL:alu_control <= `EXE_BGEZAL_OP;
		 6'b000001:;//为了区分保留指令。
		`EXE_LB:alu_control <= `EXE_LB_OP;
		`EXE_LBU:alu_control <= `EXE_LBU_OP;
		`EXE_LH:alu_control <= `EXE_LH_OP;
		`EXE_LHU:alu_control <= `EXE_LHU_OP;
		`EXE_LW:alu_control <= `EXE_LW_OP;
		`EXE_SB:alu_control <= `EXE_SB_OP;
		`EXE_SH:alu_control <= `EXE_SH_OP;
		`EXE_SW:alu_control <= `EXE_SW_OP;
		default:begin alu_control <= 8'bxxxxxxxx; reserve <= 1'b1; end
    endcase
end
endmodule
