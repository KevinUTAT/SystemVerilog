
`timescale 1ns/1ns

module CSM_tb();
// M x Q = P
logic [7:0] M;
logic [7:0] Q;
logic [15:0] P;

CarrySaveMultiplier CSM0
(
	.M(M),
	.Q(Q),
	.product(P)
);

initial begin
	integer errorcount = 0;
	for (integer i = 0; i < 256; i ++) begin
		for (integer j = 0; j < 256; j ++) begin
			logic [15:0] realProduct;
			realProduct = i * j;
			
			M = i[7:0];
			Q = j[7:0];
			#5;
			
			if (P !== realProduct) begin
				$display("Error at %d * %d should be %d but got %d !!",
					i, j, realProduct, P);
					errorcount = errorcount + 1;
//				$stop();
			end
		end
	end
	
	$display("=======================================================================");
	$display("Ran 65536 test cases, %d pass, %d fail.", (65536-errorcount), errorcount);
	$display("=======================================================================");
	$stop();
end
endmodule