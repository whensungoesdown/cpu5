`include "defines.v"

module cpu5_mux2 #(parameter WIDTH=8) 
(
 input  [WIDTH-1:0] d0,
 input  [WIDTH-1:0] d1,
 input  s,
 output [WIDTH-1:0] y
 );

   assign y = s? d1: d0;

endmodule // cpu5_mux2

				      
