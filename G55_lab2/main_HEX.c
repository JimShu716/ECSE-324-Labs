#include <stdio.h>
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"

int main() {
	while(1){
		int SW = read_slider_switches_ASM();
		write_LEDs_ASM(SW);
		if (SW >= 512) {
			HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5);
		} else {
		HEX_flood_ASM(HEX4|HEX5);
		switch(PB_data_is_pressed_ASM(read_PB_data_ASM())){
			case 0:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX0, SW);	// write value on HEX0
				break;
			case 1:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX1, SW);	// write value on HEX1
				break;
			case 2:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX2, SW);	// write value on HEX2
				break;
			case 3:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX3, SW);	// write value on HEX3
				break;	
			}
		}
	}

	return 0;
}
