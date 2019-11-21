
#include "./drivers/inc/audio1.h"

int main() {

	int frequency = 100;
	int sample_rate = 48000;
	int half_cycle = sample_rate / (frequency * 2);
	while(1) {
		int i;
		for (i = 0; i< half_cycle; ){
              if(write_audio_ASM(0x00FFFFFF)){
                   i++;}
         }
			for (i = 0; i< half_cycle; ){
              if(write_audio_ASM(0x00000000)){
                   i++;}
         }		
	}

	return 0;
}
