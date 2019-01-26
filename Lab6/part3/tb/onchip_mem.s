
mvi r6, 0x00 	// r6 is the counter value, initialize to 0

start:
// get the speed of counter
// witch is a 8 bit munber from the SW
mvi r0, 0x10	// r0 is the address of SW
mvhi r0, 0x10
ld r1, r0
//mvhi r1, 0xff	// base delay

// load r6 into display
mvi r0, 0x20
mvhi r0, 0x10
st r6, r0


mvi r4, 0x00
delay1:
mvi r5, 0xff	// this is a delay counter
mvhi r5, 0xff
delay0:
subi r5, 1
cmpi r5, 0
jz delay0
addi r4, 1
cmp r4, r1
jn delay1

mvi r3, 0xff
mvhi r3, 0xff
delay2:
subi r3, 1
cmpi r3, 0
jz delay2


counter:
addi r6, 1

j start


