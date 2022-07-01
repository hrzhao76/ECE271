onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lights_testbench/CLOCK_PERIOD
add wave -noupdate /lights_testbench/clk
add wave -noupdate /lights_testbench/reset
add wave -noupdate -expand /lights_testbench/w
add wave -noupdate -expand /lights_testbench/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {377 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 286
configure wave -valuecolwidth 219
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6271 ps}
