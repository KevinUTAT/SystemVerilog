
start:
mvi r0, 0x10
mvhi r0, 0x10
ld r1, r0

mvi r3, 0x20
mvhi r3 , 0x10
st r1, r3

mvi r4, 0x00
mvhi r4, 0x10
mvi r5, 0x00
st r5, r4

cmpi r1, 0
jz start

mvi r4, 0x00
mvhi r4, 0x10
mvi r2, 0x0f
st r2, r4

j start