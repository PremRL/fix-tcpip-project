onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbarpproc/TM
add wave -noupdate /tbarpproc/TT
add wave -noupdate /tbarpproc/RstB
add wave -noupdate /tbarpproc/Clk
add wave -noupdate -expand -group Input -radix hexadecimal /tbarpproc/u_ArpProc/SenderMACAddr
add wave -noupdate -expand -group Input -radix hexadecimal /tbarpproc/u_ArpProc/SenderIpAddr
add wave -noupdate -expand -group Input -radix hexadecimal /tbarpproc/u_ArpProc/TargetIpAddr
add wave -noupdate -expand -group Input /tbarpproc/u_ArpProc/ArpMacReq
add wave -noupdate -expand -group Output -radix hexadecimal /tbarpproc/TargetMACAddr
add wave -noupdate -expand -group Output /tbarpproc/TargetMACAddrVal
add wave -noupdate -expand -group Processor -radix hexadecimal /tbarpproc/u_ArpProc/RxArpTGMacAddr
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/RxArpOpCode
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/RxArpVal
add wave -noupdate -expand -group Processor -radix unsigned /tbarpproc/u_ArpProc/rTimeOut
add wave -noupdate -expand -group Processor -radix unsigned /tbarpproc/u_ArpProc/rAddrValCnt
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rAddrVal
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rReplyEn
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rRequestEn
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rOptionCode
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rArpGenOp
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rArpGenReq
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/TxArpBusy
add wave -noupdate -expand -group Processor -radix hexadecimal /tbarpproc/u_ArpProc/rTargetMACAddr
add wave -noupdate -expand -group Processor /tbarpproc/u_ArpProc/rTargetMACAddrVal
add wave -noupdate -expand -group {Tx Arp} /tbarpproc/u_ArpProc/u_TxArp/TxArpBusy
add wave -noupdate -expand -group {Tx Arp} /tbarpproc/u_ArpProc/u_TxArp/OptionCode
add wave -noupdate -expand -group {Tx Arp} /tbarpproc/u_ArpProc/u_TxArp/ArpGenReq
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rMACAddr
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rIpAddr
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rAddrCnt
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rArpReq
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rArpOutAddr
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rChSel0
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rChSel1
add wave -noupdate -expand -group {Tx Arp} -expand -group Internal /tbarpproc/u_ArpProc/u_TxArp/rTxArpBusy
add wave -noupdate -expand -group {Tx Arp} -expand -group {Tx Output} -radix hexadecimal /tbarpproc/u_ArpProc/u_TxArp/DataOut
add wave -noupdate -expand -group {Tx Arp} -expand -group {Tx Output} /tbarpproc/u_ArpProc/u_TxArp/DataOutVal
add wave -noupdate -expand -group {Tx Arp} -expand -group {Tx Output} /tbarpproc/u_ArpProc/u_TxArp/DataOutSop
add wave -noupdate -expand -group {Tx Arp} -expand -group {Tx Output} /tbarpproc/u_ArpProc/u_TxArp/DataOutEop
add wave -noupdate -group {Rx Arp} /tbarpproc/u_ArpProc/u_RxArp/MacRstB
add wave -noupdate -group {Rx Arp} /tbarpproc/u_ArpProc/u_RxArp/RxMacClk
add wave -noupdate -group {Rx Arp} -expand -group {Rx Input} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/DataIn
add wave -noupdate -group {Rx Arp} -expand -group {Rx Input} /tbarpproc/u_ArpProc/u_RxArp/DataInValid
add wave -noupdate -group {Rx Arp} -expand -group {Rx Input} /tbarpproc/u_ArpProc/u_RxArp/RxSOP
add wave -noupdate -group {Rx Arp} -expand -group {Rx Input} /tbarpproc/u_ArpProc/u_RxArp/RxEOP
add wave -noupdate -group {Rx Arp} -expand -group {Rx Input} /tbarpproc/u_ArpProc/u_RxArp/RxError
add wave -noupdate -group {Rx Arp} -expand -group {Rx Output} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/RxTargetMACAddr
add wave -noupdate -group {Rx Arp} -expand -group {Rx Output} /tbarpproc/u_ArpProc/u_RxArp/RxArpOpCode
add wave -noupdate -group {Rx Arp} -expand -group {Rx Output} /tbarpproc/u_ArpProc/u_RxArp/RxArpVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rDataInFF
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rDataInValFF
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rDataInSopFF
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rDataInEopFF
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} -radix unsigned /tbarpproc/u_ArpProc/u_RxArp/rRxByteCnt
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxDecodeEn
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rRxSDMacAddr
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rRxTGMacAddr
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rRxSDIpAddr
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rRxTGIpAddr
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxOptionCode
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxEnetTypeVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxHardTypeVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxOperationVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxProtTypeVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxHlenVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxPlenVal
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxError
add wave -noupdate -group {Rx Arp} -group {Mac clk domain} /tbarpproc/u_ArpProc/u_RxArp/rRxArpValid
add wave -noupdate -group {Rx Arp} -group {Mac to User} /tbarpproc/u_ArpProc/u_RxArp/rDataValidALat
add wave -noupdate -group {Rx Arp} -group {Mac to User} /tbarpproc/u_ArpProc/u_RxArp/rDataValidBLat
add wave -noupdate -group {Rx Arp} -group {Mac to User} /tbarpproc/u_ArpProc/u_RxArp/rDataValidBLatA
add wave -noupdate -group {Rx Arp} -group {User clk domain} /tbarpproc/u_ArpProc/u_RxArp/rUserDataValid
add wave -noupdate -group {Rx Arp} -group {User clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rUserSDMacAddr
add wave -noupdate -group {Rx Arp} -group {User clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rUserTGMacAddr
add wave -noupdate -group {Rx Arp} -group {User clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rUserSDIpAddr
add wave -noupdate -group {Rx Arp} -group {User clk domain} -radix hexadecimal /tbarpproc/u_ArpProc/u_RxArp/rUserTGIpAddr
add wave -noupdate -group {Rx Arp} -group {User clk domain} /tbarpproc/u_ArpProc/u_RxArp/rUserOptionCode
add wave -noupdate -group {Rx Arp} -group {User clk domain} /tbarpproc/u_ArpProc/u_RxArp/rUserIpVal
add wave -noupdate -group {Rx Arp} -group {User clk domain} /tbarpproc/u_ArpProc/u_RxArp/rUserSDMacVal
add wave -noupdate -group {Rx Arp} -group {User clk domain} /tbarpproc/u_ArpProc/u_RxArp/rUserRxArpValid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3427900 ps} 0}
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
WaveRestoreZoom {0 ps} {2980400 ps}
