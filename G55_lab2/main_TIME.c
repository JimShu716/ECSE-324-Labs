#include <stdio.h>

#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/address_map_arm.h"


int main(){
	HPS_TIM_config_t hps_tim0, hps_tim1;
	int start = 0;	// 0 => do not start, 1 => start
	int digit0 = 0;
 	int digit1 = 0; 
	int digit2 = 0; 
	int digit3 = 0; 
	int digit4 = 0; 
	int digit5 = 0;	// initialize the counts
    
    
	hps_tim0.tim = TIM0;
	hps_tim0.timeout = 10000; // 10^-6 s, 10^-6 * 10^4 = 10^-2 => 10 millisec 
	hps_tim0.LD_en = 1;
	hps_tim0.INT_en = 1;
	hps_tim0.enable = 1;
    
    
	hps_tim1.tim = TIM1;
	hps_tim1.timeout = 5000; // poll the pushbutton edgecapture register
	hps_tim1.LD_en = 1;
	hps_tim1.INT_en = 1;
	hps_tim1.enable = 1;
    
    
	HPS_TIM_config_ASM(&hps_tim0);
	HPS_TIM_config_ASM(&hps_tim1);
	HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0); //set all to 0
	
	while(1){
		if(start){ // start when start == 1
			if(HPS_TIM_read_INT_ASM(TIM0)){	// get the count
				HPS_TIM_clear_INT_ASM(TIM0);
				digit0++;               // base increment
				if(digit0 == 10){		// increment to 10, 0.1s
					digit0 = 0;
					digit1++;
				}
				if(digit1 == 10){	    // increment to 10, 1s
					digit1 = 0;
					digit2++;
				}
				if(digit2 == 10){	    // increment to 10, 10s
					digit2 = 0;
					digit3++;
				}
				if(digit3 == 6){         // increment to 6, 1min
					digit3 = 0;
					digit4++;
				}
				if(digit4 == 10){        // increment to 10, 10min
					digit4 = 0;
					digit5++;
				}
				if(digit5 == 6){         // increment to 6, 1hr
					digit5 = 0;
				}
				// write the digits to displays
				HEX_write_ASM(HEX0, digit0);
				HEX_write_ASM(HEX1, digit1);
				HEX_write_ASM(HEX2, digit2);
				HEX_write_ASM(HEX3, digit3);
				HEX_write_ASM(HEX4, digit4);
				HEX_write_ASM(HEX5, digit5);	
			}
		}
		// read buttons
		if(HPS_TIM_read_INT_ASM(TIM1)){	
			HPS_TIM_clear_INT_ASM(TIM1);
			if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 0)	 // button0 pressed => start
				start = 1;
			else if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 1) // button1 pressed => stop
				start = 0;	
			if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 2){ // button2 pressed => clear 
				HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0); //set all to 0
				start = 0;
				digit0 = 0;
 				digit1 = 0; 
				digit2 = 0; 
				digit3 = 0; 
				digit4 = 0; 
				digit5 = 0;

			}
		}
	}
	return 0;
}
