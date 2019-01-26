
module SW_or_mem
(
	input clk,
	input [15:0] mem_addr,
	output reg SW_or_mem_s
);
//assign SW_or_mem_s = ~(mem_addr[15:12] == 4'd2);

always_ff@ (posedge clk) begin
	if (mem_addr[15:12] == 4'd2) SW_or_mem_s <= 1'b0;
	else SW_or_mem_s <= 1'b1;
end

endmodule
