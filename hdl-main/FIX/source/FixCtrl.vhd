----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     FixCtrl.vhd
-- Title        FIX controller 
-- 
-- Author       L.Ratchanon
-- Date         2021/03/07
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
--
-- MsgType 
-- '0000' : TestReq 
-- '0001' : Log on
-- '0010' : Heartbeat
-- '0011' : MrkDataReq
-- '0100' : ResendReq
-- '0101' : SeqReset
-- '0110' : Reject 
-- '0111' : Log out  
-- '1000' : Generate validation 
-- '1111' : Reset Validation 
--
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

Entity FixCtrl Is
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
End Entity FixCtrl;

Architecture rtl Of FixCtrl Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component Fifo72x8 Is 
	Port
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (71 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (71 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
	End Component Fifo72x8;
	
	Component Ram74x16 Is
	Port 
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (73 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wraddress	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q			: OUT STD_LOGIC_VECTOR (73 DOWNTO 0)
	);
	End Component Ram74x16;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cHeader_BeginString 	: std_logic_vector(63 downto 0 ) := x"464958542e312e31"; -- FIXT.1.1 
	constant cHeader_BeginStringLen	: std_logic_vector( 3 downto 0 ) := x"8"; -- 8 
	
	constant cTestReq_String		: std_logic_vector(63 downto 0 ) := x"5465737452657121";  -- TestReq!
	constant cTestReq_StringLen		: std_logic_vector( 3 downto 0 ) := x"8";
	
	constant cHbInterval_Bin36		: std_logic_vector(32 downto 0 ) := '1'&x"0C38_8D00"; -- 36 sec:  4,500,000,000 Clk
	constant cHbInterval_Bin		: std_logic_vector(31 downto 0 ) := x"DF84_7580"; -- 30 sec:  3,750,000,000 Clk
	constant cInitSeqNum_1			: std_logic_vector(26 downto 0 ) := "00"&x"0000_00"&'1'; -- 1 
	
	constant cAscii_0				: std_logic_vector( 7 downto 0 ) := x"30"; 
	constant cAscii_1			    : std_logic_vector( 7 downto 0 ) := x"31"; 
	constant cAscii_2               : std_logic_vector( 7 downto 0 ) := x"32"; 
	constant cAscii_3               : std_logic_vector( 7 downto 0 ) := x"33"; 
	constant cAscii_4               : std_logic_vector( 7 downto 0 ) := x"34"; 
	constant cAscii_5               : std_logic_vector( 7 downto 0 ) := x"35"; 
	constant cAscii_6               : std_logic_vector( 7 downto 0 ) := x"36"; 
	constant cAscii_7               : std_logic_vector( 7 downto 0 ) := x"37"; 
	constant cAscii_8               : std_logic_vector( 7 downto 0 ) := x"38"; 
	constant cAscii_9               : std_logic_vector( 7 downto 0 ) := x"39"; 
	constant cAscii_A               : std_logic_vector( 7 downto 0 ) := x"41"; 
	constant cAscii_M               : std_logic_vector( 7 downto 0 ) := x"4d"; 
	constant cAscii_W               : std_logic_vector( 7 downto 0 ) := x"57"; 
	constant cAscii_Y               : std_logic_vector( 7 downto 0 ) := x"59"; 
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	type 	StateType is 
					(
						stIdle,
						stInit,
						stWaitLogon,
						stEstablish,
						stTerminate,
						stSendLogOut,
						stWaitBusy,
						stWaitLogout
					);
	
	signal 	rState					: StateType;
	
	-- Rx Input
	signal  rRxCtrlRecvSeqNumCal	: std_logic_vector(26 downto 0 );
	signal  rRx2CtrlMsgTypeValFF	: std_logic_vector( 7 downto 0 );
	signal  rRxCtrlOutOfOrder		: std_logic_vector( 2 downto 0 );
	signal  rRx2CtrlPossDupFlagFF	: std_logic_vector( 1 downto 0 );
	signal  rRxCtrlMsgVal			: std_logic;
	
	-- RxFix Interface 
	signal  rCtrl2RxNewSeqNumFF		: std_logic_vector(26 downto 0 ); 
	signal  rCtrl2RxExpSeqNum		: std_logic_vector(26 downto 0 ); 
	signal	rRx2CtrlGapFillFlagFF	: std_logic;
	signal  rFixCtrl2RxTOEConn		: std_logic;
	
	-- User Interface 
	signal  rUserFixOperate			: std_logic;
	
	-- TOE Interface 
	signal  rFix2TOEConnectReq		: std_logic;
	signal  rFix2TOETerminateReq	: std_logic;
	signal  rFix2TOERxDataReq		: std_logic;
	
	-- ResendReq Process 
	signal  rCtrlRsrValid			: std_logic_vector( 1 downto 0 );
	
	-- Heartbeat Process 
	signal  rCtrlHbRxCnt			: std_logic_vector(32 downto 0 );
	signal  rCtrlHbTxCnt			: std_logic_vector(31 downto 0 );
	signal  rCtrlHbRxCntRst			: std_logic;
	signal  rCtrlHbTxCntRst			: std_logic;
	
	-- MrkdataReq Process 
	signal  rCtrlMrkDataEn			: std_logic;
	
	-- TestReq Process 
	signal  rCtrlTtrBusy			: std_logic_vector( 3 downto 0 );
	signal  rRx2CtrlSeqNumFF		: std_logic_vector( 2 downto 0 );
	signal  rCtrlTtrDetect			: std_logic_vector( 1 downto 0 );
	
	-- Rejection message Rx Process 
	signal  rRx2CtrlErrorTagLatchFF	: std_logic_vector(31 downto 0 );
	signal  rCtrlRjtRxRefTagID		: std_logic_vector(31 downto 0 );
	signal  rCtrlRjtRxRefSeqNum		: std_logic_vector(26 downto 0 );
	signal  rCtrlRjtRxMsgType		: std_logic_vector( 7 downto 0 );
	signal  rCtrlRjtRxValid			: std_logic_vector( 3 downto 0 );
	signal  rRx2CtrlErrorTagLenFF	: std_logic_vector( 2 downto 0 );
	signal  rCtrlRjtRxRefTagIDLen	: std_logic_vector( 2 downto 0 );
	signal  rCtrlRjtRxRefTagIDCnt	: std_logic_vector( 2 downto 0 );
	signal  rCtrlRjtRxReason		: std_logic_vector( 1 downto 0 );
	
	-- Reject FIFO 
	signal  rFifoQueueWrData		: std_logic_vector(71 downto 0 );
	signal  rFifoQueueRdData		: std_logic_vector(71 downto 0 );
	signal  rFifoQueueRdReq			: std_logic_vector( 1 downto 0 );
	signal  rFifoQueueFull			: std_logic; 
	signal  rFifoQueueEmpty			: std_logic;
	signal  rFifoQueueReset			: std_logic;
	
	-- Rejection message Tx Process 
	signal  rCtrlRjtTxBusy			: std_logic_vector( 2 downto 0 );
	signal  rCtrlRjtTxRefTagID		: std_logic_vector(31 downto 0 );
	signal  rCtrlRjtTxRefSeqNum		: std_logic_vector(26 downto 0 );
	signal  rCtrlRjtTxSessReason	: std_logic_vector(15 downto 0 );
	signal  rCtrlRjtTxRefMsgType	: std_logic_vector( 7 downto 0 );
	signal  rCtrlRjtTxRefTagIDLen	: std_logic_vector( 2 downto 0 );
	signal  rCtrlRjtTxReason		: std_logic_vector( 1 downto 0 );
	signal  rCtrlRjtTxSessReasonLen	: std_logic_vector( 1 downto 0 );
	signal  rCtrlRjtTxRefTagIDEn	: std_logic;
	signal  rCtrlRjtTxValid			: std_logic;
	
	-- TestReq Reply process 
	signal  rCtrlTrrText			: std_logic_vector(63 downto 0 );
	signal  rCtrlTrrTextLen			: std_logic_vector( 3 downto 0 );
	signal  rCtrlTrrTextCnt			: std_logic_vector( 3 downto 0 );
	signal  rCtrlTrrValid			: std_logic_vector( 1 downto 0 );
	
	-- Logout Timeout process  
	signal  rCtrlLogonTimeoutCnt	: std_logic_vector(32 downto 0 );
	signal  rCtrlLogoutTimeoutCnt	: std_logic_vector(32 downto 0 );
	signal  rCtrlLogoutEn			: std_logic_vector( 1 downto 0 );
	
	-- TxFix Interface
	signal  rCtrl2TxSeqNum			: std_logic_vector(26 downto 0 );
	signal  rCtrl2TxReqMsg			: std_logic_vector(10 downto 0 );
	signal  rCtrl2TxMsgType			: std_logic_vector( 3 downto 0 );
	signal  rCtrl2TxTranEn			: std_logic;
	signal  rCtrl2TxReq				: std_logic;
	
	signal  rCtrl2TxMsgGenTag112	: std_logic_vector(127 downto 0 );
	signal  rCtrl2TxMsgGenTag112Len	: std_logic_vector( 3 downto 0 );
	signal  rCtrl2TxReplyTest		: std_logic;
	
	-- RetranRam 
	signal  rRetranRamWrData		: std_logic_vector(73 downto 0 );
	signal  rRetranRamRdData		: std_logic_vector(73 downto 0 );
	signal  rRetranRamRdAddr		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRetranMsgType		: std_logic_vector( 1 downto 0 );
	
	-- Resend write I/F 
	signal  rCtrlRsqBeginSeqNum		: std_logic_vector(26 downto 0 );
	signal  rCtrlRsqEndSeqNum		: std_logic_vector(26 downto 0 );
	signal  rCtrlRsqEndAddr1		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqEndAddr0		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqBusy			: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqDetect			: std_logic;
	
	signal  rCtrlRsqBeginSeqNumCal	: std_logic_vector(26 downto 0 );
	signal  rCtrlRsqEndSeqNumCal	: std_logic_vector(26 downto 0 );
	signal  rCtrlRsqRstSeqEn		: std_logic_vector( 4 downto 0 );
	signal  rCtrlRsqMrkDatEn		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqRejectEn		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqSeqNumCnt		: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqAddrCal			: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqEn				: std_logic_vector( 3 downto 0 );
	signal  rCtrlRsqCheckEnd		: std_logic;
	signal  rCtrlRsqStart			: std_logic;
	signal  rCtrlRsqEnd				: std_logic;
	
	-- Error signal 
	signal  rCtrlError				: std_logic_vector( 3 downto 0 );
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	UserFixOperate							<=	rUserFixOperate;
	UserFixError 							<=  rCtrlError;
	
	-- TOE Interface 
	Fix2TOEConnectReq			            <= 	rFix2TOEConnectReq;
	Fix2TOETerminateReq				        <= 	rFix2TOETerminateReq;
	Fix2TOERxDataReq						<= 	rFix2TOERxDataReq;
	
	-- Tx I/F
	Ctrl2TxReq								<=  rCtrl2TxReq;
	Ctrl2TxPossDupEn 						<=	rCtrlRsqEn(0);
	Ctrl2TxReplyTest 						<=  rCtrl2TxReplyTest;
	Ctrl2TxMsgType( 3 downto 0 )            <= 	rCtrl2TxMsgType( 3 downto 0 );
	Ctrl2TxMsgSeqNum(26 downto 0 )          <=  rCtrl2TxSeqNum(26 downto 0 );
	Ctrl2TxMsgSendTime(50  downto 0 )       <=	UserFixRTCTime(50  downto 0 );
	Ctrl2TxMsgBeginString(63 downto 0 )     <=  cHeader_BeginString; 
	Ctrl2TxMsgSenderCompID(127 downto 0 )   <=  UserFixSenderCompID(127 downto 0 );
	Ctrl2TxMsgTargetCompID(127 downto 0 )   <=  UserFixTargetCompID(127 downto 0 );
	Ctrl2TxMsgBeginStringLen( 3 downto 0 )  <=  cHeader_BeginStringLen; 
	Ctrl2TxMsgSenderCompIDLen( 4 downto 0 ) <=	UserFixSenderCompIDLen( 4 downto 0 );
	Ctrl2TxMsgTargetCompIDLen( 4 downto 0 ) <=  UserFixTargetCompIDLen( 4 downto 0 );
	-- Logon                                      
	Ctrl2TxMsgGenTag98( 7 downto 0 )        <=  cAscii_0; -- Fixed value: 0 
	Ctrl2TxMsgGenTag108(15 downto 0 )       <=  cAscii_3&cAscii_0; -- Fixed Heartbeat interval 30 sec 
	Ctrl2TxMsgGenTag141( 7 downto 0 )       <=	cAscii_Y; -- Fixed value: Y 
	Ctrl2TxMsgGenTag553(127 downto 0 )      <=  UserFixUsername(127 downto 0 );
	Ctrl2TxMsgGenTag554(127 downto 0 )      <=  UserFixPassword(127 downto 0 );
	Ctrl2TxMsgGenTag1137( 7 downto 0 )      <=	cAscii_9; -- Fixed value: 9 
	Ctrl2TxMsgGenTag553Len( 4 downto 0 )    <=	UserFixUsernameLen( 4 downto 0 );
	Ctrl2TxMsgGenTag554Len( 4 downto 0 )    <=  UserFixPasswordLen( 4 downto 0 );
	-- Heartbeat                                  
	Ctrl2TxMsgGenTag112(127 downto 0 )	    <=	rCtrl2TxMsgGenTag112(127 downto 0 );	
	Ctrl2TxMsgGenTag112Len( 4 downto 0 ) 	<=  '0'&rCtrl2TxMsgGenTag112Len(3 downto 0);
	-- MrkDataReq                                 
	Ctrl2TxMsgGenTag262(15 downto 0 )	    <= 	cAscii_M&cAscii_A; -- Fixed value: MA 
	Ctrl2TxMsgGenTag263( 7 downto 0 )	    <=  cAscii_1; -- Fixed value: 1 
	Ctrl2TxMsgGenTag264( 7 downto 0 )	    <=  cAscii_1; -- Fixed value: 1 
	Ctrl2TxMsgGenTag265( 7 downto 0 )	    <=  cAscii_0; -- Fixed value: 0 
	Ctrl2TxMsgGenTag266( 7 downto 0 )	    <=  cAscii_Y; -- Fixed value: Y
	Ctrl2TxMsgGenTag146( 3 downto 0 )	    <=	UserFixNoRelatedSym( 3 downto 0 );
	Ctrl2TxMsgGenTag22( 7 downto 0 )	    <=  cAscii_8; -- Fixed value: 8
	Ctrl2TxMsgGenTag267( 2 downto 0 )	    <=	UserFixNoMDEntryTypes( 2 downto 0 );
	Ctrl2TxMsgGenTag269(15 downto 0 )	    <=  UserFixMDEntryTypes(15 downto 0 );
	-- ResendReq                                  
	Ctrl2TxMsgGenTag7(26  downto 0 ) 	    <=  rCtrl2RxExpSeqNum(26 downto 0 ); -- Expected receiving seqnum 
	Ctrl2TxMsgGenTag16( 7 downto 0 )	    <=	cAscii_0; -- Fixed value: 0 (Always Go-Back-N)
	-- SeqReset                                   
	Ctrl2TxMsgGenTag123( 7 downto 0 )	    <= 	cAscii_Y; -- Fixed value: Y (Always Gap fill mode)
	Ctrl2TxMsgGenTag36(26 downto 0 )	    <=	rCtrl2TxSeqNum(26 downto 0 ); -- Next transmitting seqnum 
	-- Reject                                     
	Ctrl2TxMsgGenTag45(26 downto 0 )	    <=	rCtrlRjtTxRefSeqNum(26 downto 0 );
	Ctrl2TxMsgGenTag371(31 downto 0 ) 	    <=	rCtrlRjtTxRefTagID(31 downto 0 );
	Ctrl2TxMsgGenTag372( 7 downto 0 ) 	    <=	rCtrlRjtTxRefMsgType( 7 downto 0 );
	Ctrl2TxMsgGenTag373(15 downto 0 )	    <=	rCtrlRjtTxSessReason(15 downto 0 );
	Ctrl2TxMsgGenTag58(127 downto 0 )	    <=	(others=>'0'); -- Text NOT USED 
	Ctrl2TxMsgGenTag371Len( 2 downto 0 )	<=	rCtrlRjtTxRefTagIDLen( 2 downto 0 );
	Ctrl2TxMsgGenTag373Len( 1 downto 0 )	<=	rCtrlRjtTxSessReasonLen( 1 downto 0 );
	Ctrl2TxMsgGenTag58Len( 3 downto 0 )	    <=	x"0";
	Ctrl2TxMsgGenTag371En		            <=  rCtrlRjtTxRefTagIDEn; -- When Reason=99 TagID offf
	Ctrl2TxMsgGenTag372En		            <=	'1'; -- MsgType always transmitting
	Ctrl2TxMsgGenTag373En		            <=	'1'; -- reason always transmitting
	Ctrl2TxMsgGenTag58En		            <=	'0'; -- Text always off 
	-- Market data                              
	Ctrl2TxMrketData0( 9 downto 0 )	        <=  UserFixMrketData0( 9 downto 0 );	
	Ctrl2TxMrketData1( 9 downto 0 )	        <=  UserFixMrketData1( 9 downto 0 );	
	Ctrl2TxMrketData2( 9 downto 0 )	        <=  UserFixMrketData2( 9 downto 0 );	
	Ctrl2TxMrketData3( 9 downto 0 )	        <=  UserFixMrketData3( 9 downto 0 );	
	Ctrl2TxMrketData4( 9 downto 0 )	        <=  UserFixMrketData4( 9 downto 0 );	
	Ctrl2TxMrketDataEn( 2 downto 0 )		<=  UserFixNoRelatedSym( 2 downto 0 );	

	-- Rx I/F 
	Ctrl2RxTOEConn							<=	rFixCtrl2RxTOEConn;
	Ctrl2RxExpSeqNum(31	downto 0 )			<=  '0'&x"0"&rCtrl2RxExpSeqNum(26 downto 0 );
	Ctrl2RxSecValid( 4 downto 0 )			<= 	Tx2CtrlMrketVal( 4 downto 0 );	
	Ctrl2RxSecSymbol0(47 downto 0 )			<= 	Tx2CtrlMrketSymbol0(47 downto 0 );
	Ctrl2RxSecSymbol1(47 downto 0 )			<= 	Tx2CtrlMrketSymbol1(47 downto 0 );
	Ctrl2RxSecSymbol2(47 downto 0 )			<= 	Tx2CtrlMrketSymbol2(47 downto 0 );
	Ctrl2RxSecSymbol3(47 downto 0 )			<= 	Tx2CtrlMrketSymbol3(47 downto 0 );
	Ctrl2RxSecSymbol4(47 downto 0 )			<= 	Tx2CtrlMrketSymbol4(47 downto 0 );
	Ctrl2RxSecId0(15 downto 0 )				<= 	Tx2CtrlMrketSecurityID0(15 downto 0 );
	Ctrl2RxSecId1(15 downto 0 )				<= 	Tx2CtrlMrketSecurityID1(15 downto 0 );
	Ctrl2RxSecId2(15 downto 0 )				<= 	Tx2CtrlMrketSecurityID2(15 downto 0 );
	Ctrl2RxSecId3(15 downto 0 )				<= 	Tx2CtrlMrketSecurityID3(15 downto 0 );
	Ctrl2RxSecId4(15 downto 0 )				<= 	Tx2CtrlMrketSecurityID4(15 downto 0 );
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-----------------------------------------------------------
-- State Machine 
	
	u_rState : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rState	<= stIdle;
			else 	
				case ( rState ) Is 

					when stIdle		=>
						if ( rUserFixOperate='0' and UserFixConn='1' ) then 
							rState	<= stInit;
						else 
							rState	<= stIdle;
						end if;
							
					when stInit		=>
						-- TOE Established 
						if ( TOE2FixStatus(2)='1' ) then 
							rState	<= stWaitLogon;
						else
							rState	<= stInit;
						end if;
					
					when stWaitLogon=>
						-- Recv log on  
						if ( Rx2CtrlMsgTypeVal(6)='1' and Rx2CtrlSeqNumError='0'
							and Rx2CtrlResetSeqNumFlag='1' and Rx2CtrlEncryptMetError='0'
							and Rx2CtrlAppVerIdError='0' ) then 
							rState	<= stEstablish;
						-- Send logout 
						elsif ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" or rCtrlError(3)='1' ) then 
							rState	<= stSendLogOut;
						else
							rState	<= stWaitLogon;
						end if;
					
					when stEstablish=>
						-- Reset SeqNum 
						if ( UserFixDisConn='0' and rCtrlTtrBusy(3)='1' 
							and rCtrlTtrBusy(0)='1' and rCtrlTtrDetect(1)='0' ) then 
							rState	<= stInit;
						-- Recv Logout or Abnormal logout
						elsif ( (rRx2CtrlMsgTypeValFF(5)='1' and rRxCtrlMsgVal='1') 
							or rCtrlError(2 downto 0)/="000" ) then 
							rState	<= stSendLogOut;
						-- logout 
						elsif ( rCtrlLogoutEn(1)='1' ) then 
							rState	<= stTerminate; 
						else 
							rState	<= stEstablish;
						end if;
 	
					when stTerminate=>
							rState	<= stWaitLogout;
					
					when stSendLogOut=>
						if ( rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0111" ) then 
							rState	<= stWaitBusy; 
						else 
							rState	<= stSendLogOut; 
						end if;
					
					when stWaitBusy	=>
						if ( Tx2CtrlBusy='0' ) then 
							rState	<= stIdle; 
						else 
							rState	<= stWaitBusy; 
						end if; 
					
					when stWaitLogout=>
						if ( (rRx2CtrlMsgTypeValFF(5)='1' and rRxCtrlMsgVal='1')
							or rCtrlLogoutTimeoutCnt=1 ) then 
							rState	<= stIdle;
						else 
							rState	<= stWaitLogout;
						end if;
						
				end case;
			end if;
		end if;
	End Process u_rState;

-----------------------------------------------------------
-- Rx Input 

	u_rRxInputFF : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRx2CtrlMsgTypeValFF( 7 downto 0 )	<= (others=>'0');
			else 
				rRx2CtrlMsgTypeValFF( 7 downto 0 )	<= Rx2CtrlMsgTypeVal;
			end if;
			rRx2CtrlPossDupFlagFF(1 downto 0)	<= rRx2CtrlPossDupFlagFF(0)&Rx2CtrlPossDupFlag;
		end if;
	End Process u_rRxInputFF;
	
	u_rRxCtrlMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 	
				rRxCtrlMsgVal <= '0';
			else 
				if ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and Rx2CtrlSeqNumError='0' ) then 
					rRxCtrlMsgVal	<= '1';
				else 
					rRxCtrlMsgVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxCtrlMsgVal;
	
	-- Detect jumeped seqnum 
	-- Bit 0: Detect out of order message 
	-- Bit 1: Jumped SeqNum
	-- Bit 2: Duplicate message 
	u_rRxCtrlOutOfOrder : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxCtrlOutOfOrder( 2 downto 0 )	<= (others=>'0'); 
			else 
				if ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and Rx2CtrlSeqNumError='1' ) then 
					rRxCtrlOutOfOrder(0)	<= '1';
				else 
					rRxCtrlOutOfOrder(0)	<= '0';
				end if;
				
				-- Jumped message: Transmitting ResendReq 
				if ( rRxCtrlRecvSeqNumCal(26)='1' and rRxCtrlOutOfOrder(0)='1'
					-- not SeqReset message and GapFillFlag='N'
					and (rRx2CtrlGapFillFlagFF='1' or rRx2CtrlMsgTypeValFF(4)='0') ) then 
					rRxCtrlOutOfOrder(1)	<= '1';
				else 
					rRxCtrlOutOfOrder(1)	<= '0'; 
				end if;	
				
				-- Duplicate message 
				if ( rRxCtrlRecvSeqNumCal(26)='0' and rRxCtrlOutOfOrder(0)='1' ) then 
					rRxCtrlOutOfOrder(2)	<= '1';
				else 
					rRxCtrlOutOfOrder(2)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxCtrlOutOfOrder;
	
	u_rRxCtrlRecvSeqNumCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRxCtrlRecvSeqNumCal(26 downto 0 )	<= rCtrl2RxExpSeqNum(26 downto 0) - Rx2CtrlSeqNum(26 downto 0 );
		end if;
	End Process u_rRxCtrlRecvSeqNumCal;

-----------------------------------------------------------
-- RxFix Interface 
	
	u_rCtrl2RxFFsignal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rCtrl2RxNewSeqNumFF(26 downto 0 )	<= Rx2CtrlNewSeqNum(26 downto 0 );
		end if; 
	End Process u_rCtrl2RxFFsignal;
	
	u_rCtrl2RxExpSeqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRx2CtrlGapFillFlagFF	<= Rx2CtrlGapFillFlag;
			if ( Rx2CtrlMsgTypeVal(6)='1' and Rx2CtrlSeqNumError='0'
				and Rx2CtrlResetSeqNumFlag='1' ) then 
				rCtrl2RxExpSeqNum(26 downto 0 )	<= cInitSeqNum_1; 
			-- SeqReset : SeqNum valid or GapfillFlag is not set 
			elsif ( (rRxCtrlMsgVal='1' or rRx2CtrlGapFillFlagFF='0') 
				and rRx2CtrlMsgTypeValFF(4)='1' ) then 
				rCtrl2RxExpSeqNum(26 downto 0 )	<= rCtrl2RxNewSeqNumFF(26 downto 0 );
			-- Incremeental every messages 
			elsif ( rRxCtrlMsgVal='1' ) then 
				rCtrl2RxExpSeqNum(26 downto 0 )	<= rCtrl2RxExpSeqNum(26 downto 0 ) + 1;
			else 
				rCtrl2RxExpSeqNum(26 downto 0 )	<= rCtrl2RxExpSeqNum(26 downto 0 );
			end if;
		end if;
	End Process u_rCtrl2RxExpSeqNum;
	
	u_rCtrl2RxTOEConn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixCtrl2RxTOEConn	<= '0';
			else
				if ( rState/=stIdle and TOE2FixStatus(2)='1' ) then 
					rFixCtrl2RxTOEConn	<= '1';
				else 
					rFixCtrl2RxTOEConn	<= '0';
				end if; 
			end if;
		end if; 
	End Process u_rCtrl2RxTOEConn;
	
-----------------------------------------------------------
-- User Interface 
	
	u_rUserFixOperate : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rUserFixOperate	<= '0';
			else 
				if ( rState=stIdle ) then 
					rUserFixOperate	<= '0';
				else 
					rUserFixOperate	<= '1';
				end if; 
			end if; 
		end if;
	End Process u_rUserFixOperate;

-----------------------------------------------------------
-- TOE Interface 
	
	u_rFix2TOEConnectReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOEConnectReq	<= '0';
			else 
				-- In Connecting state 
				if ( TOE2FixStatus(1)='1' ) then 
					rFix2TOEConnectReq	<= '0';
				elsif ( rState=stInit and TOE2FixStatus(0)='1' ) then 
					rFix2TOEConnectReq	<= '1';
				else 
					rFix2TOEConnectReq	<= rFix2TOEConnectReq;
				end if;
			end if;
		end if;
	End Process u_rFix2TOEConnectReq; 
	
	u_rFix2TOETerminateReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOETerminateReq	<= '0';
			else 
				-- Not in Established state 
				if ( TOE2FixStatus(2)='0' ) then 
					rFix2TOETerminateReq	<= '0';
				elsif ( rState=stIdle and rUserFixOperate='1' ) then 
					rFix2TOETerminateReq	<= '1';
				else 
					rFix2TOETerminateReq	<= rFix2TOETerminateReq;
				end if; 
			end if;
		end if;
	End Process u_rFix2TOETerminateReq;
	
	u_rFix2TOERxDataReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOERxDataReq	<= '0';
			else
				if ( rState/=stIdle and TOE2FixStatus(2)='1' ) then 
					rFix2TOERxDataReq	<= '1';
				else 
					rFix2TOERxDataReq	<= '0';
				end if; 
			end if;
		end if; 
	End Process u_rFix2TOERxDataReq;

-----------------------------------------------------------
-- ResendReq Process 

	u_rCtrlRsrValid : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsrValid( 1 downto 0 )	<= (others=>'0');
			else 
				-- Transmitting ResendReq 
				if ( rCtrl2TxReqMsg(5)='1' or rState=stIdle ) then 
					rCtrlRsrValid(0)	<= '0';
				elsif ( rCtrlRsrValid(1)='0' and rRxCtrlOutOfOrder(1)='1' ) then 
					rCtrlRsrValid(0)	<= '1';
				else 
					rCtrlRsrValid(0)	<= rCtrlRsrValid(0);
				end if;
				
				-- Wait for receiving expected message to reset 
				if ( rRxCtrlMsgVal='1' ) then 
					rCtrlRsrValid(1)	<= '0';
				elsif ( rCtrlRsrValid(0)='1' ) then 
					rCtrlRsrValid(1)	<= '1';
				else 
					rCtrlRsrValid(1)	<= rCtrlRsrValid(1);
				end if;
			end if;
		end if;
	End Process u_rCtrlRsrValid;

-----------------------------------------------------------
-- Heartbeat Process 

	u_rCtrlHbTxCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Synthesis 
			if ( rCtrlHbTxCntRst='1' ) then 
				--rCtrlHbTxCnt(31 downto 0 )	<= cHbInterval_Bin; -- Synthesis 
				rCtrlHbTxCnt(31 downto 0 )	<= x"0000_05DC"; -- Simulation >>  1500 clk
			else 
				rCtrlHbTxCnt(31 downto 0 )	<= rCtrlHbTxCnt(31 downto 0 )	- 1;
			end if; 
		end if; 
	End Process u_rCtrlHbTxCnt;
	
	u_rCtrlHbTxCntRst : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlHbTxCntRst	<= '0';
			else 
				if ( rState=stWaitLogon or rCtrl2TxReqMsg(7 downto 0)/=x"00" 
					or (rCtrlHbTxCnt=2 and rState=stEstablish) ) then 
					rCtrlHbTxCntRst	<= '1';
				else 
					rCtrlHbTxCntRst	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rCtrlHbTxCntRst;
	
	-- Heartbeat Rx process 
	u_rCtrlHbRxCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Synthesis 
			if ( rCtrlHbRxCntRst='0' and rState=stEstablish ) then 
				rCtrlHbRxCnt(32 downto 0 )	<= rCtrlHbRxCnt(32 downto 0 ) - 1; -- 36 sec: 1.2*Hb interval
			else 
				--rCtrlHbRxCnt(32 downto 0 )	<= cHbInterval_Bin36; -- Synthesis 
				rCtrlHbRxCnt(32 downto 0 )	<= '0'&x"0000_0708"; -- Simulation >>  1800 clk
			end if; 
		end if; 
	End Process u_rCtrlHbRxCnt;
	
	u_rCtrlHbRxCntRst : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlHbRxCntRst	<= '0';
			else 
				if ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" or (rState=stEstablish 
					and rCtrlHbRxCnt=2) ) then 
					rCtrlHbRxCntRst	<= '1';
				else 
					rCtrlHbRxCntRst	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rCtrlHbRxCntRst;

-----------------------------------------------------------
-- MrkdataReq Process 

	u_rCtrlMrkDataEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlMrkDataEn	<= '0';
			else 
				if ( rCtrl2TxReqMsg(3)='1' ) then 
					rCtrlMrkDataEn	<= '0';
				elsif ( rState=stIdle ) then 
					rCtrlMrkDataEn	<= '1';
				else 
					rCtrlMrkDataEn	<= rCtrlMrkDataEn;
				end if;
			end if;
		end if;
	End Process u_rCtrlMrkDataEn;

-----------------------------------------------------------
-- TestReq Process 	
	
	u_rCtrlTtrDetect : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlTtrDetect( 1 downto 0 )	<= (others=>'0');
			else 
				rRx2CtrlSeqNumFF( 2 downto 0 )	<= Rx2CtrlSeqNum(26 downto 24);
				-- Detect SeqNum reach 92,274,688 either TxSeqNum or RxSeqNum 
				if ( rState=stEstablish and ((rRx2CtrlSeqNumFF(2 downto 0)="101" and rRxCtrlMsgVal='1')
					or rCtrl2TxSeqNum(26 downto 24)="101") ) then 
					rCtrlTtrDetect(0)	<= '1';
				else 
					rCtrlTtrDetect(0)	<= '0';
				end if; 
				
				if ( rCtrlTtrDetect(0)='1' ) then 
					rCtrlTtrDetect(1)	<= '0';
				elsif ( rState=stInit ) then 
					rCtrlTtrDetect(1)	<= '1';
				else 
					rCtrlTtrDetect(1)	<= rCtrlTtrDetect(1); 
				end if; 
			end if;
		end if;
	End Process u_rCtrlTtrDetect;
	
	u_rCtrlTtrBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlTtrBusy( 3 downto 0 )	<= (others=>'0');
			else 
				-- Bit 0: Busy signal of TestReq process 
				if ( rCtrlTtrBusy(3)='1' or rState=stIdle ) then 
					rCtrlTtrBusy(0)	<= '0';
				elsif ( (rCtrlTtrDetect(1 downto 0)="11" or UserFixDisConn='1'
					or rCtrlHbRxCnt=1) and rState=stEstablish and rCtrlLogoutEn(0)='0' ) then 
					rCtrlTtrBusy(0)	<= '1';
				else 
					rCtrlTtrBusy(0)	<= rCtrlTtrBusy(0);
				end if; 
				
				rCtrlTtrBusy(2)	<= rCtrlTtrBusy(1);	
				-- Bit 1 and 2 : Using as Transmitting of TestReq message 
				if ( rCtrlTtrBusy(3)='1' or rCtrlRsqEn(0)='1' or rState=stIdle ) then 
					rCtrlTtrBusy(1)	<= '0';
				elsif ( rCtrlTtrBusy(0)='1' ) then 
					rCtrlTtrBusy(1)	<= '1';
				else 
					rCtrlTtrBusy(1)	<= rCtrlTtrBusy(1);
				end if;
				
				-- Bit 3: Detect Heartbeat receiving 
				if ( rCtrlTtrBusy(0)='1' and Rx2CtrlMsgTypeVal(0)='1' and Rx2CtrlSeqNumError='0' 
					and Rx2CtrlTestReqIdVal='1' and Rx2CtrlTestReqId(63 downto 0)=cTestReq_String ) then 
					rCtrlTtrBusy(3)	<= '1';
				else 
					rCtrlTtrBusy(3)	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rCtrlTtrBusy;
	
-----------------------------------------------------------
-- Rejection message Rx Process 

	u_rCtrlRjtRxReason : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- checksum or bodylength error 
			if ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and (Rx2CtrlCsumError='1' 
				or Rx2CtrlBodyLenError='1') ) then 
				rCtrlRjtRxReason( 1 downto 0 )	<= "11";
			-- Invalid value: EncryptMetError
			elsif ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and Rx2CtrlEncryptMetError='1' ) then 
				rCtrlRjtRxReason( 1 downto 0 )	<= "10";
			-- Invalid value: AppVerIdError
			elsif ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and Rx2CtrlAppVerIdError='1' ) then 
				rCtrlRjtRxReason( 1 downto 0 )	<= "01";
			-- Unknown Tag 
			elsif ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" ) then 
				rCtrlRjtRxReason( 1 downto 0 )	<= "00";
			else 
				rCtrlRjtRxReason( 1 downto 0 )	<= rCtrlRjtRxReason( 1 downto 0 );
			end if; 
		end if;
	End Process u_rCtrlRjtRxReason;
	
	u_rCtrlRjtRxMsgType : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rRx2CtrlMsgTypeValFF(0)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_0; -- Heartbeat => '0'
			elsif ( rRx2CtrlMsgTypeValFF(1)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_1; -- TestReq => '1'
			elsif ( rRx2CtrlMsgTypeValFF(2)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_2; -- ResendReq => '2'
			elsif ( rRx2CtrlMsgTypeValFF(3)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_3; -- Reject => '3'
			elsif ( rRx2CtrlMsgTypeValFF(4)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_4; -- SeqReset => '4'
			elsif ( rRx2CtrlMsgTypeValFF(5)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_5; -- Log out => '5'
			elsif ( rRx2CtrlMsgTypeValFF(6)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_A; -- Logon => 'A'
			elsif ( rRx2CtrlMsgTypeValFF(7)='1' ) then 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= cAscii_W; -- MrkDataSnapShotFullRef => 'W'
			else 
				rCtrlRjtRxMsgType( 7 downto 0 )	<= rCtrlRjtRxMsgType( 7 downto 0 );
			end if; 
		end if;
	End Process u_rCtrlRjtRxMsgType;
	
	u_rCtrlRjtRxRefSeqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rCtrlRjtRxValid(0)='1' ) then 
				rCtrlRjtRxRefSeqNum(26 downto 0 )	<= rCtrl2RxExpSeqNum(26 downto 0 );
			else 
				rCtrlRjtRxRefSeqNum(26 downto 0 )	<= rCtrlRjtRxRefSeqNum(26 downto 0 );
			end if; 
		end if;
	End Process u_rCtrlRjtRxRefSeqNum;
	
	-- Bit 0: Rejecting message 
	-- Bit 1: Byte shifting of TagID if there exist 
	-- Bit 2: Valid Data  
	u_rCtrlRjtRxValid : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRjtRxValid( 3 downto 0 )	<= (others=>'0');
			else 
				if ( Rx2CtrlMsgTypeVal(7 downto 0)/=x"00" and (Rx2CtrlEncryptMetError='1'
				or Rx2CtrlAppVerIdError='1' or Rx2CtrlBodyLenError='1' 
				or Rx2CtrlCsumError='1' or Rx2CtrlTagErrorFlag='1') ) then 
					rCtrlRjtRxValid(0)	<= '1';
				else 
					rCtrlRjtRxValid(0)	<= '0';
				end if; 
			
				if ( rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)="00" ) then 
					rCtrlRjtRxValid(1)	<= '1';
				elsif ( rCtrlRjtRxRefTagIDCnt=1 ) then 
					rCtrlRjtRxValid(1)	<= '0';
				else 
					rCtrlRjtRxValid(1)	<= rCtrlRjtRxValid(1); 
				end if; 
				
				if ( ((rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)/="00")
					or (rCtrlRjtRxValid(1)='1' and rCtrlRjtRxRefTagIDCnt=1)) and rFifoQueueFull='0' ) then 
					rCtrlRjtRxValid(2)	<= '1';
				else 
					rCtrlRjtRxValid(2)	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rCtrlRjtRxValid;
	
	u_rCtrlRjtRxRefTagID : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRx2CtrlErrorTagLatchFF(31 downto 0)	<= Rx2CtrlErrorTagLatch(31 downto 0);
			-- EncryptMetError 
			if ( rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)="10" ) then 
				rCtrlRjtRxRefTagID(31 downto 0 )	<= cAscii_9&cAscii_8&cAscii_0&cAscii_0; -- 98
			-- AppVerIdError
			elsif ( rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)="01" ) then 
				rCtrlRjtRxRefTagID(31 downto 0 )	<= cAscii_1&cAscii_1&cAscii_3&cAscii_7; -- 1137
			-- Unknown Tag 
			elsif ( rCtrlRjtRxValid(0)='1' ) then 
				rCtrlRjtRxRefTagID(31 downto 0 )	<= rRx2CtrlErrorTagLatchFF(31 downto 0);
			-- Byte shifting if unknown 
			elsif ( rCtrlRjtRxValid(1)='1' ) then 
				rCtrlRjtRxRefTagID(31 downto 0 )	<= rCtrlRjtRxRefTagID(7 downto 0)&rCtrlRjtRxRefTagID(31 downto 8);
			else 
				rCtrlRjtRxRefTagID(31 downto 0 )	<= rCtrlRjtRxRefTagID(31 downto 0 ); 
			end if;
		end if;
	End Process u_rCtrlRjtRxRefTagID;
	
	u_rCtrlRjtRxRefTagIDLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRx2CtrlErrorTagLenFF( 2 downto 0 )	<= Rx2CtrlErrorTagLen( 2 downto 0 );
			-- EncryptMetError 
			if ( rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)="10" ) then 
				rCtrlRjtRxRefTagIDLen( 2 downto 0 )	<= "010"; -- length = 2
			-- AppVerIdError
			elsif ( rCtrlRjtRxValid(0)='1' and rCtrlRjtRxReason(1 downto 0)="01" ) then 
				rCtrlRjtRxRefTagIDLen( 2 downto 0 )	<= "100"; -- length = 4
			-- Unknown Tag 
			elsif ( rCtrlRjtRxValid(0)='1' ) then 
				rCtrlRjtRxRefTagIDLen( 2 downto 0 )	<= rRx2CtrlErrorTagLenFF( 2 downto 0 );
			else 
				rCtrlRjtRxRefTagIDLen( 2 downto 0 )	<= rCtrlRjtRxRefTagIDLen( 2 downto 0 );
			end if; 
			
			-- Byte shifting counter 
			if ( rCtrlRjtRxValid(0)='1' ) then 
				rCtrlRjtRxRefTagIDCnt( 2 downto 0 )	<= rRx2CtrlErrorTagLenFF( 2 downto 0 );
			else 
				rCtrlRjtRxRefTagIDCnt( 2 downto 0 )	<= rCtrlRjtRxRefTagIDCnt( 2 downto 0 ) - 1;
			end if; 
		end if; 
	End Process u_rCtrlRjtRxRefTagIDLen;

-----------------------------------------------------------
-- Rejection message Tx Process 

	-- Data width ordering 
	-- 71 downto 70: Reason 
	-- 69 downto 43: RefSeqNum
	-- 42 downto 35: RefMsgType
	-- 34 downto 3 : RefTagID
	-- 2  downto 0 : RefTagID Length 
	u_QueueReject : Fifo72x8
	Port map 
	(
		clock		=> Clk					,
		data		=> rFifoQueueWrData     ,
		rdreq		=> rFifoQueueRdReq(0)	,
		sclr		=> rFifoQueueReset		,
		wrreq		=> rCtrlRjtRxValid(2) 	,
		empty		=> rFifoQueueEmpty      ,
		full		=> rFifoQueueFull       ,
		q			=> rFifoQueueRdData     ,
		usedw		=> open 
	);
	
	rFifoQueueWrData(71 downto 0 ) 	<= rCtrlRjtRxReason&rCtrlRjtRxRefSeqNum&rCtrlRjtRxMsgType&rCtrlRjtRxRefTagID&rCtrlRjtRxRefTagIDLen;
	
	u_rFifoQueueReset : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFifoQueueReset	<= '0';
			else 
				if ( rState/=stEstablish ) then 
					rFifoQueueReset	<= '1';
				else 
					rFifoQueueReset	<= '0';
				end if;
			end if;
		end if;
	End Process u_rFifoQueueReset;
	
	u_rFifoQueueRdReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFifoQueueRdReq( 1 downto 0 )	<= (others=>'0');
			else 
				rFifoQueueRdReq(1)	<= rFifoQueueRdReq(0);
				-- Read Data from Queue whenever not empty and not busy and not Resend req process 
				if ( rFifoQueueRdReq(0)='0' and rCtrlRjtTxBusy(0)='0' 
					and rFifoQueueEmpty='0' and rCtrlRsqBusy(0)='0' ) then 
					rFifoQueueRdReq(0)	<= '1';
				else 
					rFifoQueueRdReq(0)	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rFifoQueueRdReq;
	
	-- Bit 0: Busy signal 
	-- Bit 1: Detect Transmitting start  
	u_rCtrlRjtTxBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRjtTxBusy( 2 downto 0 )	<= (others=>'0');
			else 	
				rCtrlRjtTxBusy(1)	<= rCtrlRjtTxBusy(0); 
				-- Ready to send new one 
				if ( (Tx2CtrlBusy='0' and rCtrlRjtTxBusy(1)='1') or rState=stIdle ) then 
					rCtrlRjtTxBusy(0)	<= '0';
				-- Normal reject or retransmitting reject 
				elsif ( rFifoQueueRdReq(0)='1' or rCtrlRsqRejectEn(3 downto 2)="01" ) then 
					rCtrlRjtTxBusy(0)	<= '1';
				else 
					rCtrlRjtTxBusy(0)	<= rCtrlRjtTxBusy(0); 
				end if;
				
				-- Transmitting end 
				if ( Tx2CtrlBusy='0' or rState=stIdle ) then 
					rCtrlRjtTxBusy(2)	<= '0';
				-- Transmitting Reject message 
				elsif ( rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0110" ) then 
					rCtrlRjtTxBusy(2)	<= '1';
				else 
					rCtrlRjtTxBusy(2)	<= rCtrlRjtTxBusy(2); 
				end if;
			end if;
		end if;
	End Process u_rCtrlRjtTxBusy; 
	
	-- Data from memory 
	u_rCtrlRjtTxData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Read from FIFO 
			if ( rFifoQueueRdReq(1)='1' ) then 
				rCtrlRjtTxReason( 1 downto 0 )		<= rFifoQueueRdData(71 downto 70);
				rCtrlRjtTxRefSeqNum(26 downto 0 )	<= rFifoQueueRdData(69 downto 43);
				rCtrlRjtTxRefMsgType( 7 downto 0 )	<= rFifoQueueRdData(42 downto 35);
				rCtrlRjtTxRefTagID(31 downto 0 )	<= rFifoQueueRdData(34 downto 3 );
				rCtrlRjtTxRefTagIDLen( 2 downto 0 )	<= rFifoQueueRdData( 2 downto 0 );
			-- Read from resend ram 
			elsif ( rCtrlRsqRejectEn(3 downto 2)="01" ) then 
				rCtrlRjtTxReason( 1 downto 0 )		<= rRetranRamRdData(71 downto 70);
				rCtrlRjtTxRefSeqNum(26 downto 0 )	<= rRetranRamRdData(69 downto 43);
				rCtrlRjtTxRefMsgType( 7 downto 0 )	<= rRetranRamRdData(42 downto 35);
				rCtrlRjtTxRefTagID(31 downto 0 )	<= rRetranRamRdData(34 downto 3 );
				rCtrlRjtTxRefTagIDLen( 2 downto 0 )	<= rRetranRamRdData( 2 downto 0 );
			else 
				rCtrlRjtTxReason( 1 downto 0 )		<= rCtrlRjtTxReason( 1 downto 0 );		
				rCtrlRjtTxRefSeqNum(26 downto 0 )	<= rCtrlRjtTxRefSeqNum(26 downto 0 );	
				rCtrlRjtTxRefMsgType( 7 downto 0 )	<= rCtrlRjtTxRefMsgType( 7 downto 0 );	
				rCtrlRjtTxRefTagID(31 downto 0 )	<= rCtrlRjtTxRefTagID(31 downto 0 );	
				rCtrlRjtTxRefTagIDLen( 2 downto 0 )	<= rCtrlRjtTxRefTagIDLen( 2 downto 0 );	
			end if; 
		
			-- No TagID generate when Reason 99 
			if ( rCtrlRjtTxValid='1' and rCtrlRjtTxReason(1 downto 0)="11" ) then 
				rCtrlRjtTxRefTagIDEn	<= '0'; -- No TagID Enable 
			elsif ( rCtrlRjtTxValid='1' ) then 
				rCtrlRjtTxRefTagIDEn	<= '1'; -- TagID Enable 
			else 
				rCtrlRjtTxRefTagIDEn	<= rCtrlRjtTxRefTagIDEn;
			end if; 
			
			-- Generate Session reject reason and its length
			if ( rCtrlRjtTxValid='1' and rCtrlRjtTxReason(1 downto 0)="11" ) then 
				rCtrlRjtTxSessReason(15 downto 0 )		<= cAscii_9&cAscii_9; -- Reason 99: checksum error or bodylength error
				rCtrlRjtTxSessReasonLen( 1 downto 0 )	<= "10"; -- Fixed length= 2
			elsif ( rCtrlRjtTxValid='1' and rCtrlRjtTxReason(1 downto 0)="00" ) then 
				rCtrlRjtTxSessReason(15 downto 0 )		<= cAscii_0&cAscii_0; -- Reason 0: Unknown Tag
				rCtrlRjtTxSessReasonLen( 1 downto 0 )	<= "01"; -- Fixed length= 1
			elsif ( rCtrlRjtTxValid='1') then 
				rCtrlRjtTxSessReason(15 downto 0 )		<= cAscii_5&cAscii_0; -- Reason 5: Invalid value
				rCtrlRjtTxSessReasonLen( 1 downto 0 )	<= "01"; -- Fixed length= 1
			else 
				rCtrlRjtTxSessReason(15 downto 0 )		<= rCtrlRjtTxSessReason(15 downto 0 );		
				rCtrlRjtTxSessReasonLen( 1 downto 0 )	<= rCtrlRjtTxSessReasonLen( 1 downto 0 );	
			end if; 
		end if; 
	End Process u_rCtrlRjtTxData;
	
	u_rCtrlRjtTxValid : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRjtTxValid	<= '0';
			else 
				if ( rCtrlRjtTxBusy(1 downto 0)="01" ) then 
					rCtrlRjtTxValid	<= '1';
				else 
					rCtrlRjtTxValid	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlRjtTxValid; 
	
-----------------------------------------------------------
-- TestReq Reply process 

	-- Bit 0: Using as Byte shifting
	-- Bit 1: Using as Validation 
	u_rCtrlTrrValid : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlTrrValid( 1 downto 0 )	<= (others=>'0'); 
			else 
				if ( rState=stEstablish and rRx2CtrlMsgTypeValFF(1)='1' ) then 
					rCtrlTrrValid(0)	<= '1';
				elsif ( rCtrlTrrTextCnt=1 ) then 
					rCtrlTrrValid(0)	<= '0';
				else 
					rCtrlTrrValid(0)	<= rCtrlTrrValid(0); 
				end if; 
				
				if ( rCtrlTrrValid(0)='1' and rCtrlTrrTextCnt=1 ) then 
					rCtrlTrrValid(1)	<= '1';
				else 
					rCtrlTrrValid(1)	<= '0';
				end if; 
			end if; 
		end if; 
	End Process u_rCtrlTrrValid;
	
	u_rCtrlTrrText : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Latch Data from TestReq Text 
			if ( rState=stEstablish and Rx2CtrlMsgTypeVal(1)='1' ) then 
				rCtrlTrrText(63 downto 0 )	<= Rx2CtrlTestReqId(63 downto 0 );
			-- Byte shifting
			elsif ( rCtrlTrrValid(0)='1' ) then 
				rCtrlTrrText(63 downto 0 )	<= rCtrlTrrText(7 downto 0)&rCtrlTrrText(63 downto 8);
			else 
				rCtrlTrrText(63 downto 0 )	<= rCtrlTrrText(63 downto 0 );
			end if;	
		end if;
	End Process u_rCtrlTrrText;

	u_rCtrlTrrTextCntLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rState=stEstablish and rRx2CtrlMsgTypeValFF(1)='1' ) then 
				rCtrlTrrTextCnt( 3 downto 0 )	<= rCtrlTrrTextLen( 3 downto 0 ); 
			else 
				rCtrlTrrTextCnt( 3 downto 0 )	<= rCtrlTrrTextCnt( 3 downto 0 ) - 1;
			end if; 
			
			if ( rState=stEstablish and Rx2CtrlMsgTypeVal(1)='1' ) then 
				rCtrlTrrTextLen( 3 downto 0 )	<= Rx2CtrlTestReqIdLen( 3 downto 0 );
			else 
				rCtrlTrrTextLen( 3 downto 0 )	<= rCtrlTrrTextLen( 3 downto 0 );
			end if;
		end if; 
	End Process u_rCtrlTrrTextCntLen;

-----------------------------------------------------------
-- Logout Timeout process  
	
	u_rCtrlLogoutEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlLogoutEn( 1 downto 0 )	<= (others=>'0');				
			else 
				if ( rCtrlLogoutEn(1)='1' ) then 
					rCtrlLogoutEn(0)	<= '0';
				elsif ( UserFixDisConn='1' and rCtrlTtrBusy(3)='1' and rCtrlTtrBusy(0)='1' ) then 
					rCtrlLogoutEn(0)	<= '1';
				else 
					rCtrlLogoutEn(0)	<= rCtrlLogoutEn(0);
				end if;
				
				if ( rCtrlLogoutEn(0)='1' and rCtrl2TxReqMsg(10 downto 0)=("000"&x"00") ) then 
					rCtrlLogoutEn(1)	<= '1';
				else 
					rCtrlLogoutEn(1)	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rCtrlLogoutEn;
	
	u_rCtrlLogoutTimeoutCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rState=stWaitLogout or rCtrlTtrBusy(1)='1' ) then 
				rCtrlLogoutTimeoutCnt(32 downto 0 )	<= rCtrlLogoutTimeoutCnt(32 downto 0 ) - 1;
			else 
				--rCtrlLogoutTimeoutCnt(32 downto 0 )	<= cHbInterval_Bin36; -- Synthesis >> 1.2* Heartbeat interval 
				rCtrlLogoutTimeoutCnt(32 downto 0 )	<=  '0'&x"0000_0708"; -- Simulation >>  1800 clk
			end if; 
		end if;
	End Process u_rCtrlLogoutTimeoutCnt;

-----------------------------------------------------------
-- Wait Logon timer 

	u_rCtrlLogonTimeoutCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rState=stWaitLogon ) then 
				rCtrlLogonTimeoutCnt(32 downto 0 )	<= rCtrlLogonTimeoutCnt(32 downto 0 ) - 1;
			else 
				--rCtrlLogonTimeoutCnt(32 downto 0 )	<= cHbInterval_Bin36; -- Synthesis >> 1.2* Heartbeat interval 
				rCtrlLogonTimeoutCnt(32 downto 0 )	<=  '0'&x"0000_0708"; -- Simulation >>  1800 clk
			end if; 
		end if;
	End Process u_rCtrlLogonTimeoutCnt;

-----------------------------------------------------------
-- TxFix Interface
	
	u_rCtrl2TxReqMsg : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrl2TxReqMsg(10 downto 0 )	<= (others=>'0');
			else 
				-- Logon message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0001") or rState=stIdle ) then 
					rCtrl2TxReqMsg(0)	<= '0';
					-- Firstly send logon 
				elsif ( rState=stInit and TOE2FixStatus(2)='1' ) then 
					rCtrl2TxReqMsg(0)	<= '1';
				else 
					rCtrl2TxReqMsg(0)	<= rCtrl2TxReqMsg(0);
				end if;
				
				-- Logout message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0111") or rState=stIdle ) then 
					rCtrl2TxReqMsg(1)	<= '0';
				elsif ( rState=stTerminate or rState=stSendLogOut ) then 
					rCtrl2TxReqMsg(1)	<= '1';
				else 
					rCtrl2TxReqMsg(1)	<= rCtrl2TxReqMsg(1);
				end if;
				
				-- Reject message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0110") or rState=stIdle ) then 
					rCtrl2TxReqMsg(2)	<= '0';
				elsif ( rCtrlRjtTxValid='1' ) then 
					rCtrl2TxReqMsg(2)	<= '1';
				else 
					rCtrl2TxReqMsg(2)	<= rCtrl2TxReqMsg(2);
				end if;
				
				-- MrkdataReq message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0011") or rState=stIdle ) then 
					rCtrl2TxReqMsg(3)	<= '0';
				elsif ( (rState=stEstablish and rCtrlMrkDataEn='1' and rCtrlRsqBusy(0)='0')
					or rCtrlRsqMrkDatEn(3 downto 2)="01" ) then 
					rCtrl2TxReqMsg(3)	<= '1';
				else 
					rCtrl2TxReqMsg(3)	<= rCtrl2TxReqMsg(3);
				end if;
			
				-- SeqReset message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0101") or rState=stIdle ) then 
					rCtrl2TxReqMsg(4)	<= '0';
				elsif ( rCtrlRsqRstSeqEn(4 downto 3)="01" ) then 
					rCtrl2TxReqMsg(4)	<= '1';
				else 
					rCtrl2TxReqMsg(4)	<= rCtrl2TxReqMsg(4);
				end if;
				
				-- ResendReq message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0100") or rState=stIdle ) then 
					rCtrl2TxReqMsg(5)	<= '0';
				elsif ( rCtrlRsrValid(0)='1' and rCtrlRsqBusy(0)='0' ) then 
					rCtrl2TxReqMsg(5)	<= '1';
				else 
					rCtrl2TxReqMsg(5)	<= rCtrl2TxReqMsg(5);
				end if;
				
				-- TestReq message request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0000") or rState=stIdle ) then 
					rCtrl2TxReqMsg(6)	<= '0';
				elsif ( rCtrlTtrBusy(2 downto 1)="01" and rCtrlRsqBusy(0)='0' ) then 
					rCtrl2TxReqMsg(6)	<= '1';
				else 
					rCtrl2TxReqMsg(6)	<= rCtrl2TxReqMsg(6);
				end if;
				
				-- Heartbeat message which is TestReq reply request to send 
				if ( (rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0010") or rState=stIdle ) then 
					rCtrl2TxReqMsg(7)	<= '0';
				elsif ( rCtrlTrrValid(1)='1' and rCtrlRsqBusy(0)='0' ) then 
					rCtrl2TxReqMsg(7)	<= '1';
				else 
					rCtrl2TxReqMsg(7)	<= rCtrl2TxReqMsg(7);
				end if;
				
				-- Heartbeat message request to send 
				-- Any message has been transferred  
				if ( rCtrl2TxTranEn='1' or rState=stIdle ) then 
					rCtrl2TxReqMsg(8)	<= '0';
				elsif ( rCtrlHbTxCnt=1 and rState=stEstablish and rCtrlRsqBusy(0)='0' ) then 
					rCtrl2TxReqMsg(8)	<= '1';
				else 
					rCtrl2TxReqMsg(8)	<= rCtrl2TxReqMsg(8);
				end if;
				
				-- Set market data valid 
				if ( rCtrl2TxTranEn='1' or rState=stIdle ) then 
					rCtrl2TxReqMsg(9)	<= '0';
				elsif ( rUserFixOperate='0' and rState=stInit ) then 
					rCtrl2TxReqMsg(9)	<= '1';
				else 
					rCtrl2TxReqMsg(9)	<= rCtrl2TxReqMsg(9);
				end if;
				
				-- Reset market data valid   
				if ( rCtrl2TxTranEn='1' or rState=stIdle ) then 
					rCtrl2TxReqMsg(10)	<= '0';
				elsif ( rUserFixOperate='1' and rState=stIdle ) then 
					rCtrl2TxReqMsg(10)	<= '1';
				else 
					rCtrl2TxReqMsg(10)	<= rCtrl2TxReqMsg(10);
				end if;
			end if;
		end if;
	End Process u_rCtrl2TxReqMsg;
	
	-- Request to send (Tx control)
	u_rCtrl2TxReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrl2TxReq	<= '0';
			else 
				if ( Tx2CtrlBusy='1' ) then 
					rCtrl2TxReq	<= '0';
				elsif ( Tx2CtrlBusy='0' and rCtrl2TxReqMsg(10 downto 0)/="000"&x"00" ) then 
					rCtrl2TxReq	<= '1';
				else 
					rCtrl2TxReq	<= rCtrl2TxReq;
				end if;
			end if; 
		end if;
	End Process u_rCtrl2TxReq; 
	
	-- message type transferring Indicator
	u_rCtrl2TxMsgType : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Logon 
			if ( rCtrl2TxReqMsg(0)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0001";
			-- Logout 
			elsif ( rCtrl2TxReqMsg(1)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0111";
			-- reject 
			elsif ( rCtrl2TxReqMsg(2)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0110";
			-- MrkdataReq
			elsif ( rCtrl2TxReqMsg(3)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0011";
			-- SeqReset
			elsif ( rCtrl2TxReqMsg(4)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0101";
			-- ResendReq
			elsif ( rCtrl2TxReqMsg(5)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0100";
			-- TestReq
			elsif ( rCtrl2TxReqMsg(6)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0000";
			-- Heartbeat
			elsif ( rCtrl2TxReqMsg(8 downto 7)/="00" and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "0010";
			-- Generate validation 
			elsif ( rCtrl2TxReqMsg(9)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "1000";
			-- Reset Validation  
			elsif ( rCtrl2TxReqMsg(10)='1' and rCtrl2TxReq='0' ) then 
				rCtrl2TxMsgType( 3 downto 0 )	<= "1111";
			else 
				rCtrl2TxMsgType( 3 downto 0 )	<= rCtrl2TxMsgType( 3 downto 0 );
			end if;
		end if;
	End Process u_rCtrl2TxMsgType;
	
	u_rCtrl2TxSeqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset 
			if ( rState=stInit ) then 
				rCtrl2TxSeqNum(26 downto 0 )	<= cInitSeqNum_1; 
			-- Resend process seqnum 
			elsif ( rCtrlRsqStart='1' or (rCtrlRsqCheckEnd='1' 
				and rCtrl2TxTranEn='1' and rCtrlRsqEn(0)='0') ) then 
				rCtrl2TxSeqNum(26 downto 0 )	<= rCtrlRsqBeginSeqNum(26 downto 0 );
			-- Resend process incrementing  
			elsif ( rCtrl2TxTranEn='1' and rCtrlRsqEn(0)='1' ) then 
				rCtrl2TxSeqNum(26 downto 0 )	<= rCtrl2TxSeqNum(26 downto 0 ) + ("000"&x"00000"&rCtrlRsqSeqNumCnt(3 downto 0));
			elsif ( rCtrl2TxTranEn='1' ) then 
				rCtrl2TxSeqNum(26 downto 0 )	<= rCtrl2TxSeqNum(26 downto 0 ) + 1; 
			else 
				rCtrl2TxSeqNum(26 downto 0 )	<= rCtrl2TxSeqNum(26 downto 0 );
			end if; 
		end if;
	End Process u_rCtrl2TxSeqNum;
	
	u_rCtrl2TxTranEn : Process (Clk) Is 
	Begin
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrl2TxTranEn	<= '0';
			else 
				if ( rCtrl2TxReq='1' and Tx2CtrlBusy='1' ) then 
					rCtrl2TxTranEn	<= '1';
				else 
					rCtrl2TxTranEn	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rCtrl2TxTranEn;
	
	u_rCtrl2TxMsgGenTag112 : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			-- When replying TestReq with Heartbeat 
			if ( rCtrl2TxTranEn='1' and rCtrl2TxMsgType(3 downto 0)="0010" ) then 
				rCtrl2TxMsgGenTag112(127 downto 0 )		<= rCtrlTrrText(63 downto 0)&x"0000000000000000";
				rCtrl2TxMsgGenTag112Len( 3 downto 0 )	<= rCtrlTrrTextLen( 3 downto 0 );
			-- When Sending TestReq 
			elsif ( rCtrl2TxTranEn='1' ) then 
				rCtrl2TxMsgGenTag112(127 downto 0 )		<= cTestReq_String&x"0000000000000000";
				rCtrl2TxMsgGenTag112Len( 3 downto 0 )	<= cTestReq_StringLen;
			else 
				rCtrl2TxMsgGenTag112(127 downto 0 )		<= rCtrl2TxMsgGenTag112(127 downto 0 );	
				rCtrl2TxMsgGenTag112Len( 3 downto 0 )	<= rCtrl2TxMsgGenTag112Len( 3 downto 0 );
			end if;
		end if;
	End Process u_rCtrl2TxMsgGenTag112;
	
	u_rCtrl2TxReplyTest : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Heartbeat replying 
			if ( rCtrl2TxReq='0' and Tx2CtrlBusy='0' and rCtrl2TxReqMsg(5 downto 0)="000000" 
				and rCtrl2TxReqMsg(7 downto 6)/="00" ) then 
				rCtrl2TxReplyTest	<= '1';
			-- Normal Heartbeat 
			elsif (  rCtrl2TxReq='0' and Tx2CtrlBusy='0' ) then 
				rCtrl2TxReplyTest	<= '0';
			else 
				rCtrl2TxReplyTest	<= rCtrl2TxReplyTest;
			end if; 
		end if;
	End Process u_rCtrl2TxReplyTest;
	
-----------------------------------------------------------
-- Resend write I/F 

	u_rCtrlRetranMsgType : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Message type: Reject 
			if ( rCtrl2TxReq='1' and rCtrl2TxMsgType(3 downto 0)="0110" ) then 
				rCtrlRetranMsgType( 1 downto 0 )	<= "11";
			-- Message type: MrkDataReq  
			elsif ( rCtrl2TxReq='1' and rCtrl2TxMsgType(3 downto 0)="0011" ) then 
				rCtrlRetranMsgType( 1 downto 0 )	<= "10";
			-- Message type: Else (Not Retransmit)
			elsif ( rCtrl2TxReq='1' ) then 
				rCtrlRetranMsgType( 1 downto 0 )	<= "00";
			else 
				rCtrlRetranMsgType( 1 downto 0 )	<= rCtrlRetranMsgType( 1 downto 0 );
			end if;
		end if;
	End Process u_rCtrlRetranMsgType;
	
	u_RetranRam : Ram74x16 
	Port map 
	(
		clock		=> Clk 							,
		data		=> rRetranRamWrData             ,
		rdaddress	=> rRetranRamRdAddr             ,
		wraddress	=> rCtrl2TxSeqNum(3 downto 0)   ,
		wren		=> rCtrl2TxTranEn               ,
		q			=> rRetranRamRdData
	);
	
	rRetranRamWrData(73 downto 0 )	<= rCtrlRetranMsgType&rCtrlRjtTxReason&rCtrlRjtTxRefSeqNum
									&rCtrlRjtTxRefMsgType&rCtrlRjtTxRefTagID&rCtrlRjtTxRefTagIDLen;
		
-- Resend Read I/F 
	
	u_rCtrlRsqDetect : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqDetect	<= '0';
			else 
				if ( Rx2CtrlMsgTypeVal(2)='1' and Rx2CtrlSeqNumError='0' and rCtrlRsqBusy(0)='0' ) then 
					rCtrlRsqDetect	<= '1';
				else 	
					rCtrlRsqDetect	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlRsqDetect;
	
	u_rCtrlRsqData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Rx2CtrlMsgTypeVal(2)='1' and rCtrlRsqBusy(0)='0' ) then 
				rCtrlRsqBeginSeqNum(26 downto 0 )	<= Rx2CtrlBeginSeqNum(26 downto 0 );
			elsif ( rCtrlRsqStart='1' ) then 
				rCtrlRsqBeginSeqNum(26 downto 0 )	<= rCtrl2TxSeqNum(26 downto 0 );
			else 	
				rCtrlRsqBeginSeqNum(26 downto 0 )	<= rCtrlRsqBeginSeqNum(26 downto 0 );
			end if; 
			
			if ( Rx2CtrlMsgTypeVal(2)='1' and rCtrlRsqBusy(0)='0' ) then 
				rCtrlRsqEndSeqNum(26 downto 0 )		<= Rx2CtrlEndSeqNum(26 downto 0 );
			else 
				rCtrlRsqEndSeqNum(26 downto 0 )		<= rCtrlRsqEndSeqNum(26 downto 0 );
			end if; 
		end if;
	End Process u_rCtrlRsqData;
	
	u_rRetranRamRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rCtrlRsqStart='1' ) then 
				rRetranRamRdAddr( 3 downto 0 )	<= rCtrlRsqBeginSeqNum(3 downto 0 );
			elsif ( rCtrlRsqEn(3 downto 0)="1111" ) then 
				rRetranRamRdAddr( 3 downto 0 )	<= rRetranRamRdAddr( 3 downto 0 ) + 1;
			else 	
				rRetranRamRdAddr( 3 downto 0 )	<= rRetranRamRdAddr( 3 downto 0 );
			end if; 
		end if;
	End Process u_rRetranRamRdAddr;
		
	u_rCtrlRsqEndAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rCtrlRsqEndAddr0( 3 downto 0 )	<= Rx2CtrlEndSeqNum( 3 downto 0 );
			if ( rCtrlRsqDetect='1' and rCtrlRsqEndSeqNum=0 ) then 
				rCtrlRsqEndAddr1( 3 downto 0 )	<= rCtrl2TxSeqNum(3 downto 0 ) - 1;
			elsif ( rCtrlRsqDetect='1' ) then 
				rCtrlRsqEndAddr1( 3 downto 0 )	<= rCtrlRsqEndAddr0( 3 downto 0 );
			else 	
				rCtrlRsqEndAddr1( 3 downto 0 )	<= rCtrlRsqEndAddr1( 3 downto 0 );
			end if; 
		end if;
	End Process u_rCtrlRsqEndAddr;
	
	u_rCtrlRsqBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqBusy( 3 downto 0 )	<= (others=>'0');
			else 
				rCtrlRsqBusy(3 downto 1)	<= rCtrlRsqBusy(2 downto 0);
				if ( rCtrlRsqEnd='1' or rState=stIdle ) then 
					rCtrlRsqBusy(0)	<= '0';
				elsif ( rCtrlRsqDetect='1' and rCtrlRsqBeginSeqNumCal(26)='1' 
					and (rCtrlRsqEndSeqNumCal(26)='1' or rCtrlRsqEndSeqNum=0) ) then 
					rCtrlRsqBusy(0)	<= '1';
				else 	
					rCtrlRsqBusy(0)	<= rCtrlRsqBusy(0);
				end if;
			end if;
		end if;
	End Process u_rCtrlRsqBusy;
	
	u_rCtrlRsqStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqStart	<= '0';
			else 
				if ( rCtrlRsqStart='0' and rCtrlRsqBusy(3 downto 0)="1111" 
					and rCtrl2TxReqMsg(10 downto 0)=("000"&x"00") and Tx2CtrlBusy='0' 
					and rCtrlRsqEn(0)='0' ) then
					rCtrlRsqStart	<= '1';
				else 
					rCtrlRsqStart	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlRsqStart; 
	
	u_rCtrlRsqEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqEnd	<= '0';
			else
				if ( rCtrlRsqEnd='0' and rCtrlRsqEn(2 downto 1)="11" and rCtrlRsqRstSeqEn(0)='0' 
					and rCtrlRsqMrkDatEn(0)='0' and rCtrlRsqRejectEn(0)='0' and rCtrlRsqCheckEnd='1' ) then
					rCtrlRsqEnd	<= '1';
				else 
					rCtrlRsqEnd	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlRsqEnd; 
	
	u_rCtrlRsqEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rCtrlRsqEn( 3 downto 0 )	<= (others=>'0');  
			else 
				if ( rCtrlRsqEnd='1' or rState=stIdle )  then 
					rCtrlRsqEn(0)	<= '0';
				elsif ( rCtrlRsqStart='1' ) then 
					rCtrlRsqEn(0)	<= '1';	
				else 
					rCtrlRsqEn(0) 	<= rCtrlRsqEn(0); 
				end if;
				
				rCtrlRsqEn(2)	<= rCtrlRsqEn(1); 
				if ( rCtrlRsqEn(3 downto 1)="111" or rState=stIdle ) then 
					rCtrlRsqEn(1)	<= '0';
				elsif ( rCtrlRsqEn(0)='1' ) then 
					rCtrlRsqEn(1)	<= '1';	
				else 
					rCtrlRsqEn(1) 	<= rCtrlRsqEn(1); 
				end if; 
				
				if ( rCtrlRsqEn(2 downto 1)="11" and rCtrlRsqRstSeqEn(0)='0' 
					and rCtrlRsqMrkDatEn(0)='0' and rCtrlRsqRejectEn(0)='0' ) then 
					rCtrlRsqEn(3)	<= '1';
				else 
					rCtrlRsqEn(3)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlRsqEn; 
	
	u_rCtrlRsqRstSeqEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqRstSeqEn( 4 downto 0 )	<= (others=>'0');
			else 
				rCtrlRsqRstSeqEn(1)	<= rCtrlRsqRstSeqEn(0); 
				if ( (rCtrlRsqRstSeqEn(1)='1' and rCtrlRsqCheckEnd='0')
					or rCtrlRsqRstSeqEn(4 downto 3)="10" or rState=stIdle ) then 
					rCtrlRsqRstSeqEn(0)	<= '0';
				elsif ( rCtrlRsqEn(2 downto 1)="01" and rRetranRamRdData(73 downto 72)="00" ) then 
					rCtrlRsqRstSeqEn(0)	<= '1';
				else 
					rCtrlRsqRstSeqEn(0)	<= rCtrlRsqRstSeqEn(0);
				end if; 
				
				if ( rCtrlRsqCheckEnd='1' or rCtrlRsqMrkDatEn(0)='1' 
					or rCtrlRsqRejectEn(0)='1' or rState=stIdle ) then 
					rCtrlRsqRstSeqEn(2)	<= '0';
				elsif ( rCtrlRsqRstSeqEn(1 downto 0)="01" ) then 
					rCtrlRsqRstSeqEn(2)	<= '1';
				else 
					rCtrlRsqRstSeqEn(2)	<= rCtrlRsqRstSeqEn(2);
				end if; 
				
				rCtrlRsqRstSeqEn(4)	<= rCtrlRsqRstSeqEn(3); 
				if ( rCtrlRsqRstSeqEn(4)='1' and rCtrl2TxReqMsg(4)='0' ) then 
					rCtrlRsqRstSeqEn(3)	<= '0';
				elsif ( (rCtrlRsqRstSeqEn(2)='1' and (rCtrlRsqMrkDatEn(0)='1' or rCtrlRsqRejectEn(0)='1'))
					or (rCtrlRsqRstSeqEn(1 downto 0)="11" and rCtrlRsqCheckEnd='1') ) then 
					rCtrlRsqRstSeqEn(3)	<= '1';
				else 
					rCtrlRsqRstSeqEn(3)	<= rCtrlRsqRstSeqEn(3);
				end if; 
			end if;
		end if;
	End Process u_rCtrlRsqRstSeqEn; 
	
	u_rCtrlRsqMrkDatEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqMrkDatEn( 3 downto 0 )	<= (others=>'0');
			else 
				rCtrlRsqMrkDatEn(1)	<= rCtrlRsqMrkDatEn(0); 
				if ( rCtrlRsqMrkDatEn(3)='1' and rCtrl2TxReqMsg(3)='0' ) then 
					rCtrlRsqMrkDatEn(0)	<= '0';
				elsif ( rCtrlRsqEn(2 downto 1)="01" and rRetranRamRdData(73 downto 72)="10" ) then 
					rCtrlRsqMrkDatEn(0)	<= '1';
				else 
					rCtrlRsqMrkDatEn(0)	<= rCtrlRsqMrkDatEn(0);
				end if; 
				
				rCtrlRsqMrkDatEn(3)	<= rCtrlRsqMrkDatEn(2); 
				if ( rCtrlRsqMrkDatEn(3)='1' and rCtrl2TxReqMsg(3)='0' ) then 
					rCtrlRsqMrkDatEn(2)	<= '0';
				elsif ( rCtrlRsqMrkDatEn(1)='1' and rCtrlRsqRstSeqEn(3)='0' ) then 
					rCtrlRsqMrkDatEn(2)	<= '1';
				else 
					rCtrlRsqMrkDatEn(2)	<= rCtrlRsqMrkDatEn(2);
				end if; 
			end if;
		end if;
	End Process u_rCtrlRsqMrkDatEn; 
	
	u_rCtrlRsqRejectEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRsqRejectEn( 3 downto 0 )	<= (others=>'0');
			else 
				rCtrlRsqRejectEn(1)	<= rCtrlRsqRejectEn(0); 
				if ( rCtrlRsqRejectEn(3)='1' and rCtrlRjtTxBusy(0)='0' ) then 
					rCtrlRsqRejectEn(0)	<= '0';
				elsif ( rCtrlRsqEn(2 downto 1)="01" and rRetranRamRdData(73 downto 72)="11" ) then 
					rCtrlRsqRejectEn(0)	<= '1';
				else 
					rCtrlRsqRejectEn(0)	<= rCtrlRsqRejectEn(0);
				end if; 
				
				rCtrlRsqRejectEn(3)	<= rCtrlRsqRejectEn(2); 
				if ( rCtrlRsqRejectEn(3)='1' and rCtrlRjtTxBusy(0)='0' ) then 
					rCtrlRsqRejectEn(2)	<= '0';
				elsif ( rCtrlRsqRejectEn(1)='1' and rCtrlRsqRstSeqEn(3)='0' ) then 
					rCtrlRsqRejectEn(2)	<= '1';
				else 
					rCtrlRsqRejectEn(2)	<= rCtrlRsqRejectEn(2);
				end if; 
			end if;
		end if;
	End Process u_rCtrlRsqRejectEn; 
	
	u_rCtrlRsqCheckEnd : Process (Clk) Is 
	Begin	
		if ( rising_edge(Clk) ) then 
			rCtrlRsqAddrCal(3 downto 0)	<= rCtrlRsqEndAddr1(3 downto 0) - rRetranRamRdAddr(3 downto 0);
			if ( rCtrlRsqEn(1)='1' and rCtrlRsqAddrCal=0 ) then 
				rCtrlRsqCheckEnd	<= '1';
			else 
				rCtrlRsqCheckEnd	<= '0';
			end if;
		end if;
	End Process u_rCtrlRsqCheckEnd;
	
	u_rCtrlRsqSeqNumCnt : Process (Clk) Is 
	Begin	
		if ( rising_edge(Clk) ) then 
			if ( rCtrl2TxTranEn='1' ) then 
				rCtrlRsqSeqNumCnt( 3 downto 0 )	<= (others=>'0');
			elsif ( rCtrlRsqRstSeqEn(1 downto 0)="01" or rCtrlRsqMrkDatEn(3 downto 2)="01" 
				or rCtrlRsqRejectEn(3 downto 2)="01" ) then 
				rCtrlRsqSeqNumCnt( 3 downto 0 )	<= rCtrlRsqSeqNumCnt( 3 downto 0 ) + 1;
			else 
				rCtrlRsqSeqNumCnt( 3 downto 0 )	<= rCtrlRsqSeqNumCnt( 3 downto 0 );
			end if;
		end if;
	End Process u_rCtrlRsqSeqNumCnt;
	
	u_rCtrlRsqDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rCtrlRsqBeginSeqNumCal(26 downto 0 )  <= Rx2CtrlBeginSeqNum(26 downto 0 ) - rCtrl2TxSeqNum(26 downto 0 );
			rCtrlRsqEndSeqNumCal(26 downto 0 ) 	  <= rCtrlRsqEndSeqNum(26 downto 0 ) - rCtrl2TxSeqNum(26 downto 0 );
		end if;
	End Process u_rCtrlRsqDataCal;
	
-----------------------------------------------------------
-- Error signal 

	u_rCtrlError : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlError( 3 downto 0 )	<= (others=>'0');
			else 
				-- Bit 0: Duplicate message, PossDupFlag not set
				if ( rRxCtrlOutOfOrder(2)='1' and rRx2CtrlPossDupFlagFF(1)='0' ) then 
					rCtrlError(0)	<= '1';
				else 
					rCtrlError(0)	<= '0';
				end if;
				
				-- Bit 1: Detect Beginseqnum and endseqnum that can not retransmit 
				if ( rCtrlRsqDetect='1' and (rCtrlRsqBeginSeqNumCal(26)='0' 
					or (rCtrlRsqEndSeqNumCal(26)='0' and rCtrlRsqEndSeqNum/=0)) ) then 
					rCtrlError(1)	<= '1';
				else 
					rCtrlError(1)	<= '0';
				end if;
				
				-- Bit 2: Detect peer not respond the TestReq message within 2*Heartbeat interval timueout 
				if ( rCtrlTtrBusy(1)='1' and rCtrlLogoutTimeoutCnt=1 ) then 
					rCtrlError(2)	<= '1';
				else 
					rCtrlError(2)	<= '0';
				end if;
				
				-- Bit 3: Logon wait timer 
				if ( rState=stWaitLogon and rCtrlLogonTimeoutCnt=1) then 
					rCtrlError(3)	<= '1';
				else 
					rCtrlError(3)	<= '0';
				end if;
				
			end if;
		end if;
	End Process u_rCtrlError;

End Architecture rtl;