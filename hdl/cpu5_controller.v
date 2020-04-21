`include "defines.v"

module cpu5_controller (
			input  [`CPU5_OPCODE_SIZE-1:0] op,
			input  [`CPU5_FUNCT7_SIZE-1:0] funct,
			input  zero,
			output memtoreg,
			output memwrite,
			output pcsrc,
			output alusrc,
			output regdst,
			output regwrite,
			output jump,
			output [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol
			);
   
   wire [`CPU5_ALU_OP_SIZE-1:0] aluop;
   wire branch;

   cpu5_maindec md(op, memtoreg, memwrite, branch,
		   alusrc, regdst, regwrite, jump,
		   aluop);

   cpu5_aludec ad(funct, aluop, alucontrol);

   assign pcsrc = branch & zero;
endmodule
			
