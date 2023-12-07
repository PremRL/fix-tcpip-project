----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbFixProc.vhd
-- Title        Testbench of FIX processor
-- 
-- Author       L.Ratchanon
-- Date         2021/02/20
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use STD.textio.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_textio.all;
use work.PkTbFixProc.all;
use work.PkSigTbFixProc.all; 

Entity TbFixProc Is
End Entity TbFixProc;

Architecture HTWTestBench Of TbFixProc Is

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component PkMapTbFixProc Is 
	End Component PkMapTbFixProc;

Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------

	u_PkMapTbFixProc : PkMapTbFixProc; 
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	u_Test : Process
	variable 	HdRec				: HdRecord;
	variable 	LogonRec			: LogonRecord;
	variable	ResentReqRec		: ResentReqRecord;
	variable 	RejectRec			: RejectRecord; 
	variable 	SeqRstRec			: SeqRstRecord;
	variable 	SnapShotFullRec		: SnapShotFullRecord;
	variable	ErrorOption			: integer := 0; 
	variable	TestReqID			: string (1 to 8);
	variable 	FixMsgDataLength	: integer;
	variable	FixMsgDataArray		: Pkt_array;
	variable	MsgFataArrayTemp	: Pkt_array;
	variable 	ExpMsgType			: std_logic_vector(7 downto 0);
	
	Begin
		-------------------------------------------
		-- TM=0 : Initialization  
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		User2FixConn			<= '0';
		User2FixDisConn			<= '0';			
		User2FixSenderCompID	<= x"31355f4649585f4d443530"&x"0000000000"; -- 15_FIX_MD50	
		User2FixTargetCompID	<= x"534554"&x"00000000000000000000000000"; -- SET 	
		User2FixUsername		<= x"4d445f4649585f414c4c5f313233"&x"0000"; -- MD_FIX_ALL_123
		User2FixPassword        <= x"6162636431323321"&x"0000000000000000"; -- abcd123!
		User2FixSenderCompIDLen	<= conv_std_logic_vector(11, 5);    
		User2FixTargetCompIDLen	<= conv_std_logic_vector(3, 5);    
		User2FixUsernameLen		<= conv_std_logic_vector(14, 5);    
		User2FixPasswordLen	    <= conv_std_logic_vector(8, 5);    
		User2FixIdValid 	 	<= '1';	
		User2FixRxSenderId		<= x"00_0031_355f_4649_585f_4d44_3530";	-- '0 015_ FIX_ MD50'	
		User2FixRxTargetId		<= x"00_0000_0000_0000_0000_0053_4554";	-- '0 0000 0000 0SET'	
		User2FixMrketData0		<= conv_std_logic_vector(0, 10);  	
		User2FixMrketData1		<= conv_std_logic_vector(12, 10);    
		User2FixMrketData2		<= conv_std_logic_vector(24, 10);    
		User2FixMrketData3		<= conv_std_logic_vector(36, 10);    
		User2FixMrketData4		<= conv_std_logic_vector(252, 10);    -- GULF
		User2FixNoRelatedSym	<= x"5"; --5 	
		User2FixMDEntryTypes	<= x"3031";	
		User2FixNoMDEntryTypes	<= "010"; -- 2             
		TOE2FixMemAlFull		<= '0';	
		
		RTCTimeYear		    	<= conv_std_logic_vector(2021, 14);
		RTCTimeMonth	    	<= conv_std_logic_vector(3, 4);
		RTCTimeDay		    	<= conv_std_logic_vector(31, 5);
		RTCTimeHour		    	<= conv_std_logic_vector(12, 5);
		RTCTimeMin		    	<= conv_std_logic_vector(52, 6);
		RTCTimeMilliSec	    	<= conv_std_logic_vector(24531, 17);
		
		RxTCPDataInit(RxDataRec);
		
		-- Formulating Header Detail 
		HdRec.HdBeginStrLen	:= 8; HdRec.HdBeginStr(1 to HdRec.HdBeginStrLen) 	:= "FIXT.1.1";
		HdRec.HdSendComIDLen:= 3; HdRec.HdSendComID(1 to HdRec.HdSendComIDLen)	:= "SET";
		HdRec.HdTarComIDLen := 11; HdRec.HdTarComID(1 to HdRec.HdTarComIDLen)	:= "15_FIX_MD50";
		HdRec.HdSendTimeLen := 21; HdRec.HdSendTime(1 to HdRec.HdSendTimeLen)	:= "20210314-21:50:12.523";
		HdRec.HdPossDupLen := 0; HdRec.HdPossDup(1 to 1)	:= "Y";
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Connection  
		-------------------------------------------
		-- TT=0 : Invalid Logon
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message : Set EncryptMet = 1 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "1";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive any message other than a Logon
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Heartbeat Message
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		ErrorOption			:= 0; 
		
		-- Receving Heatbeat whose message type is not logon : No error 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : Receive Invalid invalid SenderCompID of logon 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message : Set EncryptMet = 1 
		HdRec.HdSendComIDLen:= 3; HdRec.HdSendComID(1 to HdRec.HdSendComIDLen)	:= "TES";
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- RxFix Ignored the message due to invalid SenderComID 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=3 : Receive Valid logon 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating Logon Message 
		HdRec.HdSendComIDLen:= 3; HdRec.HdSendComID(1 to HdRec.HdSendComIDLen)	:= "SET";
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=2 : Receive Message Standard Header  
		-------------------------------------------
		-- TT=0 : MsgSeqNum(34) received as expected
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		
		SnapShotFullRec.MDReqIDLen		:= 2;	SnapShotFullRec.MDReqID(1 to SnapShotFullRec.MDReqIDLen) := "MA";				
		SnapShotFullRec.SymbolLen		:= 4;   SnapShotFullRec.Symbol(1 to SnapShotFullRec.SymbolLen) := "GULF";			
		SnapShotFullRec.SecIDLen		:= 5;   SnapShotFullRec.SecID(1 to SnapShotFullRec.SecIDLen) := "30037";			
		SnapShotFullRec.SecIDSrcLen		:= 1;   SnapShotFullRec.SecIDSrc(1 to SnapShotFullRec.SecIDSrcLen) := "8";		
		SnapShotFullRec.NoEntriesLen	:= 1;   SnapShotFullRec.NoEntries(1 to SnapShotFullRec.NoEntriesLen) := "2";		
		SnapShotFullRec.EntryType0Len	:= 1;   SnapShotFullRec.EntryType0(1 to SnapShotFullRec.EntryType0Len) := "0";		
		SnapShotFullRec.Price0Len		:= 20;  SnapShotFullRec.Price0(1 to SnapShotFullRec.Price0Len) := "9223372036854.775807";			
		SnapShotFullRec.Size0Len		:= 4;   SnapShotFullRec.Size0(1 to SnapShotFullRec.Size0Len) := "1500";			
		SnapShotFullRec.EntryTime0Len	:= 12;  SnapShotFullRec.EntryTime0(1 to SnapShotFullRec.EntryTime0Len) := "04:55:21.029";		
		SnapShotFullRec.EntryType1Len	:= 1;   SnapShotFullRec.EntryType1(1 to SnapShotFullRec.EntryType1Len) := "1";		
		SnapShotFullRec.Price1Len		:= 8;   SnapShotFullRec.Price1(1 to SnapShotFullRec.Price1Len) := "0.000001";			
		SnapShotFullRec.Size1Len		:= 5;   SnapShotFullRec.Size1(1 to SnapShotFullRec.Size1Len) := "12000";			
		SnapShotFullRec.EntryTime1Len	:= 12;  SnapShotFullRec.EntryTime1(1 to SnapShotFullRec.EntryTime1Len) := "04:45:00.000";		
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : MsgSeqNum(34) higher than expected 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "4";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- ResendReq has been sent 
		ExpMsgType := to_slv("2"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "3";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "4";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : MsgSeqNum(34) lower than expected without PossDupFlag(43) set to Y
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "4";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=3 : Garbled message received : BeginString and Bodylength Swap sequent 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------

		-- Formulating Snapshot Message : BeginString and Bodylength Swap sequent 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		MsgFataArrayTemp(0 to 10) 	:= FixMsgDataArray(0 to 10); 
		FixMsgDataArray(0 to 7) 	:= FixMsgDataArray(11 to 18); 
		FixMsgDataArray(8 to 18) 	:= MsgFataArrayTemp(0 to 10);
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Consider garbled and ignore message => Rx Supported : Not incrementing SeqNum 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=4 : BodyLength(9) value received is not correct 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating Heartbeat message with Bodylength Error  
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		ErrorOption			:= 1; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Consider garbled and ignore message => Rx Supported : Not incrementing SeqNum 
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=3 : Send/Receive Heartbeat message
		-------------------------------------------
		-- TT=0 : No data sent during preset heartbeat interval 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Heartbeat has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Snapshot Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "W";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "3";
		
		-- Receving Market Data Snapshot Full Refres
		SnapShotBuild(HdRec, SnapShotFullRec, FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Heartbeat has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : TestRequest(35=1) message received 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating TestReq Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "1";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "4";
		
		TestReqID(1 to 8)	:= "TestConn";
		
		-- Receving TestReq 
		HB_or_TestReq_Build(HdRec, TestReqID(1 to 8), FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Heartbeat with Tag 112 has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : Valid Heartbeat(35=0) message 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);

		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "5";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=4 : Send Test Request
		-------------------------------------------
		-- TT=0 : No data received during preset heartbeat interval (HeartBtInt+20%) 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Heartbeat message has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- TestReq with Tag 112 has been sent due to Rx Heartbeat not receiving within timeout 
		ExpMsgType := to_slv("1"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Heartbeat message with 112 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "6";
		
		TestReqID(1 to 8)	:= "TestReq!";
		
		-- Receving Heartbeat message 
		HB_or_TestReq_Build(HdRec, TestReqID(1 to 8), FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : No data received during preset heartbeat interval 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Heartbeat message has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- TestReq with Tag 112 has been sent 
		ExpMsgType := to_slv("1"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Heartbeat message has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- No responding for a constant time => Disconnect
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=5 : Receive Message Standard Trailer
		-------------------------------------------
		-- TT=0 : Invalid CheckSum(10) 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------
		
		-- Receving Invalid Checksum of Heartbeat message 
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		ErrorOption			:= 2; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=6 : Receive Reject message
		-------------------------------------------
		-- TT=0 : Valid Reject(35=3) message 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "2";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 500*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Heartbeat has been sent 
		ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Reject message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "3";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "3";
		
		RejectRec.RefSeqNumLen		:= 1; RejectRec.RefSeqNum(1 to RejectRec.RefSeqNumLen)		:= "3"; 
		RejectRec.RefTagIDLen		:= 3; RejectRec.RefTagID(1 to RejectRec.RefTagIDLen)		:= "112";
		RejectRec.RefMsgTypeLen	    := 1; RejectRec.RefMsgType(1 to RejectRec.RefMsgTypeLen)	:= "0";
		RejectRec.ReajectReaonLen	:= 1; RejectRec.ReajectReaon(1 to RejectRec.ReajectReaonLen):= "5";
		RejectRec.EncodedTextLen	:= 0; RejectRec.EncodedText(1 to 5)							:= "ERROR"; 
		
		-- Receving Reject message 
		RejectBuild(HdRec, RejectRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=7 : Receive Resend Request message
		-------------------------------------------
		-- TT=0 : MrkDataReq + Long period of heartbeat (EndSeqNum=0)
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		for i in 0 to 2 loop
			-- Formulating Heartbeat message 
			HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
			HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= integer'image(4 + i);
			ErrorOption			:= 0; 
			
			-- Receving Heartbeat message 
			EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray);
			RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
			
			-- Heartbeat has been sent 
			ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		End loop; 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "7";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Formulating ResendReq(35=2) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "2";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "8";
		
		ResentReqRec.BeginSeqNumLen	:= 1; ResentReqRec.BeginSeqNum(1 to ResentReqRec.BeginSeqNumLen):= "2";	 	
		ResentReqRec.EndSeqNumLen	:= 1; ResentReqRec.EndSeqNum(1 to ResentReqRec.EndSeqNumLen)	:= "0";
		
		-- Receving ResendReq(35=2) message 
		ReSentReqBuild(HdRec, ResentReqRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- SeqReset has been sent 
		ExpMsgType := to_slv("4"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : MrkDataReq + Long period of heartbeat (EndSeqNum/=0)
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating ResendReq(35=2) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "2";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "9";
		
		ResentReqRec.BeginSeqNumLen	:= 1; ResentReqRec.BeginSeqNum(1 to ResentReqRec.BeginSeqNumLen):= "2";
		ResentReqRec.EndSeqNumLen	:= 1; ResentReqRec.EndSeqNum(1 to ResentReqRec.EndSeqNumLen)	:= "5";
		
		-- Receving ResendReq(35=2) message 
		ReSentReqBuild(HdRec, ResentReqRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- SeqReset has been sent 
		ExpMsgType := to_slv("4"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=8 : Receive Sequence Reset
		-------------------------------------------
		-- TT=0 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) > NextNumIn
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "10";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Formulating SequenceReset(35=4) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "4";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "12";
		
		SeqRstRec.GapFillFlagLen:= 1; SeqRstRec.GapFillFlag(1 to SeqRstRec.GapFillFlagLen)	:= "Y";	
		SeqRstRec.NewSeqNumLen	:= 2; SeqRstRec.NewSeqNum(1 to SeqRstRec.NewSeqNumLen)		:= "15";
		
		-- Receving SequenceReset(35=4) message 
		SeqRstBuild(HdRec, SeqRstRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- ResendReq(35=2) message has been sent 
		ExpMsgType := to_slv("2"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) = NextNumIn
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating SequenceReset(35=4) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "4";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "11";
		
		SeqRstRec.GapFillFlagLen:= 1; SeqRstRec.GapFillFlag(1 to SeqRstRec.GapFillFlagLen)	:= "Y";	
		SeqRstRec.NewSeqNumLen	:= 2; SeqRstRec.NewSeqNum(1 to SeqRstRec.NewSeqNumLen)		:= "15";
		
		-- Receving SequenceReset(35=4) message 
		SeqRstBuild(HdRec, SeqRstRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) < NextNumIn and PossDupFlag(43)=Y
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating SequenceReset(35=4) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "4";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "14";
		HdRec.HdPossDupLen  := 1; HdRec.HdPossDup(1 to HdRec.HdPossDupLen)	:= "Y";
		
		SeqRstRec.GapFillFlagLen:= 1; SeqRstRec.GapFillFlag(1 to SeqRstRec.GapFillFlagLen)	:= "Y";	
		SeqRstRec.NewSeqNumLen	:= 2; SeqRstRec.NewSeqNum(1 to SeqRstRec.NewSeqNumLen)		:= "16";
		
		-- Receving SequenceReset(35=4) message 
		SeqRstBuild(HdRec, SeqRstRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- RxFix ignored the message due to received sequence number less than expected sequence number 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=3 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) < NextNumIn and without PossDupFlag(43)=Y 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating SequenceReset(35=4) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "4";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "14";
		HdRec.HdPossDupLen  := 0; HdRec.HdPossDup(1 to 1)	:= "Y";
		
		SeqRstRec.GapFillFlagLen:= 1; SeqRstRec.GapFillFlag(1 to SeqRstRec.GapFillFlagLen)	:= "Y";	
		SeqRstRec.NewSeqNumLen	:= 2; SeqRstRec.NewSeqNum(1 to SeqRstRec.NewSeqNumLen)		:= "17";
		
		-- Receving SequenceReset(35=4) message 
		SeqRstBuild(HdRec, SeqRstRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=9 : Receive Sequence Reset (N)
		-------------------------------------------
		-- TT=0 : Receive SequenceReset(35=4) with GapFillFlag(123)=N message with NewSeqNo(36) >= NextNumIn 
		-- >>Accept the SequenceReset(35=4) message without regard to its MsgSeqNum(34), Set NextNumIn to NewSeqNo(36)
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------
	
		-- Formulating SequenceReset(35=4) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "4";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "15";
		
		SeqRstRec.GapFillFlagLen:= 1; SeqRstRec.GapFillFlag(1 to SeqRstRec.GapFillFlagLen)	:= "N";	
		SeqRstRec.NewSeqNumLen	:= 2; SeqRstRec.NewSeqNum(1 to SeqRstRec.NewSeqNumLen)		:= "16";
		
		-- Receving SequenceReset(35=4) message 
		SeqRstBuild(HdRec, SeqRstRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=10 : logout process
		-------------------------------------------
		-- TT=0 : Send Logout(35=5) message and receive
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		User2FixDisConn			<= '1';
		
		-- TestReq has been sent 
		ExpMsgType := to_slv("1"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Heartbeat message with 112 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "16";
		
		TestReqID(1 to 8)	:= "TestReq!";
		
		-- Receving Heartbeat message 
		HB_or_TestReq_Build(HdRec, TestReqID(1 to 8), FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logout message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "5";
		HdRec.HdSeqNumLen	:= 2; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "17";
		ErrorOption			:= 0; 
		
		-- Receving Logout message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		wait until Fix2UserOperate='0' and rising_edge(Clk);
		User2FixDisConn			<= '0';
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Send Logout(35=5) message and no response 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------
		
		------------------------
		-- Sending and receiving some messages
		
		for i in 0 to 2 loop
			-- Formulating Heartbeat message 
			HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
			HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= integer'image(2 + i);
			ErrorOption			:= 0; 
			
			-- Receving Heartbeat message 
			EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray);
			RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
			
			-- Heartbeat has been sent 
			ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		End loop; 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "5";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		------------------------
		
		User2FixDisConn			<= '1';
		
		-- TestReq has been sent 
		ExpMsgType := to_slv("1"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Heartbeat message with 112 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "6";
		
		TestReqID(1 to 8)	:= "TestReq!";
		
		-- Receving Heartbeat message 
		HB_or_TestReq_Build(HdRec, TestReqID(1 to 8), FixMsgDataLength, FixMsgDataArray); wait for 100*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk); 
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait until Fix2UserOperate='0' and rising_edge(Clk);
		User2FixDisConn			<= '0';
		
		-- Auto disconnect due to time-out 
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : receive Logout(35=5) message 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------
		
		------------------------
		-- Sending and receiving some messages
		
		for i in 0 to 2 loop
			-- Formulating Heartbeat message 
			HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
			HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= integer'image(2 + i);
			ErrorOption			:= 0; 
			
			-- Receving Heartbeat message 
			EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray);
			RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
			
			-- Heartbeat has been sent 
			ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		End loop; 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "5";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		------------------------
		
		-- Formulating Logout message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "5";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "6";
		ErrorOption			:= 0; 
		
		-- Receving Logout message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Logout message has been sent 
		ExpMsgType := to_slv("5"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=11: Receive application or session layer message
		-------------------------------------------
		-- TT=0 : Receive field identifier (tag number) not defined in specification
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------
		-- Connection 
		User2FixConn				<= '1';
		wait until Fix2UserOperate='1' and rising_edge(Clk);
		User2FixConn				<= '0';
		
		-- Logon Message has been sent 
		ExpMsgType := to_slv("A"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Formulating Logon Message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "A";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "1";
		
		LogonRec.EncryptMetLen		:= 1; LogonRec.EncryptMet(1 to LogonRec.EncryptMetLen)		:= "0";
		LogonRec.HeartBtIntLen	    := 2; LogonRec.HeartBtInt(1 to LogonRec.HeartBtIntLen)	    := "30";
		LogonRec.RstSeqNumFlagLen   := 1; LogonRec.RstSeqNumFlag(1 to LogonRec.RstSeqNumFlagLen):= "Y";
		LogonRec.AppVerIDLen		:= 1; LogonRec.AppVerID(1 to LogonRec.AppVerIDLen)			:= "9";
		
		-- Receving Logon Message
		LogonBuild(HdRec, LogonRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		------------------------
		
		------------------------
		-- Sending and receiving some messages
		
		for i in 0 to 2 loop
			-- Formulating Heartbeat message 
			HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
			HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= integer'image(2 + i);
			ErrorOption			:= 0; 
			
			-- Receving Heartbeat message 
			EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray);
			RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
			
			-- Heartbeat has been sent 
			ExpMsgType := to_slv("0"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		End loop; 
		
		-- Formulating Heartbeat message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "0";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "5";
		ErrorOption			:= 0; 
		
		-- Receving Heartbeat message 
		EmptyFieldBuild(HdRec, ErrorOption, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		------------------------
		
		-- Formulating Reject message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "3";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "6";
		
		RejectRec.RefSeqNumLen		:= 1; RejectRec.RefSeqNum(1 to RejectRec.RefSeqNumLen)		:= "4"; 
		RejectRec.RefTagIDLen		:= 3; RejectRec.RefTagID(1 to RejectRec.RefTagIDLen)		:= "355";
		RejectRec.RefMsgTypeLen	    := 1; RejectRec.RefMsgType(1 to RejectRec.RefMsgTypeLen)	:= "3";
		RejectRec.ReajectReaonLen	:= 1; RejectRec.ReajectReaon(1 to RejectRec.ReajectReaonLen):= "0";
		RejectRec.EncodedTextLen	:= 5; RejectRec.EncodedText(1 to RejectRec.EncodedTextLen)	:= "ERROR"; 
		
		-- Receving Reject message 
		RejectBuild(HdRec, RejectRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- Reject Message has been sent 
		ExpMsgType := to_slv("3"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive ResendReq of reject message  
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Formulating ResendReq(35=2) message 
		HdRec.HdMsgTypeLen	:= 1; HdRec.HdMsgType(1 to HdRec.HdMsgTypeLen) 	:= "2";
		HdRec.HdSeqNumLen	:= 1; HdRec.HdSeqNum(1 to HdRec.HdSeqNumLen) 	:= "7";
		
		ResentReqRec.BeginSeqNumLen	:= 1; ResentReqRec.BeginSeqNum(1 to ResentReqRec.BeginSeqNumLen):= "2";	 	
		ResentReqRec.EndSeqNumLen	:= 1; ResentReqRec.EndSeqNum(1 to ResentReqRec.EndSeqNumLen)	:= "0";
		
		-- Receving ResendReq(35=2) message 
		ReSentReqBuild(HdRec, ResentReqRec, FixMsgDataLength, FixMsgDataArray); wait for 50*tClk;
		RxTCPDataGen(FixMsgDataLength, FixMsgDataArray, RxDataRec, Clk);
		
		-- MrkDataReq Message has been sent 
		ExpMsgType := to_slv("V"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- SeqReset Message has been sent 
		ExpMsgType := to_slv("4"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		-- Reject Message has been sent 
		ExpMsgType := to_slv("3"); FixOutDataVerify(TxDataRec, ExpMsgType, Clk);
		
		
		wait for 20*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;