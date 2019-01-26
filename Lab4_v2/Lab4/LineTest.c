#define switches (volatile char*) 0x0002030
#define leds (char*) 0x0002020
#define mode (int *) 0x00002000
#define status (int *) 0x00002004
#define go (int *) 0x00002008
#define line_start (int *) 0x0000200C
#define line_end (int *) 0x00002010
#define line_col (int *) 0x00002014

#include <stdio.h>

void main(){
	int SW_temp = *switches;
	while (1) {
		int y_inc;
		
		
		if (((*switches) & 0b00010000)) *mode = 1;
		else *mode = 0;
		*line_start = 0x00000;
		*line_end = 0x0014f;
		*line_col = *switches;
		*go = 0x0000;
		
		*leds = *mode;
		
		
		//while (*status == 0x00); 		
		
		
		int y_counter = 0;
		int temp_start = 0x00000;
		int temp_end = 0x0014f;
		int temp_go = 0x0001;
		int y_counter_temp;
		if (*mode) {
			//unsigned  i;
			//for (i = 0; i < 22; i ++);
			while (*status == 0x01); 
		}
		
		while (y_counter < 209 & y_counter >= 0) {
			
			if (((*switches) & 0b00010000)) *mode = 1;
			else *mode = 0;
			
			if (*switches & 0b1000) y_inc = -1;
			else y_inc = 1;
			
			temp_go += 1;
			*line_col = 0x0000;
			*line_start = temp_start;
			*line_end = temp_end;
			*go = temp_go;
			
			y_counter_temp = y_counter + y_inc;
			y_counter = y_counter_temp;
			
			unsigned i;
			if (*mode) {
				//for (i = 0; i < 22; i ++);
				while (*status == 0x01);
			}
			
			temp_start += 512 * y_inc;
			temp_end += 512 * y_inc;
			temp_go += 1;
			
			*line_col = *switches;
			*line_start = temp_start;
			*line_end = temp_end;
			*go = temp_go;
			
			for (i = 0; i < 185185; i ++);
			
			if (y_counter <= 0 & y_inc == -1) {
				temp_go += 1;
				*line_col = 0x0000;
				*line_start = temp_start;
				*line_end = temp_end;
				*go = temp_go;
				
				y_counter = 208; 
				temp_start = 0x1a000;
				temp_end = 0x1a14f;
			}
			
		}
		
		temp_go += 1;
		*line_col = 0x0000;
		*line_start = temp_start;
		*line_end = temp_end;
		*go = temp_go;
		if (*mode) {
			//unsigned  i;
			//for (i = 0; i < 22; i ++);
			while (*status == 0x01); 
		}
	}
}
	