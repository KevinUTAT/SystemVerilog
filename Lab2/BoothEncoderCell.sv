// this is the module of a booth encoder cell 
// Qj is the input bit to be encode
// Qjm1 is Q(j-1) as the last bit to Qj

module BoothEncoderCell
(
	input Qj,
	input Qjm1,
	
	output plusj,
	output minusj
);

assign plusj = Qjm1 & (~Qj);
assign minusj = Qj & (~Qjm1);

endmodule


