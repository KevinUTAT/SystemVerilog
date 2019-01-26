	component nios_system is
		port (
			clk_clk                                  : in  std_logic                    := 'X';             -- clk
			leds_export                              : out std_logic_vector(7 downto 0);                    -- export
			reset_reset_n                            : in  std_logic                    := 'X';             -- reset_n
			switches_export                          : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			top_level_component_0_vga_clk_export     : out std_logic;                                       -- export
			top_level_component_0_vga_g_export       : out std_logic_vector(7 downto 0);                    -- export
			top_level_component_0_vga_hs_export      : out std_logic;                                       -- export
			top_level_component_0_vga_r_export       : out std_logic_vector(7 downto 0);                    -- export
			top_level_component_0_vga_sync_n_export  : out std_logic;                                       -- export
			top_level_component_0_vga_vs_export      : out std_logic;                                       -- export
			top_level_component_0_vga_blank_n_export : out std_logic;                                       -- export
			top_level_component_0_vga_b_export       : out std_logic_vector(7 downto 0)                     -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                                  => CONNECTED_TO_clk_clk,                                  --                               clk.clk
			leds_export                              => CONNECTED_TO_leds_export,                              --                              leds.export
			reset_reset_n                            => CONNECTED_TO_reset_reset_n,                            --                             reset.reset_n
			switches_export                          => CONNECTED_TO_switches_export,                          --                          switches.export
			top_level_component_0_vga_clk_export     => CONNECTED_TO_top_level_component_0_vga_clk_export,     --     top_level_component_0_vga_clk.export
			top_level_component_0_vga_g_export       => CONNECTED_TO_top_level_component_0_vga_g_export,       --       top_level_component_0_vga_g.export
			top_level_component_0_vga_hs_export      => CONNECTED_TO_top_level_component_0_vga_hs_export,      --      top_level_component_0_vga_hs.export
			top_level_component_0_vga_r_export       => CONNECTED_TO_top_level_component_0_vga_r_export,       --       top_level_component_0_vga_r.export
			top_level_component_0_vga_sync_n_export  => CONNECTED_TO_top_level_component_0_vga_sync_n_export,  --  top_level_component_0_vga_sync_n.export
			top_level_component_0_vga_vs_export      => CONNECTED_TO_top_level_component_0_vga_vs_export,      --      top_level_component_0_vga_vs.export
			top_level_component_0_vga_blank_n_export => CONNECTED_TO_top_level_component_0_vga_blank_n_export, -- top_level_component_0_vga_blank_n.export
			top_level_component_0_vga_b_export       => CONNECTED_TO_top_level_component_0_vga_b_export        --       top_level_component_0_vga_b.export
		);

