onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group RAM /system_tb/DUT/CPU/scif/memstore
add wave -noupdate /system_tb/DUT/RAM/CLK
add wave -noupdate /system_tb/DUT/RAM/nRST
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group memory_control /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -group memory_control /system_tb/DUT/CPU/CC/state
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate /system_tb/DUT/CPU/CM0/ICACHE/CLK
add wave -noupdate /system_tb/DUT/CPU/CM0/ICACHE/nRST
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/iwait
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/dwait
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/iREN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/dREN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/dWEN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/iload
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/dload
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/dstore
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/iaddr
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/daddr
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/ccwait
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/ccwrite
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/cctrans
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/l_frame
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/r_frame
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/i
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/hit
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/next_frame
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/state
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/frame
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/next_state
add wave -noupdate -group CM0.icache /system_tb/DUT/CPU/CM0/ICACHE/iaddr
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/hit
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/i
add wave -noupdate -group CM0.dcache -radix binary /system_tb/DUT/CPU/CM0/DCACHE/daddr
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/snoop_addr
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_l_frame
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_r_frame
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_state
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/flush_i
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_flush_i
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/hit_cnt
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_hit_cnt
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/clean_l_dirty
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/clean_r_dirty
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_l_valid
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/next_r_valid
add wave -noupdate -group CM0.dcache /system_tb/DUT/CPU/CM0/DCACHE/j
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/halt
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/ihit
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/imemREN
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/imemload
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/imemaddr
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dmemREN
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dmemWEN
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/flushed
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dmemload
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dmemstore
add wave -noupdate -group CM0.dcif /system_tb/DUT/CPU/CM0/dcif/dmemaddr
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/iwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/iREN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dREN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dWEN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/iload
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dload
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dstore
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/iaddr
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/daddr
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/ccwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/ccwrite
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/cctrans
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -group CM1 -expand /system_tb/DUT/CPU/CM1/DCACHE/l_frame
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/r_frame
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/i
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/hit
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/next_frame
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/state
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/next_state
add wave -noupdate -group CM1.icache /system_tb/DUT/CPU/CM1/ICACHE/iaddr
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/hit
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/miss
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/i
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/daddr
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/snoop_addr
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_l_frame
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_r_frame
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_state
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/flush_i
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_flush_i
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/hit_cnt
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_hit_cnt
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/clean_l_dirty
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/clean_r_dirty
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_l_valid
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/next_r_valid
add wave -noupdate -group CM1.dcache /system_tb/DUT/CPU/CM1/DCACHE/j
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/halt
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/ihit
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/imemREN
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/imemload
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/imemaddr
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dmemREN
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dmemWEN
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/flushed
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dmemload
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dmemstore
add wave -noupdate -group CM1.dcif /system_tb/DUT/CPU/CM1/dcif/dmemaddr
add wave -noupdate -group DP0 -expand /system_tb/DUT/CPU/DP0/RF/data
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/dmemaddr_i3
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/dmemaddr_o3
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/imemload_i1
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/imemload_o1
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/dmemstore_i3
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/EM/em/dmemstore_o3
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/RF/data
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/dmemaddr_i3
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/dmemaddr_o3
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/imemload_i1
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/imemload_o1
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/dmemstore_i3
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/EM/em/dmemstore_o3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5364667 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 103
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
WaveRestoreZoom {4906468 ps} {5907788 ps}
