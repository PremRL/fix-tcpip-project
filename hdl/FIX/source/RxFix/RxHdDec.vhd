----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		RxHdDec.vhd
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
--	1. This module extracts and decodes FIX header/Trailer, then send the deooded data to contro unit.
-- 	2. Module decides whether Message will be dropped or accepted by checking BeginString/SenderId/TargetID.
--	   If any stated field is uncorrect, the message will be dropped. 
--	3. All integer and floating value is converted to be Bin signal.
--	4. All ASCII String has not been converted.	
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxHdDec Is
Port
(
	RstB				: in	std_logic;
	Clk					: in	std_logic; 
	
	-- Input from User
	UserValid 			: in	std_logic;
	UserSenderId		: in 	std_logic_vector( 103 downto 0 );	--x"00_0000_0000_0000_0000_0053_4554";	-- '0 0000 0000 0SET'
	UserTargetId		: in 	std_logic_vector( 103 downto 0 );   --x"30_3031_355f_4649_585f_4d44_3530";	-- '0 015_ FIX_ MD50'
	
	--	Input from RxTCP and TPU
	FixSOP				: in	std_logic;		-- no use
	FixValid			: in	std_logic;
	FixEOP				: in	std_logic;		-- no use
	FixData				: in	std_logic_vector( 7 downto 0 );
	TCPConnect			: in	std_logic;
	ExpSeqNum			: in 	std_logic_vector( 31 downto 0 );
	
	--	from MsgDec modules
	MsgDecCtrlFlag 		: in	std_logic_vector( 24 downto 0 );
		-- TestReqCtrlFlag		: in	std_logic;
		-- LogOnCtrlFlag		: in	std_logic_vector( 5 downto 0 );
		-- SnapShotCtrlFlag		: in	std_logic_vector( 8 downto 0 );
		-- ResentReqCtrlFlag	: in	std_logic_vector( 1 downto 0 );
		-- RejectCtrlFlag		: in	std_logic_vector( 4 downto 0 );		-- include text
		-- SeqRstCtrlFlag		: in	std_logic_vector( 1 downto 0 );
	EncryptMetError		: in	std_logic;
	AppVerIdError		: in	std_logic;
	ResetSeqNumFlag		: in 	std_logic;
	
	-- To user
	MsgVal2User			: out 	std_logic_vector( 7 downto 0 ); 	-- check with all error
	
	-- To MsgDec module
	TypePermit			: out	std_logic_vector( 7 downto 0 );	
	MsgEnd				: out 	std_logic;
	FieldLenCnt			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
	
	-- To control unit (via module daptor)
	MsgTypeVal			: out 	std_logic_vector( 7 downto 0 );	
	BLenError			: out 	std_logic;
	CSumError			: out 	std_logic;
	
	TagError			: out 	std_logic;
	ErrorTagLatch		: out	std_logic_vector( 31 downto 0 );
	ErrorTagLen			: out	std_logic_vector( 5 downto 0 );		-- update 21/02/2021
	SeqNumError			: out	std_logic;
	
		-- decodeed data from header
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
End Entity RxHdDec;

Architecture rt1 Of RxHdDec Is

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
	
	constant cTagBeginStr		: std_logic_vector( 31 downto 0 )	:= x"0000_0038";	-- '00 08'
	constant cTagBLen			: std_logic_vector( 31 downto 0 )	:= x"0000_0039";	-- '00 09'
	constant cTagMsgType		: std_logic_vector( 31 downto 0 )	:= x"0000_3335";	-- '00 35'
	constant cTagSenderId		: std_logic_vector( 31 downto 0 )	:= x"0000_3439";	-- '00 49'
	constant cTagTargetId		: std_logic_vector( 31 downto 0 )	:= x"0000_3536";	-- '00 46'
	constant cTagSeqNum			: std_logic_vector( 31 downto 0 )	:= x"0000_3334";	-- '00 34'
	constant cTagPossDup		: std_logic_vector( 31 downto 0 )	:= x"0000_3433";	-- '00 43'
	constant cTagSendTime		: std_logic_vector( 31 downto 0 )	:= x"0000_3532";	-- '00 52'
	constant cTagSeqNumProc		: std_logic_vector( 31 downto 0 )	:= x"0033_3639";	-- '03 69'
	constant cTagCsum			: std_logic_vector( 31 downto 0 )	:= x"0000_3130";	-- '00 10'
	
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
	signal	rWaitBLen			: std_logic;		
	signal	rWaitSeqNum			: std_logic;
	signal	rWaitSeqNumProc		: std_logic;
	signal	rWaitYear			: std_logic;
	signal	rWaitSec			: std_logic;
	signal	rWaitCSum			: std_logic;
	
	-- delay signal to verify Ascii2Bin output for each rWait
	signal	rBLenCtrl1			: std_logic;
	signal	rBLenCtrl2			: std_logic;
	signal	rSeqNumCtrl1		: std_logic;
	signal	rSeqNumCtrl2		: std_logic;
	signal	rSeqNumProcCtrl1	: std_logic;
	signal	rSeqNumProcCtrl2	: std_logic;
		-- SendTime is not included because of the fixed pattern
	
	-- Tag indication & field Cnt
	signal	rTagIndic			: std_logic;
	signal	rTagSh				: std_logic_vector( 31 downto 0 );
	signal 	rMsgEnd				: std_logic;
	signal	rFieldLenCnt		: std_logic_vector( 5 downto 0 );	-- update 21/02/2021
	
	-- Control Flag
	signal	rBeginStrCtrl		: std_logic;	-- bit 0 of CtrlFlag	
	signal	rBLenCtrl			: std_logic;	-- bit 1 of CtrlFlag
	signal	rMsgTypeCtrl		: std_logic;    -- bit 2 of CtrlFlag
	signal	rSenderIdCtrl		: std_logic;    -- bit 3 of CtrlFlag
	signal	rTargetIdCtrl		: std_logic;    -- bit 4 of CtrlFlag
	signal	rSeqNumCtrl			: std_logic;    -- bit 5 of CtrlFlag
	signal	rPossDupCtrl		: std_logic; 	-- bit 6 of CtrlFlag
	signal 	rSendTimeCtrl		: std_logic;    -- bit 7 of CtrlFlag
	signal 	rSeqNumProcCtrl		: std_logic;    -- bit 8 of CtrlFlag
	signal 	rCSumCtrl			: std_logic;    -- bit 9 of CtrlFlag

	-- MsgType Valid at the end of Msg
	signal	rMsgTypeVal			: std_logic_vector( 7 downto 0 );
	signal	rMsgVal2User		: std_logic_vector( 7 downto 0 );

	-- body length
	signal	rBLenLatch			: std_logic_vector( 15 downto 0 );
	signal	rBLenAddFlag		: std_logic;
	signal	rBLenCnt			: std_logic_vector( 15 downto 0 );
	signal	rBLenVal			: std_logic;
	
	-- message type indication
	signal	rMgsTypeSh			: std_logic_vector( 15 downto 0 );
	signal	rMgsTypeLatch		: std_logic_vector( 15 downto 0 );
	signal	rTypePermit			: std_logic_vector( 7 downto 0 );
	
	-- Csum
	signal	rCSumAddFlag		: std_logic;
	signal	rCSum				: std_logic_vector( 7 downto 0 );
	signal	rCSumVal			: std_logic;
	
	-- Other in header
	signal	rHdSeq				: std_logic_vector( 2 downto 0 );
	signal	rBeginStrSh			: std_logic_vector( 63 downto 0 );
	signal	rBeginStrVal		: std_logic;
	
	signal	rCompIdSh			: std_logic_vector( 103 downto 0 );
	signal	rSenderIdVal		: std_logic;
	signal	rTargetIdVal		: std_logic;
	
	signal	rSeqNumLatch		: std_logic_vector( 31 downto 0 );
	
	signal	rPossDupFlag		: std_logic;
	
	signal	rTimeByteCnt		: std_logic_vector( 4 downto 0 );
	signal	rYear				: std_logic_vector( 10 downto 0 );	-- NegExp must be 0
	signal	rMonth				: std_logic_vector( 3 downto 0 );
	signal	rDay				: std_logic_vector( 7 downto 0 );
	signal	rHour				: std_logic_vector( 7 downto 0 );
	signal	rMin				: std_logic_vector( 7 downto 0 );
	signal	rSec				: std_logic_vector( 15 downto 0 );
	signal	rSecNegExp			: std_logic_vector( 1 downto 0 );
	
	signal	rMonthSh			: std_logic_vector( 15 downto 0 );
	signal	rDaySh				: std_logic_vector( 15 downto 0 );
	signal	rHourSh				: std_logic_vector( 15 downto 0 );
	signal	rMinSh				: std_logic_vector( 15 downto 0 );
	
	signal	rSeqNumProcLatch	: std_logic_vector( 31 downto 0 );
	
	-- Tag error
	signal	rTagLatch			: std_logic_vector( 31 downto 0 );
	signal	rErrorTag			: std_logic_vector( 31 downto 0 );
	signal	rErrorTagLen		: std_logic_vector( 5 downto 0 );	-- update 21/02/2021
	signal	rTagError			: std_logic;
	
	signal	rErrorTagCntDelay	: std_logic_vector( 1 downto 0 );	-- update 21/02/2021
	signal	rTag1stByte			: std_logic;                        -- update 21/02/2021
	signal	rTag2ndByte			: std_logic;                        -- update 21/02/2021
	signal	rTag3rdByte			: std_logic;                        -- update 21/02/2021
	signal	rTag4thByte			: std_logic;                        -- update 21/02/2021
	
	signal	rSeqNumError		: std_logic;
	
Begin

----------------------------------------------------------------------------------
-- Component Mapping
----------------------------------------------------------------------------------

	u_Ascii2Bin0: Ascii2Bin
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

	MsgTypeVal			<= rMsgTypeVal	;
	MsgVal2User			<= rMsgVal2User	;
	TypePermit			<= rTypePermit	;
	MsgEnd				<= rMsgEnd		;
	--BeginStrVal		  <= rBeginStrVal	;
	--SenderIdVal         <= rSenderIdVal ;
	--TargetIdVal         <= rTargetIdVal	;
	BLenerror			<= not rBLenVal		;
	CSumerror		    <= not rCSumVal		;
	TagError		    <= rTagError	;	
	ErrorTagLatch	    <= rErrorTag	;
	ErrorTagLen			<= rErrorTagLen	;
	FieldLenCnt			<= rFieldLenCnt	;
	SeqNumError			<= rSeqNumError	;
	
	SeqNum				<= rSeqNumLatch		;
	PossDupFlag	        <= rPossDupFlag     ;
	TimeYear		    <= rYear		    ;
	TimeMonth		    <= rMonth		    ;
	TimeDay			    <= rDay(4 downto 0)	;
	TimeHour		    <= rHour(4 downto 0);
	TimeMin			    <= rMin(5 downto 0)	;
	TimeSec			    <= rSec		        ;
	TimeSecNegExp	    <= rSecNegExp	    ;
	
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
	u_BLenCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rBLenCtrl1	<= rBLenCtrl;		-- 1 FF
			rBLenCtrl2	<= rBLenCtrl1;		-- 2 FF
		end if;
	End Process u_BLenCtrlFF;
	
	u_SeqNumCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rSeqNumCtrl1	<= rSeqNumCtrl;		-- 1 FF
			rSeqNumCtrl2	<= rSeqNumCtrl1;	-- 2 FF
		end if;
	End Process u_SeqNumCtrlFF;
	
	u_SeqNumProcCtrlFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add FF to input
			rSeqNumProcCtrl1	<= rSeqNumProcCtrl;		-- 1 FF
			rSeqNumProcCtrl2	<= rSeqNumProcCtrl1;	-- 2 FF
		end if;
	End Process u_SeqNumProcCtrlFF;
	
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
					( 	rTagSh(31 downto 0)=cTagBLen or
						rTagSh(31 downto 0)=cTagSeqNum or
						rTagSh(31 downto 0)=cTagSeqNumProc or
						rTagSh(31 downto 0)=cTagSendTime or
						rTagSh(31 downto 0)=cTagCsum ) ) then
					rAsciiInSop		<='1';
				
				-- case: second decoding in sending time
				elsif ( rFixValid='1' and rTimeByteCnt(4 downto 0)=15 ) then
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
					-- ( 	rTagSh(31 downto 0)=cTagBLen or
						-- rTagSh(31 downto 0)=cTagSeqNum or
						-- rTagSh(31 downto 0)=cTagSeqNumProc or
						-- rTagSh(31 downto 0)=cTagSendTime or
						-- rTagSh(31 downto 0)=cTagCsum ) ) then
					-- rAsciiInVal	<= '1';
				
				-- -- while feeding data into Ascii2Bin, Asciivalid must accords with Fixvalid
				-- elsif ( rBLenCtrl='1' or rSeqNumCtrl='1' or
						-- rSeqNumProcCtrl='1' or rSendTimeCtrl='1' or rCSumCtrl='1' ) then
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
			-- fake data to end year decoding in sending time
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=4 ) then
				rAsciiInData(7 downto 0)	<= cAsciiSOH;
				
			-- still feed fake data till valid is come
			elsif ( rAsciiInVal='0' and rTimeByteCnt(4 downto 0)=5 ) then
				rAsciiInData(7 downto 0)	<= rAsciiInData(7 downto 0);
			else
				rAsciiInData(7 downto 0)	<= FixData(7 downto 0);
			end if;
		end if;
	End Process u_rAsciiInData;
	
----------------------------------------------------------------------------------
-- Tag indication and Field count
----------------------------------------------------------------------------------
	
	u_rTagIndic : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTagIndic	<= '1';		-- Error when first by is not real Fix data --> should not be occurred
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
				elsif ( TCPConnect='1' and rFixValid='1' and rTagIndic='1' ) then
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
	
	u_rFieldLenCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- increase when a field is fed by control flag checking
			if ( rFixValid='1' and (
					rBeginStrCtrl='1'	or rBLenCtrl='1' 		or
					rMsgTypeCtrl='1'	or rSenderIdCtrl='1' 	or
					rTargetIdCtrl='1'	or rSeqNumCtrl='1'		or
					rPossDupCtrl='1'	or rSendTimeCtrl='1'	or
					rSeqNumProcCtrl='1'	or	rCSumCtrl='1'		or
					MsgDecCtrlFlag(24 downto 0)/=('0'&x"000000")) and
					rFixData(7 downto 0)/=cAsciiSOH ) then
				rFieldLenCnt(5 downto 0)	<= rFieldLenCnt(5 downto 0) + 1 ;
			
			-- set before 1st byte of target field will start
			-- (if condition)  lower priority to avoid unexpected reset when face '=' in field.
			elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual ) then
				rFieldLenCnt(5 downto 0)	<= "000000";
			else
				rFieldLenCnt(5 downto 0)	<= rFieldLenCnt(5 downto 0);
			end if;
		end if;
	End Process u_rFieldLenCnt;
	
	u_rMsgEnd : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMsgEnd		<= '0';
			else
				-- 1-clk set when bin Csum value from Ascii2Bin is released
				-- Severe error will be occurred if Msg lacks of checksum field
				if ( rWaitCSum='1' and rBinOutVal='1' ) then
					rMsgEnd		<= '1';
				else
					rMsgEnd		<= '0';
				end if;
			end if;
		end if;
	End Process u_rMsgEnd;
	
	u_rHdSeq : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rHdSeq(2 downto 0)	<= "000";
			else
				-- reset at the end of Msg processing
				if ( rMsgEnd='1' and rBeginStrCtrl/='1' ) then
					rHdSeq(2 downto 0)	<= "000";
				
				-- special case: end of Msg processing, but the next msg is feeding
				elsif ( rMsgEnd='1' and rBeginStrCtrl='1' ) then
					rHdSeq(2 downto 0)	<= "001";
					
				-- set bit 0 when BeginString arrives
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagBeginStr ) then
					rHdSeq(2)	<= rHdSeq(2);
					rHdSeq(1)   <= rHdSeq(1);
					rHdSeq(0)   <= '1';
				
				-- set bit 1 when BodyLength arrives
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagBLen and rHdSeq(2 downto 0)="001" ) then
					rHdSeq(2)	<= rHdSeq(2);
					rHdSeq(1)   <= '1';
					rHdSeq(0)   <= rHdSeq(0);
				
				-- set bit 2 when MsgType arrives
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagMsgType and rHdSeq(2 downto 0)="011" ) then
					rHdSeq(2)	<= '1';
					rHdSeq(1)   <= rHdSeq(1);
					rHdSeq(0)   <= rHdSeq(0);
				
				else
					rHdSeq(2 downto 0)	<= rHdSeq(2 downto 0);
				end if;
			end if;
		end if;
	End Process u_rHdSeq;

----------------------------------------------------------------------------------
--	Begin String
----------------------------------------------------------------------------------

	u_rBeginStrCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBeginStrCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rBeginStrCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagBeginStr ) then
					rBeginStrCtrl	<= '1';
				else
					rBeginStrCtrl	<= rBeginStrCtrl;
				end if;
			end if;
		end if;
	End Process u_rBeginStrCtrl;
	
	u_rBeginStrSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- left shift when its control flag is set
			if ( rFixValid='1' and rBeginStrCtrl='1' ) then 
				rBeginStrSh(63 downto 56)	<= rBeginStrSh(55 downto 48);
				rBeginStrSh(55 downto 48)   <= rBeginStrSh(47 downto 40);
				rBeginStrSh(47 downto 40)   <= rBeginStrSh(39 downto 32);
				rBeginStrSh(39 downto 32)   <= rBeginStrSh(31 downto 24);
				rBeginStrSh(31 downto 24)   <= rBeginStrSh(23 downto 16);
				rBeginStrSh(23 downto 16)   <= rBeginStrSh(15 downto 8); 
				rBeginStrSh(15 downto 8)    <= rBeginStrSh(7 downto 0);  
				rBeginStrSh(7 downto 0)     <= rFixData(7 downto 0);
			else
				rBeginStrSh(63 downto 0)	<= rBeginStrSh(63 downto 0);
			end if;
		end if;
	End Process u_rBeginStrSh;

	u_rBeginStrVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBeginStrVal	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rBeginStrVal	<= '0';
					
				-- set when end of its field and value is valid
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rBeginStrSh(63 downto 0)=cFixT ) then
					rBeginStrVal	<= '1';
				else
					rBeginStrVal	<= rBeginStrVal;
				end if;
			end if;
		end if;
	End Process u_rBeginStrVal;

----------------------------------------------------------------------------------
-- Body length
----------------------------------------------------------------------------------
	
	u_rBLenCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBLenCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rBLenCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagBLen ) then
					rBLenCtrl	<= '1';
				else
					rBLenCtrl	<= rBLenCtrl;
				end if;
			end if;
		end if;
	End Process u_rBLenCtrl;
	
	u_rWaitBLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitBLen	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rBLenCtrl1='0' and rBLenCtrl2='1' ) then
					rWaitBLen	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rBLenCtrl='1' ) then
					rWaitBLen	<= '1';
				else
					rWaitBLen	<= rWaitBLen;
				end if;
			end if;
		end if;
	End Process u_rWaitBLen;
	
	u_rBLenLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 16-26 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitBLen='1' and rBinOutNegExp(1 downto 0)="00"  ) then 
				rBLenLatch(15 downto 0)		<=  rBinOutData(15 downto 0);
			else
				rBLenLatch(15 downto 0)		<=	rBLenLatch(15 downto 0);
			end if;
		end if;
	End Process u_rBLenLatch;
	
	u_rBLenAddFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBLenAddFlag	<= '0';
			else
				-- reset at the start of checksum field
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagCsum ) then
					rBLenAddFlag	<= '0'; 
					
				-- set at the start of MsgType field
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh(31 downto 0)=cTagMsgType) then
					rBLenAddFlag	<= '1';
				else
					rBLenAddFlag	<= rBLenAddFlag;
				end if;
			end if;
		end if;
	End Process u_rBLenAddFlag;
	
	u_rBLenCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBLenCnt(15 downto 0)	<= (others=>'0');
			else	
				-- set at the start of MsgType field
				-- set to be four from 3 bytes of '35=' (be 4 to syn with dataIn sequence)
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagMsgType) then
					rBLenCnt(15 downto 0)	<= x"0004";
					
				-- increase when rBLenAddFlag is set (count period)
				elsif ( rFixValid='1' and rBLenAddFlag='1' ) then
					rBLenCnt(15 downto 0)	<= rBLenCnt(15 downto 0) + 1;
				else
					rBLenCnt(15 downto 0)	<= rBLenCnt(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rBLenCnt;
	
	u_rBLenVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBLenVal	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then 
					rBLenVal	<= '0';
					
				-- checking the Body length at the start of CSum field
				-- set if the condition is valid
				-- counter is deducted by 3 from 3 bytes of '10='
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh(31 downto 0)=cTagCsum and
						rBLenLatch(15 downto 0)=(rBLenCnt(15 downto 0)-3) ) then
					rBLenVal	<= '1';
				else
					rBLenVal	<= rBLenVal;
				end if;
			end if;
		end if;
	End Process u_rBLenVal;
	
----------------------------------------------------------------------------------
--	Message type
----------------------------------------------------------------------------------

	u_rMsgTypeCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMsgTypeCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rMsgTypeCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagMsgType ) then
					rMsgTypeCtrl	<= '1';
				else
					rMsgTypeCtrl	<= rMsgTypeCtrl;
				end if;
			end if;
		end if;
	End Process u_rMsgTypeCtrl;

	u_rMgsTypeSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMgsTypeSh(15 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rMgsTypeSh(15 downto 0)	<= (others=>'0');
				
				-- left shift when its control is set
				elsif ( rFixValid='1' and rMsgTypeCtrl='1' ) then
					rMgsTypeSh(15 downto 8)	<= rMgsTypeSh(7 downto 0);
					rMgsTypeSh(7 downto 0)	<= rFixData(7 downto 0);
				else
					rMgsTypeSh(7 downto 0)	<= rMgsTypeSh(7 downto 0);
				end if;
			end if;
		end if;
	End Process u_rMgsTypeSh;

	u_rMgsTypeLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch when the end of its field
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rMsgTypeCtrl='1' ) then
				rMgsTypeLatch(15 downto 0)	<= rMgsTypeSh(15 downto 0);
			else
				rMgsTypeLatch(15 downto 0)	<= rMgsTypeLatch(15 downto 0);
			end if;
		end if;
	End Process u_rMgsTypeLatch;

	u_rTypePermit : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTypePermit(7 downto 0)	<= (others=>'0');
			else	
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rTypePermit(7 downto 0)	<= x"00";
				
				-- set a bit according to Msgtype at the end of its field
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rMsgTypeCtrl='1' ) then
					
					case ( rMgsTypeSh(15 downto 0) ) Is
						when cTypeHeartBt 		=> rTypePermit(7 downto 0) 	<= "00000001";
						when cTypeTestReq		=> rTypePermit(7 downto 0) 	<= "00000010";
						when cTypeResentReq		=> rTypePermit(7 downto 0) 	<= "00000100";
						when cTypeReject		=> rTypePermit(7 downto 0) 	<= "00001000";
						when cTypeSeqRst		=> rTypePermit(7 downto 0) 	<= "00010000";
						when cTypeLogout		=> rTypePermit(7 downto 0) 	<= "00100000";
						when cTypeLogon			=> rTypePermit(7 downto 0) 	<= "01000000";
						when cTypeSnapShot		=> rTypePermit(7 downto 0) 	<= "10000000";
						when others				=> rTypePermit(7 downto 0)	<= "00000000";
					end case;
				else
					rTypePermit(7 downto 0)	<= rTypePermit(7 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTypePermit;
	
----------------------------------------------------------------------------------
--	Checksum
----------------------------------------------------------------------------------

	u_rCSumCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rCSumCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rCSumCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagCsum ) then
					rCSumCtrl	<= '1';
				else
					rCSumCtrl	<= rCSumCtrl;
				end if;
			end if;
		end if;
	End Process u_rCSumCtrl;
	
	u_rWaitCSum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitCSum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' ) then
					rWaitCSum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rCSumCtrl='1' ) then
					rWaitCSum	<= '1';
				else
					rWaitCSum	<= rWaitCSum;
				end if;
			end if;
		end if;
	End Process u_rWaitCSum;
	
	u_rCSumAddFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rCSumAddFlag	<= '0';
			else
				-- reset when reach the start of checksum field
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagCsum ) then
					rCSumAddFlag	<= '0';
				
				-- set at the start of Msg
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagBeginStr ) then
					rCSumAddFlag	<= '1';
				else
					rCSumAddFlag	<= rCSumAddFlag;
				end if;
			end if;
		end if;
	End Process u_rCSumAddFlag;
	
	u_rCSum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set at the start of Msg
			-- set to be x"75" from adding of '8='
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
				 rTagSh(31 downto 0)=cTagBeginStr ) then
				rCSum(7 downto 0)	<= x"75";
			
			-- when reach the checksum field, deduct itself by x"61" from '10'
			elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
				 rTagSh(31 downto 0)=cTagCsum ) then
				rCSum(7 downto 0)	<= rCSum(7 downto 0) - x"61";
				
			-- add when rCSumAddFlag is set (add period)
			elsif ( rFixValid='1' and rCSumAddFlag='1' ) then
				rCSum(7 downto 0)	<= rCSum(7 downto 0) + rFixData(7 downto 0);
			else
				rCSum(7 downto 0)	<= rCSum(7 downto 0);
			end if;
		end if;
	End Process u_rCSum;

	u_rCSumVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rCSumVal	<= '0';
			else
				-- 1-clk set when bin Csum value from Ascii2Bin is released
				-- Severe error will be occurred if bit 8-26 of rBinOutData is not all zero
				if ( rWaitCSum='1' and  rBinOutVal='1' and rBinOutNegExp(1 downto 0)="00" and 
					 rCSum(7 downto 0)=rBinOutData(7 downto 0)) then
					rCSumVal	<= '1';
				else
					rCSumVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCSumVal;
	
----------------------------------------------------------------------------------
--	Comp Id
----------------------------------------------------------------------------------

	u_rSenderIdCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSenderIdCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSenderIdCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagSenderId ) then
					rSenderIdCtrl	<= '1';
				else
					rSenderIdCtrl	<= rSenderIdCtrl;
				end if;
			end if;
		end if;
	End Process u_rSenderIdCtrl;

	u_rTargetIdCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTargetIdCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rTargetIdCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagTargetId ) then
					rTargetIdCtrl	<= '1';
				else
					rTargetIdCtrl	<= rTargetIdCtrl;
				end if;
			end if;
		end if;
	End Process u_rTargetIdCtrl;
	
	u_rCompIdSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rCompIdSh(103 downto 0)	<= (others=>'0');
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rCompIdSh(103 downto 0)	<= (others=>'0');
				
				-- left shift when control flags are set
				elsif ( rFixValid='1' and ( rSenderIdCtrl='1' or rTargetIdCtrl='1' ) ) then
					rCompIdSh(103 downto 96)	<= rCompIdSh(95 downto 88);
					rCompIdSh(95 downto 88)     <= rCompIdSh(87 downto 80);
					rCompIdSh(87 downto 80)     <= rCompIdSh(79 downto 72);
					rCompIdSh(79 downto 72)     <= rCompIdSh(71 downto 64);
					rCompIdSh(71 downto 64)     <= rCompIdSh(63 downto 56);
					rCompIdSh(63 downto 56)		<= rCompIdSh(55 downto 48);
					rCompIdSh(55 downto 48)   	<= rCompIdSh(47 downto 40);
					rCompIdSh(47 downto 40)   	<= rCompIdSh(39 downto 32);
					rCompIdSh(39 downto 32)   	<= rCompIdSh(31 downto 24);
					rCompIdSh(31 downto 24)   	<= rCompIdSh(23 downto 16);
					rCompIdSh(23 downto 16)   	<= rCompIdSh(15 downto 8); 
					rCompIdSh(15 downto 8)    	<= rCompIdSh(7 downto 0);  
					rCompIdSh(7 downto 0)     	<= rFixData(7 downto 0);
				
				else
					rCompIdSh(103 downto 0)		<= rCompIdSh(103 downto 0);
				end if;
			end if;
		end if;
	End Process u_rCompIdSh;
	
	u_rSenderIdVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSenderIdVal	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rSenderIdVal	<= '0';
				
				-- set when reach the end of its field and SenderCompID is valid
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rSenderIdCtrl='1' and UserValid='1' and
						rCompIdSh(103 downto 0)=UserSenderId(103 downto 0) ) then
					rSenderIdVal	<= '1';
				else
					rSenderIdVal	<= rSenderIdVal;
				end if;
			end if;
		end if;
	End Process u_rSenderIdVal;

	u_rTargetIdVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTargetIdVal	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rTargetIdVal	<= '0';
				
				-- set when reach the end of its field and TargetCompID is valid
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rTargetIdCtrl='1' and UserValid='1' and
						rCompIdSh(103 downto 0)=UserTargetId(103 downto 0) ) then
					rTargetIdVal	<= '1';
				else
					rTargetIdVal	<= rTargetIdVal;
				end if;
			end if;
		end if;
	End Process u_rTargetIdVal;

----------------------------------------------------------------------------------
-- Sequence number
----------------------------------------------------------------------------------

	u_rSeqNumCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSeqNumCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSeqNumCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagSeqNum ) then
					rSeqNumCtrl	<= '1';
				else
					rSeqNumCtrl	<= rSeqNumCtrl;
				end if;
			end if;
		end if;
	End Process u_rSeqNumCtrl;

	u_rWaitSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSeqNum	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rSeqNumCtrl1='0' and rSeqNumCtrl2='1' ) then
					rWaitSeqNum	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rSeqNumCtrl='1' ) then
					rWaitSeqNum	<= '1';
				else
					rWaitSeqNum	<= rWaitSeqNum;
				end if;
			end if;
		end if;
	End Process u_rWaitSeqNum;

	u_rSeqNumLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then	
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of SeqNum is not all zero
			if ( rBinOutVal='1' and rWaitSeqNum='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rSeqNumLatch(31 downto 27)	<= "00000";
				rSeqNumLatch(26 downto 0)	<= rBinOutData(26 downto 0);
			else
				rSeqNumLatch(31 downto 0)	<= rSeqNumLatch(31 downto 0);
			end if;
		end if;
	End Process u_rSeqNumLatch;
	
	u_rSeqNumError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSeqNumError	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rSeqNumError	<= '0';
				
				-- set incoming sequence number is not the expected one
				-- check the condition at the start of Csum field
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagCsum and 
						rSeqNumLatch(31 downto 0)/=ExpSeqNum and ResetSeqNumFlag='0' ) then
					rSeqNumError	<= '1';
				
				-- -- set if incoming sequence number is not the expected one
				-- elsif ( rBinOutVal='1' and rWaitSeqNum='1' and rBinOutNegExp(1 downto 0)="00" and
						-- ExpSeqNum/= ("0000" & rBinOutData(26 downto 0)) ) then
					-- rSeqNumError	<= '1';
				else
					rSeqNumError	<= rSeqNumError;
				end if;
			end if;
		end if;
	End Process u_rSeqNumError;
	
----------------------------------------------------------------------------------
-- PossDupFlag
----------------------------------------------------------------------------------

	u_rPossDupCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPossDupCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rPossDupCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagPossDup ) then
					rPossDupCtrl	<= '1';
				else
					rPossDupCtrl	<= rPossDupCtrl;
				end if;
			end if;
		end if;
	End Process u_rPossDupCtrl;

	u_rPossDupFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPossDupFlag	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rPossDupFlag	<= '0';
				
				-- set when reach the start of its field and the data is 'Y'
				elsif ( rFixValid='1' and rPossDupCtrl='1' and rFixData(7 downto 0)=cAsciiYes ) then
					rPossDupFlag	<= '1';
				else
					rPossDupFlag	<= rPossDupFlag;
				end if;
			end if;
		end if;
	End Process u_rPossDupFlag;

----------------------------------------------------------------------------------
-- Sending time
----------------------------------------------------------------------------------

	u_rSendTimeCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSendTimeCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSendTimeCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagSendTime ) then
					rSendTimeCtrl	<= '1';
				else
					rSendTimeCtrl	<= rSendTimeCtrl;
				end if;
			end if;
		end if;
	End Process u_rSendTimeCtrl;

	u_rTimeByteCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTimeByteCnt(4 downto 0)	<= "00000";
			else
				-- set when reach '=' before the 1st byte of its field 
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
					 rTagSh(31 downto 0)=cTagSendTime ) then
					rTimeByteCnt(4 downto 0)	<= "00001";
				
				-- increase when ots control flag is set
				elsif ( rFixValid='1' and rSendTimeCtrl='1' ) then
					rTimeByteCnt(4 downto 0)	<= rTimeByteCnt(4 downto 0) + 1;
				else 
					rTimeByteCnt(4 downto 0)	<= rTimeByteCnt(4 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTimeByteCnt;
	
	u_rWaitYear : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitYear	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' ) then
					rWaitYear	<= '0';
					
				-- set when reach the end of year part in sending time 
				elsif ( rFixValid='1' and rTimeByteCnt(4 downto 0)=4 ) then
					rWaitYear	<= '1';
				else
					rWaitYear	<= rWaitYear;
				end if;
			end if;
		end if;
	End Process u_rWaitYear;

	u_rYear : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 11-26 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitYear='1' and rBinOutNegExp(1 downto 0)="00" ) then 
				rYear(10 downto 0)	<= rBinOutData(10 downto 0);
			else
				rYear(10 downto 0)	<= rYear(10 downto 0);
			end if;
		end if;
	End Process u_rYear;
	
	u_rMonthSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- left shift when month parts in sending time are fed
			if ( rFixValid='1' and 
				(rTimeByteCnt(4 downto 0)=5 or rTimeByteCnt(4 downto 0)=6) ) then
				rMonthSh(15 downto 8)	<= rMonthSh(7 downto 0);
				rMonthSh(7 downto 0)	<= rFixData(7 downto 0);
			else
				rMonthSh(15 downto 0)	<= rMonthSh(15 downto 0);
			end if;
		end if;
	End Process u_rMonthSh;
	
	u_rMonth : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert Ascii to bin via mux when reach the end of month parts in sending time
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=7 ) then 
				case ( rMonthSh(15 downto 0) ) Is 
					When cMonJan	=> rMonth(3 downto 0)	<= x"1";
					When cMonFeb	=> rMonth(3 downto 0)	<= x"2";
					When cMonMar	=> rMonth(3 downto 0)	<= x"3";
					When cMonArp	=> rMonth(3 downto 0)	<= x"4";
					When cMonMay	=> rMonth(3 downto 0)	<= x"5";
					When cMonJun	=> rMonth(3 downto 0)	<= x"6";
					When cMonJul	=> rMonth(3 downto 0)	<= x"7";
					When cMonAug	=> rMonth(3 downto 0)	<= x"8";
					When cMonSep	=> rMonth(3 downto 0)	<= x"9";
					When cMonOct	=> rMonth(3 downto 0)	<= x"a";
					When cMonNov	=> rMonth(3 downto 0)	<= x"b";
					When cMonDec	=> rMonth(3 downto 0)	<= x"c";
					When others		=> rMonth(3 downto 0)	<= x"0"; -- error case
				end case; 
			else
				rMonth(3 downto 0)	<= rMonth(3 downto 0);
			end if;
		end if;
	End Process u_rMonth;
	
	u_rDaySh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert 1st byte of day into bin, collect the value in bit 8-15
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=7 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rDaySh(15 downto 0)	<= x"0000"; -- < 10
					when cAscii1	=> rDaySh(15 downto 0)	<= x"0a00";	-- 10
					when cAscii2	=> rDaySh(15 downto 0)	<= x"1400"; -- 20
					when cAscii3	=> rDaySh(15 downto 0)	<= x"1e00"; -- 30
					When others		=> rDaySh(15 downto 0)	<= x"FF00"; -- error case
				end case; 
			-- convert 2nd byte of day into bin, collect the value in bit 0-7
			elsif ( rFixValid='1' and rTimeByteCnt(4 downto 0)=8 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"00";
					when cAscii1	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"01";
					when cAscii2	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"02";
					when cAscii3	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"03";
					when cAscii4	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"04";
					when cAscii5	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"05";
					when cAscii6	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"06";
					when cAscii7	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"07";
					when cAscii8	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"08";
					when cAscii9	=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"09";
					When others		=> rDaySh(15 downto 0)	<= rDaySh(15 downto 8) & x"FF"; -- error case
				end case;
			else
				rDaySh(15 downto 0)	<= rDaySh(15 downto 0);
			end if;
		end if;
	End Process u_rDaySh;
	
	u_rDay : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add 1st and 2nd bytes of day in bin togather
			-- bit 5-7 of rDay must be all zero
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=9 ) then 
				rDay(7 downto 0)	<= rDaySh(15 downto 8) + rDaySh(7 downto 0);
			else
				rDay(7 downto 0)	<= rDay(7 downto 0);
			end if;
		end if;
	End Process u_rDay;
	
	u_rHourSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert 1st byte of hour into bin, collect the value in bit 8-15
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=10 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rHourSh(15 downto 0)	<= x"0000"; -- < 10
					when cAscii1	=> rHourSh(15 downto 0)	<= x"0a00";	-- 10
					when cAscii2	=> rHourSh(15 downto 0)	<= x"1400"; -- 20
					When others		=> rHourSh(15 downto 0)	<= x"FF00"; -- error case
				end case; 
			-- convert 2nd byte of hour into bin, collect the value in bit 0-7
			elsif ( rFixValid='1' and rTimeByteCnt(4 downto 0)=11 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"00";
					when cAscii1	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"01";
					when cAscii2	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"02";
					when cAscii3	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"03";
					when cAscii4	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"04";
					when cAscii5	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"05";
					when cAscii6	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"06";
					when cAscii7	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"07";
					when cAscii8	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"08";
					when cAscii9	=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"09";
					When others		=> rHourSh(15 downto 0)	<= rHourSh(15 downto 8) & x"FF"; -- error case
				end case;
			else
				rHourSh(15 downto 0)	<= rHourSh(15 downto 0);
			end if;
		end if;
	End Process u_rHourSh;
	
	u_rHour : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add 1st and 2nd bytes of hour in bin togather
			-- bit 5-7 of rHour must be all zero
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=12 ) then 
				rHour(7 downto 0)	<= rHourSh(15 downto 8) + rHourSh(7 downto 0);
			else
				rHour(7 downto 0)	<= rHour(7 downto 0);
			end if;
		end if;
	End Process u_rHour;
	
	u_rMinSh : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- convert 1st byte of minute into bin, collect the value in bit 8-15
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=13 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rMinSh(15 downto 0)	<= x"0000"; -- < 10
					when cAscii1	=> rMinSh(15 downto 0)	<= x"0a00";	-- 10
					when cAscii2	=> rMinSh(15 downto 0)	<= x"1400"; -- 20
					when cAscii3	=> rMinSh(15 downto 0)	<= x"1e00"; -- 30
					when cAscii4	=> rMinSh(15 downto 0)	<= x"2800"; -- 40
					when cAscii5	=> rMinSh(15 downto 0)	<= x"3200"; -- 50
					When others		=> rMinSh(15 downto 0)	<= x"FF00"; -- error case
				end case; 
			-- convert 2nd byte of minute into bin, collect the value in bit 0-7
			elsif ( rFixValid='1' and rTimeByteCnt(4 downto 0)=14 ) then
				case ( rFixData(7 downto 0) ) Is
					when cAscii0	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"00";
					when cAscii1	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"01";
					when cAscii2	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"02";
					when cAscii3	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"03";
					when cAscii4	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"04";
					when cAscii5	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"05";
					when cAscii6	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"06";
					when cAscii7	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"07";
					when cAscii8	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"08";
					when cAscii9	=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"09";
					When others		=> rMinSh(15 downto 0)	<= rMinSh(15 downto 8) & x"FF"; -- error case
				end case;
			else
				rMinSh(15 downto 0)	<= rMinSh(15 downto 0);
			end if;
		end if;
	End Process u_rMinSh;
	
	u_rMin : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- add 1st and 2nd bytes of minute in bin togather
			-- bit 6-7 of rMin must be all zero
			if ( rFixValid='1' and rTimeByteCnt(4 downto 0)=15 ) then 
				rMin(7 downto 0)	<= rMinSh(15 downto 8) + rMinSh(7 downto 0);
			else
				rMin(7 downto 0)	<= rMin(7 downto 0);
			end if;
		end if;
	End Process u_rMin;
	
	u_rWaitSec : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSec	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' ) then
					rWaitSec	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rSendTimeCtrl='1' ) then
					rWaitSec	<= '1';
				else
					rWaitSec	<= rWaitSec;
				end if;
			end if;
		end if;
	End Process u_rWaitSec;

	u_rSec : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 16-26 of rBinOutData is not all zero
			if ( rBinOutVal='1' and rWaitSec='1' ) then 
				rSec(15 downto 0)	<= rBinOutData(15 downto 0);
			else
				rSec(15 downto 0)	<= rSec(15 downto 0);
			end if;
		end if;
	End Process u_rSec;
	
	u_rSecNegExp : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid
			if ( rBinOutVal='1' and rWaitSec='1' ) then 
				rSecNegExp(1 downto 0)	<= rBinOutNegExp(1 downto 0);
			else
				rSecNegExp(1 downto 0)	<= rSecNegExp(1 downto 0);
			end if;
		end if;
	End Process u_rSecNegExp;

----------------------------------------------------------------------------------
-- Last sequence number processed 
----------------------------------------------------------------------------------
	
	u_rSeqNumProcCtrl : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSeqNumProcCtrl	<= '0';
			else
				-- reset when reach SOH
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH ) then
					rSeqNumProcCtrl	<= '0';
					
				-- set when reach '=' before the 1st byte of its field 
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual and
						rTagSh( 31 downto 0)=cTagSeqNumProc ) then
					rSeqNumProcCtrl	<= '1';
				else
					rSeqNumProcCtrl	<= rSeqNumProcCtrl;
				end if;
			end if;
		end if;
	End Process u_rSeqNumProcCtrl;
	
	u_rWaitSeqNumProc : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWaitSeqNumProc	<= '0';
			else
				-- reset when Ascii2Bin releases out-valid
				if ( rBinOutVal='1' and rSeqNumProcCtrl1='0' and rSeqNumProcCtrl2='1' ) then
					rWaitSeqNumProc	<= '0';
					
				-- set when its control flag is going to reset
				elsif ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and rSeqNumProcCtrl='1' ) then
					rWaitSeqNumProc	<= '1';
				else
					rWaitSeqNumProc	<= rWaitSeqNumProc;
				end if;
			end if;
		end if;
	End Process u_rWaitSeqNumProc;
	
	u_rSeqNumProcLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch bin value when Ascii2Bin decoder releases its valid
			-- Error will be occurred if bit 27-31 of rSeqNumProcLatch is not all zero
			if ( rBinOutVal='1' and rWaitSeqNumProc='1' ) then 
				rSeqNumProcLatch(31 downto 27)	<= "00000";
				rSeqNumProcLatch(26 downto 0)	<= rBinOutData(26 downto 0);
			else
				rSeqNumProcLatch(31 downto 0)	<= rSeqNumProcLatch(31 downto 0);
			end if;
		end if;
	End Process u_rSeqNumProcLatch;
	
----------------------------------------------------------------------------------
-- Tag error detection
-- Begin String Tag Error can not be detected if the 2nd message is fed suddenly 
-- after the end of 1st message. In this case, 2nd message will be dropped by incorrect  Begin String.
----------------------------------------------------------------------------------
	
	u_rTagLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTagLatch(31 downto 0)	<= (others=>'0');
			else
				-- latch when reach the end of each tag (at '=')
				if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiEqual ) then
					rTagLatch(31 downto 0)	<= rTagSh(31 downto 0);
				else
					rTagLatch(31 downto 0)	<= rTagLatch(31 downto 0);
				end if;
			end if;	
		end if;
	End Process u_rTagLatch;
	
	u_rTagError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTagError	<= '0';
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then 
					rTagError	<= '0'; 
				
				-- set when unknown tag is detected via all zero control flags
				elsif ( TCPConnect='1' and rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
						rBeginStrCtrl='0'	and rBLenCtrl='0' 		and
						rMsgTypeCtrl='0'	and rSenderIdCtrl='0' 	and
						rTargetIdCtrl='0'	and rSeqNumCtrl='0'		and
						rPossDupCtrl='0'	and rSendTimeCtrl='0'	and
						rSeqNumProcCtrl='0'	and	rCSumCtrl='0'		and
						MsgDecCtrlFlag(24 downto 0)=('0'&x"000000") ) then
					rTagError	<= '1';
				else
					rTagError	<= rTagError;
				end if;
			end if;
		end if;
	End Process u_rTagError;
	
	u_rErrorTag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch when unknown tag is detected via all zero control flags
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rBeginStrCtrl='0'		and rBLenCtrl='0' 		and
				 rMsgTypeCtrl='0'		and rSenderIdCtrl='0' 	and
				 rTargetIdCtrl='0'		and rSeqNumCtrl='0'		and
				 rPossDupCtrl='0'		and rSendTimeCtrl='0'	and
				 rSeqNumProcCtrl='0'	and	rCSumCtrl='0'		and
				 MsgDecCtrlFlag(24 downto 0)= '0'&x"000000" ) then
				rErrorTag(31 downto 0)	<= rTagLatch(31 downto 0);
			else
				rErrorTag(31 downto 0)	<= rErrorTag(31 downto 0);
			end if;
		end if;
	End Process u_rErrorTag;
	
	-----------------------------------
	-- special case: error tag latch length checking
	-----------------------------------
	
	u_rErrorTagCntDelay : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set when unknown tag is detected via all zero control flags
			if ( rFixValid='1' and rFixData(7 downto 0)=cAsciiSOH and
				 rBeginStrCtrl='0'		and rBLenCtrl='0' 		and
				 rMsgTypeCtrl='0'		and rSenderIdCtrl='0' 	and
				 rTargetIdCtrl='0'		and rSeqNumCtrl='0'		and
				 rPossDupCtrl='0'		and rSendTimeCtrl='0'	and
				 rSeqNumProcCtrl='0'	and	rCSumCtrl='0'		and
				 MsgDecCtrlFlag(24 downto 0)= '0'&x"000000" ) then
				rErrorTagCntDelay(1 downto 0)	<= "01";
			
			-- increase every clk after set, till reach self=3
			elsif ( rErrorTagCntDelay(1 downto 0)=1 or rErrorTagCntDelay(1 downto 0)=2 ) then
				rErrorTagCntDelay(1 downto 0)	<= rErrorTagCntDelay(1 downto 0) + 1;
			else
				rErrorTagCntDelay(1 downto 0)	<= rErrorTagCntDelay(1 downto 0);
			end if;
		end if;
	End Process u_rErrorTagCntDelay;
	
	u_rTag1stByte : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set 1 when 
			if ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(7 downto 0)/=x"00" ) then 
				rTag1stByte		<= '1';
			-- set 0 when 
			elsif ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(7 downto 0)=x"00" ) then 
				rTag1stByte		<= '0';
			else
				rTag1stByte		<= rTag1stByte;
			end if;
		end if;
	End Process u_rTag1stByte;

	u_rTag2ndByte : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set 1 when 
			if ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(15 downto 8)/=x"00" ) then 
				rTag2ndByte		<= '1';
			-- set 0 when 
			elsif ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(15 downto 8)=x"00" ) then 
				rTag2ndByte		<= '0';
			else
				rTag2ndByte		<= rTag2ndByte;
			end if;
		end if;
	End Process u_rTag2ndByte;
	
	u_rTag3rdByte : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set 1 when 
			if ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(23 downto 16)/=x"00" ) then 
				rTag3rdByte		<= '1';
			-- set 0 when 
			elsif ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(23 downto 16)=x"00" ) then 
				rTag3rdByte		<= '0';
			else
				rTag3rdByte		<= rTag3rdByte;
			end if;
		end if;
	End Process u_rTag3rdByte;
	
	u_rTag4thByte : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- set 1 when 
			if ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(31 downto 24)/=x"00" ) then 
				rTag4thByte		<= '1';
			-- set 0 when 
			elsif ( rErrorTagCntDelay(1 downto 0)=1 and rErrorTag(31 downto 24)=x"00" ) then 
				rTag4thByte		<= '0';
			else
				rTag4thByte		<= rTag4thByte;
			end if;
		end if;
	End Process u_rTag4thByte;
	
	u_rErrorTagLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rErrorTagLen(5 downto 0)	<= "000000";
			else
				-- reset at the end of message processing
				if ( rMsgEnd='1' ) then
					rErrorTagLen(5 downto 0)	<= "000000";
				
				-- calculate Error tag length when rErrorTagCntDelay is 2
				-- the result will ready simultaneously with MsgEnd and MsgTypeValid
				elsif ( rErrorTagCntDelay(1 downto 0)=2 ) then
					-- Byte4th is the highest priority
					if ( rTag4thByte='1' ) then 
						rErrorTagLen(5 downto 0)	<= "000100";	-- 4
					elsif ( rTag3rdByte='1' ) then
						rErrorTagLen(5 downto 0)	<= "000011";	-- 2
					elsif ( rTag2ndByte='1' ) then
						rErrorTagLen(5 downto 0)	<= "000010";	-- 3
					elsif ( rTag1stByte='1' ) then
						rErrorTagLen(5 downto 0)	<= "000001";	-- 4
					else
						rErrorTagLen(5 downto 0)	<= rErrorTagLen(5 downto 0);
					end if;
				else
					rErrorTagLen(5 downto 0)	<= rErrorTagLen(5 downto 0);
				end if;
			end if;
		end if;
	End Process u_rErrorTagLen;
	
----------------------------------------------------------------------------------
-- Message valid
--		A bit of rMsgTypeVal will be always set when a message come.
--		Whereas, A bit of rMsgVal2User will be set iff the message has no error.
----------------------------------------------------------------------------------
	-- 	bit0: HeartBt	
	-- 	bit1: TestReq
	-- 	bit2: ResendReq
	-- 	bit3: Reject
	-- 	bit4: SeqRst
	-- 	bit5: Logout
	-- 	bit6: Logon
	-- 	bit7: SnapShot	
----------------------------------------------------------------------------------

	u_rMsgTypeVal : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMsgTypeVal(7 downto 0)	<= x"00";
			else
				-- 1-clk set when bin Csum value from Ascii2Bin is released
				-- Severe error will be occurred if Msg lacks of checksum field
				if ( rWaitCSum='1' and rBinOutVal='1' and 
					 rBeginStrVal='1' and rSenderIdVal='1' and rTargetIdVal='1' and
					 rBLenVal='1'  and rCSum(7 downto 0)=rBinOutData(7 downto 0) and
					 rHdSeq(2 downto 0)="111" ) then
					-- set the bit according to msg type
					case ( rTypePermit(7 downto 0) ) Is
						when "00000001"		=> rMsgTypeVal(7 downto 0) 	<= "00000001";	-- HeartBt	
						when "00000010"		=> rMsgTypeVal(7 downto 0) 	<= "00000010";	-- TestReq
						when "00000100"		=> rMsgTypeVal(7 downto 0) 	<= "00000100";  -- ResendReq
						when "00001000"		=> rMsgTypeVal(7 downto 0) 	<= "00001000";  -- Reject
						when "00010000"		=> rMsgTypeVal(7 downto 0) 	<= "00010000";  -- SeqRst
						when "00100000"		=> rMsgTypeVal(7 downto 0) 	<= "00100000";  -- Logout
						when "01000000"		=> rMsgTypeVal(7 downto 0) 	<= "01000000";  -- Logon
						when "10000000"		=> rMsgTypeVal(7 downto 0) 	<= "10000000";  -- SnapShot	
						when others			=> rMsgTypeVal(7 downto 0)	<= "00000000";	-- unknown msg type
					end case;
				else
					rMsgTypeVal(7 downto 0)		<= x"00";
				end if;
			end if;
		end if;
	End Process u_rMsgTypeVal;
	
	u_rMsgVal2User : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMsgVal2User(7 downto 0)	<= x"00";
			else
				-- 1-clk set when bin Csum value from Ascii2Bin is released
				-- Severe error will be occurred if Msg lacks of checksum field
				if ( rWaitCSum='1' and rBinOutVal='1' and 
					 rBeginStrVal='1' and rSenderIdVal='1' and rTargetIdVal='1' and
					 rHdSeq(2 downto 0)="111" and 
					 rBLenVal='1'  and rTagError='0' and
					 EncryptMetError='0' and AppVerIdError='0' and
					 rBinOutNegExp(1 downto 0)="00" and 
					 rCSum(7 downto 0)=rBinOutData(7 downto 0)) then
					-- set the bit according to msg type
					case ( rTypePermit(7 downto 0) ) Is
						when "00000001"		=> rMsgVal2User(7 downto 0) 	<= "00000001";	-- HeartBt	
						when "00000010"		=> rMsgVal2User(7 downto 0) 	<= "00000010";	-- TestReq
						when "00000100"		=> rMsgVal2User(7 downto 0) 	<= "00000100";  -- ResendReq
						when "00001000"		=> rMsgVal2User(7 downto 0) 	<= "00001000";  -- Reject
						when "00010000"		=> rMsgVal2User(7 downto 0) 	<= "00010000";  -- SeqRst
						when "00100000"		=> rMsgVal2User(7 downto 0) 	<= "00100000";  -- Logout
						when "01000000"		=> rMsgVal2User(7 downto 0) 	<= "01000000";  -- Logon
						when "10000000"		=> rMsgVal2User(7 downto 0) 	<= "10000000";  -- SnapShot	
						when others			=> rMsgVal2User(7 downto 0)		<= "00000000";	-- unknown msg type
					end case;
				else
					rMsgVal2User(7 downto 0)		<= x"00";
				end if;
			end if;
		end if;
	End Process u_rMsgVal2User;
	
End Architecture rt1;