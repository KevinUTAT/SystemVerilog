// this is a system verilog module of a full adder
// A + B = S

module FullAdder
(
	input A,
	input B,
	input carry_in,
	
	output S,
	output carry_out
);

assign S = A ^ B ^ carry_in;
assign carry_out = (A & B) | (A & carry_in) | (B & carry_in); // AB + AC + BC

endmodule
