`timescale 1ns / 1ps
`include"defines.vh"
module controller(
	input wire clk,rst,
	//decode stage
	input wire[5:0] opD,functD,
	output wire pcsrcD,branchD,
	input wire equalD,
	input wire[4:0] rtD,rsD,
	output wire jumpD,
	output wire logI,jrD,

	//execute stage
	input wire flushE,stallE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[7:0] alucontrolE,
	output wire writehiE,writeloE,
	output wire [1:0] hilo_srcE,
	output wire alE,jrE,readcp0E,
	//mem stage
	output wire memtoregM,
	output wire memwriteM,
	output wire	regwriteM,readhiloM,hilo_selM,
	output wire writecp0M,readcp0M,
	output wire breakM,syscallM,eretM,reserveM,
	input wire flushM,stallM,
	//write back stage
	output wire memtoregW,regwriteW,readhiloW,readcp0W,
	input wire flushW
    );

	//decode stage
//	wire[1:0] aluopD;
	wire memtoregD,alusrcD,
		regdstD,regwriteD;
	wire memwriteD;
	wire writecp0D,readcp0D;

	

	wire writehiD,writeloD,hilo_selD,readhiloD;
	wire breakD,syscallD,eretD,reserveD;

	wire alD;
	wire [1:0] hilo_srcD;

	wire[7:0] alucontrolD;
    assign logI = (opD[3:2] == 2'b11 ); 

	assign readhiloD = ((opD == `EXE_NOP) && ((functD == 6'b010000) || (functD == 6'b010010)) );
	assign hilo_selD = ((opD == `EXE_NOP) && (functD == 6'b010000));//选择hi还是lo
	assign hilo_srcD = ((opD == `EXE_NOP) && (functD == 6'b010001 || functD == 6'b010011)) ? 2'b00://rs
						((opD == `EXE_NOP) && (functD == 6'b011000 || functD == 6'b011001)) ? 2'b01://乘法
						2'b10;//除法
	assign writehiD = ((opD == `EXE_NOP) && (functD == 6'b010001 || functD == 6'b011000 || functD == 6'b011001 || 
										functD == 6'b011010 || functD == 6'b011011) );
	assign writeloD = ((opD == `EXE_NOP) && (functD == 6'b010011 || functD == 6'b011000 || functD == 6'b011001 ||
										functD == 6'b011010 || functD == 6'b011011) ); 
										
	assign readcp0D = (opD == 6'b010000) &&(rsD == 5'b00000);
	assign writecp0D = (opD == 6'b010000) && (rsD == 5'b00100);
	//execute stage
	wire memwriteE;
	wire readhiloE,hilo_selE;
	wire writecp0E;
	wire breakE,syscallE,eretE,reserveE;
	// wire [2:0] load_selE;

	//memory  stage
	// wire [2:0] load_selM;
	
	//write stage
	main_decoder md(.jump(jumpD),.branch(branchD),.alusrc(alusrcD),.memWrite(memwriteD),.memtoReg(memtoregD),
		.regwrite(regwriteD),.regdst(regdstD),.opcode(opD),.al(alD),.jr(jrD),.rt(rtD),.funct(functD),.rs(rsD));

	alu_decoder ad(.funct(functD),.alu_control(alucontrolD),.op(opD),.break(breakD),
				.syscall(syscallD),.eret(eretD),.reserve(reserveD));
	assign pcsrcD = branchD & equalD;

	//pipeline cache
	flopenrc #(27) regdE(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin({memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,
	writehiD,writeloD,hilo_srcD,hilo_selD,readhiloD,alD,jrD, writecp0D, readcp0D,breakD,syscallD,eretD,reserveD}),
		.cout({memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,writehiE,writeloE,hilo_srcE,hilo_selE,
		readhiloE,alE,jrE, writecp0E, readcp0E,breakE,syscallE,eretE,reserveE}));

	flopenrc #(11) regM(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin({memtoregE,memwriteE,regwriteE,readhiloE,hilo_selE, writecp0E, readcp0E,breakE,syscallE,eretE,reserveE}),
		.cout({memtoregM,memwriteM,regwriteM,readhiloM,hilo_selM, writecp0M, readcp0M,breakM,syscallM,eretM,reserveM}));
           
	floprc #(8) regW(.clk(clk),.rst(rst),.clear(flushW),.cin({memtoregM,regwriteM,readhiloM,readcp0M,breakM,syscallM,eretM,reserveM}),
		.cout({memtoregW,regwriteW,readhiloW,readcp0W,breakW,syscallW,eretW,reserveW}));

endmodule
