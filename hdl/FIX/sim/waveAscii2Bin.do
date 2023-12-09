onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbascii2bin/TM
add wave -noupdate /tbascii2bin/TT
add wave -noupdate /tbascii2bin/RstB
add wave -noupdate /tbascii2bin/Clk
add wave -noupdate -expand -group Input /tbascii2bin/AsciiDataGenRecOut.AsciiDataGenVal
add wave -noupdate -expand -group Input /tbascii2bin/AsciiDataGenRecOut.AsciiDataGenSop
add wave -noupdate -expand -group Input /tbascii2bin/AsciiDataGenRecOut.AsciiDataGenEop
add wave -noupdate -expand -group Input -radix hexadecimal /tbascii2bin/AsciiDataGenRecOut.AsciiDataGen
add wave -noupdate -expand -group Output /tbascii2bin/BinOutVal
add wave -noupdate -expand -group Output /tbascii2bin/BinOutNegativeExp
add wave -noupdate -expand -group Output -radix unsigned /tbascii2bin/BinOutData
add wave -noupdate -expand -group Internal /tbascii2bin/u_Ascii2Bin/rAsciiInValFF
add wave -noupdate -expand -group Internal -radix unsigned /tbascii2bin/u_Ascii2Bin/rAscii2BinNumMap
add wave -noupdate -expand -group Internal /tbascii2bin/u_Ascii2Bin/rAscii2BinCtrl
add wave -noupdate -expand -group Internal /tbascii2bin/u_Ascii2Bin/rBinOutVal
add wave -noupdate -expand -group Internal -radix unsigned /tbascii2bin/u_Ascii2Bin/rAsc2BinData
add wave -noupdate -expand -group Internal -radix unsigned /tbascii2bin/u_Ascii2Bin/rBinOutNegativeExp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1733600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 400
configure wave -valuecolwidth 114
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
WaveRestoreZoom {1610600 ps} {2152900 ps}
