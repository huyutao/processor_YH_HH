onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate -divider data_path
add wave -noupdate /memory_control_tb/dcif/halt
add wave -noupdate /memory_control_tb/dcif/ihit
add wave -noupdate -color Yellow -itemcolor Yellow /memory_control_tb/dcif/imemREN
add wave -noupdate /memory_control_tb/dcif/imemload
add wave -noupdate /memory_control_tb/dcif/imemaddr
add wave -noupdate /memory_control_tb/dcif/dhit
add wave -noupdate -color Yellow -itemcolor Yellow /memory_control_tb/dcif/dmemREN
add wave -noupdate -color Yellow -itemcolor Yellow /memory_control_tb/dcif/dmemWEN
add wave -noupdate /memory_control_tb/dcif/dmemload
add wave -noupdate /memory_control_tb/dcif/dmemstore
add wave -noupdate /memory_control_tb/dcif/dmemaddr
add wave -noupdate -divider caches
add wave -noupdate /memory_control_tb/cif/iwait
add wave -noupdate /memory_control_tb/cif/dwait
add wave -noupdate /memory_control_tb/cif/iREN
add wave -noupdate /memory_control_tb/cif/dREN
add wave -noupdate /memory_control_tb/cif/dWEN
add wave -noupdate /memory_control_tb/cif/iload
add wave -noupdate /memory_control_tb/cif/dload
add wave -noupdate /memory_control_tb/cif/dstore
add wave -noupdate /memory_control_tb/cif/daddr
add wave -noupdate /memory_control_tb/cif/iaddr
add wave -noupdate -divider memory_control
add wave -noupdate /memory_control_tb/ccif/iwait
add wave -noupdate /memory_control_tb/ccif/dwait
add wave -noupdate /memory_control_tb/ccif/iREN
add wave -noupdate /memory_control_tb/ccif/dREN
add wave -noupdate /memory_control_tb/ccif/dWEN
add wave -noupdate /memory_control_tb/ccif/iload
add wave -noupdate /memory_control_tb/ccif/dload
add wave -noupdate /memory_control_tb/ccif/dstore
add wave -noupdate /memory_control_tb/ccif/iaddr
add wave -noupdate /memory_control_tb/ccif/daddr
add wave -noupdate /memory_control_tb/ccif/ramWEN
add wave -noupdate /memory_control_tb/ccif/ramREN
add wave -noupdate /memory_control_tb/ccif/ramstate
add wave -noupdate /memory_control_tb/ccif/ramaddr
add wave -noupdate /memory_control_tb/ccif/ramstore
add wave -noupdate /memory_control_tb/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116308 ps} 0}
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
WaveRestoreZoom {0 ps} {189 ns}
