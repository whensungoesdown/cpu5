`include "defines.v"

module cpu5_core (
		  input  clk,
		  input  reset,
   
		  output [`CPU5_XLEN-1:0] pc,
		  input  [`CPU5_XLEN-1:0] instr,
                  // write back to memory
		  output memwrite,
		  output [`CPU5_XLEN-1:0] dataaddr,
		  output [`CPU5_XLEN-1:0] writedata,
                  // fetch data
		  input  [`CPU5_XLEN-1:0] readdata
);

   wire memtoreg;
   wire alusrc;
   wire regdst;
   wire regwrite;
   wire jump;
   wire [`CPU5_BRANCHTYPE_SIZE-1:0] branchtype;
   wire zero;

   wire [`CPU5_ALU_CONTROL_SIZE-1:0] alucontrol;
   wire [`CPU5_IMMTYPE_SIZE-1:0] immtype;
   
   cpu5_controller c(instr[`CPU5_OPCODE_HIGH:`CPU5_OPCODE_LOW],
		     instr[`CPU5_FUNCT3_HIGH:`CPU5_FUNCT3_LOW],
		     instr[`CPU5_FUNCT7_HIGH:`CPU5_FUNCT7_LOW],
		     memtoreg, memwrite, branchtype,
		     alusrc, regwrite, jump,
		     alucontrol, immtype);
   
   cpu5_datapath dp(clk, reset, memtoreg, branchtype,
		    alusrc, regwrite, jump,
		    alucontrol, immtype, pc, instr,
		    dataaddr, writedata, readdata);

endmodule   
