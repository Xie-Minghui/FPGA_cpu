`timescale 1ns / 1ps

module datapath(
	input wire clk,rst,
	input wire[5:0] int_iM,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	input wire logI,jrD,
	output wire equalD,
	output wire[5:0] opD,functD,
	output wire[4:0] rtD,rsD,
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,alE,jrE,
	input wire[7:0] alucontrolE,
	output wire flushE, 
	input wire writehiE,
	input wire writeloE,
	input wire [1:0] hilo_srcE,
	output wire stallE,
	input wire readcp0E,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	input wire hiorlo_selM,
	input wire readhiloM,
	input wire writecp0M,readcp0M,
	output wire[3:0] ls_selM2,
	input wire breakM,syscallM,eretM,reserveM,
	output wire flushM,
	output wire[31:0]  excepttype_iM,
	output wire stallM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	input wire readhiloW,
	input wire readcp0W,
	output wire[31:0] resultW,
	output wire[4:0] writeregW,
	output wire[31:0] pcW,
	output wire flushW,
	//memory request stall
	input wire	stallreq_from_if,
	input wire	stallreq_from_mem
    );
	
	//fetch stage
	wire stallF;
	wire is_in_delayslot_iF,flushF,pc_adelF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D,instrD;
	wire forwardaD,forwardbD;
	wire [4:0] rdD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D,pcj;
	wire[4:0] saD;
	wire [31:0] pcplus8D;
	wire [31:0] pcD;
	wire pc_adelD;
	wire is_in_delayslot_iD;
	//execute stage
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE;
	wire [4:0] writeregE,writereg2E;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE,aluout2E;
	wire [4:0] saE;//
	wire[63:0] hilo_temp_aluE;//
	wire[63:0] hilo_tempE;//
	wire[63:0] hilo_divE;
	wire[63:0] hilo_rsE;
	wire[31:0] hiE;///
	wire[31:0] loE;///
	wire div_readyE,start_divE,signed_divE,stall_divE;
	wire[3:0] ls_selE;
	wire load_usignE;
	wire [31:0] pcplus8E;
	wire [31:0] pcE;
	wire overflowE,pc_adelE,adelE,adesE;
	wire is_in_delayslot_iE;

	// wire [31:0] srcb2E;
	//mem stage
	wire [4:0] writeregM;
	wire [31:0] hiM, loM;
	wire [31:0] hiorloM;
	wire [31:0] forwardDataM;
	wire [31:0] pcM;
	wire[31:0] rdM;
	wire [31:0] srcb2M;
	wire overflowM,pc_adelM,adelM,adesM;
	wire[31:0] except_pc;
	wire [3:0] ls_selM;

	wire load_usignM;
	wire[31:0] readcp0dataM;
	wire[31:0] current_inst_addr_iM,bad_addr_iM;
	wire [31:0] count_oM,compare_oM,status_oM,cause_oM,epc_oM,config_oM,prid_oM,badvaddrM;
	wire timer_int_oM;
	wire is_in_delayslot_iM;
	
	// wire flushM;
	//writeback stage
	wire [31:0] aluoutW,readdataW;
	wire [31:0] hiorloW;
	wire [31:0] resultW0;
	wire [31:0] readcp0dataW;
	wire [31:0] resultW1;
	// wire flushW;
	//hazard detection
	hazard h(
		//fetch stage
		stallF,flushF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,jrD,flushD,
		//execute stage
		rsE,rtE,
		writereg2E,
		regwriteE,
		memtoregE,
		stall_divE,
		forwardaE,forwardbE,
		flushE,
		stallE,readcp0E,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,readcp0M,
		excepttype_iM,flushM,except_pc,epc_oM,stallM,
		//write back stage
		writeregW,
		regwriteW,flushW,
		//memory request stall
		stallreq_from_if,
		stallreq_from_mem
		);
	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(.cin_a(pcplus4F),.cin_b(pcbranchD),.sel(pcsrcD),.cout(pcnextbrFD));
	mux2 #(32) pcjmux(.cin_a(pcnextbrFD),.cin_b(pcj),
		.sel(jumpD),.cout(pcnextFD));
	

	//regfile (operates in decode and writeback)
	regfile rf(.clk(~clk),.we3(regwriteW),.ra1(rsD),.ra2(rtD),.ra3(writeregW),.wd3(resultW),.rd1(srcaD),.rd2(srcbD));

	//fetch stage logic
	pc_flop #(32) pcreg(.clk(clk),.rst(rst),.enable(~stallF),.clear(flushF),.except_pc(except_pc),.cin(pcnextFD),.cout(pcF));
	adder pcadd1(.cin_a(pcF),.cin_b(32'b100),.cout(pcplus4F));
	assign pc_adelF = (pcF[1:0] != 2'b00);
	assign is_in_delayslot_iF = jumpD | branchD;
	//decode stage
	flopenrc #(32) r1D(.clk(clk),.rst(rst),.enable(~stallD),.clear(flushD),.cin(pcplus4F),.cout(pcplus4D));
	flopenrc #(32) r2D(.clk(clk),.rst(rst),.enable(~stallD),.clear(flushD),.cin(instrF),.cout(instrD));
	flopenrc #(32) r3D(.clk(clk),.rst(rst),.enable(~stallD),.clear(flushD),.cin(pcF),.cout(pcD));
	flopenrc #(1) r4D(.clk(clk),.rst(rst),.enable(~stallD),.clear(flushD),.cin(pc_adelF),.cout(pc_adelD));
	flopenrc #(1) r5D(.clk(clk),.rst(rst),.enable(~stallD),.clear(flushD),.cin(is_in_delayslot_iF),.cout(is_in_delayslot_iD));

    wire [31:0] signimm,signimmu;
	signext se(.cin(instrD[15:0]),.cout(signimm));
	signextu seu(.cin(instrD[15:0]),.cout(signimmu));
	
	
	mux2 #(32) signmux(.cin_a(signimm),.cin_b(signimmu),.sel(logI),.cout(signimmD));
	
	sl2 immsh(.cin(signimmD),.cout(signimmshD));

	adder pcadd2(.cin_a(pcplus4D),.cin_b(signimmshD),.cout(pcbranchD));
	adder pcadd3(.cin_a(pcplus4D),.cin_b(32'b100),.cout(pcplus8D));
	mux2 #(32) forwardamux(.cin_a(srcaD),.cin_b(forwardDataM),.sel(forwardaD),.cout(srca2D));
	mux2 #(32) jrmux(.cin_b(srca2D),.cin_a({pcplus4D[31:28],instrD[25:0],2'b00}),.sel(jrD),.cout(pcj));
	mux2 #(32) forwardbmux(.cin_a(srcbD),.cin_b(forwardDataM),.sel(forwardbD),.cout(srcb2D));
	eqcmp comp(.cin_a(srca2D),.cin_b(srcb2D),.op(opD),.rt(rtD),.cout(equalD));

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	
	//execute stage
	flopenrc #(32) r1E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(srcaD),.cout(srcaE));//
	flopenrc #(32) r2E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(srcbD),.cout(srcbE));
	flopenrc #(32) r3E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(signimmD),.cout(signimmE));
	flopenrc #(5) r4E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(rsD),.cout(rsE));
	flopenrc #(5) r5E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(rtD),.cout(rtE));
	flopenrc #(5) r6E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(rdD),.cout(rdE));
	flopenrc #(5) r7E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(saD),.cout(saE));
	flopenrc #(32) r8E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(pcplus8D),.cout(pcplus8E));
	flopenrc #(32) r9E(.clk(clk),.rst(rst),.enable(~stallE),.clear(1'b0),.cin(pcD),.cout(pcE));
	flopenrc #(1) r10E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(pc_adelD),.cout(pc_adelE));
	flopenrc #(1) r11E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(is_in_delayslot_iD),.cout(is_in_delayslot_iE));
	// flopenrc #(32) r10E(.clk(clk),.rst(rst),.enable(~stallE),.clear(flushE),.cin(srcb2D),.cout(srcb2E));

	mux3 #(32) forwardaemux(.cin_a(srcaE),.cin_b(resultW),.cin_c(forwardDataM),.sel(forwardaE),.cout(srca2E));
	mux3 #(32) forwardbemux(.cin_a(srcbE),.cin_b(resultW),.cin_c(forwardDataM),.sel(forwardbE),.cout(srcb2E));
	mux2 #(32) srcbmux(.cin_a(srcb2E),.cin_b(signimmE),.sel(alusrcE),.cout(srcb3E));
	div_controller div_con(.op(alucontrolE),.start_div(start_divE),.signed_div(signed_divE));
	div_self_align div(.clk(~clk),.rst(rst),.sign(signed_divE),.a(srca2E),.b(srcb3E),.valid(start_divE),.result(hilo_divE),.div_stall(stall_divE));
	ALU alu(.num1(srca2E),.num2(srcb3E),.result(aluoutE),.op(alucontrolE),.sa(saE),.hilo_temp(hilo_temp_aluE),.sel(ls_selE),.load_usign(load_usignE),
			.overflow(overflowE),.adel(adelE),.ades(adesE));
	mux2 #(5) wrmux(.cin_a(rtE),.cin_b(rdE),.sel(regdstE),.cout(writeregE)); 
	mux2 #(32) aluoutmux(.cin_a(aluoutE),.cin_b(pcplus8E),.sel(alE|jrE),.cout(aluout2E));///
	mux2 #(5) writeregmux(.cin_a(writeregE),.cin_b(5'b11111),.sel(alE),.cout(writereg2E));

	mux2 #(64) HilorsE(.cin_a({{32{1'b0}},srca2E}),.cin_b({srca2E,{32{1'b0}}}),.cout(hilo_rsE),.sel(writehiE));//閫夋嫨rs鍐欏叆hilo鐨勯珮浣嶈繕鏄綆锟???
	mux3 #(64) HiloE(.cin_a(hilo_rsE), .cin_b(hilo_temp_aluE), .cin_c(hilo_divE), .sel(hilo_srcE), .cout(hilo_tempE));
	mux2 #(32) hi(.cin_a(hiM), .cin_b(hilo_tempE[63:32]), .sel(writehiE),.cout(hiE));
	mux2 #(32) lo(.cin_a(loM), .cin_b(hilo_tempE[31:0]), .sel(writeloE),.cout(loE));
	hilo_reg hiloreg0(.clk(clk), .rst(rst), .we((writehiE | writeloE)&&(excepttype_iM == 0)), .hi(hiE),.lo(loE), .hi_o(hiM), .lo_o(loM));
	//出现异常时，hilo寄存器的值不应该被刷新，也不应该把出现异常时的�?�写入hilo.
	//mem stage
	// flopr #(32) r1M(.clk(clk),.rst(rst),.cin(srcb2E),.cout(writedataM));
	flopr_writeData #(32) writedataMux(.clk(clk),.rst(rst),.cin(srcb2E),.cout(writedataM),.ls_sel(ls_selE));
	flopenrc #(32) r2M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(aluout2E),.cout(aluoutM));
	flopenrc #(5) r3M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(writereg2E),.cout(writeregM));
	flopenrc #(5) r4M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin({ls_selE,load_usignE}),.cout({ls_selM,load_usignM}));
	flopenrc #(32) r5M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(pcE),.cout(pcM));
	flopenrc #(5) r6M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(rdE),.cout(rdM));
	flopenrc #(32) r7M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(srcb2E),.cout(srcb2M));
	flopenrc #(1) r8M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(overflowE),.cout(overflowM));
	flopenrc #(1) r9M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(pc_adelE),.cout(pc_adelM));
	flopenrc #(2) r10M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin({adelE,adesE}),.cout({adelM,adesM}));
	flopenrc #(1) r11M(.clk(clk),.rst(rst),.enable(~stallM),.clear(flushM),.cin(is_in_delayslot_iE),.cout(is_in_delayslot_iM));
	mux2 #(32) hiorlomux(.cin_a(loM), .cin_b(hiM), .sel(hiorlo_selM), .cout(hiorloM));
	mux2 #(32) forwardMmux(.cin_a(aluoutM),.cin_b(hiorloM),.sel(readhiloM),.cout(forwardDataM));
	mux2 #(32) bad_addr_imux(.cin_a(aluoutM),.cin_b(pcM),.sel(pc_adelM),.cout(bad_addr_iM));
	exception exce(.clk(~clk),.rst(rst),.except({pc_adelM,syscallM,breakM,eretM,reserveM,overflowM,2'b00}),.adel(adelM),.ades(adesM),.cp0_status(status_oM),.cp0_cause(cause_oM),.excepttype(excepttype_iM));
	//exception改为下降沿触发，在进入cp0之前就得出结果，但是cp0改为上升沿触发，与M到W阶段的触发器同时触发，但是cp0可能
	//要快�?点，�?以结果输出来之后，触发器再将它传送至W阶段�?
	cp0_reg cp0(.clk(clk),.rst(rst),.we_i(writecp0M),.waddr_i(rdM),.raddr_i(rdM),.data_i(srcb2M),.int_i(int_iM),.excepttype_i(excepttype_iM),.current_inst_addr_i(pcM),
				.is_in_delayslot_i(is_in_delayslot_iM),.bad_addr_i(bad_addr_iM),.data_o(readcp0dataM),.count_o(count_oM),.compare_o(compare_oM),.status_o(status_oM),.cause_o(cause_oM),
				.epc_o(epc_oM),.config_o(config_oM),.prid_o(prid_oM),.badvaddr(badvaddrM),.timer_int_o(timer_int_oM));
	//同理在异常时，也不能将异常的数据写入DM,DM是下降沿触发，与exception同时触发，所以可能有来不及，�?以直接使用异常信号判断�??
	assign ls_selM2 = ls_selM & ({4{ {pc_adelM,syscallM,breakM,eretM,reserveM,overflowM,adesM ,adelM}
								 == 8'b00000000} });

	//writeback stage
	floprc #(32) r1W(.clk(clk),.rst(rst),.clear(flushW),.cin(aluoutM),.cout(aluoutW));
	// flopr #(32) r2W(.clk(clk),.rst(rst),.cin(readdataM),.cout(readdataW0));
	flopr_readData r2W(.clk(clk),.rst(rst),.cin(readdataM),.cout(readdataW),.ls_sel(ls_selM),.load_usign(load_usignM));
	floprc #(5) r3W(.clk(clk),.rst(rst),.clear(flushW),.cin(writeregM),.cout(writeregW));
	floprc #(32) r4W(.clk(clk),.rst(rst),.clear(flushW),.cin(hiorloM),.cout(hiorloW));
	floprc #(32) r5W(.clk(clk),.rst(rst),.clear(flushW),.cin(pcM),.cout(pcW));
	floprc #(32) r6W(.clk(clk),.rst(rst),.clear(flushW),.cin(readcp0dataM),.cout(readcp0dataW));

	// mux5 #(32) readDatamux(.cin1({{24{readdataW0[7]}},readdataW0[7:0]}),.cin2({{24{1'b0}},readdataW0[7:0]}),
	// .cin3({{16{readdataW0[15]}},readdataW0[15:0]}),.cin4({{16{1'b0}},readdataW0[15:0]}),.cin5(readdataW0),.cout(readdataW),
	// .sel(load_selW));
	mux2 #(32) resmux(.cin_a(aluoutW),.cin_b(readdataW),.sel(memtoregW),.cout(resultW0));
	mux2 #(32) resmux2(.cin_a(resultW0),.cin_b(readcp0dataW),.sel(readcp0W),.cout(resultW1));
	mux2 #(32) res1mux(.cin_a(resultW1),.cin_b(hiorloW),.sel(readhiloW),.cout(resultW));

endmodule