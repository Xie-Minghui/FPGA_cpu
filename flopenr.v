`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 19:23:07
// Design Name: 
// Module Name: flopenr
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


module flopenr#(parameter WIDTH = 32)(
input wire clk,rst,enable,
input wire[WIDTH-1:0] cin,
output reg[WIDTH-1:0] cout
    );

always @(posedge clk) begin
	if (rst) begin
		// reset
		cout <= 0;
	end
	else if (enable) begin
		cout <= cin;
	end
end
endmodule
