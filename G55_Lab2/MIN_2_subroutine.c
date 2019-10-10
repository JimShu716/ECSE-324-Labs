extern	int	MIN_2(int	x,	int	y);
int	 main()	{
		int	a[5] = {1,20,3,4,5};
		int min_val =0;				//initialize the minimum value
		int temp = 0;			
		int i;             
		for (i=0;i<5;i++){
			temp = MIN_2(a[i],a[i+1]);
			if(temp<min_val){
					min_val = temp;
				}
			}
return	min_value;
}