onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbrxarp/TM
add wave -noupdate /tbrxarp/TT
add wave -noupdate /tbrxarp/MacRstB
add wave -noupdate /tbrxarp/MacClk
add wave -noupdate -expand -group Input -radix hexadecimal /tbrxarp/u_RxArp/DataIn
add wave -noupdate -expand -group Input /tbrxarp/u_RxArp/DataInValid
add wave -noupdate -expand -group Input /tbrxarp/u_RxArp/RxSOP
add wave -noupdate -expand -group Input /tbrxarp/u_RxArp/RxEOP
add wave -noupdate -expand -group Input /tbrxarp/u_RxArp/RxError
add wave -noupdate -expand -group Output -radix hexadecimal /tbrxarp/RxTargetMACAddr
add wave -noupdate -expand -group Output /tbrxarp/RxArpOpCode
add wave -noupdate -expand -group Output /tbrxarp/RxArpVal
add wave -noupdate -group Internal -radix hexadecimal /tbrxarp/u_RxArp/rDataInFF
add wave -noupdate -group Internal /tbrxarp/u_RxArp/rDataInValFF
add wave -noupdate -group Internal /tbrxarp/u_RxArp/rDataInSopFF
add wave -noupdate -group Internal /tbrxarp/u_RxArp/rDataInEopFF
add wave -noupdate -group Internal -expand -group Decode /tbrxarp/u_RxArp/rRxDecodeEn
add wave -noupdate -group Internal -expand -group Decode -radix hexadecimal /tbrxarp/u_RxArp/rRxSDMacAddr
add wave -noupdate -group Internal -expand -group Decode -radix hexadecimal /tbrxarp/u_RxArp/rRxTGMacAddr
add wave -noupdate -group Internal -expand -group Decode -radix hexadecimal /tbrxarp/u_RxArp/rRxSDIpAddr
add wave -noupdate -group Internal -expand -group Decode -radix hexadecimal /tbrxarp/u_RxArp/rRxTGIpAddr
add wave -noupdate -group Internal -expand -group Decode /tbrxarp/u_RxArp/rRxOptionCode
add wave -noupdate -group Internal -expand -group Valid -radix unsigned /tbrxarp/u_RxArp/rRxByteCnt
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxEnetTypeVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxHardTypeVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxProtTypeVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxHlenVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxPlenVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxOperationVal
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxError
add wave -noupdate -group Internal -expand -group Valid /tbrxarp/u_RxArp/rRxArpValid
add wave -noupdate /tbrxarp/RstB
add wave -noupdate /tbrxarp/Clk
add wave -noupdate -expand -group {Mac to User} /tbrxarp/u_RxArp/rDataValidALat
add wave -noupdate -expand -group {Mac to User} /tbrxarp/u_RxArp/rDataValidBLat
add wave -noupdate -group {User Domain} /tbrxarp/u_RxArp/rUserDataValid
add wave -noupdate -group {User Domain} -expand -group Addr -radix hexadecimal /tbrxarp/u_RxArp/rUserSDMacAddr
add wave -noupdate -group {User Domain} -expand -group Addr -radix hexadecimal /tbrxarp/u_RxArp/rUserTGMacAddr
add wave -noupdate -group {User Domain} -expand -group Addr -radix hexadecimal /tbrxarp/u_RxArp/rUserSDIpAddr
add wave -noupdate -group {User Domain} -expand -group Addr -radix hexadecimal /tbrxarp/u_RxArp/rUserTGIpAddr
add wave -noupdate -group {User Domain} -expand -group Addr /tbrxarp/u_RxArp/rUserOptionCode
add wave -noupdate -group {User Domain} /tbrxarp/u_RxArp/rUserIpVal
add wave -noupdate -group {User Domain} /tbrxarp/u_RxArp/rUserSDMacVal
add wave -noupdate -group {User Domain} /tbrxarp/u_RxArp/rUserRxArpValid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {809000 ps} 0}
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
WaveRestoreZoom {0 ps} {2251300 ps}
