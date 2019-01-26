// this is the control path of User interface
// this controls Line_drawer as one module

module UI_control
(
	input clk,
	// interface to the DE1-Soc board
	input setX,
	input setY,
	input setCol,
	input GO,
	
	// flags to data path
	output logic assign_x,
	output logic assign_y,
	output logic assign_col,
//	output logic realy_done,
	
	//interface to the line_drswer
	input done,
	
	output logic start
);

enum int unsigned
{
	reset,
	wait_x,
	key_wait_x,
	wait_y,
	key_wait_y,
	wait_colour,
	key_wait_colour,
	wait_GO,
	lets_GO
} state, nextstate;

// clocked always block for making state reg
always_ff@(posedge clk) begin
	state <= nextstate;
end


always_comb begin
	assign_x = 1'b0;
	assign_y = 1'b0;
	assign_col = 1'b0;
//	realy_done = 1'b0;
	start = 1'b0;
	nextstate = state;
	
	case (state) 
		reset:		begin
							nextstate = wait_x;
						end
					
		wait_x:		begin
							nextstate = (setX) ? key_wait_x : wait_x;
						end
					
		key_wait_x:	begin
							nextstate = (setX) ? key_wait_x : wait_y;
							assign_x = 1'b1;
						end
					
		wait_y: 		begin
							nextstate = (setY) ? key_wait_y : wait_y;
						end
						
		key_wait_y:	begin
							nextstate = (setY) ? key_wait_y : wait_colour;
							assign_y = 1'b1;
						end
						
		wait_colour:begin
							nextstate = (setCol) ? key_wait_colour : wait_colour;
						end
						
		key_wait_colour:	begin
									nextstate = (setCol) ? key_wait_colour : wait_GO;
									assign_col = 1'b1;
								end
		wait_GO:		begin
							nextstate = (GO) ? lets_GO : wait_GO;
						end
						
		lets_GO:		begin
							nextstate = (done) ? wait_x : lets_GO;
							start = 1'b1;
						end
	endcase
end
endmodule
		
	

