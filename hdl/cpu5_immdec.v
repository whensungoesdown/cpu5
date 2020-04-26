`include "defines.v"

module cpu5_immdec (
   input  [`CPU5_XLEN-1:0] instr,
   input  [`CPU5_BRANCHTYPE_SIZE-1:0] immtype,
   output [`CPU5_XLEN-1:0] signimm
   );

   
   wire [`CPU5_XLEN-1:0] i_imm = {
			{`CPU5_XLEN-`CPU5_I_IMM_SIZE{instr[`CPU5_I_IMM_HIGH]}},
			instr[`CPU5_I_IMM_HIGH:`CPU5_I_IMM_LOW]
			};

   wire [`CPU5_XLEN-1:0] s_imm = {
			{`CPU5_XLEN-`CPU5_S_IMM_SIZE{instr[`CPU5_S_IMM2_HIGH]}},
			instr[`CPU5_S_IMM2_HIGH:`CPU5_S_IMM2_LOW],
			instr[`CPU5_S_IMM1_HIGH:`CPU5_S_IMM1_LOW]
			};

   wire [`CPU5_XLEN-1:0] b_imm = {
			 {`CPU5_XLEN-`CPU5_B_IMM_SIZE{instr[`CPU5_B_IMM_BIT12]}},
			 instr[`CPU5_B_IMM_BIT12],
			 instr[`CPU5_B_IMM_BIT11],
			 instr[`CPU5_B_IMM2_HIGH:`CPU5_B_IMM2_LOW],
			 instr[`CPU5_B_IMM1_HIGH:`CPU5_B_IMM1_LOW]
			 };

   assign signimm = ({`CPU5_XLEN{immtype == `CPU5_IMMTYPE_I}} & i_imm)
                  | ({`CPU5_XLEN{immtype == `CPU5_IMMTYPE_S}} & s_imm)
                  | ({`CPU5_XLEN{immtype == `CPU5_IMMTYPE_B}} & b_imm)
		     ;

endmodule // cpu5_immdec

