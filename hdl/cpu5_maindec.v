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

   assign op_lw = (op == 6'b0000011);
   assign controls = ({9{op_lw}} & 9'b111001000); // aluop 00
                                                  // jump 0
                                                  // memtoreg 1
                                                  // memwrite 0
                                                  // branch 0
                                                  // alusrc 1  0:Writedata from rf, 1:imm
                                                  // regdst 1  0:WRITE_TO_RS2; 1:WRITE_TO_RD
                                                  // regwrite 1
                                                  // Above describes LW instruction
   
endmodule
