`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/15 20:56:28
// Design Name: 
// Module Name: main_decoder
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
module main_decoder(opcode,jump,branch,alusrc,memWrite,memtoReg,regwrite,regdst,rt,al,jr,funct,rs);
input [5:0] opcode,funct;
input [4:0] rt,rs;
output  jump,branch,alusrc,memtoReg,regwrite,regdst,al,jr;
output wire memWrite;
reg [8:0] output_assemble;
assign {regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,al,jr} = output_assemble;
always @(*)begin
	case(opcode)
		// `EXE_NOP: output_assemble <= 11'b110000000000;
		`EXE_ANDI: output_assemble <= 9'b101000000;
		`EXE_XORI: output_assemble <= 9'b101000000;
		`EXE_LUI: output_assemble <= 9'b101000000;
		`EXE_ORI: output_assemble <= 9'b101000000;
		`EXE_ADDI:output_assemble <= 9'b101000000;
		`EXE_ADDIU: output_assemble <= 9'b101000000;
		`EXE_SLTI: output_assemble <= 9'b101000000;
		`EXE_SLTIU: output_assemble <= 9'b101000000;

		`EXE_SB: output_assemble <= 9'b001010000;
		`EXE_SH: output_assemble <= 9'b001010000;
		`EXE_SW: output_assemble <= 9'b001010000;
		`EXE_LB: output_assemble <= 9'b101001000;
		`EXE_LBU: output_assemble <= 9'b101001000;
		`EXE_LH: output_assemble <= 9'b101001000;
		`EXE_LHU: output_assemble <= 9'b101001000;
		`EXE_LW: output_assemble <= 9'b101001000;

		`EXE_SPECIAL_INST:
			case(funct)
				`EXE_JR: output_assemble <= 9'b000000101;
				`EXE_JALR: output_assemble <= 9'b110000101;
				default: output_assemble <= 9'b110000000;//R-type
			endcase
		`EXE_J: output_assemble <= 9'b000000100;
		`EXE_JAL: output_assemble <= 9'b100000110;
		`EXE_BEQ: output_assemble <= 9'b000100000;
		`EXE_BNE: output_assemble <= 9'b000100000;
		`EXE_BGTZ: output_assemble <= 9'b000100000;
		`EXE_BLEZ: output_assemble <= 9'b000100000;
		`EXE_REGIMM_INST: 
			case(rt)
				`EXE_BGEZ: output_assemble <= 9'b000100000;
				`EXE_BLTZ: output_assemble <= 9'b000100000;
				`EXE_BLTZAL: output_assemble <= 9'b100100010;
				`EXE_BGEZAL: output_assemble <= 9'b100100010;
			endcase
		
		6'b010000://特权指令:
		  case(rs)
		      5'b00100:output_assemble <= 9'b000000000;//mt
		      5'b00000:output_assemble <= 9'b100000000;//mf
		  endcase
		// 6'b10009: output_assemble <= 10'b1010010;///lw
		// 6'b10109: output_assemble <= 10'b0x10100;//sw
		// 6'b000100: output_assemble <= 10'b0001000;//beq
		// 6'b001000: output_assemble <= 10'b1010000;//addi
		// 6'b000010: output_assemble <= 10'b0000001;//jump
		default: output_assemble <= 9'bxxxxxxxxx; //???
	endcase
end
endmodule
