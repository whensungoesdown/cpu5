`include "../hdl/defines.v"

module pseudo_icache (
		      input  [7:0] a,
		      output [`CPU5_XLEN-1:0] q
		      );

   reg [`CPU5_XLEN-1:0] cache[255:0];

   initial
     $readmemh("memory.dat", cache);
   
   assign q = cache[a];

endmodule // pseudo_icache


module pseudo_dcache (
		      input  clk,
		      input  we,
		      input  [7:0] a,
		      input  [`CPU5_XLEN-1:0] wd,
		      output [`CPU5_XLEN-1:0] rd
		      );

   reg [`CPU5_XLEN-1:0] cache[255:0];

   initial
     $readmemh("memory.dat", cache);

   assign rd = cache[a];

   always @(posedge clk)
     if (we) cache[a] <= wd;

endmodule // pseudo_dcache

