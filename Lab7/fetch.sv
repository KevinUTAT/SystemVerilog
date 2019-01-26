
module fetch
(
	input reset,
	input clk,
	
	output logic [15:0] o_pc_addr,
	output logic o_pc_rd,
	
	input [15:0] PC,
	output logic [15:0] PC_out
);


always_ff@(posedge clk) begin

	if (reset) PC_out = 16'b0;
	
	else begin
		o_pc_addr = PC;
		o_pc_rd = 1;
		PC_out = PC + 16'd2;
	end
end

endmodule
