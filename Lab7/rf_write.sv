
module rf_write
(
	input clk,
	
	output logic [2:0] wr_addr,
	output logic wren,
	output reg [15:0] wrdata_in,
	
	output logic [15:0] Rx_val_stage4,
	
	input [15:0] ALU_out,
	input [15:0] x_val,
	input [15:0] y_val,
	
	input [15:0] i_ldst_rddata,
	
	input [15:0] IR,
	output logic set_flags,
	
	output logic [7:0][15:0] o_tb_regs,
	output logic [15:0] IRout,
	
	input [15:0] PC
);

wire [4:0] opcode;
assign opcode = IR[4:0];
wire [2:0] Rx;
assign Rx = IR[7:5];
wire [7:0] imm8;
assign imm8 = IR[15:8];
wire [10:0] imm11;
assign imm11 = IR[15:5];

assign IRout = IR;

assign Rx_val_stage4 = (opcode == 5'b00000) ? y_val :
						(opcode == 5'b00001 ||
						opcode == 5'b00010 ||
						opcode == 5'b10001 ||
						opcode == 5'b10010) ? ALU_out :
						(opcode == 5'b00100) ? i_ldst_rddata :
						(opcode == 5'b10000) ? imm8 :
						(opcode == 5'b10110) ? {imm8, x_val[7:0]} : 0;
						
//assign wrdata_in = (opcode == 5'b00001
	//				|| opcode == 5'b00010
		//			|| opcode == 5'b10001
			//		|| opcode == 5'b10010) ? ALU_out :
				//	(opcode[3:0] == 4'b1100) ? (PC - 16'd6) :
					//(opcode == 5'b00000) ? y_val :
	//				(opcode == 5'b00100) ?  i_ldst_rddata :
		//			(opcode == 5'b10000) ? $signed(imm8) :
			//		(opcode == 5'b10110) ? {imm8, x_val[7:0]} : 0;
					
 
always_ff@(posedge clk) begin

		wren = 1'b0;
		set_flags = 0;

		// mv add sub ld mvi addi subi mvhi
		if (opcode == 5'b00000 || opcode == 5'b00001
			|| opcode == 5'b00010 || opcode == 5'b00100
			|| opcode == 5'b10000 || opcode == 5'b10001
			|| opcode == 5'b10010 || opcode == 5'b10110) begin
			wr_addr = Rx;
			wren = 1;
		end
		
		// add sub addi subi
		if (opcode == 5'b00001
			|| opcode == 5'b00010
			|| opcode == 5'b10001
			|| opcode == 5'b10010) begin
			wrdata_in = ALU_out;
			o_tb_regs[Rx] = ALU_out;
		end
			
		// sub cmp subi cmpi
		if (opcode == 5'b00010
			|| opcode == 5'b00011
			|| opcode == 5'b10010
			|| opcode == 5'b10011) 
			set_flags = 1;
		
		// callr call
		if (opcode[3:0] == 4'b1100) begin
			wr_addr = 3'd7;
			wren = 1;
			wrdata_in = PC - 16'd6;
			o_tb_regs[7] = PC - 16'd6;
		end
		
		// mv
		if (opcode == 5'b00000) begin
			wrdata_in = y_val;
			o_tb_regs[Rx] = y_val;
			
		end
		
		// ld
		if (opcode == 5'b00100) begin
			//set_flags = 1;
			wrdata_in = i_ldst_rddata;
			o_tb_regs[Rx] = i_ldst_rddata;
		end
		
		// mvi
		if (opcode == 5'b10000) begin 
			wrdata_in = $signed(imm8);
			o_tb_regs[Rx] = $signed(imm8);
		end
		
		// mvhi
		if (opcode == 5'b10110) begin
			wrdata_in = {imm8, x_val[7:0]};
			o_tb_regs[Rx] = {imm8, x_val[7:0]};
		end
end

endmodule


