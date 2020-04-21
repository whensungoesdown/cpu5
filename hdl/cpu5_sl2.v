`include "defines.v"

module cpu5_sl2  (
		  input  [`CPU5_XLEN-1:0] a,
		  output [`CPU5_XLEN-1:0] y
		  );

   assign y = {a[`CPU5_XLEN-3:0], 2'b00};

endmodule // cpu5_sl2
