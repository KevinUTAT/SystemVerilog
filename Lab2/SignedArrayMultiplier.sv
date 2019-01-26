// this is a system verilog module for a 8x8 signed array multiplier
// aka a booth multiplier

module SignedArrayMultiplier
(
	input [7:0] m,
	input [7:0] q,
	
	output [15:0] product
);
logic [8:0] q_in;
assign q_in[0] = 1'b0;
assign q_in[8:1] = q[7:0];

// 2D array to store partial product between rows
logic [16:0] p_in[8:0] ; // each row is a partial product that goes into the next row multiplier
assign p_in[0] = 17'b0;

genvar j;
genvar k;
genvar l;
generate
// For loop to create 8 row multipliers to form a array multiplier
	for (j = 0; j < 8; j ++) begin : rowCreator
		SAM_row #
		(
			.rowIndex(j)
		)
		SAM_row_inst
		(
			.qjm1(q_in[j]),
			.qj(q_in[j+1]),
			.m(m),
			.pin_ext(p_in[j]),
			.pout_ext(p_in[j+1])
		);
	end
	
// for loop to extract final answer
	for (k = 0; k < 8; k++) begin : answerExtractor
		assign product[k] = p_in[k+1][0];
	end
	
	// assign the last 8-bit of answer
	for (l = 0; l < 8; l++) begin : AE2
		assign product[l+8] = p_in[8][l+1];
	end
endgenerate
endmodule 


module SAM_row #
(
	parameter rowIndex			// indicating the # of the current row
)
(
	input qjm1,             // qj-1
	input qj,				// qj
	input [7:0] m,			// m
	input [16:0] pin_ext,	// 8-bit partial product coming in with sign extension or carry down
	output [16:0] pout_ext	// resulting 8-bit partial product with carry down or extension 
);
wire Bplus;
wire Bminus;
// first booth encode m
BoothEncoderCell BEC
(
	.Qj(qj),
	.Qjm1(qjm1),
	.plusj(Bplus),
	.minusj(Bminus)
);

// here we crate a row multiplier and a row sign extender to calculate partial product
logic [16:0] carry;
assign carry[0] = Bminus;
logic [7:0] sign_ext;
genvar i;
genvar j;
generate 
	// 8-bit row multiplier
	for (i = 0; i < 8; i ++) begin : rowMultiplier
		MultiplierCell MC_inst
		(
			.M(m[i]),
			.Qplus(Bplus),
			.Qminus(Bminus),
			.Pin(pin_ext[i+1]),
			.Cin(carry[i]),
			.signExt(sign_ext[i]),
			.Cout(carry[i+1]),
			.Pout(pout_ext[i])
		);
	end
	
	// sign extender and carry down
	for (j = 8; j < (16 - rowIndex); j ++) begin : signExtender
		FullAdder SE_inst
		(
			.A(pin_ext[j+1]),
			.B(sign_ext[7]),
			.carry_in(carry[j]),
			.S(pout_ext[j]),
			.carry_out(carry[j+1])
		);
	end
	// assign the very last bit of our final answer if this SAM_row is the last row
//	if (rowIndex == 7) begin : answerLastBit
//		assign pout_ext[8] = carry[8];
//	end
endgenerate


//always@(*) begin
//	if (rowIndix == 7) pout_ext[8] <= carry[8];
//	else pout_ext[15] <= 1'b0;
//end
endmodule














