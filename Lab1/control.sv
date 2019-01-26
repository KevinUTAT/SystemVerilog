module control
(
	input clk,
	input reset,
	
	// Button input
	input i_enter,
	
	// Datapath
	output logic o_inc_actual,
	input i_over,
	input i_under,
	input i_equal,
	
	// LED Control: Setting this to 1 will copy the current
	// values of over/under/equal to the 3 LEDs. Setting this to 0
	// will cause the LEDs to hold their current values.
	output logic o_update_leds,
	//output the attempts
	output logic [7:0] attempt,
	output logic dead
);

// counter to count how many attempts of guess has been made	
initial attempt = 8'd0; // counter start at 0

reg [3:0]resetSig = 2'd0;  // signal to increment attempt

// count every enter input
always@(posedge clk) begin
	
	if (resetSig == 2'd1)
	begin
		attempt = attempt + 8'd1;
		end
		
	else if (resetSig == 2'd2)
		attempt = 8'd0;
	
end

// Declare two objects, 'state' and 'nextstate'
// that are of enum type.
enum int unsigned
{
	rst,
	wait_1,
	numGen,
	wait_enter_1,
	compare,
	under,
	equal,
	over,
	wait_2,
	wait_enter_2,
	die
} state, nextstate;

// Clocked always block for making state registers
always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		state = rst; // TODO: choose initial reset sta
		end
	
	else state <= nextstate;
end

// always_comb replaces always @* and gives compile-time errors instead of warnings
// if you accidentally infer a latch
always_comb begin
	// Set default values for signals here, to avoid having to explicitly
	// set a value for every possible control path through this always block
	nextstate = state;
	o_inc_actual = 1'b0;
	o_update_leds = 1'b0;
	dead = 1'b0;
	resetSig = 1'b0;
	
	case (state)
		rst: begin
				nextstate = wait_1;
				o_inc_actual = 1'b1;
				resetSig = 2'd2;
				//attempt = 8'd0;
			 end
			 
		wait_1: begin
				nextstate = (i_enter) ? numGen : wait_1;
				o_inc_actual = 1'b1;
				end
				
		numGen: begin
				nextstate = wait_enter_1;
				o_inc_actual = 1'b0;
				end
				
		wait_enter_1: begin
					nextstate = (i_enter) ? wait_enter_1 : compare;
					end		
				
		compare: begin
				if (i_under) nextstate = under;
				else if (i_over) nextstate = over;
				else if (i_equal) nextstate = equal;
				else nextstate = rst;
				resetSig = 2'd1;
				 end
				 
		under: 	begin
				nextstate = wait_2;
				o_update_leds = 1'b1;
				end
				
		over:  	begin
				nextstate = wait_2;
				o_update_leds = 1'b1;
				end
				
		equal: 	begin
				nextstate = equal;
				o_update_leds = 1'b1;
				end
				
		wait_2: begin
				if (attempt < 8'd7)  begin 
					
					nextstate = (i_enter) ? wait_enter_2 : wait_2;
					end
					
				else nextstate = die;
				end
				
		wait_enter_2: begin
					nextstate = (i_enter) ? wait_enter_2 : compare;
					
					end
				
		die: begin
				nextstate = (reset) ? rst : die;
				dead = 1'b1;
			 end
	endcase
end

endmodule
