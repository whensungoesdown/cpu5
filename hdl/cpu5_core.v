`include "defines.v"

module cpu5_core (
		  input  clk,
		  input  reset,
		  output [`CPU5_XLEN:0] pc,
		  input  [`CPU5_XLEN:0] instr,
		  output memwrite,
		  output [`CPU5_XLEN:0] aluout,
		  output [`CPU5_XLEN:0] writedata,
		  input  [`CPU5_XLEN:0] readdata
);

   wire memtoreg;
   wire alusrc;
   wire regdst;
   wire regwrite;
   wire jump;
   wire pcsrc;
   wire zero;

   wire [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol;
   
   cpu5_controller c(instr[`CPU5_OPCODE_HIGH:`CPU5_OPCODE_LOW],
		     instr[`CPU5_FUNCT7_HIGH:`CPU5_FUNCT7_LOW],
		     zero, memtoreg, memwrite, pcsrc,
		     alusrc, regdst, regwrite, jump,
		     alucontrol);
   
   cpu5_datapath dp(clk, reset, memtoreg, pcsrc,
		    alusrc, regdst, regwrite, jump,
		    alucontrol, zero, pc, instr,
		    aluout, writedata, readdata);

endmodule   
