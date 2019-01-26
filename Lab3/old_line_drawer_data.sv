// this is the data path of line drawer
// the this module use vga_bmp to draw line 

module line_drawer_data
(
	input clk,
	// interface to UI
	input start,
	input [8:0] x0,
	input [7:0] y0,
	input [8:0] x1,
	input [7:0] y1,
	input [2:0] colour_in, // the right way
	
	// interface to data path
	output logic [8:0] x_out,
	output logic [7:0] y_out,
	output logic plot,
	output logic [2:0] colour_out,
	
	input draw
);
logic [8:0] abs_y = (y1 > y0) ? (y1 - y0) : (y0 - y1); //abs(y1-y0)
logic [8:0] abs_x = (x1 > x0) ? (x1 - x0) : (x0 - x1); //abs(x1-x0) 
// preprocessing inputs
logic [8:0] x0_fake_temp;
logic [8:0] y0_fake_temp;
logic [8:0] x1_fake_temp;
logic [8:0] y1_fake_temp;

initial x0_fake_temp = 9'd0;
initial y0_fake_temp = 9'd0;
initial x1_fake_temp = 9'd0;
initial y1_fake_temp = 9'd0;

logic [8:0] x0_fake = 9'd0;
logic [8:0] y0_fake = 9'd0;
logic [8:0] x1_fake = 9'd0;
logic [8:0] y1_fake = 9'd0;

logic steep = abs_y > abs_x;

assign x0_fake_temp = (steep) ? y0 : x0;		// if (steep) {
assign y0_fake_temp = (steep) ? x0 : y0;		//     swap(x0,y0);
												//     swap(x1,y1);
assign x1_fake_temp = (steep) ? y1 : x1;		// }
assign y1_fake_temp = (steep) ? x1 : y1;

logic zeroGreaterThanOne = x0 > x1;

assign x0_fake = (zeroGreaterThanOne) ? x1_fake_temp : x0_fake_temp; // if (x0 > x1) {
assign x1_fake = (zeroGreaterThanOne) ? x0_fake_temp : x1_fake_temp; //     swap(x0,x1);
																	 //     swap(y0,y1);
assign y0_fake = (zeroGreaterThanOne) ? y1_fake_temp : y0_fake_temp; // }
assign y1_fake = (zeroGreaterThanOne) ? y0_fake_temp : y1_fake_temp;

// setup local variable
// we have to assign delta_x and delta_y
logic [8:0] delta_x = x1_fake - x0_fake;
logic [8:0] delta_y = (y1_fake > y0_fake) ? (y1_fake - y0_fake) : (y0_fake - y1_fake); //abs(y1_fake - y0_fake)
logic [8:0] error = - (delta_x >> 1);
logic [8:0] y = y0_fake;
logic [8:0] x = x0_fake;

logic [8:0] ystep = (y0_fake < y1_fake) ? 9'b1 : 9'b111111111;

// here is the block that will draw one pixel
always_ff @ (posedge draw) begin
	if (steep == 1'b1) begin
		x_out <= y;
		y_out <= x;
		colour_out <= colour_in;
		plot <= 1'b1;
	end
	else begin
		x_out <= x;
		y_out <= y;
		colour_out <= colour_in;
		plot <= 1'b1;
	end
	
	error <= error + delta_y;
	if (error > 1) begin
		y = y + ystep;
		error = error - delta_x;
	end
	
	x <= x + 1; // x ++
end
endmodule


















