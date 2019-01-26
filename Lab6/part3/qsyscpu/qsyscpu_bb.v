
module qsyscpu (
	clk_clk,
	led_external_connection_export,
	quad_hex_decode_0_hex0_export,
	quad_hex_decode_0_hex1_export,
	quad_hex_decode_0_hex2_export,
	quad_hex_decode_0_hex3_export,
	reset_reset_n,
	sw_external_connection_export);	

	input		clk_clk;
	output	[9:0]	led_external_connection_export;
	output	[6:0]	quad_hex_decode_0_hex0_export;
	output	[6:0]	quad_hex_decode_0_hex1_export;
	output	[6:0]	quad_hex_decode_0_hex2_export;
	output	[6:0]	quad_hex_decode_0_hex3_export;
	input		reset_reset_n;
	input	[9:0]	sw_external_connection_export;
endmodule
