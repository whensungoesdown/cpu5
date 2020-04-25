`include "defines.v"

// shift left

module cpu5_sl1  (
		  input  [`CPU5_XLEN-1:0] a,
		  output [`CPU5_XLEN-1:0] y
		  );

   assign y = {a[`CPU5_XLEN-2:0], 1'b0};

endmodule // cpu5_sl2
