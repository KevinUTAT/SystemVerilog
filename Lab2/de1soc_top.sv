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
	// Design goes here
wire [7:0] numIn = SW[7:0];
wire clk = CLOCK_50;
wire enable = SW[9];

logic [7:0] numX;
logic [7:0] numY;

logic [15:0] out;

always@(posedge clk) begin
	if (enable) numX <= numIn;
	else numY <= numIn;
end

SignedArrayMultiplier SAM0
(
	.m(numX),
	.q(numY),
	.product(out)
);

// out put to HexDisplay
hex_decoder out0
	(
		.hex_digit(out[3:0]),
		.segments(HEX0)
	);
	
hex_decoder out1
	(
		.hex_digit(out[7:4]),
		.segments(HEX1)
	);
	
hex_decoder out2
	(
		.hex_digit(out[11:8]),
		.segments(HEX2)
	);
	
hex_decoder out3
	(
		.hex_digit(out[15:12]),
		.segments(HEX3)
	);
	
	assign HEX4 = '1;
	assign HEX5 = '1;
endmodule
	
	
	
	
	
	
	
	
