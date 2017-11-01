onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bus_controller_tb/CLK
add wave -noupdate /bus_controller_tb/nRST
add wave -noupdate /bus_controller_tb/ccif/ramWEN
add wave -noupdate /bus_controller_tb/ccif/ramREN
add wave -noupdate /bus_controller_tb/ccif/ramstate
add wave -noupdate /bus_controller_tb/ccif/ramaddr
add wave -noupdate /bus_controller_tb/ccif/ramstore
add wave -noupdate /bus_controller_tb/ccif/ramload
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/iwait
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/dwait
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/iREN
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/dREN
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/dWEN
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/iload
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/dload
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/dstore
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/iaddr
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/daddr
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/ccwait
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/ccinv
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/ccwrite
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/cctrans
add wave -noupdate -group c0 /bus_controller_tb/ccif/cif0/ccsnoopaddr
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/iwait
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/dwait
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/iREN
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/dREN
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/dWEN
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/iload
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/dload
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/dstore
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/iaddr
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/daddr
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/ccwait
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/ccinv
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/ccwrite
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/cctrans
add wave -noupdate -group c1 /bus_controller_tb/ccif/cif1/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34266 ps} 0}
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
WaveRestoreZoom {0 ps} {131250 ps}
