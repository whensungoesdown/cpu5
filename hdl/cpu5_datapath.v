`include "defines.v"

module cpu5_datapath (
		      input  clk,
		      input  reset,
		      input  memtoreg,
		      input  [`CPU5_BRANCHTYPE_SIZE-1:0] branchtype, //input  pcsrc,
		      input  alusrc,
		      //input  regdst,
		      input  regwrite,
		      input  jump,
		      input  [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol,
                      input  [`CPU5_IMMTYPE_SIZE-1:0] immtype,
		      output [`CPU5_XLEN-1:0] pc,
		      input  [`CPU5_XLEN-1:0] instr,
		      output [`CPU5_XLEN-1:0] dataaddr,
		      output [`CPU5_XLEN-1:0] writedata,
		      input  [`CPU5_XLEN-1:0] readdata
		      );

   wire [`CPU5_XLEN-1:0] aluout;

   assign dataaddr = aluout;
   
   wire [`CPU5_RFIDX_WIDTH-1:0] writereg = instr[`CPU5_RD_HIGH:`CPU5_RD_LOW];

   wire [`CPU5_XLEN-1:0] pcnext;
   wire [`CPU5_XLEN-1:0] pcnextbr;
   wire [`CPU5_XLEN-1:0] pcplus4;
   wire [`CPU5_XLEN-1:0] pcbranch;

   wire [`CPU5_XLEN-1:0] signimm; 
   wire [`CPU5_XLEN-1:0] signimmsh;
   
   wire [`CPU5_XLEN-1:0] rs1;
   wire [`CPU5_XLEN-1:0] rs2_imm;
   
   wire [`CPU5_XLEN-1:0] alu_mem;
   wire [`CPU5_XLEN-1:0] rd;

   wire branch;
   wire zero;
   

   // decode imm
   cpu5_immdec immdec(instr, immtype, signimm);

   // decode branch
   cpu5_branchdec branchdec(branchtype, zero, branch);
   
   // next PC logic
   cpu5_dffr#(`CPU5_XLEN) pcreg(pcnext, pc, clk, reset);
   cpu5_adder pcadd1(pc, 32'b100, pcplus4); // next pc if no branch, no jump
   cpu5_sl1 immsh(signimm, signimmsh);
   // risc-v counts begin at the current branch instruction
   cpu5_adder pcadd2(pc, signimmsh, pcbranch);
   // branch desides if to take next instruction or branch to pcbranch
   // pcnextbr means pc next br 
   cpu5_mux2#(`CPU5_XLEN) pcbrmux(pcplus4, pcbranch, branch, pcnextbr);
   // pcnext is the final pc
   // code review when implementing jump
   cpu5_mux2#(`CPU5_XLEN) pcmux(pcnextbr, aluout, jump, pcnext);

   // register file logic
   cpu5_regfile rf(instr[`CPU5_RS1_HIGH:`CPU5_RS1_LOW],
                   instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
                   rs1, writedata, // SW: rs2 contains data to write to memory
                   regwrite,
		   writereg, rd,
		   clk, reset);

   // rd <-- mem/reg
   // when write to rs2?
   // only mips need to determine write-register, MIPS LW use rt(rs2) as the destination register
   // but other type instruction use rd
   
   //cpu5_mux2#(`CPU5_RFIDX_WIDTH) wrmux(instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
   //				       instr[`CPU5_RD_HIGH:`CPU5_RD_LOW],
   //				       regdst, writereg);
   
   // memtoreg 1 means it's a LW, data comes from memory,
   // otherwise the alu_mem comes from ALU
   // LW: load data from memory to rd.  add rd, rs1, rs2: ALU output to rd
   cpu5_mux2#(`CPU5_XLEN) resmux(aluout, readdata, memtoreg, alu_mem);

   cpu5_mux2#(`CPU5_XLEN) jumpmux(alu_mem, pcplus4, jump, rd);

   //cpu5_signext se(instr[`CPU5_IMM_HIGH:`CPU5_IMM_LOW], signimm);

   // ALU logic
   cpu5_mux2#(`CPU5_XLEN) srcbmux(writedata, signimm, alusrc, rs2_imm);
   cpu5_alu alu(rs1, rs2_imm, alucontrol, aluout, zero);
		      
endmodule // cpu5_datapath
