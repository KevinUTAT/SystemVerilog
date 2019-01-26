
module reg_file
(
	input clk,
	input [2:0] addr,
	input rd_wr,     // 0 is resd, 1 is write
	input [15:0] data_in,
	output logic [15:0] data_out
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
assign input_buf = data_in;

//wire [15:0] data_temp;

assign data_out = (addr == 3'b000) ? R0 :
					(addr == 3'b001) ? R1 :
					(addr == 3'b010) ? R2 :
					(addr == 3'b011) ? R3 :
					(addr == 3'b100) ? R4 :
					(addr == 3'b101) ? R5 :
					(addr == 3'b110) ? R6 : R7;

always_ff@(posedge clk) begin
/*
	if (!rd_wr) begin  // read
		case (addr)
			3'b000:		data_out = R0;
			3'b001:		data_out = R1;
			3'b010:		data_out = R2;
			3'b011:		data_out = R3;
			3'b100:		data_out = R4;
			3'b101:		data_out = R5;
			3'b110:		data_out = R6;
			3'b111:		data_out = R7;
		endcase
	end
	*/
	if (rd_wr) begin			  // write
		case (addr)
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
			