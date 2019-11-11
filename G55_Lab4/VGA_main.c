#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"

void test_char() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++)
		for(x = 0; x <= 79; x++)
			VGA_write_byte_ASM(x, y, c++);
}

void test_byte() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++)
		for(x = 0; x <= 79; x += 3)
			VGA_write_byte_ASM(x, y, c++);
}

void test_pixel() {
	int x, y;
	unsigned short colour = 0;

	for(y = 0; y <= 239; y++)
		for(x = 0; x <= 319; x++)
			VGA_draw_point_ASM(x, y, colour++);
}

int main() {
	while(1) {
		if (PB_data_is_pressed_ASM(read_PB_data_ASM()) == 0) {
			int sw = read_slider_switches_ASM();
			if(sw != 0) {
				test_byte();
			}
			else { 
				test_char();
			}
		}
		if (PB_data_is_pressed_ASM(read_PB_data_ASM()) == 1) {
			test_pixel();
		}
		if (PB_data_is_pressed_ASM(read_PB_data_ASM()) == 2) {
			VGA_clear_charbuff_ASM();
		}
		if (PB_data_is_pressed_ASM(read_PB_data_ASM()) == 3) {
			VGA_clear_pixelbuff_ASM();
		}
	}
	return 0;
}
