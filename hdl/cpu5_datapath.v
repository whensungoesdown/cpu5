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
                      input  [`CPU5_IMMTYPE_SIZE-1:0] immtype,
		      output zero,
		      output [`CPU5_XLEN-1:0] pc,
		      input  [`CPU5_XLEN-1:0] instr,
		      output [`CPU5_XLEN-1:0] dataaddr,
		      output [`CPU5_XLEN-1:0] writedata,
		      input  [`CPU5_XLEN-1:0] readdata
		      );

   wire [`CPU5_XLEN-1:0] aluout;

   assign dataaddr = aluout;
   
   wire [`CPU5_RFIDX_WIDTH-1:0] writereg;

   wire [`CPU5_XLEN-1:0] pcnext;
   wire [`CPU5_XLEN-1:0] pcnextbr;
   wire [`CPU5_XLEN-1:0] pcplus4;
   wire [`CPU5_XLEN-1:0] pcbranch;

   wire [`CPU5_XLEN-1:0] signimm; 
   //wire [`CPU5_XLEN-1:0] signimmsh;
   
   wire [`CPU5_XLEN-1:0] rs1;
   wire [`CPU5_XLEN-1:0] rs2_imm;
   
   wire [`CPU5_XLEN-1:0] result;


   
   wire [`CPU5_XLEN-1:0] i_imm = {
			{`CPU5_XLEN-`CPU5_I_IMM_SIZE{instr[`CPU5_I_IMM_HIGH]}},
			instr[`CPU5_I_IMM_HIGH:`CPU5_I_IMM_LOW]
			};

   wire [`CPU5_XLEN-1:0] s_imm = {
			{`CPU5_XLEN-`CPU5_S_IMM_SIZE{instr[`CPU5_S_IMM2_HIGH]}},
			instr[`CPU5_S_IMM2_HIGH:`CPU5_S_IMM2_LOW],
			instr[`CPU5_S_IMM1_HIGH:`CPU5_S_IMM1_LOW]
			};

   assign signimm = ({`CPU5_XLEN{immtype == `CPU5_IMMTYPE_I}} & i_imm)
                  | ({`CPU5_XLEN{immtype == `CPU5_IMMTYPE_S}} & s_imm)
		     ;

   // next PC logic
   cpu5_dffr#(`CPU5_XLEN) pcreg(pcnext, pc, clk, reset);
   cpu5_adder pcadd1(pc, 32'b100, pcplus4); // next pc if no branch, no jump
   //cpu5_sl2 immsh(signimm, signimmsh);
   // pcsrc desides if to take next instruction or branch to pcbranch
   // pcnextbr means pc next br 
   cpu5_mux2#(`CPU5_XLEN) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
   // pcnext is the final pc
   // code review when implementing jump
   cpu5_mux2#(`CPU5_XLEN) pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);

   // register file logic
   cpu5_regfile rf(instr[`CPU5_RS1_HIGH:`CPU5_RS1_LOW],
                   instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
                   rs1, writedata, // SW: rs2 contains data to write to memory
                   regwrite,
		   writereg, result,
		   clk, reset);

   // regdst determines whether  or write to rd in LW instruction
   // ? when need to write to rs2?
   cpu5_mux2#(`CPU5_RFIDX_WIDTH) wrmux(instr[`CPU5_RS2_HIGH:`CPU5_RS2_LOW],
				       instr[`CPU5_RD_HIGH:`CPU5_RD_LOW],
				       regdst, writereg);
   // memtoreg 1 means it's a LW, data comes from memory,
   // otherwise the result comes from ALU
   // LW: load data from memory to rd.  add rd, rs1, rs2: ALU output to rd
   cpu5_mux2#(`CPU5_XLEN) resmux(aluout, readdata, memtoreg, result);

   //cpu5_signext se(instr[`CPU5_IMM_HIGH:`CPU5_IMM_LOW], signimm);

   // ALU logic
   cpu5_mux2#(`CPU5_XLEN) srcbmux(writedata, signimm, alusrc, rs2_imm);
   cpu5_alu alu(rs1, rs2_imm, alucontrol, aluout, zero);
		      
endmodule // cpu5_datapath
