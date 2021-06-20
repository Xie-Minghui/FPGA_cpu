`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 17:32:19
// Design Name: 
// Module Name: flopr_readData
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


module flopr_readData #(parameter WIDTH = 32)(
	input wire clk,rst,
	input wire[WIDTH-1:0] cin,
	input wire[3:0] ls_sel,
	input wire load_usign,
	output reg[WIDTH-1:0] cout
    );
	always @(posedge clk) begin
		if (rst) begin
			// reset
			cout <= 0;
		end
		else begin
			case(ls_sel)
			    4'b0001:
					case(load_usign)
						1'b0:
							cout <= {{24{cin[7]}},cin[7:0]};
						1'b1:
							cout <= {{24{1'b0}},cin[7:0]};
					endcase
				4'b0010:
					case(load_usign)
						1'b0:
							cout <= {{24{cin[15]}},cin[15:8]};
						1'b1:
							cout <= {{{24{1'b0}},cin[15:8]}};
					endcase
				4'b0100:
					case(load_usign)
						1'b0:
							cout <= {{24{cin[23]}},cin[23:16]};
						1'b1:
							cout <= {{24{1'b0}},cin[23:16]};
					endcase
				4'b1000:
					case(load_usign)
						1'b0:
							cout <= {{24{cin[31]}},cin[31:24]};
						1'b1:
							cout <= {{24{1'b0}},cin[31:24]};
					endcase
				4'b0011:
					case(load_usign)
						1'b0:
							cout <= {{16{cin[15]}},cin[15:0]};
						1'b1:
							cout <= {{16{1'b0}},cin[15:0]};
					endcase
				4'b1100:
					case(load_usign)
						1'b0:
							cout <= {{16{cin[31]}},cin[31:16]};
						1'b1:
							cout <= {{16{1'b0}},cin[31:16]};
					endcase
				4'b1111:
					cout <= cin;
			    default:
				    cout <= 0;
			endcase
		end
	end
endmodule

