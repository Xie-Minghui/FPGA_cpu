`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 16:36:48
// Design Name: 
// Module Name: mux3
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


module mux3#(parameter WIDTH = 32)(cin_a,cin_b,cin_c,cout,sel);
input [WIDTH-1:0] cin_a,cin_b,cin_c;
input [1:0] sel;
output [WIDTH-1:0] cout;

assign cout = (sel == 2'b00) ? cin_a :
			 (sel == 2'b01) ? cin_b :
			 (sel == 2'b10) ? cin_c : cin_a;
endmodule