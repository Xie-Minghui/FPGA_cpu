`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 20:25:50
// Design Name: 
// Module Name: eqcmp
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


module eqcmp#(parameter WIDTH = 32)(
	input wire [WIDTH-1:0] cin_a,cin_b,
	input wire[5:0] op,
	input wire[4:0] rt,
	output wire cout
    );
	// assign cout = (cin_a == cin_b) ? 1 : 0;
	assign cout = (op == `EXE_BEQ) ? (cin_a == cin_b) :
	  			(op == `EXE_BNE) ? (cin_a != cin_b):
				(op == `EXE_BGTZ) ? ((cin_a[31] == 1'b0) && (cin_a != `ZeroWord)):
				(op == `EXE_BLEZ) ? ((cin_a[31] == 1'b1) || (cin_a == `ZeroWord)):
				((op == `EXE_REGIMM_INST) && ((rt == `EXE_BGEZ) || (rt == `EXE_BGEZAL))) ?(cin_a[31] == 1'b0) :
				((op == `EXE_REGIMM_INST) && ((rt == `EXE_BLTZ) || (rt == `EXE_BLTZAL))) ? ((cin_a[31] == 1'b1)):
				0;
endmodule
