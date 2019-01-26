#define switches (volatile char*) 0x0002030
#define leds (char*) 0x0002020
//#define top_level_component_0 (voletile char*) 0x0002000
#define mode (int *) 0x00002000
#define status (int *) 0x00002004
#define go (int *) 0x00002008
#define line_start (int *) 0x0000200C
#define line_end (int *) 0x00002010
#define line_col (int *) 0x00002014

void main(){
	int SW_temp = *switches;
	while (1) {
		*mode = 0;
		*line_start = 0xd2a8;
		*line_end = 0xd6ac;
		*line_col = *switches;
		*go = 0x0000;
		
		//while (*status == 0x00); 		
		
		
		int y_counter = 0;
		int temp_start = 0x0080;
		int temp_end = 0x00ff;
		int temp_go = 0x0000;
		int y_counter_temp;
		while (y_counter < 210) {
			temp_start += 512;
			temp_end += 512;
			temp_go += 1;
			
			*line_start = temp_start;
			*line_end = temp_end;
			*go = temp_go;
			
			y_counter_temp = y_counter + 1;
			y_counter = y_counter_temp;
		}
	}
}
	