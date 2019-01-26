// this is a system verilog module of a 1 bit multiplier cell
// M x Q = P

module MultiplierCell
(
	input M,
	input Qplus,
	input Qminus,
	input Pin,
	input Cin,
	
	output signExt,
	output Cout,
	output Pout
);

// this wire is the result going into the FA
wire Mout;

assign Mout = (M & Qplus) | ((~M) & Qminus);
assign signExt = Mout;

FullAdder FA0
(
	.A(Pin),
	.B(Mout),
	.carry_in(Cin),
	.S(Pout),
	.carry_out(Cout)
);
endmodule



