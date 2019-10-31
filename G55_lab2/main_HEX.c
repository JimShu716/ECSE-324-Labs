#include <stdio.h>
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"

int main() {
	while(1){
		int sw = read_slider_switches_ASM();
		write_LEDs_ASM(sw);
		if (sw == 512) {
			HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5);
		} else {
		HEX_flood_ASM(HEX4|HEX5);
		HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
		switch(PB_data_is_pressed_ASM(read_PB_data_ASM())){		    // get button number that is pressed
			case 0:
				HEX_write_ASM(HEX0, sw);	// display on HEX 0
				break;
			case 1:
				HEX_write_ASM(HEX1, sw);	// display on HEX 1
				break;
			case 2:
				HEX_write_ASM(HEX2, sw);	// display on HEX 2
				break;
			case 3:
				HEX_write_ASM(HEX3, sw);	// display on HEX 3
				break;	
			}
		}
	}

	return 0;
}
