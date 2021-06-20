`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 15:35:09
// Design Name: 
// Module Name: mux5
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

module mux5 #(parameter WIDTH = 32)(
input  wire[WIDTH-1:0] cin1,cin2,cin3,cin4,cin5,
input wire[2:0] sel,
output wire[WIDTH-1:0] cout
    );
    assign cout = (sel == 3'b000) ? cin1:
                (sel == 3'b001) ? cin2:
                (sel == 3'b010) ? cin3:
                (sel == 3'b011) ? cin4: cin5;
endmodule
