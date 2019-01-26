
module reg_file
(
	input clk,
	input reset,
	input [2:0] Rx_addr,
	input [2:0] Ry_addr,
	input [2:0] wr_addr,
	input wren,				// write enable
	input [15:0] wrdata_in,
	output logic [15:0] Rx_out,
	output logic [15:0] Ry_out
);
reg [15:0] R0;
reg [15:0] R1;
reg [15:0] R2;
reg [15:0] R3;
reg [15:0] R4;
reg [15:0] R5; 
reg [15:0] R6;
reg [15:0] R7;

reg [15:0] input_buf;
assign input_buf = wrdata_in;
reg [15:0] wr_addr_buf;
assign wr_addr_buf = wr_addr;


// read
assign Rx_out = (Rx_addr == 3'b000) ? R0 :
					(Rx_addr == 3'b001) ? R1 :
					(Rx_addr == 3'b010) ? R2 :
					(Rx_addr == 3'b011) ? R3 :
					(Rx_addr == 3'b100) ? R4 :
					(Rx_addr == 3'b101) ? R5 :
					(Rx_addr == 3'b110) ? R6 : R7;
					
assign Ry_out = (Ry_addr == 3'b000) ? R0 :
					(Ry_addr == 3'b001) ? R1 :
					(Ry_addr == 3'b010) ? R2 :
					(Ry_addr == 3'b011) ? R3 :
					(Ry_addr == 3'b100) ? R4 :
					(Ry_addr == 3'b101) ? R5 :
					(Ry_addr == 3'b110) ? R6 : R7;

// write
always_ff@(posedge clk) begin
	if (wren) begin			  // write
		case (wr_addr_buf)
			3'b000:		R0 = input_buf;
			3'b001:		R1 = input_buf;
			3'b010:		R2 = input_buf;
			3'b011:		R3 = input_buf;
			3'b100:		R4 = input_buf;
			3'b101:		R5 = input_buf;
			3'b110:		R6 = input_buf;
			3'b111:		R7 = input_buf;
		endcase
	end
end

endmodule
			