module de1soc_top 
(
    // Clock pins
    input                       CLOCK_50,

    // Seven Segment Displays
    output      [ 6: 0]         HEX0,
    output      [ 6: 0]         HEX1,
    output      [ 6: 0]         HEX2,
    output      [ 6: 0]         HEX3,
    output      [ 6: 0]         HEX4,
    output      [ 6: 0]         HEX5,

    // Pushbuttons
    input       [ 3: 0]         KEY,

    // LEDs
    output      [ 9: 0]         LEDR,

    // Slider Switches
    input       [ 9: 0]         SW,

    // VGA
    output      [ 7: 0]         VGA_B,
    output                      VGA_BLANK_N,
    output                      VGA_CLK,
    output      [ 7: 0]         VGA_G,
    output                      VGA_HS,
    output      [ 7: 0]         VGA_R,
    output                      VGA_SYNC_N,
    output                      VGA_VS
);


logic [7:0] SW_Q;
always_ff@ (posedge clk) begin
	SW_Q <= SW[7:0];
end

logic LEDR_en;
always_ff@ (posedge clk) begin
	if (LEDR_en) LEDR[7:0] <= mem_wrdata[7:0];
end

//assign LEDR[7:0] = SW_Q;


logic clk;
assign clk = CLOCK_50;
logic reset;
assign reset = ~KEY[0];
logic [15:0] mem_addr;
logic mem_rd;
logic [15:0] mem_rddata;
logic mem_wr;
logic [15:0] mem_wrdata;

logic [10:0] addr;
logic wr;
logic [15:0] rddata;

logic SW_or_mem_s;

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
