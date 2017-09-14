onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/zero_f
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/overflow_f
add wave -noupdate -color Yellow -itemcolor Yellow /system_tb/DUT/CPU/DP/cuif/i_hit
add wave -noupdate -color Yellow -itemcolor Yellow /system_tb/DUT/CPU/DP/cuif/d_hit
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/pc_next
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/alu_op
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/i_ren
add wave -noupdate -color Yellow -itemcolor Yellow /system_tb/DUT/CPU/DP/cuif/ru_dren_out
add wave -noupdate -color Yellow -itemcolor Yellow /system_tb/DUT/CPU/DP/cuif/ru_dwen_out
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/wen
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/imm16
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/j_addr26
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/shamt
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/lui
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/W_mux
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ExtOP
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -divider memctr
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -expand -group memctr /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -divider {register file}
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/data
add wave -noupdate -divider {request unit}
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/i_hit
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/d_hit
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/cu_dren_out
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/cu_dwen_out
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/d_ren
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/d_wen
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {232217 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1068 ns}
