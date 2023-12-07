onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbmuxencoder/TM
add wave -noupdate /tbmuxencoder/TT
add wave -noupdate /tbmuxencoder/RstB
add wave -noupdate /tbmuxencoder/Clk
add wave -noupdate -expand -group Input -expand -group {In 0} /tbmuxencoder/InMuxStart0
add wave -noupdate -expand -group Input -expand -group {In 0} /tbmuxencoder/InMuxTransEn0
add wave -noupdate -expand -group Input -expand -group {In 0} /tbmuxencoder/InMuxDecPointEn0
add wave -noupdate -expand -group Input -expand -group {In 0} /tbmuxencoder/InMuxNegativeExp0
add wave -noupdate -expand -group Input -expand -group {In 0} -radix hexadecimal /tbmuxencoder/InMuxData0
add wave -noupdate -expand -group Input -expand -group {In 1} /tbmuxencoder/InMuxStart1
add wave -noupdate -expand -group Input -expand -group {In 1} /tbmuxencoder/InMuxTransEn1
add wave -noupdate -expand -group Input -expand -group {In 1} /tbmuxencoder/InMuxDecPointEn1
add wave -noupdate -expand -group Input -expand -group {In 1} /tbmuxencoder/InMuxNegativeExp1
add wave -noupdate -expand -group Input -expand -group {In 1} -radix hexadecimal /tbmuxencoder/InMuxData1
add wave -noupdate -expand -group Output -expand -group {Out 0} /tbmuxencoder/OutMuxReq0
add wave -noupdate -expand -group Output -expand -group {Out 0} /tbmuxencoder/OutMuxVal0
add wave -noupdate -expand -group Output -expand -group {Out 0} /tbmuxencoder/OutMuxEop0
add wave -noupdate -expand -group Output -expand -group {Out 0} -radix hexadecimal /tbmuxencoder/OutMuxData0
add wave -noupdate -expand -group Output -expand -group {Out 1} /tbmuxencoder/OutMuxReq1
add wave -noupdate -expand -group Output -expand -group {Out 1} /tbmuxencoder/OutMuxVal1
add wave -noupdate -expand -group Output -expand -group {Out 1} /tbmuxencoder/OutMuxEop1
add wave -noupdate -expand -group Output -expand -group {Out 1} -radix hexadecimal /tbmuxencoder/OutMuxData1
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rCtrlMux0
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rCtrlMux1
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rEncoderStart
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rEncoderInReady
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rEncoderData0
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } /tbmuxencoder/u_MuxEncoder/rEncoderNegativeExp0
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } /tbmuxencoder/u_MuxEncoder/rEncoderDecPointEn0
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rEncoderData1
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } /tbmuxencoder/u_MuxEncoder/rEncoderNegativeExp1
add wave -noupdate -expand -group Internal -expand -group {Data Input signal } /tbmuxencoder/u_MuxEncoder/rEncoderDecPointEn1
add wave -noupdate -expand -group Internal -expand -group {Out encoder} -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rEncoderOutData0
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutReq0
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutVal0
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutEop0
add wave -noupdate -expand -group Internal -expand -group {Out encoder} -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rEncoderOutData1
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutReq1
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutVal1
add wave -noupdate -expand -group Internal -expand -group {Out encoder} /tbmuxencoder/u_MuxEncoder/rEncoderOutEop1
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rOutMuxBusy
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rOutMuxSel
add wave -noupdate -expand -group Internal -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rOutMuxData0
add wave -noupdate -expand -group Internal -radix hexadecimal /tbmuxencoder/u_MuxEncoder/rOutMuxData1
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rOutMuxReq
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rOutMuxVal
add wave -noupdate -expand -group Internal /tbmuxencoder/u_MuxEncoder/rOutMuxEop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1367600 ps} 0}
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
WaveRestoreZoom {1270900 ps} {1317 ns}
