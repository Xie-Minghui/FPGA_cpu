`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/12 16:56:33
// Design Name: 
// Module Name: div_controller
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

`include"defines.vh"
module div_controller(op, start_div, signed_div);
input wire [7:0] op;
// input wire div_ready;
output reg start_div, signed_div;
always @(*) begin
    case(op)
        `EXE_DIV_OP:begin
            // case(div_ready)
            //     1'b0: begin
                    start_div <= 1'b1;
                    signed_div <= 1'b1;
                    // stall_div <= 1'b1;
                // end
                // 1'b1:begin
                //     start_div <= 1'b0;
                //     signed_div <= 1'b1;
                //     // stall_div <= 1'b0;
                // end
            //     default: begin
            //         start_div <= 1'b0;
            //         signed_div <= 1'b0;
            //         // stall_div <= 1'b0;
            //     end
            // endcase
        end
        `EXE_DIVU_OP:begin
            // case(div_ready)
            //     1'b0: begin
                    start_div <= 1'b1;
                    signed_div <= 1'b0;
                    // stall_div <= 1'b1;
                // end
                // 1'b1:begin
                //     start_div <= 1'b0;
                //     signed_div <= 1'b0;
                //     // stall_div <= 1'b0;
                // end
            //      default: begin
            //         start_div <= 1'b0;
            //         signed_div <= 1'b0;
            //         // stall_div <= 1'b0;
            //     end
            // endcase
        end
        default: begin
           start_div <= 1'b0;
           signed_div <= 1'b0;
        //    stall_div <= 1'b0;
        end
    endcase
end

endmodule
