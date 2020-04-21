`include "defines.v"

module cpu5_maindec (
		     input  [`CPU5_OPCODE_SIZE-1:0] op,
		     output memtoreg,
		     output memwrite,
		     output branch,
		     output alusrc,
		     output regdst,
		     output regwrite,
		     output jump,
		     output [`CPU5_ALU_OP_SIZE-1:0] aluop
		     );

   wire [8:0] controls;
   assign regwrite = controls[8];
   assign regdst = controls[7];
   assign alusrc = controls[6];
   assign branch = controls[5];
   assign memwrite = controls[4];
   assign memtoreg = controls[3];
   assign jump = controls[2];
   assign aluop = controls[1:0];

   wire op_lw;

   assign op_lw = (op == 6'b100011);
   assign controls = ({9{op_lw}} & 9'b101001000);
   
endmodule
