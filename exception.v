`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/17 11:27:32
// Design Name: 
// Module Name: exception
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

module exception(
    input wire rst,clk,
    input wire [7:0] except,
    input wire adel,ades,
    input wire [31:0] cp0_status,cp0_cause,
    output reg [31:0] excepttype
    );
    always @(posedge clk)begin
        if(rst) begin
            excepttype<= 0;
        end
        else begin
            excepttype<= 0;
            if ( ((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00) &&//ÖÐ¶Ï
                   (cp0_status[1] == 1'b0 ) && (cp0_status[0]==1'b1) ) begin
                excepttype <= 32'h0000_0001;
            end
            else if (except[7]==1'b1 || adel) begin//AdEL(¶ÁµØÖ·´í)
                excepttype <= 32'h0000_0004;
            end
            else if (ades) begin//AdES(Ð´µØÖ·´í)
                excepttype <= 32'h0000_0005;
            end
            else if (except[6]==1'b1) begin //syscall
                excepttype <= 32'h0000_0008;
            end else if (except[5]==1'b1) begin//break
                excepttype <= 32'h0000_0009;
            end
            else if (except[4]==1'b1) begin//eret
                excepttype <= 32'h0000_000e;
            end
            else if (except[3]==1'b1) begin//reserve
                excepttype <= 32'h0000_000a;
            end
            else if (except[2]==1'b1) begin//overflow
                excepttype <= 32'h0000_000c;
            end
        end
    end

endmodule
