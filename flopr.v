`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:39:20
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter WIDTH = 8)(
	input wire clk,rst,
	input wire[WIDTH-1:0] cin,
	output reg[WIDTH-1:0] cout
    );
	always @(posedge clk) begin
		if (rst) begin
			// reset
			cout <= 0;
		end
		else begin
			cout <= cin;
		end
	end
endmodule
