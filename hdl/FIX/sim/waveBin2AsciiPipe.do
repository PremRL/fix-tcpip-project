onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbbin2asciipipe/TM
add wave -noupdate /tbbin2asciipipe/TT
add wave -noupdate /tbbin2asciipipe/RstB
add wave -noupdate /tbbin2asciipipe/Clk
add wave -noupdate -expand -group Input /tbbin2asciipipe/BinInStart
add wave -noupdate -expand -group Input /tbbin2asciipipe/BinInData
add wave -noupdate -expand -group Output /tbbin2asciipipe/AsciiOutEop
add wave -noupdate -expand -group Output /tbbin2asciipipe/AsciiOutVal
add wave -noupdate -expand -group Output -radix ascii /tbbin2asciipipe/AsciiOutData
add wave -noupdate -expand -group Internal -expand -group Control /tbbin2asciipipe/u_Bin2AsciiPipe/rCtrlCal
add wave -noupdate -expand -group Internal -expand -group Control /tbbin2asciipipe/u_Bin2AsciiPipe/rCtrlBusy
add wave -noupdate -expand -group Internal -expand -group OutInternal /tbbin2asciipipe/u_Bin2AsciiPipe/rAsciiOutEop
add wave -noupdate -expand -group Internal -expand -group OutInternal /tbbin2asciipipe/u_Bin2AsciiPipe/rAsciiOutVal
add wave -noupdate -expand -group Internal -expand -group OutInternal -radix ascii /tbbin2asciipipe/u_Bin2AsciiPipe/rAsciiOutData
add wave -noupdate -expand -group Internal -expand -group Data -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/r1StDigitTemp
add wave -noupdate -expand -group Internal -expand -group Data -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinData0
add wave -noupdate -expand -group Internal -expand -group Data -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinData1
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal1
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal2
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal3
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal4
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal5
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal6
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal7
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal8
add wave -noupdate -expand -group Internal -expand -group Cal0 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp0Cal9
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal1
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal2
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal3
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal4
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal5
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal6
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal7
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal8
add wave -noupdate -expand -group Internal -expand -group Cal1 -radix unsigned /tbbin2asciipipe/u_Bin2AsciiPipe/rBinTemp1Cal9
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3380900 ps} 0}
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
WaveRestoreZoom {3360900 ps} {3407 ns}
