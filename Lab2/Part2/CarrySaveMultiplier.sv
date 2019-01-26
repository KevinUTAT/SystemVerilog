
module CarrySaveMultiplier
(
	input [7:0] M,
	input [7:0] Q,
	output [15:0] product
);

logic [7:0] carry[8:0];
assign carry[0] = 8'b0;

logic [7:0] partial[8:0];
assign partial[0] = 8'b0;

logic [8:0] fa_cin;
assign fa_cin[0] = 1'b0;

genvar j;
genvar k;
genvar l;
generate
	// generate 8 Row multipliers
	for (j = 0; j < 8; j ++) begin : multiplier
		CSA_row CSA_inst
		(
			.carry_in(carry[j]),
			.p_in(partial[j]),
			.Bi(Q[j]),
			.A(M[7:0]),
			.carry_out(carry[j+1]),
			.p_out(partial[j+1])
		);
	end
	
	// extract first 8 bit 
	for (l = 0; l < 8; l ++) begin : extractor
		assign product[l] = partial[l+1][0];
	end
	
	// ripple merge adder for last 8bit
	for (k = 0; k < 7; k ++) begin : fastAdder
		FullAdder fastA_inst
		(
			.A(carry[8][k]),
			.B(partial[8][k+1]),
			.carry_in(fa_cin[k]),
			.S(product[k+8]),
			.carry_out(fa_cin[k+1])
		);
	end
	FullAdder fastA_last		// last bit
		(
			.A(carry[8][7]),
			.B(1'b0),
			.carry_in(fa_cin[7]),
			.S(product[15]),
			.carry_out(fa_cin[8])
		);
endgenerate
endmodule


module CSA_row
(
	input [7:0] carry_in,
	input [7:0] p_in,
	input Bi,
	input [7:0] A,
	
	output [7:0] carry_out,
	output [7:0] p_out
);

logic [8:0] partialIn;
assign partialIn[8] = 1'b0;
assign partialIn[7:0] = p_in[7:0];

genvar i;
generate
	for (i = 0; i < 8; i++) begin : rowMultiplier
		FullAdder FA_inst
			(
				.A(partialIn[i+1]),
				.B(Bi&A[i]),
				.carry_in(carry_in[i]),
				.S(p_out[i]),
				.carry_out(carry_out[i])
			);
	end
endgenerate
endmodule