
module reg_file
(
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

always_comb begin
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
	else begin			  // write
		case (addr)
			3'b000:		R0 = data_in;
			3'b001:		R1 = data_in;
			3'b010:		R2 = data_in;
			3'b011:		R3 = data_in;
			3'b100:		R4 = data_in;
			3'b101:		R5 = data_in;
			3'b110:		R6 = data_in;
			3'b111:		R7 = data_in;
		endcase
	end
end

endmodule
			