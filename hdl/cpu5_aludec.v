`include "defines.v"

module cpu5_aludec (
   input  [`CPU5_FUNCT3_SIZE-1:0] funct3,
   input  [`CPU5_FUNCT7_SIZE-1:0] funct7,
   input  [`CPU5_ALU_OP_SIZE-1:0] aluop,
   output [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol
   );
   
   wire aluop_00 = (aluop == 2'b00);
   wire aluop_01 = (aluop == 2'b01);

   assign alucontrol = ({3{aluop_00}} & 3'b010) // add (for lw/sw/addi)
                     | ({3{aluop_01}} & 3'b110);

endmodule // cpu5_aludec
 
