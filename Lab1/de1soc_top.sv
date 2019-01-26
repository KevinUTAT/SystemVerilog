module de1soc_top 
(
	// These are the board inputs/outputs required for all the ECE342 labs.
	// Each lab can use the subset it needs -- unused pins will be ignored.
	
    // Clock pins
    input                     CLOCK_50,

    // Seven Segment Displays
    output      [6:0]         HEX0,
    output      [6:0]         HEX1,
    output      [6:0]         HEX2,
    output      [6:0]         HEX3,
    output      [6:0]         HEX4,
    output      [6:0]         HEX5,

    // Pushbuttons
    input       [3:0]         KEY,

    // LEDs
    output      [9:0]         LEDR,

    // Slider Switches
    input       [9:0]         SW,

    // VGA
    output      [7:0]         VGA_B,
    output                    VGA_BLANK_N,
    output                    VGA_CLK,
    output      [7:0]         VGA_G,
    output                    VGA_HS,
    output      [7:0]         VGA_R,
    output                    VGA_SYNC_N,
    output                    VGA_VS
);
	// Clock signal
	wire clk = CLOCK_50;
	
	// KEYs are active low, invert them here
	wire reset = ~KEY[0];
	wire enter = ~KEY[1];
	
	// Number guess input
	wire [7:0] guess = SW[7:0];
	
	//attempt counter
	wire [7:0] attemptCount;
	
	// Datapath
	logic dp_inc_actual;
	logic dp_over;
	logic dp_under;
	logic dp_equal;
	datapath the_datapath
	(
		.clk(clk),
		.reset(reset),
		.i_guess(guess),
		.i_inc_actual(dp_inc_actual),
		.o_over(dp_over),
		.o_under(dp_under),
		.o_equal(dp_equal),
		.db_actual(result)
	);
	
	// State Machine
	logic ctrl_update_leds;
	control the_control
	(
		.clk(clk),
		.reset(reset),
		.i_enter(enter),
		.o_inc_actual(dp_inc_actual),
		.i_over(dp_over),
		.i_under(dp_under),
		.i_equal(dp_equal),
		.o_update_leds(ctrl_update_leds),
		.attempt(attemptCount),
		.dead(LEDR[1])
	);
	
	// control path debugging part
	wire [7:0] result;
	// debugging end
	
	// LED controllers
	led_ctrl ledc_under(clk, reset, dp_under, ctrl_update_leds, LEDR[9]);
	led_ctrl ledc_over(clk, reset, dp_over, ctrl_update_leds, LEDR[0]);
	led_ctrl ledc_equal(clk, reset, dp_equal, ctrl_update_leds, LEDR[4]);
	
	// Hex Decoders ---------
	hex_decoder hexdec_guess0
	(
		.hex_digit(guess[3:0]),
		.segments(HEX0)
	);
	
	hex_decoder hexdec_guess1
	(
		.hex_digit(guess[7:4]),
		.segments(HEX1)
	);
	//----------------------
	hex_decoder hexdec_attempt0
	(
		.hex_digit(attemptCount[3:0]),
		.segments(HEX2)
	);
	
	hex_decoder hexdec_attempt1
	(
		.hex_digit(attemptCount[7:4]),
		.segments(HEX3)
	);
	
	// debugging stuff
	wire cheat = SW[9];
	wire [6:0] HEX4_temp;
	wire [6:0] HEX5_temp;
	
	hex_decoder db_hex0
	(
		.hex_digit(result[3:0]),
		.segments(HEX4_temp)
	);
	
	hex_decoder db_hex1
	(
		.hex_digit(result[7:4]),
		.segments(HEX5_temp)
	);
	// debugging end
	
	// Turn off the other HEXes
//	assign HEX2 = '1;
//	assign HEX3 = '1;
	assign HEX4 = (cheat) ? HEX4_temp : '1;
	assign HEX5 = (cheat) ? HEX5_temp : '1;
	
endmodule