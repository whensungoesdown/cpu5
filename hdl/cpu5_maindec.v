`include "defines.v"

// aluop:                   00:  LW SW(?)

// alusrc:                   0: rf
//                           1: imm

// regdst:                   0: rs2
//                           1: rd

module cpu5_maindec (
		     input  [`CPU5_OPCODE_SIZE-1:0] op,
		     output memtoreg,
		     output memwrite,
		     output branch,
		     output alusrc,
		     output regdst,
		     output regwrite,
		     output jump,
		     output [`CPU5_ALU_OP_SIZE-1:0] aluop,
                     output [`CPU5_IMMTYPE_SIZE-1:0] immtype
		     );

   wire [11:0] controls;
   assign regwrite = controls[11];
   assign regdst = controls[10];
   assign alusrc = controls[9];
   assign branch = controls[8];
   assign memwrite = controls[7];
   assign memtoreg = controls[6];
   assign jump = controls[5];
   assign aluop = controls[4:3];
   assign immtype = controls[2:0];

   wire op_lw;
   wire op_sw;

   assign op_lw = (op == 6'b0000011);
   assign op_sw = (op == 6'b0100011);


   wire [11:0] sw_controls = {
	      1'b0, // regwrite: no
	      1'b0, // regdst: (rs2)
	      1'b1, // alusrc: imm
	      1'b0, // branch: no
	      1'b1, // memwrite: yes
	      1'b0, // memtoreg: no
	      1'b0, // jump: no
	      2'b00, // aluop: add
	      `CPU5_IMMTYPE_S // immtype: CPU5_IMMTYPE_S     
	      };
   
   
   assign controls = ({12{op_lw}} & 12'b111001000001)  // immtype: CPU5_IMMTYPE_I
                                                  // aluop 00
                                                  // jump 0
                                                  // memtoreg 1
                                                  // memwrite 0
                                                  // branch 0
                                                  // alusrc 1  0:Writedata from rf, 1:imm
                                                  // regdst 1  0:WRITE_TO_RS2; 1:WRITE_TO_RD
                                                  // regwrite 1
                                                  // Above describes LW instruction
                   | ({11{op_sw}} & sw_controls)
		     ;
endmodule

//opcodes-rv32i
//# format of a line in this file:
//# <instruction name> <args> <opcode>
//#
//# <opcode> is given by specifying one or more range/value pairs:
//# hi..lo=value or bit=value or arg=value (e.g. 6..2=0x45 10=1 rd=0)
//#
//# <args> is one of rd, rs1, rs2, rs3, imm20, imm12, imm12lo, imm12hi,
//# shamtw, shamt, rm
//
//beq     bimm12hi rs1 rs2 bimm12lo 14..12=0 6..2=0x18 1..0=3
//bne     bimm12hi rs1 rs2 bimm12lo 14..12=1 6..2=0x18 1..0=3
//blt     bimm12hi rs1 rs2 bimm12lo 14..12=4 6..2=0x18 1..0=3
//bge     bimm12hi rs1 rs2 bimm12lo 14..12=5 6..2=0x18 1..0=3
//bltu    bimm12hi rs1 rs2 bimm12lo 14..12=6 6..2=0x18 1..0=3
//bgeu    bimm12hi rs1 rs2 bimm12lo 14..12=7 6..2=0x18 1..0=3
//
//jalr    rd rs1 imm12              14..12=0 6..2=0x19 1..0=3
//
//jal     rd jimm20                          6..2=0x1b 1..0=3
//
//lui     rd imm20 6..2=0x0D 1..0=3
//auipc   rd imm20 6..2=0x05 1..0=3
//
//addi    rd rs1 imm12           14..12=0 6..2=0x04 1..0=3
//slli    rd rs1 31..26=0  shamt 14..12=1 6..2=0x04 1..0=3
//slti    rd rs1 imm12           14..12=2 6..2=0x04 1..0=3
//sltiu   rd rs1 imm12           14..12=3 6..2=0x04 1..0=3
//xori    rd rs1 imm12           14..12=4 6..2=0x04 1..0=3
//srli    rd rs1 31..26=0  shamt 14..12=5 6..2=0x04 1..0=3
//srai    rd rs1 31..26=16 shamt 14..12=5 6..2=0x04 1..0=3
//ori     rd rs1 imm12           14..12=6 6..2=0x04 1..0=3
//andi    rd rs1 imm12           14..12=7 6..2=0x04 1..0=3
//
//add     rd rs1 rs2 31..25=0  14..12=0 6..2=0x0C 1..0=3
//sub     rd rs1 rs2 31..25=32 14..12=0 6..2=0x0C 1..0=3
//sll     rd rs1 rs2 31..25=0  14..12=1 6..2=0x0C 1..0=3
//slt     rd rs1 rs2 31..25=0  14..12=2 6..2=0x0C 1..0=3
//sltu    rd rs1 rs2 31..25=0  14..12=3 6..2=0x0C 1..0=3
//xor     rd rs1 rs2 31..25=0  14..12=4 6..2=0x0C 1..0=3
//srl     rd rs1 rs2 31..25=0  14..12=5 6..2=0x0C 1..0=3
//sra     rd rs1 rs2 31..25=32 14..12=5 6..2=0x0C 1..0=3
//or      rd rs1 rs2 31..25=0  14..12=6 6..2=0x0C 1..0=3
//and     rd rs1 rs2 31..25=0  14..12=7 6..2=0x0C 1..0=3
//
//lb      rd rs1       imm12 14..12=0 6..2=0x00 1..0=3
//lh      rd rs1       imm12 14..12=1 6..2=0x00 1..0=3
//lw      rd rs1       imm12 14..12=2 6..2=0x00 1..0=3
//lbu     rd rs1       imm12 14..12=4 6..2=0x00 1..0=3
//lhu     rd rs1       imm12 14..12=5 6..2=0x00 1..0=3
//
//sb     imm12hi rs1 rs2 imm12lo 14..12=0 6..2=0x08 1..0=3
//sh     imm12hi rs1 rs2 imm12lo 14..12=1 6..2=0x08 1..0=3
//sw     imm12hi rs1 rs2 imm12lo 14..12=2 6..2=0x08 1..0=3
//
//fence       fm            pred succ     rs1 14..12=0 rd 6..2=0x03 1..0=3
//fence.i     imm12                       rs1 14..12=1 rd 6..2=0x03 1..0=3
