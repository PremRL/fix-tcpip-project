onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pksigtbtoe/TM
add wave -noupdate /pksigtbtoe/TT
add wave -noupdate -expand -group System /pksigtbtoe/RstB
add wave -noupdate -expand -group System /pksigtbtoe/Clk
add wave -noupdate -expand -group System /pksigtbtoe/MacRstB
add wave -noupdate -expand -group System /pksigtbtoe/RxMacClk
add wave -noupdate -expand -group {Assigned Input } -group {User Control} /pksigtbtoe/User2TOEConnectReq
add wave -noupdate -expand -group {Assigned Input } -group {User Control} /pksigtbtoe/User2TOETerminateReq
add wave -noupdate -expand -group {Assigned Input } -group {User Tx Input} /tbtoe/u_PkMapTbTOE/u_TOE/User2TOETxDataVal
add wave -noupdate -expand -group {Assigned Input } -group {User Tx Input} /tbtoe/u_PkMapTbTOE/u_TOE/User2TOETxDataSop
add wave -noupdate -expand -group {Assigned Input } -group {User Tx Input} /tbtoe/u_PkMapTbTOE/u_TOE/User2TOETxDataEop
add wave -noupdate -expand -group {Assigned Input } -group {User Tx Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/User2TOETxDataIn
add wave -noupdate -expand -group {Assigned Input } -group {User Tx Input} -radix unsigned /tbtoe/u_PkMapTbTOE/u_TOE/User2TOETxDataLen
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOESenderMACAddr
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOETargetMACAddr
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOESenderIpAddr
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOETargetIpAddr
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOESrcPort
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} -radix hexadecimal /pksigtbtoe/UNG2TOEDesPort
add wave -noupdate -expand -group {Assigned Input } -group {User Network register} /pksigtbtoe/UNG2TOEAddrVal
add wave -noupdate -expand -group {Assigned Input } -expand -group {RxMac Input} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxSOP
add wave -noupdate -expand -group {Assigned Input } -expand -group {RxMac Input} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxValid
add wave -noupdate -expand -group {Assigned Input } -expand -group {RxMac Input} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxEOP
add wave -noupdate -expand -group {Assigned Input } -expand -group {RxMac Input} -radix hexadecimal -childformat {{/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(7) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(6) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(5) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(4) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(3) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(2) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(1) -radix hexadecimal} {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(0) -radix hexadecimal}} -subitemconfig {/tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(7) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(6) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(5) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(4) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(3) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(2) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(1) {-height 15 -radix hexadecimal} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData(0) {-height 15 -radix hexadecimal}} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxData
add wave -noupdate -expand -group {Assigned Input } -expand -group {RxMac Input} /tbtoe/u_PkMapTbTOE/u_TOE/EMAC2TOERxError
add wave -noupdate -expand -group {Assigned Input } /pksigtbtoe/User2TOERxReq
add wave -noupdate -expand -group {Assigned Input } /pksigtbtoe/EMAC2TOETxReady
add wave -noupdate -expand -group Output /pksigtbtoe/TOE2UserTxMemAlFull
add wave -noupdate -expand -group Output -group {User TOE status} /pksigtbtoe/TOE2UserStatus
add wave -noupdate -expand -group Output -group {User TOE status} /pksigtbtoe/TOE2UserPSHFlagset
add wave -noupdate -expand -group Output -group {User TOE status} /pksigtbtoe/TOE2UserFINFlagset
add wave -noupdate -expand -group Output -group {User TOE status} /pksigtbtoe/TOE2UserRSTFlagset
add wave -noupdate -expand -group Output -group {User Rx Data Path } /pksigtbtoe/TOE2UserRxSOP
add wave -noupdate -expand -group Output -group {User Rx Data Path } /pksigtbtoe/TOE2UserRxEOP
add wave -noupdate -expand -group Output -group {User Rx Data Path } /pksigtbtoe/TOE2UserRxValid
add wave -noupdate -expand -group Output -group {User Rx Data Path } -radix hexadecimal /pksigtbtoe/TOE2UserRxData
add wave -noupdate -expand -group Output -expand -group {TxMac Output} /pksigtbtoe/TOE2EMACTxReq
add wave -noupdate -expand -group Output -expand -group {TxMac Output} -radix hexadecimal -childformat {{/pksigtbtoe/TOE2EMACTxDataOut(7) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(6) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(5) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(4) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(3) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(2) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(1) -radix hexadecimal} {/pksigtbtoe/TOE2EMACTxDataOut(0) -radix hexadecimal}} -subitemconfig {/pksigtbtoe/TOE2EMACTxDataOut(7) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(6) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(5) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(4) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(3) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(2) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(1) {-height 15 -radix hexadecimal} /pksigtbtoe/TOE2EMACTxDataOut(0) {-height 15 -radix hexadecimal}} /pksigtbtoe/TOE2EMACTxDataOut
add wave -noupdate -expand -group Output -expand -group {TxMac Output} /pksigtbtoe/TOE2EMACTxDataOutVal
add wave -noupdate -expand -group Output -expand -group {TxMac Output} /pksigtbtoe/TOE2EMACTxDataOutSop
add wave -noupdate -expand -group Output -expand -group {TxMac Output} /pksigtbtoe/TOE2EMACTxDataOutEop
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU sys} /pksigtbtoe/TM
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU sys} /pksigtbtoe/TT
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU sys} /pksigtbtoe/RstB
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU sys} /pksigtbtoe/Clk
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserConnectReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserTerminateReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {UNG2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UNG2TCPAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPUPayloadLen
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPUPayloadReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPUOpReply
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPUInitReady
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPULastData
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Tx2TPUTxCtrlBusy
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} -radix unsigned /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUPayloadLen
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUWinSize
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUFreeSpace
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUAckFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUPshFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPURstFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUSynFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUFinFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUPktValid
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Input} -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/Rx2TPUSeqNumError
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {User TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserStatus
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {User TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserPSHFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {User TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserFINFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {User TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/UserRSTFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxMACSouAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxMACDesAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxMACSouAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxIPSouAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxIPDesAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxSouPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -group TxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxDataOffset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxUrgent
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxSeqNumIndex
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxSeqNumIndexEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxOperations
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxReset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxTxReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Tx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2TxPayloadEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -group RxAddr -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxExpSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxInitFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxDecodeEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxDataTransEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group {TPU Output} -group {TPU2Rx Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/TPU2RxAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UNG2TCPSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UNG2TCPTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UNG2TCPSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UNG2TCPTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UNG2TCPAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserConnectReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {User2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserTerminateReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {RxTPU2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {RxTPU2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlAllRecv
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {TxTPu2State Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlLastSent
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserStatus
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserPSHFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserFINFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/UserRSTFlagset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlStateMach
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlDataEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlRST
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlStateMach
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlDataEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {State2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/CtrlRST
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rState
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rConnecting
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rEstablished
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rClosed
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rTerminating
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rSenderFINSet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rSenderPSHSet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rSenderRSTSet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rCtrlState
add wave -noupdate -expand -group TOE -group TPUTCPTP -group StateCtrl -group {StateCtrl Internel} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rStateCtrl/rTimeout
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPUPayloadLen
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPUPayloadReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPUOpReply
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPUInitReady
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPULastData
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2TPUTxCtrlBusy
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} -group {StateCtrl2TxTPU Addr} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlStateMach
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlDataEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {StateCtrl2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlRST
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPUAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPUSeqNumAcked
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPURecWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPUWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPURetransOption
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPUAckNumUdt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {RxTPU2TxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Rx2TxTPUSeqNumEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxMACSouAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxMACDesAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxIPSouAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxIPDesAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxSouPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxDataOffset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -group {TxTCP Header Gen} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxUrgent
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxSeqNumIndex
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxSeqNumIndexEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxOperations
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxReset
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxTxReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TPU2TxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/TPU2TxPayloadEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU2StateCtrl Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/CtrlLastSent
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU2RxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2RxTPUSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2RxTPUCtrl
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU2RxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/Tx2RxTPURetransEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTx2RxTPURetransEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTx2TPULastDataFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rRx2TxTPUAckNumFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rRx2TxTPUWindowFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rRx2TxTPURetransOptionFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rRx2TxTPUAckNumUdtFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rCtrlStateMach0
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTx2RxTPURetransEnFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUSeqNumInit
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group FlowCtrl -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUExpSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group FlowCtrl -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUWindowCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group FlowCtrl -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUFlowCtrlCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -group FlowCtrl /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUFlowCtrl
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTCPCtrl
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTCPCtrlSel0
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTCPCtrlSel1
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} -radix unsigned /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPURxNakCnt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUInit
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUEstablished
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTCPTerminated
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPURetrans
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUTxReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group TxTPU -group {TxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rTxTPUCtrl/rTxTPUPayloadEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUPayloadLen
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUWinSize
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUFreeSpace
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUAckFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUPshFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPURstFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUSynFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUFinFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUPktValid
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTCP2TPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TPUSeqNumError
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlStateMach
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlRST
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {StateCtrl2RxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TxTPU2RxTPU Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Tx2RxTPUSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TxTPU2RxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Tx2RxTPUCtrl
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TxTPU2RxTPU Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Tx2RxTPURetransEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxSenderMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxTargetMACAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxSenderIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxTargetIpAddr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxExpSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxSrcPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxDesPort
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxInitFlag
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxDecodeEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxDataTransEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {TPU2RxTCP Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/TPU2RxAddrVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUAckNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUSeqNumAcked
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUCSeqNumRet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPURecWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUWindow
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPURetransOption
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUAckNumUdt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2TxTPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/Rx2TxTPUSeqNumEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU2StateCtrl Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/CtrlFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRx2TPUPktValidFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRx2TPUSeqNumErrorFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRx2TPUAckNumFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRx2TPUWinSizeFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -group {FF signal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRx2TPUFreeSpaceFF
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUExpSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUFinPktVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUPktVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rJumpedPktEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rDupACKEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckNumInitEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckNumVal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckPktEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckPktCtrl
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckPktCtrlCnt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckPktRetrans
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckPktRetransFin
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group {Control packet} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCPktRefSeqNum
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group {Control packet} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCPktSet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group {Control packet} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCPktIdent
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group {Control packet} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCPktSeqNumUdt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer -radix unsigned /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCnt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerSet
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerPktAcked
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerExpired
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerAckChangeEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerRst
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCntRst
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCntEn
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCtrlRetransOp
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCtrlSynAcked
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Timer /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rTimerCtrlFinAcked
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Cal -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckNumChangeCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Cal -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rExpSeqNumCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Cal -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCPktRefSeqNumCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} -expand -group Cal -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rAckNumCal
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPURetransReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUAckRetransReq
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUAckNumUdt
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUCtrl0
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPUCtrl1
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCtrlFlags
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rRxTPURecvErr
add wave -noupdate -expand -group TOE -group TPUTCPTP -group RxTPU -group {RxTPU Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TPUTCPIP/u_rRxTPUCtrl/rCtrlRxError
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Sys} /pksigtbtoe/TM
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Sys} /pksigtbtoe/TT
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Sys} /pksigtbtoe/RstB
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Sys} /pksigtbtoe/Clk
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {User2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserDataVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {User2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserDataSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {User2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserDataEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {User2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserDataIn
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {User2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/MACSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/MACDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/IPSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/IPDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/SouPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/DesPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/SeqNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/AckNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/DataOffset
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/Flags
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/Window
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/Urgent
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUAckedSeqnum
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUOperations
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUAckedSeqnumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUReset
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUTxReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TPU2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUPayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Input} -group {TxMac2TxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/EMACReady
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/UserMemAlFull
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TxMac Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/EMACDataOut
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/EMACDataOutVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/EMACDataOutSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/EMACDataOutEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUPayloadLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUPayloadReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUOpReply
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUInitReady
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPULastData
add wave -noupdate -expand -group TOE -group TxTCPIP -group {TxTCP Output} -group {TxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/TPUTxCtrlBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {User2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserDataVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {User2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserDataSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {User2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserDataEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {User2TxQueue Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserDataIn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {User2TxQueue Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUAckedSeqnum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUSeqNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUOperations
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUAckedSeqnumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUReset
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUTxReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TPU2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUPayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {CheckSumCal2TxQueue Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/UserMemAlFull
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUPayloadLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUPayloadReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUOpReply
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPUInitReady
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/TPULastData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CDataIn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CDataVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CDataSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CDataEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue2CheckSumCal Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/Q2CCheckSumEnd
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rUserDataValFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rUserDataEopFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPUOperationsFF0
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rUserMemAlFull
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {FF signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rUserMemAlFullFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueWrAFull
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexWrAFull
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueWrDataEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexWrDataEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueWrSpace
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Write TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexWrSpace
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexRdDataFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rCompLenCal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueRdSpace
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexRdSpace
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read TxQueue} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamQueueRdAble
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read control} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRdCtrl0
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read control} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRdCtrl1
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read control} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRdCtrl2
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Read control} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rReadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Search ram} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRetranIndexCal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Search ram} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRetranBack
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Search ram} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRetranCompEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group {Search ram} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRetranLenCalEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/WrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/WrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/WrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/Init
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/AckVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rRefAddrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/AckNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/RefAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/RdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/RdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rRefData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rRefAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rIndexAckedCal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group RamIndex -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/u_rRamIndex/rIndexAddrCal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPUPayloadLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rPayloadLenFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rPayloadLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPUInitReady
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPULastData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rDetectClose
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPUPayloadReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rTPUOpReply
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group 2ChecksumCal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rQ2CDataSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group 2ChecksumCal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rQ2CDataEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group 2ChecksumCal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rQ2CDataVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxQueue -group {TxQueue Internal} -group 2ChecksumCal -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxQueue/rRamIndexRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CDataIn
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CDataVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CDataSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CDataEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxQueue2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CCheckSumEnd
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxOutCtrl2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Start
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {TxOutCtrl2CheckSumCal Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/PayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxQueue Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/Q2CBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/RamLoadWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/RamLoadWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/RamLoadWrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/PayloadLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/CheckSum
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal2TxOutCtrl Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/CheckSumCalEnd
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rQ2CDataInFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rQ2CDataEopFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rQ2CDataValFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rCheckSum
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rSumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rQ2CBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group CheckSumCal -group {CheckSumCal Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_CheckSumCal/rRamLoadWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/MACSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/MACDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/IPSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/IPDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/SouPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DesPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/SeqNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/AckNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DataOffset
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/Flags
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/Window
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/Urgent
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/TxPayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TPU2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/TxReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {CheckSumCal2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {CheckSumCal2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/CheckSumCalData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {CheckSumCal2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/CheckSumCalEnd
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {CheckSumCal2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamLoadRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {IPHdGen2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamIPHdRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TCPHdGen2TxOutCtrl Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamTCPHdRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxMac2TxOutCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACReady
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/TxBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2CheckSumCal Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamLoadRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2IPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamIPHdRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2IPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/IPSouAddrGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2IPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/IPDesAddrGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/SouPortGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DesPortGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/SeqNumGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/AckNumGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DataOffsetGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/FlagsGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/WindowGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/UrgentGen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/DataChecksum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TCPHdGen Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamTCPHdRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TxMac Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACDataOut
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACDataOutVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACDataOutSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl2TxMac Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/EMACDataOutEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl control output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/CtrlDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl control output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/CtrlStart
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl control output} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/CtrlPayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -group GenData -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rSeqNumGen0
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -group GenData -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rFlagsGen0
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -group GenData -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rSeqNumGen1
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -group GenData /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rFlagsGen1
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataMAC
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamIPHdRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamTCPHdRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/RamLoadRdData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataMACCnt
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rRamIPHdRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rRamTCPHdRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rRamLoadRdAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rCheckSumCalEndLat
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rTxOutStart
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rRdPayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rCheckSumWait
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rTxBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rTxOutBusy
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rChSel0
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rChSel1
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataOut
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataOutVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataOutSop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rDataOutEop
add wave -noupdate -expand -group TOE -group TxTCPIP -group TxOutCtrl -group {TxOutCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TxOutCtrl/rEMACReq
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/IPSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/IPDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/DataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/PayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/Start
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/RamIPHdWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/RamIPHdWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {TxOutCtrl and IPHdGen I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/RamIPHdWrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rRamIPHdWrDataFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rRamIPHdWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rRamIPHdWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rRamIPHdWrAddrFF
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rRamIPHdWrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rTotalLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rIdent
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rHdCheckSum
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rHdCheckSumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group IPHdGen -group {IPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_IPHdGen/rSumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/IPSouAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/IPDesAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/SouPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/DesPort
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/SeqNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/AckNum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/DataOffset
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/Flags
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/Window
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/Urgent
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/DataCheckSum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/DataLen
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/PayloadEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/Start
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/RamTCPHdWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/RamTCPHdWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen and TxOutCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/RamTCPHdWrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rRamTCPHdWrData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rRamTCPHdWrAddr
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rRamTCPHdWrEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rTCPLength
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rHdCheckSum
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rHdCheckSumData
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rHdCheckSumCnt
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rHdCheckSumEn
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rHdCheckSumVal
add wave -noupdate -expand -group TOE -group TxTCPIP -group TCPHdGen -group {TCPHdGen Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_TxTCPIP/u_TCPHdGen/rSumEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /pksigtbtoe/TM
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /pksigtbtoe/TT
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacRstB
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/RstB
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/RxMacClk
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP Sys} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/Clk
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/PktDropError
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacAddrValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/IPVerValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/ProtocolValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/SrcIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DesIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/SrcPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DesPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/CheckSumValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacErrorFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCPError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/PlLenError
add wave -noupdate -expand -group TOE -group RxTCPIP -group {User2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/FixReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/InitEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DecodeEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DataTransEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/ExpSeqNum
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserSrcMac
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserDesMac
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserSrcIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserDesIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserSrcPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group {TPU2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/UserDesPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxMac2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxMac2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxMac2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxMac2RxTCP Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacData
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxMac2RxTCP Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/FixSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/FixEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/FixValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2User Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/FixData
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/PktValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/SeqNumError
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPSeqNum
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPAck
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPAckFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPPshFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPRstFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPSynFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPFinFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPWinSize
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/TCPPLLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group {RxTCP2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/RxWinSize
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/MacSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/MacValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/MacEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/MacData
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/MacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/PktDropError
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/SOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/DataValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/EOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/Data
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/RxMacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rDataValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rData
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rRxMacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rPktDropError
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/WrFull
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rWrReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rWrData
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/RdEmpty
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/RdReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rRdReqFF
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/rRdData
add wave -noupdate -expand -group TOE -group RxTCPIP -group ClkAdaptor -group {ClkAdaptor Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_ClkAdaptor/AsynClear
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacAddrValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/IPVerValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/ProtocolValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/SrcIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DesIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/SrcPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/DesPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/CheckSumValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDecError signal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/MacErrorFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {ClkAdaptor2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/MacSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {ClkAdaptor2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/MacValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {ClkAdaptor2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/MacEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {ClkAdaptor2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/MacData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {ClkAdaptor2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/MacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/InitEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/ExpSeqNum
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserSrcMac
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserDesMac
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserSrcIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserDesIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserSrcPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {TPU2RxHeaderDec Input} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/UserDesPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/PktValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPSeqNum
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPAck
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPAckFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPPshFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPRstFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPSynFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPFinFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/TCPWinSize
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec2TPU Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/PayloadLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/WinUpReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/QWrFull
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/QCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/QWrReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/QWrData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/PLRamWrData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/PLRamWrEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {Queue&DataCtrl I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/PLRamWrAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rState
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDecodeEnLat
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPrePktValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPktValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rValDelayCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rWinUpReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacData1
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacError
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacAddrValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rIPVerValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rProtocolValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSrcIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDesIPValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSrcPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDesPortValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rIPCheckSumValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rTCPCheckSumValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacErrorFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSeqNumError
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSeqNumErrorDelay
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rEthCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rMacAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rEthType
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rIHL
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rTotalLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSrcIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDesIP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rIPHeadCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rIPCheckSum
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rTCPCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rTCPLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPayloadLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSrcPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDesPort
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSeqNum
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rAck
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rAckFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPshFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rRstFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rSynFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rFinFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rWinSize
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rDataOffset
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rTCPCheckSum
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPayloadFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPsudoHdFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPaddingFlag
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPLRamWrEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rPLRamWrAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rQWrReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxHeaderDec -group {RxHeaderDec Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxHeaderDec/rQWrData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and TPU I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/DataTransEn
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and TPU I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FreeSpace
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/RxWinUpReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/RamWrAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/QRdEmpty
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/QRdData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/QRdReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl and RxHeaderDec I/F} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/PlLenError
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {Payload Ram} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/RamRdData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {Payload Ram} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/RamRdAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {User2RxDataCtrl Input} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FixReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FixSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FixEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl2User Output} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FixValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl2User Output} -radix hexadecimal /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/FixData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/WinUpFlagCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rPreFreeSpace
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFreeSpace
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rBufState
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rQRdReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rPLLenError
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rTempFreeSpace
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rQMode
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rPayloadLen
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rRamRdCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rRamRdReq
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rRamRdReq1
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rRamRdDataVal
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rRamRdAddr
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixTransCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixSOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixEOP
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixValid
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixData
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rTransByteCnt
add wave -noupdate -expand -group TOE -group RxTCPIP -group RxDataCtrl -group {RxDataCtrl Internal} /tbtoe/u_PkMapTbTOE/u_TOE/u_RxTCPIP/u_RxDataCtrl/rFixWinUpReq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {346005700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 586
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
WaveRestoreZoom {0 ps} {555505 ns}
