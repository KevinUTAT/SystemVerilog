// this is the testbench system verilog file
// for testing the module BoothEncoderCell

`timescale 1ns/1ns

module BEC_tb();

// Generates a 50MHz clock.
logic clk;
initial clk = 1'b0;     // Clock starts at 0
always #10 clk = ~clk;  // Wait 10ns, flip the clock, repeat forever

logic in_bit;   // input bit (Qj)
logic in_bit_prev;   // previous bit of in_bit (Qjm1)

logic plus;
logic minus;

// created a BEC to test
BoothEncoderCell BEC0
(
	.Qj(in_bit),
	.Qjm1(in_bit_prev),
	.plusj(plus),
	.minusj(minus)
);

initial begin
	in_bit = 1'b0;
	in_bit_prev = 1'b0;
	@(posedge clk)
	
	in_bit = 1'b0;
	in_bit_prev = 1'b1;
	@(posedge clk)
	
	in_bit = 1'b1;
	in_bit_prev = 1'b0;
	@(posedge clk)
	
	in_bit = 1'b1;
	in_bit_prev = 1'b1;
	@(posedge clk)
	
	$display("Simulation finish.");
	$stop();
	
end
endmodule 

