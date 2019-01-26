
module ALU
(
	input clk,
	input [15:0] in0,
	input [15:0] in1,
	input ALUop, // 0 is +, 1 is -
	
	output logic [15:0] result,
	output logic N,
	output logic Z
);

assign result = (ALUop) ? (in0 - in1) : (in0 + in1);
assign N = result[15];
assign Z = (result == 16'd0);

endmodule