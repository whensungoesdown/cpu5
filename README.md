# cpu5

A simple single cycle RISC-V 32I CPU

The following instructions are implemented

LW 
SW 
ADD 
SUB
ADDI 
BEQ 
BNE 
JALR

### It can run simple stuff



``````````
	0:		00000293		addi x5 x0 0
	4:		00000313		addi x6 x0 0
	8:		06400393		addi x7 x0 100

0000000c <loop>:
	c:		00130313		addi x6 x6 1
	10:		006282b3		add x5 x5 x6
	14:		fe731ce3		bne x6 x7 -8 <loop>
	18:		04502823		sw x5 80(x0)
	1c:		00000013		nop
	20:		00000013		nop
	24:		01800113		addi x2 x0 24
	28:		018100e7		jalr x1 x2 24
	2c:		00000013		nop
	30:		05000293		addi x5 x0 80
	34:		0012a223		sw x1 4(x5)
	38:		ffc00313		addi x6 x0 -4
	3c:		406282b3		sub x5 x5 x6
	40:		0012a423		sw x1 8(x5)

00000044 <halt>:
	44:		00000013		nop
	48:		fe000ee3		beq x0 x0 -4 <halt>

``````````
