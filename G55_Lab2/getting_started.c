#include <stdio.h>
int main(){
			
		int a[5] = {1, 20, 3, 4, 5};	// array of numbers
		int min_val = a[0];			// initialize the minimum value
		int i;						// pointer to search for the minimum value
		for(i = 0; i < 5; i++) {
			if (a[i] < min_val){
				min_val = a[i];		//update the minimum value
			}
		}
	printf("The minimum value is %d\n", min_val);
	return min_val;	

}
