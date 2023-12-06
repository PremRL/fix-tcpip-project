onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbbin2ascii/TM
add wave -noupdate /tbbin2ascii/TT
add wave -noupdate /tbbin2ascii/RstB
add wave -noupdate /tbbin2ascii/Clk
add wave -noupdate -expand -group Input /tbbin2ascii/BinInStart
add wave -noupdate -expand -group Input /tbbin2ascii/BinInDecPointEn
add wave -noupdate -expand -group Input -radix unsigned /tbbin2ascii/BinInNegativeExp
add wave -noupdate -expand -group Input -radix unsigned /tbbin2ascii/BinInData
add wave -noupdate -expand -group Input /tbbin2ascii/AsciiInReady
add wave -noupdate -expand -group Output /tbbin2ascii/AsciiOutReq
add wave -noupdate -expand -group Output /tbbin2ascii/AsciiOutEop
add wave -noupdate -expand -group Output /tbbin2ascii/AsciiOutVal
add wave -noupdate -expand -group Output -radix hexadecimal /tbbin2ascii/AsciiOutData
add wave -noupdate -expand -group Internal /tbbin2ascii/u_Bin2Ascii/rCtrlCal
add wave -noupdate -expand -group Internal /tbbin2ascii/u_Bin2Ascii/rBinInDecPointEn
add wave -noupdate -expand -group Internal -radix unsigned /tbbin2ascii/u_Bin2Ascii/rBinDataCal
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal1
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal2
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal3
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal4
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal5
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal6
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal7
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal8
add wave -noupdate -expand -group Internal -expand -group Cal -radix decimal /tbbin2ascii/u_Bin2Ascii/rBinTempDataCal9
add wave -noupdate -expand -group Internal -radix unsigned /tbbin2ascii/u_Bin2Ascii/rByteCnt
add wave -noupdate -expand -group Internal -radix unsigned /tbbin2ascii/u_Bin2Ascii/rIntByteCnt
add wave -noupdate -expand -group Internal -expand -group Wr -radix hexadecimal /tbbin2ascii/u_Bin2Ascii/rMapBin2AsciiData
add wave -noupdate -expand -group Internal -expand -group Wr -radix unsigned /tbbin2ascii/u_Bin2Ascii/rWrDataCnt
add wave -noupdate -expand -group Internal -expand -group Wr -radix unsigned /tbbin2ascii/u_Bin2Ascii/rWrAddr
add wave -noupdate -expand -group Internal -expand -group Rd -radix unsigned /tbbin2ascii/u_Bin2Ascii/rRdLength
add wave -noupdate -expand -group Internal -expand -group Rd -radix unsigned /tbbin2ascii/u_Bin2Ascii/rRdAddr
add wave -noupdate -expand -group Internal -expand -group Rd /tbbin2ascii/u_Bin2Ascii/rRdRamEn
add wave -noupdate -expand -group Internal /tbbin2ascii/u_Bin2Ascii/rAsciiOutReq
add wave -noupdate -expand -group Internal /tbbin2ascii/u_Bin2Ascii/rAsciiOutEop
add wave -noupdate -expand -group Internal /tbbin2ascii/u_Bin2Ascii/rAsciiOutVal
add wave -noupdate -expand -group Internal -radix hexadecimal /tbbin2ascii/u_Bin2Ascii/rAsciiOutData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {452100 ps} 0}
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
WaveRestoreZoom {105900 ps} {264 ns}
