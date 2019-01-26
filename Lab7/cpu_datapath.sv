
module cpu_datapath
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
	
	output logic [7:0][15:0] o_tb_regs
);

// Branchin handling
logic branch_s;

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
//assign set_flags = (branch_s) ? 0 : set_flags_temp;

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
//assign wren = (branch_s) ? 0 : wren_temp;

//assign ALU_in0 = Rx_out;

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


reg [15:0] PC;
logic [2:0][15:0] IR;
logic [15:0] x_val;
logic [15:0] y_val;

// dependent handling 
logic Rx_select;
logic Ry_select;
logic Rx_select2;
logic Ry_select2;
logic [15:0] Rx_val_stage4;
logic [15:0] Rx_val_stage4_before;
always_ff@(posedge clk) begin
	Rx_val_stage4_before <= Rx_val_stage4;
end


logic [2:0] Rx_stage3;
logic [2:0] Ry_stage3;
assign Rx_stage3 = IR[0][7:5];
assign Ry_stage3 = IR[0][10:8];
logic [2:0] Rx_stage4;
assign Rx_stage4 = IR[1][7:5];
logic ld_stage4;
assign ld_stage4 = (IR[1][4:0] == 5'b00100);

assign Rx_select = (wren && (Rx_stage3 == Rx_stage4));
assign Ry_select = (wren && (Ry_stage3 == Rx_stage4));





// assign Rx_val_stage4 = wrdata_in;

logic [15:0] PC_out;
logic [15:0] PC_jump;
assign PC = (branch_s) ? PC_jump : PC_out;

logic branch_s_delay;
always_ff@(posedge clk) begin
	branch_s_delay <= branch_s;
end 

fetch fetch_module
(
	.reset(reset),
	.clk(clk),
	.o_pc_addr(o_pc_addr),
	.o_pc_rd(o_pc_rd),
	.PC(PC),
	.PC_out(PC_out)
);


rf_read rf_read_module
(
	.clk(clk),
	.Rx_select(Rx_select),
	.Ry_select(Ry_select),
	.Rx_stage4(Rx_stage4),
	.Rx_select2(Rx_select2),
	.Ry_select2(Ry_select2),
	.i_pc_rddata(i_pc_rddata),
	.Rx_addr(Rx_addr),
	.Ry_addr(Ry_addr),
	.IR(IR[0]),
	.wren(wren),
	.branch_s((branch_s || branch_s_delay))
);

execute execute_module 
(
	.clk(clk),
	.PC(PC),
	.PC_jump(PC_jump),
	.N(N_temp),
	.Z(Z_temp),
	.Rx_select(Rx_select),
	.Ry_select(Ry_select),
	.Rx_stage4(Rx_val_stage4),
	.Ry_stage4(Rx_val_stage4),
	.Rx_select2(Rx_select2),
	.Ry_select2(Ry_select2),
	.Rx_stage4_before(Rx_val_stage4_before),
	.ld_stage4(ld_stage4),
	.Rx_out(Rx_out),
	.Ry_out(Ry_out),
	.IR(IR[0]),
	.x_val(x_val),
	.y_val(y_val),
	.IR_out(IR[1]),
	.ALU_in0(ALU_in0),
	.ALU_in1(ALU_in1),
	.ALUop(ALUop),
	.o_ldst_addr(o_ldst_addr),
	.o_ldst_rd(o_ldst_rd),
	.o_ldst_wr(o_ldst_wr),
	.o_ldst_wrdata(o_ldst_wrdata),
	.i_ldst_rddata(i_ldst_rddata),
	.branch_s(branch_s)
);


rf_write rf_write_module
(
	.clk(clk),
	.wr_addr(wr_addr),
	.wren(wren),
	.wrdata_in(wrdata_in),
	.ALU_out(ALU_out),
	.x_val(x_val),
	.y_val(y_val),
	.i_ldst_rddata(i_ldst_rddata),
	.IR(IR[1]),
	.set_flags(set_flags),
	.o_tb_regs(o_tb_regs),
	.Rx_val_stage4(Rx_val_stage4),
	.IRout(IR[2]),
	.PC(PC_out)
);

endmodule















