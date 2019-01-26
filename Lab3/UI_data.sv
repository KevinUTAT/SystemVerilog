
module UI_data
(
	input clk,
	
	output logic [8:0] x0,
	output logic [7:0] y0,
	output logic [8:0] x1,
	output logic [7:0] y1,
	output logic [2:0] colour,
	
	
	input [8:0] VAL,
	
	// flags
	input assign_x,
	input assign_y,
	input assign_col,
	input done
);
initial x0 = 9'd0;
initial y0 = 8'd0;


always_ff @(posedge clk) begin

	if (assign_x)
		if (VAL < 9'd337) x1 <= VAL;
		else x1 <= 9'd336;
	
	if (assign_y)
		if (VAL < 9'd211) y1 <= VAL[7:0];
		else y1 <= 8'd210;
	
	if (assign_col)
	colour <= VAL[2:0];

	if (done) begin 
		x0 <= x1;
		y0 <= y1;
	end
	
end

/*
assign x1 = (assign_x) ? VAL : x1;
assign y1 = (assign_y) ? VAL : y1;
assign colour = (assign_col) ? VAL : colour;

// shift x1y1 to x0y0 when done ploting
assign x0 = (done) ? x1 : x0;
assign y0 = (done) ? y1 : y0;

*/


endmodule


