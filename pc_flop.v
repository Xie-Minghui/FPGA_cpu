`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/18 14:03:38
// Design Name: 
// Module Name: pc_flop
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


module pc_flop  #(parameter WIDTH = 32)(
	input clk,rst,clear,enable,
	input wire[WIDTH-1:0] cin,
	input wire[WIDTH-1:0] except_pc,
	output reg[WIDTH-1:0] cout
    );
	always @(posedge clk) begin
		if (rst) begin
			// reset
			cout <= 32'hbfc00000;
		end 
		else if (clear)begin
		        cout <= except_pc;
		end
		else if (enable) begin
			    cout <= cin;
		end
	end
endmodule
