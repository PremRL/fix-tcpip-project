----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		RxMsgDec.vhd
-- Title		
--
-- Company		Design Gateway Co., Ltd.
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
--	1. This module decoded information in Fix message, then send the decoded data out to User. 
--	2. This module support only some messages in FIXT1.1 and FIX5.0SP2 including
--	   Logon, Logout, Sequence Reset, Resent Request, Reject, HeartBeat, TestRequest,
--     Market data Request and Market data snapshot full refresh.
--	3. Field Error checking is weak in this module because of the field length variance
--     which can not be expected.
--	4. Resend Request is triggered by the error of Seqnumber
--	5. Reject is triggered by the error of checksum, body length, unknown Tag and so,e constant fields.
--	6. Un-support Tag is not allowed to pass through the module. (Reject case will be trigger.) 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxMsgDec Is
Port
(
	RstB				: in	std_logic;
	Clk					: in	std_logic; 
	
	--	Input from RxTCP and TPU
	FixSOP				: in	std_logic;		-- no use
	FixValid			: in	std_logic;
	FixEOP				: in	std_logic;		-- no use
	FixData				: in	std_logic_vector( 7 downto 0 );
	TCPConnect			: in	std_logic;
	
		-- Sec info 
	SecValid			: in	std_logic_vector( 4 downto 0 ); -- 5 Securities
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
	
	-- from header decoder modules
	TypePermit			: in	std_logic_vector( 7 downto 0 );	
	MsgEnd				: in	std_logic;								-- flag-reset point
	FieldLenCnt			: in	std_logic_vector( 5 downto 0 );			-- update 21/02/2021
	
	-- To header decoder modules
	MsgDecCtrlFlag 		: out	std_logic_vector( 24 downto 0 );		-- must be edited 
		-- TestReqCtrlFlag		: in	std_logic;
		-- LogOnCtrlFlag		: in	std_logic_vector( 5 downto 0 );
		-- SnapShotCtrlFlag		: in	std_logic_vector( 8 downto 0 );
		-- ResentReqCtrlFlag	: in	std_logic_vector( 1 downto 0 );
		-- RejectCtrlFlag		: in	std_logic_vector( 4 downto 0 );		-- include text
		-- SeqRstCtrlFlag		: in	std_logic_vector( 1 downto 0 );
	
	-- To control unit (via module Raptor)
	EncryptMetError		: out	std_logic;
	AppVerIdError		: out	std_logic;
	
	HeartBtInt			: out 	std_logic_vector( 15 downto 0 );	-- update 22/02/2021
	ResetSeqNumFlag		: out	std_logic;
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
	
	
	-- To User/ Decoded data
	SecIndic			: out 	std_logic_vector( 4 downto 0 );
	EntriesVal			: out 	std_logic_vector( 1 downto 0 );		-- 25/02/2021
	BidPx				: out 	std_logic_vector( 15 downto 0 );	-- edit 
	BidPxNegExp			: out 	std_logic_vector( 1 downto 0 );
	BidSize				: out 	std_logic_vector( 31 downto 0 );
	BidTimeHour			: out 	std_logic_vector( 7 downto 0 );		-- edit
	BidTimeMin          : out 	std_logic_vector( 7 downto 0 );		-- edit
	BidTimeSec          : out 	std_logic_vector( 15 downto 0 );
	BidTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 );
	
	OffPx				: out 	std_logic_vector( 15 downto 0 );	-- edit
	OffPxNegExp			: out 	std_logic_vector( 1 downto 0 );
	OffSize				: out 	std_logic_vector( 31 downto 0 );
	OffTimeHour			: out 	std_logic_vector( 7 downto 0 );		-- edit
	OffTimeMin          : out 	std_logic_vector( 7 downto 0 );     -- edit
	OffTimeSec          : out 	std_logic_vector( 15 downto 0 );
	OffTimeSecNegExp    : out 	std_logic_vector( 1 downto 0 );
	
	SpecialPxFlag		: out 	std_logic_vector( 1 downto 0 );
	
	-- Test Error port
	NoEntriesError		: out	std_logic
	
);
End Entity RxMsgDec;

Architecture rt1 Of RxMsgDec Is

----------------------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------------------

	Component Ascii2Bin Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		AsciiInSop			: in 	std_logic;
		AsciiInEop			: in 	std_logic;
		AsciiInVal			: in 	std_logic;
		AsciiInData			: in 	std_logic_vector( 7 downto 0 );
		
		BinOutVal			: out	std_logic;
		BinOutNegativeExp	: out	std_logic_vector( 1 downto 0 );
		BinOutData			: out 	std_logic_vector(26 downto 0 )
	);
	End Component Ascii2Bin;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cTypeHeartBt		: std_logic_vector( 15 downto 0 )	:= x"0030";	-- '0'
	constant cTypeTestReq		: std_logic_vector( 15 downto 0 )	:= x"0031";	-- '1'
	constant cTypeResentReq		: std_logic_vector( 15 downto 0 )	:= x"0032";	-- '2'
	constant cTypeReject		: std_logic_vector( 15 downto 0 )	:= x"0033";	-- '3'
	constant cTypeSeqRst		: std_logic_vector( 15 downto 0 )	:= x"0034";	-- '4'
	constant cTypeLogout		: std_logic_vector( 15 downto 0 )	:= x"0035";	-- '5'
	constant cTypeLogon			: std_logic_vector( 15 downto 0 )	:= x"0041";	-- 'A'
	constant cTypeSnapShot		: std_logic_vector( 15 downto 0 )	:= x"0057";	-- 'W'
	constant cTypeMrkDataReq	: std_logic_vector( 15 downto 0 )	:= x"0056";	-- 'V'
	
	-- #25 tag
	constant cTagEncryptMet		: std_logic_vector( 31 downto 0 )	:= x"0000_3938";	-- '00 98'
	constant cTagHeartBtInt		: std_logic_vector( 31 downto 0 )	:= x"0031_3038";	-- '01 08'
	constant cTagRstDeqNumFlag	: std_logic_vector( 31 downto 0 )	:= x"0031_3431";	-- '01 41'
	constant cTagUsername		: std_logic_vector( 31 downto 0 )	:= x"0035_3533";	-- '05 53'
	constant cTagPassword		: std_logic_vector( 31 downto 0 )	:= x"0035_3534";	-- '05 54'
	constant cTagAppVerId		: std_logic_vector( 31 downto 0 )	:= x"3131_3337";	-- '11 37'
	constant cTagTestReqId		: std_logic_vector( 31 downto 0 )	:= x"0031_3132";	-- '01 12'
	constant cTagBeginSeqNum	: std_logic_vector( 31 downto 0 )	:= x"0000_0037";	-- '00 07'
	constant cTagEndSeqNum		: std_logic_vector( 31 downto 0 )	:= x"0000_3136";	-- '00 16'
	constant cTagRefSeqNum		: std_logic_vector( 31 downto 0 )	:= x"0000_3435";	-- '00 45'
	constant cTagRefTagId		: std_logic_vector( 31 downto 0 )	:= x"0033_3731";	-- '03 71'
	constant cTagRefMsgType		: std_logic_vector( 31 downto 0 )	:= x"0033_3732";	-- '03 72'
	constant cTagRejectRea		: std_logic_vector( 31 downto 0 )	:= x"0033_3733";	-- '03 73'
	constant cTagText			: std_logic_vector( 31 downto 0 )	:= x"0000_3538";	-- '00 58'
	constant cTagGapFillFlag	: std_logic_vector( 31 downto 0 )	:= x"0031_3233";	-- '01 23'
	constant cTagNeqSeqNum		: std_logic_vector( 31 downto 0 )	:= x"0000_3336";	-- '00 36'
	constant cTagMDReqId		: std_logic_vector( 31 downto 0 )	:= x"0032_3632";	-- '02 62'
	constant cTagSymbol			: std_logic_vector( 31 downto 0 )	:= x"0000_3535";	-- '00 55'
	constant cTagSecId			: std_logic_vector( 31 downto 0 )	:= x"0000_3438";	-- '00 48'
	constant cTagSecIdSrc		: std_logic_vector( 31 downto 0 )	:= x"0000_3232";	-- '00 22'
	constant cTagNoEntries		: std_logic_vector( 31 downto 0 )	:= x"0032_3638";	-- '02 68'
	constant cTagEntryType		: std_logic_vector( 31 downto 0 )	:= x"0032_3639";	-- '02 69'
	constant cTagPx				: std_logic_vector( 31 downto 0 )	:= x"0032_3730";	-- '02 70'
	constant cTagSize			: std_logic_vector( 31 downto 0 )	:= x"0032_3731";	-- '02 71'
	constant cTagEntryTime		: std_logic_vector( 31 downto 0 )	:= x"0032_3733";	-- '02 73'	
	
	constant cAsciiEqual		: std_logic_vector( 7 downto 0 )	:= x"3d";	-- '='
	constant cAsciiSOH			: std_logic_vector( 7 downto 0 )	:= x"01";	-- ' '
	constant cAsciiYes			: std_logic_vector( 7 downto 0 )	:= x"59";	-- 'Y'
	constant cAscii0			: std_logic_vector( 7 downto 0 )	:= x"30";	-- '0'
	constant cAscii1			: std_logic_vector( 7 downto 0 )	:= x"31";	-- '1'
	constant cAscii2            : std_logic_vector( 7 downto 0 )	:= x"32";	-- '2'
	constant cAscii3            : std_logic_vector( 7 downto 0 )	:= x"33";	-- '3'
	constant cAscii4            : std_logic_vector( 7 downto 0 )	:= x"34";	-- '4'
	constant cAscii5            : std_logic_vector( 7 downto 0 )	:= x"35";	-- '5'
	constant cAscii6            : std_logic_vector( 7 downto 0 )	:= x"36";	-- '6'
	constant cAscii7            : std_logic_vector( 7 downto 0 )	:= x"37";	-- '7'
	constant cAscii8            : std_logic_vector( 7 downto 0 )	:= x"38";	-- '8'
	constant cAscii9            : std_logic_vector( 7 downto 0 )	:= x"39";	-- '9'
	
	constant cFixT				: std_logic_vector( 63 downto 0 )	:= x"4649_5854_2e31_2e31";	-- 'FIXT.1.1'
	
	constant cSETCompId			: std_logic_vector( 103 downto 0 )	:= x"00_0000_0000_0000_0000_0053_4554";	-- '0 0000 0000 0SET'
	constant cFIXCompId			: std_logic_vector( 103 downto 0 )	:= x"30_3031_355f_4649_585f_4d44_3530";	-- '0 015_ FIX_ MD50'
	
	constant cMonJan			: std_logic_vector( 15 downto 0 )	:= x"3031";
	constant cMonFeb            : std_logic_vector( 15 downto 0 )	:= x"3032";
	constant cMonMar            : std_logic_vector( 15 downto 0 )	:= x"3033";
	constant cMonArp            : std_logic_vector( 15 downto 0 )	:= x"3034";
	constant cMonMay            : std_logic_vector( 15 downto 0 )	:= x"3035";
	constant cMonJun            : std_logic_vector( 15 downto 0 )	:= x"3036";
	constant cMonJul            : std_logic_vector( 15 downto 0 )	:= x"3037";
	constant cMonAug            : std_logic_vector( 15 downto 0 )	:= x"3038";
	constant cMonSep            : std_logic_vector( 15 downto 0 )	:= x"3039";
	constant cMonOct            : std_logic_vector( 15 downto 0 )	:= x"3130";
	constant cMonNov            : std_logic_vector( 15 downto 0 )	:= x"3131";
	constant cMonDec            : std_logic_vector( 15 downto 0 )	:= x"3132";
	
	constant cRejectRea0		: std_logic_vector( 15 downto 0 )	:= x"0030";
	constant cRejectRea5		: std_logic_vector( 15 downto 0 )	:= x"0035";
	constant cRejectRea99		: std_logic_vector( 15 downto 0 )	:= x"3939";
	
	constant cBidMrkPx			: std_logic_vector( 39 downto 0 )	:= x"3932323333";	-- '92233 ...'
	constant cOffMrkPx			: std_logic_vector( 39 downto 0 )	:= x"302e303030";	-- '0.000 ...'
	constant cEndOfBidMrkPx		: std_logic_vector( 63 downto 0 )	:= x"342e373735383037";	-- '4.7758071'
	constant cEndOfOffMrkPx		: std_logic_vector( 63 downto 0 )	:= x"302e303030303031";	-- '0.000001'
	
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- input with FF							
	signal	rFixValid			: std_logic;
	signal	rFixData			: std_logic_vector( 7 downto 0 );
	
	-- Ascii2Bin I/F							
	signal	rAsciiInSop			: std_logic;
	signal	rAsciiInVal			: std_logic;
	signal	rAsciiInData		: std_logic_vector( 7 downto 0 );	-- flexible for fake data

	signal	rBinOutVal			: std_logic;
	signal	rBinOutNegExp		: std_logic_vector( 1 downto 0 );
	signal	rBinOutData			: std_logic_vector( 26 downto 0 );
	
	-- Wait Ascii2Bin output					
		--	signal	rWaitHeartBtInt			: std_logic;	delete 22/02/2021
	signal	rWaitBeginSeqNum	: std_logic;
	signal	rWaitEndSeqNum		: std_logic;
	signal	rWaitRefSeqNum		: std_logic;
	signal	rWaitRefTagId		: std_logic;
	signal	rWaitNewSeqNum		: std_logic;
	signal	rWaitSecId			: std_logic;
	signal	rWaitPx				: std_logic;
	signal	rWaitSize			: std_logic;
	signal	rWaitSec			: std_logic;
	
	-- delay signal to verify Ascii2Bin output for each rWait
	signal	rBeginSeqNumCtrl1	: std_logic;
	signal	rBeginSeqNumCtrl2	: std_logic;
	signal	rEndSeqNumCtrl1		: std_logic;
	signal	rEndSeqNumCtrl2		: std_logic;
	signal	rRefSeqNumCtrl1		: std_logic;
	signal	rRefSeqNumCtrl2		: std_logic;
	signal	rRefTagIdCtrl1		: std_logic;
	signal	rRefTagIdCtrl2		: std_logic;
	signal	rNewSeqNumCtrl1		: std_logic;
	signal	rNewSeqNumCtrl2		: std_logic;
	signal	rSecIdCtrl1			: std_logic;
	signal	rSecIdCtrl2			: std_logic;
	signal	rPxCtrl1			: std_logic;
	signal	rPxCtrl2			: std_logic;
	signal	rSizeCtrl1			: std_logic;
	signal	rSizeCtrl2			: std_logic;
	
	-- Tag indication
	signal	rTagIndic			: std_logic;
	signal	rTagSh				: std_logic_vector( 31 downto 0 );
	
	-- Control Flag
	signal	rTestReqIdCtrl		: std_logic;						-- bit 0 		of MsgDecCtrlFlag	
	signal	rResentReqCtrl		: std_logic_vector( 1 downto 0 );	-- bit 2-1 		of MsgDecCtrlFlag
	signal	rRejectCtrl			: std_logic_vector( 4 downto 0 );   -- bit 7-3 		of MsgDecCtrlFlag	-- include text
	signal	rSeqRstCtrl			: std_logic_vector( 1 downto 0 );   -- bit 9-8 		of MsgDecCtrlFlag
	signal	rLogOnCtrl			: std_logic_vector( 5 downto 0 );	-- bit 15-10 	of MsgDecCtrlFlag
	signal	rSnapShotCtrl		: std_logic_vector( 8 downto 0 );   -- bit 24-16 	of MsgDecCtrlFlag
	
	-- Heartbeat / TestReq				TypePermit bit 0-1
	signal	rTestReqIdVal			: std_logic;
	signal	rTestReqId				: std_logic_vector( 63 downto 0 );
	signal	rTestReqIdLen			: std_logic_vector( 5 downto 0 );		-- update 21/02/2021
	
	-- ResentReq					  TypePermit bit 2
	signal	rBeginSeqNum			: std_logic_vector( 31 downto 0 );
	signal	rEndSeqNum				: std_logic_vector( 31 downto 0 );
	
	-- Reject						TypePermit bit 3
	signal	rRefSeqNum				: std_logic_vector( 31 downto 0 );
	signal	rRefTagId				: std_logic_vector( 15 downto 0 );
	signal	rRefMsgTypeSh			: std_logic_vector( 15 downto 0 );
	signal	rRefMsgType				: std_logic_vector( 7 downto 0 );
	signal	rRejectReaSh			: std_logic_vector( 15 downto 0 );
	signal	rRejectReason			: std_logic_vector( 2 downto 0 );
	
	-- SeqRst						TypePermit bit 4
	signal	rGapFillFlag			: std_logic;
	signal	rNewSeqNum				: std_logic_vector( 31 downto 0 );
	
	-- LogOn						TypePermit bit 6	(bit 5 is LogOut)
	signal	rEncryptMet				: std_logic_vector( 7 downto 0 );
	signal	rEncryptMetError		: std_logic;
	signal	rHeartBtInt				: std_logic_vector( 15 downto 0 );		-- update 22/02/2021
	signal	rRstSeqNumFlag			: std_logic;
	signal	rAppVerIdVal			: std_logic;
	signal	rUserName				: std_logic_vector( 103 downto 0 );
	signal	rPassword				: std_logic_vector( 63 downto 0 );
	
	-- SnapShot					TypePermit bit 7
	signal	rMDReqId				: std_logic_vector( 15 downto 0 );
	signal	rMDReqIdLen				: std_logic_vector( 5 downto 0 );		-- update 21/02/2021
	signal	rSymbolSh				: std_logic_vector( 47 downto 0 );
	signal	rSecIndic				: std_logic_vector( 4 downto 0 );
	signal	rSecId					: std_logic_vector( 15 downto 0 );
	signal	rSecIdSource			: std_logic_vector( 15 downto 0 );
	signal	rNoEntries				: std_logic_vector( 15 downto 0 );
	signal	rNoEntriesError			: std_logic;		-- test port 
	signal	rEnTryTypeIndic			: std_logic;
	signal	rPxSh					: std_logic_vector( 159 downto 0 );
	signal	rPxByteCnt				: std_logic_vector( 4 downto 0 );
	signal	rBidVal					: std_logic;
	signal	rBidPx					: std_logic_vector( 15 downto 0 );
	signal	rBidPxNeqExp			: std_logic_vector( 1 downto 0 );
	signal	rOffVal					: std_logic;
	signal	rOffPx					: std_logic_vector( 15 downto 0 );
	signal	rOffPxNeqExp			: std_logic_vector( 1 downto 0 );
	signal	rSpecialPxFlag			: std_logic;
	signal	rSpecialPx				: std_logic_vector( 1 downto 0 );
	signal	rBidSize				: std_logic_vector( 31 downto 0 );
	signal	rOffSize				: std_logic_vector( 31 downto 0 );
	signal	rTimeByteCnt			: std_logic_vector( 3 downto 0 );	
	signal	rTimeHourSh				: std_logic_vector( 15 downto 0 );	
	signal	rTimeMinSh				: std_logic_vector( 15 downto 0 );
	signal	rBidTimeHour			: std_logic_vector( 7 downto 0 );
	signal	rBidTimeMin             : std_logic_vector( 7 downto 0 );
	signal	rBidTimeSec             : std_logic_vector( 15 downto 0 );
	signal	rBidTimeSecNegExp       : std_logic_vector( 1 downto 0 );
	signal	rOffTimeHour            : std_logic_vector( 7 downto 0 );
	signal	rOffTimeMin             : std_logic_vector( 7 downto 0 );
	signal	rOffTimeSec             : std_logic_vector( 15 downto 0 );
	signal	rOffTimeSecNegExp       : std_logic_vector( 1 downto 0 );
	
Begin

----------------------------------------------------------------------------------
-- Component Mapping
----------------------------------------------------------------------------------

	u_Ascii2Bin1: Ascii2Bin
	Port map
	(	
		Clk					=> Clk				,	
		RstB				=> RstB				,
		
		AsciiInSop			=> rAsciiInSop		,
		AsciiInEop			=> '0'	    		,
		AsciiInVal			=> rAsciiInVal	    ,
		AsciiInData			=> rAsciiInData     ,
		
		BinOutVal			=> rBinOutVal		,
		BinOutNegativeExp	=> rBinOutNegExp	,
        BinOutData	        => rBinOutData			
		
	);	

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	MsgDecCtrlFlag(0)				<= rTestReqIdCtrl				;
	MsgDecCtrlFlag(2 downto 1)		<= rResentReqCtrl(1 downto 0)	;
	MsgDecCtrlFlag(7 downto 3)      <= rRejectCtrl(4 downto 0)		;
	MsgDecCtrlFlag(9 downto 8)      <= rSeqRstCtrl(1 downto 0)		;
	MsgDecCtrlFlag(15 downto 10)    <= rLogOnCtrl(5 downto 0)		;
	MsgDecCtrlFlag(24 downto 16)    <= rSnapShotCtrl(8 downto 0)	;
	
	EncryptMetError					<= rEncryptMetError             ;
	AppVerIdError	                <= not rAppVerIdVal				;
	
	HeartBtInt						<= rHeartBtInt					;
	ResetSeqNumFlag	                <= rRstSeqNumFlag               ;
	TestReqIdVal					<= rTestReqIdVal				;
	TestReqId		                <= rTestReqId                   ;
	TestReqIdLen					<= rTestReqIdLen				;
	BeginSeqNum		                <= rBeginSeqNum                 ;
	EndSeqNum		                <= rEndSeqNum                   ;
	RefSeqNum		                <= rRefSeqNum                   ;
	RefTagId		                <= rRefTagId                    ;
	RefMsgType		                <= rRefMsgType                  ;
	RejectReason	                <= rRejectReason                ;
	GapFillFlag		                <= rGapFillFlag                 ;
	NewSeqNum		                <= rNewSeqNum                   ;
	MDReqId			                <= rMDReqId                     ;
	MDReqIdLen						<= rMDReqIdLen					;
	
	SecIndic						<= rSecIndic 					;
	EntriesVal(0)					<= rBidVal						;
	EntriesVal(1)					<= rOffVal						;
	BidPx		                    <= rBidPx                       ;
	BidPxNegExp	                    <= rBidPxNeqExp                 ;
	BidSize		                    <= rBidSize                     ;
	BidTimeHour	                    <= rBidTimeHour                 ;
	BidTimeMin                      <= rBidTimeMin                  ;
	BidTimeSec                      <= rBidTimeSec                  ;
	BidTimeSecNegExp				<= rBidTimeSecNegExp            ;
	
	OffPx							<= rOffPx						;
	OffPxNegExp	                    <= rOffPxNeqExp                 ;
	OffSize		                    <= rOffSize                     ;
	OffTimeHour	                    <= rOffTimeHour                 ;
	OffTimeMin                      <= rOffTimeMin                  ;
	OffTimeSec                      <= rOffTimeSec                  ;
	OffTimeSecNegExp				<= rOffTimeSecNegExp            ;
	
	SpecialPxFlag					<= rSpecialPx					;
	NoEntriesError					<= rNoEntriesError              ;
	
----------------------------------------------------------------------------------
-- Internal Process
----------------------------------------------------------------------------------

	u_DataIn : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rFixData(7 downto 0)		<= FixData(7 downto 0);		-- 1 FF
		end if;
	End Process u_DataIn;
	
	u_DataInVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixValid	<= '0';
			else	
				rFixValid		<= FixValid;	-- 1 FF
			end if;
		end if;
	End Process u_DataInVal;
	
	-- delay signal to verify Ascii2Bin output for each rWait
	u_BeginSeqNumCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rBeginSeqNumCtrl1	<= rResentReqCtrl(0);	-- 1 FF
			rBeginSeqNumCtrl2	<= rBeginSeqNumCtrl1;	-- 2 FF
		end if;
	End Process u_BeginSeqNumCtrlFF;
	
	u_EndSeqNumCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rEndSeqNumCtrl1		<= rResentReqCtrl(1);	-- 1 FF
			rEndSeqNumCtrl2		<= rEndSeqNumCtrl1;		-- 2 FF
		end if;
	End Process u_EndSeqNumCtrlFF;
	
	u_RefSeqNumCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rRefSeqNumCtrl1		<= rRejectCtrl(0);		-- 1 FF
			rRefSeqNumCtrl2		<= rRefSeqNumCtrl1;		-- 2 FF
		end if;
	End Process u_RefSeqNumCtrlFF;
	
	u_RefTagIdCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rRefTagIdCtrl1		<= rRejectCtrl(1);		-- 1 FF
			rRefTagIdCtrl2		<= rRefTagIdCtrl1;		-- 2 FF
		end if;
	End Process u_RefTagIdCtrlFF;
	
	u_NewSeqNumCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rNewSeqNumCtrl1		<= rSeqRstCtrl(1);		-- 1 FF
			rNewSeqNumCtrl2		<= rNewSeqNumCtrl1;		-- 2 FF
		end if;
	End Process u_NewSeqNumCtrlFF;
	
	u_SecIdCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rSecIdCtrl1		<= rSnapShotCtrl(2);		-- 1 FF
			rSecIdCtrl2		<= rSecIdCtrl1;				-- 2 FF
		end if;
	End Process u_SecIdCtrlFF;
	
	u_PxCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rPxCtrl1		<= rSnapShotCtrl(6);		-- 1 FF
			rPxCtrl2		<= rPxCtrl1;				-- 2 FF
		end if;
	End Process u_PxCtrlFF;
	
	u_SizeCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rSizeCtrl1		<= rSnapShotCtrl(7);		-- 1 FF
			rSizeCtrl2		<= rSizeCtrl1;				-- 2 FF
		end if;
	End Process u_SizeCtrlFF;
	
----------------------------------------------------------------------------------
--	Ascii to Binary 
----------------------------------------------------------------------------------	
	
	u_rAsciiInSop : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rAsciiInSop	<= '0';
			else
				-- reset after set with valid for 1 clk
				if ( rAsciiInVal='1' and rAsciiInSop='1' ) then
					rAsciiInSop		<= '0';
				
				-- normal case: set SOP when the tag want to decode ascii
				elsif ( rFixValid='1' and rFixData=cAsciiEqual and
					( 	rTagSh(31 downto 0)=cTagBeginSeqNum or
						rTagSh(31 downto 0)=cTagEndSeqNum or
						rTagSh(31 downto 0)=cTagRefSeqNum or
						rTagSh(31 downto 0)=cTagRefTagId or
						rTagSh(31 downto 0)=cTagNeqSeqNum or
						rTagSh(31 downto 0)=cTagSecId or
						rTagSh(31 downto 0)=cTagPx or
						rTagSh(31 downto 0)=cTagSize ) ) then 
					rAsciiInSop		<= '1';
				
				-- case: second decoding in sending time
				elsif ( rFixValid='1' and rTimeByteCnt(3 downto 0)=6 ) then
					rAsciiInSop		<='1';
				else
					rAsciiInSop		<= rAsciiInSop;
				end if;
			end if;
		end if;
	End Process u_rAsciiInSop;
	
	u_rAsciiInVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rAsciiInVal	<= '0';
			else
				rAsciiInVal		<= FixValid;
				-- -- reset when fed data is SOH, end of process
				-- if ( rFixValid='1' and rAsciiInData(7 downto 0)=cAsciiSOH ) then
					-- rAsciiInVal	<= '0';
				
				-- -- set when the tag want to decode ascii (first byte according with AsciiSop)
				-- elsif ( rFixValid='1' and rFixData=cAsciiEqual and
					-- ( 	rTagSh(31 downto 0)=cTagBeginSeqNum or
						-- rTagSh(31 downto 0)=cTagEndSeqNum or
						-- rTagSh(31 downto 0)=cTagRefSeqNum or
						-- rTagSh(31 downto 0)=cTagRefTagId or
						-- rTagSh(31 downto 0)=cTagNeqSeqNum or
						-- rTagSh(31 downto 0)=cTagSecId or
						-- rTagSh(31 downto 0)=cTagPx or
						-- rTagSh(31 downto 0)=cTagSize ) ) then 
					-- rAsciiInVal	<= '1';
				
				-- -- while feeding data into Ascii2Bin, Asciivalid must accords with Fixvalid
				-- elsif ( rResentReqCtrl(1 downto 0)="01" or rResentReqCtrl(1 downto 0)="10" or
						-- rRejectCtrl(4 downto 0)="00001" or rRejectCtrl(4 downto 0)="00010" or 
						-- rSeqRstCtrl(1 downto 0)="10" or rSnapShotCtrl(8 downto 0)="000000100" or
						-- rSnapShotCtrl(8 downto 0)="001000000" or rSnapShotCtrl(8 downto 0)="010000000" or
						-- rSnapShotCtrl(8 downto 0)="100000000" ) then
					-- rAsciiInVal	<= FixValid;
		
				-- else
					-- rAsciiInVal	<= rAsciiInVal;
				-- end if;
			end if;
		end if;
	End Process u_rAsciiInVal;
	
	u_rAsciiInData : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- fake data to end price decoding when market price (special case) is fed.
			if ( rFixValid='1' and rPxByteCnt(4 downto 0)=7 and 
				 rSpecialPxFlag='1' ) then
				rAsciiInData(7 downto 0)	<= cAsciiSOH;
				
			-- still feed fake data till valid is come
			elsif ( rAsciiInVal='0' and rPxByteCnt(4 downto 0)=7 and 
					rSpecialPxFlag='1' ) then
				rAsciiInData(7 downto 0)	<= rAsciiInData(7 downto 0);
			else
				rAsciiInData(7 downto 0)	<= FixData(7 downto 0);
			end if;
		end if;
	End Process u_rAsciiInData;
	
----------------------------------------------------------------------------------
-- Tag indication
----------------------------------------------------------------------------------

	u_rTagIndic : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTagIndic	<= '0';
			else	
				-- reset when reach '='
				if ( TCPConnect='1' and rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual ) then 
					rTagIndic	<= '0';
					
				-- set when reach SOH
				elsif ( TCPConnect='1' and rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rTagIndic	<= '1';
				else
					rTagIndic	<= rTagIndic;
				end if;
			end if;
		end if;
	End Process u_rTagIndic;
	
	u_rTagSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTagSh(31 downto 0)	<= (others=>'0');
			else	
				-- reset when reach '='
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual ) then
					rTagSh(31 downto 0)		<=	(others=>'0');
					
				-- left shift when Tag indicator is set
				elsif ( rFixValid='1' and rTagIndic='1' ) then
					rTagSh(31 downto 24)	<= rTagSh(23 downto 16);	
					rTagSh(23 downto 16)	<= rTagSh(15 downto 8);	
					rTagSh(15 downto 8)   	<= rTagSh(7 downto 0);  
					rTagSh(7 downto 0)    	<= rFixData(7 downto 0);   
				else
					rTagSh(31 downto 0)		<= rTagSh(31 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTagSh;
	
----------------------------------------------------------------------------------
-- Heartbeat / Test Request
--		-- these 2 message type have only one field which is TestReqId
--		-- Permission: bit 0-1 of TypePermit(7 downto 0) 
----------------------------------------------------------------------------------

	u_rTestReqIdCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTestReqIdCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rTestReqIdCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						(TypePermit(0)='1' or TypePermit(1)='1') and 
						rTagSh( 31 downto 0)=cTagTestReqId ) then
					rTestReqIdCtrl	<= '1';
				else
					rTestReqIdCtrl	<= rTestReqIdCtrl;
				end if;
			end if;
		end if;
	End Process u_rTestReqIdCtrl;
	
	-- rTestReqIdVal
	u_rTestReqIdVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTestReqIdVal	<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rTestReqIdVal	<= '0';
				
				-- set when feeding Msg has TestReqId field
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						(TypePermit(0)='1' or TypePermit(1)='1') and 
						rTagSh( 31 downto 0)=cTagTestReqId ) then
					rTestReqIdVal	<= '1';
				else
					rTestReqIdVal	<= rTestReqIdVal;
				end if;
			 end if;
		end if;
	End Process;
	
	u_rTestReqId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTestReqId(63 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rTestReqId(63 downto 0)	<= (others=>'0');
				
				-- left shift when its control flag is set
				elsif ( rFixValid='1' and rTestReqIdCtrl='1' and rFixData(7 downto 0)/=cAsciiSOH) then 
					rTestReqId(63 downto 56)	<= rTestReqId(55 downto 48);
					rTestReqId(55 downto 48)   	<= rTestReqId(47 downto 40);
					rTestReqId(47 downto 40)   	<= rTestReqId(39 downto 32);
					rTestReqId(39 downto 32)   	<= rTestReqId(31 downto 24);
					rTestReqId(31 downto 24)   	<= rTestReqId(23 downto 16);
					rTestReqId(23 downto 16)   	<= rTestReqId(15 downto 8); 
					rTestReqId(15 downto 8)    	<= rTestReqId(7 downto 0);  
					rTestReqId(7 downto 0)     	<= rFixData(7 downto 0);
				else
					rTestReqId(63 downto 0)			<= rTestReqId(63 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTestReqId;
	
	u_rTestReqIdLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTestReqIdLen(5 downto 0)	<= "000000";
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rTestReqIdLen(5 downto 0)	<= "000000";
				
				-- latch field length at the end of Test request ID field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rTestReqIdCtrl='1' ) then
					rTestReqIdLen(5 downto 0)	<= FieldLenCnt(5 downto 0);
				else
					rTestReqIdLen(5 downto 0)	<= rTestReqIdLen(5 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTestReqIdLen;
	
----------------------------------------------------------------------------------
-- Resent Request
--		-- Permission: bit 2 of TypePermit(7 downto 0)
--		-- rResentReqCtrl(0) to control BeginSeqNum
--		-- rResentReqCtrl(1) to control EndSeqNum 
----------------------------------------------------------------------------------
	
	u_rResentReqCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rResentReqCtrl(1 downto 0)	<= "00";
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rResentReqCtrl(1 downto 0)	<= "00";
					
				-- bit0: set when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(2)='1' and rTagSh( 31 downto 0)=cTagBeginSeqNum ) then
					rResentReqCtrl(1 downto 0)	<= "01";
					
				-- bit1: set when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(2)='1' and rTagSh( 31 downto 0)=cTagEndSeqNum ) then
					rResentReqCtrl(1 downto 0)	<= "10";
					
				else
					rResentReqCtrl(1 downto 0)	<= rResentReqCtrl(1 downto 0);
				end if;
			end if;
		end if;
	End Process u_rResentReqCtrl;
	
	u_rWaitBeginSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitBeginSeqNum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rBeginSeqNumCtrl1='0' and rBeginSeqNumCtrl2='1' ) then
					rWaitBeginSeqNum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rResentReqCtrl(0)='1' ) then
					rWaitBeginSeqNum	<= '1';
				else
					rWaitBeginSeqNum	<= rWaitBeginSeqNum;
				end if;
			end if;
		end if;
	End Process u_rWaitBeginSeqNum;
	
	u_rWaitEndSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitEndSeqNum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rEndSeqNumCtrl1='0' and rEndSeqNumCtrl2='1' ) then
					rWaitEndSeqNum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rResentReqCtrl(1)='1' ) then
					rWaitEndSeqNum	<= '1';
				else
					rWaitEndSeqNum	<= rWaitEndSeqNum;
				end if;
			end if;
		end if;
	End Process u_rWaitEndSeqNum;
	
	u_rBeginSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of SeqNum is not all zero
			if ( rBinOutVal='1' and rWaitBeginSeqNum='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rBeginSeqNum(31 downto 27)	<= "00000";
				rBeginSeqNum(26 downto 0)	<= rBinOutData(26 downto 0);
			else
				rBeginSeqNum(31 downto 0)	<= rBeginSeqNum(31 downto 0);
			end if;
		end if;
	End Process u_rBeginSeqNum;
	
	u_rEndSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of SeqNum is not all zero
			if ( rBinOutVal='1' and rWaitEndSeqNum='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rEndSeqNum(31 downto 27)	<= "00000";
				rEndSeqNum(26 downto 0)		<= rBinOutData(26 downto 0);
			else
				rEndSeqNum(31 downto 0)		<= rEndSeqNum(31 downto 0);
			end if;
		end if;
	End Process u_rEndSeqNum;
	
----------------------------------------------------------------------------------
-- Reject
--		-- Permission: bit 3 of TypePermit(7 downto 0)
--		-- rRejectCtrl(0) to control RefSeqNum
--		-- rRejectCtrl(1) to control RefTagId
--		-- rRejectCtrl(2) to control RefMsgType
--		-- rRejectCtrl(3) to control RejectReason
--		-- rRejectCtrl(4) to control Text
----------------------------------------------------------------------------------
	
	u_rRejectCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRejectCtrl(4 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rRejectCtrl(4 downto 0)	<= "00000";
					
				-- set a bit when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(3)='1' ) then
					case ( rTagSh( 31 downto 0) ) Is
						When cTagRefSeqNum		=> rRejectCtrl(4 downto 0)	<= "00001";
						When cTagRefTagId		=> rRejectCtrl(4 downto 0)	<= "00010";
						When cTagRefMsgType		=> rRejectCtrl(4 downto 0)	<= "00100";
						When cTagRejectRea		=> rRejectCtrl(4 downto 0)	<= "01000";
						When cTagText			=> rRejectCtrl(4 downto 0)	<= "10000";
						When others				=> rRejectCtrl(4 downto 0)	<= "00000";
					end case;	
				else
					rRejectCtrl(4 downto 0)	<= rRejectCtrl(4 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRejectCtrl;
	
	u_rWaitRefSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitRefSeqNum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rRefSeqNumCtrl1='0' and rRefSeqNumCtrl2='1' ) then
					rWaitRefSeqNum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rRejectCtrl(4 downto 0)="00001" ) then
					rWaitRefSeqNum	<= '1';
				else
					rWaitRefSeqNum	<= rWaitRefSeqNum;
				end if;
			end if;
		end if;
	End Process u_rWaitRefSeqNum;
	
	u_rWaitRefTagId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitRefTagId	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rRefTagIdCtrl1='0' and rRefTagIdCtrl2='1' ) then
					rWaitRefTagId	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rRejectCtrl(4 downto 0)="00010" ) then
					rWaitRefTagId	<= '1';
				else
					rWaitRefTagId	<= rWaitRefTagId;
				end if;
			end if;
		end if;
	End Process u_rWaitRefTagId;
	
	u_rRefSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of SeqNum is not all zero
			if ( rBinOutVal='1' and rWaitRefSeqNum='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rRefSeqNum(31 downto 27)	<= "00000";
				rRefSeqNum(26 downto 0)		<= rBinOutData(26 downto 0);
			else
				rRefSeqNum(31 downto 0)		<= rRefSeqNum(31 downto 0);
			end if;
		end if;
	End Process u_rRefSeqNum;
	
	u_rRefTagId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 26-16 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitRefTagId='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rRefTagId(15 downto 0)		<= rBinOutData(15 downto 0);
			else
				rRefTagId(15 downto 0)		<= rRefTagId(15 downto 0);
			end if;
		end if;
	End Process u_rRefTagId;
	
	u_rRefMsgTypeSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRefMsgTypeSh(15 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rRefMsgTypeSh(15 downto 0)	<= (others=>'0');
	
				-- left shift when its control is set
				elsif ( rFixValid='1' and rRejectCtrl(4 downto 0)="00100" ) then
					rRefMsgTypeSh(15 downto 8)	<= rRefMsgTypeSh(7 downto 0);
					rRefMsgTypeSh(7 downto 0)	<= rFixData(7 downto 0);
				else
					rRefMsgTypeSh(7 downto 0)	<= rRefMsgTypeSh(7 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRefMsgTypeSh;
	
	u_rRefMsgType : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch when the end of its field
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rRejectCtrl(4 downto 0)="00100" ) then
				-- set the bit according to message type that is referred
				case ( rRefMsgTypeSh(15 downto 0) ) Is
					when cTypeHeartBt 		=> rRefMsgType(7 downto 0) 	<= "00000001";
					when cTypeTestReq		=> rRefMsgType(7 downto 0) 	<= "00000010";
					when cTypeResentReq		=> rRefMsgType(7 downto 0) 	<= "00000100";
					when cTypeReject		=> rRefMsgType(7 downto 0) 	<= "00001000";
					when cTypeSeqRst		=> rRefMsgType(7 downto 0) 	<= "00010000";
					when cTypeLogout		=> rRefMsgType(7 downto 0) 	<= "00100000";
					when cTypeLogon			=> rRefMsgType(7 downto 0) 	<= "01000000";
					when cTypeMrkDataReq	=> rRefMsgType(7 downto 0) 	<= "10000000";
					when others				=> rRefMsgType(7 downto 0)	<= "00000000";	-- error case
				end case;
			else
				rRefMsgType(7 downto 0)		<= rRefMsgType(7 downto 0);
			end if;
		end if;
	End Process u_rRefMsgType;
	
	u_rRejectReaSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRejectReaSh(15 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rRejectReaSh(15 downto 0)	<= (others=>'0');
	
				-- left shift when its control is set
				elsif ( rFixValid='1' and rRejectCtrl(4 downto 0)="01000" ) then
					rRejectReaSh(15 downto 8)	<= rRejectReaSh(7 downto 0);
					rRejectReaSh(7 downto 0)	<= rFixData(7 downto 0);
				else
					rRejectReaSh(7 downto 0)	<= rRejectReaSh(7 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRejectReaSh;
	
	u_rRejectReason : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch when the end of its field
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rRejectCtrl(4 downto 0)="01000" ) then
				-- set the bit according to reject reason
				case ( rRejectReaSh(15 downto 0) ) Is
					when cRejectRea0 		=> rRejectReason(2 downto 0) 	<= "001";
					when cRejectRea5 		=> rRejectReason(2 downto 0) 	<= "010";
					when cRejectRea99 		=> rRejectReason(2 downto 0) 	<= "100";
					when others				=> rRejectReason(2 downto 0) 	<= "000";	-- error case
				end case;
			else
				rRejectReason(2 downto 0)		<= rRejectReason(2 downto 0);
			end if;
		end if;
	End Process u_rRejectReason;
	
----------------------------------------------------------------------------------
-- Sequence Reset
--		-- Permission: bit 4 of TypePermit(7 downto 0)
--		-- rSeqRstCtrl(0) to control rGapFillFlag
--		-- rSeqRstCtrl(1) to control rNewSeqNum
----------------------------------------------------------------------------------

	u_rSeqRstCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSeqRstCtrl(1 downto 0)	<= "00";
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSeqRstCtrl(1 downto 0)	<= "00";
					
				-- bit0: set when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(4)='1' and rTagSh( 31 downto 0)=cTagGapFillFlag ) then
					rSeqRstCtrl(1 downto 0)	<= "01";
					
				-- bit1: set when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(4)='1' and rTagSh( 31 downto 0)=cTagNeqSeqNum ) then
					rSeqRstCtrl(1 downto 0)	<= "10";
					
				else
					rSeqRstCtrl(1 downto 0)	<= rSeqRstCtrl(1 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSeqRstCtrl;
	
	u_rGapFillFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rGapFillFlag	<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rGapFillFlag	<= '0';
					
				-- set if GapFillFlag is Y
				elsif ( rFixValid='1' and rSeqRstCtrl(1 downto 0)="01" and
						rFixData(7 downto 0)/=cAsciiSOH and rFixData(7 downto 0)=cAsciiYes ) then
					rGapFillFlag	<= '1';
				else
					rGapFillFlag	<= rGapFillFlag;
				end if;
			end if;
		end if;
	End Process u_rGapFillFlag;
	
	u_rWaitNewSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitNewSeqNum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rNewSeqNumCtrl1='0' and rNewSeqNumCtrl2='1' ) then
					rWaitNewSeqNum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSeqRstCtrl(1 downto 0)="10" ) then
					rWaitNewSeqNum	<= '1';
				else
					rWaitNewSeqNum	<= rWaitNewSeqNum;
				end if;
			end if;
		end if;
	End Process u_rWaitNewSeqNum;
	
	u_rNewSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of SeqNum is not all zero
			if ( rBinOutVal='1' and rWaitNewSeqNum='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rNewSeqNum(31 downto 27)	<= "00000";
				rNewSeqNum(26 downto 0)		<= rBinOutData(26 downto 0);
			else
				rNewSeqNum(31 downto 0)		<= rNewSeqNum(31 downto 0);
			end if;
		end if;
	End Process u_rNewSeqNum;
	
----------------------------------------------------------------------------------
-- Logon
--		-- Permission: bit 6 of TypePermit(7 downto 0)
--		-- rLogOnCtrl(0) to control rEncryptMet
--		-- rLogOnCtrl(1) to control rHeartBtInt
--		-- rLogOnCtrl(2) to control rRstSeqNumFlag
--		-- rLogOnCtrl(3) to control rAppVerId
--		-- rLogOnCtrl(4) to control rUserName
--		-- rLogOnCtrl(5) to control rPassword
----------------------------------------------------------------------------------

	u_rLogOnCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rLogOnCtrl(5 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rLogOnCtrl(5 downto 0)	<= "000000";
					
				-- set a bit when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(6)='1' ) then
					case ( rTagSh( 31 downto 0) ) Is
						When cTagEncryptMet		=> rLogOnCtrl(5 downto 0)	<= "000001";
						When cTagHeartBtInt		=> rLogOnCtrl(5 downto 0)	<= "000010";
						When cTagRstDeqNumFlag	=> rLogOnCtrl(5 downto 0)	<= "000100";
						When cTagAppVerId		=> rLogOnCtrl(5 downto 0)	<= "001000";
						When cTagUsername		=> rLogOnCtrl(5 downto 0)	<= "010000";
						When cTagPassword		=> rLogOnCtrl(5 downto 0)	<= "100000";
						When others				=> rLogOnCtrl(5 downto 0)	<= "000000";
					end case;
				else
					rLogOnCtrl(5 downto 0)	<= rLogOnCtrl(5 downto 0);
				end if;
			end if;
		end if;
	End Process u_rLogOnCtrl;
	
	u_rEncryptMet : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch Ascii value of Encrypt Method when its control flag is set
			if ( rFixValid='1' and rLogOnCtrl(5 downto 0)="000001" and 
				 rFixData(7 downto 0)/=cAsciiSOH ) then
				rEncryptMet(7 downto 0)	<= rFixData(7 downto 0);
			else
				rEncryptMet(7 downto 0)	<= rEncryptMet(7 downto 0);
			end if;
		end if;
	End Process u_rEncryptMet;
	
	u_rEncryptMetError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rEncryptMetError	<= '1';
			else
				-- set Error if latched Encrypt Method is not 30 (Ascii)
				if ( rFixValid='1' and rLogOnCtrl(5 downto 0)="000001" and 
					 rFixData(7 downto 0)=cAsciiSOH and rEncryptMet(7 downto 0)/=cAscii0 ) then
					rEncryptMetError	<= '1';
				-- set Valid (non-Error) if latched Encrypt Method is 30 (Ascii)
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)="000001" and 
					 rFixData(7 downto 0)=cAsciiSOH and rEncryptMet(7 downto 0)=cAscii0 ) then
					rEncryptMetError	<= '0';
				
				else
					rEncryptMetError	<= rEncryptMetError;
				end if;
			end if;
		end if;
	End Process u_rEncryptMetError;
	
	u_rHeartBtInt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rHeartBtInt(15 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rHeartBtInt(15 downto 0)	<= (others=>'0');
				
				-- left shift when its control flag is set
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)= "000010" and
						 rFixData(7 downto 0)/=cAsciiSOH ) then
					rHeartBtInt(15 downto 8)	<= rHeartBtInt(7 downto 0);
					rHeartBtInt(7 downto 0)		<= rFixData(7 downto 0);
				else
					rHeartBtInt(15 downto 0)		<= rHeartBtInt(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rHeartBtInt;

	u_rRstSeqNumFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRstSeqNumFlag	<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rRstSeqNumFlag	<= '0';
					
				-- set if Reset Sequence Number flag is Y
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)="000100" and
						rFixData(7 downto 0)/=cAsciiSOH and rFixData(7 downto 0)=cAsciiYes ) then
					rRstSeqNumFlag	<= '1';
				else
					rRstSeqNumFlag	<= rRstSeqNumFlag;
				end if;
			end if;
		end if;
	End Process u_rRstSeqNumFlag;

	u_rAppVerIdVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rAppVerIdVal	<= '0';
			else	
				-- set Valid if Application version ID is 9 (39 in Ascii)
				if ( rFixValid='1' and rLogOnCtrl(5 downto 0)="001000" and
					 rFixData(7 downto 0)/=cAsciiSOH and rFixData(7 downto 0)=cAscii9 ) then
					rAppVerIdVal	<= '1';
					
				-- set Error if Application version ID is not 9 (39 in Ascii)
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)="001000" and
						rFixData(7 downto 0)/=cAsciiSOH and rFixData(7 downto 0)/=cAscii9 ) then
					rAppVerIdVal	<= '0';	
					
				else
					rAppVerIdVal	<= rAppVerIdVal;
				end if;
			end if;
		end if;
	End Process u_rAppVerIdVal;

	u_rUserName : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rUserName(103 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rUserName(103 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)="010000" and
						rFixData(7 downto 0)/=cAsciiSOH ) then
					rUserName(103 downto 96)	<= rUserName(95 downto 88);
					rUserName(95 downto 88)     <= rUserName(87 downto 80);
					rUserName(87 downto 80)     <= rUserName(79 downto 72);
					rUserName(79 downto 72)     <= rUserName(71 downto 64);
					rUserName(71 downto 64)     <= rUserName(63 downto 56);
					rUserName(63 downto 56)		<= rUserName(55 downto 48);
					rUserName(55 downto 48)   	<= rUserName(47 downto 40);
					rUserName(47 downto 40)   	<= rUserName(39 downto 32);
					rUserName(39 downto 32)   	<= rUserName(31 downto 24);
					rUserName(31 downto 24)   	<= rUserName(23 downto 16);
					rUserName(23 downto 16)   	<= rUserName(15 downto 8); 
					rUserName(15 downto 8)    	<= rUserName(7 downto 0);  
					rUserName(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rUserName(103 downto 0)		<= rUserName(103 downto 0);
				end if;
			end if;
		end if;
	End Process u_rUserName;

	u_rPassword : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPassword(63 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rPassword(63 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rLogOnCtrl(5 downto 0)="100000" and
						rFixData(7 downto 0)/=cAsciiSOH ) then
					rPassword(63 downto 56)		<= rPassword(55 downto 48);
					rPassword(55 downto 48)   	<= rPassword(47 downto 40);
					rPassword(47 downto 40)   	<= rPassword(39 downto 32);
					rPassword(39 downto 32)   	<= rPassword(31 downto 24);
					rPassword(31 downto 24)   	<= rPassword(23 downto 16);
					rPassword(23 downto 16)   	<= rPassword(15 downto 8); 
					rPassword(15 downto 8)    	<= rPassword(7 downto 0);  
					rPassword(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rPassword(63 downto 0)		<= rPassword(63 downto 0);
				end if;
			end if;
		end if;
	End Process u_rPassword;

----------------------------------------------------------------------------------
-- SnapShot Full Refresh
--		-- Permission: bit 7 of TypePermit(7 downto 0)
--		-- rSnapShotCtrl(0) to control rMDReqId
--		-- rSnapShotCtrl(1) to control rSymbolSh
--		-- rSnapShotCtrl(2) to control rSecId
--		-- rSnapShotCtrl(3) to control rSecIdSource
--		-- rSnapShotCtrl(4) to control rNoEntries
--		-- rSnapShotCtrl(5) to control rEnTryTypeIndic
--		-- rSnapShotCtrl(6) to control rPxSh
--		-- rSnapShotCtrl(7) to control rBidSize / rOffSize
--		-- rSnapShotCtrl(8) to control All of Entry Time signals
----------------------------------------------------------------------------------

	u_rSnapShotCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSnapShotCtrl(8 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSnapShotCtrl(8 downto 0)	<= '0'&x"00";
					
				-- set a bit when reach '=' before the 1st byte of its field
				-- its permission flag (TypePermit) must be set
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						TypePermit(7)='1' ) then
					case ( rTagSh( 31 downto 0) ) Is
						When cTagMDReqId	=> rSnapShotCtrl(8 downto 0)	<= '0'&"0000"&"0001";
						When cTagSymbol		=> rSnapShotCtrl(8 downto 0)	<= '0'&"0000"&"0010";
						When cTagSecId		=> rSnapShotCtrl(8 downto 0)	<= '0'&"0000"&"0100";
						When cTagSecIdSrc	=> rSnapShotCtrl(8 downto 0)	<= '0'&"0000"&"1000";
						When cTagNoEntries	=> rSnapShotCtrl(8 downto 0)	<= '0'&"0001"&"0000";
						When cTagEntryType	=> rSnapShotCtrl(8 downto 0)	<= '0'&"0010"&"0000";
						When cTagPx			=> rSnapShotCtrl(8 downto 0)	<= '0'&"0100"&"0000";
						When cTagSize		=> rSnapShotCtrl(8 downto 0)	<= '0'&"1000"&"0000";
						When cTagEntryTime	=> rSnapShotCtrl(8 downto 0)	<= '1'&"0000"&"0000";
						When others			=> rSnapShotCtrl(8 downto 0)	<= '0'&"0000"&"0000";
					end case;
				else
					rSnapShotCtrl(8 downto 0)	<= rSnapShotCtrl(8 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSnapShotCtrl;

	u_rMDReqId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMDReqId(15 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rMDReqId(15 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0001") and
						rFixData(7 downto 0)/=cAsciiSOH ) then 
					rMDReqId(15 downto 8)    	<= rMDReqId(7 downto 0);  
					rMDReqId(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rMDReqId(15 downto 0)		<= rMDReqId(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rMDReqId;
	
	u_rMDReqIdLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMDReqIdLen(5 downto 0)	<= "000000";
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rMDReqIdLen(5 downto 0)	<= "000000";
				
				-- latch field length at the end of Test request ID field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0001") ) then
					rMDReqIdLen(5 downto 0)	<= FieldLenCnt(5 downto 0);
				else
					rMDReqIdLen(5 downto 0)	<= rMDReqIdLen(5 downto 0);
				end if;
			end if;
		end if;
	End Process u_rMDReqIdLen;
	
	--------------------------------------
	-- Security 
	--------------------------------------
	
	u_rSymbolSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSymbolSh(47 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rSymbolSh(47 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and
						rFixData(7 downto 0)/=cAsciiSOH ) then
					rSymbolSh(47 downto 40)		<= rSymbolSh(39 downto 32);
					rSymbolSh(39 downto 32)   	<= rSymbolSh(31 downto 24);
					rSymbolSh(31 downto 24)   	<= rSymbolSh(23 downto 16);
					rSymbolSh(23 downto 16)   	<= rSymbolSh(15 downto 8); 
					rSymbolSh(15 downto 8)    	<= rSymbolSh(7 downto 0);  
					rSymbolSh(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rSymbolSh(47 downto 0)		<= rSymbolSh(47 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSymbolSh;

	u_rSecIndic : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSecIndic(4 downto 0)	<= "00000";
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rSecIndic(4 downto 0)	<= "00000";
				
				-- ** conraining data check via corresponding SecID or Symbol
				-- bit 0: set when incoming message contains data of Sec0 
				elsif ( SecValid(0)='1' and 
						((rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						 rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and rSymbolSh(47 downto 0)=SecSymbol0) or
						(rBinOutVal='1' and rWaitSecId='1' and rBinOutData(15 downto 0)=SrcId0)) ) then
					rSecIndic(4 downto 0)	<= "00001";
				
				-- bit 1: set when incoming message contains data of Sec1 
				elsif ( SecValid(1)='1' and 
						((rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						 rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and rSymbolSh(47 downto 0)=SecSymbol1) or
						(rBinOutVal='1' and rWaitSecId='1' and rBinOutData(15 downto 0)=SrcId1)) ) then
					rSecIndic(4 downto 0)	<= "00010";
	
				-- bit 2: set when incoming message contains data of Sec2 
				elsif ( SecValid(2)='1' and 
						((rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						 rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and rSymbolSh(47 downto 0)=SecSymbol2) or
						(rBinOutVal='1' and rWaitSecId='1' and rBinOutData(15 downto 0)=SrcId2)) ) then
					rSecIndic(4 downto 0)	<= "00100";
	
				-- bit 3: set when incoming message contains data of Sec3 
				elsif ( SecValid(3)='1' and 
						((rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						 rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and rSymbolSh(47 downto 0)=SecSymbol3) or
						(rBinOutVal='1' and rWaitSecId='1' and rBinOutData(15 downto 0)=SrcId3)) ) then
					rSecIndic(4 downto 0)	<= "01000";
	
				-- bit 4: set when incoming message contains data of Sec4 
				elsif ( SecValid(4)='1' and 
						((rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and 
						 rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0010") and rSymbolSh(47 downto 0)=SecSymbol4) or
						(rBinOutVal='1' and rWaitSecId='1' and rBinOutData(15 downto 0)=SrcId4)) ) then
					rSecIndic(4 downto 0)	<= "10000";
				else
					rSecIndic(4 downto 0)	<= rSecIndic(4 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSecIndic;
	
	u_rWaitSecId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSecId	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rSecIdCtrl1='0' and rSecIdCtrl2='1' ) then
					rWaitSecId	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSnapShotCtrl(8 downto 0)=('0'&"0000"&"0100") ) then
					rWaitSecId	<= '1';
				else
					rWaitSecId	<= rWaitSecId;
				end if;
			end if;
		end if;
	End Process u_rWaitSecId;
	
	u_rSecId : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 26-16 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitSecId='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rSecId(15 downto 0)		<= rBinOutData(15 downto 0);
			else
				rSecId(15 downto 0)		<= rSecId(15 downto 0);
			end if;
		end if;
	End Process u_rSecId;
	
	u_rSecIdSource : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSecIdSource(15 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rSecIdSource(15 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0000"&"1000") and
						rFixData(7 downto 0)/=cAsciiSOH ) then 
					rSecIdSource(15 downto 8)    	<= rSecIdSource(7 downto 0);  
					rSecIdSource(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rSecIdSource(15 downto 0)		<= rSecIdSource(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSecIdSource;
	
	--------------------------------------
	-- Entry Type
	--------------------------------------

	u_rNoEntries : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rNoEntries(15 downto 0)	<= (others=>'0');
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rNoEntries(15 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0001"&"0000") and
						rFixData(7 downto 0)/=cAsciiSOH ) then 
					rNoEntries(15 downto 8)    	<= rNoEntries(7 downto 0);  
					rNoEntries(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rNoEntries(15 downto 0)		<= rNoEntries(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rNoEntries;

	u_rNoEntriesError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rNoEntriesError		<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rNoEntriesError		<= '0';
				
				-- set if number of Entries is more than 2
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0001"&"0000") and
						rFixData(7 downto 0)=cAsciiSOH and 
						rNoEntries(15 downto 0)/=x"0031" and rNoEntries(15 downto 0)/=x"0032" ) then
					rNoEntriesError		<= '1';
				else
					rNoEntriesError		<= rNoEntriesError;
				end if;
			end if;
		end if;
	End Process u_rNoEntriesError;
	
	u_rEnTryTypeIndic : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rEnTryTypeIndic		<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rEnTryTypeIndic		<= '0';
				
				-- set is Entry Type is 0 (Bid)
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0010"&"0000") and
						rFixData(7 downto 0)=cAscii0 ) then 
					rEnTryTypeIndic		<= '0';
				
				-- set is Entry Type is 1 (Offer)
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0010"&"0000") and
						rFixData(7 downto 0)=cAscii1 ) then 
					rEnTryTypeIndic		<= '1';
				else
					rEnTryTypeIndic		<= rEnTryTypeIndic;
				end if;
			end if;
		end if;
	End Process u_rEnTryTypeIndic;
	
	u_rBidVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBidVal		<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rBidVal		<= '0';
				
				-- set is Entry Type is 0 (Bid)
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0010"&"0000") and
						rFixData(7 downto 0)=cAscii0 ) then 
					rBidVal		<= '1';
				
				else
					rBidVal		<= rBidVal;
				end if;
			end if;
		end if;
	End Process u_rBidVal;
	
	u_rOffVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rOffVal		<= '0';
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rOffVal		<= '0';
				
				-- set is Entry Type is 1 (Offer)
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0010"&"0000") and
						rFixData(7 downto 0)=cAscii1 ) then
					rOffVal		<= '1';
				else
					rOffVal		<= rOffVal;
				end if;
			end if;
		end if;
	End Process u_rOffVal;
	
	--------------------------------------
	-- Price
	--------------------------------------
	
	u_rPxSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPxSh(159 downto 0)	<= (others=>'0');
			else
				-- reset at the end of its field
				if ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rFixData(7 downto 0)=cAsciiSOH ) then
					rPxSh(159 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rFixData(7 downto 0)/=cAsciiSOH ) then
					rPxSh(159 downto 152)	<= rPxSh(151 downto 144);
					rPxSh(151 downto 144)	<= rPxSh(143 downto 136);
					rPxSh(143 downto 136)	<= rPxSh(135 downto 128);
					rPxSh(135 downto 128)	<= rPxSh(127 downto 120);
					rPxSh(127 downto 120)	<= rPxSh(119 downto 112);
					rPxSh(119 downto 112)	<= rPxSh(111 downto 104);
					rPxSh(111 downto 104)	<= rPxSh(103 downto 96);
					rPxSh(103 downto 96)	<= rPxSh(95 downto 88);
					rPxSh(95 downto 88)     <= rPxSh(87 downto 80);
					rPxSh(87 downto 80)     <= rPxSh(79 downto 72);
					rPxSh(79 downto 72)     <= rPxSh(71 downto 64);
					rPxSh(71 downto 64)     <= rPxSh(63 downto 56);
					rPxSh(63 downto 56)		<= rPxSh(55 downto 48);
					rPxSh(55 downto 48)   	<= rPxSh(47 downto 40);
					rPxSh(47 downto 40)   	<= rPxSh(39 downto 32);
					rPxSh(39 downto 32)   	<= rPxSh(31 downto 24);
					rPxSh(31 downto 24)   	<= rPxSh(23 downto 16);
					rPxSh(23 downto 16)   	<= rPxSh(15 downto 8); 
					rPxSh(15 downto 8)    	<= rPxSh(7 downto 0);  
					rPxSh(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rPxSh(159 downto 0)		<= rPxSh(159 downto 0);
				end if;
			end if;
		end if;
	End Process u_rPxSh;
	
	u_rPxByteCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPxByteCnt(4 downto 0)	<= "00000";
			else
				-- set when reach '=' before the 1st byte of its field 
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagPx ) then
					rPxByteCnt(4 downto 0)	<= "00001";
				
				-- increase when ots control flag is set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") ) then
					rPxByteCnt(4 downto 0)	<= rPxByteCnt(4 downto 0) + 1;
				else 
					rPxByteCnt(4 downto 0)	<= rPxByteCnt(4 downto 0);
				end if;
			end if;
		end if;
	End Process u_rPxByteCnt;
	
	u_rWaitPx : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitPx	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rPxCtrl1='0' and rPxCtrl2='1' ) then
					rWaitPx	<= '0';
					
				-- set when its control flag is going to reset and Price is not market price
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rSpecialPxFlag/='1' ) then
					rWaitPx	<= '1';
				else
					rWaitPx	<= rWaitPx;
				end if;
			end if;
		end if;
	End Process u_rWaitPx;
	
	u_rBidPx : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Bid
			-- Error will be occurred if bit 16-26 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitPx='1' and rEnTryTypeIndic='0' ) then 
				rBidPx(15 downto 0)	<= rBinOutData(15 downto 0);
			else
				rBidPx(15 downto 0)	<= rBidPx(15 downto 0);
			end if;
		end if;
	End Process u_rBidPx;
	
	u_rBidPxNeqExp : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Bid
			if ( rBinOutVal='1' and rWaitPx='1' and rEnTryTypeIndic='0' ) then 
				rBidPxNeqExp(1 downto 0)	<= rBinOutNegExp(1 downto 0);
			else
				rBidPxNeqExp(1 downto 0)	<= rBidPxNeqExp(1 downto 0);
			end if;
		end if;
	End Process u_rBidPxNeqExp;
	
	u_rOffPx : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Offer
			-- Error will be occurred if bit 16-26 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitPx='1' and rEnTryTypeIndic='1' ) then 
				rOffPx(15 downto 0)	<= rBinOutData(15 downto 0);
			else
				rOffPx(15 downto 0)	<= rOffPx(15 downto 0);
			end if;
		end if;
	End Process u_rOffPx;
	
	u_rOffPxNeqExp : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Offer
			if ( rBinOutVal='1' and rWaitPx='1' and rEnTryTypeIndic='1' ) then 
				rOffPxNeqExp(1 downto 0)	<= rBinOutNegExp(1 downto 0);
			else
				rOffPxNeqExp(1 downto 0)	<= rOffPxNeqExp(1 downto 0);
			end if;
		end if;
	End Process u_rOffPxNeqExp;
	
	u_rSpecialPxFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSpecialPxFlag	<= '0';
			else
				-- reset at the end of its field
				if ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
					 rFixData(7 downto 0)=cAsciiSOH ) then
					rSpecialPxFlag	<= '0';
				
				-- set if incoming price is market price (special case)
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rPxByteCnt(4 downto 0)=6 and
						(rPxSh(39 downto 0)=cBidMrkPx or rPxSh(39 downto 0)=cOffMrkPx) ) then
					rSpecialPxFlag	<= '1';
				
				else
					rSpecialPxFlag	<= rSpecialPxFlag;
				end if;
			end if;
		end if;
	End Process u_rSpecialPxFlag;
	
	u_rSpecialPx : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSpecialPx(1 downto 0)	<= "00";
			else
				-- reset at the end of message processing
				if ( MsgEnd='1' ) then
					rSpecialPx(1 downto 0)	<= "00";
					
				-- bit0 : set if bid price is at market price
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rFixData(7 downto 0)=cAsciiSOH and rSpecialPxFlag='1' and
						 rPxSh(63 downto 0)=cEndOfBidMrkPx ) then
					rSpecialPx(0)	<= '1';
					rSpecialPx(1)	<= rSpecialPx(1);
				
				-- bit1 : et if offer price is at market price
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('0'&"0100"&"0000") and
						rFixData(7 downto 0)=cAsciiSOH and rSpecialPxFlag='1' and
						 rPxSh(63 downto 0)=cEndOfOffMrkPx ) then
					rSpecialPx(0)	<= rSpecialPx(0);
					rSpecialPx(1)	<= '1';
				else
					rSpecialPx(1 downto 0)	<= rSpecialPx(1 downto 0);
				end if;
			end if;
		end if;
	End Process u_rSpecialPx;
	
	--------------------------------------
	-- Size
	--------------------------------------

	u_rWaitSize : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSize	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rSizeCtrl1='0' and rSizeCtrl2='1' ) then
					rWaitSize	<= '0';
					
				-- set when its control flag is going to reset and Price is not market price
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSnapShotCtrl(8 downto 0)=('0'&"1000"&"0000") ) then
					rWaitSize	<= '1';
				else
					rWaitSize	<= rWaitSize;
				end if;
			end if;
		end if;
	End Process u_rWaitSize;

	u_rBidSize : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Bid
			-- Error will be occurred if bit 31-27 of incoming Size is not all zero
			if ( rBinOutVal='1' and rWaitSize='1' and rBinOutNegExp(1 downto 0)="00" and
				 rEnTryTypeIndic='0' ) then 
				rBidSize(31 downto 27)		<= "00000";
				rBidSize(26 downto 0)		<= rBinOutData(26 downto 0);
			else
				rBidSize(31 downto 0)		<= rBidSize(31 downto 0);
			end if;
		end if;
	End Process u_rBidSize;

	u_rOffSize: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid and Entry is Offer
			-- Error will be occurred if bit 31-27 of incoming Size is not all zero
			if ( rBinOutVal='1' and rWaitSize='1' and rBinOutNegExp(1 downto 0)="00" and
				 rEnTryTypeIndic='1' ) then 
				rOffSize(31 downto 27)		<= "00000";
				rOffSize(26 downto 0)		<= rBinOutData(26 downto 0);
			else
				rOffSize(31 downto 0)		<= rOffSize(31 downto 0);
			end if;
		end if;
	End Process u_rOffSize;

	--------------------------------------
	-- Time
	--------------------------------------

	u_rTimeByteCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTimeByteCnt(3 downto 0)	<= "0000";
			else
				-- set when reach '=' before the 1st byte of its field 
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagEntryTime ) then
					rTimeByteCnt(3 downto 0)	<= "0001";
				
				-- increase when ots control flag is set
				elsif ( rFixValid='1' and rSnapShotCtrl(8 downto 0)=('1'&"0000"&"0000") ) then
					rTimeByteCnt(3 downto 0)	<= rTimeByteCnt(3 downto 0) + 1;
				else 
					rTimeByteCnt(3 downto 0)	<= rTimeByteCnt(3 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTimeByteCnt;

	u_rTimeHourSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert 1st byte of hour into bin, collect the value in bit 15-8
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=1 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rTimeHourSh(15 downto 0)	<= x"0000"; -- < 10
					when cAscii1	=> rTimeHourSh(15 downto 0)	<= x"0a00";	-- 10
					when cAscii2	=> rTimeHourSh(15 downto 0)	<= x"1400"; -- 20
					When others		=> rTimeHourSh(15 downto 0)	<= x"FF00"; -- error case
				end case; 
			-- convert 2nd byte of hour into bin, collect the value in bit 7-0
			elsif ( rFixValid='1' and rTimeByteCnt(3 downto 0)=2 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"00";
					when cAscii1	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"01";
					when cAscii2	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"02";
					when cAscii3	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"03";
					when cAscii4	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"04";
					when cAscii5	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"05";
					when cAscii6	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"06";
					when cAscii7	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"07";
					when cAscii8	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"08";
					when cAscii9	=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"09";
					When others		=> rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 8) & x"FF"; -- error case
				end case;
			else
				rTimeHourSh(15 downto 0)	<= rTimeHourSh(15 downto 0);
			end if;
		end if;
	End Process u_rTimeHourSh;

	u_rBidTimeHour : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- if Entry is Bid, add 1st and 2nd bytes of hour in bin togather
			-- bit 5-7 of sum must be all zero
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=3 and rEnTryTypeIndic='0' ) then 
				rBidTimeHour(7 downto 0)	<= rTimeHourSh(15 downto 8) + rTimeHourSh(7 downto 0);
			else
				rBidTimeHour(7 downto 0)	<= rBidTimeHour(7 downto 0);
			end if;
		end if;
	End Process u_rBidTimeHour;

	u_rOffTimeHour : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- if Entry is Offer, add 1st and 2nd bytes of hour in bin togather
			-- bit 5-7 of sum must be all zero
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=3 and rEnTryTypeIndic='1' ) then 
				rOffTimeHour(7 downto 0)	<= rTimeHourSh(15 downto 8) + rTimeHourSh(7 downto 0);
			else
				rOffTimeHour(7 downto 0)	<= rOffTimeHour(7 downto 0);
			end if;
		end if;
	End Process u_rOffTimeHour;

	u_rTimeMinSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert 1st byte of minute into bin, collect the value in bit 15-8
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=4 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rTimeMinSh(15 downto 0)	<= x"0000"; -- < 10
					when cAscii1	=> rTimeMinSh(15 downto 0)	<= x"0a00";	-- 10
					when cAscii2	=> rTimeMinSh(15 downto 0)	<= x"1400"; -- 20
					when cAscii3	=> rTimeMinSh(15 downto 0)	<= x"1e00"; -- 30
					when cAscii4	=> rTimeMinSh(15 downto 0)	<= x"2800"; -- 40
					when cAscii5	=> rTimeMinSh(15 downto 0)	<= x"3200"; -- 50
					When others		=> rTimeMinSh(15 downto 0)	<= x"FF00"; -- error case
				end case; 
			-- convert 2nd byte of minute into bin, collect the value in bit 7-0
			elsif ( rFixValid='1' and rTimeByteCnt(3 downto 0)=5 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"00";
					when cAscii1	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"01";
					when cAscii2	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"02";
					when cAscii3	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"03";
					when cAscii4	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"04";
					when cAscii5	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"05";
					when cAscii6	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"06";
					when cAscii7	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"07";
					when cAscii8	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"08";
					when cAscii9	=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"09";
					When others		=> rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 8) & x"FF"; -- error case
				end case;
			else
				rTimeMinSh(15 downto 0)	<= rTimeMinSh(15 downto 0);
			end if;
		end if;
	End Process u_rTimeMinSh;

	u_rBidTimeMin: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- when Entry is Bid, add 1st and 2nd bytes of minute in bin togather
			-- bit 6-7 of sum must be all zero
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=6 and rEnTryTypeIndic='0' ) then 
				rBidTimeMin(7 downto 0)	<= rTimeMinSh(15 downto 8) + rTimeMinSh(7 downto 0);
			else
				rBidTimeMin(7 downto 0)	<= rBidTimeMin(7 downto 0);
			end if;
		end if;
	End Process u_rBidTimeMin;

	u_rOffTimeMin: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- when Entry is Offer, add 1st and 2nd bytes of minute in bin togather
			-- bit 6-7 of sum must be all zero
			if ( rFixValid='1' and rTimeByteCnt(3 downto 0)=6 and rEnTryTypeIndic='1' ) then 
				rOffTimeMin(7 downto 0)	<= rTimeMinSh(15 downto 8) + rTimeMinSh(7 downto 0);
			else
				rOffTimeMin(7 downto 0)	<= rOffTimeMin(7 downto 0);
			end if;
		end if;
	End Process u_rOffTimeMin;

	u_rWaitSec : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSec	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' ) then
					rWaitSec	<= '0';
					
				-- set when its control flag is going to reset and Price is not market price
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSnapShotCtrl(8 downto 0)=('1'&"0000"&"0000") ) then
					rWaitSec	<= '1';
				else
					rWaitSec	<= rWaitSec;
				end if;
			end if;
		end if;
	End Process u_rWaitSec;

	u_rBidTimeSec : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid, Entry must be Bid
			-- Error will be occurred if bit 126-6 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitSec='1' and rEnTryTypeIndic='0' ) then 
				rBidTimeSec(15 downto 0)	<= rBinOutData(15 downto 0);
			else
				rBidTimeSec(15 downto 0)	<= rBidTimeSec(15 downto 0);
			end if;
		end if;
	End Process u_rBidTimeSec;
	
	u_rBidTimeSecNegExp : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid, Entry must be Bid
			if ( rBinOutVal='1' and rWaitSec='1' and rEnTryTypeIndic='0' ) then 
				rBidTimeSecNegExp(1 downto 0)	<= rBinOutNegExp(1 downto 0);
			else
				rBidTimeSecNegExp(1 downto 0)	<= rBidTimeSecNegExp(1 downto 0);
			end if;
		end if;
	End Process u_rBidTimeSecNegExp;

	u_rOffTimeSec : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid, Entry must be Offer
			-- Error will be occurred if bit 126-6 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitSec='1' and rEnTryTypeIndic='1' ) then 
				rOffTimeSec(15 downto 0)	<= rBinOutData(15 downto 0);
			else
				rOffTimeSec(15 downto 0)	<= rOffTimeSec(15 downto 0);
			end if;
		end if;
	End Process u_rOffTimeSec;
	
	u_rOffTimeSecNegExp : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid, Entry must be Offer
			if ( rBinOutVal='1' and rWaitSec='1' and rEnTryTypeIndic='1' ) then 
				rOffTimeSecNegExp(1 downto 0)	<= rBinOutNegExp(1 downto 0);
			else
				rOffTimeSecNegExp(1 downto 0)	<= rOffTimeSecNegExp(1 downto 0);
			end if;
		end if;
	End Process u_rOffTimeSecNegExp;


End Architecture rt1;