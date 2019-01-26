
module cpu
(
	input clk,
	input reset,
	
	output [15:0] o_mem_addr,
	
	output logic o_mem_rd,
	input [15:0] i_mem_rddata,
	
	output logic o_mem_wr,
	output [15:0] o_mem_wrdata,
	
	input i_mem_wait,
	input i_mem_rddatavalid
);

logic reset_s;
logic assert_rd_s;
logic rd_data_s;
logic inc_PC_s;
logic decode_s;
logic mv_rd_s;
logic rd_mv_wait_s;
logic mv_wr_s;
logic readRx_add_s;
logic readRy_add_s;
logic rd_R_wait_s;
logic add_add_s;
logic updatePC_s;
logic writeRx_add_s;
logic readRy_ld_s;
logic rd_ld_wait;
logic readMem_s;
logic writeRx_ld_s;
logic st_Rx_s;
logic rd_Rx_mvi_s;
logic rd_mvi_wait_s;
logic mvi_s;
logic addi_s;
logic jump_s;
logic j_wait_s;
logic new_PC_s;
logic call_s;

logic [4:0] opCode;
logic N;
logic Z;

control_masterline CPU_control
(
	.clk(clk),
	.reset(reset),
	// external signal
	.i_mem_wait(i_mem_wait),
	.i_mem_rddatavalid(i_mem_rddatavalid),
	//.o_mem_rd(o_mem_rd),
	//.o_mem_wr(o_mem_wr),
	
	//signals to data
	.reset_s(reset_s),
	.assert_rd_s(assert_rd_s),
	.rd_data_s(rd_data_s),
	.inc_PC_s(inc_PC_s),
	.decode_s(decode_s),
	.mv_rd_s(mv_rd_s),
	.rd_mv_wait_s(rd_mv_wait_s),
	.mv_wr_s(mv_wr_s),
	.readRx_add_s(readRx_add_s),
	.readRy_add_s(readRy_add_s),
	.rd_R_wait_s(rd_R_wait_s),
	.add_add_s(add_add_s),
	.updatePC_s(updatePC_s),
	.writeRx_add_s(writeRx_add_s),
	.readRy_ld_s(readRy_ld_s),
	.rd_ld_wait(rd_ld_wait),
	.readMem_s(readMem_s),
	.writeRx_ld_s(writeRx_ld_s),
	.st_Rx_s(st_Rx_s),
	.rd_Rx_mvi_s(rd_Rx_mvi_s),
	.rd_mvi_wait_s(rd_mvi_wait_s),
	.mvi_s(mvi_s),
	.addi_s(addi_s),
	.jump_s(jump_s),
	.j_wait_s(j_wait_s),
	.new_PC_s(new_PC_s),
	.call_s(call_s),
	
	.opCode(opCode),
	.N(N),
	.Z(Z)
);


data_masterline CPU_data
(
	//external signals
	.clk(clk),
	.reset(reset),	
	.o_mem_addr(o_mem_addr),
	.o_mem_rd(o_mem_rd),
	.i_mem_rddata(i_mem_rddata),
	.o_mem_wr(o_mem_wr),
	.o_mem_wrdata(o_mem_wrdata),
	// signals to control
	.reset_s(reset_s),
	.assert_rd_s(assert_rd_s),
	.rd_data_s(rd_data_s),
	.inc_PC_s(inc_PC_s),
	.decode_s(decode_s),
	.mv_rd_s(mv_rd_s),
	.rd_mv_wait_s(rd_mv_wait_s),
	.mv_wr_s(mv_wr_s),
	.readRx_add_s(readRx_add_s),
	.readRy_add_s(readRy_add_s),
	.rd_R_wait_s(rd_R_wait_s),
	.add_add_s(add_add_s),
	.updatePC_s(updatePC_s),
	.writeRx_add_s(writeRx_add_s),
	.readRy_ld_s(readRy_ld_s),
	.rd_ld_wait(rd_ld_wait),
	.readMem_s(readMem_s),
	.writeRx_ld_s(writeRx_ld_s),
	.st_Rx_s(st_Rx_s),
	.rd_Rx_mvi_s(rd_Rx_mvi_s),
	.rd_mvi_wait_s(rd_mvi_wait_s),
	.mvi_s(mvi_s),
	.addi_s(addi_s),
	.jump_s(jump_s),
	.j_wait_s(j_wait_s),
	.new_PC_s(new_PC_s),
	.call_s(call_s),
	
	.opCode(opCode),
	.N(N),
	.Z(Z)
);

endmodule















