`include "defines.v"

module cpu5_core (
		  input  clk,
		  input  reset,
		  output [`CPU5_PC_SIZE:0] pc,
		  input  [`CPU5_XLEN:0] instr,
		  output memwrite,
		  output [`CPU5_ADDR_SIZE:0] aluout,
		  output [`CPU5_XLEN:0] writedata,
		  input  [`CPU5_XLEN:0] readdata
);


endmodule   
