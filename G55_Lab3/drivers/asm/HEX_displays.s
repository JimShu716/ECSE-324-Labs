          .text   
		  .equ HEX03, 0xFF200020
		  .equ HEX45, 0xFF200030
          .global HEX_clear_ASM
          .global HEX_flood_ASM
          .global HEX_write_ASM

HEX_clear_ASM: 				
			LDR R1, =HEX03 // store address of HEX0-3 to R1
			MOV R3, #1	 // R3 = 1, use for comparison
			MOV R4, #0	 // set counter to 0
			
clear03:  
			CMP R4, #4	 // since there are only 4 HEXes in this address, we process the loop 4 times
			BGE setup45     // go to check HEX4-5 if all HE0-3 have been checked
			TST R0, R3	 // convert R0 and R3 to binary number and AND them bit by bit 
			BNE clear1		 // if not equal to 0, go to clear1
			LSL R3, R3, #1 // left shift comparison value (one-hot encoding)
			ADD R4, R4, #1 // update counter
			B clear03      // go back to check the next HEX
			
clear1:	  
			ADD R5, R4, R1 // get the current HEX location
			MOV R6, #0     // set R6 to 0			
			STRB R6, [R5]	 // clear the location by setting all bits to 0
			LSL R3, R3, #1 // left shift comparison value (one-hot encoding)
			ADD R4, R4, #1 // update counter
			B clear03      // check the next HEX location
			
setup45:   
			LDR R2, =HEX45 // store address of HEX4-5 to R2
			MOV R4, #0	 // reset counter
			
clear45:  
			CMP R4, #2	 // since there are only 2 HEXes in this address, we process the loop 2 times			
			BXGE LR	     	 // exit
			TST R0, R3	 // convert R0 and R3 to binary number and AND them bit by bit 
			BNE clear2	 // if not equal to 0, go to clear2
			LSL R3, R3, #1 // left shift comparison value
			ADD R4, R4, #1 // update counter
			B clear45	// go back to check the next HEX
			
clear2:	  
			ADD R5, R4, R2 // get the current HEX location
			MOV R6, #0	// set R6 to 0
			STRB R6, [R5]	 // clear the location by setting all bits to 0
			LSL R3, R3, #1 // left shift the comparison value
			ADD R4, R4, #1 // update counter
			B clear45      // check the next HEX location
					
HEX_flood_ASM:
			LDR R1, =HEX03 	// store address of HEX0-3 to R1
			MOV R3, #1	 // R3 = 1, use for comparison 
			MOV R4, #0	 // set counter to 0
			
flood03:  
			CMP R4, #4	 // since there are only 4 HEXes in this address, we process the loop 4 times
			BGE setUP45     // go to check HEX4-5 if all HE0-3 have been checked
			TST R0, R3	 // convert R0 and R3 to binary number and AND them bit by bit 
			BNE flood1		 // if not equal to 0, go to flood1
			LSL R3, R3, #1 // left shift comparison value (one-hot encoding)
			ADD R4, R4, #1 // update counter
			B clear03      // go back to check the next HEX
			
flood1:	  
			ADD R5, R4, R1 // get the current HEX location
			MOV R6, #255   // set R6 to 11111111	
			STRB R6, [R5]  // flood the location by setting all bits to 1
			LSL R3, R3, #1 // left shift the comparison value
			ADD R4, R4, #1 // update the counter
			B flood03      // check the next HEX location
			
setUP45:    
			LDR R2, =HEX45 // store address of HEX4-5 to R2
			MOV R4, #0     // initialize the counter to 0
			
flood45:  
			CMP R4, #2	 // since there are only 2 HEXes in this address, we process the loop 2 times
			BXGE LR		// exit
			TST R0, R3     // convert R0 and R3 to binary number and AND them bit by bit
			BNE flood2     // if not equal to 0, go to flood2
			LSL R3, R3, #1 // left shift the comparison value
			ADD R4, R4, #1 // update counter
			B flood45      // go back to check the next HEX
flood2:	  
			ADD R5, R4, R2 // get the current HEX location
			MOV R6, #255   // set R6 to 11111111 
			STRB R6, [R5]  // flood the location by setting all bits to 1
			LSL R3, R3, #1 // left shift the comparison value
			ADD R4, R4, #1 // update the counter
			B flood45      // check the next HEX location
		  
HEX_write_ASM:         // R0 is destination and R1 is wanted value

check0:   
			LDR R2, =HEX03 // store address of HEX0-3 to R2
			LDR R3, =HEX45 // store address of HEX4-5 to R3
			MOV R4, #1     // R4 = 1, use for comparison
			MOV R5, #0     // set counter to 0
			CMP R1, #0   // check if the wanted value is 0
			BNE check1   // if not, go to check1
			MOV R1, #63  // the code we need is 0111111, to show 0
			B write
check1:   
			CMP R1, #1   // check if the wanted value is 1
			BNE check2   // if not, go to check2
			MOV R1, #6   // the code we need is 0000110, to show 1
			B write
check2:   
			CMP R1, #2   // check if the wanted value is 2
			BNE check3   // if not, go to check3
			MOV R1, #91  // the code we need is 1011011, to show 2
			B write
check3:   
			CMP R1, #3   // check if the wanted value is 3
			BNE check4   // if not, go to check4
			MOV R1, #79  // the code we need is 1001111, to show 3
			B write
check4:   
			CMP R1, #4   // check if the wanted value is 4
			BNE check5   // if not, go to check5
			MOV R1, #102 // the code we need is 0111111, to show 4
			B write
check5:   
			CMP R1, #5   // check if the wanted value is 5
			BNE check6   // if not, go to check6
			MOV R1, #109 // the code we need is 1101101, to show 5
			B write
check6:   
			CMP R1, #6   // check if the wanted value is 6
			BNE check7   // if not, go to check7
			MOV R1, #125 // the code we need is 1111101, to show 6
			B write
check7:   
			CMP R1, #7   // check if the wanted value is 7
			BNE check8   // if not, go to check8
			MOV R1, #39  // the code we need is 0100111, to show 7
			B write
check8:   
			CMP R1, #8   // check if the wanted value is 8
			BNE check9   // if not, go to check9
			MOV R1, #127 // the code we need is 1111111, to show 8
			B write
check9:   
			CMP R1, #9   // check if the wanted value is 9
			BNE checkA   // if not, go to check10
			MOV R1, #111 // the code we need is 1101111, to show 9
			B write
check10:   
			CMP R1, #10  // check if the wanted value is A
			BNE checkB   // if not, go to check11
			MOV R1, #119 // the code we need is 1110111, to show A
			B write
check11:   
			CMP R1, #11  // check if the wanted value is B
			BNE checkC   // if not, go to check12
			MOV R1, #124 // the code we need is 1111100, to show b
			B write
check12:   
			CMP R1, #12  // check if the wanted value is C
			BNE checkD   // if not, go to check13
			MOV R1, #57  // the code we need is 0111001, to show C
			B write
check13:   
			CMP R1, #13  // check if the wanted value is D
			BNE checkE   // if not, go to check14
			MOV R1, #94  // the code we need is 1011110, to show d
			B write
check14:   
			CMP R1, #14  // check if the wanted value is E
			BNE checkF   // if not, go to check15
			MOV R1, #121 // the code we need is 1111001, to show E
			B write
check15:   
			CMP R1, #15  // check if the wanted value is F
			BNE END2
			MOV R1, #113 // the code we need is 1110001, to show F
			B write		  
write:	  
			CMP R5, #4	  // since there are only 4 HEXes in this address, we process the loop 4 times 
			BGE END1	      // go to check HEX4-5 if all HE0-3 have been checked
			TST R0, R4	  // convert R0 and R4 to binary number and AND them bit by bit 
			BNE write03	  // go to write03 if not equal to 0, needs update
			LSL R4, R4, #1  // left shift the comparison value
			ADD R5, R5, #1  // update the counter
			B write		  // go back to check the next HEX
write03:  
			ADD R6, R5, R2  // get the current HEX location
			STRB R1, [R6]	  // set R6 to value of R1 bit by bit
			LSL R4, R4, #1  // left shift the comparison value
			ADD R5, R5, #1  // update the counter
			B write		  // check the next HEX location
END1:	  	MOV R5, #0	  // reset the counter
write2:	  
			CMP R5, #2	  // since there are only 2 HEXes in this address, we process the loop 2 times
			BXGE LR		  // exit
			TST R0, R4	  // convert R0 and R4 to binary number and AND them bit by bit 
			BNE write45	  // go to write45 if not equal to 0, needs update
			LSL R4, R4, #1  // left shift the compaison value
			ADD R5, R5, #1  // update the counter
			B write2		  // go back to check the next HEX
write45:  
			ADD R6, R5, R3  // get the current HEX location
			STRB R1, [R6]	  // set R6 to value of R1 bit by bit
			LSL R4, R4, #1  // left shift the comparison value
			ADD R5, R5, #1  // update the counter
			B write		  // check the next HEX location
END2:		BX LR			// exit
          
			.end
