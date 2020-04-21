`include "defines.v"

module cpu5_adder (
		   input  [`CPU5_XLEN-1:0] a,
		   input  [`CPU5_XLEN-1:0] b,
		   output [`CPU5_XLEN-1:0] y
		   );
   assign y = a + b;

endmodule // cpu5_adder
