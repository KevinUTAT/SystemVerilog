

module LDA_peripheral 
(
	input clk, //50 MHz
	input reset,
	input [2:0] avs_s1_address,
	input avs_s1_read,
	input avs_s1_write,
	input [31:0] avs_s1_writedata,
	
	output [31:0] avs_s1_readdata,
	output avs_s1_waitrequest,
	
	//VGA output
	
	 output      [7:0]         coe_VGA_B_export,
    output                    coe_VGA_BLANK_N_export,
    output                    coe_VGA_CLK_export,
    output      [7:0]         coe_VGA_G_export,
    output                    coe_VGA_HS_export,
    output      [7:0]         coe_VGA_R_export,
    output                    coe_VGA_SYNC_N_export,
    output                    coe_VGA_VS_export
	
);

	//wires between Avalon Slave Controller and LDA Circuit
	wire done;
	wire start;
	wire [2:0] colour;
	wire [8:0] x0;
	wire [7:0] y0;
	wire [8:0] x1;
	wire [7:0] y1;

	// Wires between LDA circuit and VGA Adapter	
	wire [8:0] x_out;
	wire [7:0] y_out;
	wire plot;
	wire [2:0] colour_out;
	

Avalon_Slave_Controller ASC
(
	.clk(clk),
	.reset(reset),
	.avs_s1_address(avs_s1_address),
	.avs_s1_read(avs_s1_read),
	.avs_s1_write(avs_s1_write),
	.avs_s1_writedata(avs_s1_writedata),
	
	.avs_s1_readdata(avs_s1_readdata),
	.avs_s1_waitrequest(avs_s1_waitrequest),
	
	.done(done),
	.start(start),
	.colour(colour),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1)
	
);


LDA_circuit LDAC
(

	.clk(clk),
	
	.done(done),
	
	.start(start),
	.colour(colour),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	
	.x_out(x_out),
	.y_out(y_out),
	.plot(plot),
	.colour_out(colour_out)

);


vga_adapter VGA
(
	.clk(clk), // should be a 50MHz clock

	// User signals
	.x(x_out),
	.y(y_out),
	.color(colour_out),
	.plot(plot),
	
	// Connect directly to top-level
    .VGA_B(coe_VGA_B_export),
    .VGA_BLANK_N(coe_VGA_BLANK_N_export),
    .VGA_CLK(coe_VGA_CLK_export),
    .VGA_G(coe_VGA_G_export),
    .VGA_HS(coe_VGA_HS_export),
    .VGA_R(coe_VGA_R_export),
    .VGA_SYNC_N(coe_VGA_SYNC_N_export),
    .VGA_VS(coe_VGA_VS_export)

);
endmodule 

