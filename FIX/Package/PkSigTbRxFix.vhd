----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkSigTbRxFix.vhd
-- Title        Signal and Record declaration for TbRxFix
-- 
-- Author       K. Norawit
-- Date         2021/20/02
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;
use work.PkTbFixGen.all;

Package PkSigTbRxFix Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	constant cLogOnGenLen		: integer range 0 to 65535 			:= 171;
	constant cTestReqGenLen		: integer range 0 to 65535 			:= 128;
	constant cEmptyGenLen		: integer range 0 to 65535 			:= 115;
	constant cResentReqLen		: integer range 0 to 65535 			:= 130;
	constant cRejectReqLen		: integer range 0 to 65535 			:= 159;
	constant cSeqRstLen			: integer range 0 to 65535 			:= 129;
	constant cSnapShot			: integer range 0 to 65535 			:= 264;
	
----------------------------------------------------------------------------------
-- Recored declaration
----------------------------------------------------------------------------------
	
	-- ** dont forget TestReqId	for Heartbeat and TestReq
	
	Type OutHdDecRecord is Record
		MsgTypeVal			: std_logic_vector( 7 downto 0 );	
		BLenError			: std_logic;
		CSumError			: std_logic;
		TagError			: std_logic;
		ErrorTagLatch		: std_logic_vector( 31 downto 0 );
		ErrorTagLen			: std_logic_vector( 5 downto 0 );
		SeqNumError			: std_logic;
		SeqNum				: std_logic_vector( 31 downto 0 );		
		PossDupFlag			: std_logic;
		TimeYear			: std_logic_vector( 10 downto 0 );	
		TimeMonth			: std_logic_vector( 3 downto 0 );
		TimeDay				: std_logic_vector( 4 downto 0 );
		TimeHour			: std_logic_vector( 4 downto 0 );
		TimeMin				: std_logic_vector( 5 downto 0 );
		TimeSec				: std_logic_vector( 15 downto 0 );
		TimeSecNegExp		: std_logic_vector( 1 downto 0 );
		MsgVal2User			: std_logic_vector( 7 downto 0 );
	End Record OutHdDecRecord;
	
	Type OutLogOnRecord is Record
		HeartBtInt			: std_logic_vector( 15 downto 0 );
		ResetSeqNumFlag		: std_logic;
		EncryptMetError		: std_logic;
		AppVerIdError		: std_logic;
	End Record OutLogOnRecord;
	
	Type OutTestReqIdRecord is Record
		TestReqIdVal		: std_logic;
		TestReqId			: std_logic_vector( 63 downto 0 );
		TestReqIdLen		: std_logic_vector( 5 downto 0 );
	End Record OutTestReqIdRecord;
	
	Type OutResentReqRecord is Record
		BeginSeqNum			: std_logic_vector( 31 downto 0 );
		EndSeqNum			: std_logic_vector( 31 downto 0 );
	End Record OutResentReqRecord;

	Type OutRejectRecord is Record
		RefSeqNum			: std_logic_vector( 31 downto 0 );
		RefTagId			: std_logic_vector( 15 downto 0 );
		RefMsgType			: std_logic_vector( 7 downto 0 );
		RejectReason		: std_logic_vector( 2 downto 0 );
	End Record OutRejectRecord;
	
	Type OutSeqRstRecord is Record
		GapFillFlag			: std_logic;
		NewSeqNum			: std_logic_vector( 31 downto 0 );
	End Record OutSeqRstRecord;
		
	Type OutSnapShotRecord is Record
		MDReqId				: std_logic_vector( 15 downto 0 );
		MDReqIdLen			: std_logic_vector( 5 downto 0 );
		SecIndic			: std_logic_vector( 4 downto 0 );
		EntriesVal			: std_logic_vector( 1 downto 0 );
		BidPx				: std_logic_vector( 15 downto 0 );
		BidPxNegExp			: std_logic_vector( 1 downto 0 );
		BidSize				: std_logic_vector( 31 downto 0 );
		BidTimeHour			: std_logic_vector( 7 downto 0 );
		BidTimeMin          : std_logic_vector( 7 downto 0 );
		BidTimeSec          : std_logic_vector( 15 downto 0 );
		BidTimeSecNegExp    : std_logic_vector( 1 downto 0 );
		OffPx				: std_logic_vector( 15 downto 0 );
		OffPxNegExp			: std_logic_vector( 1 downto 0 );
		OffSize				: std_logic_vector( 31 downto 0 );
		OffTimeHour			: std_logic_vector( 7 downto 0 );
		OffTimeMin          : std_logic_vector( 7 downto 0 );
		OffTimeSec          : std_logic_vector( 15 downto 0 );
		OffTimeSecNegExp    : std_logic_vector( 1 downto 0 );
		SpecialPxFlag		: std_logic_vector( 1 downto 0 );
		NoEntriesError		: std_logic;
	End Record OutSnapShotRecord;
	
----------------------------------------------------------------------------------
-- Signal declaration																
----------------------------------------------------------------------------------
	
	signal	TM				: integer	range 0 to 65535;
	signal	TT				: integer	range 0 to 65535;
	
	signal	RstB			: std_logic;
	signal	Clk				: std_logic;
	
	signal rTest1			: std_logic_vector( 7 downto 0 );
	signal rTest2			: std_logic_vector( 7 downto 0 );
	
	-- Fix message gen	(info of these records in file: PkTbFixGen)
	signal	GenHdRecIn				: HdRecord;
	signal	GenLogonRecIn			: LogonRecord;
	signal	GenResentReqRecIn		: ResentReqRecord;
	signal	GenRejectRecIn			: RejectRecord;
	signal	GenSeqRstRecIn			: SeqRstRecord;
	signal	GenSnapShotFullRecIn	: SnapShotFullRecord;
	signal	GenCsum					: std_logic_vector( 23 downto 0 );
	signal	GenTestReqID			: std_logic_vector( 63 downto 0 );
	
	-- Verify signal
	signal  ExpHdDecRecIn		: OutHdDecRecord;
	signal  ExpLogOnRecIn		: OutLogOnRecord;
	signal	ExpTestReqIdRecIn	: OutTestReqIdRecord;
	signal  ExpResentReqRecIn	: OutResentReqRecord;
	signal  ExpRejectRecIn		: OutRejectRecord;
	signal  ExpSeqRstRecIn		: OutSeqRstRecord;
	signal  ExpSnapShotRecIn	: OutSnapShotRecord;
	
	-- Output
	signal  OutHdDecRecIn		: OutHdDecRecord;
	signal  OutLogOnRecIn		: OutLogOnRecord;
	signal	OutTestReqIdRecIn	: OutTestReqIdRecord;
	signal  OutResentReqRecIn	: OutResentReqRecord;
	signal  OutRejectRecIn		: OutRejectRecord;
	signal  OutSeqRstRecIn		: OutSeqRstRecord;
	signal  OutSnapShotRecIn	: OutSnapShotRecord;
	
	-- Input
	signal	UserValid 			: std_logic;						-- no delay
	signal	UserSenderId		: std_logic_vector( 103 downto 0 ); -- no delay
	signal	UserTargetId		: std_logic_vector( 103 downto 0 ); -- no delay
	signal	FixSOP				: std_logic;
	signal	FixValid			: std_logic;
	signal	FixEOP				: std_logic;
	signal	FixData				: std_logic_vector( 7 downto 0 );
	signal	TCPConnect			: std_logic;
	signal	ExpSeqNum			: std_logic_vector( 31 downto 0 );
	signal	SecValid			: std_logic_vector( 4 downto 0 );
	signal	SecSymbol0			: std_logic_vector( 47 downto 0 );
	signal	SrcId0				: std_logic_vector( 15 downto 0 );
	signal	SecSymbol1			: std_logic_vector( 47 downto 0 );
	signal	SrcId1				: std_logic_vector( 15 downto 0 );
	signal	SecSymbol2			: std_logic_vector( 47 downto 0 );
	signal	SrcId2				: std_logic_vector( 15 downto 0 );
	signal	SecSymbol3			: std_logic_vector( 47 downto 0 );
	signal	SrcId3				: std_logic_vector( 15 downto 0 );
	signal	SecSymbol4			: std_logic_vector( 47 downto 0 );
	signal	SrcId4				: std_logic_vector( 15 downto 0 );
	
	-- intermediate signal for 1 ns delay
	signal	FixSOP_t			: std_logic;
	signal	FixValid_t			: std_logic;
	signal	FixEOP_t			: std_logic;
	signal	FixData_t			: std_logic_vector( 7 downto 0 );
	signal	TCPConnect_t		: std_logic;
	signal	ExpSeqNum_t			: std_logic_vector( 31 downto 0 );
	signal	SecValid_t			: std_logic_vector( 4 downto 0 );
	signal	SecSymbol0_t		: std_logic_vector( 47 downto 0 );
	signal	SrcId0_t			: std_logic_vector( 15 downto 0 );
	signal	SecSymbol1_t		: std_logic_vector( 47 downto 0 );
	signal	SrcId1_t			: std_logic_vector( 15 downto 0 );
	signal	SecSymbol2_t		: std_logic_vector( 47 downto 0 );
	signal	SrcId2_t			: std_logic_vector( 15 downto 0 );
	signal	SecSymbol3_t		: std_logic_vector( 47 downto 0 );
	signal	SrcId3_t			: std_logic_vector( 15 downto 0 );
	signal	SecSymbol4_t		: std_logic_vector( 47 downto 0 );
	signal	SrcId4_t			: std_logic_vector( 15 downto 0 );
	signal	MsgTypeVal_t		: std_logic_vector( 7 downto 0 );	
	signal	BLenError_t			: std_logic;
	signal	CSumError_t			: std_logic;
	signal	TagError_t			: std_logic;
	signal	ErrorTagLatch_t		: std_logic_vector( 31 downto 0 );
	signal	ErrorTagLen_t		: std_logic_vector( 5 downto 0 );
	signal	SeqNumError_t		: std_logic;
	signal	SeqNum_t			: std_logic_vector( 31 downto 0 );		
	signal	PossDupFlag_t		: std_logic;
	signal	TimeYear_t			: std_logic_vector( 10 downto 0 );	
	signal	TimeMonth_t			: std_logic_vector( 3 downto 0 );
	signal	TimeDay_t			: std_logic_vector( 4 downto 0 );
	signal	TimeHour_t			: std_logic_vector( 4 downto 0 );
	signal	TimeMin_t			: std_logic_vector( 5 downto 0 );
	signal	TimeSec_t			: std_logic_vector( 15 downto 0 );
	signal	TimeSecNegExp_t		: std_logic_vector( 1 downto 0 );
	
	signal	HeartBtInt_t		: std_logic_vector( 15 downto 0 );
	signal	ResetSeqNumFlag_t	: std_logic;
	signal	AppVerIdError_t		: std_logic;
	signal	EncryptMetError_t	: std_logic;
	signal	TestReqIdVal_t		: std_logic;
	signal	TestReqId_t			: std_logic_vector( 63 downto 0 );
	signal	TestReqIdLen_t		: std_logic_vector( 5 downto 0 );
	signal	BeginSeqNum_t		: std_logic_vector( 31 downto 0 );
	signal	EndSeqNum_t			: std_logic_vector( 31 downto 0 );
	signal	RefSeqNum_t			: std_logic_vector( 31 downto 0 );
	signal	RefTagId_t			: std_logic_vector( 15 downto 0 );
	signal	RefMsgType_t		: std_logic_vector( 7 downto 0 );
	signal	RejectReason_t		: std_logic_vector( 2 downto 0 );
	signal	GapFillFlag_t		: std_logic;
	signal	NewSeqNum_t			: std_logic_vector( 31 downto 0 );
	signal	MDReqId_t			: std_logic_vector( 15 downto 0 );
	signal	MDReqIdLen_t		: std_logic_vector( 5 downto 0 );
	signal	MsgVal2User_t		: std_logic_vector( 7 downto 0 );
	signal	SecIndic_t			: std_logic_vector( 4 downto 0 );
	signal	EntriesVal_t		: std_logic_vector( 1 downto 0 );
	signal	BidPx_t				: std_logic_vector( 15 downto 0 );
	signal	BidPxNegExp_t		: std_logic_vector( 1 downto 0 );
	signal	BidSize_t			: std_logic_vector( 31 downto 0 );
	signal	BidTimeHour_t		: std_logic_vector( 7 downto 0 );
	signal	BidTimeMin_t        : std_logic_vector( 7 downto 0 );
	signal	BidTimeSec_t        : std_logic_vector( 15 downto 0 );
	signal	BidTimeSecNegExp_t  : std_logic_vector( 1 downto 0 );
	signal	OffPx_t				: std_logic_vector( 15 downto 0 );
	signal	OffPxNegExp_t		: std_logic_vector( 1 downto 0 );
	signal	OffSize_t			: std_logic_vector( 31 downto 0 );
	signal	OffTimeHour_t		: std_logic_vector( 7 downto 0 );
	signal	OffTimeMin_t        : std_logic_vector( 7 downto 0 );
	signal	OffTimeSec_t        : std_logic_vector( 15 downto 0 );
	signal	OffTimeSecNegExp_t  : std_logic_vector( 1 downto 0 );
	signal	SpecialPxFlag_t		: std_logic_vector( 1 downto 0 );
	signal	NoEntriesError_t	: std_logic;
	
End Package PkSigTbRxFix;		
	
