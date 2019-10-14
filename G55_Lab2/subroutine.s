			.text
			.global _start

_start:
			LDR R4, =RESULT     // R4 points to the result location
			LDR R2, [R4, #4]    // R2 holds the number of element in the list
			ADD R3, R4, #8      // R3 points to the first number
			LDR R0, [R3]        // R0 holds the first number in the list


LOOP: 		
			SUBS R2, R2, #1		// decrement the loop counter
			BEQ DONE            // end loop if counter has reached 0
			ADD R3, R3, #4      // R3 points to next number in the list
			LDR R1, [R3]        // R1 holds the next number in the list
			BL CHECKMIN			// exit to CHECKMIN and leave a link register
			B LOOP              // branch back to the loop

CHECKMIN: 
			PUSH {LR}			// push link register in a stack
			CMP R0, R1          // check if R0 is greater than R1
			BGE UPDATEMIN		// if R0 >= R1, go to UPDATEMIN loop
			POP {LR}			// pop out the link register
			BX LR				// return from function call / go back to the address stored by LR

UPDATEMIN:
			MOV R0, R1			// set the value of R1 to R0 (which is smaller)
			POP {LR}			// pop out the link register
			BX LR				// return from function call / go back to the address stored by LR

DONE: 		STR R0, [R4]       	// store the result to the memory location


END: 		B END               // infinite loop!

RESULT:		.word 	0       	// memory assigned for the result location
N: 			.word	3           // number of entries in the list
NUMBERS: 	.word	3, -5, 1  	// the list data
