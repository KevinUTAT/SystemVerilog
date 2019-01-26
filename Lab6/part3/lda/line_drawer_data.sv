
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
	
	// interface to vga
	output logic [8:0] x_out,
	output logic [7:0] y_out,
	output logic plot,
	output logic [2:0] colour_out,
	
	// control flags
	input rst_s,
	input check_steep_s,
	input check_x0x1_steep_s,
	input swap_xy_s,
	input swap_10_s,
	input set_var_s,
	input draw_s,
	input init_s,
	input error_s,
	input inc_s,
	
	output logic steep,
	output logic x0_greater_than_x1,
	output logic x0_greater_than_x1_steep,
	output logic for_loop_done
);

// we calculate the value of steep here
logic [7:0] abs_dy;
logic [8:0] abs_dx;
always_ff@(posedge clk) begin
	if (check_steep_s) begin
		abs_dx = ($signed(x1-x0) >= 0) ? (x1-x0) : (x0-x1);
		abs_dy = ($signed(y1-y0) >= 0) ? (y1-y0) : (y0-y1);
		steep = abs_dy > abs_dx;
		x0_greater_than_x1 = x0 > x1;
	/*
		if (y1 > y0) begin
			if (x1 > x0) begin
				if ((y1-y0) > (x1-x0)) steep <= 1'b1;
				else steep <= 1'b0;
			end
			else begin
				if ((y1-y0) > (x0-x1)) steep <= 1'b1;
				else steep <= 1'b0;
			end
		end
		else begin
			if (x1 > x0) begin
				if ((y0-y1) > (x1-x0)) steep <= 1'b1;
				else steep <= 1'b0;
			end
			else begin
				if ((y0-y1) > (x0-x1)) steep <= 1'b1;
				else steep <= 1'b0;
			end
		end
		*/
	end
end

logic [8:0] x0_internal;
logic [8:0] x1_internal;
logic [8:0] y0_internal;
logic [8:0] y1_internal;

//initial x0_internal[8:0] = x0[8:0];
//initial x1_internal[8:0] = x1[8:0];
//initial y0_internal[7:0] = y0[7:0];
//initial y1_internal[7:0] = y1[7:0];
//initial y0_internal[8] = 0;
//initial y0_internal[8] = 0;

logic swaped_xy;
logic swaped_10;

always_ff@(posedge clk) begin

	if (swap_xy_s) begin
		x0_internal = y0;		// swap(x0, y0)
		y0_internal = x0;
		
		x1_internal = y1;		// swap(x1, y1)
		y1_internal = x1;
		
		swaped_xy = 1;
	end
	
	else if (swap_10_s) begin
		if (swaped_xy) begin
			x0_internal <= x1_internal;
			x1_internal <= x0_internal;
		
			y0_internal <= y1_internal;
			y1_internal <= y0_internal;
		end
		else begin
			x0_internal <= x1;
			x1_internal <= x0;
		
			y0_internal <= y1;
			y1_internal <= y0;
		end
		swaped_10 = 1;
	end
	
	else if (check_x0x1_steep_s) begin
		x0_greater_than_x1_steep = x0_internal > x1_internal;
	end
	
	else if (rst_s) begin
		swaped_xy = 0;
		swaped_10 = 0;
	end
	
	if ((!swaped_xy) && (!swaped_10)) begin
		x0_internal[8:0] = x0[8:0];
		x1_internal[8:0] = x1[8:0];
		y0_internal[7:0] = y0[7:0];
		y1_internal[7:0] = y1[7:0];
		y0_internal[8] = 0;
		y1_internal[8] = 0;
	end
end
/*
// swapping x and y
always_ff@(posedge swap_xy_s) begin
		x0_internal <= y0;		// swap(x0, y0)
		y0_internal <= x0;
	
		x1_internal <= y1;		// swap(x1, y1)
		y1_internal <= x1;
end

// swapping 1 and 0
assign x0_greater_than_x1 = x0 > x1;
always_ff@(posedge swap_10_s) begin
	x0_internal <= x1;		// swap(x0, x1)
	x1_internal <= x0;
	
	y0_internal <= y1;		// swap(y0, y1)
	y1_internal <= y0;
end
*/

// set up local variables
logic [8:0] delta_x;
logic [8:0] delta_y;
logic signed [8:0] error;
logic [8:0] x;
logic [8:0] y;
logic signed [8:0] y_step;
always_ff@(posedge clk) begin
	if (set_var_s) begin
		delta_x = x1_internal - x0_internal;
	
		// abs(y1 - y0)
		if (y1_internal > y0_internal) begin 
			delta_y = y1_internal - y0_internal;
		end
		else delta_y = y0_internal - y1_internal;
	
		if (y0_internal < y1_internal) y_step = 9'd1;
		else y_step = 9'b111111111; // -1
	end
end

// for loop:
// initialize x, y or increment them
//initial for_loop_done = 1'b0;
assign for_loop_done = (x > x1_internal);
always_ff@(posedge clk) begin
	// check for end of for loop
	//if ((x >= x1_internal)) begin
	//	for_loop_done = 1'b1;
	//end
	
	// draw_pixel
	if (draw_s) begin
		if (steep) begin
			x_out = y;
			y_out = x;
			colour_out = colour_in;
			plot = 1'b1;
		end
		else begin
			x_out = x;
			y_out = y;
			colour_out = colour_in;
			plot = 1'b1;
		end
		//for_loop_done = 1'b0;
	end
	
	// initialize x and y also error
	else if (init_s) begin
		error <= -1 * (delta_x >> 1);
		error[8] = 1;
		x <= x0_internal;
		y <= y0_internal;
		plot <= 1'b1;
		//for_loop_done = 1'b0;
	end
	
	// incrementing error
	else if (error_s) begin
		error <= error + delta_y;
		plot <= 1'b0;
		//for_loop_done <= 1'b0;
	end
	
	// incrementing x y and error
	else if(inc_s) begin
		plot = 1'b0;
		x = x + 9'b1;
		//for_loop_done <= 1'b0;
		
		if (error > 0) begin 
			y = y + y_step;
			error = error - delta_x;
		end
	end
	
	else if (rst_s) begin
		plot = 1'b0;
//		error = 9'b0;
//		x = 9'b0;
//		y = 9'b0;
		//for_loop_done = 1'b0;
	end
end


/*
initial x = x0_internal;
initial y = y0_internal;
assign for_loop_done = x == x1_internal;

always_ff@(posedge draw_s) begin
	if (steep == 1'b1) begin
		x_out = y;
		y_out = x;
		colour_out = colour_in;
		plot = 1'b1;
	end
	else begin
		x_out = x;
		y_out = y;
		colour_out = colour_in;
		plot = 1'b1;
	end
	
	error = error + delta_y;
	
	if (error > 0) begin
		y <= y + y_step;
		error = error -delta_x;
	end
	x <= x + 9'b1;
end
*/
endmodule 
		
		
		
		
		
		
		
		
