
module control_masterline
(

	input clk,
	input reset,
	// external signal
	output logic o_mem_rd,
	output logic o_mem_wr,
	
	//signals to data
	output logic reset_s,
	output logic assert_rd_s,
	output logic rd_data_s,
	output logic inc_PC_s,
	output logic decode_s,
	output logic mv_rd_s,
	output logic mv_wr_s,
	output logic readRx_add_s,
	output logic readRy_add_s,
	output logic add_add_s,
	output logic updatePC_s,
	output logic writeRx_add_s,
	output logic readRy_ld_s,
	output logic readMem_s,
	output logic writeRx_ld_s,
	output logic st_Rx_s,
	output logic mvi_s,
	output logic rd_Rx_mvi_s,
	output logic addi_s,
	output logic jump_s,
	output logic new_PC_s,
	output logic call_s,
	
	input [4:0] opCode,
	input N,
	input Z
);

enum int unsigned
{
	Reset,
	Assert_rd,
	Rd_data,
	Inc_PC,
	UpdatePC,
	Decode,
	Instr_branch,
	Ins_mv,
	ReadRy_mv,
	WriteRx_mv,
	Ins_add,
	ReadRx_add,
	ReadRy_add,
	Add_add,
	WriteRx_add,
	Ins_sub,
	Ins_cmp,
	Ins_ld,
	ReadRy_ld,
	Assert_rd_mem,
	ReadMem,
	WriteRx_ld,
	Ins_st,
	St_Rx,
	Ins_mvi,
	Ins_addi,
	Ins_subi,
	Ins_cmpi,
	Ins_mvhi,
	WriteRx_mvi,
	ReadRx_mvi,
	Ins_jumps,
	New_PC,
	Ins_jr,
	Ins_jzr,
	Ins_jnr,
	Ins_callr,
	Ins_j,
	Ins_jz,
	Ins_jn,
	Ins_call
} state, nextstate;


always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		state = Reset;
		end
	else state <= nextstate;
end


always_comb begin
	reset_s = 1'b0;
	assert_rd_s = 1'b0;
	o_mem_rd = 1'b0;
	o_mem_wr = 1'b0;
	rd_data_s = 1'b0;
	inc_PC_s = 1'b0;
	updatePC_s = 1'b0;
	decode_s = 1'b0;
	mv_rd_s = 1'b0;
	mv_wr_s = 1'b0;
	readRx_add_s = 1'b0;
	readRy_add_s = 1'b0;
	add_add_s = 1'b0;
	writeRx_add_s = 1'b0;
	readRy_ld_s = 1'b0;
	readMem_s = 1'b0;
	writeRx_ld_s = 1'b0;
	st_Rx_s = 1'b0;
	rd_Rx_mvi_s = 1'b0;
	mvi_s = 1'b0;
	addi_s = 1'b0;
	jump_s = 1'b0;
	new_PC_s = 1'b0;
	call_s = 1'b0;

	case (state)
	
		Reset: 			begin
							reset_s = 1'b1;
							nextstate = Assert_rd;
						end 
		
		Assert_rd: 		begin
							assert_rd_s = 1'b1;
							o_mem_rd = 1'b1;
							nextstate = Rd_data;
						end
						
		Rd_data: 		begin
							rd_data_s = 1'b1;
							nextstate = Inc_PC;
						end
						
		Inc_PC:			begin
							inc_PC_s = 1'b1;
							nextstate = UpdatePC;
						end
						
		UpdatePC:		begin 
							updatePC_s = 1'b1;
							nextstate = Decode;
						end
							
		Decode:			begin
							decode_s = 1'b1;
							nextstate = Instr_branch;
						end
						
		Instr_branch:	begin
							case (opCode)
								5'b00000:	nextstate = Ins_mv;
								5'b00001:	nextstate = Ins_add;
								5'b00010:	nextstate = Ins_add;
								5'b00011:	nextstate = Ins_add;
								5'b00100:	nextstate = Ins_ld;
								5'b00101:	nextstate = Ins_st;
								5'b10000:	nextstate = Ins_mvi;
								5'b10001:	nextstate = Ins_addi;
								5'b10010:	nextstate = Ins_addi;
								5'b10011:	nextstate = Ins_addi;
								5'b10110:	nextstate = Ins_mvi;
								5'b01000:	nextstate = Ins_jumps;
								5'b01001:	nextstate = Ins_jumps;
								5'b01010:	nextstate = Ins_jumps;
								5'b01100:	nextstate = Ins_call;
								5'b11000:	nextstate = Ins_jumps;
								5'b11001:	nextstate = Ins_jumps;
								5'b11010:	nextstate = Ins_jumps;
								5'b11100:	nextstate = Ins_call;
							endcase
						end
		
// mv		
		Ins_mv:			begin
							nextstate = ReadRy_mv;
						end 
						
		ReadRy_mv:		begin
							mv_rd_s = 1'b1;
							nextstate = WriteRx_mv;
						end
						
		WriteRx_mv:		begin
							mv_wr_s = 1'b1;
							nextstate = Assert_rd;
						end
						
// add & sub & cmp
		Ins_add:		nextstate = ReadRx_add;
		
		ReadRx_add:		begin
							readRx_add_s = 1'b1;
							if (opCode == 5'b10001 || opCode == 5'b10010 || opCode == 5'b10011) nextstate = Add_add; // for addi & subi, no readRy
							else nextstate = ReadRy_add;
						end
						
		ReadRy_add:		begin
							readRy_add_s = 1'b1;
							if (opCode == 5'b00101) nextstate = St_Rx; // if its a st 
							else nextstate = Add_add;
						end
						
		Add_add:		begin
							add_add_s = 1'b1;
							if (opCode == 5'b00011 || opCode == 5'b10011) nextstate = Assert_rd; // only for cmp & cmpi
							else nextstate = WriteRx_add;
						end
						
		WriteRx_add:	begin 
							writeRx_add_s = 1'b1;
							nextstate = Assert_rd;
						end
					
// ld
		Ins_ld:			nextstate = ReadRy_ld;
		
		ReadRy_ld: 		begin
							readRy_ld_s = 1'b1;
							nextstate = Assert_rd_mem;
						end
						
		Assert_rd_mem:	begin
							o_mem_rd = 1'b1;
							nextstate = ReadMem;
						end
		
		ReadMem: 		begin
							readMem_s = 1'b1;
							o_mem_rd = 1'b1;
							nextstate = WriteRx_ld;
						end
						
		WriteRx_ld:		begin 
							writeRx_ld_s = 1'b1;
							nextstate = Assert_rd;
						end
						
// st
		Ins_st:			nextstate = ReadRx_add;
		
		St_Rx:			begin
							st_Rx_s = 1'b1;
							o_mem_wr = 1'b1;
							nextstate = Assert_rd;
						end
	
// mvi
		Ins_mvi: 		begin
							nextstate = ReadRx_mvi;
						end
						
		ReadRx_mvi: 	begin
							rd_Rx_mvi_s = 1'b1;
							nextstate = WriteRx_mvi;
						end
						
		WriteRx_mvi:	begin 
							mvi_s = 1'b1;
							nextstate = Assert_rd;
						end
						
//addi and subi & cmpi
		Ins_addi: 		begin
							addi_s = 1'b1;
							nextstate = ReadRx_add;
						end
						
// for all jumps: jr, jzr,jnr,j, jz, jn
		Ins_jumps:		begin
							jump_s = 1'b1;
							nextstate = New_PC;
						end
						
		New_PC: 		begin
							//         j,  jr                        jz, jzr if Z == 1
							if (opCode[3:0] == 4'b1000 || (opCode[3:0] == 4'b1001 && Z == 1)
							//            jn, jnr if N == 1              handlling part of call & callr
								|| (opCode[3:0] == 4'b1010 && N == 1) || opCode[3:0] == 4'b1100) begin
								new_PC_s = 1'b1;
							end
							nextstate = Assert_rd;
						end
						
// for all call: call & callr
		Ins_call:		begin
							call_s = 1'b1;
							nextstate = Ins_jumps;
						end
						
		default:		nextstate = Reset;
	endcase
end
endmodule

						
						

							
							
							
						
							
								
						
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
	