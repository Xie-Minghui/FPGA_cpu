`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:43:06
// Design Name: 
// Module Name: floprc
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


module floprc #(parameter WIDTH = 8)(
	input clk,rst,clear,
	input wire[WIDTH-1:0] cin,
	output reg[WIDTH-1:0] cout
    );
	always @(posedge clk) begin
		if (rst || clear) begin
			// reset
			cout <= 0;
		end
		else  begin
			cout <= cin;
		end
	end
endmodule
