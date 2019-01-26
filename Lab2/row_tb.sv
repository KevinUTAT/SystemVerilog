
`timescale 1ns/1ns

module row_tb();

logic [15:0] Pin;
logic qi;
logic qim1;
logic [7:0] M;
logic [15:0] Pout;

SAM_row #
(
	.rowIndex(0)
)
SAMR0
(
	.qjm1(qim1),
	.qj(qi),
	.m(M),
	.pin_ext(Pin),
	.pout_ext(Pout)
);

initial begin
	Pin = 16'b0;
	qi = 1'b0;
	qim1 = 1'b0;
	M = 8'b11111111;
	#5;
end
endmodule 