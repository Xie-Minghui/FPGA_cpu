`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 21:11:31
// Design Name: 
// Module Name: hazard
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


module hazard(
	//fetch stage
	output wire stallF,//out
	output wire flushF,
	//decode stage
	input wire[4:0] rsD,rtD,//in
	input wire branchD,//in
	output wire forwardaD,forwardbD,//out
	output wire stallD,//out
	input wire jrD,
	output wire flushD,
	//execute stage
	input wire[4:0] rsE,rtE,//in
	input wire[4:0] writeregE,//in
	input wire regwriteE,//.in
	input wire memtoregE,//in
	input wire stall_divE,
	output wire[1:0] forwardaE,forwardbE,//out
	output wire flushE,//out
	output wire stallE,
	input wire readcp0E,
	//mem stage
	input wire [4:0]writeregM,//in
	input wire regwriteM,//in
	input wire memtoregM,//in
	input wire readcp0M,
	input wire[31:0] excepttypeM,
	output wire flushM,
	output reg[31:0] except_pc,
	input wire[31:0] epc_oM,
	output wire stallM,
	//write back stage
	input wire [4:0] writeregW,//in
	input wire regwriteW,//in
	output wire flushW,
	//memory request stall
	input wire	stallreq_from_if,
	input wire	stallreq_from_mem
    );
wire brachstall,lwstall,jrstall;
wire flush_except;
assign flush_except = (excepttypeM != 0);
assign flushF = flush_except;
assign flushD = flush_except;
assign flushM = flush_except;
assign flushW = flush_except || stallreq_from_mem;

assign forwardaD = (rsD != 0) && (rsD == writeregM) && regwriteM;
assign forwardbD = (rtD != 0) && (rtD == writeregM) && regwriteM;

assign lwstall = ((rsD == rtE) || (rtD == rtE)) && (memtoregE | readcp0E);

assign brachstall = (branchD && regwriteE && (writeregE == rsD || writeregE == rtD))
					|| (branchD && (memtoregM | readcp0M) && (writeregM == rsD || writeregM == rtD));
assign jrstall = (jrD && regwriteE && (writeregE == rsD))
					|| (jrD && (memtoregM | readcp0M) && (writeregM == rsD));
assign stallF = lwstall || brachstall || stall_divE || jrstall || stallreq_from_if || stallreq_from_mem;
assign stallD = lwstall || brachstall || stall_divE || jrstall || stallreq_from_if || stallreq_from_mem;
assign flushE =  stall_divE ? 0 : (lwstall || brachstall || jrstall || flush_except || stallreq_from_if);
assign stallE = stall_divE || stallreq_from_mem;
assign stallM = stallreq_from_mem;
assign forwardaE = ((rsE != 0) && (rsE == writeregM) && regwriteM) ? 2'b10 :
					((rsE != 0) && (rsE == writeregW) && regwriteW) ? 2'b01 :
					2'b00;

assign forwardbE = ((rtE != 0) && (rtE == writeregM) && regwriteM) ? 2'b10 :
					((rtE != 0) && (rtE == writeregW) && regwriteW) ? 2'b01 :
					2'b00;

always @(*)begin
	if(excepttypeM != 0)begin
		case(excepttypeM)
			32'h00000001:begin
				except_pc <= 32'hBFC00380;
			end
			32'h00000004:begin
				except_pc <= 32'hBFC00380;
			end
			32'h00000005:begin
				except_pc <= 32'hBFC00380;
			end
			32'h00000008:begin
				except_pc <= 32'hBFC00380;
			end
			32'h00000009:begin
				except_pc <= 32'hBFC00380;
			end
			32'h0000000a:begin
				except_pc <= 32'hBFC00380;
			end
			32'h0000000c:begin
				except_pc <= 32'hBFC00380;
			end
			32'h0000000d:begin
				except_pc <= 32'hBFC00380;
			end
			32'h0000000e:begin
				except_pc <= epc_oM;
			end
			default:;
		endcase
	end
end
endmodule
