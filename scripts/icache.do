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
add wave -noupdate -radix binary -childformat {{{/icache_tb/cif/iaddr[31]} -radix binary} {{/icache_tb/cif/iaddr[30]} -radix binary} {{/icache_tb/cif/iaddr[29]} -radix binary} {{/icache_tb/cif/iaddr[28]} -radix binary} {{/icache_tb/cif/iaddr[27]} -radix binary} {{/icache_tb/cif/iaddr[26]} -radix binary} {{/icache_tb/cif/iaddr[25]} -radix binary} {{/icache_tb/cif/iaddr[24]} -radix binary} {{/icache_tb/cif/iaddr[23]} -radix binary} {{/icache_tb/cif/iaddr[22]} -radix binary} {{/icache_tb/cif/iaddr[21]} -radix binary} {{/icache_tb/cif/iaddr[20]} -radix binary} {{/icache_tb/cif/iaddr[19]} -radix binary} {{/icache_tb/cif/iaddr[18]} -radix binary} {{/icache_tb/cif/iaddr[17]} -radix binary} {{/icache_tb/cif/iaddr[16]} -radix binary} {{/icache_tb/cif/iaddr[15]} -radix binary} {{/icache_tb/cif/iaddr[14]} -radix binary} {{/icache_tb/cif/iaddr[13]} -radix binary} {{/icache_tb/cif/iaddr[12]} -radix binary} {{/icache_tb/cif/iaddr[11]} -radix binary} {{/icache_tb/cif/iaddr[10]} -radix binary} {{/icache_tb/cif/iaddr[9]} -radix binary} {{/icache_tb/cif/iaddr[8]} -radix binary} {{/icache_tb/cif/iaddr[7]} -radix binary} {{/icache_tb/cif/iaddr[6]} -radix binary} {{/icache_tb/cif/iaddr[5]} -radix binary} {{/icache_tb/cif/iaddr[4]} -radix binary} {{/icache_tb/cif/iaddr[3]} -radix binary} {{/icache_tb/cif/iaddr[2]} -radix binary} {{/icache_tb/cif/iaddr[1]} -radix binary} {{/icache_tb/cif/iaddr[0]} -radix binary}} -subitemconfig {{/icache_tb/cif/iaddr[31]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[30]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[29]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[28]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[27]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[26]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[25]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[24]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[23]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[22]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[21]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[20]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[19]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[18]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[17]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[16]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[15]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[14]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[13]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[12]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[11]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[10]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[9]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[8]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[7]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[6]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[5]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[4]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[3]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[2]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[1]} {-height 17 -radix binary} {/icache_tb/cif/iaddr[0]} {-height 17 -radix binary}} /icache_tb/cif/iaddr
add wave -noupdate /icache_tb/DUT/state
add wave -noupdate /icache_tb/DUT/frame
add wave -noupdate -expand /icache_tb/DUT/iaddr
add wave -noupdate -expand /icache_tb/DUT/frame
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85 ns} 0}
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
WaveRestoreZoom {42 ns} {129 ns}
