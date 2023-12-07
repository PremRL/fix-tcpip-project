----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     FixProc.vhd
-- Title        FIX processor
-- 
-- Author       L.Ratchanon
-- Date         2021/02/20
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- SendTime
-- (50 downto 37) Year
-- (36 downto 33) Month
-- (32 downto 28) Day
-- (27 downto 23) Hour
-- (22 downto 17) Min
-- (16 downto 0 ) Millisec
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity FixProc Is
	Port 
	(
		Clk							: in	std_logic;
		RstB						: in	std_logic; 
		
		-- TCP/IP I/F 
		TOE2FixMemAlFull			: in 	std_logic;	
		Fix2TOEDataVal				: out 	std_logic;
		Fix2TOEDataSop				: out	std_logic;
		Fix2TOEDataEop				: out	std_logic;
		Fix2TOEData					: out 	std_logic_vector( 7  downto 0 );
		Fix2TOEDataLen				: out	std_logic_vector(15  downto 0 );
		
		Fix2TOERxDataReq			: out 	std_logic;
		TOE2FixRxSOP				: in	std_logic;
		TOE2FixRxValid				: in	std_logic;
		TOE2FixRxEOP				: in	std_logic;
		TOE2FixRxData				: in	std_logic_vector( 7 downto 0 );
		
		TOE2FixStatus				: in 	std_logic_vector( 3 downto 0 );	
		TOE2FixPSHFlagset           : in	std_logic;
		TOE2FixFINFlagset           : in	std_logic;
		TOE2FixRSTFlagset           : in	std_logic;
		Fix2TOEConnectReq			: out 	std_logic;
		Fix2TOETerminateReq			: out 	std_logic;
		
		-- User I/F 
		User2FixConn				: in	std_logic;
		User2FixDisConn			    : in	std_logic;
		User2FixRTCTime			    : in	std_logic_vector( 50 downto 0 );
		User2FixSenderCompID		: in	std_logic_vector(127 downto 0 );
		User2FixTargetCompID		: in	std_logic_vector(127 downto 0 );
		User2FixUsername			: in	std_logic_vector(127 downto 0 );
		User2FixPassword            : in	std_logic_vector(127 downto 0 );
		User2FixSenderCompIDLen	    : in	std_logic_vector( 4  downto 0 );
		User2FixTargetCompIDLen	    : in	std_logic_vector( 4  downto 0 );
		User2FixUsernameLen		    : in	std_logic_vector( 4  downto 0 );
		User2FixPasswordLen	        : in	std_logic_vector( 4  downto 0 );
		
		User2FixIdValid 	 		: in	std_logic;
		User2FixRxSenderId			: in	std_logic_vector(103 downto 0 );
		User2FixRxTargetId			: in	std_logic_vector(103 downto 0 );
	
		User2FixMrketData0			: in	std_logic_vector( 9 downto 0 );
		User2FixMrketData1		    : in	std_logic_vector( 9 downto 0 );
		User2FixMrketData2		    : in	std_logic_vector( 9 downto 0 );
		User2FixMrketData3		    : in	std_logic_vector( 9 downto 0 );
		User2FixMrketData4		    : in	std_logic_vector( 9 downto 0 );
		User2FixNoRelatedSym		: in	std_logic_vector( 3  downto 0 ); 	-- Max 5 
		User2FixMDEntryTypes		: in	std_logic_vector(15  downto 0 ); 	-- MSB 
		User2FixNoMDEntryTypes	    : in	std_logic_vector( 2  downto 0 ); 	-- Max 2
	
		Fix2UserMsgVal2User			: out 	std_logic_vector( 7 downto 0 );
		Fix2UserSecIndic			: out 	std_logic_vector( 4 downto 0 );    
		Fix2UserEntriesVal			: out	std_logic_vector( 1 downto 0 );
		Fix2UserBidPx				: out 	std_logic_vector( 15 downto 0 );
		Fix2UserBidPxNegExp			: out 	std_logic_vector( 1 downto 0 );
		Fix2UserBidSize				: out 	std_logic_vector( 31 downto 0 );
		Fix2UserBidTimeHour			: out 	std_logic_vector( 7 downto 0 );
		Fix2UserBidTimeMin          : out 	std_logic_vector( 7 downto 0 ); 
		Fix2UserBidTimeSec          : out 	std_logic_vector( 15 downto 0 ); 
		Fix2UserBidTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 ); 

		Fix2UserOffPx			    : out 	std_logic_vector( 15 downto 0 );
		Fix2UserOffPxNegExp		    : out 	std_logic_vector( 1 downto 0 );
		Fix2UserOffSize			    : out 	std_logic_vector( 31 downto 0 );
		Fix2UserOffTimeHour		    : out 	std_logic_vector( 7 downto 0 );
		Fix2UserOffTimeMin          : out 	std_logic_vector( 7 downto 0 ); 
		Fix2UserOffTimeSec          : out 	std_logic_vector( 15 downto 0 ); 
		Fix2UserOffTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 ); 
		Fix2UserSpecialPxFlag	    : out 	std_logic_vector( 1 downto 0 );
		
		Fix2UserError 			    : out 	std_logic_vector( 3 downto 0 );
		Fix2UserOperate			    : out 	std_logic;	
		Fix2UserNoEntriesError		: out	std_logic
	);
End Entity FixProc;

Architecture rtl Of FixProc Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component FixCtrl Is
	Port 
	(
		Clk							: in	std_logic;
		RstB						: in	std_logic; 
		
		-----------------------------------
		-- User Interface	
		UserFixConn					: in	std_logic;
		UserFixDisConn				: in	std_logic;
		UserFixRTCTime				: in	std_logic_vector( 50 downto 0 );
		UserFixSenderCompID			: in	std_logic_vector(127 downto 0 );
		UserFixTargetCompID			: in	std_logic_vector(127 downto 0 );
		UserFixUsername				: in	std_logic_vector(127 downto 0 );
		UserFixPassword             : in	std_logic_vector(127 downto 0 );
		UserFixSenderCompIDLen		: in	std_logic_vector( 4  downto 0 );
		UserFixTargetCompIDLen		: in	std_logic_vector( 4  downto 0 );
		UserFixUsernameLen			: in	std_logic_vector( 4  downto 0 );
		UserFixPasswordLen	        : in	std_logic_vector( 4  downto 0 );
		
		UserFixMrketData0			: in	std_logic_vector( 9 downto 0 );
		UserFixMrketData1			: in	std_logic_vector( 9 downto 0 );
		UserFixMrketData2			: in	std_logic_vector( 9 downto 0 );
		UserFixMrketData3			: in	std_logic_vector( 9 downto 0 );
		UserFixMrketData4			: in	std_logic_vector( 9 downto 0 );
		UserFixNoRelatedSym			: in	std_logic_vector( 3  downto 0 ); 	-- Max 5 
		UserFixMDEntryTypes			: in	std_logic_vector(15  downto 0 ); 	-- MSB 
		UserFixNoMDEntryTypes		: in	std_logic_vector( 2  downto 0 ); 	-- Max 2
		
		UserFixOperate				: out 	std_logic;	
		UserFixError 				: out 	std_logic_vector( 3 downto 0 );	
		
		-----------------------------------
		-- TOE Interface	
		Fix2TOEConnectReq			: out	std_logic;
		Fix2TOETerminateReq			: out 	std_logic;
		Fix2TOERxDataReq			: out 	std_logic;
		
		TOE2FixStatus				: in 	std_logic_vector( 3 downto 0 );	
		TOE2FixPSHFlagset			: in	std_logic;
		TOE2FixFINFlagset 			: in	std_logic;
		TOE2FixRSTFlagset			: in 	std_logic;
		
		-----------------------------------
		-- TxFix Interface 
		Ctrl2TxReq					: out	std_logic;
		Ctrl2TxPossDupEn 			: out   std_logic;
		Ctrl2TxReplyTest 			: out	std_logic;
		Tx2CtrlBusy					: in	std_logic;
		
		Ctrl2TxMsgType				: out	std_logic_vector( 3  downto 0 );
		Ctrl2TxMsgSeqNum			: out	std_logic_vector(26  downto 0 );
		Ctrl2TxMsgSendTime			: out	std_logic_vector(50  downto 0 );
		Ctrl2TxMsgBeginString		: out	std_logic_vector(63  downto 0 );
		Ctrl2TxMsgSenderCompID		: out	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgTargetCompID		: out	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgBeginStringLen   	: out	std_logic_vector( 3  downto 0 );
		Ctrl2TxMsgSenderCompIDLen	: out	std_logic_vector( 4  downto 0 );
		Ctrl2TxMsgTargetCompIDLen	: out	std_logic_vector( 4  downto 0 );
		
		-- Logon 
		Ctrl2TxMsgGenTag98			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag108			: out 	std_logic_vector(15  downto 0 ); 
		Ctrl2TxMsgGenTag141			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag553			: out 	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgGenTag554			: out 	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgGenTag1137		: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag553Len		: out 	std_logic_vector( 4	 downto 0 );
		Ctrl2TxMsgGenTag554Len		: out 	std_logic_vector( 4	 downto 0 );
		-- Heartbeat
		Ctrl2TxMsgGenTag112			: out 	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgGenTag112Len		: out 	std_logic_vector( 4	 downto 0 );
		-- MrkDataReq 
		Ctrl2TxMsgGenTag262			: out 	std_logic_vector(15  downto 0 ); 
		Ctrl2TxMsgGenTag263			: out 	std_logic_vector( 7  downto 0 ); 
		Ctrl2TxMsgGenTag264			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag265			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag266			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag146			: out 	std_logic_vector( 3  downto 0 ); 
		Ctrl2TxMsgGenTag22			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag267			: out 	std_logic_vector( 2  downto 0 ); 
		Ctrl2TxMsgGenTag269			: out 	std_logic_vector(15  downto 0 ); 
		-- ResendReq 
		Ctrl2TxMsgGenTag7			: out 	std_logic_vector(26  downto 0 ); 
		Ctrl2TxMsgGenTag16			: out 	std_logic_vector( 7  downto 0 ); 
		-- SeqReset 
		Ctrl2TxMsgGenTag123			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag36			: out 	std_logic_vector(26  downto 0 );
		-- Reject 
		Ctrl2TxMsgGenTag45			: out 	std_logic_vector(26  downto 0 ); 
		Ctrl2TxMsgGenTag371			: out 	std_logic_vector(31  downto 0 ); 
		Ctrl2TxMsgGenTag372			: out 	std_logic_vector( 7  downto 0 );
		Ctrl2TxMsgGenTag373			: out 	std_logic_vector(15  downto 0 );
		Ctrl2TxMsgGenTag58			: out 	std_logic_vector(127 downto 0 );
		Ctrl2TxMsgGenTag371Len		: out 	std_logic_vector( 2  downto 0 ); 
		Ctrl2TxMsgGenTag373Len		: out 	std_logic_vector( 1  downto 0 ); 
		Ctrl2TxMsgGenTag58Len		: out 	std_logic_vector( 3  downto 0 ); 
		Ctrl2TxMsgGenTag371En		: out 	std_logic;
		Ctrl2TxMsgGenTag372En		: out 	std_logic;
		Ctrl2TxMsgGenTag373En		: out 	std_logic;
		Ctrl2TxMsgGenTag58En		: out 	std_logic;	
		-- Market data 
		Ctrl2TxMrketData0			: out	std_logic_vector( 9 downto 0 );
		Ctrl2TxMrketData1			: out	std_logic_vector( 9 downto 0 );
		Ctrl2TxMrketData2			: out	std_logic_vector( 9 downto 0 );
		Ctrl2TxMrketData3			: out	std_logic_vector( 9 downto 0 );
		Ctrl2TxMrketData4			: out	std_logic_vector( 9 downto 0 );
		Ctrl2TxMrketDataEn			: out	std_logic_vector( 2 downto 0 );
		
		-- Market data validation 
		Tx2CtrlMrketVal				: in 	std_logic_vector( 4 downto 0 );
		Tx2CtrlMrketSymbol0			: in	std_logic_vector(47 downto 0 );
		Tx2CtrlMrketSecurityID0		: in    std_logic_vector(15 downto 0 );
		Tx2CtrlMrketSymbol1			: in	std_logic_vector(47 downto 0 );
		Tx2CtrlMrketSecurityID1     : in    std_logic_vector(15 downto 0 );
		Tx2CtrlMrketSymbol2			: in	std_logic_vector(47 downto 0 );
		Tx2CtrlMrketSecurityID2     : in    std_logic_vector(15 downto 0 );
		Tx2CtrlMrketSymbol3			: in	std_logic_vector(47 downto 0 );
		Tx2CtrlMrketSecurityID3     : in    std_logic_vector(15 downto 0 );
		Tx2CtrlMrketSymbol4			: in	std_logic_vector(47 downto 0 );
		Tx2CtrlMrketSecurityID4     : in    std_logic_vector(15 downto 0 );
		
		-----------------------------------
		-- RxFix Interface 
		Ctrl2RxTOEConn				: out 	std_logic;
		Ctrl2RxExpSeqNum			: out	std_logic_vector(31 downto 0 );
		Ctrl2RxSecValid				: out	std_logic_vector( 4 downto 0 );
		Ctrl2RxSecSymbol0			: out	std_logic_vector(47 downto 0 );
		Ctrl2RxSecSymbol1			: out	std_logic_vector(47 downto 0 );
		Ctrl2RxSecSymbol2			: out	std_logic_vector(47 downto 0 );
		Ctrl2RxSecSymbol3			: out	std_logic_vector(47 downto 0 );
		Ctrl2RxSecSymbol4			: out	std_logic_vector(47 downto 0 );
		Ctrl2RxSecId0				: out   std_logic_vector(15 downto 0 );
		Ctrl2RxSecId1				: out   std_logic_vector(15 downto 0 );
		Ctrl2RxSecId2				: out   std_logic_vector(15 downto 0 );
		Ctrl2RxSecId3				: out   std_logic_vector(15 downto 0 );
		Ctrl2RxSecId4				: out   std_logic_vector(15 downto 0 );
		
		Rx2CtrlSeqNum				: in	std_logic_vector(31 downto 0 );
		Rx2CtrlMsgTypeVal			: in	std_logic_vector( 7 downto 0 ); 
		Rx2CtrlSeqNumError			: in	std_logic;
		Rx2CtrlPossDupFlag			: in	std_logic;
		Rx2CtrlMsgTimeYear			: in	std_logic_vector(10 downto 0 ); 
		Rx2CtrlMsgTimeMonth			: in	std_logic_vector( 3 downto 0 ); 
		Rx2CtrlMsgTimeDay			: in	std_logic_vector( 4 downto 0 ); 
		Rx2CtrlMsgTimeHour			: in	std_logic_vector( 4 downto 0 ); 
		Rx2CtrlMsgTimeMin			: in	std_logic_vector( 5 downto 0 ); 
		Rx2CtrlMsgTimeSec			: in	std_logic_vector(15 downto 0 ); 
		Rx2CtrlMsgTimeSecNegExp		: in	std_logic_vector( 1 downto 0 ); 
		Rx2CtrlTagErrorFlag			: in	std_logic;
		Rx2CtrlErrorTagLatch		: in	std_logic_vector(31 downto 0 );
		Rx2CtrlErrorTagLen			: in	std_logic_vector( 5 downto 0 );
		Rx2CtrlBodyLenError			: in	std_logic;
		Rx2CtrlCsumError			: in	std_logic;
		Rx2CtrlEncryptMetError		: in	std_logic;
		Rx2CtrlAppVerIdError		: in	std_logic;
		Rx2CtrlHeartBtInt			: in	std_logic_vector( 7 downto 0 ); 
		Rx2CtrlResetSeqNumFlag		: in	std_logic;
		Rx2CtrlTestReqId			: in	std_logic_vector(63 downto 0 ); 
		Rx2CtrlTestReqIdLen			: in	std_logic_vector( 5 downto 0 ); 
		Rx2CtrlTestReqIdVal			: in	std_logic;
		Rx2CtrlBeginSeqNum			: in	std_logic_vector(31 downto 0 ); 
		Rx2CtrlEndSeqNum			: in	std_logic_vector(31 downto 0 ); 
		Rx2CtrlRefSeqNum			: in	std_logic_vector(31 downto 0 ); 
		Rx2CtrlRefTagId				: in	std_logic_vector(15 downto 0 ); 
		Rx2CtrlRefMsgType			: in	std_logic_vector( 7 downto 0 ); 
		Rx2CtrlRejectReason			: in	std_logic_vector( 2 downto 0 ); 
		Rx2CtrlGapFillFlag			: in	std_logic;
		Rx2CtrlNewSeqNum			: in	std_logic_vector(31 downto 0 ); 
		Rx2CtrlMDReqId				: in	std_logic_vector(15 downto 0 ); 
		Rx2CtrlMDReqIdLen			: in	std_logic_vector( 5 downto 0 )
	);
	End Component FixCtrl;
	
	Component TxFixMsg Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		FixCtrl2TxReq		: in	std_logic;
		FixCtrl2TxPossDupEn : in    std_logic;
		FixCtrl2TxReplyTest : in	std_logic;
		FixTx2CtrlBusy		: out	std_logic;
		
		-- Header Detail 
		MsgType				: in	std_logic_vector( 3  downto 0 );
		MsgSeqNum			: in	std_logic_vector(26  downto 0 );
		MsgSendTime			: in	std_logic_vector(50  downto 0 );
		MsgBeginString		: in	std_logic_vector(63  downto 0 );
		MsgSenderCompID		: in	std_logic_vector(127 downto 0 );
		MsgTargetCompID		: in	std_logic_vector(127 downto 0 );
		
		MsgBeginStringLen   : in	std_logic_vector( 3  downto 0 );
		MsgSenderCompIDLen	: in	std_logic_vector( 4  downto 0 );
		MsgTargetCompIDLen	: in	std_logic_vector( 4  downto 0 );
		
		-- Message Body 
		-- Logon 
		MsgGenTag98			: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag108		: in 	std_logic_vector(15  downto 0 ); 
		MsgGenTag141		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag553		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag554		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag1137		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag553Len		: in 	std_logic_vector( 4	 downto 0 );
		MsgGenTag554Len		: in 	std_logic_vector( 4	 downto 0 );
		-- Heartbeat
		MsgGenTag112		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag112Len		: in 	std_logic_vector( 4	 downto 0 );
		-- MrkDataReq 
		MsgGenTag262		: in 	std_logic_vector(15  downto 0 ); 
		MsgGenTag263		: in 	std_logic_vector( 7  downto 0 ); 
		MsgGenTag264		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag265		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag266		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag146		: in 	std_logic_vector( 3  downto 0 ); 
		MsgGenTag22			: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag267		: in 	std_logic_vector( 2  downto 0 ); 
		MsgGenTag269		: in 	std_logic_vector(15  downto 0 ); 
		-- ResendReq 
		MsgGenTag7			: in 	std_logic_vector(26  downto 0 ); 
		MsgGenTag16			: in 	std_logic_vector( 7  downto 0 ); 
		-- SeqReset 
		MsgGenTag123		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag36			: in 	std_logic_vector(26  downto 0 );
		-- Reject 
		MsgGenTag45			: in 	std_logic_vector(26  downto 0 ); 
		MsgGenTag371		: in 	std_logic_vector(31  downto 0 ); 
		MsgGenTag372		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag373		: in 	std_logic_vector(15  downto 0 );
		MsgGenTag58			: in 	std_logic_vector(127 downto 0 );
		MsgGenTag371Len		: in 	std_logic_vector( 2  downto 0 ); 
		MsgGenTag373Len		: in 	std_logic_vector( 1  downto 0 ); 
		MsgGenTag58Len		: in 	std_logic_vector( 3  downto 0 ); 
		MsgGenTag371En		: in 	std_logic;
		MsgGenTag372En		: in 	std_logic;
		MsgGenTag373En		: in 	std_logic;
		MsgGenTag58En		: in 	std_logic;
		
		-- Market data 
		MrketData0			: in	std_logic_vector( 9 downto 0 );
		MrketData1			: in	std_logic_vector( 9 downto 0 );
		MrketData2			: in	std_logic_vector( 9 downto 0 );
		MrketData3			: in	std_logic_vector( 9 downto 0 );
		MrketData4			: in	std_logic_vector( 9 downto 0 );
		MrketDataEn			: in	std_logic_vector( 2 downto 0 );
		
		-- Market data validation 
		MrketVal			: out 	std_logic_vector( 4 downto 0 );
		MrketSymbol0		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID0	: out   std_logic_vector(15 downto 0 );
		MrketSymbol1		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID1    : out   std_logic_vector(15 downto 0 );
		MrketSymbol2		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID2    : out   std_logic_vector(15 downto 0 );
		MrketSymbol3		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID3    : out   std_logic_vector(15 downto 0 );
		MrketSymbol4		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID4    : out   std_logic_vector(15 downto 0 );
		
		-- TxTOE I/F 
		TOE2FixMemAlFull	: in 	std_logic;	
		
		Fix2TOEDataVal		: out 	std_logic;
		Fix2TOEDataSop		: out	std_logic;
		Fix2TOEDataEop		: out	std_logic;
		Fix2TOEData			: out 	std_logic_vector( 7  downto 0 );
		Fix2TOEDataLen		: out	std_logic_vector(15  downto 0 )
	);
	End Component TxFixMsg;
	
	Component RxFix Is
	Port
	(
		RstB				: in	std_logic;
		Clk					: in	std_logic; 
		
		-- To RxHdDec
		UserValid 			: in	std_logic;
		UserSenderId		: in 	std_logic_vector( 103 downto 0 );
		UserTargetId		: in 	std_logic_vector( 103 downto 0 );
		FixSOP				: in	std_logic;
		FixValid			: in	std_logic;
		FixEOP				: in	std_logic;
		FixData				: in	std_logic_vector( 7 downto 0 );
		TCPConnect			: in	std_logic;
		ExpSeqNum			: in 	std_logic_vector( 31 downto 0 );
		
		-- To RxMsgDec
		SecValid			: in	std_logic_vector( 4 downto 0 );
		SecSymbol0			: in	std_logic_vector( 47 downto 0 );
		SrcId0				: in	std_logic_vector( 15 downto 0 );
		SecSymbol1			: in	std_logic_vector( 47 downto 0 );
		SrcId1				: in	std_logic_vector( 15 downto 0 );
		SecSymbol2			: in	std_logic_vector( 47 downto 0 );
		SrcId2				: in	std_logic_vector( 15 downto 0 );
		SecSymbol3			: in	std_logic_vector( 47 downto 0 );
		SrcId3				: in	std_logic_vector( 15 downto 0 );
		SecSymbol4			: in	std_logic_vector( 47 downto 0 );
		SrcId4				: in	std_logic_vector( 15 downto 0 );
		
		-- To Control Unit
		MsgTypeVal			: out 	std_logic_vector( 7 downto 0 );	
		BLenError			: out 	std_logic;
		CSumError			: out 	std_logic;
		TagError			: out 	std_logic;
		ErrorTagLatch		: out	std_logic_vector( 31 downto 0 );
		ErrorTagLen			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2020
		SeqNumError			: out	std_logic;
		SeqNum				: out	std_logic_vector( 31 downto 0 );		
		PossDupFlag			: out	std_logic;
		TimeYear			: out 	std_logic_vector( 10 downto 0 );	
		TimeMonth			: out 	std_logic_vector( 3 downto 0 );
		TimeDay				: out 	std_logic_vector( 4 downto 0 );
		TimeHour			: out 	std_logic_vector( 4 downto 0 );
		TimeMin				: out 	std_logic_vector( 5 downto 0 );
		TimeSec				: out 	std_logic_vector( 15 downto 0 );
		TimeSecNegExp		: out 	std_logic_vector( 1 downto 0 );
		
		HeartBtInt			: out 	std_logic_vector( 15 downto 0 );	-- update 22/02/2021
		ResetSeqNumFlag		: out	std_logic;
		EncryptMetError		: out	std_logic;	
		AppVerIdError		: out	std_logic;	
		TestReqIdVal		: out	std_logic;							-- update 25/02/2021
		TestReqId			: out 	std_logic_vector( 63 downto 0 );
		TestReqIdLen		: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
		BeginSeqNum			: out 	std_logic_vector( 31 downto 0 );
		EndSeqNum			: out 	std_logic_vector( 31 downto 0 );
		RefSeqNum			: out 	std_logic_vector( 31 downto 0 );
		RefTagId			: out 	std_logic_vector( 15 downto 0 );
		RefMsgType			: out 	std_logic_vector( 7 downto 0 );
		RejectReason		: out 	std_logic_vector( 2 downto 0 );
		GapFillFlag			: out	std_logic;
		NewSeqNum			: out 	std_logic_vector( 31 downto 0 );
		MDReqId				: out	std_logic_vector( 15 downto 0 );
		MDReqIdLen			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
		
		-- To User
		MsgVal2User			: out 	std_logic_vector( 7 downto 0 );
		SecIndic			: out 	std_logic_vector( 4 downto 0 );
		EntriesVal			: out	std_logic_vector( 1 downto 0 );
		BidPx				: out 	std_logic_vector( 15 downto 0 );
		BidPxNegExp			: out 	std_logic_vector( 1 downto 0 );
		BidSize				: out 	std_logic_vector( 31 downto 0 );
		BidTimeHour			: out 	std_logic_vector( 7 downto 0 );
		BidTimeMin          : out 	std_logic_vector( 7 downto 0 );
		BidTimeSec          : out 	std_logic_vector( 15 downto 0 );
		BidTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 );
		
		OffPx				: out 	std_logic_vector( 15 downto 0 );
		OffPxNegExp			: out 	std_logic_vector( 1 downto 0 );
		OffSize				: out 	std_logic_vector( 31 downto 0 );
		OffTimeHour			: out 	std_logic_vector( 7 downto 0 );
		OffTimeMin          : out 	std_logic_vector( 7 downto 0 );
		OffTimeSec          : out 	std_logic_vector( 15 downto 0 );
		OffTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 );
		SpecialPxFlag		: out 	std_logic_vector( 1 downto 0 );
		-- Test Error port
		NoEntriesError		: out	std_logic
	);
	End Component RxFix;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	
	signal	Ctrl2TxReq					: std_logic;
    signal	Ctrl2TxPossDupEn 			: std_logic;
    signal	Ctrl2TxReplyTest 			: std_logic;
    signal	Tx2CtrlBusy					: std_logic;

    signal	Ctrl2TxMsgType				: std_logic_vector( 3  downto 0 );
    signal	Ctrl2TxMsgSeqNum			: std_logic_vector(26  downto 0 );    
    signal	Ctrl2TxMsgSendTime			: std_logic_vector(50  downto 0 );
    signal	Ctrl2TxMsgBeginString		: std_logic_vector(63  downto 0 );
    signal	Ctrl2TxMsgSenderCompID		: std_logic_vector(127 downto 0 );
    signal	Ctrl2TxMsgTargetCompID		: std_logic_vector(127 downto 0 );
    signal	Ctrl2TxMsgBeginStringLen   	: std_logic_vector( 3  downto 0 );
    signal	Ctrl2TxMsgSenderCompIDLen	: std_logic_vector( 4  downto 0 );
    signal	Ctrl2TxMsgTargetCompIDLen	: std_logic_vector( 4  downto 0 );
         
	signal	Ctrl2TxMsgGenTag98		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag108		    : std_logic_vector(15  downto 0 ); 
	signal	Ctrl2TxMsgGenTag141		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag553		    : std_logic_vector(127 downto 0 );
	signal	Ctrl2TxMsgGenTag554		    : std_logic_vector(127 downto 0 );
	signal	Ctrl2TxMsgGenTag1137	    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag553Len	    : std_logic_vector( 4  downto 0 );
	signal	Ctrl2TxMsgGenTag554Len	    : std_logic_vector( 4  downto 0 );
	signal	Ctrl2TxMsgGenTag112		    : std_logic_vector(127 downto 0 );
	signal	Ctrl2TxMsgGenTag112Len	    : std_logic_vector( 4  downto 0 );
	signal	Ctrl2TxMsgGenTag262		    : std_logic_vector(15  downto 0 ); 
	signal	Ctrl2TxMsgGenTag263		    : std_logic_vector( 7  downto 0 ); 
	signal	Ctrl2TxMsgGenTag264		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag265		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag266		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag146		    : std_logic_vector( 3  downto 0 ); 
	signal	Ctrl2TxMsgGenTag22		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag267		    : std_logic_vector( 2  downto 0 ); 
	signal	Ctrl2TxMsgGenTag269		    : std_logic_vector(15  downto 0 ); 
	signal	Ctrl2TxMsgGenTag7		    : std_logic_vector(26  downto 0 ); 
	signal	Ctrl2TxMsgGenTag16		    : std_logic_vector( 7  downto 0 ); 
	signal	Ctrl2TxMsgGenTag123		    : std_logic_vector( 7  downto 0 ); 
	signal	Ctrl2TxMsgGenTag36		    : std_logic_vector(26  downto 0 ); 
	signal	Ctrl2TxMsgGenTag45		    : std_logic_vector(26  downto 0 ); 
	signal	Ctrl2TxMsgGenTag371		    : std_logic_vector(31  downto 0 ); 
	signal	Ctrl2TxMsgGenTag372		    : std_logic_vector( 7  downto 0 );
	signal	Ctrl2TxMsgGenTag373		    : std_logic_vector(15  downto 0 );
	signal	Ctrl2TxMsgGenTag58		    : std_logic_vector(127 downto 0 );
	signal	Ctrl2TxMsgGenTag371Len	    : std_logic_vector( 2  downto 0 ); 
	signal	Ctrl2TxMsgGenTag373Len	    : std_logic_vector( 1  downto 0 ); 
	signal	Ctrl2TxMsgGenTag58Len	    : std_logic_vector( 3  downto 0 ); 
	signal	Ctrl2TxMsgGenTag371En	    : std_logic;
	signal	Ctrl2TxMsgGenTag372En	    : std_logic;
	signal	Ctrl2TxMsgGenTag373En	    : std_logic;
	signal	Ctrl2TxMsgGenTag58En		: std_logic;	
   
	signal	Ctrl2TxMrketData0		    : std_logic_vector( 9 downto 0 );
	signal	Ctrl2TxMrketData1		    : std_logic_vector( 9 downto 0 );
	signal	Ctrl2TxMrketData2		    : std_logic_vector( 9 downto 0 );
	signal	Ctrl2TxMrketData3		    : std_logic_vector( 9 downto 0 );
	signal	Ctrl2TxMrketData4		    : std_logic_vector( 9 downto 0 );
	signal	Ctrl2TxMrketDataEn		    : std_logic_vector( 2 downto 0 );
   
	signal	Tx2CtrlMrketVal			    : std_logic_vector( 4 downto 0 );
	signal	Tx2CtrlMrketSymbol0		    : std_logic_vector(47 downto 0 );
	signal	Tx2CtrlMrketSecurityID0	    : std_logic_vector(15 downto 0 );
	signal	Tx2CtrlMrketSymbol1		    : std_logic_vector(47 downto 0 );
	signal	Tx2CtrlMrketSecurityID1     : std_logic_vector(15 downto 0 );
	signal	Tx2CtrlMrketSymbol2		    : std_logic_vector(47 downto 0 );
	signal	Tx2CtrlMrketSecurityID2     : std_logic_vector(15 downto 0 );
	signal	Tx2CtrlMrketSymbol3		    : std_logic_vector(47 downto 0 );
	signal	Tx2CtrlMrketSecurityID3     : std_logic_vector(15 downto 0 );
	signal	Tx2CtrlMrketSymbol4		    : std_logic_vector(47 downto 0 );
	signal	Tx2CtrlMrketSecurityID4     : std_logic_vector(15 downto 0 );
 
	signal	Ctrl2RxTOEConn			    : std_logic;
	signal	Ctrl2RxExpSeqNum			: std_logic_vector(31 downto 0 );
	signal	Ctrl2RxSecValid			    : std_logic_vector( 4 downto 0 );
	signal	Ctrl2RxSecSymbol0		    : std_logic_vector(47 downto 0 );
	signal	Ctrl2RxSecSymbol1		    : std_logic_vector(47 downto 0 );
	signal	Ctrl2RxSecSymbol2		    : std_logic_vector(47 downto 0 );
	signal	Ctrl2RxSecSymbol3		    : std_logic_vector(47 downto 0 );
	signal	Ctrl2RxSecSymbol4		    : std_logic_vector(47 downto 0 );
	signal	Ctrl2RxSecId0			    : std_logic_vector(15 downto 0 );
	signal	Ctrl2RxSecId1			    : std_logic_vector(15 downto 0 );
	signal	Ctrl2RxSecId2			    : std_logic_vector(15 downto 0 );
	signal	Ctrl2RxSecId3			    : std_logic_vector(15 downto 0 );
	signal	Ctrl2RxSecId4			    : std_logic_vector(15 downto 0 );
 
	signal	Rx2CtrlSeqNum			    : std_logic_vector(31 downto 0 );
	signal	Rx2CtrlMsgTypeVal		    : std_logic_vector( 7 downto 0 ); 
	signal	Rx2CtrlSeqNumError		    : std_logic;
	signal	Rx2CtrlPossDupFlag		    : std_logic;
	signal	Rx2CtrlMsgTimeYear		    : std_logic_vector(10 downto 0 ); 
	signal	Rx2CtrlMsgTimeMonth		    : std_logic_vector( 3 downto 0 ); 
	signal	Rx2CtrlMsgTimeDay		    : std_logic_vector( 4 downto 0 ); 
	signal	Rx2CtrlMsgTimeHour		    : std_logic_vector( 4 downto 0 ); 
	signal	Rx2CtrlMsgTimeMin		    : std_logic_vector( 5 downto 0 ); 
	signal	Rx2CtrlMsgTimeSec		    : std_logic_vector(15 downto 0 ); 
	signal	Rx2CtrlMsgTimeSecNegExp	    : std_logic_vector( 1 downto 0 ); 
	signal	Rx2CtrlTagErrorFlag		    : std_logic;
	signal	Rx2CtrlErrorTagLatch		: std_logic_vector(31 downto 0 );
	signal	Rx2CtrlErrorTagLen		    : std_logic_vector( 5 downto 0 );
	signal	Rx2CtrlBodyLenError		    : std_logic;
	signal	Rx2CtrlCsumError			: std_logic;
	signal	Rx2CtrlEncryptMetError	    : std_logic;
	signal	Rx2CtrlAppVerIdError		: std_logic;
	signal	Rx2CtrlHeartBtInt		    : std_logic_vector(15 downto 0 ); 
	signal	Rx2CtrlResetSeqNumFlag	    : std_logic;
	signal	Rx2CtrlTestReqId			: std_logic_vector(63 downto 0 ); 
	signal	Rx2CtrlTestReqIdLen		    : std_logic_vector( 5 downto 0 ); 
	signal	Rx2CtrlTestReqIdVal		    : std_logic;
	signal	Rx2CtrlBeginSeqNum		    : std_logic_vector(31 downto 0 ); 
	signal	Rx2CtrlEndSeqNum			: std_logic_vector(31 downto 0 ); 
	signal	Rx2CtrlRefSeqNum			: std_logic_vector(31 downto 0 ); 
	signal	Rx2CtrlRefTagId			    : std_logic_vector(15 downto 0 ); 
	signal	Rx2CtrlRefMsgType		    : std_logic_vector( 7 downto 0 ); 
	signal	Rx2CtrlRejectReason		    : std_logic_vector( 2 downto 0 ); 
	signal	Rx2CtrlGapFillFlag		    : std_logic;
    signal	Rx2CtrlNewSeqNum			: std_logic_vector(31 downto 0 ); 
    signal	Rx2CtrlMDReqId			    : std_logic_vector(15 downto 0 ); 
    signal	Rx2CtrlMDReqIdLen		    : std_logic_vector( 5 downto 0 );

Begin                                   
-----------------------------------------------------------------------------
-- DFF: Component                          
-----------------------------------------------------------------------------

	u_FixCtrl : FixCtrl
	Port map
	(
		Clk							=> Clk							,
		RstB						=> RstB                         ,

		-----------------------------------                                        
		-- User Interface	                                                       
		UserFixConn					=> User2FixConn			        ,
		UserFixDisConn				=> User2FixDisConn			    ,
		UserFixRTCTime				=> User2FixRTCTime			    ,
		UserFixSenderCompID			=> User2FixSenderCompID	        ,
		UserFixTargetCompID			=> User2FixTargetCompID	        ,
		UserFixUsername				=> User2FixUsername		        ,
		UserFixPassword             => User2FixPassword             ,
		UserFixSenderCompIDLen		=> User2FixSenderCompIDLen	    ,
		UserFixTargetCompIDLen		=> User2FixTargetCompIDLen	    ,
		UserFixUsernameLen			=> User2FixUsernameLen		    ,
		UserFixPasswordLen	        => User2FixPasswordLen	        ,
	
		UserFixMrketData0			=> User2FixMrketData0		    ,
		UserFixMrketData1			=> User2FixMrketData1		    ,
		UserFixMrketData2			=> User2FixMrketData2		    ,
		UserFixMrketData3			=> User2FixMrketData3		    ,
		UserFixMrketData4			=> User2FixMrketData4		    ,
		UserFixNoRelatedSym			=> User2FixNoRelatedSym		    ,
		UserFixMDEntryTypes			=> User2FixMDEntryTypes		    ,
		UserFixNoMDEntryTypes		=> User2FixNoMDEntryTypes	    ,

		UserFixOperate				=> Fix2UserOperate			    ,
		UserFixError 				=> Fix2UserError 			    ,

		-----------------------------------                                        
		-- TOE Interface	                                                       
		Fix2TOEConnectReq			=> Fix2TOEConnectReq	        ,
		Fix2TOETerminateReq			=> Fix2TOETerminateReq	        ,
		Fix2TOERxDataReq			=> Fix2TOERxDataReq             ,
		
		TOE2FixStatus				=> TOE2FixStatus	            ,
		TOE2FixPSHFlagset			=> TOE2FixPSHFlagset            ,
		TOE2FixFINFlagset 			=> TOE2FixFINFlagset            ,
		TOE2FixRSTFlagset			=> TOE2FixRSTFlagset            ,

		-----------------------------------                                        
		-- TxFix Interface                                                         
		Ctrl2TxReq					=> Ctrl2TxReq					,
		Ctrl2TxPossDupEn 			=> Ctrl2TxPossDupEn 			,
		Ctrl2TxReplyTest 			=> Ctrl2TxReplyTest 			,
		Tx2CtrlBusy					=> Tx2CtrlBusy					,
	
		Ctrl2TxMsgType				=> Ctrl2TxMsgType				,
		Ctrl2TxMsgSeqNum			=> Ctrl2TxMsgSeqNum			    ,
		Ctrl2TxMsgSendTime			=> Ctrl2TxMsgSendTime			,
		Ctrl2TxMsgBeginString		=> Ctrl2TxMsgBeginString		,
		Ctrl2TxMsgSenderCompID		=> Ctrl2TxMsgSenderCompID		,
		Ctrl2TxMsgTargetCompID		=> Ctrl2TxMsgTargetCompID		,
		Ctrl2TxMsgBeginStringLen   	=> Ctrl2TxMsgBeginStringLen   	,
		Ctrl2TxMsgSenderCompIDLen	=> Ctrl2TxMsgSenderCompIDLen	,
		Ctrl2TxMsgTargetCompIDLen	=> Ctrl2TxMsgTargetCompIDLen	,
	
		-- Logon                                                                   
		Ctrl2TxMsgGenTag98			=> Ctrl2TxMsgGenTag98		    ,
		Ctrl2TxMsgGenTag108			=> Ctrl2TxMsgGenTag108		    ,
		Ctrl2TxMsgGenTag141			=> Ctrl2TxMsgGenTag141		    ,
		Ctrl2TxMsgGenTag553			=> Ctrl2TxMsgGenTag553		    ,
		Ctrl2TxMsgGenTag554			=> Ctrl2TxMsgGenTag554		    ,
		Ctrl2TxMsgGenTag1137		=> Ctrl2TxMsgGenTag1137	        ,
		Ctrl2TxMsgGenTag553Len		=> Ctrl2TxMsgGenTag553Len	    ,
		Ctrl2TxMsgGenTag554Len		=> Ctrl2TxMsgGenTag554Len	    ,
		-- Heartbeat                                                               
		Ctrl2TxMsgGenTag112			=> Ctrl2TxMsgGenTag112			,
		Ctrl2TxMsgGenTag112Len		=> Ctrl2TxMsgGenTag112Len		,
		-- MrkDataReq                                                              
		Ctrl2TxMsgGenTag262			=> Ctrl2TxMsgGenTag262			,
		Ctrl2TxMsgGenTag263			=> Ctrl2TxMsgGenTag263			,
		Ctrl2TxMsgGenTag264			=> Ctrl2TxMsgGenTag264			,
		Ctrl2TxMsgGenTag265			=> Ctrl2TxMsgGenTag265			,
		Ctrl2TxMsgGenTag266			=> Ctrl2TxMsgGenTag266			,
		Ctrl2TxMsgGenTag146			=> Ctrl2TxMsgGenTag146			,
		Ctrl2TxMsgGenTag22			=> Ctrl2TxMsgGenTag22			,
		Ctrl2TxMsgGenTag267			=> Ctrl2TxMsgGenTag267			,
		Ctrl2TxMsgGenTag269			=> Ctrl2TxMsgGenTag269			,
		-- ResendReq                                                               
		Ctrl2TxMsgGenTag7			=> Ctrl2TxMsgGenTag7			,
		Ctrl2TxMsgGenTag16			=> Ctrl2TxMsgGenTag16			,
		-- SeqReset                                                                
		Ctrl2TxMsgGenTag123			=> Ctrl2TxMsgGenTag123			,
		Ctrl2TxMsgGenTag36			=> Ctrl2TxMsgGenTag36			,
		-- Reject                                                                  
		Ctrl2TxMsgGenTag45			=> Ctrl2TxMsgGenTag45			,
		Ctrl2TxMsgGenTag371			=> Ctrl2TxMsgGenTag371			,
		Ctrl2TxMsgGenTag372			=> Ctrl2TxMsgGenTag372			,
		Ctrl2TxMsgGenTag373			=> Ctrl2TxMsgGenTag373			,
		Ctrl2TxMsgGenTag58			=> Ctrl2TxMsgGenTag58			,
		Ctrl2TxMsgGenTag371Len		=> Ctrl2TxMsgGenTag371Len		,
		Ctrl2TxMsgGenTag373Len		=> Ctrl2TxMsgGenTag373Len		,
		Ctrl2TxMsgGenTag58Len		=> Ctrl2TxMsgGenTag58Len		,
		Ctrl2TxMsgGenTag371En		=> Ctrl2TxMsgGenTag371En		,
		Ctrl2TxMsgGenTag372En		=> Ctrl2TxMsgGenTag372En		,
		Ctrl2TxMsgGenTag373En		=> Ctrl2TxMsgGenTag373En		,
		Ctrl2TxMsgGenTag58En		=> Ctrl2TxMsgGenTag58En		    ,
		-- Market data                                                             
		Ctrl2TxMrketData0			=> Ctrl2TxMrketData0			,
		Ctrl2TxMrketData1			=> Ctrl2TxMrketData1			,
		Ctrl2TxMrketData2			=> Ctrl2TxMrketData2			,
		Ctrl2TxMrketData3			=> Ctrl2TxMrketData3			,
		Ctrl2TxMrketData4			=> Ctrl2TxMrketData4			,
		Ctrl2TxMrketDataEn			=> Ctrl2TxMrketDataEn			,
		
		-- Market data validation                                                  
		Tx2CtrlMrketVal				=> Tx2CtrlMrketVal				,
		Tx2CtrlMrketSymbol0			=> Tx2CtrlMrketSymbol0			,
		Tx2CtrlMrketSecurityID0		=> Tx2CtrlMrketSecurityID0		,
		Tx2CtrlMrketSymbol1			=> Tx2CtrlMrketSymbol1			,
		Tx2CtrlMrketSecurityID1     => Tx2CtrlMrketSecurityID1      ,
		Tx2CtrlMrketSymbol2			=> Tx2CtrlMrketSymbol2			,
		Tx2CtrlMrketSecurityID2     => Tx2CtrlMrketSecurityID2      ,
		Tx2CtrlMrketSymbol3			=> Tx2CtrlMrketSymbol3			,
		Tx2CtrlMrketSecurityID3     => Tx2CtrlMrketSecurityID3      ,
		Tx2CtrlMrketSymbol4			=> Tx2CtrlMrketSymbol4			,
		Tx2CtrlMrketSecurityID4     => Tx2CtrlMrketSecurityID4      ,

		-----------------------------------                                        
		-- RxFix Interface                                                         
		Ctrl2RxTOEConn				=> Ctrl2RxTOEConn				,
		Ctrl2RxExpSeqNum			=> Ctrl2RxExpSeqNum			    ,
		Ctrl2RxSecValid				=> Ctrl2RxSecValid				,
		Ctrl2RxSecSymbol0			=> Ctrl2RxSecSymbol0			,
		Ctrl2RxSecSymbol1			=> Ctrl2RxSecSymbol1			,
		Ctrl2RxSecSymbol2			=> Ctrl2RxSecSymbol2			,
		Ctrl2RxSecSymbol3			=> Ctrl2RxSecSymbol3			,
		Ctrl2RxSecSymbol4			=> Ctrl2RxSecSymbol4			,
		Ctrl2RxSecId0				=> Ctrl2RxSecId0				,
		Ctrl2RxSecId1				=> Ctrl2RxSecId1				,
		Ctrl2RxSecId2				=> Ctrl2RxSecId2				,
		Ctrl2RxSecId3				=> Ctrl2RxSecId3				,
		Ctrl2RxSecId4				=> Ctrl2RxSecId4				,

		Rx2CtrlSeqNum				=> Rx2CtrlSeqNum				,
		Rx2CtrlMsgTypeVal			=> Rx2CtrlMsgTypeVal			,
		Rx2CtrlSeqNumError			=> Rx2CtrlSeqNumError			,
		Rx2CtrlPossDupFlag			=> Rx2CtrlPossDupFlag			,
		Rx2CtrlMsgTimeYear			=> Rx2CtrlMsgTimeYear			,
		Rx2CtrlMsgTimeMonth			=> Rx2CtrlMsgTimeMonth			,
		Rx2CtrlMsgTimeDay			=> Rx2CtrlMsgTimeDay			,
		Rx2CtrlMsgTimeHour			=> Rx2CtrlMsgTimeHour			,
		Rx2CtrlMsgTimeMin			=> Rx2CtrlMsgTimeMin			,
		Rx2CtrlMsgTimeSec			=> Rx2CtrlMsgTimeSec			,
		Rx2CtrlMsgTimeSecNegExp		=> Rx2CtrlMsgTimeSecNegExp		,
		Rx2CtrlTagErrorFlag			=> Rx2CtrlTagErrorFlag			,
		Rx2CtrlErrorTagLatch		=> Rx2CtrlErrorTagLatch		    ,
		Rx2CtrlErrorTagLen			=> Rx2CtrlErrorTagLen			,
		Rx2CtrlBodyLenError			=> Rx2CtrlBodyLenError			,
		Rx2CtrlCsumError			=> Rx2CtrlCsumError			    ,
		Rx2CtrlEncryptMetError		=> Rx2CtrlEncryptMetError		,
		Rx2CtrlAppVerIdError		=> Rx2CtrlAppVerIdError		    ,
		Rx2CtrlHeartBtInt			=> Rx2CtrlHeartBtInt(7 downto 0),
		Rx2CtrlResetSeqNumFlag		=> Rx2CtrlResetSeqNumFlag		,
		Rx2CtrlTestReqId			=> Rx2CtrlTestReqId			    ,
		Rx2CtrlTestReqIdLen			=> Rx2CtrlTestReqIdLen			,
		Rx2CtrlTestReqIdVal			=> Rx2CtrlTestReqIdVal			,
		Rx2CtrlBeginSeqNum			=> Rx2CtrlBeginSeqNum			,
		Rx2CtrlEndSeqNum			=> Rx2CtrlEndSeqNum			    ,
		Rx2CtrlRefSeqNum			=> Rx2CtrlRefSeqNum			    ,
		Rx2CtrlRefTagId				=> Rx2CtrlRefTagId				,
		Rx2CtrlRefMsgType			=> Rx2CtrlRefMsgType			,
		Rx2CtrlRejectReason			=> Rx2CtrlRejectReason			,
		Rx2CtrlGapFillFlag			=> Rx2CtrlGapFillFlag			,
		Rx2CtrlNewSeqNum			=> Rx2CtrlNewSeqNum			    ,
		Rx2CtrlMDReqId				=> Rx2CtrlMDReqId				,
		Rx2CtrlMDReqIdLen			=> Rx2CtrlMDReqIdLen			
	);
	
	u_TxFixMsg : TxFixMsg 
	Port map
	(
		Clk							=> Clk							,
		RstB				        => RstB                         ,
		
		-- Control                  
		FixCtrl2TxReq		        => Ctrl2TxReq		            ,
		FixCtrl2TxPossDupEn         => Ctrl2TxPossDupEn             ,
		FixCtrl2TxReplyTest         => Ctrl2TxReplyTest             ,
		FixTx2CtrlBusy		        => Tx2CtrlBusy		            ,
		
		-- Header Detail                
		MsgType				        => Ctrl2TxMsgType				,
		MsgSeqNum			        => Ctrl2TxMsgSeqNum			    ,
		MsgSendTime			        => Ctrl2TxMsgSendTime			,
		MsgBeginString		        => Ctrl2TxMsgBeginString		,
		MsgSenderCompID		        => Ctrl2TxMsgSenderCompID		,
		MsgTargetCompID		        => Ctrl2TxMsgTargetCompID		,
	
		MsgBeginStringLen           => Ctrl2TxMsgBeginStringLen 	,
		MsgSenderCompIDLen	        => Ctrl2TxMsgSenderCompIDLen	,
		MsgTargetCompIDLen	        => Ctrl2TxMsgTargetCompIDLen    ,
		
		-- Message Body              
		-- Logon                                                             
		MsgGenTag98			        => Ctrl2TxMsgGenTag98		    ,
		MsgGenTag108		        => Ctrl2TxMsgGenTag108		    ,
		MsgGenTag141		        => Ctrl2TxMsgGenTag141		    ,
		MsgGenTag553		        => Ctrl2TxMsgGenTag553		    ,
		MsgGenTag554		        => Ctrl2TxMsgGenTag554		    ,
		MsgGenTag1137		        => Ctrl2TxMsgGenTag1137	        ,
		MsgGenTag553Len		        => Ctrl2TxMsgGenTag553Len	    ,
		MsgGenTag554Len		        => Ctrl2TxMsgGenTag554Len	    ,
		-- Heartbeat                                                               
		MsgGenTag112		        => Ctrl2TxMsgGenTag112		    ,
		MsgGenTag112Len		        => Ctrl2TxMsgGenTag112Len	    ,
		-- MrkDataReq                                                              
		MsgGenTag262		        => Ctrl2TxMsgGenTag262		    ,
		MsgGenTag263		        => Ctrl2TxMsgGenTag263		    ,
		MsgGenTag264		        => Ctrl2TxMsgGenTag264		    ,
		MsgGenTag265		        => Ctrl2TxMsgGenTag265		    ,
		MsgGenTag266		        => Ctrl2TxMsgGenTag266		    ,
		MsgGenTag146		        => Ctrl2TxMsgGenTag146		    ,
		MsgGenTag22			        => Ctrl2TxMsgGenTag22		    ,
		MsgGenTag267		        => Ctrl2TxMsgGenTag267		    ,
		MsgGenTag269		        => Ctrl2TxMsgGenTag269		    ,
		-- ResendReq                                                               
		MsgGenTag7			        => Ctrl2TxMsgGenTag7		    ,
		MsgGenTag16			        => Ctrl2TxMsgGenTag16		    ,
		-- SeqReset                                                                
		MsgGenTag123		        => Ctrl2TxMsgGenTag123		    ,
		MsgGenTag36			        => Ctrl2TxMsgGenTag36		    ,
		-- Reject                                                                  
		MsgGenTag45			        => Ctrl2TxMsgGenTag45		    ,
		MsgGenTag371		        => Ctrl2TxMsgGenTag371		    ,
		MsgGenTag372		        => Ctrl2TxMsgGenTag372		    ,
		MsgGenTag373		        => Ctrl2TxMsgGenTag373		    ,
		MsgGenTag58			        => Ctrl2TxMsgGenTag58		    ,
		MsgGenTag371Len		        => Ctrl2TxMsgGenTag371Len	    ,
		MsgGenTag373Len		        => Ctrl2TxMsgGenTag373Len	    ,
		MsgGenTag58Len		        => Ctrl2TxMsgGenTag58Len	    ,
		MsgGenTag371En		        => Ctrl2TxMsgGenTag371En	    ,
		MsgGenTag372En		        => Ctrl2TxMsgGenTag372En	    ,
		MsgGenTag373En		        => Ctrl2TxMsgGenTag373En	    ,
		MsgGenTag58En		        => Ctrl2TxMsgGenTag58En		    ,
		
		-- Market data                                                             
		MrketData0			        => Ctrl2TxMrketData0		    ,
		MrketData1			        => Ctrl2TxMrketData1		    ,
		MrketData2			        => Ctrl2TxMrketData2		    ,
		MrketData3			        => Ctrl2TxMrketData3		    ,
		MrketData4			        => Ctrl2TxMrketData4		    ,
		MrketDataEn			        => Ctrl2TxMrketDataEn		    ,
		
		-- Market data validation         
		MrketVal			        => Tx2CtrlMrketVal			    ,
		MrketSymbol0		        => Tx2CtrlMrketSymbol0		    ,
		MrketSecurityID0	        => Tx2CtrlMrketSecurityID0	    ,
		MrketSymbol1		        => Tx2CtrlMrketSymbol1		    ,
		MrketSecurityID1            => Tx2CtrlMrketSecurityID1      ,
		MrketSymbol2		        => Tx2CtrlMrketSymbol2		    ,
		MrketSecurityID2            => Tx2CtrlMrketSecurityID2      ,
		MrketSymbol3		        => Tx2CtrlMrketSymbol3		    ,
		MrketSecurityID3            => Tx2CtrlMrketSecurityID3      ,
		MrketSymbol4		        => Tx2CtrlMrketSymbol4		    ,
		MrketSecurityID4            => Tx2CtrlMrketSecurityID4      ,
	
		-- TxTOE I/F             
		TOE2FixMemAlFull	        => TOE2FixMemAlFull             ,
		
		Fix2TOEDataVal		        => Fix2TOEDataVal	            ,
		Fix2TOEDataSop		        => Fix2TOEDataSop	            ,
		Fix2TOEDataEop		        => Fix2TOEDataEop	            ,
		Fix2TOEData			        => Fix2TOEData		            ,
		Fix2TOEDataLen		        => Fix2TOEDataLen	                             
	);
	
	u_RxFix : RxFix 
	Port map 
	(
		RstB						=> RstB							,
		Clk					        => Clk	                        ,

		-- To RxHdDec                   
		UserValid 			        => User2FixIdValid 	            ,
		UserSenderId		        => User2FixRxTargetId           ,
		UserTargetId		        => User2FixRxSenderId           ,
		FixSOP				        => TOE2FixRxSOP	                ,
		FixValid			        => TOE2FixRxValid	            ,
		FixEOP				        => TOE2FixRxEOP	                ,
		FixData				        => TOE2FixRxData	            ,
		TCPConnect			        => Ctrl2RxTOEConn               ,
		ExpSeqNum			        => Ctrl2RxExpSeqNum	            ,

		-- To RxMsgDec                    
		SecValid			        => Ctrl2RxSecValid	            ,
		SecSymbol0			        => Ctrl2RxSecSymbol0	        ,
		SrcId0				        => Ctrl2RxSecId0                ,
		SecSymbol1			        => Ctrl2RxSecSymbol1            ,
		SrcId1				        => Ctrl2RxSecId1                ,
		SecSymbol2			        => Ctrl2RxSecSymbol2            ,
		SrcId2				        => Ctrl2RxSecId2                ,
		SecSymbol3			        => Ctrl2RxSecSymbol3            ,
		SrcId3				        => Ctrl2RxSecId3                ,
		SecSymbol4			        => Ctrl2RxSecSymbol4            ,
		SrcId4				        => Ctrl2RxSecId4                ,

		-- To Control Unit                                                         
		MsgTypeVal			        => Rx2CtrlMsgTypeVal            ,
		BLenError			        => Rx2CtrlBodyLenError			,	
		CSumError			        => Rx2CtrlCsumError			    ,
		TagError			        => Rx2CtrlTagErrorFlag			,
		ErrorTagLatch		        => Rx2CtrlErrorTagLatch	        ,
		ErrorTagLen			        => Rx2CtrlErrorTagLen	        ,
		SeqNumError			        => Rx2CtrlSeqNumError	        ,
		SeqNum				        => Rx2CtrlSeqNum	            ,
		PossDupFlag			        => Rx2CtrlPossDupFlag	        ,
		TimeYear			        => Rx2CtrlMsgTimeYear	        ,
		TimeMonth			        => Rx2CtrlMsgTimeMonth	        ,
		TimeDay				        => Rx2CtrlMsgTimeDay	        ,
		TimeHour			        => Rx2CtrlMsgTimeHour			,
		TimeMin				        => Rx2CtrlMsgTimeMin		    ,
		TimeSec				        => Rx2CtrlMsgTimeSec			,
		TimeSecNegExp		        => Rx2CtrlMsgTimeSecNegExp		,	

		HeartBtInt			        => Rx2CtrlHeartBtInt            ,
		ResetSeqNumFlag		        => Rx2CtrlResetSeqNumFlag       ,
		EncryptMetError		        => Rx2CtrlEncryptMetError		,	
		AppVerIdError		        => Rx2CtrlAppVerIdError		    ,
		TestReqIdVal		        => Rx2CtrlTestReqIdVal			,
		TestReqId			        => Rx2CtrlTestReqId	            ,
		TestReqIdLen		        => Rx2CtrlTestReqIdLen	        ,
		BeginSeqNum			        => Rx2CtrlBeginSeqNum			,
		EndSeqNum			        => Rx2CtrlEndSeqNum			    ,
		RefSeqNum			        => Rx2CtrlRefSeqNum			    ,
		RefTagId			        => Rx2CtrlRefTagId				,
		RefMsgType			        => Rx2CtrlRefMsgType			,
		RejectReason		        => Rx2CtrlRejectReason			,
		GapFillFlag			        => Rx2CtrlGapFillFlag			,
		NewSeqNum			        => Rx2CtrlNewSeqNum			    ,
		MDReqId				        => Rx2CtrlMDReqId				,
		MDReqIdLen			        => Rx2CtrlMDReqIdLen			,
	
		-- To User                                                                 
		MsgVal2User			        => Fix2UserMsgVal2User			,
		SecIndic			        => Fix2UserSecIndic			    ,
		EntriesVal			        => Fix2UserEntriesVal			,
		BidPx				        => Fix2UserBidPx				,
		BidPxNegExp			        => Fix2UserBidPxNegExp			,
		BidSize				        => Fix2UserBidSize				,
		BidTimeHour			        => Fix2UserBidTimeHour			,
		BidTimeMin                  => Fix2UserBidTimeMin           ,
		BidTimeSec                  => Fix2UserBidTimeSec           ,
		BidTimeSecNegExp            => Fix2UserBidTimeSecNegExp     ,
	
		OffPx				        => Fix2UserOffPx			    ,
		OffPxNegExp			        => Fix2UserOffPxNegExp		    ,
		OffSize				        => Fix2UserOffSize			    ,
		OffTimeHour			        => Fix2UserOffTimeHour		    ,
		OffTimeMin                  => Fix2UserOffTimeMin           ,
		OffTimeSec                  => Fix2UserOffTimeSec           ,
		OffTimeSecNegExp            => Fix2UserOffTimeSecNegExp     ,
		SpecialPxFlag		        => Fix2UserSpecialPxFlag	    ,
		-- Test Error port                
		NoEntriesError		        => Fix2UserNoEntriesError
	);
	
End Architecture rtl;