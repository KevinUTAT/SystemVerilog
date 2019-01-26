
module execute
(
	input clk,
	input [15:0] PC,
	output logic [15:0] PC_jump,
	input N,
	input Z,
	
	input Rx_select,
	input Ry_select,
	input [15:0] Rx_stage4,
	input [15:0] Ry_stage4,
	
	input Rx_select2,
	input Ry_select2,
	input [15:0] Rx_stage4_before,
	input ld_stage4,

	input [15:0] Rx_out,
	input [15:0] Ry_out,
	
	input [15:0] IR,
	output logic [15:0] x_val,
	output logic [15:0] y_val,
	
	output logic [15:0] IR_out,
	
	output logic [15:0] ALU_in0,
	output logic [15:0] ALU_in1,
	output logic ALUop,
	
	output logic [15:0] o_ldst_addr,
	output logic o_ldst_rd,
	output logic o_ldst_wr,
	output logic [15:0] o_ldst_wrdata,
	input [15:0] i_ldst_rddata,
	
	output logic branch_s
);

logic [4:0] opcode;
logic [7:0] imm8;
logic [10:0] imm11;

always_ff@(posedge clk) begin

		o_ldst_rd = 1'b0;
		o_ldst_wr = 1'b0;
		
		IR_out = (branch_s) ? 16'b0 : IR;
		branch_s = 1'b0;
		opcode = IR_out[4:0];
		imm8 = IR_out[15:8];
		imm11 = IR_out[15:5];
	
		if (ld_stage4) y_val = (Ry_select) ? i_ldst_rddata :
				(Ry_select2) ? i_ldst_rddata : Ry_out;
		else y_val = (Ry_select) ? Ry_stage4 :
				(Ry_select2) ? Rx_stage4_before : Ry_out;
		
		// if NOT j jz jn call
		if (~(opcode[4:3] == 2'b11)) begin
			if (ld_stage4) x_val = (Rx_select) ? i_ldst_rddata :
				(Rx_select2) ? i_ldst_rddata : Rx_out;
			else x_val = (Rx_select) ? Rx_stage4 :
				(Rx_select2) ? Rx_stage4_before : Rx_out;
		end
		
		
		// if j jz jn call
		if (opcode[4:3] == 2'b11) begin
			x_val = (PC - 16'd4) + $signed($signed(imm11)*2);
		end
		
		// add sub cmp, addi subi cmpi
		if (opcode == 5'b00001 || opcode == 5'b00010 
			|| opcode == 5'b00011 || opcode == 5'b10001
			|| opcode == 5'b10010 || opcode == 5'b10011)
			//ALU_in0 <= x_val;
			ALU_in0 = ((Rx_select) ? Rx_stage4 : 
				(Rx_select2) ? Rx_stage4_before  : x_val);
			
		// add sub cmp
		if (opcode == 5'b00001 || opcode == 5'b00010 
			|| opcode == 5'b00011) 
			//ALU_in1 = y_val;
			ALU_in1 = (Ry_select) ? Ry_stage4 : 
				(Ry_select2) ? Rx_stage4_before : y_val;
			
		// addi subi cmpi
		if (opcode == 5'b10001
			|| opcode == 5'b10010 || opcode == 5'b10011)
			ALU_in1 = $signed(imm8);
			
		if (opcode[3:0] == 4'b0001) ALUop = 1'b0;
		
		if (opcode[3:0] == 4'b0010 || opcode[3:0] == 4'b0011)
			ALUop = 1'b1;
			
		//ld st
		if (opcode == 5'b00100 || opcode == 5'b00101)
			//o_ldst_addr = y_val;
			o_ldst_addr = (ld_stage4 && Ry_select) ? i_ldst_rddata : y_val;
			
			
		// ld
		if (opcode == 5'b00100) o_ldst_rd = 1'b1;
		
		// st
		if (opcode == 5'b00101) begin
			o_ldst_wr = 1'b1;
			o_ldst_wrdata = x_val;
		end
		
		// jr
		if (opcode == 5'b01000) PC_jump = x_val;
		
		// jzr
		if ((opcode == 5'b01001) && (Z == 1'b1)) begin
			PC_jump = x_val;
		end
		
		// jnr
		if ((opcode == 5'b01010) && (N == 1'b1)) begin
			PC_jump = x_val;
		end
		
		// callr
		if (opcode == 5'b01100) PC_jump = x_val;
		
		// j jz jn call
		if (Z && opcode == 5'b11001) PC_jump = x_val; // jz
		if (N && opcode == 5'b11010) PC_jump = x_val; // jn
		if (opcode == 5'b11000 || opcode == 5'b11100) 
				PC_jump = x_val; // j call
		
		// branch_s logics
		if (opcode[3:0] == 4'b1000 || opcode[3:0] == 4'b1100) begin
			branch_s = 1'b1;
		end
		
		if (opcode[3:0] == 4'b1001 && Z == 1'b1) begin
			branch_s = 1'b1;
		end
		
		if (opcode[3:0] == 4'b1010 && N == 1'b1) begin
			branch_s = 1'b1;
		end
	
end
endmodule
