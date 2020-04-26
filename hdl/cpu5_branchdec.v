`include "defines.v"

module cpu5_branchdec (
   input  [`CPU5_BRANCHTYPE_SIZE-1:0] branchtype,
   input  zero,
   output branch
   );

  
   assign branch = ((branchtype == `CPU5_BRANCHTYPE_BEQ) & zero)
               | ((branchtype == `CPU5_BRANCHTYPE_BNE) & (~zero))
	;
   
endmodule // cpu5_branchdec
