`include "defines.v"

module top (
	    input  clk,
	    input  reset
	    );

   wire [`CPU5_XLEN-1:0] pc;
   wire [`CPU5_XLEN-1:0] instr;
   wire [`CPU5_XLEN-1:0] readdata;

   wire [`CPU5_XLEN-1:0] dataaddr;
   wire [`CPU5_XLEN-1:0] writedata;
   wire memwrite;
   
   // instantiate processor and memories
   cpu5_core core(clk, reset, pc, instr, memwrite,
		  dataaddr, writedata, readdata);

   pseudo_icache icache(pc[9:2], instr);
   pseudo_dcache dcache(clk, memwrite, dataaddr[9:2],
			writedata, readdata);

endmodule // top
