----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkMapTbFixCtrl.vhd
-- Title        Mapping of TbFixCtrl
-- 
-- Author       L.Ratchanon
-- Date         2021/03/07
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
-- 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.PkSigTbFixCtrl.all;

Entity PkMapTbFixCtrl Is
End Entity PkMapTbFixCtrl;

Architecture HTWTestBench Of PkMapTbFixCtrl Is 

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
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

Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u_RstB : Process
	Begin
		RstB	<= '0';
		wait for 20*tClk;
		RstB	<= '1';
		wait;
	End Process u_RstB;

	u_Clk : Process
	Begin
		Clk		<= '1';
		wait for tClk/2;
		Clk		<= '0';
		wait for tClk/2;
	End Process u_Clk;
	
	u_TOEStatus : Process 
	Begin 
		TOE2FixPSHFlagset	<= '0';
		TOE2FixFINFlagset   <= '0';
		TOE2FixRSTFlagset   <= '0';
		if ( RstB='0' ) then 
			TOE2FixStatus	<= "0001";
		else 
			if ( Fix2TOEConnectReq='1' and TOE2FixStatus="0001" ) then 
				TOE2FixStatus	<= "0010";
				wait for 20*tClk;
				wait until rising_edge(Clk);
				TOE2FixStatus	<= "0100";
			elsif ( Fix2TOETerminateReq='1' and TOE2FixStatus="0100" ) then 
				TOE2FixStatus	<= "1000";
				wait for 20*tClk;
				wait until rising_edge(Clk);
				TOE2FixStatus	<= "0001";
			else 
				TOE2FixStatus	<= TOE2FixStatus;
			end if; 
		end if;
		wait until rising_edge(Clk);
	End Process u_TOEStatus;
	
	u_Tx2CtrlBusy : Process 
	Begin 
		if ( RstB='0' ) then 
			Tx2CtrlBusy	<= '0';
		else 
			if ( Tx2CtrlBusy='0' and Ctrl2TxReq='1' ) then 
				Tx2CtrlBusy	<= '1';
				wait for 10*tClk;
				wait until rising_edge(Clk);
				Tx2CtrlBusy	<= '0';
			else 
				Tx2CtrlBusy	<= '0';
			end if;
		end if;
		wait until rising_edge(Clk);
	End Process u_Tx2CtrlBusy;
	
	u_FixCtrl: FixCtrl 
	Port map
	(
		Clk							=>	Clk							,
		RstB						=>  RstB						,

		UserFixConn					=>  UserFixConn_t				,	
		UserFixDisConn				=>  UserFixDisConn_t			,	
		UserFixRTCTime				=>  UserFixRTCTime_t			,	
		UserFixSenderCompID			=>  UserFixSenderCompID_t		,	
		UserFixTargetCompID			=>  UserFixTargetCompID_t		,	
		UserFixUsername				=>  UserFixUsername_t			,	
		UserFixPassword             =>  UserFixPassword_t           , 
		UserFixSenderCompIDLen		=>  UserFixSenderCompIDLen_t	,	
		UserFixTargetCompIDLen		=>  UserFixTargetCompIDLen_t	,	
		UserFixUsernameLen			=>  UserFixUsernameLen_t		,	
		UserFixPasswordLen	        =>  UserFixPasswordLen_t	    ,    
	
		UserFixMrketData0			=>  UserFixMrketData0_t			,
		UserFixMrketData1			=>  UserFixMrketData1_t			,
		UserFixMrketData2			=>  UserFixMrketData2_t			,
		UserFixMrketData3			=>  UserFixMrketData3_t			,
		UserFixMrketData4			=>  UserFixMrketData4_t			,
		UserFixNoRelatedSym			=>  UserFixNoRelatedSym_t		,	
		UserFixMDEntryTypes			=>  UserFixMDEntryTypes_t		,	
		UserFixNoMDEntryTypes		=>  UserFixNoMDEntryTypes_t		,
	
		UserFixOperate				=>  UserFixOperate_t			,	
		UserFixError 				=>  UserFixError_t 				,
	
		Fix2TOEConnectReq			=>  Fix2TOEConnectReq_t			,
		Fix2TOETerminateReq			=>  Fix2TOETerminateReq_t		,	
		Fix2TOERxDataReq			=>  Fix2TOERxDataReq_t			,
	
		TOE2FixStatus				=>  TOE2FixStatus_t				,
		TOE2FixPSHFlagset			=>  TOE2FixPSHFlagset_t			,
		TOE2FixFINFlagset 			=>  TOE2FixFINFlagset_t 		,	
		TOE2FixRSTFlagset			=>  TOE2FixRSTFlagset_t			,

		Ctrl2TxReq					=>  Ctrl2TxReq_t				,	
		Ctrl2TxPossDupEn 			=>  Ctrl2TxPossDupEn_t 			,
		Ctrl2TxReplyTest 			=>  Ctrl2TxReplyTest_t 			,
		Tx2CtrlBusy					=>  Tx2CtrlBusy_t				,	
	
		Ctrl2TxMsgType				=>  Ctrl2TxMsgType_t			,	
		Ctrl2TxMsgSeqNum			=>  Ctrl2TxMsgSeqNum_t			,
		Ctrl2TxMsgSendTime			=>  Ctrl2TxMsgSendTime_t		,	
		Ctrl2TxMsgBeginString		=>  Ctrl2TxMsgBeginString_t		,
		Ctrl2TxMsgSenderCompID		=>  Ctrl2TxMsgSenderCompID_t	,	
		Ctrl2TxMsgTargetCompID		=>  Ctrl2TxMsgTargetCompID_t	,	
		Ctrl2TxMsgBeginStringLen   	=>  Ctrl2TxMsgBeginStringLen_t  , 	
		Ctrl2TxMsgSenderCompIDLen	=>  Ctrl2TxMsgSenderCompIDLen_t	,
		Ctrl2TxMsgTargetCompIDLen	=>  Ctrl2TxMsgTargetCompIDLen_t	,

		Ctrl2TxMsgGenTag98			=>  Ctrl2TxMsgGenTag98_t		,	
		Ctrl2TxMsgGenTag108			=>  Ctrl2TxMsgGenTag108_t		,	
		Ctrl2TxMsgGenTag141			=>  Ctrl2TxMsgGenTag141_t		,	
		Ctrl2TxMsgGenTag553			=>  Ctrl2TxMsgGenTag553_t		,	
		Ctrl2TxMsgGenTag554			=>  Ctrl2TxMsgGenTag554_t		,	
		Ctrl2TxMsgGenTag1137		=>  Ctrl2TxMsgGenTag1137_t		,
		Ctrl2TxMsgGenTag553Len		=>  Ctrl2TxMsgGenTag553Len_t	,	
		Ctrl2TxMsgGenTag554Len		=>  Ctrl2TxMsgGenTag554Len_t	,	
	
		Ctrl2TxMsgGenTag112			=>  Ctrl2TxMsgGenTag112_t		,	
		Ctrl2TxMsgGenTag112Len		=>  Ctrl2TxMsgGenTag112Len_t	,	
	
		Ctrl2TxMsgGenTag262			=>  Ctrl2TxMsgGenTag262_t		,	
		Ctrl2TxMsgGenTag263			=>  Ctrl2TxMsgGenTag263_t		,	
		Ctrl2TxMsgGenTag264			=>  Ctrl2TxMsgGenTag264_t		,	
		Ctrl2TxMsgGenTag265			=>  Ctrl2TxMsgGenTag265_t		,	
		Ctrl2TxMsgGenTag266			=>  Ctrl2TxMsgGenTag266_t		,	
		Ctrl2TxMsgGenTag146			=>  Ctrl2TxMsgGenTag146_t		,	
		Ctrl2TxMsgGenTag22			=>  Ctrl2TxMsgGenTag22_t		,
		Ctrl2TxMsgGenTag267			=>  Ctrl2TxMsgGenTag267_t		,	
		Ctrl2TxMsgGenTag269			=>  Ctrl2TxMsgGenTag269_t		,	
	
		Ctrl2TxMsgGenTag7			=>  Ctrl2TxMsgGenTag7_t			,
		Ctrl2TxMsgGenTag16			=>  Ctrl2TxMsgGenTag16_t		,	

		Ctrl2TxMsgGenTag123			=>  Ctrl2TxMsgGenTag123_t		,	
		Ctrl2TxMsgGenTag36			=>  Ctrl2TxMsgGenTag36_t		,	

		Ctrl2TxMsgGenTag45			=>  Ctrl2TxMsgGenTag45_t		,	
		Ctrl2TxMsgGenTag371			=>  Ctrl2TxMsgGenTag371_t		,	
		Ctrl2TxMsgGenTag372			=>  Ctrl2TxMsgGenTag372_t		,	
		Ctrl2TxMsgGenTag373			=>  Ctrl2TxMsgGenTag373_t		,	
		Ctrl2TxMsgGenTag58			=>  Ctrl2TxMsgGenTag58_t		,	
		Ctrl2TxMsgGenTag371Len		=>  Ctrl2TxMsgGenTag371Len_t	,	
		Ctrl2TxMsgGenTag373Len		=>  Ctrl2TxMsgGenTag373Len_t	,	
		Ctrl2TxMsgGenTag58Len		=>  Ctrl2TxMsgGenTag58Len_t		,
		Ctrl2TxMsgGenTag371En		=>  Ctrl2TxMsgGenTag371En_t		,
		Ctrl2TxMsgGenTag372En		=>  Ctrl2TxMsgGenTag372En_t		,
		Ctrl2TxMsgGenTag373En		=>  Ctrl2TxMsgGenTag373En_t		,
		Ctrl2TxMsgGenTag58En		=>  Ctrl2TxMsgGenTag58En_t		,

		Ctrl2TxMrketData0			=>  Ctrl2TxMrketData0_t			,
		Ctrl2TxMrketData1			=>  Ctrl2TxMrketData1_t			,
		Ctrl2TxMrketData2			=>  Ctrl2TxMrketData2_t			,
		Ctrl2TxMrketData3			=>  Ctrl2TxMrketData3_t			,
		Ctrl2TxMrketData4			=>  Ctrl2TxMrketData4_t			,
		Ctrl2TxMrketDataEn			=>  Ctrl2TxMrketDataEn_t		,	
		
		Tx2CtrlMrketVal				=>  Tx2CtrlMrketVal_t			,	
		Tx2CtrlMrketSymbol0			=>  Tx2CtrlMrketSymbol0_t		,	
		Tx2CtrlMrketSecurityID0		=>  Tx2CtrlMrketSecurityID0_t	,	
		Tx2CtrlMrketSymbol1			=>  Tx2CtrlMrketSymbol1_t		,	
		Tx2CtrlMrketSecurityID1     =>  Tx2CtrlMrketSecurityID1_t   ,  
		Tx2CtrlMrketSymbol2			=>  Tx2CtrlMrketSymbol2_t		,	
		Tx2CtrlMrketSecurityID2     =>  Tx2CtrlMrketSecurityID2_t   ,  
		Tx2CtrlMrketSymbol3			=>  Tx2CtrlMrketSymbol3_t		,	
		Tx2CtrlMrketSecurityID3     =>  Tx2CtrlMrketSecurityID3_t   ,  
		Tx2CtrlMrketSymbol4			=>  Tx2CtrlMrketSymbol4_t		,	
		Tx2CtrlMrketSecurityID4     =>  Tx2CtrlMrketSecurityID4_t   ,  

		Ctrl2RxTOEConn				=>  Ctrl2RxTOEConn_t			,	
		Ctrl2RxExpSeqNum			=>  Ctrl2RxExpSeqNum_t			,
		Ctrl2RxSecValid				=>  Ctrl2RxSecValid_t			,	
		Ctrl2RxSecSymbol0			=>  Ctrl2RxSecSymbol0_t			,
		Ctrl2RxSecSymbol1			=>  Ctrl2RxSecSymbol1_t			,
		Ctrl2RxSecSymbol2			=>  Ctrl2RxSecSymbol2_t			,
		Ctrl2RxSecSymbol3			=>  Ctrl2RxSecSymbol3_t			,
		Ctrl2RxSecSymbol4			=>  Ctrl2RxSecSymbol4_t			,
		Ctrl2RxSecId0				=>  Ctrl2RxSecId0_t				,
		Ctrl2RxSecId1				=>  Ctrl2RxSecId1_t				,
		Ctrl2RxSecId2				=>  Ctrl2RxSecId2_t				,
		Ctrl2RxSecId3				=>  Ctrl2RxSecId3_t				,
		Ctrl2RxSecId4				=>  Ctrl2RxSecId4_t				,

		Rx2CtrlSeqNum				=>  Rx2CtrlSeqNum_t				,
		Rx2CtrlMsgTypeVal			=>  Rx2CtrlMsgTypeVal_t			,
		Rx2CtrlSeqNumError			=>  Rx2CtrlSeqNumError_t		,	
		Rx2CtrlPossDupFlag			=>  Rx2CtrlPossDupFlag_t		,	
		Rx2CtrlMsgTimeYear			=>  Rx2CtrlMsgTimeYear_t		,	
		Rx2CtrlMsgTimeMonth			=>  Rx2CtrlMsgTimeMonth_t		,	
		Rx2CtrlMsgTimeDay			=>  Rx2CtrlMsgTimeDay_t			,
		Rx2CtrlMsgTimeHour			=>  Rx2CtrlMsgTimeHour_t		,	
		Rx2CtrlMsgTimeMin			=>  Rx2CtrlMsgTimeMin_t			,
		Rx2CtrlMsgTimeSec			=>  Rx2CtrlMsgTimeSec_t			,
		Rx2CtrlMsgTimeSecNegExp		=>  Rx2CtrlMsgTimeSecNegExp_t	,	
		Rx2CtrlTagErrorFlag			=>  Rx2CtrlTagErrorFlag_t		,	
		Rx2CtrlErrorTagLatch		=>  Rx2CtrlErrorTagLatch_t		,
		Rx2CtrlErrorTagLen			=>  Rx2CtrlErrorTagLen_t		,	
		Rx2CtrlBodyLenError			=>  Rx2CtrlBodyLenError_t		,	
		Rx2CtrlCsumError			=>  Rx2CtrlCsumError_t			,
		Rx2CtrlEncryptMetError		=>  Rx2CtrlEncryptMetError_t	,	
		Rx2CtrlAppVerIdError		=>  Rx2CtrlAppVerIdError_t		,
		Rx2CtrlHeartBtInt			=>  Rx2CtrlHeartBtInt_t			,
		Rx2CtrlResetSeqNumFlag		=>  Rx2CtrlResetSeqNumFlag_t	,	
		Rx2CtrlTestReqId			=>  Rx2CtrlTestReqId_t			,
		Rx2CtrlTestReqIdLen			=>  Rx2CtrlTestReqIdLen_t		,	
		Rx2CtrlTestReqIdVal			=>	Rx2CtrlTestReqIdVal_t		,
		Rx2CtrlBeginSeqNum			=>  Rx2CtrlBeginSeqNum_t		,	
		Rx2CtrlEndSeqNum			=>  Rx2CtrlEndSeqNum_t			,
		Rx2CtrlRefSeqNum			=>  Rx2CtrlRefSeqNum_t			,
		Rx2CtrlRefTagId				=>  Rx2CtrlRefTagId_t			,	
		Rx2CtrlRefMsgType			=>  Rx2CtrlRefMsgType_t			,
		Rx2CtrlRejectReason			=>  Rx2CtrlRejectReason_t		,	
		Rx2CtrlGapFillFlag			=>  Rx2CtrlGapFillFlag_t		,	
		Rx2CtrlNewSeqNum			=>  Rx2CtrlNewSeqNum_t			,
		Rx2CtrlMDReqId				=>  Rx2CtrlMDReqId_t			,	
		Rx2CtrlMDReqIdLen			=>  Rx2CtrlMDReqIdLen_t			
	);
	
-- Signal assignment from Testbench to FixCtrl with delay time
	UserFixConn_t				<= UserFixConn						after 1 ns;
    UserFixDisConn_t			<= UserFixDisConn					after 1 ns;
	UserFixRTCTime_t			<= UserFixRTCTime					after 1 ns;
	UserFixSenderCompID_t		<= UserFixSenderCompID				after 1 ns;
	UserFixTargetCompID_t		<= UserFixTargetCompID				after 1 ns;
	UserFixUsername_t			<= UserFixUsername					after 1 ns;
	UserFixPassword_t       	<= UserFixPassword             		after 1 ns;
	UserFixSenderCompIDLen_t	<= UserFixSenderCompIDLen			after 1 ns;
	UserFixTargetCompIDLen_t	<= UserFixTargetCompIDLen			after 1 ns;
	UserFixUsernameLen_t		<= UserFixUsernameLen				after 1 ns;
	UserFixPasswordLen_t		<= UserFixPasswordLen	        	after 1 ns;
	UserFixMrketData0_t		    <= UserFixMrketData0				after 1 ns;
	UserFixMrketData1_t		    <= UserFixMrketData1			    after 1 ns;
	UserFixMrketData2_t		    <= UserFixMrketData2			    after 1 ns;
	UserFixMrketData3_t		    <= UserFixMrketData3			    after 1 ns;
	UserFixMrketData4_t		    <= UserFixMrketData4			    after 1 ns;
	UserFixNoRelatedSym_t	    <= UserFixNoRelatedSym			    after 1 ns;
	UserFixMDEntryTypes_t	    <= UserFixMDEntryTypes			    after 1 ns;
	UserFixNoMDEntryTypes_t	    <= UserFixNoMDEntryTypes		    after 1 ns;
	TOE2FixStatus_t		        <= TOE2FixStatus		            after 1 ns;
	TOE2FixPSHFlagset_t	        <= TOE2FixPSHFlagset	            after 1 ns;
	TOE2FixFINFlagset_t         <= TOE2FixFINFlagset 	            after 1 ns;
	TOE2FixRSTFlagset_t	        <= TOE2FixRSTFlagset	            after 1 ns;
	Tx2CtrlBusy_t               <= Tx2CtrlBusy                      after 1 ns;
	Tx2CtrlMrketVal_t			<= Tx2CtrlMrketVal				    after 1 ns;
	Tx2CtrlMrketSymbol0_t		<= Tx2CtrlMrketSymbol0			    after 1 ns;
	Tx2CtrlMrketSecurityID0_t	<= Tx2CtrlMrketSecurityID0		    after 1 ns;
	Tx2CtrlMrketSymbol1_t		<= Tx2CtrlMrketSymbol1			    after 1 ns;
	Tx2CtrlMrketSecurityID1_t   <= Tx2CtrlMrketSecurityID1          after 1 ns;
	Tx2CtrlMrketSymbol2_t		<= Tx2CtrlMrketSymbol2			    after 1 ns;
	Tx2CtrlMrketSecurityID2_t   <= Tx2CtrlMrketSecurityID2          after 1 ns;
	Tx2CtrlMrketSymbol3_t		<= Tx2CtrlMrketSymbol3			    after 1 ns;
	Tx2CtrlMrketSecurityID3_t   <= Tx2CtrlMrketSecurityID3          after 1 ns;
	Tx2CtrlMrketSymbol4_t		<= Tx2CtrlMrketSymbol4			    after 1 ns;
	Tx2CtrlMrketSecurityID4_t   <= Tx2CtrlMrketSecurityID4          after 1 ns;
	
-- Signal assignment from FixCtrl to Testbench with delay time
	UserFixOperate				<= UserFixOperate_t					after 1 ns;
	UserFixError 	            <= UserFixError_t 	  			  	after 1 ns;
	Fix2TOEConnectReq			<= Fix2TOEConnectReq_t				after 1 ns;
	Fix2TOETerminateReq		    <= Fix2TOETerminateReq_t	        after 1 ns;
	Fix2TOERxDataReq	        <= Fix2TOERxDataReq_t		        after 1 ns;
	Ctrl2TxReq					<= Ctrl2TxReq_t		                after 1 ns;
	Ctrl2TxPossDupEn 	        <= Ctrl2TxPossDupEn_t 	            after 1 ns;
	Ctrl2TxReplyTest 	        <= Ctrl2TxReplyTest_t 	            after 1 ns;
	Ctrl2TxMsgType				<= Ctrl2TxMsgType_t			        after 1 ns;
	Ctrl2TxMsgSeqNum		    <= Ctrl2TxMsgSeqNum_t			    after 1 ns;
	Ctrl2TxMsgSendTime		    <= Ctrl2TxMsgSendTime_t		        after 1 ns;
	Ctrl2TxMsgBeginString	    <= Ctrl2TxMsgBeginString_t		    after 1 ns;
	Ctrl2TxMsgSenderCompID	    <= Ctrl2TxMsgSenderCompID_t	        after 1 ns;
	Ctrl2TxMsgTargetCompID	    <= Ctrl2TxMsgTargetCompID_t	        after 1 ns;
	Ctrl2TxMsgBeginStringLen    <= Ctrl2TxMsgBeginStringLen_t       after 1 ns;
	Ctrl2TxMsgSenderCompIDLen   <= Ctrl2TxMsgSenderCompIDLen_t	    after 1 ns;
	Ctrl2TxMsgTargetCompIDLen   <= Ctrl2TxMsgTargetCompIDLen_t	    after 1 ns;
	Ctrl2TxMsgGenTag98		    <= Ctrl2TxMsgGenTag98_t	            after 1 ns;
	Ctrl2TxMsgGenTag108		    <= Ctrl2TxMsgGenTag108_t	        after 1 ns;
	Ctrl2TxMsgGenTag141		    <= Ctrl2TxMsgGenTag141_t	        after 1 ns;
	Ctrl2TxMsgGenTag553		    <= Ctrl2TxMsgGenTag553_t	        after 1 ns;
	Ctrl2TxMsgGenTag554		    <= Ctrl2TxMsgGenTag554_t	        after 1 ns;
	Ctrl2TxMsgGenTag1137	    <= Ctrl2TxMsgGenTag1137_t	        after 1 ns;
	Ctrl2TxMsgGenTag553Len	    <= Ctrl2TxMsgGenTag553Len_t         after 1 ns;
	Ctrl2TxMsgGenTag554Len	    <= Ctrl2TxMsgGenTag554Len_t         after 1 ns;
	Ctrl2TxMsgGenTag112		    <= Ctrl2TxMsgGenTag112_t	        after 1 ns;
	Ctrl2TxMsgGenTag112Len      <= Ctrl2TxMsgGenTag112Len_t         after 1 ns;
	Ctrl2TxMsgGenTag262	        <= Ctrl2TxMsgGenTag262_t	        after 1 ns;
	Ctrl2TxMsgGenTag263	        <= Ctrl2TxMsgGenTag263_t	        after 1 ns;
	Ctrl2TxMsgGenTag264	        <= Ctrl2TxMsgGenTag264_t	        after 1 ns;
	Ctrl2TxMsgGenTag265	        <= Ctrl2TxMsgGenTag265_t	        after 1 ns;
	Ctrl2TxMsgGenTag266	        <= Ctrl2TxMsgGenTag266_t	        after 1 ns;
	Ctrl2TxMsgGenTag146	        <= Ctrl2TxMsgGenTag146_t	        after 1 ns;
	Ctrl2TxMsgGenTag22	        <= Ctrl2TxMsgGenTag22_t	            after 1 ns;
	Ctrl2TxMsgGenTag267	        <= Ctrl2TxMsgGenTag267_t	        after 1 ns;
	Ctrl2TxMsgGenTag269	        <= Ctrl2TxMsgGenTag269_t	        after 1 ns;
	Ctrl2TxMsgGenTag7           <= Ctrl2TxMsgGenTag7_t	            after 1 ns;
	Ctrl2TxMsgGenTag16          <= Ctrl2TxMsgGenTag16_t             after 1 ns;
	Ctrl2TxMsgGenTag123	        <= Ctrl2TxMsgGenTag123_t	        after 1 ns;
	Ctrl2TxMsgGenTag36	        <= Ctrl2TxMsgGenTag36_t	            after 1 ns;
	Ctrl2TxMsgGenTag45		    <= Ctrl2TxMsgGenTag45_t	            after 1 ns;
	Ctrl2TxMsgGenTag371		    <= Ctrl2TxMsgGenTag371_t	        after 1 ns;
	Ctrl2TxMsgGenTag372		    <= Ctrl2TxMsgGenTag372_t	        after 1 ns;
	Ctrl2TxMsgGenTag373		    <= Ctrl2TxMsgGenTag373_t	        after 1 ns;
	Ctrl2TxMsgGenTag58		    <= Ctrl2TxMsgGenTag58_t	            after 1 ns;
	Ctrl2TxMsgGenTag371Len	    <= Ctrl2TxMsgGenTag371Len_t         after 1 ns;
	Ctrl2TxMsgGenTag373Len	    <= Ctrl2TxMsgGenTag373Len_t         after 1 ns;
	Ctrl2TxMsgGenTag58Len	    <= Ctrl2TxMsgGenTag58Len_t	        after 1 ns;
	Ctrl2TxMsgGenTag371En	    <= Ctrl2TxMsgGenTag371En_t	        after 1 ns;
	Ctrl2TxMsgGenTag372En	    <= Ctrl2TxMsgGenTag372En_t	        after 1 ns;
	Ctrl2TxMsgGenTag373En	    <= Ctrl2TxMsgGenTag373En_t	        after 1 ns;
	Ctrl2TxMsgGenTag58En	    <= Ctrl2TxMsgGenTag58En_t	        after 1 ns;
	Ctrl2TxMrketData0	        <= Ctrl2TxMrketData0_t		        after 1 ns;
	Ctrl2TxMrketData1	        <= Ctrl2TxMrketData1_t		        after 1 ns;
	Ctrl2TxMrketData2	        <= Ctrl2TxMrketData2_t		        after 1 ns;
	Ctrl2TxMrketData3	        <= Ctrl2TxMrketData3_t		        after 1 ns;
	Ctrl2TxMrketData4	        <= Ctrl2TxMrketData4_t		        after 1 ns;
	Ctrl2TxMrketDataEn	        <= Ctrl2TxMrketDataEn_t	            after 1 ns;
	Ctrl2RxTOEConn		        <= Ctrl2RxTOEConn_t		            after 1 ns;
	Ctrl2RxExpSeqNum	        <= Ctrl2RxExpSeqNum_t		        after 1 ns;
	Ctrl2RxSecValid		        <= Ctrl2RxSecValid_t		        after 1 ns;
	Ctrl2RxSecSymbol0	        <= Ctrl2RxSecSymbol0_t		        after 1 ns;
	Ctrl2RxSecSymbol1	        <= Ctrl2RxSecSymbol1_t		        after 1 ns;
	Ctrl2RxSecSymbol2	        <= Ctrl2RxSecSymbol2_t		        after 1 ns;
	Ctrl2RxSecSymbol3	        <= Ctrl2RxSecSymbol3_t		        after 1 ns;
	Ctrl2RxSecSymbol4	        <= Ctrl2RxSecSymbol4_t		        after 1 ns;
	Ctrl2RxSecId0		        <= Ctrl2RxSecId0_t			        after 1 ns;
	Ctrl2RxSecId1		        <= Ctrl2RxSecId1_t			        after 1 ns;
	Ctrl2RxSecId2		        <= Ctrl2RxSecId2_t			        after 1 ns;
	Ctrl2RxSecId3		        <= Ctrl2RxSecId3_t			        after 1 ns;
	Ctrl2RxSecId4		        <= Ctrl2RxSecId4_t			        after 1 ns;
	

-- Sendtime mapping 
	
	UserFixRTCTime(50 downto 0)	<= RTCTimeYear&RTCTimeMonth&RTCTimeDay&RTCTimeHour&RTCTimeMin&RTCTimeMilliSec;
	

-- Signal assignment from Package and Testbench to FixCtrl with delay time
	Rx2CtrlSeqNum_t				<= RxDataRec.Rx2CtrlSeqNum			after 1 ns;
    Rx2CtrlMsgTypeVal_t			<= RxDataRec.Rx2CtrlMsgTypeVal		after 1 ns;    
    Rx2CtrlSeqNumError_t		<= RxDataRec.Rx2CtrlSeqNumError		after 1 ns;    
    Rx2CtrlPossDupFlag_t		<= RxDataRec.Rx2CtrlPossDupFlag		after 1 ns;    
    Rx2CtrlMsgTimeYear_t		<= RxDataRec.Rx2CtrlMsgTimeYear		after 1 ns;    
    Rx2CtrlMsgTimeMonth_t		<= RxDataRec.Rx2CtrlMsgTimeMonth	after 1 ns;	    
    Rx2CtrlMsgTimeDay_t			<= RxDataRec.Rx2CtrlMsgTimeDay		after 1 ns;    
    Rx2CtrlMsgTimeHour_t		<= RxDataRec.Rx2CtrlMsgTimeHour		after 1 ns;    
    Rx2CtrlMsgTimeMin_t			<= RxDataRec.Rx2CtrlMsgTimeMin		after 1 ns;    
    Rx2CtrlMsgTimeSec_t			<= RxDataRec.Rx2CtrlMsgTimeSec		after 1 ns;    
    Rx2CtrlMsgTimeSecNegExp_t	<= RxDataRec.Rx2CtrlMsgTimeSecNegExp after 1 ns;	    
    Rx2CtrlTagErrorFlag_t		<= RxDataRec.Rx2CtrlTagErrorFlag	after 1 ns;	    
    Rx2CtrlErrorTagLatch_t		<= RxDataRec.Rx2CtrlErrorTagLatch	after 1 ns;        
    Rx2CtrlErrorTagLen_t		<= RxDataRec.Rx2CtrlErrorTagLen		after 1 ns;    
    Rx2CtrlBodyLenError_t		<= RxDataRec.Rx2CtrlBodyLenError	after 1 ns;	    
    Rx2CtrlCsumError_t			<= RxDataRec.Rx2CtrlCsumError		after 1 ns;        
    Rx2CtrlEncryptMetError_t	<= RxDataRec.Rx2CtrlEncryptMetError	after 1 ns;    
    Rx2CtrlAppVerIdError_t		<= RxDataRec.Rx2CtrlAppVerIdError	after 1 ns;        
    Rx2CtrlHeartBtInt_t			<= RxDataRec.Rx2CtrlHeartBtInt		after 1 ns;    
    Rx2CtrlResetSeqNumFlag_t	<= RxDataRec.Rx2CtrlResetSeqNumFlag	after 1 ns;    
    Rx2CtrlTestReqId_t			<= RxDataRec.Rx2CtrlTestReqId		after 1 ns;        
    Rx2CtrlTestReqIdLen_t		<= RxDataRec.Rx2CtrlTestReqIdLen	after 1 ns;	    
    Rx2CtrlTestReqIdVal_t		<= RxDataRec.Rx2CtrlTestReqIdVal	after 1 ns;		
    Rx2CtrlBeginSeqNum_t		<= RxDataRec.Rx2CtrlBeginSeqNum		after 1 ns;    
    Rx2CtrlEndSeqNum_t			<= RxDataRec.Rx2CtrlEndSeqNum		after 1 ns;        
    Rx2CtrlRefSeqNum_t			<= RxDataRec.Rx2CtrlRefSeqNum		after 1 ns;        
    Rx2CtrlRefTagId_t			<= RxDataRec.Rx2CtrlRefTagId		after 1 ns;	    
    Rx2CtrlRefMsgType_t			<= RxDataRec.Rx2CtrlRefMsgType		after 1 ns;    
    Rx2CtrlRejectReason_t		<= RxDataRec.Rx2CtrlRejectReason	after 1 ns;	    
    Rx2CtrlGapFillFlag_t		<= RxDataRec.Rx2CtrlGapFillFlag		after 1 ns;    
    Rx2CtrlNewSeqNum_t			<= RxDataRec.Rx2CtrlNewSeqNum	    after 1 ns;    
    Rx2CtrlMDReqId_t			<= RxDataRec.Rx2CtrlMDReqId			after 1 ns;    
    Rx2CtrlMDReqIdLen_t			<= RxDataRec.Rx2CtrlMDReqIdLen		after 1 ns;    

End Architecture HTWTestBench;