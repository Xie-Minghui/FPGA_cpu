`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 12:09:59
// Design Name: 
// Module Name: mux2
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


module mux2#(parameter WIDTH = 32)(cin_a,cin_b,sel,cout);
input [WIDTH-1:0] cin_a,cin_b;
input sel;
output wire [WIDTH-1:0] cout;

assign cout = sel == 0 ? cin_a : cin_b;
 
endmodule
