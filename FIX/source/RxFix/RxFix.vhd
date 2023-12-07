----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		RxFix.vhd
-- Title		
--
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         

-- Version      1.00
-- Author       K.Norawit
-- Date         2021/04/02
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--	Comment below is FYI note
--	1. This RxFix module maps RxHdDec and RxMsgDec togather
-- 	2. This module support only some messages in FIXT1.1 and FIX5.0SP2 including
--	   Logon, Logout, Sequence Reset, Resent Request, Reject, HeartBeat, TestRequest,
--     Market data Request and Market data snapshot full refresh. 
--	3. I/F of this module consists of 
--		3.1) Input with RxTCPIP	: FIX messages are transferred from RxTCPIP into RxFix.
--		3.2) Output to User		: FIX Market data message are decoded in RxFix module, 
--								  then decoded data is transferred to User in signal form.
--		3.3) Control unit		: FIX message header is extracts and decodes (by RxFix), then
--								  the header data is send to control unit in order to
--								: operate the FIX Session.	
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxFix Is
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
End Entity RxFix;

Architecture rt1 Of RxFix Is
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cUserSenderId	: std_logic_vector( 103 downto 0 )	:= x"00_0000_0000_0000_0000_0053_4554";	-- '0 0000 0000 0SET'
	constant cUserTargetId	: std_logic_vector( 103 downto 0 )	:= x"30_3031_355f_4649_585f_4d44_3530";	-- '0 015_ FIX_ MD50'
	
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component RxHdDec Is
	Port 
	(	
		RstB				: in	std_logic;
		Clk					: in	std_logic; 
		UserValid 			: in	std_logic;
		UserSenderId		: in 	std_logic_vector( 103 downto 0 );
		UserTargetId		: in 	std_logic_vector( 103 downto 0 );
		FixSOP				: in	std_logic;
		FixValid			: in	std_logic;
		FixEOP				: in	std_logic;
		FixData				: in	std_logic_vector( 7 downto 0 );
		TCPConnect			: in	std_logic;
		ExpSeqNum			: in 	std_logic_vector( 31 downto 0 );
		MsgDecCtrlFlag 		: in	std_logic_vector( 24 downto 0 );
		EncryptMetError		: in	std_logic;
		AppVerIdError		: in	std_logic;
		ResetSeqNumFlag		: in	std_logic;
		MsgVal2User			: out 	std_logic_vector( 7 downto 0 );
		TypePermit			: out	std_logic_vector( 7 downto 0 );	
		MsgEnd				: out 	std_logic;
		FieldLenCnt			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
		MsgTypeVal			: out 	std_logic_vector( 7 downto 0 );	
		BLenError			: out 	std_logic;
		CSumError			: out 	std_logic;
		TagError			: out 	std_logic;
		ErrorTagLatch		: out	std_logic_vector( 31 downto 0 );
		ErrorTagLen			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
		SeqNumError			: out	std_logic;
		SeqNum				: out	std_logic_vector( 31 downto 0 );		
		PossDupFlag			: out	std_logic;
		TimeYear			: out 	std_logic_vector( 10 downto 0 );	
		TimeMonth			: out 	std_logic_vector( 3 downto 0 );
		TimeDay				: out 	std_logic_vector( 4 downto 0 );
		TimeHour			: out 	std_logic_vector( 4 downto 0 );
		TimeMin				: out 	std_logic_vector( 5 downto 0 );
		TimeSec				: out 	std_logic_vector( 15 downto 0 );
		TimeSecNegExp		: out 	std_logic_vector( 1 downto 0 )
		
	);
	End Component RxHdDec;
	
	Component RxMsgDec Is
	Port 
	(	
		RstB				: in	std_logic;
		Clk					: in	std_logic;
		FixSOP				: in	std_logic;
		FixValid			: in	std_logic;
		FixEOP				: in	std_logic;
		FixData				: in	std_logic_vector( 7 downto 0 );
		TCPConnect			: in	std_logic;
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
		TypePermit			: in	std_logic_vector( 7 downto 0 );	
		MsgEnd				: in	std_logic;
		FieldLenCnt			: in	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
		MsgDecCtrlFlag 		: out	std_logic_vector( 24 downto 0 );
		EncryptMetError		: out	std_logic;
		AppVerIdError		: out	std_logic;
		HeartBtInt			: out 	std_logic_vector( 15 downto 0 );
		ResetSeqNumFlag		: out	std_logic;
		TestReqIdVal		: out 	std_logic;							-- update 25/02/2021
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
		
		SecIndic			: out 	std_logic_vector( 4 downto 0 );
		EntriesVal			: out 	std_logic_vector( 1 downto 0 );
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
		NoEntriesError		: out	std_logic
		
	);
	End Component RxMsgDec;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------	
	
	-- HeDec to MsgDec
	signal	rTypePermit	 		: std_logic_vector( 7 downto 0 );
	signal	rMsgEnd	   		 	: std_logic;
	signal	rFieldLenCnt		: std_logic_vector( 5 downto 0 );
	
	-- MsgDec to HdDec
	signal	rMsgDecCtrlFlag	 	: std_logic_vector( 24 downto 0 );
	signal	rEncryptMetError	: std_logic;
	signal	rAppVerIdError	    : std_logic;
	signal	rRstSeqNumFlag		: std_logic;
	
	
Begin	

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	ResetSeqNumFlag		<= rRstSeqNumFlag;
	EncryptMetError		<= rEncryptMetError;
	AppVerIdError		<= rAppVerIdError;
	
----------------------------------------------------------------------------------
-- Combination
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Port mappling
----------------------------------------------------------------------------------	
	
	u_RxHdDec : RxHdDec
	Port map
	(
		RstB			=> RstB				,
		Clk				=> Clk              ,
		UserValid 		=> UserValid 	 	,	
		UserSenderId	=> UserSenderId  	,   
	    UserTargetId	=> UserTargetId  	,   
        FixSOP			=> FixSOP			,	
        FixValid		=> FixValid	        ,
        FixEOP			=> FixEOP		    ,
        FixData			=> FixData		    ,
        TCPConnect		=> TCPConnect	    ,
        ExpSeqNum		=> ExpSeqNum	    ,
        MsgDecCtrlFlag 	=> rMsgDecCtrlFlag  ,
        EncryptMetError	=> rEncryptMetError ,
        AppVerIdError	=> rAppVerIdError   ,
		ResetSeqNumFlag	=> rRstSeqNumFlag	,
        MsgVal2User		=> MsgVal2User      ,
        TypePermit		=> rTypePermit      ,
        MsgEnd			=> rMsgEnd          ,
		FieldLenCnt		=> rFieldLenCnt		,	-- 21/02/2021
        MsgTypeVal		=> MsgTypeVal		,
        BLenError		=> BLenError		,
        CSumError		=> CSumError		,
        TagError		=> TagError		    ,
        ErrorTagLatch	=> ErrorTagLatch	,
		ErrorTagLen		=> ErrorTagLen		,	-- 21/02/2021
        SeqNumError		=> SeqNumError		,
        SeqNum			=> SeqNum			,
        PossDupFlag		=> PossDupFlag		,
        TimeYear		=> TimeYear		    ,
        TimeMonth		=> TimeMonth		,
        TimeDay			=> TimeDay			,
        TimeHour		=> TimeHour		    ,
        TimeMin			=> TimeMin			,
        TimeSec			=> TimeSec			,
        TimeSecNegExp	=> TimeSecNegExp

	);
	
	u_RxMsgDec : RxMsgDec
	Port map
	(
		RstB				=> RstB				,
		Clk					=> Clk              ,
		FixSOP				=> FixSOP		    ,
		FixValid			=> FixValid	        ,
		FixEOP				=> FixEOP		    ,
		FixData				=> FixData		    ,
		TCPConnect			=> TCPConnect	    ,
		SecValid			=> SecValid	        ,
		SecSymbol0			=> SecSymbol0	    ,
		SrcId0				=> SrcId0		    ,
		SecSymbol1			=> SecSymbol1	    ,
		SrcId1				=> SrcId1		    ,
		SecSymbol2			=> SecSymbol2	    ,
		SrcId2				=> SrcId2		    ,
		SecSymbol3			=> SecSymbol3	    ,
		SrcId3				=> SrcId3		    ,
		SecSymbol4			=> SecSymbol4	    ,
		SrcId4				=> SrcId4		    ,
		TypePermit			=> rTypePermit      ,
		MsgEnd				=> rMsgEnd          ,
		FieldLenCnt			=> rFieldLenCnt		,	--21/02/2021
		MsgDecCtrlFlag 		=> rMsgDecCtrlFlag  ,
		EncryptMetError		=> rEncryptMetError ,
		AppVerIdError		=> rAppVerIdError   ,
		HeartBtInt			=> HeartBtInt		,
		ResetSeqNumFlag		=> rRstSeqNumFlag	,
		TestReqIdVal		=> TestReqIdVal		,	--25/02/2021
		TestReqId			=> TestReqId		,
		TestReqIdLen		=> TestReqIdLen		,
		BeginSeqNum			=> BeginSeqNum		,
		EndSeqNum			=> EndSeqNum		,
		RefSeqNum			=> RefSeqNum		,
		RefTagId			=> RefTagId		    ,
		RefMsgType			=> RefMsgType		,
		RejectReason		=> RejectReason	    ,
		GapFillFlag			=> GapFillFlag		,
		NewSeqNum			=> NewSeqNum		,
		MDReqId				=> MDReqId			,
		MDReqIdLen			=> MDReqIdLen		,
		
		SecIndic			=> SecIndic			,
		EntriesVal			=> EntriesVal		,
		BidPx				=> BidPx			,
		BidPxNegExp			=> BidPxNegExp		,
		BidSize				=> BidSize			,
		BidTimeHour			=> BidTimeHour		,
		BidTimeMin      	=> BidTimeMin       ,
		BidTimeSec      	=> BidTimeSec       ,
		BidTimeSecNegExp	=> BidTimeSecNegExp ,
		OffPx				=> OffPx			,
		OffPxNegExp			=> OffPxNegExp		,
		OffSize				=> OffSize			,
		OffTimeHour			=> OffTimeHour		,
		OffTimeMin      	=> OffTimeMin       ,
		OffTimeSec      	=> OffTimeSec       ,
		OffTimeSecNegExp	=> OffTimeSecNegExp ,
		SpecialPxFlag		=> SpecialPxFlag	,
		NoEntriesError		=> NoEntriesError
		
	);
	
End Architecture rt1;