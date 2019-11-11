			.text
			.equ PIXEL, 0xC8000000
			.equ CHAR, 0xC9000000
			.global VGA_clear_charbuff_ASM
			.global VGA_clear_pixelbuff_ASM
			.global VGA_write_char_ASM
			.global VGA_write_byte_ASM
			.global VGA_draw_point_ASM

VGA_clear_charbuff_ASM:
			LDR R0, =CHAR
			MOV R2, #0			// counter for x
			MOV R3, #0			// counter for y
			MOV R4, #0			// used to clear

XLOOP1:
			CMP R2, #80			// compare R2 with 80
			BGE updateY1		// if R2 >= 80, go to updateY
			LDR R0, =CHAR		// R0 is at the location of (0, 0)
			LSL R5, R3, #7		// e.g. 00000001 -> 01000000 add one to y's corresponding address
			ORR R0, R5, R0		// bit addition of R5 to address R0
			ORR R0, R2, R0		// bit addition of R2 to the updated address R0
			STRB R4, [R0]		// clear 8 bits
			ADD R2, R2, #1		// add R2 by 1
			B XLOOP1			// recursive

checkY1:
			CMP R3, #60			// compare R3 with 60
			BXGE LR				// exit
			B XLOOP1			// back to XLOOP

updateY1:
			MOV R2, #0			// reset R2 to 0
			ADD R3, R3, #1		// add R3 by 1
			B checkY1			// go to checkY

VGA_clear_pixelbuff_ASM:
			LDR R0, =PIXEL
			MOV R2, #0			// counter for x
			MOV R3, #0			// counter for y
			MOV R4, #0			// used to clear

XLOOP2:
			CMP R2, #320		// compare R2 with 320
			BGE updateY2		// if R2 >= 80, go to updateY
			LDR R0, =PIXEL		// R0 is at the location of (0, 0)
			LSL R5, R3, #10		// e.g. 0000000001 -> 1000000000 add one to y's corresponding address
			LSL R6, R2, #1		// E.G. 01 -> 10, add 1 to x's corresponding address
			ORR R0, R5, R0		// bit addition of R5 to address R0
			ORR R0, R6, R0		// bit addition of R6 to the updated address R0
			STRH R4, [R0]		// clear 16 bits
			ADD R2, R2, #1		// add R2 by 1
			B XLOOP2			// recursive

checkY2:
			CMP R3, #240		// compare R3 with 240
			BXGE LR				// exit
			B XLOOP2			// back to XLOOP

updateY2:
			MOV R2, #0			// reset R2 to 0
			ADD R3, R3, #1		// add R3 by 1
			B checkY2			// go to checkY

VGA_write_char_ASM:
			CMP R0, #0			// make sure the range of x is [0, 79]
			BXLT LR				
			CMP R0, #80
			BXGE LR
			CMP R1, #0			// make sure the range of y is [0, 60]
			BXLT LR
			CMP R1, #60
			BXGE LR
			LDR R3, =CHAR		// R3 is the address of [0, 0]
			LSL R4, R1, #7		// e.g. 00000001 -> 01000000 add one to y's corresponding address
			ORR R3, R3, R0		// bit addition of R0 to address R3
			ORR R3, R3, R4		// bit addition of R4 to the updated address R3
			STRB R2, [R3]		// store bit char into current address location
			BX LR				// exit

VGA_write_byte_ASM:
			CMP R0, #0			// make sure the range of x is [0, 79]
			BXLT LR				
			CMP R0, #80
			BXGE LR
			CMP R1, #0			// make sure the range of y is [0, 59]
			BXLT LR
			CMP R1, #60
			BXGE LR
			LDR R3, =CHAR		// R3 is the address of [0, 0]
			LSL R4, R1, #7		// e.g. 00000001 -> 01000000 add one to y's corresponding address
			ORR R3, R3, R0		// bit addition of R0 to address R3
			ORR R3, R3, R4		// bit addition of R4 to the updated address R3
			MOV R5, R2			// R5 = R2
			LSR R5, #4			// get the first 4 bits of character
			CMP R5, #9			
			ADDLE R5, R5, #48	// ASCII character 48 to 57 represents 0 to 9
			ADDGT R5, R5, #65	// ASCII character 65 to 70 represents A to F (10 to 15)
			STRB R5, [R3]		// store bits of R5 into the current address
			
			ADD R0, R0, #1		// next location
			CMP R0, #80			// compare x with 80
			MOVGE R0, #0
			ADDGE R1, R1, #1
			CMP R1, #60			// compare y with 60
			BXGE LR
			MOV R5, R2
			AND R5, R5, #0xF	// get the second character bits
			LDR R3, =CHAR		// R3 is the address of [0, 0]
			LSL R4, R1, #7		// e.g. 00000001 -> 01000000 add one to y's corresponding address
			ORR R3, R3, R0		// bit addition of R0 to address R3
			ORR R3, R3, R4		// bit addition of R4 to the updated address R3
			CMP R5, #9			
			ADDLE R5, R5, #48	// ASCII character 48 to 57 represents 0 to 9
			ADDGT R5, R5, #65	// ASCII character 65 to 70 represents A to F (10 to 15)
			STRB R5, [R3]		// store bits of R5 into the current address
			BX LR

VGA_draw_point_ASM:
			CMP R0, #0			// make sure the range of x is [0, 319]
			BXLT LR				
			CMP R0, #320
			BXGE LR
			CMP R1, #0			// make sure the range of y is [0, 239]
			BXLT LR
			CMP R1, #240
			BXGE LR
			LDR R3, =PIXEL		// R3 is the address of [0, 0]
			LSL R4, R1, #10		// e.g. 0000000001 -> 1000000000 add one to y's corresponding address
			LSL R5, R0, #1		// E.G. 01 -> 10, add 1 to x's corresponding address
			ORR R3, R3, R5		// bit addition of R5 to address R3
			ORR R3, R3, R4		// bit addition of R4 to the updated address R3
			STRH R2, [R3]		// store bit char into current address location
			BX LR				// exit

			.end
