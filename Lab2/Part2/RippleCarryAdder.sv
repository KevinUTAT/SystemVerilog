
// A x B = sum
module RippleCarryAdder
(
	input [7:0] A,
	input [7:0] B,
	output [8:0] sum
);
logic [8:0] carry;

assign carry[0] = 1'b0;
assign sum[8] = carry[8];

genvar i;
generate
	for (i = 0; i < 8; i ++) begin : adder8
		FullAdder FA_inst
		(
			.A(A),
			.B(B),
			.carry_in(carry[i]),
			.S(sum),
			.carry_out(carry[i+1])
		);
	end
endgenerate
endmodule