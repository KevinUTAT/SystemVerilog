
module Avalon_Slave_Controller
(
	input clk,
	input reset,
	input [2:0] avs_s1_address, //address coming in
	input avs_s1_read,
	input avs_s1_write,
	input [31:0] avs_s1_writedata,
	
	output logic [31:0] avs_s1_readdata,
	output logic avs_s1_waitrequest,
	
	input ready,
	input done,
	output logic start,
	output logic [2:0] colour,
	output logic [8:0] x0,
	output logic [7:0] y0,
	output logic [8:0] x1,
	output logic [7:0] y1
);

logic mode; // mode = 1 => poll. mode = 0 => stall
logic status;// dont write to it
logic oldStatus = 1'b0;


//assign status = start == 1'b1; 
//assign status = ~done;
//initial start = 1'b0;
//assign avs_s1_readdata = {31'b0, status};
//assign avs_s1_readdata = (avs_s1_read && (avs_s1_address == 3'b001)) ? {31'b0, status} : 


assign avs_s1_waitrequest = (!mode && start) || (status && !mode);

assign status = (done) ? 1'b0 : (start) ? 1'b1 : oldStatus;

always_comb begin
	avs_s1_readdata = 32'b0;
	
	if (avs_s1_read) begin	// master says read from slave
		case(avs_s1_address)
			3'b000: avs_s1_readdata = {31'b0, mode};
			3'b001: avs_s1_readdata = {31'b0, status}; // master reads status
			3'b010: avs_s1_readdata = {31'b0, start};
			3'b011: avs_s1_readdata = {15'b0, y0, x0};
			3'b100: avs_s1_readdata = {15'b0, y1, x1};
			3'b101: avs_s1_readdata = {29'b0, colour};
			
		endcase 		
		
	end
	
	
end

assign start = (avs_s1_write && avs_s1_address == 3'b010 && !done) ? 1'b1 : 1'b0;

always_ff@(posedge clk) begin
	
	//if (start) status = 1'b1;
	//else if (done) status = 1'b0;
	
	
	//start = 1'b0;	
	/*
	if (avs_s1_read) begin	// master says read from slave
	
		case(avs_s1_address)
			3'b000: avs_s1_readdata <= {31'b0, mode};
			3'b001: avs_s1_readdata <= {31'b0, status}; // master reads status
			3'b010: avs_s1_readdata <= {31'b0, start};
			3'b011: avs_s1_readdata <= {15'b0, y0, x0};
			3'b100: avs_s1_readdata <= {15'b0, y1, x1};
			3'b101: avs_s1_readdata <= {29'b0, colour};
		endcase 		
		
	end
	*/
	
	
	if (avs_s1_write) begin //master says write to slave
	
		
		case(avs_s1_address)
			3'b000: mode = avs_s1_writedata[0];
			
			//3'b001: status <= avs_s1_writedata[0]; //?
		
			//3'b010: begin 
			//			start = 1'b1;
			//		  end
		
			3'b011: begin
						x0 = avs_s1_writedata[8:0];
						y0 = avs_s1_writedata[16:9];
					  end
				
			3'b100: begin
						x1 = avs_s1_writedata[8:0];
						y1 = avs_s1_writedata[16:9];
					  end
				
			3'b101: colour = avs_s1_writedata[2:0];
		endcase
	end
	/*
	if (status && !mode) 
		avs_s1_waitrequest = 1'b1;
	else
		avs_s1_waitrequest = 1'b0;
	*/
	oldStatus = status;
	
end

endmodule





