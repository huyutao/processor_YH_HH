onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /icache_tb/CLK
add wave -noupdate -radix binary /icache_tb/nRST
add wave -noupdate -radix binary /icache_tb/dcif/ihit
add wave -noupdate -radix binary /icache_tb/dcif/imemREN
add wave -noupdate -radix binary /icache_tb/dcif/imemload
add wave -noupdate -radix binary /icache_tb/dcif/imemaddr
add wave -noupdate -radix binary /icache_tb/cif/iwait
add wave -noupdate -radix binary /icache_tb/cif/iREN
add wave -noupdate -radix binary /icache_tb/cif/iload
add wave -noupdate -radix binary /icache_tb/cif/iaddr
add wave -noupdate /icache_tb/DUT/state
add wave -noupdate /icache_tb/DUT/frame
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65 ns} 0}
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
WaveRestoreZoom {108 ns} {195 ns}
