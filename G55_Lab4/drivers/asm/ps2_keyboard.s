	.text
	
	.equ PS2_base, 0xFF200100
	.global read_PS2_data_ASM
	
read_PS2_data_ASM:
	LDR	R1, =PS2_base
	LDRB R2, [R1, #1]
	LSR R2, R2, #7		//extracted RVALID to R2
	CMP R2, #1
	BEQ RVALID
	MOV R0, #0
	BX LR

RVALID:
	LDRB R2, [R1]
	STRB R2, [R0]
	MOV R0, #1
	BX LR

	.end
