 
 module LEDR_decoder
 (
	input mem_wr,
	input [15:0] mem_addr,
	output LEDR_en
 );
 
 assign LEDR_en = (mem_wr && (mem_addr[15:12] == 4'd3));
 
 endmodule
 