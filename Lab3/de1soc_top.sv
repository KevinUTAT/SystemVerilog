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

// VGA adapter and signals
logic [8:0] vga_x;
logic [7:0] vga_y;
logic [2:0] vga_color;
logic vga_plot;

vga_adapter #
(
	.BITS_PER_CHANNEL(1)
)
vga_inst
(
	.CLOCK_50(CLOCK_50),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_CLK(VGA_CLK),
	.x(vga_x),
	.y(vga_y),
	.color(vga_color),
	.plot(vga_plot)
);

// This generates a one-time active-high asynchronous reset
// signal on powerup. You can use it if you need it.
// All the KEY inputs are occupied, so we can't use one as a reset.
logic reset;
logic [1:0] reset_reg;
always_ff @ (posedge CLOCK_50) begin
	reset <= ~reset_reg[0];
	reset_reg <= {1'b1, reset_reg[1]};
end

//
// PUT YOUR UI AND LDA MODULE INSTANTIATIONS HERE
//

wire assign_x;
wire assign_y;
wire assign_col;

wire [8:0] x0;
wire [7:0] y0;
wire [8:0] x1;
wire [7:0] y1;
wire [2:0] colour;

wire start;
wire done;

UI_control UIC
(
	.clk(CLOCK_50),
	.setX(~KEY[0]),
	.setY(~KEY[1]),
	.setCol(~KEY[2]),
	.GO(~KEY[3]),
	.assign_x(assign_x),
	.assign_y(assign_y),
	.assign_col(assign_col),
	.done(done),
	.start(start)
);

UI_data UID
(
	.clk(CLOCK_50),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.colour(colour),
	
	
	.VAL(SW[8:0]),
	
	// flags
	.assign_x(assign_x),
	.assign_y(assign_y),
	.assign_col(assign_col),
	.done(done)
);

wire steep;
wire x0_greater_than_x1;
wire x0_greater_than_x1_steep;
wire for_loop_done;
assign LEDR[0] = for_loop_done;
wire rst_s;
wire check_steep_s;
wire check_x0x1_steep_s;
wire swap_xy_s;
wire swap_10_s;
wire set_var_s;
wire draw_s;
wire init_s;
wire error_s;
wire inc_s;

line_drawer_control LDA_C
(
	.clk(CLOCK_50),
	.start(start),
	.steep(steep),
	.x0_greater_than_x1(x0_greater_than_x1),
	.x0_greater_than_x1_steep(x0_greater_than_x1_steep),
	.for_loop_done(for_loop_done),
	
	.rst_s(rst_s),
	.check_steep_s(check_steep_s),
	.check_x0x1_steep_s(check_x0x1_steep_s),
	.swap_xy_s(swap_xy_s),
	.swap_10_s(swap_10_s),
	.set_var_s(set_var_s),
	.draw_s(draw_s),
	.init_s(init_s),
	.error_s(error_s),
	.inc_s(inc_s),
	.done(done)
);

line_drawer_data LDA_D
(
	.clk(CLOCK_50),
	.start(start),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.colour_in(colour), // the right way
	
	// interface to vga
	.x_out(vga_x),
	.y_out(vga_y),
	.plot(vga_plot),
	.colour_out(vga_color),
	
	// control flags
	.rst_s(rst_s),
	.check_steep_s(check_steep_s),
	.check_x0x1_steep_s(check_x0x1_steep_s),
	.swap_xy_s(swap_xy_s),
	.swap_10_s(swap_10_s),
	.set_var_s(set_var_s),
	.draw_s(draw_s),
	.init_s(init_s),
	.error_s(error_s),
	.inc_s(inc_s),
	
	.steep(steep),
	.x0_greater_than_x1(x0_greater_than_x1),
	.x0_greater_than_x1_steep(x0_greater_than_x1_steep),
	.for_loop_done(for_loop_done)
);

wire [8:0] hex_var0 = (SW[9]) ? x0 : x1;
wire [7:0] hex_var1 = (SW[9]) ? y0 : y1;

hex_decoder hex0
(
	.hex_digit(hex_var0[3:0]),
	.segments(HEX0)
);

hex_decoder hex1
(
	.hex_digit(hex_var0[7:4]),
	.segments(HEX1)
);

hex_decoder hex2
(
	.hex_digit(hex_var0[8]),
	.segments(HEX2)
);

hex_decoder hex3
(
	.hex_digit(hex_var1[3:0]),
	.segments(HEX3)
);

hex_decoder hex4
(
	.hex_digit(hex_var1[7:4]),
	.segments(HEX4)
);

// dbugging code here


endmodule