onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label TM /pksigtbrxfix/TM
add wave -noupdate -label TT /pksigtbrxfix/TT
add wave -noupdate -label RstB /pksigtbrxfix/RstB
add wave -noupdate -label Clk /pksigtbrxfix/Clk
add wave -noupdate -label TCPConnect /tbrxfix/u_RxFix/TCPConnect
add wave -noupdate -group {DataIn (no FF)} /tbrxfix/u_RxFix/FixSOP
add wave -noupdate -group {DataIn (no FF)} /tbrxfix/u_RxFix/FixValid
add wave -noupdate -group {DataIn (no FF)} /tbrxfix/u_RxFix/FixEOP
add wave -noupdate -group {DataIn (no FF)} -radix hexadecimal /tbrxfix/u_RxFix/FixData
add wave -noupdate -label rFixValid /tbrxfix/u_RxFix/u_RxHdDec/rFixValid
add wave -noupdate -label rFixData -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rFixData
add wave -noupdate -group Ascii2Bin_Hd -label rAsciiInSop /tbrxfix/u_RxFix/u_RxHdDec/rAsciiInSop
add wave -noupdate -group Ascii2Bin_Hd -label rAsciiInVal /tbrxfix/u_RxFix/u_RxHdDec/rAsciiInVal
add wave -noupdate -group Ascii2Bin_Hd -label rAsciiInData -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rAsciiInData
add wave -noupdate -group Ascii2Bin_Hd -label rBinOutVal /tbrxfix/u_RxFix/u_RxHdDec/rBinOutVal
add wave -noupdate -group Ascii2Bin_Hd -label rBinOutData -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rBinOutData
add wave -noupdate -group Ascii2Bin_Hd -label rBinOutNegExp /tbrxfix/u_RxFix/u_RxHdDec/rBinOutNegExp
add wave -noupdate -label rTagIndic /tbrxfix/u_RxFix/u_RxHdDec/rTagIndic
add wave -noupdate -label rTagSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rTagSh
add wave -noupdate -label rHdSeq /tbrxfix/u_RxFix/u_RxHdDec/rHdSeq
add wave -noupdate -label rMsgEnd /tbrxfix/u_RxFix/u_RxHdDec/rMsgEnd
add wave -noupdate -group BeginStr -label rBeginStrCtrl /tbrxfix/u_RxFix/u_RxHdDec/rBeginStrCtrl
add wave -noupdate -group BeginStr -label rBeginStrSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rBeginStrSh
add wave -noupdate -group BeginStr -label rBeginStrVal /tbrxfix/u_RxFix/u_RxHdDec/rBeginStrVal
add wave -noupdate -group {Body Len} -label rBLenCtrl /tbrxfix/u_RxFix/u_RxHdDec/rBLenCtrl
add wave -noupdate -group {Body Len} -label rBLenCtrl2 /tbrxfix/u_RxFix/u_RxHdDec/rBLenCtrl2
add wave -noupdate -group {Body Len} -label rWaitBLen /tbrxfix/u_RxFix/u_RxHdDec/rWaitBLen
add wave -noupdate -group {Body Len} -label rBLenLatch -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rBLenLatch
add wave -noupdate -group {Body Len} -label rBLenAddFlag /tbrxfix/u_RxFix/u_RxHdDec/rBLenAddFlag
add wave -noupdate -group {Body Len} -label rBLenCnt -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rBLenCnt
add wave -noupdate -group {Body Len} -label rBLenVal /tbrxfix/u_RxFix/u_RxHdDec/rBLenVal
add wave -noupdate -group {Body Len} -label BLenError /tbrxfix/u_RxFix/BLenError
add wave -noupdate -group MsgType -label rMsgTypeCtrl /tbrxfix/u_RxFix/u_RxHdDec/rMsgTypeCtrl
add wave -noupdate -group MsgType -label rMgsTypeSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rMgsTypeSh
add wave -noupdate -group MsgType -label rMgsTypeLatch -radix ascii /tbrxfix/u_RxFix/u_RxHdDec/rMgsTypeLatch
add wave -noupdate -group MsgType -label rTypePermit -radix binary /tbrxfix/u_RxFix/u_RxHdDec/rTypePermit
add wave -noupdate -group CSum -label rCSumCtrl /tbrxfix/u_RxFix/u_RxHdDec/rCSumCtrl
add wave -noupdate -group CSum -label rWaitCSum /tbrxfix/u_RxFix/u_RxHdDec/rWaitCSum
add wave -noupdate -group CSum -label rCSumAddFlag /tbrxfix/u_RxFix/u_RxHdDec/rCSumAddFlag
add wave -noupdate -group CSum -label rCSum -radix hexadecimal -childformat {{/tbrxfix/u_RxFix/u_RxHdDec/rCSum(7) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(6) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(5) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(4) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(3) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(2) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(1) -radix hexadecimal} {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(0) -radix hexadecimal}} -subitemconfig {/tbrxfix/u_RxFix/u_RxHdDec/rCSum(7) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(6) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(5) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(4) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(3) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(2) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(1) {-height 15 -radix hexadecimal} /tbrxfix/u_RxFix/u_RxHdDec/rCSum(0) {-height 15 -radix hexadecimal}} /tbrxfix/u_RxFix/u_RxHdDec/rCSum
add wave -noupdate -group CSum -label rCSumVal /tbrxfix/u_RxFix/u_RxHdDec/rCSumVal
add wave -noupdate -group CSum -label CSumError /tbrxfix/u_RxFix/CSumError
add wave -noupdate -group ComID -label rSenderIdCtrl /tbrxfix/u_RxFix/u_RxHdDec/rSenderIdCtrl
add wave -noupdate -group ComID -label rTargetIdCtrl /tbrxfix/u_RxFix/u_RxHdDec/rTargetIdCtrl
add wave -noupdate -group ComID -label rCompIdSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxHdDec/rCompIdSh
add wave -noupdate -group ComID -label rSenderIdVal /tbrxfix/u_RxFix/u_RxHdDec/rSenderIdVal
add wave -noupdate -group ComID -label rTargetIdVal /tbrxfix/u_RxFix/u_RxHdDec/rTargetIdVal
add wave -noupdate -group SeqNum -label rSeqNumCtrl /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumCtrl
add wave -noupdate -group SeqNum -label rSeqNumCtrl2 /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumCtrl2
add wave -noupdate -group SeqNum -label rWaitSeqNum /tbrxfix/u_RxFix/u_RxHdDec/rWaitSeqNum
add wave -noupdate -group SeqNum -label rSeqNumLatch -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumLatch
add wave -noupdate -group SeqNum -label SeqNum -radix unsigned /tbrxfix/u_RxFix/SeqNum
add wave -noupdate -group SeqNum -label SeqNumError /tbrxfix/u_RxFix/SeqNumError
add wave -noupdate -group PossDup -label rPossDupCtrl /tbrxfix/u_RxFix/u_RxHdDec/rPossDupCtrl
add wave -noupdate -group PossDup -label PossDupFlag /tbrxfix/u_RxFix/PossDupFlag
add wave -noupdate -group MsgTime -label rSendTimeCtrl /tbrxfix/u_RxFix/u_RxHdDec/rSendTimeCtrl
add wave -noupdate -group MsgTime -label rTimeByteCnt -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rTimeByteCnt
add wave -noupdate -group MsgTime -label rWaitYear /tbrxfix/u_RxFix/u_RxHdDec/rWaitYear
add wave -noupdate -group MsgTime -label TimeYear -radix unsigned /tbrxfix/u_RxFix/TimeYear
add wave -noupdate -group MsgTime -label rMonthSh /tbrxfix/u_RxFix/u_RxHdDec/rMonthSh
add wave -noupdate -group MsgTime -label TimeMonth -radix unsigned /tbrxfix/u_RxFix/TimeMonth
add wave -noupdate -group MsgTime -label rDaySh /tbrxfix/u_RxFix/u_RxHdDec/rDaySh
add wave -noupdate -group MsgTime -label TimeDay -radix unsigned /tbrxfix/u_RxFix/TimeDay
add wave -noupdate -group MsgTime -label TimeHour -radix unsigned /tbrxfix/u_RxFix/TimeHour
add wave -noupdate -group MsgTime -label TimeMin -radix unsigned /tbrxfix/u_RxFix/TimeMin
add wave -noupdate -group MsgTime -label rWaitSec /tbrxfix/u_RxFix/u_RxHdDec/rWaitSec
add wave -noupdate -group MsgTime -label TimeSec -radix unsigned /tbrxfix/u_RxFix/TimeSec
add wave -noupdate -group MsgTime -label TimeSecNegExp -radix unsigned /tbrxfix/u_RxFix/TimeSecNegExp
add wave -noupdate -group LastSeqNumProc -label rSeqNumProcCtrl /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumProcCtrl
add wave -noupdate -group LastSeqNumProc -label rSeqNumProcCtrl2 /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumProcCtrl2
add wave -noupdate -group LastSeqNumProc -label rWaitSeqNumProc /tbrxfix/u_RxFix/u_RxHdDec/rWaitSeqNumProc
add wave -noupdate -group LastSeqNumProc -label rSeqNumProcLatch -radix unsigned /tbrxfix/u_RxFix/u_RxHdDec/rSeqNumProcLatch
add wave -noupdate -label {Tb [MsgTypeVal with delay]} /pksigtbrxfix/OutHdDecRecIn.MsgTypeVal
add wave -noupdate -label MsgTypeVal -radix binary -childformat {{/tbrxfix/u_RxFix/MsgTypeVal(7) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(6) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(5) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(4) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(3) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(2) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(1) -radix binary} {/tbrxfix/u_RxFix/MsgTypeVal(0) -radix binary}} -subitemconfig {/tbrxfix/u_RxFix/MsgTypeVal(7) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(6) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(5) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(4) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(3) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(2) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(1) {-height 15 -radix binary} /tbrxfix/u_RxFix/MsgTypeVal(0) {-height 15 -radix binary}} /tbrxfix/u_RxFix/MsgTypeVal
add wave -noupdate -label MsgVal2User -radix binary /tbrxfix/u_RxFix/u_RxHdDec/MsgVal2User
add wave -noupdate -label rFieldLenCnt /tbrxfix/u_RxFix/u_RxHdDec/rFieldLenCnt
add wave -noupdate -group {error tag} -label TagError /tbrxfix/u_RxFix/TagError
add wave -noupdate -group {error tag} -label ErrorTagLatch -radix hexadecimal /tbrxfix/u_RxFix/ErrorTagLatch
add wave -noupdate -group {error tag} -label ErrorTagLen -radix unsigned /tbrxfix/u_RxFix/ErrorTagLen
add wave -noupdate -group Ascii2Bin_Msg -label rAsciiInSop /tbrxfix/u_RxFix/u_RxMsgDec/rAsciiInSop
add wave -noupdate -group Ascii2Bin_Msg -label rAsciiInVal /tbrxfix/u_RxFix/u_RxMsgDec/rAsciiInVal
add wave -noupdate -group Ascii2Bin_Msg -label rAsciiInData -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rAsciiInData
add wave -noupdate -group Ascii2Bin_Msg -label rBinOutVal /tbrxfix/u_RxFix/u_RxMsgDec/rBinOutVal
add wave -noupdate -group Ascii2Bin_Msg -label rBinOutData -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rBinOutData
add wave -noupdate -group Ascii2Bin_Msg -label rBinOutNegExp -radix binary /tbrxfix/u_RxFix/u_RxMsgDec/rBinOutNegExp
add wave -noupdate -group LogOn -label rLogOnCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rLogOnCtrl
add wave -noupdate -group LogOn -label rEncryptMet -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rEncryptMet
add wave -noupdate -group LogOn -label rEncryptMetError /tbrxfix/u_RxFix/u_RxMsgDec/rEncryptMetError
add wave -noupdate -group LogOn -label HeartBtInt -radix hexadecimal /tbrxfix/u_RxFix/HeartBtInt
add wave -noupdate -group LogOn -label ResetSeqNumFlag /tbrxfix/u_RxFix/ResetSeqNumFlag
add wave -noupdate -group LogOn -label rAppVerIdVal /tbrxfix/u_RxFix/u_RxMsgDec/rAppVerIdVal
add wave -noupdate -group LogOn -label AppVerIdError /tbrxfix/u_RxFix/u_RxHdDec/AppVerIdError
add wave -noupdate -group LogOn -label rUserName -radix ascii /tbrxfix/u_RxFix/u_RxMsgDec/rUserName
add wave -noupdate -group LogOn -label rPassword -radix ascii /tbrxfix/u_RxFix/u_RxMsgDec/rPassword
add wave -noupdate -group LogOn -label EncryptMetError /tbrxfix/u_RxFix/EncryptMetError
add wave -noupdate -group LogOn -label AppVerIdError /tbrxfix/u_RxFix/AppVerIdError
add wave -noupdate -group Test_for_Csum -radix hexadecimal /pksigtbrxfix/rTest1
add wave -noupdate -group Test_for_Csum -radix hexadecimal /pksigtbrxfix/rTest2
add wave -noupdate -group TestReqID -label rTestReqIdCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rTestReqIdCtrl
add wave -noupdate -group TestReqID -label TestReqIdVal /tbrxfix/u_RxFix/u_RxMsgDec/TestReqIdVal
add wave -noupdate -group TestReqID -label TestReqId -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/TestReqId
add wave -noupdate -group TestReqID -label TestReqIdLen -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/TestReqIdLen
add wave -noupdate -group {Resend Req} -label rResentReqCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rResentReqCtrl
add wave -noupdate -group {Resend Req} -label rWaitBeginSeqNum /tbrxfix/u_RxFix/u_RxMsgDec/rWaitBeginSeqNum
add wave -noupdate -group {Resend Req} -label rWaitEndSeqNum /tbrxfix/u_RxFix/u_RxMsgDec/rWaitEndSeqNum
add wave -noupdate -group {Resend Req} -label BeginSeqNum -radix unsigned /tbrxfix/u_RxFix/BeginSeqNum
add wave -noupdate -group {Resend Req} -label EndSeqNum -radix unsigned /tbrxfix/u_RxFix/EndSeqNum
add wave -noupdate -group Reject -label rRejectCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rRejectCtrl
add wave -noupdate -group Reject -label rWaitRefSeqNum -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/rWaitRefSeqNum
add wave -noupdate -group Reject -label RefSeqNum -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/RefSeqNum
add wave -noupdate -group Reject -label rWaitRefTagId -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/rWaitRefTagId
add wave -noupdate -group Reject -label RefTagId -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/RefTagId
add wave -noupdate -group Reject -label rRefMsgTypeSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rRefMsgTypeSh
add wave -noupdate -group Reject -label RefMsgType /tbrxfix/u_RxFix/u_RxMsgDec/RefMsgType
add wave -noupdate -group Reject -label rRejectReaSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rRejectReaSh
add wave -noupdate -group Reject -label RejectReason /tbrxfix/u_RxFix/u_RxMsgDec/RejectReason
add wave -noupdate -group Sequence_Rst -label rSeqRstCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rSeqRstCtrl
add wave -noupdate -group Sequence_Rst -label GapFillFlag /tbrxfix/u_RxFix/u_RxMsgDec/GapFillFlag
add wave -noupdate -group Sequence_Rst -label NewSeqNum -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/NewSeqNum
add wave -noupdate -group Sequence_Rst -label rWaitNewSeqNum /tbrxfix/u_RxFix/u_RxMsgDec/rWaitNewSeqNum
add wave -noupdate -label rSnapShotCtrl /tbrxfix/u_RxFix/u_RxMsgDec/rSnapShotCtrl
add wave -noupdate -label SecIndic /tbrxfix/u_RxFix/u_RxMsgDec/SecIndic
add wave -noupdate -label EntriesVal /tbrxfix/u_RxFix/EntriesVal
add wave -noupdate -group {Other in Snapshot} -label rSymbolSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rSymbolSh
add wave -noupdate -group {Other in Snapshot} -label rWaitSecId /tbrxfix/u_RxFix/u_RxMsgDec/rWaitSecId
add wave -noupdate -group {Other in Snapshot} -label rSecId -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/rSecId
add wave -noupdate -group {Other in Snapshot} -label rSecIdSource -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rSecIdSource
add wave -noupdate -group {Other in Snapshot} -label rNoEntries -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rNoEntries
add wave -noupdate -group {Other in Snapshot} -label NoEntriesError /tbrxfix/u_RxFix/u_RxMsgDec/NoEntriesError
add wave -noupdate -group {Other in Snapshot} -label rEnTryTypeIndic /tbrxfix/u_RxFix/u_RxMsgDec/rEnTryTypeIndic
add wave -noupdate -group Price -label rPxSh -radix hexadecimal /tbrxfix/u_RxFix/u_RxMsgDec/rPxSh
add wave -noupdate -group Price -label rPxByteCnt -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/rPxByteCnt
add wave -noupdate -group Price -label rWaitPx /tbrxfix/u_RxFix/u_RxMsgDec/rWaitPx
add wave -noupdate -group Price -label BidPx -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/BidPx
add wave -noupdate -group Price -label BidPxNegExp /tbrxfix/u_RxFix/u_RxMsgDec/BidPxNegExp
add wave -noupdate -group Price -label OffPx -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/OffPx
add wave -noupdate -group Price -label OffPxNegExp /tbrxfix/u_RxFix/u_RxMsgDec/OffPxNegExp
add wave -noupdate -group Price -label SpecialPxFlag /tbrxfix/u_RxFix/u_RxMsgDec/SpecialPxFlag
add wave -noupdate -group Size -label rWaitSize /tbrxfix/u_RxFix/u_RxMsgDec/rWaitSize
add wave -noupdate -group Size -label BidSize -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/BidSize
add wave -noupdate -group Size -label OffSize -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/OffSize
add wave -noupdate -group EntryTime -label rEntryTimeByteCnt -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/rTimeByteCnt
add wave -noupdate -group EntryTime -label BidTimeHour -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/BidTimeHour
add wave -noupdate -group EntryTime -label OffTimeHour -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/OffTimeHour
add wave -noupdate -group EntryTime -label BidTimeMin -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/BidTimeMin
add wave -noupdate -group EntryTime -label OffTimeMin -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/OffTimeMin
add wave -noupdate -group EntryTime -label rWaitSec /tbrxfix/u_RxFix/u_RxMsgDec/rWaitSec
add wave -noupdate -group EntryTime -label BidTimeSec -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/BidTimeSec
add wave -noupdate -group EntryTime -label BidTimeSecNegExp /tbrxfix/u_RxFix/u_RxMsgDec/BidTimeSecNegExp
add wave -noupdate -group EntryTime -label OffTimeSec -radix unsigned /tbrxfix/u_RxFix/u_RxMsgDec/OffTimeSec
add wave -noupdate -group EntryTime -label OffTimeSecNegExp /tbrxfix/u_RxFix/u_RxMsgDec/OffTimeSecNegExp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {33700000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
configure wave -valuecolwidth 72
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
WaveRestoreZoom {56544600 ps} {56940900 ps}
