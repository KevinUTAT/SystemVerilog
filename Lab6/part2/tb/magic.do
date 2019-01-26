vlog ../cpu/ALU.sv
vlog ../cpu/control_masterline.sv
vlog ../cpu/data_masterline.sv
vlog ../cpu/reg_file.sv
vlog ../cpu/cpu.sv
vlog tb.sv
vsim tb

add wave -position end  sim:/tb/clk
add wave -position end  sim:/tb/reset
add wave -position end  sim:/tb/o_mem_addr
add wave -position end  sim:/tb/o_mem_rd
add wave -position end  sim:/tb/i_mem_rddata
add wave -position end  sim:/tb/o_mem_wr
add wave -position end  sim:/tb/o_mem_wrdata
add wave -position end  sim:/tb/i_mem_wait
add wave -position end  sim:/tb/i_mem_rddatavalid
add wave -position end  sim:/tb/dut/CPU_control/opCode
add wave -position end  sim:/tb/dut/CPU_control/state
add wave -position end  sim:/tb/dut/CPU_data/PC
add wave -position end  sim:/tb/dut/CPU_data/IR
add wave -position end  sim:/tb/dut/CPU_data/Rx
add wave -position end  sim:/tb/dut/CPU_data/Ry
add wave -position end  sim:/tb/dut/CPU_data/imm8
add wave -position end  sim:/tb/dut/CPU_data/imm11
add wave -position end  sim:/tb/dut/CPU_data/tempReg1
add wave -position end  sim:/tb/dut/CPU_data/tempReg2
add wave -position end  sim:/tb/dut/CPU_data/RF/addr
add wave -position end  sim:/tb/dut/CPU_data/RF/rd_wr
add wave -position end  sim:/tb/dut/CPU_data/RF/data_in
add wave -position end  sim:/tb/dut/CPU_data/RF/data_out
add wave -position end  sim:/tb/dut/CPU_data/RF/R0
add wave -position end  sim:/tb/dut/CPU_data/RF/R1
add wave -position end  sim:/tb/dut/CPU_data/RF/R2
add wave -position end  sim:/tb/dut/CPU_data/RF/R3
add wave -position end  sim:/tb/dut/CPU_data/RF/R4
add wave -position end  sim:/tb/dut/CPU_data/N
add wave -position end  sim:/tb/dut/CPU_data/Z
add wave -position 28  sim:/tb/dut/CPU_data/RF/R5
add wave -position 29  sim:/tb/dut/CPU_data/RF/R6
add wave -position 30  sim:/tb/dut/CPU_data/RF/R7
