----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		TbRxFix.vhd
-- Title		Test RxFix
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       K.Norawit
-- Date         2021/02/20
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;
use work.PkTbFixGen.all;
use work.PkSigTbRxFix.all;
use work.PkTbRxFix.all;


Entity TbRxFix Is
End Entity TbRxFix;

Architecture HTWTestBench Of TbRxFix Is

----------------------------------------------------------------------------------
--	Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------------------
	
	component RxFix Is
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
		-- Test Error port
		NoEntriesError		: out	std_logic
		
	);
	End component RxFix;

----------------------------------------------------------------------------------
--	Signal declaration
----------------------------------------------------------------------------------
	
Begin

----------------------------------------------------------------------------------
--	Concurrent signal
----------------------------------------------------------------------------------
	
	u_RstB	:	Process
	Begin
		RstB	<=	'0';
		wait for 20*tClk;
		RstB	<=	'1';
		wait;
	End Process u_RstB;

	u_Clk	:	Process
	Begin
		Clk		<=	'1';
		wait for tClk/2;
		Clk		<=	'0';
		wait for tClk/2;
	End Process u_Clk;
	
	u_RxFix	:	RxFix
	Port map
	(
		RstB				=> RstB					,
		Clk					=> Clk					,	
		UserValid 			=> '1' 					,
		UserSenderId        => x"00_0000_0000_0000_0000_0053_4554",
		UserTargetId        => x"30_3031_355f_4649_585f_4d44_3530",
		FixSOP		        => FixSOP_t	            ,
		FixValid	        => FixValid_t	        ,
		FixEOP		        => FixEOP_t	            ,
		FixData		        => FixData_t	        ,
		TCPConnect	        => TCPConnect_t         ,
		ExpSeqNum	        => ExpSeqNum_t          ,
		SecValid	        => SecValid_t	        ,
		SecSymbol0	        => SecSymbol0_t         ,
		SrcId0		        => SrcId0_t	            ,
		SecSymbol1	        => SecSymbol1_t         ,
		SrcId1		        => SrcId1_t	            ,
		SecSymbol2	        => SecSymbol2_t         ,
		SrcId2		        => SrcId2_t	            ,
		SecSymbol3	        => SecSymbol3_t         ,
		SrcId3		        => SrcId3_t	            ,
		SecSymbol4	        => SecSymbol4_t         ,
		SrcId4		        => SrcId4_t	            ,
		MsgTypeVal		    => MsgTypeVal_t		    ,
		BLenError			=> BLenError_t		    ,
		CSumError			=> CSumError_t		    ,
		TagError		    => TagError_t		    ,
		ErrorTagLatch	    => ErrorTagLatch_t	    ,
		ErrorTagLen		    => ErrorTagLen_t	    ,
		SeqNumError		    => SeqNumError_t	    ,
		SeqNum			    => SeqNum_t			    ,
		PossDupFlag		    => PossDupFlag_t	    ,
		TimeYear		    => TimeYear_t		    ,
		TimeMonth		    => TimeMonth_t		    ,
		TimeDay			    => TimeDay_t		    ,
		TimeHour		    => TimeHour_t		    ,
		TimeMin			    => TimeMin_t		    ,
		TimeSec			    => TimeSec_t		    ,
		TimeSecNegExp	    => TimeSecNegExp_t	    ,
		HeartBtInt		    => HeartBtInt_t			,
		EncryptMetError		=> EncryptMetError_t	,
		AppVerIdError		=> AppVerIdError_t	    ,
		ResetSeqNumFlag	    => ResetSeqNumFlag_t	,
		TestReqIdVal		=> TestReqIdVal_t		,	
		TestReqId		    => TestReqId_t			,
		TestReqIdLen	    => TestReqIdLen_t		,
		BeginSeqNum		    => BeginSeqNum_t		,
		EndSeqNum		    => EndSeqNum_t			,
		RefSeqNum		    => RefSeqNum_t			,
		RefTagId		    => RefTagId_t			,
		RefMsgType		    => RefMsgType_t			,
		RejectReason	    => RejectReason_t		,
		GapFillFlag		    => GapFillFlag_t		,
		NewSeqNum		    => NewSeqNum_t			,
		MDReqId			    => MDReqId_t			,
		MDReqIdLen		    => MDReqIdLen_t			,
		MsgVal2User		    => MsgVal2User_t		,
		SecIndic		    => SecIndic_t		    ,
		EntriesVal			=> EntriesVal_t			,
		BidPx			    => BidPx_t			    ,
		BidPxNegExp		    => BidPxNegExp_t		,
		BidSize			    => BidSize_t			,
		BidTimeHour		    => BidTimeHour_t		,
		BidTimeMin          => BidTimeMin_t         ,
		BidTimeSec          => BidTimeSec_t         ,
		BidTimeSecNegExp    => BidTimeSecNegExp_t   ,
		OffPx			    => OffPx_t				,
		OffPxNegExp		    => OffPxNegExp_t	    ,
		OffSize			    => OffSize_t		    ,
		OffTimeHour		    => OffTimeHour_t	    ,
		OffTimeMin          => OffTimeMin_t      	,
		OffTimeSec          => OffTimeSec_t      	,
		OffTimeSecNegExp    => OffTimeSecNegExp_t	,
		SpecialPxFlag	    => SpecialPxFlag_t	 	,
		NoEntriesError      => NoEntriesError_t
		
	);

	-- In
	FixSOP_t		<= FixSOP		    	after 1 ns;
	FixValid_t	    <= FixValid	        	after 1 ns;
	FixEOP_t		<= FixEOP		    	after 1 ns;
	FixData_t		<= FixData		    	after 1 ns;
	TCPConnect_t	<= TCPConnect	    	after 1 ns;
	ExpSeqNum_t     <= ExpSeqNum	    	after 1 ns;

	SecValid_t		<= SecValid				after 1 ns;
	SecSymbol0_t	<= SecSymbol0	    	after 1 ns;
	SrcId0_t		<= SrcId0		    	after 1 ns;
	SecSymbol1_t	<= SecSymbol1	    	after 1 ns;
	SrcId1_t		<= SrcId1		    	after 1 ns;
	SecSymbol2_t	<= SecSymbol2	    	after 1 ns;
	SrcId2_t		<= SrcId2		    	after 1 ns;
	SecSymbol3_t	<= SecSymbol3	    	after 1 ns;
	SrcId3_t		<= SrcId3		    	after 1 ns;
	SecSymbol4_t	<= SecSymbol4	    	after 1 ns;
	SrcId4_t		<= SrcId4		    	after 1 ns;
	
	-- Out
	OutHdDecRecIn.MsgTypeVal		<= MsgTypeVal_t			after 1 ns;	
	OutHdDecRecIn.BLenError			<= BLenError_t			after 1 ns;	
	OutHdDecRecIn.CSumError			<= CSumError_t			after 1 ns;	
	OutHdDecRecIn.TagError			<= TagError_t			after 1 ns;
	OutHdDecRecIn.ErrorTagLatch		<= ErrorTagLatch_t		after 1 ns;
	OutHdDecRecIn.ErrorTagLen		<= ErrorTagLen_t		after 1 ns;	
	OutHdDecRecIn.SeqNumError		<= SeqNumError_t		after 1 ns;	
	OutHdDecRecIn.SeqNum			<= SeqNum_t				after 1 ns;
	OutHdDecRecIn.PossDupFlag		<= PossDupFlag_t		after 1 ns;	
	OutHdDecRecIn.TimeYear			<= TimeYear_t			after 1 ns;
	OutHdDecRecIn.TimeMonth			<= TimeMonth_t			after 1 ns;
	OutHdDecRecIn.TimeDay			<= TimeDay_t			after 1 ns;	
	OutHdDecRecIn.TimeHour			<= TimeHour_t			after 1 ns;
	OutHdDecRecIn.TimeMin			<= TimeMin_t			after 1 ns;	
	OutHdDecRecIn.TimeSec			<= TimeSec_t			after 1 ns;	
	OutHdDecRecIn.TimeSecNegExp		<= TimeSecNegExp_t		after 1 ns;
	
	OutLogOnRecIn.HeartBtInt		<= HeartBtInt_t			after 1 ns;
	OutLogOnRecIn.ResetSeqNumFlag	<= ResetSeqNumFlag_t	after 1 ns;
	OutLogOnRecIn.EncryptMetError	<= EncryptMetError_t	after 1 ns;
	OutLogOnRecIn.AppVerIdError	    <= AppVerIdError_t	 	after 1 ns;
	OutTestReqIdRecIn.TestReqIdVal	<= TestReqIdVal_t		after 1 ns;
	OutTestReqIdRecIn.TestReqId		<= TestReqId_t		    after 1 ns;
	OutTestReqIdRecIn.TestReqIdLen	<= TestReqIdLen_t	    after 1 ns;
	OutResentReqRecIn.BeginSeqNum	<= BeginSeqNum_t		after 1 ns;
	OutResentReqRecIn.EndSeqNum		<= EndSeqNum_t		    after 1 ns;
	OutRejectRecIn.RefSeqNum		<= RefSeqNum_t		    after 1 ns;
	OutRejectRecIn.RefTagId			<= RefTagId_t		    after 1 ns;
	OutRejectRecIn.RefMsgType		<= RefMsgType_t		    after 1 ns;
	OutRejectRecIn.RejectReason		<= RejectReason_t	    after 1 ns;
	OutSeqRstRecIn.GapFillFlag		<= GapFillFlag_t		after 1 ns;
    OutSeqRstRecIn.NewSeqNum		<= NewSeqNum_t		    after 1 ns;
    OutSnapShotRecIn.MDReqId		<= MDReqId_t			after 1 ns;
    OutSnapShotRecIn.MDReqIdLen		<= MDReqIdLen_t		    after 1 ns;

	OutHdDecRecIn.MsgVal2User			<= MsgVal2User_t		after 1 ns;
	OutSnapShotRecIn.SecIndic			<= SecIndic_t		    after 1 ns;
	OutSnapShotRecIn.EntriesVal			<= EntriesVal_t			after 1 ns;
	OutSnapShotRecIn.BidPx				<= BidPx_t			    after 1 ns;
	OutSnapShotRecIn.BidPxNegExp		<= BidPxNegExp_t		after 1 ns;
	OutSnapShotRecIn.BidSize			<= BidSize_t			after 1 ns;
	OutSnapShotRecIn.BidTimeHour		<= BidTimeHour_t		after 1 ns;
	OutSnapShotRecIn.BidTimeMin      	<= BidTimeMin_t         after 1 ns;
	OutSnapShotRecIn.BidTimeSec      	<= BidTimeSec_t         after 1 ns;
	OutSnapShotRecIn.BidTimeSecNegExp	<= BidTimeSecNegExp_t   after 1 ns;
	
	OutSnapShotRecIn.OffPx				<= OffPx_t				after 1 ns;
	OutSnapShotRecIn.OffPxNegExp		<= OffPxNegExp_t		after 1 ns;
	OutSnapShotRecIn.OffSize			<= OffSize_t			after 1 ns;
	OutSnapShotRecIn.OffTimeHour		<= OffTimeHour_t		after 1 ns;
	OutSnapShotRecIn.OffTimeMin      	<= OffTimeMin_t         after 1 ns;
	OutSnapShotRecIn.OffTimeSec      	<= OffTimeSec_t         after 1 ns;
	OutSnapShotRecIn.OffTimeSecNegExp	<= OffTimeSecNegExp_t   after 1 ns;
	OutSnapShotRecIn.SpecialPxFlag		<= SpecialPxFlag_t	    after 1 ns;
	
	OutSnapShotRecIn.NoEntriesError		<= NoEntriesError_t		after 1 ns;

----------------------------------------------------------------------------------
--	Testbench
----------------------------------------------------------------------------------

	u_Test	:	Process
		
	Begin
		--------------------------------------------------------------------------
		-- TM=0 : Reset
		--------------------------------------------------------------------------
		TM	<=	0; wait for 1 ns;
		Report "TM=" & integer'image(TM); 
		wait until rising_edge(Clk);
		rTest1			<= x"FF";
		rTest2			<= x"96";
		
			-- UserValid 		<= '0';
			-- UserSenderId    <= x"00_0000_0000_0000_0000_0000_0000";
			-- UserTargetId    <= x"00_0000_0000_0000_0000_0000_0000";
		FixSOP		    <= '0';
		FixValid	    <= '0';
		FixEOP		    <= '0';
		FixData		    <= x"00";
		TCPConnect	    <= '0';
		ExpSeqNum	    <= x"0000_0000";
		
		SecValid		<= "00000";
		SecSymbol0	    <= x"0000_0000_0000";
		SrcId0		    <= x"0000";
		SecSymbol1	    <= x"0000_0000_0000";
		SrcId1		    <= x"0000";
		SecSymbol2	    <= x"0000_0000_0000";
		SrcId2		    <= x"0000";
		SecSymbol3	    <= x"0000_0000_0000";
		SrcId3		    <= x"0000";
		SecSymbol4	    <= x"0000_0000_0000";
		SrcId4		    <= x"0000";
		wait for 30*tClk;	--	must be more than 20tClk(reset time)
		
		--------------------------------------------------------------------------
		--	TM=1 : Logon
		--------------------------------------------------------------------------	
		-- TT=0: a valid LogOn
		----------------------------------------
		TM	<=	1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
			-- UserValid 		<= '1';
			-- UserSenderId    <= x"00_0000_0000_0000_0000_0053_4554";		-- SET
			-- UserTargetId    <= x"30_3031_355f_4649_585f_4d44_3530";		-- '0 015_ FIX_ MD50'
		TCPConnect	    <= '1';
		ExpSeqNum	    <= x"0000_0001";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "01000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0001";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "1000";			-- 8
		ExpHdDecRecIn.TimeDay			<= "10101";			-- 21
		ExpHdDecRecIn.TimeHour		    <= "00010";			-- 02
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41
		ExpHdDecRecIn.TimeSec			<= x"1E68";			-- 7784
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "01000000";
		ExpLogOnRecIn.HeartBtInt		<= x"3330";		
		ExpLogOnRecIn.ResetSeqNumFlag	<= '1';
		ExpLogOnRecIn.EncryptMetError	<= '0';
		ExpLogOnRecIn.AppVerIdError     <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3435";		-- 000145		-- edit +3 +3 +10 +3 +18 +13 + 5 
			-- size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0041";			-- A (Logon)
		GenHdRecIn.HdSeqNum		        <= x"3030_3031";			-- 1 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3030_3832_312d_3032_3a34_313a_3037_2e37_3834"; 	-- 20200821-02:41:07.784
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3031";			-- 1 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenLogonRecIn.EncryptMet		<= x"30";					-- 0
		GenLogonRecIn.HeartBtInt		<= x"3330";					-- 30
		GenLogonRecIn.RstSeqNumFlag	    <= x"59";					-- Y
		GenLogonRecIn.UserName		    <= x"30_3031_355f_4649_585f_4d44_3530";	-- test sh regis
		GenLogonRecIn.Password		    <= x"3966_514e_4543_4033";				-- test sh regis
		GenLogonRecIn.AppVerID		    <= x"39";					-- 9
		GenCsum                         <= x"303634";				-- 64
		
		-- build msg
		wait until rising_edge(Clk);
		LogonBuild(GenHdRecIn,GenLogonRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cLogOnGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
				
				rTest1		<= rTest1 + 1;
				rTest2		<= rTest2 + rTest2;
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cLogOnGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: Valid LogOn with 1-clk toggling FixValid / EncrptMetError/ AppVerIdError
		----------------------------------------
		TM	<=	1; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_000A";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "01000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_000A";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "0111";			-- 7
		ExpHdDecRecIn.TimeDay			<= "10100";			-- 20
		ExpHdDecRecIn.TimeHour		    <= "00100";			-- 04
		ExpHdDecRecIn.TimeMin			<= "101000";		-- 40
		ExpHdDecRecIn.TimeSec			<= x"1E67";			-- 7783
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000000";		-- invalid via error
		ExpLogOnRecIn.HeartBtInt		<= x"3330";		
		ExpLogOnRecIn.ResetSeqNumFlag	<= '1';
		ExpLogOnRecIn.EncryptMetError	<= '1';
		ExpLogOnRecIn.AppVerIdError     <= '1';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3435";		-- 000145		-- edit +3 +3 +10 +3 +18 +13 + 5 
			-- size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0041";			-- A (Logon)
		GenHdRecIn.HdSeqNum		        <= x"3030_3130";			-- 10 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3030_3732_302d_3034_3a34_303a_3037_2e37_3833"; 	-- 20200720-04:40:07.783
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3039";			-- 9 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenLogonRecIn.EncryptMet		<= x"31";					-- 1 (error)
		GenLogonRecIn.HeartBtInt		<= x"3330";					-- 30
		GenLogonRecIn.RstSeqNumFlag	    <= x"59";					-- Y
		GenLogonRecIn.UserName		    <= x"30_3031_355f_4649_585f_4d44_3530";	-- test sh regis
		GenLogonRecIn.Password		    <= x"3966_514e_4543_4033";				-- test sh regis
		GenLogonRecIn.AppVerID		    <= x"38";					-- 8 (error)
		-- 9
		GenCsum                         <= x"303730";				-- 70
		
		-- build msg
		wait until rising_edge(Clk);
		LogonBuild(GenHdRecIn,GenLogonRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cLogOnGenLen) loop			
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			---------------------------------
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- last byte of message, set EOP
			if ( byte=cLogOnGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=2: Dropped LogOn via invalid BeginString/ invalid sender-target ComId
		----------------------------------------
		TM	<=	1; TT <= 2; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_000A";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_000A";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "0111";			-- 7
		ExpHdDecRecIn.TimeDay			<= "10100";			-- 20
		ExpHdDecRecIn.TimeHour		    <= "00100";			-- 04
		ExpHdDecRecIn.TimeMin			<= "101000";		-- 40
		ExpHdDecRecIn.TimeSec			<= x"1E67";			-- 7783
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000000";
		ExpLogOnRecIn.HeartBtInt		<= x"3330";		
		ExpLogOnRecIn.ResetSeqNumFlag	<= '1';
		ExpLogOnRecIn.EncryptMetError	<= '0';
		ExpLogOnRecIn.AppVerIdError     <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e30";	-- FIXT.1.0
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3435";		-- 000145		-- edit +3 +3 +10 +3 +18 +13 + 5 
			-- size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0041";			-- A (Logon)
		GenHdRecIn.HdSeqNum		        <= x"3030_3130";			-- 10 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4553";				-- SES
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3531";				-- 0015_FIX_ MD51
		GenHdRecIn.HdSendTime		    <= x"32_3032_3030_3732_302d_3034_3a34_303a_3037_2e37_3833"; 	-- 20200720-04:40:07.783
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3039";			-- 9 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenLogonRecIn.EncryptMet		<= x"30";					-- 0
		GenLogonRecIn.HeartBtInt		<= x"3330";					-- 30
		GenLogonRecIn.RstSeqNumFlag	    <= x"59";					-- Y
		GenLogonRecIn.UserName		    <= x"30_3031_355f_4649_585f_4d44_3530";	-- test sh regis
		GenLogonRecIn.Password		    <= x"3966_514e_4543_4033";				-- test sh regis
		GenLogonRecIn.AppVerID		    <= x"39";	
		-- 9
		GenCsum                         <= x"303639";				-- 69
		
		-- build msg
		wait until rising_edge(Clk);
		LogonBuild(GenHdRecIn,GenLogonRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cLogOnGenLen) loop			
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			---------------------------------
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-------------------------------
			-- -- Test: drop valid for 1 clk
			-- if ( byte>0 ) then
				-- FixValid	<= '0';
				-- wait until rising_edge(Clk);
				-- FixValid	<= '1';
			-- end if;
			-------------------------------
			-- last byte of message, set EOP
			if ( byte=cLogOnGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=3: Valid LogOn with Seqnum reset by ResetSeqNumFlag
		--	Seqnum is not the expected one but SeqNumErro must be '0'
		----------------------------------------
		TM	<=	1; TT <= 3; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_00FF";	-- control unit
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "01000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0001";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "1000";			-- 8
		ExpHdDecRecIn.TimeDay			<= "10101";			-- 21
		ExpHdDecRecIn.TimeHour		    <= "00010";			-- 02
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41
		ExpHdDecRecIn.TimeSec			<= x"1E68";			-- 7784
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "01000000";
		ExpLogOnRecIn.HeartBtInt		<= x"3330";		
		ExpLogOnRecIn.ResetSeqNumFlag	<= '1';
		ExpLogOnRecIn.EncryptMetError	<= '0';
		ExpLogOnRecIn.AppVerIdError     <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3435";		-- 000145		-- edit +3 +3 +10 +3 +18 +13 + 5 
			-- size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0041";			-- A (Logon)
		GenHdRecIn.HdSeqNum		        <= x"3030_3031";			-- 1 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3030_3832_312d_3032_3a34_313a_3037_2e37_3834"; 	-- 20200821-02:41:07.784
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3031";			-- 1 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenLogonRecIn.EncryptMet		<= x"30";					-- 0
		GenLogonRecIn.HeartBtInt		<= x"3330";					-- 30
		GenLogonRecIn.RstSeqNumFlag	    <= x"59";					-- Y
		GenLogonRecIn.UserName		    <= x"30_3031_355f_4649_585f_4d44_3530";	-- test sh regis
		GenLogonRecIn.Password		    <= x"3966_514e_4543_4033";				-- test sh regis
		GenLogonRecIn.AppVerID		    <= x"39";					-- 9
		GenCsum                         <= x"303634";				-- 64
		
		-- build msg
		wait until rising_edge(Clk);
		LogonBuild(GenHdRecIn,GenLogonRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cLogOnGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cLogOnGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		--------------------------------------------------------------------------
		--	TM=2 : LogOut
		--------------------------------------------------------------------------	
		-- TT=0: a valid LogOut
		----------------------------------------
		TM	<=	2; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		ExpSeqNum	    <= x"0000_0002";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00100000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0002";
		ExpHdDecRecIn.PossDupFlag		<= '0'; 
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "0010";			-- 2
		ExpHdDecRecIn.TimeDay			<= "11000";			-- 24	
		ExpHdDecRecIn.TimeHour		    <= "00011";			-- 03
		ExpHdDecRecIn.TimeMin			<= "101000";		-- 40
		ExpHdDecRecIn.TimeSec			<= x"2418";			-- 9240
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00100000";
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3030_3839";		-- 000089 : size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0035";			-- 5 (LogOut)
		GenHdRecIn.HdSeqNum		        <= x"3030_3032";			-- 2 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3130_3232_342d_3033_3a34_303a_3039_2e32_3430"; 	-- 20210224-03:40:09.240
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3032";			-- 2 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenCsum                         <= x"303836";				-- 86
		
		-- build msg
		wait until rising_edge(Clk);
		EmptyFieldBuild(GenHdRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cEmptyGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cEmptyGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: LogOut with BLenError/ CsumError --> dropped
		----------------------------------------
		TM	<=	2; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		ExpSeqNum	    <= x"0000_000F";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000000";
		ExpHdDecRecIn.BLenError			<= '1';
		ExpHdDecRecIn.CSumError			<= '1';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_000F";
		ExpHdDecRecIn.PossDupFlag		<= '0'; 
		ExpHdDecRecIn.TimeYear		    <= "11111100110";	-- 2022
		ExpHdDecRecIn.TimeMonth		    <= "0111";			-- 07
		ExpHdDecRecIn.TimeDay			<= "10000";			-- 16	
		ExpHdDecRecIn.TimeHour		    <= "01000";			-- 08
		ExpHdDecRecIn.TimeMin			<= "000001";		-- 01
		ExpHdDecRecIn.TimeSec			<= x"0001";			-- 00001
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000000";
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3030_3838";		-- 000088 (error)
		GenHdRecIn.HdMsgType		    <= x"0000_0035";			-- 5 (LogOut)
		GenHdRecIn.HdSeqNum		        <= x"3030_3135";			-- 15 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3230_3731_362d_3038_3a30_313a_3030_2e30_3031"; 	-- 20220716-08:01:00.001
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3134";			-- 14 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenCsum                         <= x"303836";				-- 86 (error)
		
		-- build msg
		wait until rising_edge(Clk);
		EmptyFieldBuild(GenHdRecIn,GenCsum,All_array(0));
		
		----------------build 2nd message in advance for next TT (TT=2)--------------
		wait until rising_edge(Clk);
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3030_3839";		-- 000089 : size - 20(BeginStr+BLen) - 7 (Csum)
		GenHdRecIn.HdMsgType		    <= x"0000_0035";			-- 5 (LogOut)
		GenHdRecIn.HdSeqNum		        <= x"3030_3032";			-- 2 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3130_3232_342d_3033_3a34_303a_3039_2e32_3430"; 	-- 20210224-03:40:09.240
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3032";			-- 2 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4E";					-- N
		GenCsum                         <= x"303836";				-- 86
		
		-- build msg
		wait until rising_edge(Clk);
		EmptyFieldBuild(GenHdRecIn,GenCsum,All_array(1));
		
		-----------------------------------------------------------------------------
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cEmptyGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cEmptyGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		-- FixValid	<= '0';
		-- wait for 6*tClk;
		
		----------------------------------------
		-- TT=2: Send Valid LogOut immediately sinec the former one is finished feeding 
		----------------------------------------
		-- TM	<=	2; TT <= 2; wait for 1 ns;
		-- Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		ExpSeqNum	    <= x"0000_0002";
		-- feed message
		--wait until rising_edge(Clk);
		For byte in 0 to (cEmptyGenLen) loop
			-- resolve wait untill problem in verify
			if (byte=5) then
				TM	<=	2; TT <= 2; wait for 1 ns;
				Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
			end if;
		
			-- feed (a byte) input 
			FixData		<= All_array(1)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cEmptyGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00100000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0002";
		ExpHdDecRecIn.PossDupFlag		<= '0'; 
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "0010";			-- 2
		ExpHdDecRecIn.TimeDay			<= "11000";			-- 24	
		ExpHdDecRecIn.TimeHour		    <= "00011";			-- 03
		ExpHdDecRecIn.TimeMin			<= "101000";		-- 40
		ExpHdDecRecIn.TimeSec			<= x"2418";			-- 9240
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00100000";
		wait for 6*tClk;
		
		--------------------------------------------------------------------------
		--	TM=3 : Heartbeat
		--------------------------------------------------------------------------	
		-- TT=0: a valid Heartbeat with TestReqID
		----------------------------------------
		TM	<=	3; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0003";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000001";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0003";
		ExpHdDecRecIn.PossDupFlag		<= '1';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "0100";			-- 4
		ExpHdDecRecIn.TimeDay			<= "10101";			-- 21
		ExpHdDecRecIn.TimeHour		    <= "00100";			-- 04
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41	
		ExpHdDecRecIn.TimeSec			<= x"2397";			-- 9111
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000001";
		
		ExpTestReqIdRecIn.TestReqIdVal	<= '1';	
		ExpTestReqIdRecIn.TestReqId		<= x"3030_3030_3132_3334";	-- 1234
		ExpTestReqIdRecIn.TestReqIdLen	<= "001000";		-- 8
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3032";		-- 000102	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0030";			-- 0 (HeartBeat)
		GenHdRecIn.HdSeqNum		        <= x"3030_3033";			-- 3 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3130_3432_312d_3034_3a34_313a_3039_2e31_3131"; 	-- 20210421-04:41:09.111
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3032";			-- 2 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"59";					-- Y
		
		GenTestReqID					<= x"3030_3030_3132_3334";	-- 1234
		GenCsum                         <= x"313639";				-- 169
		
		-- build msg
		wait until rising_edge(Clk);
		HB_or_TestReq_Build(GenHdRecIn,GenTestReqID,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cTestReqGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cTestReqGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: a valid Heartbeat without TestReqID
		----------------------------------------
		TM	<=	3; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0004";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000001";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0004";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "0100";			-- 4
		ExpHdDecRecIn.TimeDay			<= "10101";			-- 21
		ExpHdDecRecIn.TimeHour		    <= "00100";			-- 04
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41	
		ExpHdDecRecIn.TimeSec			<= x"2397";			-- 9111
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000001";
		
		ExpTestReqIdRecIn.TestReqIdVal	<= '0';	
		ExpTestReqIdRecIn.TestReqId		<= x"3030_3030_3132_3334";	-- 1234	[ignore]
		ExpTestReqIdRecIn.TestReqIdLen	<= "001000";		-- 8			[ignore]
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3030_3839";		-- 000089	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0030";			-- 0 (HeartBeat)
		GenHdRecIn.HdSeqNum		        <= x"3030_3034";			-- 4 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3130_3432_312d_3034_3a34_313a_3039_2e31_3131"; 	-- 20210421-04:41:09.111
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3033";			-- 3 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenCsum                         <= x"303832";				-- 082
		
		-- build msg
		wait until rising_edge(Clk);
		EmptyFieldBuild(GenHdRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cEmptyGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cEmptyGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=2: Valid Heartbeat with 1-clk toggling
		----------------------------------------
		TM	<=	3; TT <= 2; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_00FF";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000001";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_00FF";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11101101100";	-- 1900
		ExpHdDecRecIn.TimeMonth		    <= "0110";			-- 6
		ExpHdDecRecIn.TimeDay			<= "01101";			-- 13
		ExpHdDecRecIn.TimeHour		    <= "01000";			-- 16
		ExpHdDecRecIn.TimeMin			<= "000000";		-- 00	
		ExpHdDecRecIn.TimeSec			<= x"07D0";			-- 2000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000001";
		
		ExpTestReqIdRecIn.TestReqIdVal	<= '1';	
		ExpTestReqIdRecIn.TestReqId		<= x"3030_3030_3938_3736";	-- 9876
		ExpTestReqIdRecIn.TestReqIdLen	<= "001000";		-- 8
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3032";		-- 000102	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0030";			-- 0 (HeartBeat)
		GenHdRecIn.HdSeqNum		        <= x"3032_3535";			-- 255 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"31_3930_3030_3631_332d_3136_3a30_303a_3032_2e30_3030"; 	-- 19000613-16:00:02.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3032_3534";			-- 254 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenTestReqID					<= x"3030_3030_3938_3736";	-- 9876
		GenCsum                         <= x"313932";				-- 192
		
		-- build msg
		wait until rising_edge(Clk);
		HB_or_TestReq_Build(GenHdRecIn,GenTestReqID,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cTestReqGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cTestReqGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		--------------------------------------------------------------------------
		--	TM=4 : Test Request
		--------------------------------------------------------------------------	
		-- TT=0: a valid Test Request with TestReqID
		----------------------------------------
		TM	<=	4; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_23A8";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000010";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_23A8";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1011";			-- 11
		ExpHdDecRecIn.TimeDay			<= "10011";			-- 19
		ExpHdDecRecIn.TimeHour		    <= "00010";			-- 02
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41	
		ExpHdDecRecIn.TimeSec			<= x"1F40";			-- 8000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000010";
		
		ExpTestReqIdRecIn.TestReqIdVal	<= '1';
		ExpTestReqIdRecIn.TestReqId		<= x"3030_3030_3939_3939";	-- 0000_9999
		ExpTestReqIdRecIn.TestReqIdLen	<= "001000";		-- 8
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3032";		-- 000102	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0031";			-- 1 (HeartBeat)
		GenHdRecIn.HdSeqNum		        <= x"3931_3238";			-- 9128 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3131_392d_3032_3a34_313a_3038_2e30_3030"; 	-- 20211119-02:41:08.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3033";			-- 3 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenTestReqID					<= x"3030_3030_3939_3939";	-- 0000_9999
		GenCsum                         <= x"323032";				-- 202
		
		-- build msg
		wait until rising_edge(Clk);
		HB_or_TestReq_Build(GenHdRecIn,GenTestReqID,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cTestReqGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cTestReqGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: drop TCP connect --> pkt dropped
		----------------------------------------
		TM	<=	4; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		TCPConnect		<= '0';
		ExpSeqNum	    <= x"0000_23A8";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_23A8";
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1011";			-- 11
		ExpHdDecRecIn.TimeDay			<= "10011";			-- 19
		ExpHdDecRecIn.TimeHour		    <= "00010";			-- 02
		ExpHdDecRecIn.TimeMin			<= "101001";		-- 41	
		ExpHdDecRecIn.TimeSec			<= x"1F40";			-- 8000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000000";
		
		ExpTestReqIdRecIn.TestReqIdVal	<= '1';
		ExpTestReqIdRecIn.TestReqId		<= x"3030_3030_3939_3939";	-- 0000_9999
		ExpTestReqIdRecIn.TestReqIdLen	<= "001000";		-- 8
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3032";		-- 000102	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0031";			-- 1 (HeartBeat)
		GenHdRecIn.HdSeqNum		        <= x"3931_3238";			-- 9128 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3131_392d_3032_3a34_313a_3038_2e30_3030"; 	-- 20211119-02:41:08.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3033";			-- 3 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenTestReqID					<= x"3030_3030_3939_3939";	-- 0000_9999
		GenCsum                         <= x"323032";				-- 202
		
		-- build msg
		wait until rising_edge(Clk);
		HB_or_TestReq_Build(GenHdRecIn,GenTestReqID,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cTestReqGenLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cTestReqGenLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		
		--------------------------------------------------------------------------
		--	TM=5 : Resent Request
		--------------------------------------------------------------------------	
		-- TT=0: a valid Resent Request
		----------------------------------------
		TM	<=	5; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		TCPConnect		<= '1';
		ExpSeqNum	    <= x"0000_03E8";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000100";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_03E8";	-- 1000
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "0001";			-- 01
		ExpHdDecRecIn.TimeDay			<= "00001";			-- 01
		ExpHdDecRecIn.TimeHour		    <= "00110";			-- 06
		ExpHdDecRecIn.TimeMin			<= "001111";		-- 15	
		ExpHdDecRecIn.TimeSec			<= x"07D0";			-- 2000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000100";
		
		ExpResentReqRecIn.BeginSeqNum	<= x"0000_0002";	-- 0002
		ExpResentReqRecIn.EndSeqNum		<= x"0000_0005";	-- 0005
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3034";		-- 000104	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0032";			-- 2 (Resent Req)
		GenHdRecIn.HdSeqNum		        <= x"3130_3030";			-- 1000 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3130_3130_312d_3036_3a31_353a_3032_2e30_3030"; 	-- 20210101-06:15:02.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3931_3238";			-- 9128 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenResentReqRecIn.BeginSeqNum	<= x"3030_3032";	-- 0002
		GenResentReqRecIn.EndSeqNum		<= x"3030_3035";	-- 0005
		GenCsum                         <= x"323335";		-- 235
		
		-- build msg
		wait until rising_edge(Clk);
		ReSentReqBuild(GenHdRecIn,GenResentReqRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cResentReqLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cResentReqLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: Valid resent Req with 1-clk toggling
		----------------------------------------
		TM	<=	5; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_270F";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00000100";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_270F";	-- 9999
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111011100";	-- 2012
		ExpHdDecRecIn.TimeMonth		    <= "0010";			-- 02
		ExpHdDecRecIn.TimeDay			<= "00011";			-- 03
		ExpHdDecRecIn.TimeHour		    <= "00000";			-- 00
		ExpHdDecRecIn.TimeMin			<= "111011";		-- 59	
		ExpHdDecRecIn.TimeSec			<= x"0000";			-- 0000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00000100";
		
		ExpResentReqRecIn.BeginSeqNum	<= x"0000_270B";	-- 9995
		ExpResentReqRecIn.EndSeqNum		<= x"0000_270E";	-- 9998
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3034";		-- 000104	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0032";			-- 2 (Resent Req)
		GenHdRecIn.HdSeqNum		        <= x"3939_3939";			-- 9999 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3031_3230_3230_332d_3030_3a35_393a_3030_2e30_3030"; 	-- 20120203-00:59:00.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3939_3938";			-- 9998 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenResentReqRecIn.BeginSeqNum	<= x"3939_3935";	-- 9995
		GenResentReqRecIn.EndSeqNum		<= x"3939_3938";	-- 9998
		GenCsum                         <= x"303932";		-- 092
		
		-- build msg
		wait until rising_edge(Clk);
		ReSentReqBuild(GenHdRecIn,GenResentReqRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cResentReqLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cResentReqLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		
		--------------------------------------------------------------------------
		--	TM=6 : Reject
		--------------------------------------------------------------------------	
		-- TT=0: a valid Reject
		----------------------------------------
		TM	<=	6; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_03E9";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00001000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_03E9";	-- 1001
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11110";			-- 30
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "110111";		-- 55	
		ExpHdDecRecIn.TimeSec			<= x"D6DD";			-- 55005
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00001000";
		
		ExpRejectRecIn.RefSeqNum		<= x"0000_23A8";	-- 9128		
		ExpRejectRecIn.RefTagId			<= x"0471";			-- 1137
		ExpRejectRecIn.RefMsgType		<= "01000000";		-- Logon
		ExpRejectRecIn.RejectReason	   	<= "010";			-- reason 5
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3333";		-- 000133	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0033";			-- 3 (Reject)
		GenHdRecIn.HdSeqNum		        <= x"3130_3031";			-- 1001 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3233_302d_3233_3a35_353a_3535_2e30_3035"; 	-- 20211230-23:55:55.005
		GenHdRecIn.HdLastSeqNumProc     <= x"3931_3237";			-- 9127 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenRejectRecIn.RefSeqNum		<= x"3931_3238";
		GenRejectRecIn.RefTagID	        <= x"3131_3337";
		GenRejectRecIn.RefMsgType	    <= x"41";		-- A (LogOn)
		GenRejectRecIn.ReajectReaon     <= x"0035";		-- (0 must be 00 bin)
		GenRejectRecIn.Reject_Text	    <= x"3030_3030_3030_3030_3030";
		
		GenCsum                         <= x"303535";		-- 55
		
		-- build msg
		wait until rising_edge(Clk);
		RejectBuild(GenHdRecIn,GenRejectRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cRejectReqLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cRejectReqLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: a valid Reject with 1-clk toggling
		----------------------------------------
		TM	<=	6; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0190";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00001000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0190";	-- 400
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "1011";			-- 11
		ExpHdDecRecIn.TimeDay			<= "11111";			-- 31
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "111011";		-- 59	
		ExpHdDecRecIn.TimeSec			<= x"EA5F";			-- 59999
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00001000";
		
		ExpRejectRecIn.RefSeqNum		<= x"0000_23A8";	-- 9128		
		ExpRejectRecIn.RefTagId			<= x"0457";			-- 1111
		ExpRejectRecIn.RefMsgType		<= "10000000";		-- Mkt data req
		ExpRejectRecIn.RejectReason	   	<= "001";			-- reason 0
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3333";		-- 000133	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0033";			-- 3 (Reject)
		GenHdRecIn.HdSeqNum		        <= x"3034_3030";			-- 400 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3031_3133_312d_3233_3a35_393a_3539_2e39_3939"; 	-- 20201131-23:59:59.999
		GenHdRecIn.HdLastSeqNumProc     <= x"3931_3237";			-- 9127 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenRejectRecIn.RefSeqNum		<= x"3931_3238";
		GenRejectRecIn.RefTagID	        <= x"3131_3131";
		GenRejectRecIn.RefMsgType	    <= x"56";		-- V (Mkt data req)
		GenRejectRecIn.ReajectReaon     <= x"0030";		-- (0 must be 00 bin)
		GenRejectRecIn.Reject_Text	    <= x"3030_3030_3030_3030_3030";
		
		GenCsum                         <= x"303934";		-- 94
		
		-- build msg
		wait until rising_edge(Clk);
		RejectBuild(GenHdRecIn,GenRejectRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cRejectReqLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cRejectReqLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		
		--------------------------------------------------------------------------
		--	TM=7 : Sequence Reset
		--------------------------------------------------------------------------	
		-- TT=0: a valid Sequence Reset
		----------------------------------------
		TM	<=	7; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_270F";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00010000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_270F";	-- 9999
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11110";			-- 30
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "110111";		-- 55	
		ExpHdDecRecIn.TimeSec			<= x"0000";			-- 0
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00010000";
		
		ExpSeqRstRecIn.GapFillFlag		<= '1';		
		ExpSeqRstRecIn.NewSeqNum		<= x"0000_0001";	-- 1
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3033";		-- 000103	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0034";			-- 4 (Seq Rst)
		GenHdRecIn.HdSeqNum		        <= x"3939_3939";			-- 9999 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3233_302d_3233_3a35_353a_3030_2e30_3030"; 	-- 20211230-23:55:00.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3939_3938";			-- 9998 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSeqRstRecIn.GapFillFlag		<= x"59";			-- Y
		GenSeqRstRecIn.NewSeqNum	    <= x"3030_3031"; 	-- 0001
	
		GenCsum                         <= x"303233";		-- 23
		
		-- build msg
		wait until rising_edge(Clk);
		SeqRstBuild(GenHdRecIn,GenSeqRstRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSeqRstLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
				
				rTest1		<= rTest1 + 1;
				rTest2		<= rTest2 + rTest2;
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSeqRstLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: a valid Sequence Reset with 1-clk toggling
		----------------------------------------
		TM	<=	7; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0003";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "00010000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0003";	-- 3
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "0001";			-- 01
		ExpHdDecRecIn.TimeDay			<= "00001";			-- 01
		ExpHdDecRecIn.TimeHour		    <= "00001";			-- 01
		ExpHdDecRecIn.TimeMin			<= "000001";		-- 01	
		ExpHdDecRecIn.TimeSec			<= x"03E8";			-- 01000
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "00010000";
		
		ExpSeqRstRecIn.GapFillFlag		<= '0';		
		ExpSeqRstRecIn.NewSeqNum		<= x"0000_0000";	-- 0
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3031_3033";		-- 000103	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0034";			-- 4 (Seq Rst)
		GenHdRecIn.HdSeqNum		        <= x"3030_3033";			-- 3 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3030_3130_312d_3031_3a30_313a_3031_2e30_3030"; 	-- 20200101-01:01:01.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3131";			-- 11 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSeqRstRecIn.GapFillFlag		<= x"4e";			-- N
		GenSeqRstRecIn.NewSeqNum	    <= x"3030_3030"; 	-- 0000
	
		GenCsum                         <= x"313834";		-- 184
		
		-- build msg
		wait until rising_edge(Clk);
		SeqRstBuild(GenHdRecIn,GenSeqRstRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSeqRstLen) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSeqRstLen ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		
		--------------------------------------------------------------------------
		--	TM=8 : Snapshot
		--------------------------------------------------------------------------	
		-- TT=0: a valid Snapshot
		----------------------------------------
		TM	<=	8; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0007";
		
		SecValid		<= "01101";
		SecSymbol0	    <= x"4144_5641_4e43";	-- ADVANC
		SrcId0		    <= x"042d";				-- 1069 (dec)
		SecSymbol1	    <= x"0000_0000_0000";	
		SrcId1		    <= x"0000";				
		SecSymbol2	    <= x"0000_4755_4c46";	-- GULF	
		SrcId2		    <= x"7555";             -- 30037 (dec)
		SecSymbol3	    <= x"0000_0000_4355";	-- CU (fake)
		SrcId3		    <= x"0065";				-- 101 (fake)
		SecSymbol4	    <= x"0000_0000_0000";
		SrcId4		    <= x"0000";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "10000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0007";	-- 9999
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11110";			-- 30
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "110111";		-- 55	
		ExpHdDecRecIn.TimeSec			<= x"0000";			-- 0
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "10000000";
		
		ExpSnapShotRecIn.MDReqId			<= x"4d41";			-- MA	
		ExpSnapShotRecIn.MDReqIdLen		    <= "000010";		-- 2
		ExpSnapShotRecIn.SecIndic		    <= "00001";			-- ADVANC
		ExpSnapShotRecIn.EntriesVal			<= "11";			-- bid/Offer
		ExpSnapShotRecIn.BidPx			    <= x"0096";			-- 150
		ExpSnapShotRecIn.BidPxNegExp		<= "00";	
		ExpSnapShotRecIn.BidSize			<= x"0000_2710";	-- 10000
		ExpSnapShotRecIn.BidTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.BidTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.BidTimeSec         <= x"0000";			-- 0.000
		ExpSnapShotRecIn.BidTimeSecNegExp   <= "11";	
		ExpSnapShotRecIn.OffPx			    <= x"0064";			-- 100
		ExpSnapShotRecIn.OffPxNegExp		<= "00";	
		ExpSnapShotRecIn.OffSize			<= x"0000_4E20";	-- 20000
		ExpSnapShotRecIn.OffTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.OffTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.OffTimeSec         <= x"4E21";			-- 20001
		ExpSnapShotRecIn.OffTimeSecNegExp   <= "11";			-- 1e(-3)
		ExpSnapShotRecIn.SpecialPxFlag	    <= "00";
		ExpSnapShotRecIn.NoEntriesError	    <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3032_3338";		-- 000238	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0057";			-- W (SnapShot)
		GenHdRecIn.HdSeqNum		        <= x"3030_3037";			-- 0007 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3233_302d_3233_3a35_353a_3030_2e30_3030"; 	-- 20211230-23:55:00.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3939_3938";			-- 9998 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSnapShotFullRecIn.MDReqID	<= x"4d41";				-- MA	
		GenSnapShotFullRecIn.Symbol		<= x"4144_5641_4e43"; 	-- ADVANC
		GenSnapShotFullRecIn.SecID		<= x"30_3130_3639";		-- 01069
		GenSnapShotFullRecIn.SecIDSrc	<= x"0038";				-- 8			
		GenSnapShotFullRecIn.NoEntries	<= x"0032";				-- 2
		GenSnapShotFullRecIn.EntryType0	<= x"30";				-- 0 [bid]
		GenSnapShotFullRecIn.Price0		<= x"3030_3030_3030_3030_3030_3030_3030_3030_3031_3530"; -- 00000_00000_00000_00150
		GenSnapShotFullRecIn.Size0		<= x"3030_3031_3030_3030";	-- 0001_0000
		GenSnapShotFullRecIn.EntryTime0	<= x"3032_3a33_303a_3030_2e30_3030";	-- 02:30:00.000
		GenSnapShotFullRecIn.EntryType1	<= x"31"; 				-- 1 [offer]
		GenSnapShotFullRecIn.Price1		<= x"3030_3030_3031_3030"; 				-- 00000_00000_00000_00100
		GenSnapShotFullRecIn.Size1		<= x"3030_3032_3030_3030";	-- 0002_0000
		GenSnapShotFullRecIn.EntryTime1	<= x"3032_3a33_303a_3230_2e30_3031";	-- 02:30:20.001
	
		GenCsum                         <= x"303132";		-- 012
		
		-- build msg
		wait until rising_edge(Clk);
		SnapShotBuild(GenHdRecIn,GenSnapShotFullRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSnapShot) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSnapShot ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=1: a valid Snapshot with 1-clk toggling
		----------------------------------------
		TM	<=	8; TT <= 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0006";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "10000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0006";	-- 6
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11111";			-- 31
		ExpHdDecRecIn.TimeHour		    <= "10110";			-- 22
		ExpHdDecRecIn.TimeMin			<= "110110";		-- 54	
		ExpHdDecRecIn.TimeSec			<= x"000A";			-- 00.010
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "10000000";
		
		ExpSnapShotRecIn.MDReqId			<= x"4d41";			-- MA	
		ExpSnapShotRecIn.MDReqIdLen		    <= "000010";		-- 2
		ExpSnapShotRecIn.SecIndic		    <= "00100";			-- GULF
		ExpSnapShotRecIn.EntriesVal			<= "11";			-- bid/Offer
		ExpSnapShotRecIn.BidPx			    <= x"762A";			-- 30250
		ExpSnapShotRecIn.BidPxNegExp		<= "11";			-- 1e(-3)
		ExpSnapShotRecIn.BidSize			<= x"0000_05DC";	-- 1500
		ExpSnapShotRecIn.BidTimeHour		<= x"04";			-- 04
		ExpSnapShotRecIn.BidTimeMin         <= x"37";			-- 55
		ExpSnapShotRecIn.BidTimeSec         <= x"5225";			-- 21.029
		ExpSnapShotRecIn.BidTimeSecNegExp   <= "11";	
		ExpSnapShotRecIn.OffPx			    <= x"733C";			-- 29500
		ExpSnapShotRecIn.OffPxNegExp		<= "11";			-- 1e(-3)
		ExpSnapShotRecIn.OffSize			<= x"0000_2EE0";	-- 12000
		ExpSnapShotRecIn.OffTimeHour		<= x"04";			-- 04
		ExpSnapShotRecIn.OffTimeMin         <= x"2D";			-- 45
		ExpSnapShotRecIn.OffTimeSec         <= x"0000";			-- 0
		ExpSnapShotRecIn.OffTimeSecNegExp   <= "11";			-- 1e(-3)
		ExpSnapShotRecIn.SpecialPxFlag	    <= "00";
		ExpSnapShotRecIn.NoEntriesError	    <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3032_3338";		-- 000238	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0057";			-- W (SnapShot)
		GenHdRecIn.HdSeqNum		        <= x"3030_3036";			-- 6 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3031_3233_312d_3232_3a35_343a_3030_2e30_3130"; 	-- 20201231-22:54:00.010
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3035";			-- 5 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSnapShotFullRecIn.MDReqID	<= x"4d41";				-- MA	
		GenSnapShotFullRecIn.Symbol		<= x"0000_4755_4c46"; 	-- GULF
		GenSnapShotFullRecIn.SecID		<= x"33_3030_3337";		-- 30037
		GenSnapShotFullRecIn.SecIDSrc	<= x"0038";				-- 8			
		GenSnapShotFullRecIn.NoEntries	<= x"0032";				-- 2
		GenSnapShotFullRecIn.EntryType0	<= x"30";				-- 0 [bid]
		GenSnapShotFullRecIn.Price0		<= x"3030_3030_3030_3030_3030_3030_3030_3330_2e32_3530"; -- 00000_00000_00003_0.250
		GenSnapShotFullRecIn.Size0		<= x"3030_3030_3135_3030";	-- 0000_1500
		GenSnapShotFullRecIn.EntryTime0	<= x"3034_3a35_353a_3231_2e30_3239";	-- 04:55:21.029
		GenSnapShotFullRecIn.EntryType1	<= x"31"; 				-- 1 [offer]
		GenSnapShotFullRecIn.Price1		<= x"3030_3239_2e35_3030"; 	-- 00000_00000_00002_9.500
		GenSnapShotFullRecIn.Size1		<= x"3030_3031_3230_3030";	-- 0001_2000
		GenSnapShotFullRecIn.EntryTime1	<= x"3034_3a34_353a_3030_2e30_3030";	-- 04:45:00.000
	
		GenCsum                         <= x"313535";		-- 155
		
		-- build msg
		wait until rising_edge(Clk);
		SnapShotBuild(GenHdRecIn,GenSnapShotFullRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSnapShot) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSnapShot ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=2: a valid Snapshot with 2-clk toggling
		----------------------------------------
		TM	<=	8; TT <= 2; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0007";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "10000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0007";	-- 9999
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11110";			-- 30
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "110111";		-- 55	
		ExpHdDecRecIn.TimeSec			<= x"0000";			-- 0
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "10000000";
		
		ExpSnapShotRecIn.MDReqId			<= x"4d41";			-- MA	
		ExpSnapShotRecIn.MDReqIdLen		    <= "000010";		-- 2
		ExpSnapShotRecIn.SecIndic		    <= "00001";			-- ADVANC
		ExpSnapShotRecIn.EntriesVal			<= "11";			-- bid/Offer
		ExpSnapShotRecIn.BidPx			    <= x"0096";			-- 150
		ExpSnapShotRecIn.BidPxNegExp		<= "00";	
		ExpSnapShotRecIn.BidSize			<= x"0000_2710";	-- 10000
		ExpSnapShotRecIn.BidTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.BidTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.BidTimeSec         <= x"0000";			-- 0.000
		ExpSnapShotRecIn.BidTimeSecNegExp   <= "11";	
		ExpSnapShotRecIn.OffPx			    <= x"0064";			-- 100
		ExpSnapShotRecIn.OffPxNegExp		<= "00";	
		ExpSnapShotRecIn.OffSize			<= x"0000_4E20";	-- 20000
		ExpSnapShotRecIn.OffTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.OffTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.OffTimeSec         <= x"4E21";			-- 20001
		ExpSnapShotRecIn.OffTimeSecNegExp   <= "11";			-- 1e(-3)
		ExpSnapShotRecIn.SpecialPxFlag	    <= "00";
		ExpSnapShotRecIn.NoEntriesError	    <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3032_3338";		-- 000238	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0057";			-- W (SnapShot)
		GenHdRecIn.HdSeqNum		        <= x"3030_3037";			-- 0007 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3233_302d_3233_3a35_353a_3030_2e30_3030"; 	-- 20211230-23:55:00.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3939_3938";			-- 9998 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSnapShotFullRecIn.MDReqID	<= x"4d41";				-- MA	
		GenSnapShotFullRecIn.Symbol		<= x"4144_5641_4e43"; 	-- ADVANC
		GenSnapShotFullRecIn.SecID		<= x"30_3130_3639";		-- 01069
		GenSnapShotFullRecIn.SecIDSrc	<= x"0038";				-- 8			
		GenSnapShotFullRecIn.NoEntries	<= x"0032";				-- 2
		GenSnapShotFullRecIn.EntryType0	<= x"30";				-- 0 [bid]
		GenSnapShotFullRecIn.Price0		<= x"3030_3030_3030_3030_3030_3030_3030_3030_3031_3530"; -- 00000_00000_00000_00150
		GenSnapShotFullRecIn.Size0		<= x"3030_3031_3030_3030";	-- 0001_0000
		GenSnapShotFullRecIn.EntryTime0	<= x"3032_3a33_303a_3030_2e30_3030";	-- 02:30:00.000
		GenSnapShotFullRecIn.EntryType1	<= x"31"; 				-- 1 [offer]
		GenSnapShotFullRecIn.Price1		<= x"3030_3030_3031_3030"; 	-- 00000_00000_00000_00100
		GenSnapShotFullRecIn.Size1		<= x"3030_3032_3030_3030";	-- 0002_0000
		GenSnapShotFullRecIn.EntryTime1	<= x"3032_3a33_303a_3230_2e30_3031";	-- 02:30:20.001
	
		GenCsum                         <= x"303132";		-- 012
		
		-- build msg
		wait until rising_edge(Clk);
		SnapShotBuild(GenHdRecIn,GenSnapShotFullRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSnapShot) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-------------------------------
			-- Test: drop valid for 1 clk
			if ( byte>0 ) then
				FixValid	<= '0';
				wait until rising_edge(Clk);
				wait until rising_edge(Clk);
				FixValid	<= '1';
			end if;
			-------------------------------
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSnapShot ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		----------------------------------------
		-- TT=3: a valid Snapshot with bid/offer market price (special price)
		----------------------------------------
		TM	<=	8; TT <= 3; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0006";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "10000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '0';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0000_0000";
		ExpHdDecRecIn.ErrorTagLen		<= "000000";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0006";	-- 6
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100100";	-- 2020
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11111";			-- 31
		ExpHdDecRecIn.TimeHour		    <= "10110";			-- 22
		ExpHdDecRecIn.TimeMin			<= "110110";		-- 54	
		ExpHdDecRecIn.TimeSec			<= x"000A";			-- 00.010
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "10000000";
		
		ExpSnapShotRecIn.MDReqId			<= x"4d41";			-- MA	
		ExpSnapShotRecIn.MDReqIdLen		    <= "000010";		-- 2
		ExpSnapShotRecIn.SecIndic		    <= "00100";			-- GULF
		ExpSnapShotRecIn.EntriesVal			<= "11";			-- bid/Offer
		ExpSnapShotRecIn.BidPx			    <= x"762A";			-- 30250
		ExpSnapShotRecIn.BidPxNegExp		<= "11";			-- 1e(-3)
		ExpSnapShotRecIn.BidSize			<= x"0000_05DC";	-- 1500
		ExpSnapShotRecIn.BidTimeHour		<= x"04";			-- 04
		ExpSnapShotRecIn.BidTimeMin         <= x"37";			-- 55
		ExpSnapShotRecIn.BidTimeSec         <= x"5225";			-- 21.029
		ExpSnapShotRecIn.BidTimeSecNegExp   <= "11";	
		ExpSnapShotRecIn.OffPx			    <= x"733C";			-- 29500
		ExpSnapShotRecIn.OffPxNegExp		<= "11";			-- 1e(-3)
		ExpSnapShotRecIn.OffSize			<= x"0000_2EE0";	-- 12000
		ExpSnapShotRecIn.OffTimeHour		<= x"04";			-- 04
		ExpSnapShotRecIn.OffTimeMin         <= x"2D";			-- 45
		ExpSnapShotRecIn.OffTimeSec         <= x"0000";			-- 0
		ExpSnapShotRecIn.OffTimeSecNegExp   <= "11";			-- 1e(-3)
		ExpSnapShotRecIn.SpecialPxFlag	    <= "11";
		ExpSnapShotRecIn.NoEntriesError	    <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3032_3338";		-- 000238	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0057";			-- W (SnapShot)
		GenHdRecIn.HdSeqNum		        <= x"3030_3036";			-- 6 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3031_3233_312d_3232_3a35_343a_3030_2e30_3130"; 	-- 20201231-22:54:00.010
		GenHdRecIn.HdLastSeqNumProc     <= x"3030_3035";			-- 5 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSnapShotFullRecIn.MDReqID	<= x"4d41";				-- MA	
		GenSnapShotFullRecIn.Symbol		<= x"0000_4755_4c46"; 	-- GULF
		GenSnapShotFullRecIn.SecID		<= x"33_3030_3337";		-- 30037
		GenSnapShotFullRecIn.SecIDSrc	<= x"0038";				-- 8			
		GenSnapShotFullRecIn.NoEntries	<= x"0032";				-- 2
		GenSnapShotFullRecIn.EntryType0	<= x"30";				-- 0 [bid]
		GenSnapShotFullRecIn.Price0		<= x"3932_3233_3337_3230_3336_3835_342e_3737_3538_3037"; -- 92233_72036_854.7_75807
		GenSnapShotFullRecIn.Size0		<= x"3030_3030_3135_3030";	-- 0000_1500
		GenSnapShotFullRecIn.EntryTime0	<= x"3034_3a35_353a_3231_2e30_3239";	-- 04:55:21.029
		GenSnapShotFullRecIn.EntryType1	<= x"31"; 				-- 1 [offer]
		GenSnapShotFullRecIn.Price1		<= x"302e_3030_3030_3031"; -- 00000_00000_000.0_00001
		GenSnapShotFullRecIn.Size1		<= x"3030_3031_3230_3030";	-- 0001_2000
		GenSnapShotFullRecIn.EntryTime1	<= x"3034_3a34_353a_3030_2e30_3030";	-- 04:45:00.000
	
		GenCsum                         <= x"323138";		-- 218
			
		-- build msg
		wait until rising_edge(Clk);
		SnapShotBuild(GenHdRecIn,GenSnapShotFullRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSnapShot) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSnapShot ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		
		----------------------------------------
		-- TT=4: a invalid Snapshot with TagError [BidPrice, OfferSize error tag]
		----------------------------------------
		TM	<=	8; TT <= 4; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		wait until rising_edge(Clk);
		-- set input
		ExpSeqNum	    <= x"0000_0007";
		
		-- set expected Output
		ExpHdDecRecIn.MsgTypeVal		<= "10000000";
		ExpHdDecRecIn.BLenError			<= '0';
		ExpHdDecRecIn.CSumError			<= '0';
		ExpHdDecRecIn.TagError		    <= '1';
		ExpHdDecRecIn.ErrorTagLatch	    <= x"0039_3939";
		ExpHdDecRecIn.ErrorTagLen		<= "000011";
		ExpHdDecRecIn.SeqNumError		<= '0';
		ExpHdDecRecIn.SeqNum			<= x"0000_0007";	-- 9999
		ExpHdDecRecIn.PossDupFlag		<= '0';
		ExpHdDecRecIn.TimeYear		    <= "11111100101";	-- 2021
		ExpHdDecRecIn.TimeMonth		    <= "1100";			-- 12
		ExpHdDecRecIn.TimeDay			<= "11110";			-- 30
		ExpHdDecRecIn.TimeHour		    <= "10111";			-- 23
		ExpHdDecRecIn.TimeMin			<= "110111";		-- 55	
		ExpHdDecRecIn.TimeSec			<= x"0000";			-- 0
		ExpHdDecRecIn.TimeSecNegExp	    <= "11";			-- 1e(-3)
		ExpHdDecRecIn.MsgVal2User		<= "10000000";
		
		ExpSnapShotRecIn.MDReqId			<= x"4d41";			-- MA	
		ExpSnapShotRecIn.MDReqIdLen		    <= "000010";		-- 2
		ExpSnapShotRecIn.SecIndic		    <= "00001";			-- ADVANC
		ExpSnapShotRecIn.EntriesVal			<= "11";			-- bid/Offer
		ExpSnapShotRecIn.BidPx			    <= x"0096";			-- 150
		ExpSnapShotRecIn.BidPxNegExp		<= "00";	
		ExpSnapShotRecIn.BidSize			<= x"0000_2710";	-- 10000
		ExpSnapShotRecIn.BidTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.BidTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.BidTimeSec         <= x"0000";			-- 0.000
		ExpSnapShotRecIn.BidTimeSecNegExp   <= "11";	
		ExpSnapShotRecIn.OffPx			    <= x"0064";			-- 100
		ExpSnapShotRecIn.OffPxNegExp		<= "00";	
		ExpSnapShotRecIn.OffSize			<= x"0000_4E20";	-- 20000
		ExpSnapShotRecIn.OffTimeHour		<= x"02";			-- 02
		ExpSnapShotRecIn.OffTimeMin         <= x"1E";			-- 30
		ExpSnapShotRecIn.OffTimeSec         <= x"4E21";			-- 20001
		ExpSnapShotRecIn.OffTimeSecNegExp   <= "11";			-- 1e(-3)
		ExpSnapShotRecIn.SpecialPxFlag	    <= "00";
		ExpSnapShotRecIn.NoEntriesError	    <= '0';
		
		-- set signal for msg gen (ASCII)
		GenHdRecIn.HdBeginStr			<= x"4649_5854_2e31_2e31";	-- FIXT.1.1
		GenHdRecIn.HdBodyLen		    <= x"3030_3032_3338";		-- 000238	[size - 20(BeginStr+BLen) - 7 (Csum)]
		GenHdRecIn.HdMsgType		    <= x"0000_0057";			-- W (SnapShot)
		GenHdRecIn.HdSeqNum		        <= x"3030_3037";			-- 0007 (0 must be 30)
		GenHdRecIn.HdSendComID		    <= x"00_0000_0000_0000_0000_0053_4554";				-- SET
		GenHdRecIn.HdTarComID		    <= x"30_3031_355f_4649_585f_4d44_3530";				-- 0015_FIX_ MD50
		GenHdRecIn.HdSendTime		    <= x"32_3032_3131_3233_302d_3233_3a35_353a_3030_2e30_3030"; 	-- 20211230-23:55:00.000
		GenHdRecIn.HdLastSeqNumProc     <= x"3939_3938";			-- 9998 (0 must be 30)
		GenHdRecIn.HdPossDup		    <= x"4e";					-- N
		
		GenSnapShotFullRecIn.MDReqID	<= x"4d41";				-- MA	
		GenSnapShotFullRecIn.Symbol		<= x"4144_5641_4e43"; 	-- ADVANC
		GenSnapShotFullRecIn.SecID		<= x"30_3130_3639";		-- 01069
		GenSnapShotFullRecIn.SecIDSrc	<= x"0038";				-- 8			
		GenSnapShotFullRecIn.NoEntries	<= x"0032";				-- 2
		GenSnapShotFullRecIn.EntryType0	<= x"30";				-- 0 [bid]
		GenSnapShotFullRecIn.Price0		<= x"3030_3030_3030_3030_3030_3030_3030_3030_3031_3530"; -- 00000_00000_00000_00150
		GenSnapShotFullRecIn.Size0		<= x"3030_3031_3030_3030";	-- 0001_0000
		GenSnapShotFullRecIn.EntryTime0	<= x"3032_3a33_303a_3030_2e30_3030";	-- 02:30:00.000
		GenSnapShotFullRecIn.EntryType1	<= x"31"; 				-- 1 [offer]
		GenSnapShotFullRecIn.Price1		<= x"3030_3030_3031_3030"; 	-- 00000_00000_00000_00100
		GenSnapShotFullRecIn.Size1		<= x"3030_3032_3030_3030";	-- 0002_0000
		GenSnapShotFullRecIn.EntryTime1	<= x"3032_3a33_303a_3230_2e30_3031";	-- 02:30:20.001
	
		GenCsum                         <= x"303434";		-- 044 [changed via error tag]
		
		-- build msg
		wait until rising_edge(Clk);
		SnapShotBuild_Error(GenHdRecIn,GenSnapShotFullRecIn,GenCsum,All_array(0));
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to (cSnapShot) loop
			-- feed (a byte) input 
			FixData		<= All_array(0)(byte);
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=cSnapShot ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		--------------------------------------------------------------------------
		--	TM=9 : Unknow message
		--------------------------------------------------------------------------	
		-- TT=0: 
		----------------------------------------
		TM	<=	9; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- feed message
		wait until rising_edge(Clk);
		For byte in 0 to 9 loop
			-- feed (a byte) input 
			FixData		<= x"02";
			-- first byte of message, set SOP
			if ( byte=0 ) then
				FixSOP		<= '1';
				FixValid	<= '1';
			end if;
			-- second byte of message, reset SOP
			if ( byte=1 ) then
				FixSOP		<= '0';
			end if;
			-- last byte of message, set EOP
			if ( byte=9 ) then
				FixEOP		<= '1';
			end if;
			wait until rising_edge(Clk);
		End loop;
		
		-- reset valid and EOP
		FixEOP		<= '0';
		FixValid	<= '0';
		wait for 6*tClk;
		
		--------------------------------------------------------------------------
		-- TM=255 : End
		--------------------------------------------------------------------------		
		TM <= 255; wait for 1 ns;
		wait for 100*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
	
	--------------------------------------------------------------------------
	-- Verify
	--------------------------------------------------------------------------
	u_Verify : Process
	variable	TM_t	: integer range 0 to 65535 := 0;
	variable	TT_t	: integer range 0 to 65535 := 0;
	
	Begin
		wait until rising_edge(Clk);
		-------------------------------------------	
		-- TM=1: LogOn
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Logon
		TM_t := 1; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_LogOn(Clk,ExpHdDecRecIn,ExpLogOnRecIn,OutHdDecRecIn,OutLogOnRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : LogOn with 1-clk toggling valid / EncrptMetError/ AppVerIdError
		TM_t := 1; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_LogOn(Clk,ExpHdDecRecIn,ExpLogOnRecIn,OutHdDecRecIn,OutLogOnRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 2 : Dropped LogOn with invalid Begin string
		TM_t := 1; TT_t := 2;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_LogOn(Clk,ExpHdDecRecIn,ExpLogOnRecIn,OutHdDecRecIn,OutLogOnRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 3 : Reset Seqnum with unexpected incomiing Seqnum
		TM_t := 1; TT_t := 3;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_LogOn(Clk,ExpHdDecRecIn,ExpLogOnRecIn,OutHdDecRecIn,OutLogOnRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=2: LogOut
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid LogOut
		TM_t := 2; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_Empty(Clk,ExpHdDecRecIn,OutHdDecRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : LogOut with BLenError/ CsumError
		TM_t := 2; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_Empty(Clk,ExpHdDecRecIn,OutHdDecRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 2 : Send next valid LogOut immediately
		TM_t := 2; TT_t := 2;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_Empty(Clk,ExpHdDecRecIn,OutHdDecRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
	
	
		-------------------------------------------	
		-- TM=3: Heartbeat
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Heartbeat
		TM_t := 3; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_TestReqId(Clk,ExpHdDecRecIn, ExpTestReqIdRecIn, OutHdDecRecIn, OutTestReqIdRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
	
		-------------------------------------------
		-- TT = 1 : valid Heartbeat without TestReqID field
		TM_t := 3; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_TestReqId(Clk,ExpHdDecRecIn, ExpTestReqIdRecIn, OutHdDecRecIn, OutTestReqIdRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : valid Heartbeat with TestReqID field, 1-clk toggling
		TM_t := 3; TT_t := 2;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_TestReqId(Clk,ExpHdDecRecIn, ExpTestReqIdRecIn, OutHdDecRecIn, OutTestReqIdRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=4: TestReq
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid TestReq
		TM_t := 4; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_TestReqId(Clk,ExpHdDecRecIn, ExpTestReqIdRecIn, OutHdDecRecIn, OutTestReqIdRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : Drop TCPConnect
		TM_t := 4; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_TestReqId(Clk,ExpHdDecRecIn, ExpTestReqIdRecIn, OutHdDecRecIn, OutTestReqIdRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=5: Resent Request
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Resent Request
		TM_t := 5; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_ResendReq(Clk,ExpHdDecRecIn, ExpResentReqRecIn, OutHdDecRecIn, OutResentReqRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : valid Resent Request with 1-clk toggling 
		TM_t := 5; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_ResendReq(Clk,ExpHdDecRecIn, ExpResentReqRecIn, OutHdDecRecIn, OutResentReqRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=6: Reject
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Reject
		TM_t := 6; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_Reject(Clk,ExpHdDecRecIn, ExpRejectRecIn, OutHdDecRecIn, OutRejectRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : valid Reject with 1-clk toggling
		TM_t := 6; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_Reject(Clk,ExpHdDecRecIn, ExpRejectRecIn, OutHdDecRecIn, OutRejectRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=7: Seq Rst
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Seq Rst
		TM_t := 7; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SeqRst(Clk,ExpHdDecRecIn, ExpSeqRstRecIn, OutHdDecRecIn, OutSeqRstRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : valid Seq Rst with 1-clk toggling
		TM_t := 7; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SeqRst(Clk,ExpHdDecRecIn, ExpSeqRstRecIn, OutHdDecRecIn, OutSeqRstRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		-------------------------------------------	
		-- TM=8: Snapshot
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : valid Snapshot
		TM_t := 8; TT_t := 0;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SnapShot(Clk,ExpHdDecRecIn, ExpSnapShotRecIn, OutHdDecRecIn, OutSnapShotRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 1 : valid Snapshot with 1-clk toggling
		TM_t := 8; TT_t := 1;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SnapShot(Clk,ExpHdDecRecIn, ExpSnapShotRecIn, OutHdDecRecIn, OutSnapShotRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 2 : valid Snapshot with 2-clk toggling
		TM_t := 8; TT_t := 2;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SnapShot(Clk,ExpHdDecRecIn, ExpSnapShotRecIn, OutHdDecRecIn, OutSnapShotRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 3 : valid Snapshot with bid/offer market price (special price)
		TM_t := 8; TT_t := 3;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SnapShot(Clk,ExpHdDecRecIn, ExpSnapShotRecIn, OutHdDecRecIn, OutSnapShotRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		-------------------------------------------
		-- TT = 4 : a invalid Snapshot with TagError [BidPrice, OfferSize error tag]
		TM_t := 8; TT_t := 4;
		wait until (TM_t=TM and TT_t=TT);
		Report "TM_t="&integer'image(TM_t)&" TT_t="&integer'image(TT_t);
		
		wait until rising_edge(FixEOP_t);
		wait for 4*t_Clk;
		Verify_SnapShot(Clk,ExpHdDecRecIn, ExpSnapShotRecIn, OutHdDecRecIn, OutSnapShotRecIn);
		Report "TM="&integer'image(TM_t)&" and TT="&integer'image(TT_t)&" is valid";
		
		
		
		
		wait for 5*tClk;
		Report "##### Verified #####";
	
	End Process u_Verify;
	
End Architecture HTWTestBench;