
module data_masterline
(
	//external signals
	input clk,
	input reset,
	
	output logic [15:0] o_mem_addr,
	
	output logic o_mem_rd,
	input [15:0] i_mem_rddata,
	
	output logic o_mem_wr,
	output logic [15:0] o_mem_wrdata,
	
	// signals to control
	input reset_s,
	input assert_rd_s,
	input rd_data_s,
	input inc_PC_s,
	input decode_s,
	input mv_rd_s,
	input rd_mv_wait_s,
	input mv_wr_s,
	input readRx_add_s,
	input readRy_add_s,
	input rd_R_wait_s,
	input add_add_s,
	input updatePC_s,
	input writeRx_add_s,
	input readRy_ld_s,
	input rd_ld_wait,
	input readMem_s,
	input writeRx_ld_s,
	input st_Rx_s,
	input rd_Rx_mvi_s,
	input rd_mvi_wait_s,
	input mvi_s,
	input addi_s,
	input jump_s,
	input j_wait_s,
	input new_PC_s,
	input call_s,
	
	output logic [4:0] opCode,
	output logic N,
	output logic Z
);

// ALU
logic [15:0] ALU_in0;
logic [15:0] ALU_in1;
logic ALUop;
logic [15:0] ALU_out;
logic N_temp;
logic Z_temp;
logic set_flags;

ALU ALU0
(
	.in0(ALU_in0),
	.in1(ALU_in1),
	.ALUop(ALUop),
	.result(ALU_out),
	.N(N_temp),
	.Z(Z_temp)
);
always@(set_flags) begin
	N <= N_temp;
	Z <= Z_temp;
end


reg [15:0] PC;
reg [15:0] IR;
reg [15:0] MDR;

//general regs
logic [2:0] reg_addr;
logic reg_rd_wr;
logic [15:0] reg_data_in;
logic [15:0] reg_data_out;
reg_file RF
(
	.clk(clk),
	.addr(reg_addr),
	.rd_wr(reg_rd_wr),
	.data_in(reg_data_in),
	.data_out(reg_data_out)
);

// decoded IR
reg [2:0] Rx;
reg [2:0] Ry;
reg [7:0] imm8;
reg [10:0] imm11;
//integer Rx_val = Rx;
//integer Ry_val = Ry;

reg [15:0] tempReg1;
reg [15:0] tempReg2;

//sampling mem data at a falling clk edge
logic [15:0] mem_data;
always@ (negedge clk) begin
	mem_data <= i_mem_rddata;
end

/*
always@(posedge clk) begin
	if(enable) pcout <= pcin;
	else pcout <= pcout;
	end
*/
//PC
//always_ff@(posedge clk) begin
	

	

always_ff@(negedge clk) begin
	set_flags = 1'b0;
	o_mem_rd = 1'b0;
	o_mem_wr = 1'b0;
	
	if (reset_s) begin
		PC = 16'b0;
		IR = 16'b0;
	end
	
	else if (assert_rd_s) begin 
		o_mem_addr = PC;
		o_mem_rd = 1'b1;
	end
	
	else if (rd_data_s) begin
		IR = i_mem_rddata;
	end
	
	else if (inc_PC_s) begin
		ALU_in0 = PC;
		ALU_in1 = 2'd2;
		ALUop = 1'b0;
		//set_flags = 1'b1;
	end 
	
	else if (updatePC_s) PC = ALU_out;
	
	else if (decode_s) begin
		opCode = IR[4:0];
		Rx = IR[7:5];
		Ry = IR[10:8];
		imm8 = IR[15:8];
		imm11 = IR[15:5];
	end
	
	else if (mv_rd_s) begin
		reg_addr = Ry;
		reg_rd_wr = 1'b0;
		
	end
	
	else if (rd_mv_wait_s) tempReg1 = reg_data_out;
	
	else if (mv_wr_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b1;
		reg_data_in = tempReg1;
	end
	
	// add & sub & cmp
	else if (readRx_add_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b0;
		//tempReg1 = reg_data_out;
	end
	
	else if (readRy_add_s) begin
		tempReg1 = reg_data_out;
		reg_addr = Ry;
		reg_rd_wr = 1'b0;
		//tempReg2 = reg_data_out;
	end
	
	else if (rd_R_wait_s) begin
		if (opCode[4] == 0) tempReg2 = reg_data_out;
		else tempReg1 = reg_data_out;
	end
	
	else if (add_add_s) begin
		ALU_in0 = tempReg1;
		ALU_in1 = tempReg2;
		if (opCode == 5'b00001 || opCode == 5'b10001) ALUop = 1'b0; // for add & addi
		else ALUop = 1'b1;
		set_flags = 1'b1;
	end
	
	else if (writeRx_add_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b1;
		reg_data_in = ALU_out;
	end
	
	else if (readRy_ld_s) begin
		reg_addr = Ry;
		reg_rd_wr = 1'b0;
		
		//o_mem_rd = 1'b1;
	end
	
	else if (rd_ld_wait) tempReg1 = reg_data_out;
	
	else if (readMem_s) begin
		o_mem_addr = tempReg1;
		o_mem_rd = 1'b1;
	end
	
	else if (writeRx_ld_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b1;
		reg_data_in = i_mem_rddata;
	end
	
	else if (st_Rx_s) begin
		o_mem_addr = tempReg2;
		o_mem_wrdata = tempReg1;
		o_mem_wr = 1'b1;
	end
	
	else if (rd_Rx_mvi_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b0;
	end
	
	else if (rd_mvi_wait_s) tempReg1 = reg_data_out;
	
	else if (mvi_s) begin
		reg_addr = Rx;
		reg_rd_wr = 1'b1;
		if (opCode == 5'b10110) begin
			reg_data_in[7:0] = tempReg1[7:0];
			reg_data_in[15:8] = imm8; // mvhi
		end
		else reg_data_in = $signed(imm8);
	end
	
	else if (addi_s) begin
		tempReg2 = $signed(imm8);
	end
	
	else if (jump_s) begin
		if (opCode[4] == 0) begin // not abs jump
			reg_addr = Rx;
			reg_rd_wr = 1'b0;
			
		end
		else begin
			tempReg1 = PC + $signed(2 * $signed(imm11));
		end
	end
	
	else if (j_wait_s) begin
		if (opCode[4] == 0) tempReg1 = reg_data_out;
	end
	
	else if (new_PC_s) begin
		PC = tempReg1;
	end
	
	else if (call_s) begin  // R7 = PC
		reg_addr = 3'b111;
		reg_rd_wr = 1'b1;
		reg_data_in = PC;
	end
	
end
endmodule 

	
		
		
	
	
	
	
	
	
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	
