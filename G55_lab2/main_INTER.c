#include <stdio.h>

#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/pushbuttons.h"

int main(){
	// set up timer and button interrupt
	HPS_TIM_config_t hps_tim; // initialize timer
	int_setup(2, (int []){199, 73}); // 199 for reset, 73 for insert key
	int start = 0;
	int count0 = 0;
	int count1 = 0;
	int count2 = 0;
  	int count3 = 0;
 	int count4 = 0; 
	int count5 = 0;
    
    
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
    
	HPS_TIM_config_ASM(&hps_tim);
    
	HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0);
    
    
	while(1){		
		enable_PB_INT_ASM(PB0|PB1|PB2);
		if(start){
			if(hps_tim0_int_flag){	// time out
				hps_tim0_int_flag = 0;	
				count0++;
				if(count0 == 10){
					count0 = 0;
					count1++;
				}
				if(count1 == 10){
					count1 = 0;
					count2++;
				}
				if(count2 == 10){
					count2 = 0;
					count3++;
				}
				if(count3 == 6){
					count3 = 0;
					count4++;
				}
				if(count4 == 10){
					count4 = 0;
					count5++;
				}
				if(count5 == 6){
					count5 = 0;
				}
				HEX_write_ASM(HEX0, count0);
				HEX_write_ASM(HEX1, count1);
				HEX_write_ASM(HEX2, count2);
				HEX_write_ASM(HEX3, count3);
				HEX_write_ASM(HEX4, count4);
				HEX_write_ASM(HEX5, count5);
			}
		}
		if(button_interrupt_flag == 0){	// when not interrupted
			start = 1;
		}
		if(button_interrupt_flag == 1){	// when interrupted
			start = 0;
			while(1){
				if(button_interrupt_flag == 0 || button_interrupt_flag == 2){	
					start = 1;
					break;
				}
			}	
		}
		if(button_interrupt_flag == 2){	// if 2, reset
			count0 = 0;
			count1 = 0;
			count2 = 0;
			count3 = 0;
			count4 = 0;
			count5 = 0;
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);	
		}
	}
	return 0;
}