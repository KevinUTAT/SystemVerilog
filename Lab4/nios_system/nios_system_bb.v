
module nios_system (
	clk_clk,
	leds_export,
	reset_reset_n,
	switches_export,
	top_level_component_0_vga_clk_export,
	top_level_component_0_vga_g_export,
	top_level_component_0_vga_hs_export,
	top_level_component_0_vga_r_export,
	top_level_component_0_vga_sync_n_export,
	top_level_component_0_vga_vs_export,
	top_level_component_0_vga_blank_n_export,
	top_level_component_0_vga_b_export);	

	input		clk_clk;
	output	[7:0]	leds_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output		top_level_component_0_vga_clk_export;
	output	[7:0]	top_level_component_0_vga_g_export;
	output		top_level_component_0_vga_hs_export;
	output	[7:0]	top_level_component_0_vga_r_export;
	output		top_level_component_0_vga_sync_n_export;
	output		top_level_component_0_vga_vs_export;
	output		top_level_component_0_vga_blank_n_export;
	output	[7:0]	top_level_component_0_vga_b_export;
endmodule
