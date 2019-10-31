#include <stdio.h>

#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/pushbuttons.h"

int main(){
	// set up timer and button interrupt
	HPS_TIM_config_t hps_tim; // initialize timer
	int_setup(2, (int []){199, 73}); // 199 is Interrupt ID for HPS Timer 0, 73 for FPGA Pushbutton KEYs
	int start = 0;
	int digit0 = 0;
	int digit1 = 0;
	int digit2 = 0;
  	int digit3 = 0;
 	int digit4 = 0; 
	int digit5 = 0;
    
    
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
    
	HPS_TIM_config_ASM(&hps_tim);
	enable_PB_INT_ASM(PB0|PB1|PB2);
    
	HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0);
    
    
	while(1){		
		if(start){
			if(hps_tim0_int_flag){	
				hps_tim0_int_flag = 0;	
				digit0++;
				if(digit0 == 10){
					digit0 = 0;
					digit1++;
				}
				if(digit1 == 10){
					digit1 = 0;
					digit2++;
				}
				if(digit2 == 10){
					digit2 = 0;
					digit3++;
				}
				if(digit3 == 6){
					digit3 = 0;
					digit4++;
				}
				if(digit4 == 10){
					digit4 = 0;
					digit5++;
				}
				if(digit5 == 6){
					digit5 = 0;
				}
				HEX_write_ASM(HEX0, digit0);
				HEX_write_ASM(HEX1, digit1);
				HEX_write_ASM(HEX2, digit2);
				HEX_write_ASM(HEX3, digit3);
				HEX_write_ASM(HEX4, digit4);
				HEX_write_ASM(HEX5, digit5);
			}
		}
		if(button_interrupt_flag == 1){	// when not interrupted
			start = 1;
		}
		if(button_interrupt_flag == 2){	// when interrupted
			start = 0;	
		}
		if(button_interrupt_flag == 4){	// if 2, reset
			digit0 = 0;
			digit1 = 0;
			digit2 = 0;
			digit3 = 0;
			digit4 = 0;
			digit5 = 0;
			HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0); //set all to 0	
			start = 0;
		}
	}
	return 0;
}
