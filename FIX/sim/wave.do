onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pksigtbfixproc/TM
add wave -noupdate /pksigtbfixproc/TT
add wave -noupdate /pksigtbfixproc/RstB
add wave -noupdate /pksigtbfixproc/Clk
add wave -noupdate -group TCP2FixInput /pksigtbfixproc/TOE2FixStatus
add wave -noupdate -group TCP2FixInput /pksigtbfixproc/TOE2FixPSHFlagset
add wave -noupdate -group TCP2FixInput /pksigtbfixproc/TOE2FixFINFlagset
add wave -noupdate -group TCP2FixInput /pksigtbfixproc/TOE2FixRSTFlagset
add wave -noupdate -group TCP2FixInput /pksigtbfixproc/TOE2FixMemAlFull
add wave -noupdate -group TCP2FixInput -childformat {{/pksigtbfixproc/RxDataRec.RxTCPData -radix ascii}} -expand -subitemconfig {/pksigtbfixproc/RxDataRec.RxTCPData {-height 15 -radix ascii}} /pksigtbfixproc/RxDataRec
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixConn
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixDisConn
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixRTCTime
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixSenderCompID
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixTargetCompID
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixUsername
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixPassword
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixSenderCompIDLen
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixTargetCompIDLen
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixUsernameLen
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixPasswordLen
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixIdValid
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixRxSenderId
add wave -noupdate -group User2FixInput -radix ascii /pksigtbfixproc/User2FixRxTargetId
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixMrketData0
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixMrketData1
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixMrketData2
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixMrketData3
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixMrketData4
add wave -noupdate -group User2FixInput -radix unsigned /pksigtbfixproc/User2FixNoRelatedSym
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixMDEntryTypes
add wave -noupdate -group User2FixInput /pksigtbfixproc/User2FixNoMDEntryTypes
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOEDataVal
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOEDataSop
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOEDataEop
add wave -noupdate -group Fix2TCPOutput -radix ascii /pksigtbfixproc/Fix2TOEData
add wave -noupdate -group Fix2TCPOutput -radix unsigned /pksigtbfixproc/Fix2TOEDataLen
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOERxDataReq
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOEConnectReq
add wave -noupdate -group Fix2TCPOutput /pksigtbfixproc/Fix2TOETerminateReq
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOperate
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserNoEntriesError
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserError
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserMsgVal2User
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserSecIndic
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserEntriesVal
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidPx
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidPxNegExp
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidSize
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidTimeHour
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidTimeMin
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidTimeSec
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserBidTimeSecNegExp
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffPx
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffPxNegExp
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffSize
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffTimeHour
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffTimeMin
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffTimeSec
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserOffTimeSecNegExp
add wave -noupdate -group Fix2UserOutput /pksigtbfixproc/Fix2UserSpecialPxFlag
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixConn
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixDisConn
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixRTCTime
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixSenderCompID
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixTargetCompID
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixUsername
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixPassword
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixSenderCompIDLen
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixTargetCompIDLen
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixUsernameLen
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixPasswordLen
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMrketData0
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMrketData1
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMrketData2
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMrketData3
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMrketData4
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixNoRelatedSym
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixMDEntryTypes
add wave -noupdate -expand -group FixCtrl -group Input -group {UserData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixNoMDEntryTypes
add wave -noupdate -expand -group FixCtrl -group Input -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/TOE2FixStatus
add wave -noupdate -expand -group FixCtrl -group Input -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/TOE2FixPSHFlagset
add wave -noupdate -expand -group FixCtrl -group Input -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/TOE2FixFINFlagset
add wave -noupdate -expand -group FixCtrl -group Input -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/TOE2FixRSTFlagset
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlBusy
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketVal
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSymbol0
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSecurityID0
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSymbol1
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSecurityID1
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSymbol2
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSecurityID2
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSymbol3
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSecurityID3
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSymbol4
add wave -noupdate -expand -group FixCtrl -group Input -group {TxData Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlMrketSecurityID4
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTypeVal
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlSeqNum
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlSeqNumError
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlPossDupFlag
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeYear
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeMonth
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeDay
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeHour
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeMin
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeSec
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group RxMsgTime -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMsgTimeSecNegExp
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlTagErrorFlag
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlErrorTagLatch
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlErrorTagLen
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlBodyLenError
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlCsumError
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlEncryptMetError
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlAppVerIdError
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlHeartBtInt
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlResetSeqNumFlag
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlTestReqId
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlTestReqIdLen
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlTestReqIdVal
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlBeginSeqNum
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlEndSeqNum
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlRefSeqNum
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlRefTagId
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlRefMsgType
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix binary /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlRejectReason
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlGapFillFlag
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlNewSeqNum
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMDReqId
add wave -noupdate -expand -group FixCtrl -group Input -group RxDataInput -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Rx2CtrlMDReqIdLen
add wave -noupdate -expand -group FixCtrl -group Output /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixOperate
add wave -noupdate -expand -group FixCtrl -group Output -group {TOE output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Fix2TOEConnectReq
add wave -noupdate -expand -group FixCtrl -group Output -group {TOE output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Fix2TOETerminateReq
add wave -noupdate -expand -group FixCtrl -group Output -group {TOE output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Fix2TOERxDataReq
add wave -noupdate -expand -group FixCtrl -group Output -group {TOE output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/UserFixError
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxReq
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Tx2CtrlBusy
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxPossDupEn
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxReplyTest
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgType
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgSeqNum
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgSendTime
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgBeginString
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgSenderCompID
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgTargetCompID
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgBeginStringLen
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgSenderCompIDLen
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Header -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgTargetCompIDLen
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag98
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag108
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag141
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag553
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag554
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag1137
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag553Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Logon -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag554Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Heartbeat -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag112
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Heartbeat -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag112Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag262
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag263
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag264
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag265
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag266
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag146
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag22
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag267
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group MrkDataReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag269
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group ResendReq -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag7
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group ResendReq -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag16
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group SeqReset -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag123
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group SeqReset -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag36
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag45
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag371
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag372
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag373
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag58
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag371Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag373Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag58Len
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag371En
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag372En
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag373En
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMsgGenTag58En
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketData0
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketData1
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketData2
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketData3
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketData4
add wave -noupdate -expand -group FixCtrl -group Output -group {TxData output} -group {Market data } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2TxMrketDataEn
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxTOEConn
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxExpSeqNum
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecValid
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecSymbol0
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecSymbol1
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecSymbol2
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecSymbol3
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecSymbol4
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecId0
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecId1
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecId2
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecId3
add wave -noupdate -expand -group FixCtrl -group Output -group {RxData output} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/Ctrl2RxSecId4
add wave -noupdate -expand -group FixCtrl -group Internal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rState
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rx Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRxCtrlRecvSeqNumCal
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rx Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRx2CtrlMsgTypeValFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rx Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRxCtrlOutOfOrder
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rx Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRx2CtrlPossDupFlagFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rx Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRxCtrlMsgVal
add wave -noupdate -expand -group FixCtrl -group Internal -group {RxFix Interface} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2RxNewSeqNumFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {RxFix Interface} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2RxExpSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {RxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFixCtrl2RxTOEConn
add wave -noupdate -expand -group FixCtrl -group Internal -group {User Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rUserFixOperate
add wave -noupdate -expand -group FixCtrl -group Internal -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFix2TOEConnectReq
add wave -noupdate -expand -group FixCtrl -group Internal -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFix2TOETerminateReq
add wave -noupdate -expand -group FixCtrl -group Internal -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFix2TOERxDataReq
add wave -noupdate -expand -group FixCtrl -group Internal -group {ResendReq Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsrValid
add wave -noupdate -expand -group FixCtrl -group Internal -group {Heartbeat Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlHbRxCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {Heartbeat Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlHbTxCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {Heartbeat Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlHbRxCntRst
add wave -noupdate -expand -group FixCtrl -group Internal -group {Heartbeat Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlHbTxCntRst
add wave -noupdate -expand -group FixCtrl -group Internal -group {MrkdataReq Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlMrkDataEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTtrBusy
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRx2CtrlSeqNumFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTtrDetect
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRx2CtrlErrorTagLatchFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxRefTagID
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxRefSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxMsgType
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxValid
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRx2CtrlErrorTagLenFF
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxRefTagIDLen
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxRefTagIDCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Rx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtRxReason
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueWrData
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueRdData
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueRdReq
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueFull
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueEmpty
add wave -noupdate -expand -group FixCtrl -group Internal -group {Reject FIF} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rFifoQueueReset
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxBusy
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxRefTagID
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxRefSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxSessReason
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxRefMsgType
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxRefTagIDLen
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxReason
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxSessReasonLen
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxRefTagIDEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {Rejection message Tx Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRjtTxValid
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Reply process } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTrrText
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Reply process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTrrTextLen
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Reply process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTrrTextCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {TestReq Reply process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlTrrValid
add wave -noupdate -expand -group FixCtrl -group Internal -group {Logout Timeout process  } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlLogoutTimeoutCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {Logout Timeout process  } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlLogoutEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxReqMsg
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxMsgType
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxTranEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxReq
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxMsgGenTag112
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxMsgGenTag112Len
add wave -noupdate -expand -group FixCtrl -group Internal -group {TxFix Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrl2TxReplyTest
add wave -noupdate -expand -group FixCtrl -group Internal -group { RetranRam } -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRetranRamWrData
add wave -noupdate -expand -group FixCtrl -group Internal -group { RetranRam } -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRetranRamRdData
add wave -noupdate -expand -group FixCtrl -group Internal -group { RetranRam } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rRetranRamRdAddr
add wave -noupdate -expand -group FixCtrl -group Internal -group { RetranRam } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRetranMsgType
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqBeginSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEndSeqNum
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEndAddr1
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEndAddr0
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqBusy
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqDetect
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqBeginSeqNumCal
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEndSeqNumCal
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqRstSeqEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqMrkDatEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqRejectEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqSeqNumCnt
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqAddrCal
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEn
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqCheckEnd
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqStart
add wave -noupdate -expand -group FixCtrl -group Internal -group {Resend write I/F } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlRsqEnd
add wave -noupdate -expand -group FixCtrl -group Internal -group {Error signal } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_FixCtrl/rCtrlError
add wave -noupdate -group FixTx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Clk
add wave -noupdate -group FixTx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/RstB
add wave -noupdate -group FixTx -group {FixTx - Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/FixCtrl2TxReq
add wave -noupdate -group FixTx -group {FixTx - Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/FixCtrl2TxPossDupEn
add wave -noupdate -group FixTx -group {FixTx - Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/FixCtrl2TxReplyTest
add wave -noupdate -group FixTx -group {FixTx - Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgType
add wave -noupdate -group FixTx -group {FixTx - Input} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgSeqNum
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgSendTime
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgBeginString
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgSenderCompID
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgTargetCompID
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgBeginStringLen
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgSenderCompIDLen
add wave -noupdate -group FixTx -group {FixTx - Input} -group Detail -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgTargetCompIDLen
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag98
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag108
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag141
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag553
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag554
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag1137
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag553Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag554Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag112
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag112Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag262
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag263
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag264
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag265
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag266
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag146
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag22
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag267
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag269
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag7
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag16
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag123
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag36
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag45
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag371
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag372
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag373
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag58
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag371Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag373Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag58Len
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag371En
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag372En
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag373En
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MsgGenTag58En
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketData0
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketData1
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketData2
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketData3
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketData4
add wave -noupdate -group FixTx -group {FixTx - Input} -group {Message Body} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketDataEn
add wave -noupdate -group FixTx -group {FixTx - Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/TOE2FixMemAlFull
add wave -noupdate -group FixTx -group {FixTx - Output} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/FixTx2CtrlBusy
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketVal
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSymbol0
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSecurityID0
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSymbol1
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSecurityID1
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSymbol2
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSecurityID2
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSymbol3
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSecurityID3
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSymbol4
add wave -noupdate -group FixTx -group {FixTx - Output} -group MrkData -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/MrketSecurityID4
add wave -noupdate -group FixTx -group {FixTx - Output} -group {TOE Out} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Fix2TOEDataVal
add wave -noupdate -group FixTx -group {FixTx - Output} -group {TOE Out} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Fix2TOEDataSop
add wave -noupdate -group FixTx -group {FixTx - Output} -group {TOE Out} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Fix2TOEDataEop
add wave -noupdate -group FixTx -group {FixTx - Output} -group {TOE Out} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Fix2TOEData
add wave -noupdate -group FixTx -group {FixTx - Output} -group {TOE Out} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/Fix2TOEDataLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/FixCtrl2TxReq
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/FixCtrl2TxPossDupEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/FixCtrl2TxReplyTest
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/FixTx2CtrlBusy
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgType
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgSeqNum
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgSendTime
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgBeginString
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgSenderCompID
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgTargetCompID
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgBeginStringLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgSenderCompIDLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -expand -group {Ctrl Interface } -group {Header detail} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgTargetCompIDLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/TOE2FixMemAlFull
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Fix2TOEDataVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Fix2TOEDataSop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Fix2TOEDataEop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Fix2TOEData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {TOE Interface } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Fix2TOEDataLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiOutReq
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiOutVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiOutEop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiOutData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiInStart
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiInTransEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiInDecPointEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiInNegativeExp
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MuxEnc Interface} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/AsciiInData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Ctrl2GenMsgReq
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgGen2CtrlBusy
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgGen2CtrlCheckSum
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/MsgGen2CtrlEnd
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/Ctrl2GenMsgType
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/PayloadRdData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/PayloadWrAddr
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {MsgGen Interface } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/PayloadRdAddr
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {FF signal} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rMsgSendTimeFF
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {FF signal} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rMsgSeqNumFF
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {FF signal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rMsgTypeFF
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group Control /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rCtrlChkTxBusy
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group Control /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixTx2CtrlBusy
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group Control /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiMsgType
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group TxFixMsgGEn /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rCtrl2GenMsgType
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group TxFixMsgGEn /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rTxCtrl2GenEnd
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group TxFixMsgGEn /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rTxCtrl2GenReq
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiEncData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiEncNegativeExp
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiEncStart
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiEncTransEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiEncDecPointEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuffShCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuffReady
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuffShEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuffStart
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBodyLenReady
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuff1
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Ascii Enc Pro} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiOutBuff0
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {AsciiPipe encoder process} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiPipOutData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {AsciiPipe encoder process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiPipOutVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {AsciiPipe encoder process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiPipData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {AsciiPipe encoder process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiPipCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {AsciiPipe encoder process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rAsciiPipStart
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag35
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag34
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag49
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag56
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag52
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Tag43
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0DataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0LenCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0AsciiReq
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0LenCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Data
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Equal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Hyphen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0SemCol
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Eop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Soh
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header After Tag 9 Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Val
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0WrData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0WrAddr
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0RdAddr
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0RdData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0WrEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Checksum
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0Length
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0End
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0RdVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {RAM Header process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd0RdEnd
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1Start
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd1Tag8
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd1Tag9
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenTrlTag10
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1BodyLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1AsciiTranEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1DataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd1LenCnt
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenHd1LenCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1Data
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1Eop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Generate Header 1 and Trailer Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGen1Val
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Payload Ram Process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rPayloadLength
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Payload Ram Process} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rPayloadRdAddr
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Payload Ram Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rPayloadRdVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Payload Ram Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rPayloadRdEnd
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Payload Ram Process} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rPayloadRdEn
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Checksum Process } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixGenCheckSum
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Checksum Process } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFixCheckSumStart
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Output generator} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFix2TOEDataLen
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Output generator} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFix2TOEData
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Output generator} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFix2TOEDataVal
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Output generator} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFix2TOEDataEop
add wave -noupdate -group FixTx -group {FixTx - MsgCtrl} -group {FixTxCtrl - Internal} -group {Output generator} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgCtrl/rFix2TOEDataSop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenReq
add wave -noupdate -group FixTx -group {FixTx - MsgGen} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenMsgType
add wave -noupdate -group FixTx -group {FixTx - MsgGen} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/Gen2TxCtrlBusy
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag98
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag108
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag141
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag553
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag554
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag1137
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag553Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag554Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag112
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag112Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag262
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag263
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag264
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag265
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag266
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag146
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag22
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag267
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag269
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag7
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag16
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag123
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag36
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag45
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag371
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag372
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag373
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag58
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag371Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag373Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag58Len
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag371En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag372En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag373En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/TxCtrl2GenTag58En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketData0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketData1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketData2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketData3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketData4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group MsgGen2TxCtrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketDataEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSymbol0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSecurityID0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketVal0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSymbol1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSecurityID1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketVal1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSymbol2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSecurityID2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketVal2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSymbol3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSecurityID3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketVal3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSymbol4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketSecurityID4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group TxCtrl2MsgGen /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/MrketVal4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiOutReq
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiOutVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiOutEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiOutData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiInStart
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiInTransEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiInDecPointEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiInNegativeExp
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {AsciiEnc Interface} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/AsciiInData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen DataOut} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/OutMsgWrAddr
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen DataOut} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/OutMsgWrData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen DataOut} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/OutMsgWrEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen DataOut} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/OutMsgChecksum
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen DataOut} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/OutMsgEnd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMsgGenCtrl0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMsgGenCtrl1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rGen2TxCtrlBusy
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkRdAddr
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkRdData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDataReqNum
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDataCntFF
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDataEnd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rGenValRdCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rGenValCheckEnd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rGenValRdEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSymbol0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSymbol1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSymbol2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSymbol3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSymbol4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSecurityID0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSecurityID1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSecurityID2
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSecurityID3
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData RAM } -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrketSecurityID4
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Ascii dec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInSop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Ascii dec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Ascii dec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Ascii dec} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rBinOutData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Ascii dec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rBinOutVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgDataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnLenCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnUserTagEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnPassTagEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnLastTagEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnLenCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnFixedTagEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Logon /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rLogOnMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgLenCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgDataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgLenCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Heartbeat /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rHbtMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgDataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag262En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag263En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag264En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag265En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag266En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag146En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag267En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag55En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag48En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag22En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgTag269En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgRptSymEnd0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgRptSymCnt0
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgRptSymEnd1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgRptSymCnt1
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDatJumpAddr
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDatRdAddrCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDatRdAddrCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDatAsciiTransEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkDatStartRd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {MrkData Proc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rMrkMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgTag16En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgTag7En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Rrq /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRrqMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgTag123En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgTag36En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group SeqReset /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRstMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgDataCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgLenCnt
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgEnd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgTag45En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgTag58En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgTag371En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgTag372En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgTag373En
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgLenCntEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject -radix hexadecimal /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgEqual
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgVal
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgSoh
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group Reject /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rRjtMsgEop
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Asii Enc} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Asii Enc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInTransEn
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Asii Enc} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rAsciiInStart
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Data Our} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rOutMsgWrAddr
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Data Our} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rOutMsgWrData
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Data Our} -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rOutMsgChecksum
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Data Our} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rOutMsgEnd
add wave -noupdate -group FixTx -group {FixTx - MsgGen} -group {MsgGen Internal} -group {Data Our} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_TxFixMsgGen/rOutMsgWrEn
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxStart0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxTransEn0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxDecPointEn0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxNegativeExp0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxData0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxStart1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxTransEn1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxDecPointEn1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxNegativeExp1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group InMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/InMuxData1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxReq0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxVal0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxEop0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxData0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxReq1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxVal1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxEop1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group OutMux /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/OutMuxData1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rCtrlMux0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rCtrlMux1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderStart
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderInReady
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderData0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderNegativeExp0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderDecPointEn0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderData1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderNegativeExp1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderDecPointEn1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutData0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutReq0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutVal0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutEop0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutData1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutReq1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutVal1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rEncoderOutEop1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxBusy
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxSel
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxData0
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxData1
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxReq
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxVal
add wave -noupdate -group FixTx -group {FixTx - MuxEnc} -group {Internal - Mux} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_TxFixMsg/u_MuxEncoder/rOutMuxEop
add wave -noupdate -group FixRx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/RstB
add wave -noupdate -group FixRx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/Clk
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/UserValid
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/UserSenderId
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/UserTargetId
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TCPConnect
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/ExpSeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecValid
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecSymbol0
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SrcId0
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecSymbol1
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SrcId1
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecSymbol2
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SrcId2
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecSymbol3
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SrcId3
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecSymbol4
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Ctrl2Rx -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SrcId4
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/MsgTypeVal
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BLenError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/CSumError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TagError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/ErrorTagLatch
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/ErrorTagLen
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SeqNumError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/PossDupFlag
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeYear
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeMonth
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeDay
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeHour
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeMin
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeSec
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TimeSecNegExp
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/HeartBtInt
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/ResetSeqNumFlag
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/EncryptMetError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/AppVerIdError
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TestReqIdVal
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TestReqId
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/TestReqIdLen
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BeginSeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/EndSeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/RefSeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/RefTagId
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/RefMsgType
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/RejectReason
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/GapFillFlag
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/NewSeqNum
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/MDReqId
add wave -noupdate -group FixRx -group {Ctrl2Rx Interface } -group Rx2Ctrl -radix unsigned /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/MDReqIdLen
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/MsgVal2User
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SecIndic
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/EntriesVal
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidPx
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidPxNegExp
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidSize
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidTimeHour
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidTimeMin
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidTimeSec
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/BidTimeSecNegExp
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffPx
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffPxNegExp
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffSize
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffTimeHour
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffTimeMin
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffTimeSec
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/OffTimeSecNegExp
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/SpecialPxFlag
add wave -noupdate -group FixRx -group {User Output Data} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/NoEntriesError
add wave -noupdate -group FixRx -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/FixSOP
add wave -noupdate -group FixRx -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/FixValid
add wave -noupdate -group FixRx -group {TOE Input} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/FixEOP
add wave -noupdate -group FixRx -group {TOE Input} -radix ascii /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/FixData
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/UserValid
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/UserSenderId
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/UserTargetId
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/FixSOP
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/FixValid
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/FixEOP
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/FixData
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TCPConnect
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/ExpSeqNum
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/MsgDecCtrlFlag
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/EncryptMetError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/AppVerIdError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/ResetSeqNumFlag
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/MsgVal2User
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TypePermit
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/MsgEnd
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/FieldLenCnt
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/MsgTypeVal
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/BLenError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/CSumError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TagError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/ErrorTagLatch
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/ErrorTagLen
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/SeqNumError
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/SeqNum
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/PossDupFlag
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeYear
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeMonth
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeDay
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeHour
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeMin
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeSec
add wave -noupdate -group FixRx -group RxHdDec -group {In out - HdDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/TimeSecNegExp
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rFixValid
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rFixData
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rAsciiInSop
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rAsciiInVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rAsciiInData
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBinOutVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBinOutNegExp
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBinOutData
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitBLen
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitSeqNum
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitSeqNumProc
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitYear
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitSec
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rWaitCSum
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTagIndic
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTagSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMsgEnd
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rFieldLenCnt
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBeginStrCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBLenCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMsgTypeCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSenderIdCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTargetIdCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSeqNumCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rPossDupCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSendTimeCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSeqNumProcCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rCSumCtrl
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMsgTypeVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMsgVal2User
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBLenLatch
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBLenAddFlag
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBLenCnt
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBLenVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMgsTypeSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMgsTypeLatch
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTypePermit
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rCSumAddFlag
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rCSum
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rCSumVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBeginStrSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rBeginStrVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rCompIdSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSenderIdVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTargetIdVal
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSeqNumLatch
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rPossDupFlag
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTimeByteCnt
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rYear
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMonth
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rDay
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rHour
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMin
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSec
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSecNegExp
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMonthSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rDaySh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rHourSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rMinSh
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSeqNumProcLatch
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTagLatch
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rErrorTag
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rErrorTagLen
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTagError
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rErrorTagCntDelay
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTag1stByte
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTag2ndByte
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTag3rdByte
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rTag4thByte
add wave -noupdate -group FixRx -group RxHdDec -group {HdDec - Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxHdDec/rSeqNumError
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/FixSOP
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/FixValid
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/FixEOP
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/FixData
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/TCPConnect
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecValid
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecSymbol0
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SrcId0
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecSymbol1
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SrcId1
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecSymbol2
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SrcId2
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecSymbol3
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SrcId3
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecSymbol4
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SrcId4
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/TypePermit
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/MsgEnd
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/FieldLenCnt
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/MsgDecCtrlFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/EncryptMetError
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/AppVerIdError
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/HeartBtInt
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/ResetSeqNumFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/TestReqIdVal
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/TestReqId
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/TestReqIdLen
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BeginSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/EndSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/RefSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/RefTagId
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/RefMsgType
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/RejectReason
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/GapFillFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/NewSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/MDReqId
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/MDReqIdLen
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SecIndic
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/EntriesVal
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidPx
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidPxNegExp
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidSize
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidTimeHour
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidTimeMin
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidTimeSec
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/BidTimeSecNegExp
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffPx
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffPxNegExp
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffSize
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffTimeHour
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffTimeMin
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffTimeSec
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/OffTimeSecNegExp
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/SpecialPxFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {In out - MsgDec} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/NoEntriesError
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rFixValid
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rFixData
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rAsciiInSop
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rAsciiInVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rAsciiInData
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBinOutVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBinOutNegExp
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBinOutData
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitBeginSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitEndSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitRefSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitRefTagId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitNewSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitSecId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitPx
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitSize
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rWaitSec
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTagIndic
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTagSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTestReqIdCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rResentReqCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRejectCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSeqRstCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rLogOnCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSnapShotCtrl
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTestReqIdVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTestReqId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTestReqIdLen
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBeginSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rEndSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRefSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRefTagId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRefMsgTypeSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRefMsgType
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRejectReaSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRejectReason
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rGapFillFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rNewSeqNum
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rEncryptMet
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rEncryptMetError
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rHeartBtInt
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rRstSeqNumFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rAppVerIdVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rUserName
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rPassword
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rMDReqId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rMDReqIdLen
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSymbolSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSecIndic
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSecId
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSecIdSource
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rNoEntries
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rNoEntriesError
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rEnTryTypeIndic
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rPxSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rPxByteCnt
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidPx
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidPxNeqExp
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rOffVal
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rOffPx
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rOffPxNeqExp
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSpecialPxFlag
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rSpecialPx
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidSize
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rOffSize
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTimeByteCnt
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTimeHourSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rTimeMinSh
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidTimeHour
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidTimeMin
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidTimeSec
add wave -noupdate -group FixRx -group RxMsgDec -group {MsgDec Internal} /tbfixproc/u_PkMapTbFixProc/u_FixProc/u_RxFix/u_RxMsgDec/rBidTimeSecNegExp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {111800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 648
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
WaveRestoreZoom {0 ps} {639800 ps}
