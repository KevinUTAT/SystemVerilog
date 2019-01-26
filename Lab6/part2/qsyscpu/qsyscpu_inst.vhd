	component qsyscpu is
		port (
			clk_clk                        : in  std_logic                    := 'X';             -- clk
			led_external_connection_export : out std_logic_vector(9 downto 0);                    -- export
			quad_hex_decode_0_hex0_export  : out std_logic_vector(6 downto 0);                    -- export
			quad_hex_decode_0_hex1_export  : out std_logic_vector(6 downto 0);                    -- export
			quad_hex_decode_0_hex2_export  : out std_logic_vector(6 downto 0);                    -- export
			quad_hex_decode_0_hex3_export  : out std_logic_vector(6 downto 0);                    -- export
			reset_reset_n                  : in  std_logic                    := 'X';             -- reset_n
			sw_external_connection_export  : in  std_logic_vector(9 downto 0) := (others => 'X')  -- export
		);
	end component qsyscpu;

	u0 : component qsyscpu
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			led_external_connection_export => CONNECTED_TO_led_external_connection_export, -- led_external_connection.export
			quad_hex_decode_0_hex0_export  => CONNECTED_TO_quad_hex_decode_0_hex0_export,  --  quad_hex_decode_0_hex0.export
			quad_hex_decode_0_hex1_export  => CONNECTED_TO_quad_hex_decode_0_hex1_export,  --  quad_hex_decode_0_hex1.export
			quad_hex_decode_0_hex2_export  => CONNECTED_TO_quad_hex_decode_0_hex2_export,  --  quad_hex_decode_0_hex2.export
			quad_hex_decode_0_hex3_export  => CONNECTED_TO_quad_hex_decode_0_hex3_export,  --  quad_hex_decode_0_hex3.export
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			sw_external_connection_export  => CONNECTED_TO_sw_external_connection_export   --  sw_external_connection.export
		);

