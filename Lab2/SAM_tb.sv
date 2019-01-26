// this is a system verilog test bench for a signed array multiplier module

`timescale 1ns/1ns

module SAM_tb();
// Generates a 50MHz clock.
logic clk;
initial clk = 1'b0;     // Clock starts at 0
always #10 clk = ~clk;  // Wait 10ns, flip the clock, repeat forever

// M x Q = P
logic [7:0] M;
logic [7:0] Q;
logic [15:0] P;

SignedArrayMultiplier SAM0
(
	.m(M),
	.q(Q),
	.product(P)
);

initial begin
	for (integer i = -127; i < 128; i ++) begin
		for (integer j = -127; j < 128; j ++) begin
			logic [15:0] realProduct;
			realProduct = i * j;
			
			M = i[7:0];
			Q = j[7:0];
			#5;
			
			if (P !== realProduct) begin
				$display("Error at %d * %d should be %d but got %d !!",
					i, j, realProduct, P);
				$stop();
			end
		end
	end
	
	$display("Pass!!!!!!!!!!!!");
	$stop();
end
endmodule
			
			
			
			
			
			
			
