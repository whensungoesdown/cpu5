`include "defines.v"

module cpu5_signext (
		     input  [`CPU5_IMM_SIZE-1:0] a,
		     output [`CPU5_XLEN-1:0] y
		     );

   assign y = {{`CPU5_XLEN-`CPU5_IMM_SIZE{a[`CPU5_IMM_SIZE-1]}}, a};

endmodule // cpu5_signext

