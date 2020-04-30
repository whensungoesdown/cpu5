`define CPU5_ADDR_SIZE    32
//`define CPU5_PC_SIZE      32

`define CPU5_RFREG_NUM    32
`define CPU5_RFIDX_WIDTH  5
`define CPU5_XLEN         32

`define CPU5_ALU_CONTROL_SIZE     3

`define CPU5_ALU_OP_SIZE          2
`define CPU5_ALU_OP_ADD           2'b00
`define CPU5_ALU_OP_SUB           2'b01
`define CPU5_ALU_OP_OTHER         2'b11

`define CPU5_FUNCT3_HIGH         14
`define CPU5_FUNCT3_LOW          12
`define CPU5_FUNCT3_SIZE          3

`define CPU5_FUNCT7_HIGH         31
`define CPU5_FUNCT7_LOW          25
`define CPU5_FUNCT7_SIZE          7

`define CPU5_RS2_HIGH            24
`define CPU5_RS2_LOW             20

`define CPU5_RS1_HIGH            19
`define CPU5_RS1_LOW             15

`define CPU5_RD_HIGH             11
`define CPU5_RD_LOW               7

// IMM
`define CPU5_IMMTYPE_SIZE        3

`define CPU5_IMMTYPE_R           3'b000
`define CPU5_IMMTYPE_I           3'b001
`define CPU5_IMMTYPE_S           3'b010
`define CPU5_IMMTYPE_B           3'b011
`define CPU5_IMMTYPE_U           3'b100
`define CPU5_IMMTYPE_J           3'b101


// I-type imm
`define CPU5_IMM_HIGH            31
`define CPU5_IMM_LOW             20
`define CPU5_IMM_SIZE            12

`define CPU5_I_IMM_HIGH          31
`define CPU5_I_IMM_LOW           20
`define CPU5_I_IMM_SIZE          12

// S-type imm
`define CPU5_S_IMM2_HIGH         31
`define CPU5_S_IMM2_LOW          25
`define CPU5_S_IMM1_HIGH         11
`define CPU5_S_IMM1_LOW           7
`define CPU5_S_IMM_SIZE          12 

// B-type imm
`define CPU5_B_IMM_BIT12         31
`define CPU5_B_IMM_BIT11          7
`define CPU5_B_IMM2_HIGH         30
`define CPU5_B_IMM2_LOW          25
`define CPU5_B_IMM1_HIGH         11
`define CPU5_B_IMM1_LOW           8
`define CPU5_B_IMM_SIZE          12

`define CPU5_OPCODE_HIGH          6
`define CPU5_OPCODE_LOW           0
`define CPU5_OPCODE_SIZE          7


// Branch 
`define CPU5_BRANCHTYPE_SIZE      3

// BRANCHTYPE similar to funct3, use 3'b010 as nobranch
`define CPU5_BRANCHTYPE_NOBRANCH  3'b010

`define CPU5_BRANCHTYPE_BEQ       3'b000
`define CPU5_BRANCHTYPE_BNE       3'b001
// ...
