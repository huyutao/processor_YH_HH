onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -expand -group caches /dcache_tb/cif/dwait
add wave -noupdate -expand -group caches /dcache_tb/cif/dREN
add wave -noupdate -expand -group caches /dcache_tb/cif/dWEN
add wave -noupdate -expand -group caches /dcache_tb/cif/dload
add wave -noupdate -expand -group caches /dcache_tb/cif/dstore
add wave -noupdate -expand -group caches /dcache_tb/cif/daddr
add wave -noupdate -expand -group Processor /dcache_tb/dcif/halt
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dhit
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dmemREN
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dmemWEN
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dmemload
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dmemstore
add wave -noupdate -expand -group Processor /dcache_tb/dcif/dmemaddr
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/daddr
add wave -noupdate -expand -group {state machine} -expand /dcache_tb/DUT/l_frame
add wave -noupdate -expand -group {state machine} -expand /dcache_tb/DUT/r_frame
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_l_frame
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_r_frame
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/state
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_state
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/lru
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_lru
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/flush_i
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_flush_i
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/hit_cnt
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/next_hit_cnt
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/hit
add wave -noupdate /dcache_tb/DUT/dcf/ccwait
add wave -noupdate /dcache_tb/DUT/dcf/ccinv
add wave -noupdate /dcache_tb/DUT/dcf/ccwrite
add wave -noupdate /dcache_tb/DUT/dcf/cctrans
add wave -noupdate /dcache_tb/DUT/dcf/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {542 ns} 0}
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
WaveRestoreZoom {488 ns} {680 ns}
