
module LDA_circuit
(

	input clk,
	
	output done,
	
	input start,
	input [2:0] colour,
	input [8:0] x0,
	input [7:0] y0,
	input [8:0] x1,
	input [7:0] y1,
	
	output [8:0] x_out,
	output [7:0] y_out,
	output plot,
	output [2:0] colour_out,
	output ready
);

assign ready = rst_s;

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

line_drawer_control LDAC
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



line_drawer_data LDAD
(
	.clk(clk),
	.start(start),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.colour_in(colour),
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


endmodule












