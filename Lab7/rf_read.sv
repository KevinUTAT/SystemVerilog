
module rf_read
(
	input clk,
	
	input Rx_select,
	input Ry_select,
	input [2:0] Rx_stage4,
	
	output logic Rx_select2,
	output logic Ry_select2,
	
	input [15:0] i_pc_rddata,
	
	output logic [15:0] IR,
	
	output logic [2:0]Rx_addr,
	output logic [2:0]Ry_addr,
	
	input wren,
	input branch_s
);

logic [2:0] Rx;
logic [2:0] Ry;

always_ff@(posedge clk) begin
		
	IR = (branch_s) ? 16'b0 : i_pc_rddata;
	
	Rx = IR[7:5];
	Ry = IR[10:8];
	
	Rx_select2 = ((Rx == Rx_stage4) && wren);
	Ry_select2 = ((Ry == Rx_stage4) && wren);
		
	Rx_addr = Rx;
	Ry_addr = Ry;
		
	//Rx_addr = (Rx_select) ? Rx_stage4 : Rx;
	//Ry_addr = (Ry_select) ? Ry_stage4 : Ry;
	
end

endmodule
