	component nios_system is
		port (
			clk_clk                            : in  std_logic                    := 'X';             -- clk
			lda_component_0_vga_b_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_component_0_vga_blank_n_export : out std_logic;                                       -- export
			lda_component_0_vga_clk_export     : out std_logic;                                       -- export
			lda_component_0_vga_g_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_component_0_vga_hs_export      : out std_logic;                                       -- export
			lda_component_0_vga_r_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_component_0_vga_sync_n_export  : out std_logic;                                       -- export
			lda_component_0_vga_vs_export      : out std_logic;                                       -- export
			leds_export                        : out std_logic_vector(7 downto 0);                    -- export
			reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
			switches_export                    : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                         clk.clk
			lda_component_0_vga_b_export       => CONNECTED_TO_lda_component_0_vga_b_export,       --       lda_component_0_vga_b.export
			lda_component_0_vga_blank_n_export => CONNECTED_TO_lda_component_0_vga_blank_n_export, -- lda_component_0_vga_blank_n.export
			lda_component_0_vga_clk_export     => CONNECTED_TO_lda_component_0_vga_clk_export,     --     lda_component_0_vga_clk.export
			lda_component_0_vga_g_export       => CONNECTED_TO_lda_component_0_vga_g_export,       --       lda_component_0_vga_g.export
			lda_component_0_vga_hs_export      => CONNECTED_TO_lda_component_0_vga_hs_export,      --      lda_component_0_vga_hs.export
			lda_component_0_vga_r_export       => CONNECTED_TO_lda_component_0_vga_r_export,       --       lda_component_0_vga_r.export
			lda_component_0_vga_sync_n_export  => CONNECTED_TO_lda_component_0_vga_sync_n_export,  --  lda_component_0_vga_sync_n.export
			lda_component_0_vga_vs_export      => CONNECTED_TO_lda_component_0_vga_vs_export,      --      lda_component_0_vga_vs.export
			leds_export                        => CONNECTED_TO_leds_export,                        --                        leds.export
			reset_reset_n                      => CONNECTED_TO_reset_reset_n,                      --                       reset.reset_n
			switches_export                    => CONNECTED_TO_switches_export                     --                    switches.export
		);

