			.text
			.global _start

_start:	
			LDR R4, =N				// R4 points to the N location
			LDR R0, [R4, #4]		// R0 is the first number in the list
			STR R0, [SP, #-4]!		// First SP is subtracted by four
			LDR R0, [R4, #8]		// R0 now is the second number in the list
			STR R0, [SP, #-4]!		// Store R0 at current SP
			LDR R0, [R4, #12]		// R0 is updated to the third number in the list
			STR R0, [SP, #-4]!		// Store R0 at newest SP
			LDR R1, [SP], #4		// First load value in SP to R1, and then add SP by 4
			LDR R2, [SP], #4		// Then load value in SP to R2, and add SP by 4 afterwards
			LDR R3, [SP], #4		// Finally load value in SP to R3, and add SP by 4

END:		B END					// Infinite loop!

N:			.word  3
NUMBER:		.word  -1, 5, 10
