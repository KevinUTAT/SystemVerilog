
module cpu_datapath_old
(
	input clk,
	input reset,
	
	output logic [15:0] o_pc_addr,
	output logic o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output logic [15:0] o_ldst_addr,
	output logic o_ldst_rd,
	input [15:0] i_ldst_rddata,
	output logic o_ldst_wr,
	output logic [15:0] o_ldst_wrdata,
	
	output logic [7:0][15:0] o_tb_regs,
	
	input rst_s,
	input fetch_s,
	input rfread_s,
	input execute_s,
	input rfwrite_s
);

logic [2:0][15:0]counter;
always_ff@(posedge clk) begin
	if(reset) counter[0] = 16'b0;

	counter[2] = counter[1];
	counter[1] = counter[0];
	counter[0] = counter[0] + 16'b1;
	
	
	
end

// ALU
logic [15:0] ALU_in0;
logic [15:0] ALU_in1;
logic ALUop;
logic [15:0] ALU_out;
logic N_temp;
logic Z_temp;
logic N;
logic Z;
logic set_flags;

ALU ALU0
(
	.clk(clk),
	.in0(ALU_in0),
	.in1(ALU_in1),
	.ALUop(ALUop),
	.result(ALU_out),
	.N(N_temp),
	.Z(Z_temp)
);
always_ff@(posedge clk) begin
	if (set_flags) begin
		N <= N_temp;
		Z <= Z_temp;
	end
end

// RF
logic [2:0] Rx_addr;
logic [2:0] Ry_addr;
logic [2:0] wr_addr;
logic wren;
logic [15:0] wrdata_in;
logic [15:0] Rx_out;
logic [15:0] Ry_out;

assign ALU_in0 = Rx_out;

reg_file RF
(
	.clk(clk),
	.reset(reset),
	.Rx_addr(Rx_addr),
	.Ry_addr(Ry_addr),
	.wr_addr(wr_addr),
	.wren(wren),
	.wrdata_in(wrdata_in),
	.Rx_out(Rx_out),
	.Ry_out(Ry_out)
);

reg [3:0][15:0] PC;
reg [3:0][15:0] IR;
//initial PC[0] = 16'b0;
//initial PC[1] = 16'b0;
//initial PC[2] = 16'b0;
//initial PC[3] = 16'b0;
/*
always@(posedge clk) begin
	if (reset == 1) begin
		PC[0] = 16'b0;
		PC[1] = 16'b0;
		PC[2] = 16'b0;
		PC[3] = 16'b0;
	end
end
*/
logic [3:0][4:0] opcode;
/*
assign opcode[0][4:0] = IR[0][4:0];
assign opcode[1][4:0] = IR[1][4:0];
assign opcode[2][4:0] = IR[2][4:0];
assign opcode[3][4:0] = IR[3][4:0];
*/
logic [3:0][2:0] Rx;

logic [3:0][2:0] Ry;

logic [3:0][7:0] imm8;
/*
assign imm8[0][7:0] = IR[0][15:8];
assign imm8[1][7:0] = IR[1][15:8];
assign imm8[2][7:0] = IR[2][15:8];
assign imm8[3][7:0] = IR[3][15:8];
*/
logic [3:0][10:0] imm11;
/*
assign imm11[0][10:0] = IR[0][15:5];
assign imm11[1][10:0] = IR[1][15:5];
assign imm11[2][10:0] = IR[2][15:5];
assign imm11[3][10:0] = IR[3][15:5];
*/
reg [3:0][15:0] x_val;
reg [3:0][15:0] y_val;

// controller
logic fetch_ocp = 1;
logic rfread_ocp = 1;
logic execute_ocp = 1;
logic rfwrite_ocp = 1;

always@(posedge clk) begin
	o_ldst_rd = 1'b0;
	o_ldst_wr = 1'b0;
	set_flags = 0;
	wren = 0;
	
	
	
	if (reset) begin
		PC[0] <= 16'b0;
		PC[1] <= 16'b0;
		PC[2] <= 16'b0;
		PC[3] <= 16'b0;
		IR[0] <= 16'b0;
		IR[1] <= 16'b0;
		IR[2] <= 16'b0;
		IR[3] <= 16'b0;
		x_val[0] <= 16'b0;
		y_val[0] <= 16'b0;
		x_val[1] <= 16'b0;
		y_val[1] <= 16'b0;
		x_val[2] <= 16'b0;
		y_val[2] <= 16'b0;
		x_val[3] <= 16'b0;
		y_val[3] <= 16'b0;
	end
	
	if (fetch_ocp) begin
		o_pc_addr = PC[3];
		o_pc_rd = 1;
		PC[3] = PC[3] + 16'd2;
	end
	
	if (rfread_ocp) begin
		PC[1] = PC[3];
		
		IR[1] = i_pc_rddata;
		
		
		Rx[1] = IR[1][7:5];
		Ry[1] = IR[1][10:8];
		imm8[1] = IR[1][15:8];
		imm11[1] = IR[1][15:5];
		opcode[1] = IR[1][4:0];
		
		Rx_addr = Rx[1];
		Ry_addr = Ry[1];
		
	end
	
	if (execute_ocp) begin
		IR[2] = IR[1];
		PC[2] = PC[1];
		Rx[2] = Rx[1];
		Ry[2] = Ry[1];
		imm8[2] = imm8[1];
		imm11[2] = imm11[1];
		opcode[2] = opcode[1];
	
		y_val[2] = Ry_out;
		
		// if NOT j jz jn call
		if (~(opcode[1][4:3] == 2'b11)) x_val[2] = Rx_out;
		
		// if j jz jn call
		if (opcode[1][4:3] == 2'b11) 
			x_val[2] = PC[2] + 2*$signed(imm11[1]);
		
		// add sub cmp, addi subi cmpi
		if (opcode[1] == 5'b00001 || opcode[1] == 5'b00010 
			|| opcode[1] == 5'b00011 || opcode[1] == 5'b10001
			|| opcode[1] == 5'b10010 || opcode[1] == 5'b10011)
			//ALU_in0 = Rx_out;
			
		// add sub cmp
		if (opcode[1] == 5'b00001 || opcode[1] == 5'b00010 
			|| opcode[1] == 5'b00011) 
			ALU_in1 = y_val[2];
			
		// addi subi cmpi
		if (opcode[1] == 5'b10001
			|| opcode[1] == 5'b10010 || opcode[1] == 5'b10011)
			ALU_in1 = $signed(imm8[1]);
			
		if (opcode[1][3:0] == 4'b0001) ALUop = 1'b0;
		
		if (opcode[1][3:0] == 4'b0010 || opcode[1][3:0] == 4'b0011)
			ALUop = 1'b1;
			
		if (opcode[1] == 5'b00100 || opcode[1] == 5'b00101)
			o_ldst_addr = y_val[2];
			
			
		// ld
		if (opcode[1] == 5'b00100) o_ldst_rd = 1'b1;
		
		// st
		if (opcode[1] == 5'b00101) begin
			o_ldst_wr = 1'b1;
			o_ldst_wrdata = x_val[2];
		end
		
		// jr
		if (opcode[1] == 5'b01000) PC[2] = x_val[2];
		
		// jzr
		if (opcode[1] == 5'b01001) begin
			if (Z) PC[2] = x_val[2];
		end
		
		// jnr
		if (opcode[1] == 5'b01010) begin
			if (N) PC[2] = x_val[2];
		end
		
		// callr
		if (opcode[1] == 5'b01100) PC[2] = x_val[2];
	end
	
	if (rfwrite_ocp) begin
		PC[3] = PC[2];
		IR[3] = IR[2];
		Rx[3] = Rx[2];
		Ry[3] = Ry[2];
		imm8[3] = imm8[2];
		imm11[3] = imm11[3];
		opcode[3] = opcode[2];
		
		// mv add sub ld mvi addi subi mvhi
		if (opcode[2] == 5'b00000 || opcode[2] == 5'b00001
			|| opcode[2] == 5'b00010 || opcode[2] == 5'b00100
			|| opcode[2] == 5'b10000 || opcode[2] == 5'b10001
			|| opcode[2] == 5'b10010 || opcode[2] == 5'b10110) begin
			wr_addr = Rx[2];
			wren = 1;
		end
		
		// add sub addi subi
		if (opcode[2] == 5'b00001
			|| opcode[2] == 5'b00010
			|| opcode[2] == 5'b10001
			|| opcode[2] == 5'b10010) begin
			wrdata_in = ALU_out;
			o_tb_regs[Rx[2]] = ALU_out;
		end
			
		// sub cmp subi cmpi
		if (opcode[2] == 5'b00010
			|| opcode[2] == 5'b00011
			|| opcode[2] == 5'b10010
			|| opcode[2] == 5'b10011) 
			set_flags = 1;
			
		// callr call
		if (opcode[2][3:0] == 4'b1100) begin
			wr_addr = 3'd7;
			wren = 1;
			wrdata_in = PC[2];
			o_tb_regs[7] = PC[2];
		end
		
		// j jz jn call
		if (Z && opcode[2] == 5'b11001) PC[3] = x_val[2]; // jz
		if (N && opcode[2] == 5'b11010) PC[3] = x_val[2]; // jn
		if (opcode[2] == 5'b11000 || opcode[2] == 5'b11100) 
				PC[3] = x_val[2]; // j call
				
		// mv
		if (opcode[2] == 5'b00000) begin
			wrdata_in = y_val[2];
			o_tb_regs[Rx[2]] = y_val[2];
		end
		
		// ld
		if (opcode[2] == 5'b00100) wrdata_in = i_ldst_rddata;
		
		// mvi
		if (opcode[2] == 5'b10000) wrdata_in = $signed(imm8[2]);
		
		//mvhi
		if (opcode[2] == 5'b10110) begin
			wrdata_in = {imm8[2], x_val[2][7:0]};
			o_tb_regs[Rx[2]] = {imm8[2], x_val[2][7:0]};;
		end
	end
end
endmodule

		
			
			
		
		
		
		












