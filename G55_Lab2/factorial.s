			.text
			.global _start

_start:
			LDR R4, =RESULT		// R4 points to the result location
			LDR R2, [R4, #4]	// R2 holds the number of N
			MOV R5, #0			// set R5 to 
			MOV R0, #1			// set R0 to 1

MAIN:		
			CMP R2, R5			// compare R2 with R5
			BEQ DONE			// if R2 equals to 0, go to DONE
			BL SUBROUTINE		// else exit to SUBROUTINE and leave a link register
			SUB R2, R2, #1		// R2 = R2 - 1 
			B MAIN				// back to main loop

SUBROUTINE:	
			PUSH {LR}			// push link register to a stack
			MUL R0, R0, R2		// R0 = R0 * R2
			POP {LR}			// pop link register from the stack
			BX LR				// return to next address where we exit the MAIN loop

DONE:		STR R0, [R4]		// store R0 value in address R4 (RESULT)

END:		B END				// infinite loop!

RESULT:	.word	0
N:		.word	10
