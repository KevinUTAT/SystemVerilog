
module tbb();

logic clk;
initial clk = '0;
always #5 clk = ~clk;

logic [3:0] KEY;
logic [9:0] LEDR;
logic [9:0] SW = 10'b0011110011;

logic [15:0] mem_addr;
logic mem_rd;
logic [15:0] mem_rddata;
logic mem_wr;
logic [15:0] mem_wrdata;

logic [10:0] addr;
logic wr;
logic [15:0] rddata;

logic SW_or_mem_s;


logic [7:0] SW_Q;
always_ff@ (posedge clk) begin
	SW_Q <= SW[7:0];
end

logic LEDR_en;
always_ff@ (posedge clk) begin
	if (LEDR_en) LEDR[7:0] <= mem_wrdata[7:0];
end

//assign LEDR[7:0] = SW_Q;


//logic clk;
//assign clk = CLOCK_50;
logic reset;

initial begin
	reset = '1;
	@(posedge clk);
	@(posedge clk);
	reset = '0;
end

//assign reset = ~KEY[0];


assign mem_rddata = (SW_or_mem_s) ? rddata : {8'b0, SW_Q};
//assign mem_rddata = 
 


cpu cpu0
(
	.clk(clk),
	.reset(reset),
	.o_mem_addr(mem_addr),
	.o_mem_rd(mem_rd),
	.i_mem_rddata(mem_rddata),
	.o_mem_wr(mem_wr),
	.o_mem_wrdata(mem_wrdata)
);


mem4k_decoder mem_decoder0
(
	.mem_addr(mem_addr),
	.mem_wr(mem_wr),
	.addr(addr),
	.wr(wr)
);


mem4k mem0
(
	.clk(clk),
	.addr(addr),
	.wrdata(mem_wrdata),
	.wr(wr),
	.rddata(rddata)
);

SW_or_mem som0
(
	.clk(clk),
	.mem_addr(mem_addr),
	.SW_or_mem_s(SW_or_mem_s)
);


LEDR_decoder LEDRD
(
	.mem_wr(mem_wr),
	.mem_addr(mem_addr),
	.LEDR_en(LEDR_en)
);

endmodule