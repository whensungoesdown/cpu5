`include "defines.v"

module cpu5_datapath (
		      input  clk,
		      input  reset,
		      input  memtoreg,
		      input  pcsrc,
		      input  alusrc,
		      input  regdst,
		      input  regwrite,
		      input  jump,
		      input  [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol,
		      output zero,
		      output [`CPU5_XLEN-1:0] pc,
		      input  [`CPU5_XLEN-1:0] instr,
		      output [`CPU5_XLEN-1:0] aluout,
		      output [`CPU5_XLEN-1:0] writedata,
		      input  [`CPU5_XLEN-1:0] readdata
		      );

   wire [`CPU5_RFIDX_WIDTH-1:0] writereg;

   wire [`CPU5_XLEN-1:0] pcnext;
   wire [`CPU5_XLEN-1:0] pcnextbr;
   wire [`CPU5_XLEN-1:0] pcplus4;
   wire [`CPU5_XLEN-1:0] pcbranch;

   wire [`CPU5_XLEN-1:0] signimm; 
   wire [`CPU5_XLEN-1:0] signimmsh;

   
   wire [`CPU5_XLEN-1:0] srca;
   wire [`CPU5_XLEN-1:0] srcb;
   
   wire [`CPU5_XLEN-1:0] result;
  

   // next PC logic
   cpu5_dffr#(`CPU5_XLEN) pcreg(pcnext, pc, clk, reset);
   cpu5_adder pcadd1(pc, 32'b100, pcplus4); // next pc if no branch, no jump
   cpu5_sl2 immsh(signimm, signimmsh);
   // pcsrc desides if to take next instruction or branch to pcbranch
   // pcnextbr means pc next br 
   cpu5_mux2#(`CPU5_XLEN) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
   // pcnext is the final pc
   // code review when implementing jump
   cpu5_mux2#(`CPU5_XLEN) pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);

   // register file logic
   cpu5_regfile rf(instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
		   instr[`CPU5_RS1_HIGH:`CPU5_RS1_LOW],
		   srca, writedata,
		   regwrite,
		   writereg, result,
		   clk, reset);

   // regdst determines whether write to rs2 or write to rd as LW instruction does
   cpu5_mux2#(`CPU5_RFIDX_WIDTH) wrmux(instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
				       instr[`CPU5_RD_HIGH:`CPU5_RD_LOW],
				       regdst, writereg);
   // memtoreg 1 means it's a LW, data comes from memory,
   // otherwise the result comes from ALU
   cpu5_mux2#(`CPU5_XLEN) resmux(aluout, readdata, memtoreg, result);

   cpu5_signext se(instr[`CPU5_IMM_HIGH:`CPU5_IMM_LOW], signimm);

   // ALU logic
   // srca from regfile, srcb ...
   cpu5_mux2#(`CPU5_XLEN) srcbmux(writedata, signimm, alusrc, srcb);
   cpu5_alu alu(srca, srcb, alucontrol, aluout, zero);
		      
endmodule // cpu5_datapath
