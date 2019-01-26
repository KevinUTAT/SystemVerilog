// this is the control FSM of line_drawer

module line_drawer_control
(
	input clk,
	input start,
	// flags to data path
	input steep,
	input x0_greater_than_x1,
	input x0_greater_than_x1_steep,
	input for_loop_done,
	
	output logic rst_s,
	output logic check_steep_s,
	output logic check_x0x1_steep_s,
	output logic swap_xy_s,
	output logic swap_10_s,
	output logic set_var_s,
	output logic draw_s,
	output logic init_s,
	output logic error_s,
	output logic inc_s,
	output logic done
);

enum int unsigned
{
	reset,
	check_steep,
	branch,
	check_x0x1_steep,
	branch2,
	swap_xy,
	swap_10,
	set_var,
	init,
	draw_pixel,
	error,
	inc,
	done_pixel,
	done_state
} state, nextstate;

// state reg
always_ff@(posedge clk) begin
	state <= nextstate;
end

always_comb begin
	rst_s = 1'b0;
	check_steep_s = 1'b0;
	check_x0x1_steep_s = 1'b0;
	swap_xy_s = 1'b0;
	swap_10_s = 1'b0;
	set_var_s = 1'b0;
	init_s = 1'b0;
	draw_s = 1'b0;
	error_s = 1'b0;
	inc_s = 1'b0;
	done = 1'b0;
	
	case (state) 
		reset:		begin
						nextstate = (start) ? check_steep : reset;
						rst_s = 1'b1;
					end
					
		check_steep:begin
						nextstate = branch;
						check_steep_s = 1'b1;
					end
					
		branch		:begin
						if (steep == 1'b0) begin
							if (x0_greater_than_x1 == 1'b0) begin
								nextstate = set_var;
							end
							else nextstate = swap_10;
						end
						else nextstate = swap_xy;
					end
					
		
								
		swap_xy: 	begin
						nextstate = check_x0x1_steep;
						swap_xy_s = 1'b1;
					end
					
		check_x0x1_steep:	begin
								nextstate = branch2;
								check_x0x1_steep_s = 1'b1;
							end			
							
		branch2:	begin
						nextstate = (x0_greater_than_x1_steep) ? swap_10 : set_var;
					end
					
		swap_10: 	begin
						nextstate = set_var;
						swap_10_s = 1'b1;
					end
					
		set_var:	begin
						nextstate = init;
						set_var_s = 1'b1;
					end
					
		init:		begin
						nextstate = draw_pixel;
						init_s = 1'b1;
					end
					
		draw_pixel:	begin
						nextstate = error;
						draw_s = 1'b1;
					end
					
		error:		begin
						nextstate = inc;
						error_s = 1'b1;
					end
					
		inc: 		begin
						nextstate = done_pixel;
						inc_s = 1'b1;
					end
					
		done_pixel:	begin
						nextstate = (for_loop_done) ? done_state : draw_pixel;
					end
					
		done_state:	begin
						nextstate = reset;
						done = 1'b1;
					end
	endcase
end
endmodule		
					
		


							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							