#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include <stdio.h>
#include <math.h>

int amplitude = 5;
float frequency[8] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};
int keyboard[8] = {0, 0, 0, 0, 0, 0, 0, 0};

int signal (double f, int t) {
	double multiplication;
	double table;
	double decimal;
	double sig;
	double integer;
	multiplication = f * t;
	decimal = modf(multiplication, &integer);
	integer = (int)integer % 48000;
	table = (1 - decimal) * sine[(int)integer] + decimal * sine[(int)integer + 1];
	sig = amplitude * table;
	return sig;
}

int signalSum (int number) {
	int i;
	double sum = 0;
	for (i = 0; i < 8; i++) {
		sum = sum + signal(frequency[i] , number);
	}
	return sum;
}

int main() {
	HPS_TIM_config_t hps_tim; // initialize timer
	int_setup(2, (int []){199, 73}); // 199 is Interrupt ID for HPS Timer 0, 73 for FPGA Pushbutton KEYs
	hps_tim.tim = TIM0;
	hps_tim.timeout = 20;		// unit is in mus and 1/48000 = 20.83, but this config is in int so we choose 20
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
    
	HPS_TIM_config_ASM(&hps_tim);
	double sum;
	int counter = 0;
	while(1) {
		sum = signalSum(counter);
		audio_write_data_ASM((int)sum, (int)sum);
		counter++;
		if(counter == 4800) counter = 0;
	}

	return 0;
}
