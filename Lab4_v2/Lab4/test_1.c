#define switches (volatile char*) 0x0002030
#define leds (char*) 0x0002020
//#define top_level_component_0 (voletile char*) 0x0002000
#define mode (int *) 0x00002000
#define status (int *) 0x00002004
#define go (int *) 0x00002008
#define line_start (int *) 0x0000200C
#define line_end (int *) 0x00002010
#define line_col (int *) 0x00002014
#define y_inc 0x0200 
#include <stdio.h> 

void main() { 	
int i; 	
int old_start = 0x0080; 	
int old_end = 0x00ff; 	 	

while (1){ 		
*line_start = old_start; 		
*line_end = old_end; 		 		 		

if(((*switches) & 0b00001000)){ 			

old_start += y_inc; 			

old_end += y_inc; 		
} 		

else 		{ 			

old_start -= y_inc; 			

old_end -= y_inc; 		
} 		 		

if(((*switches) & 0b00010000)){

*mode = 1;
} 		

else {
*mode = 0;
} 		 		

*line_col = 0x00000000; 		
*go = 1; 			 		

while (*status == 0x00); 		

//for(i = 0; i < 10000; i++); 		 		
*line_start = old_start; 		
*line_end = old_end; 		
*line_col = *switches; 		
*go = 1; 		 		

while (*status == 0x00); 
		
for(i = 0; i < 100000; i++); 	

} 	 

}
