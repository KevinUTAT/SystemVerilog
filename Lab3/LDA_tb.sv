`timescale 1ns/1ns

module LDA_tb();
// Generates a 50MHz clock.
logic clk;
initial clk = 1'b0;     // Clock starts at 0
always #10 clk = ~clk;  // Wait 10ns, flip the clock, repeat forever

// "input" to the system
logic start;
logic [8:0] x0_in;
logic [7:0] y0_in;
logic [8:0] x1_in;
logic [7:0] y1_in;
logic [2:0] colour_in;
// "output" of the system
logic [8:0] x_out;
logic [7:0] y_out;
logic [2:0] colour_out;
logic plot;
logic done = 1'b0;

wire steep;
wire x0_greater_than_x1;
wire x0_greater_than_x1_steep;
wire for_loop_done;
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
	.clk(clk),
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
	.clk(clk),
	.start(start),
	.x0(x0_in),
	.y0(y0_in),
	.x1(x1_in),
	.y1(y1_in),
	.colour_in(colour_in),
	.x_out(x_out),
	.y_out(y_out),
	.plot(plot),
	.colour_out(colour_out),
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

vga_bmp vga_bmp_inst
(
	.clk(clk),
	.x(x_out),
	.y(y_out),
	.color(colour_out),
	.plot(plot)
);

// assuming we are drawing in a 16 x 16 screen
initial begin

	x0_in = 0;
	y0_in = 0;
	x1_in = 20;
	y1_in = 15;
	colour_in = 3'b110;
	start = 1;
	#3000
	/*
	for (integer i = 0; i < 100; i ++) begin
		#30;
		$display("draw:[%d] [%d], plot=%d", x_out, y_out, plot);
	end
	*/
	x0_in = 20;
	y0_in = 15;
	x1_in = 15;
	y1_in = 30;
	colour_in = 3'b110;
	start = 1;
	#3000

	/*
	for (integer j = 0; j < 100; j ++) begin
		#30;
		$display("draw:[%d] [%d], plot=%d", x_out, y_out, plot);
	end
	*/
	vga_bmp_inst.write_bmp();
	
	$stop();
	
end
endmodule
	
	




















