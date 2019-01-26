
module mem4k_decoder
(
	input [15:0] mem_addr,
	input mem_wr,
	output [10:0] addr,
	output wr
);

assign wr = (mem_wr && (mem_addr[15:12] == 4'b0));
assign addr = mem_addr[12:1];

endmodule
