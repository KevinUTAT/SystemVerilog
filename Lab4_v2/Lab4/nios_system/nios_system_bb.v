
module nios_system (
	clk_clk,
	lda_component_0_vga_b_export,
	lda_component_0_vga_blank_n_export,
	lda_component_0_vga_clk_export,
	lda_component_0_vga_g_export,
	lda_component_0_vga_hs_export,
	lda_component_0_vga_r_export,
	lda_component_0_vga_sync_n_export,
	lda_component_0_vga_vs_export,
	leds_export,
	reset_reset_n,
	switches_export);	

	input		clk_clk;
	output	[7:0]	lda_component_0_vga_b_export;
	output		lda_component_0_vga_blank_n_export;
	output		lda_component_0_vga_clk_export;
	output	[7:0]	lda_component_0_vga_g_export;
	output		lda_component_0_vga_hs_export;
	output	[7:0]	lda_component_0_vga_r_export;
	output		lda_component_0_vga_sync_n_export;
	output		lda_component_0_vga_vs_export;
	output	[7:0]	leds_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
endmodule
