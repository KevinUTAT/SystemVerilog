module cpu
(
	input clk,
	input reset,
	
	output [15:0] o_pc_addr,
	output o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output [15:0] o_ldst_addr,
	output o_ldst_rd,
	output o_ldst_wr,
	input [15:0] i_ldst_rddata,
	output [15:0] o_ldst_wrdata,
	
	output [7:0][15:0] o_tb_regs
);

	logic rst_s;
	logic fetch_s;
	logic rfread_s;
	logic execute_s;
	logic rfwrite_s;
	
	cpu_controlpath cp
	(
	.clk(clk),
	.reset(reset),
	.rst_s(rst_s),
	.fetch_s(fetch_s),
	.rfread_s(rfread_s),
	.execute_s(execute_s),
	.rfwrite_s(rfwrite_s)
	);
	
	
	cpu_datapath dp
	(
	.clk(clk),
	.reset(reset),
	.o_pc_addr(o_pc_addr),
	.o_pc_rd(o_pc_rd),
	.i_pc_rddata(i_pc_rddata),
	.o_ldst_addr(o_ldst_addr),
	.o_ldst_rd(o_ldst_rd),
	.i_ldst_rddata(i_ldst_rddata),
	.o_ldst_wr(o_ldst_wr),
	.o_ldst_wrdata(o_ldst_wrdata),
	.o_tb_regs(o_tb_regs)
	);


endmodule

