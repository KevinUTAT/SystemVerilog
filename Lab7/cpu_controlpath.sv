
module cpu_controlpath
(
	input clk,
	input reset,
	
	output logic rst_s,
	output logic fetch_s,
	output logic rfread_s,
	output logic execute_s,
	output logic rfwrite_s
);

enum int unsigned
{
	Rst,
	Fetch,
	RFRead,
	Execute,
	RFWrite
} state, nextstate;

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		state <= Rst;
		end
	else state <= nextstate;
end


always_comb begin
	nextstate = state;
	rst_s = 1'b0;
	fetch_s = 1'b0;
	rfread_s = 1'b0;
	execute_s = 1'b0;
	rfwrite_s = 1'b0;
	
	
	case (state)
	
		Rst:		begin
						rst_s = 1'b1;
						nextstate = Fetch;
					end
					
		Fetch:		begin
						fetch_s = 1'b1;
						nextstate = RFRead;
					end
					
		RFRead:		begin
						rfread_s = 1'b1;
						nextstate = Execute;
					end
					
		Execute:	begin
						execute_s =1'b1;
						nextstate = RFWrite;
					end
					
		RFWrite:	begin
						rfwrite_s = 1'b1;
						nextstate = Fetch;
					end
					
		default:		nextstate = state;
	endcase
end
endmodule

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
