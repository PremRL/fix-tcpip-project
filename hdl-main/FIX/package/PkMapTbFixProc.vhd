----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		PkTbFixProc.vhd
-- Title		Mapping for TbFixProc
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       L.Ratchanon 
-- Date         2021/02/20
-- Remark       
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.PkSigTbFixProc.all;

Entity PkMapTbFixProc Is
End Entity PkMapTbFixProc;

Architecture HTWTestBench Of PkMapTbFixProc Is 

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component FixProc Is
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
	End Component FixProc;

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
				wait for 100*tClk;
				wait until rising_edge(Clk);
				TOE2FixStatus	<= "0100";
			elsif ( Fix2TOETerminateReq='1' and TOE2FixStatus="0100" ) then 
				TOE2FixStatus	<= "1000";
				wait for 100*tClk;
				wait until rising_edge(Clk);
				TOE2FixStatus	<= "0001";
			else 
				TOE2FixStatus	<= TOE2FixStatus;
			end if; 
		end if;
		wait until rising_edge(Clk);
	End Process u_TOEStatus;
	
	u_FixProc: FixProc 
	Port map                        
	(                               
		Clk							=> Clk							,
		RstB						=> RstB					    	,

		TOE2FixMemAlFull			=> TOE2FixMemAlFull_t			,
		Fix2TOEDataVal				=> Fix2TOEDataVal_t				,
		Fix2TOEDataSop				=> Fix2TOEDataSop_t				,
		Fix2TOEDataEop				=> Fix2TOEDataEop_t				,
		Fix2TOEData					=> Fix2TOEData_t				,
		Fix2TOEDataLen				=> Fix2TOEDataLen_t				,

		Fix2TOERxDataReq			=> Fix2TOERxDataReq_t			,
		TOE2FixRxSOP				=> TOE2FixRxSOP_t				,
		TOE2FixRxValid				=> TOE2FixRxValid_t				,
		TOE2FixRxEOP				=> TOE2FixRxEOP_t				,
		TOE2FixRxData				=> TOE2FixRxData_t				,

		TOE2FixStatus				=> TOE2FixStatus_t				,
		TOE2FixPSHFlagset           => TOE2FixPSHFlagset_t      	,
		TOE2FixFINFlagset           => TOE2FixFINFlagset_t      	,
		TOE2FixRSTFlagset           => TOE2FixRSTFlagset_t      	,
		Fix2TOEConnectReq			=> Fix2TOEConnectReq_t			,
		Fix2TOETerminateReq			=> Fix2TOETerminateReq_t		,

		User2FixConn				=> User2FixConn_t				,
		User2FixDisConn			    => User2FixDisConn_t			, 
		User2FixRTCTime			    => User2FixRTCTime_t			, 
		User2FixSenderCompID		=> User2FixSenderCompID_t		,
		User2FixTargetCompID		=> User2FixTargetCompID_t		,
		User2FixUsername			=> User2FixUsername_t			,
		User2FixPassword            => User2FixPassword_t       	,
		User2FixSenderCompIDLen	    => User2FixSenderCompIDLen_t	, 
		User2FixTargetCompIDLen	    => User2FixTargetCompIDLen_t	, 
		User2FixUsernameLen		    => User2FixUsernameLen_t		, 
		User2FixPasswordLen	        => User2FixPasswordLen_t		,  

		User2FixIdValid 	 		=> User2FixIdValid_t 	 		,
		User2FixRxSenderId			=> User2FixRxSenderId_t			,
		User2FixRxTargetId			=> User2FixRxTargetId_t			,

		User2FixMrketData0			=> User2FixMrketData0_t			,
		User2FixMrketData1		    => User2FixMrketData1_t			,
		User2FixMrketData2		    => User2FixMrketData2_t			,
		User2FixMrketData3		    => User2FixMrketData3_t			,
		User2FixMrketData4		    => User2FixMrketData4_t			,
		User2FixNoRelatedSym		=> User2FixNoRelatedSym_t		,
		User2FixMDEntryTypes		=> User2FixMDEntryTypes_t		,
		User2FixNoMDEntryTypes	    => User2FixNoMDEntryTypes_t		,
		
		Fix2UserMsgVal2User			=> Fix2UserMsgVal2User_t		,		
		Fix2UserSecIndic			=> Fix2UserSecIndic_t			,
		Fix2UserEntriesVal			=> Fix2UserEntriesVal_t			,
		Fix2UserBidPx				=> Fix2UserBidPx_t				,
		Fix2UserBidPxNegExp			=> Fix2UserBidPxNegExp_t		,	
		Fix2UserBidSize				=> Fix2UserBidSize_t			,	
		Fix2UserBidTimeHour			=> Fix2UserBidTimeHour_t		,	
		Fix2UserBidTimeMin          => Fix2UserBidTimeMin_t         ,
		Fix2UserBidTimeSec          => Fix2UserBidTimeSec_t         , 
		Fix2UserBidTimeSecNegExp    => Fix2UserBidTimeSecNegExp_t   , 

		Fix2UserOffPx			    => Fix2UserOffPx_t			    ,
		Fix2UserOffPxNegExp		    => Fix2UserOffPxNegExp_t		,    
		Fix2UserOffSize			    => Fix2UserOffSize_t			,    
		Fix2UserOffTimeHour		    => Fix2UserOffTimeHour_t		,    
		Fix2UserOffTimeMin          => Fix2UserOffTimeMin_t         , 
		Fix2UserOffTimeSec          => Fix2UserOffTimeSec_t         , 
		Fix2UserOffTimeSecNegExp    => Fix2UserOffTimeSecNegExp_t   , 
		Fix2UserSpecialPxFlag	    => Fix2UserSpecialPxFlag_t	    ,
	
		Fix2UserError 			    => Fix2UserError_t 				,
		Fix2UserOperate			    => Fix2UserOperate_t			, 	 
		Fix2UserNoEntriesError		=> Fix2UserNoEntriesError_t		
	);
	
-- Signal assignment from Testbench to FixCtrl with delay time
	TOE2FixMemAlFull_t			<= TOE2FixMemAlFull				after 1 ns;
    TOE2FixRxSOP_t				<= RxDataRec.RxTCPSop			after 1 ns;
	TOE2FixRxValid_t			<= RxDataRec.RxTCPValid			after 1 ns;
	TOE2FixRxEOP_t				<= RxDataRec.RxTCPEop			after 1 ns;
	TOE2FixRxData_t				<= RxDataRec.RxTCPData			after 1 ns;
	TOE2FixStatus_t				<= TOE2FixStatus				after 1 ns;
	TOE2FixPSHFlagset_t     	<= TOE2FixPSHFlagset            after 1 ns;
	TOE2FixFINFlagset_t     	<= TOE2FixFINFlagset            after 1 ns;
	TOE2FixRSTFlagset_t     	<= TOE2FixRSTFlagset            after 1 ns;
	User2FixConn_t				<= User2FixConn				    after 1 ns;
	User2FixDisConn_t			<= User2FixDisConn			    after 1 ns;
	User2FixRTCTime_t			<= User2FixRTCTime			    after 1 ns;
	User2FixSenderCompID_t		<= User2FixSenderCompID		    after 1 ns;
	User2FixTargetCompID_t		<= User2FixTargetCompID		    after 1 ns;
	User2FixUsername_t			<= User2FixUsername			    after 1 ns;
	User2FixPassword_t      	<= User2FixPassword             after 1 ns;
	User2FixSenderCompIDLen_t 	<= User2FixSenderCompIDLen	    after 1 ns;
	User2FixTargetCompIDLen_t 	<= User2FixTargetCompIDLen	    after 1 ns;
	User2FixUsernameLen_t		<= User2FixUsernameLen		    after 1 ns;
	User2FixPasswordLen_t		<= User2FixPasswordLen	        after 1 ns;
	User2FixIdValid_t 	 		<= User2FixIdValid 	 		    after 1 ns;
	User2FixRxSenderId_t		<= User2FixRxSenderId			after 1 ns;	
	User2FixRxTargetId_t		<= User2FixRxTargetId			after 1 ns;	
	User2FixMrketData0_t		<= User2FixMrketData0			after 1 ns;	
	User2FixMrketData1_t		<= User2FixMrketData1		    after 1 ns;	
	User2FixMrketData2_t		<= User2FixMrketData2		    after 1 ns;	
	User2FixMrketData3_t		<= User2FixMrketData3		    after 1 ns;	
	User2FixMrketData4_t		<= User2FixMrketData4		    after 1 ns;	
	User2FixNoRelatedSym_t		<= User2FixNoRelatedSym		    after 1 ns;
	User2FixMDEntryTypes_t		<= User2FixMDEntryTypes		    after 1 ns;
	User2FixNoMDEntryTypes_t	<= User2FixNoMDEntryTypes	    after 1 ns;	
	
	
-- Signal assignment from FixCtrl to Testbench with delay time
	Fix2TOEDataVal				<= Fix2TOEDataVal_t				after 1 ns;	
	Fix2TOEDataSop	            <= Fix2TOEDataSop_t	            after 1 ns;	
	Fix2TOEDataEop	            <= Fix2TOEDataEop_t	            after 1 ns;	
	Fix2TOEData		            <= Fix2TOEData_t	            after 1 ns;	
	Fix2TOEDataLen	            <= Fix2TOEDataLen_t	            after 1 ns;	
	Fix2TOERxDataReq			<= Fix2TOERxDataReq_t			after 1 ns;					 
	Fix2TOEConnectReq			<= Fix2TOEConnectReq_t          after 1 ns;	
	Fix2TOETerminateReq			<= Fix2TOETerminateReq_t        after 1 ns;	
	Fix2UserOperate				<= Fix2UserOperate_t            after 1 ns;	
	Fix2UserError 	            <= Fix2UserError_t  	        after 1 ns;	
	Fix2UserNoEntriesError		<= Fix2UserNoEntriesError_t		after 1 ns;	
	Fix2UserMsgVal2User			<= Fix2UserMsgVal2User_t		after 1 ns;	
	Fix2UserSecIndic			<= Fix2UserSecIndic_t			after 1 ns;	
	Fix2UserEntriesVal			<= Fix2UserEntriesVal_t			after 1 ns;	
	Fix2UserBidPx				<= Fix2UserBidPx_t				after 1 ns;	
	Fix2UserBidPxNegExp			<= Fix2UserBidPxNegExp_t		after 1 ns;	
	Fix2UserBidSize				<= Fix2UserBidSize_t			after 1 ns;	
	Fix2UserBidTimeHour			<= Fix2UserBidTimeHour_t		after 1 ns;	
	Fix2UserBidTimeMin          <= Fix2UserBidTimeMin_t         after 1 ns;	
	Fix2UserBidTimeSec          <= Fix2UserBidTimeSec_t         after 1 ns;	
	Fix2UserBidTimeSecNegExp    <= Fix2UserBidTimeSecNegExp_t   after 1 ns;	
	Fix2UserOffPx			    <= Fix2UserOffPx_t			    after 1 ns;	
	Fix2UserOffPxNegExp		    <= Fix2UserOffPxNegExp_t		after 1 ns;	
	Fix2UserOffSize			    <= Fix2UserOffSize_t			after 1 ns;	
	Fix2UserOffTimeHour		    <= Fix2UserOffTimeHour_t		after 1 ns;	
	Fix2UserOffTimeMin          <= Fix2UserOffTimeMin_t         after 1 ns;	
	Fix2UserOffTimeSec          <= Fix2UserOffTimeSec_t         after 1 ns;	
	Fix2UserOffTimeSecNegExp    <= Fix2UserOffTimeSecNegExp_t   after 1 ns;	
	Fix2UserSpecialPxFlag	    <= Fix2UserSpecialPxFlag_t	    after 1 ns;	
	
-- Sendtime mapping 
	User2FixRTCTime(50 downto 0)<= RTCTimeYear&RTCTimeMonth&RTCTimeDay
									&RTCTimeHour&RTCTimeMin&RTCTimeMilliSec;

-- Signal assignment from Testbench for Verifying
	TxDataRec.FixOutDataVal		<= Fix2TOEDataVal;		
	TxDataRec.FixOutDataSop	    <= Fix2TOEDataSop;	   
	TxDataRec.FixOutDataEop	    <= Fix2TOEDataEop;	    
	TxDataRec.FixOutData		<= Fix2TOEData;		        
    TxDataRec.FixOutDataLen	    <= Fix2TOEDataLen;
	
End Architecture HTWTestBench;