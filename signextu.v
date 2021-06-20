`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/11 20:49:25
// Design Name: 
// Module Name: signextu
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


module signextu(cin,cout);
input [15:0] cin;
output[31:0] cout;
assign cout = {{16{1'b0}},cin}; 
endmodule
