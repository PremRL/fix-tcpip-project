onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbtxarp/TM
add wave -noupdate /tbtxarp/TT
add wave -noupdate /tbtxarp/RstB
add wave -noupdate /tbtxarp/Clk
add wave -noupdate -expand -group Input -radix hexadecimal /tbtxarp/u_TxArp/SenderMACAddr
add wave -noupdate -expand -group Input -radix hexadecimal /tbtxarp/u_TxArp/TargetMACAddr
add wave -noupdate -expand -group Input -radix hexadecimal /tbtxarp/u_TxArp/SenderIpAddr
add wave -noupdate -expand -group Input -radix hexadecimal /tbtxarp/u_TxArp/TargetIpAddr
add wave -noupdate -expand -group Input /tbtxarp/u_TxArp/OptionCode
add wave -noupdate -expand -group Input /tbtxarp/u_TxArp/ArpGenReq
add wave -noupdate -expand -group Input /tbtxarp/u_TxArp/Ready
add wave -noupdate -expand -group Output -radix hexadecimal /tbtxarp/TxArpBusy
add wave -noupdate -expand -group Output /tbtxarp/Req
add wave -noupdate -expand -group Output -radix hexadecimal /tbtxarp/DataOut
add wave -noupdate -expand -group Output /tbtxarp/DataOutVal
add wave -noupdate -expand -group Output /tbtxarp/DataOutSop
add wave -noupdate -expand -group Output /tbtxarp/DataOutEop
add wave -noupdate -expand -group Internal -expand -group Addr -radix hexadecimal /tbtxarp/u_TxArp/rMACAddr
add wave -noupdate -expand -group Internal -expand -group Addr -radix hexadecimal /tbtxarp/u_TxArp/rIpAddr
add wave -noupdate -expand -group Internal -expand -group Addr /tbtxarp/u_TxArp/rAddrCnt
add wave -noupdate -expand -group Internal /tbtxarp/u_TxArp/rArpReq
add wave -noupdate -expand -group Internal /tbtxarp/u_TxArp/rChSel0
add wave -noupdate -expand -group Internal /tbtxarp/u_TxArp/rChSel1
add wave -noupdate -expand -group Internal -radix unsigned /tbtxarp/u_TxArp/rArpOutAddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1219000 ps} 0}
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
WaveRestoreZoom {1092900 ps} {1376600 ps}
