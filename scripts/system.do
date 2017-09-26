onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/nRST
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group ram /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group {mem control} /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -expand -group pc /system_tb/DUT/CPU/DP/pcif/PC
add wave -noupdate -expand -group pc /system_tb/DUT/CPU/DP/pcif/pc3
add wave -noupdate -expand -group pc /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate -expand -group pc /system_tb/DUT/CPU/DP/pcif/pc_en
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -group i1 /system_tb/DUT/CPU/DP/stif/id_en
add wave -noupdate -group i1 /system_tb/DUT/CPU/DP/stif/npc_i1
add wave -noupdate -group i1 /system_tb/DUT/CPU/DP/stif/imemload_i1
add wave -noupdate -expand -group o1 /system_tb/DUT/CPU/DP/stif/npc_o1
add wave -noupdate -expand -group o1 /system_tb/DUT/CPU/DP/stif/imemload_o1
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/instr
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/zero_sel
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/alu_op
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/d_ren
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/d_wen
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/wsel
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/rsel1
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/rsel2
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/wen
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/imm16
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/j_addr26
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/shamt
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/lui
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/PCSrc
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/W_mux
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/ExtOP
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/flushed
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HU/huif/branch_sel
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/pc_en
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/id_en
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/d_ren
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/pc_src
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/rsel1
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/rsel2
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/wsel
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/npc_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/imemload_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/halt_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/d_ren_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/d_wen_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/wen_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/zero_sel_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/ALUSrc_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/W_mux_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/PCSrc_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/wsel_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/rsel1_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/rsel2_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/LUI_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/ext32_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/rdat1_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/rdat2_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/j_addr26_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/imm16_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/alu_op_i2
add wave -noupdate -group i2 /system_tb/DUT/CPU/DP/stif/shamt_i2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/npc_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/DE/de/hz_flushed
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/imemload_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/halt_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/d_ren_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/d_wen_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/wen_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/zero_sel_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/ALUSrc_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/W_mux_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/PCSrc_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/wsel_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/shamt_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/rsel1_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/rsel2_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/LUI_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/ext32_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/rdat1_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/rdat2_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/j_addr26_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/imm16_o2
add wave -noupdate -expand -group o2 /system_tb/DUT/CPU/DP/stif/alu_op_o2
add wave -noupdate -group fuif /system_tb/DUT/CPU/DP/fuif/forwardA
add wave -noupdate -group fuif /system_tb/DUT/CPU/DP/fuif/forwardB
add wave -noupdate -group fuif /system_tb/DUT/CPU/DP/fuif/store
add wave -noupdate -group fuif /system_tb/DUT/CPU/DP/fuif/ALUSrc
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/zero_flag
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/negative_flag
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/overflow_flag
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/a
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/b
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/out
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/op
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/npc_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/imemload_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/halt_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/d_ren_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/d_wen_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/wen_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/W_mux_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/PCSrc_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/wsel_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/LUI_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/jump_addr_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/branch_addr_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/jr_addr_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/dmemstore_i3
add wave -noupdate -group i3 /system_tb/DUT/CPU/DP/stif/dmemaddr_i3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/npc_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/imemload_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/flushed
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/halt_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/d_ren_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/d_wen_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/wen_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/W_mux_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/PCSrc_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/wsel_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/LUI_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/jump_addr_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/branch_addr_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/jr_addr_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/dmemstore_o3
add wave -noupdate -expand -group o3 /system_tb/DUT/CPU/DP/stif/dmemaddr_o3
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/npc_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/imemload_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/d_ren_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/wen_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/W_mux_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/PCSrc_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/wsel_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/jump_addr_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/branch_addr_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/jr_addr_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/dmemload_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/dmemaddr_i4
add wave -noupdate -group i4 /system_tb/DUT/CPU/DP/stif/LUI_i4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/npc_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/imemload_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/d_ren_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/wen_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/W_mux_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/PCSrc_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/wsel_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/LUI_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/jump_addr_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/branch_addr_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/jr_addr_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/dmemload_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/dmemaddr_o4
add wave -noupdate -group o4 /system_tb/DUT/CPU/DP/stif/wb_en
add wave -noupdate -group {rfif wb} /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group {rfif wb} /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group {rfif wb} /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/RF/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199917 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
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
WaveRestoreZoom {0 ps} {513700 ps}
