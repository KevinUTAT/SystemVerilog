// this is a test bench for 1 bit Multiplier module

`timescale 1ns/1ns

module MC_tb();
// Generates a 50MHz clock.
logic clk;
initial clk = 1'b0;     // Clock starts at 0
always #10 clk = ~clk;  // Wait 10ns, flip the clock, repeat forever

logic p_in;
logic plusj;
logic minusj;
logic c_in;
logic Mi;

logic sign_ext;
logic c_out;
logic p_out;

MultiplierCell MC0
(
	.M(Mi),
	.Qplus(plusj),
	.Qminus(minusj),
	.Pin(p_in),
	.Cin(c_in),
	.signExt(sign_ext),
	.Cout(c_out),
	.Pout(p_out)
);

initial begin

	Mi = 1'b1;
	p_in = 1'b0;
	plusj = 1'b0;
	minusj = 1'b0;
	c_in = 1'b0;
	#5;

	$stop();
end
endmodule 
	
	
	
	
	