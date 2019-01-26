//Switch address in r0
mvi r0, 0x10
mvhi r0, 0x10

//LEDR address in r1
mvi r1, 0x00
mvhi r1, 0x10

//HEX address in r2
mvi r2, 0x20
mvhi r2, 0x10

//Counter in r3
mvi r3, 0xFF
mvhi r3, 0x00

inf_loop: 
	st r3, r2
	ld r6,r0
	st r6, r1
	
	//counter incriment
	addi r3, 1
	
	cmpi r6, 1
	jz slower
	
	cmpi r6, 3
	jz faster
	
	slower:
	mvi r4, 0xFF
	mvhi r4, 0xFF
	j count_loop
	
	faster:
	mvi r4, 0xFF
	mvhi r4, 0x00
	
count_loop:
	subi r4, 1
	cmpi r4, 0
	jz inf_loop
	j count_loop

	
inf: j inf