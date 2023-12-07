----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		PkTbFixProc.vhd
-- Title		Signal declaration for TbFixProc
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
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;
use work.PkTbFixProc.all;

Package PkSigTbFixProc Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant	tClk					: time 	  := 10 ns;
	
----------------------------------------------------------------------------------
-- Signal declaration																
----------------------------------------------------------------------------------
	
	signal	TM							: integer	range 0 to 65535;
	signal	TT							: integer	range 0 to 65535;
	
	signal	RstB						: std_logic;
	signal	Clk							: std_logic;
	
	---------------------------------------------
	-- Input 
	signal	User2FixConn				: std_logic;
	signal	User2FixDisConn			    : std_logic;
	signal	User2FixRTCTime			    : std_logic_vector( 50 downto 0 );
	signal	User2FixSenderCompID		: std_logic_vector(127 downto 0 );
	signal	User2FixTargetCompID		: std_logic_vector(127 downto 0 );
	signal	User2FixUsername			: std_logic_vector(127 downto 0 );
	signal	User2FixPassword            : std_logic_vector(127 downto 0 );
	signal	User2FixSenderCompIDLen	    : std_logic_vector( 4  downto 0 );
	signal	User2FixTargetCompIDLen	    : std_logic_vector( 4  downto 0 );
	signal	User2FixUsernameLen		    : std_logic_vector( 4  downto 0 );
	signal	User2FixPasswordLen	        : std_logic_vector( 4  downto 0 );
	signal	User2FixIdValid 	 		: std_logic;
	signal	User2FixRxSenderId			: std_logic_vector(103 downto 0 );
	signal	User2FixRxTargetId			: std_logic_vector(103 downto 0 );
	signal	User2FixMrketData0			: std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData1		    : std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData2		    : std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData3		    : std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData4		    : std_logic_vector( 9 downto 0 );
	signal	User2FixNoRelatedSym		: std_logic_vector( 3  downto 0 ); 
	signal	User2FixMDEntryTypes		: std_logic_vector(15  downto 0 ); 
	signal	User2FixNoMDEntryTypes	    : std_logic_vector( 2  downto 0 ); 
	signal	TOE2FixStatus				: std_logic_vector( 3 downto 0 );	
	signal	TOE2FixPSHFlagset			: std_logic;
	signal	TOE2FixFINFlagset           : std_logic;
	signal	TOE2FixRSTFlagset           : std_logic;
	signal	TOE2FixMemAlFull			: std_logic;
	
	signal  RxDataRec					: RxTCPDataRecord; 
	
	-- Mapping signal 
	signal	User2FixConn_t				: std_logic;
	signal	User2FixDisConn_t			: std_logic;
	signal	User2FixRTCTime_t			: std_logic_vector( 50 downto 0 );
	signal	User2FixSenderCompID_t		: std_logic_vector(127 downto 0 );
	signal	User2FixTargetCompID_t		: std_logic_vector(127 downto 0 );
	signal	User2FixUsername_t			: std_logic_vector(127 downto 0 );
	signal	User2FixPassword_t      	: std_logic_vector(127 downto 0 );
	signal	User2FixSenderCompIDLen_t 	: std_logic_vector( 4  downto 0 );
	signal	User2FixTargetCompIDLen_t 	: std_logic_vector( 4  downto 0 );
	signal	User2FixUsernameLen_t		: std_logic_vector( 4  downto 0 );
	signal	User2FixPasswordLen_t		: std_logic_vector( 4  downto 0 );
	signal	User2FixIdValid_t 	 		: std_logic;
	signal	User2FixRxSenderId_t		: std_logic_vector(103 downto 0 );
	signal	User2FixRxTargetId_t		: std_logic_vector(103 downto 0 );
	signal	User2FixMrketData0_t		: std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData1_t		: std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData2_t		: std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData3_t		: std_logic_vector( 9 downto 0 );
	signal	User2FixMrketData4_t		: std_logic_vector( 9 downto 0 );
	signal	User2FixNoRelatedSym_t		: std_logic_vector( 3  downto 0 ); 
	signal	User2FixMDEntryTypes_t		: std_logic_vector(15  downto 0 ); 
	signal	User2FixNoMDEntryTypes_t	: std_logic_vector( 2  downto 0 ); 
	signal	TOE2FixStatus_t				: std_logic_vector( 3 downto 0 );	
	signal	TOE2FixPSHFlagset_t 		: std_logic;
	signal	TOE2FixFINFlagset_t         : std_logic;
	signal	TOE2FixRSTFlagset_t         : std_logic;
	signal	TOE2FixMemAlFull_t			: std_logic;
	signal	TOE2FixRxSOP_t				: std_logic;
	signal	TOE2FixRxValid_t			: std_logic;
	signal	TOE2FixRxEOP_t				: std_logic;
	signal	TOE2FixRxData_t				: std_logic_vector( 7 downto 0 );	

	------------------------------------------
	-- output 
	signal	Fix2TOEDataVal				: std_logic;
	signal	Fix2TOEDataSop	            : std_logic;
	signal	Fix2TOEDataEop	            : std_logic;
	signal	Fix2TOEData		            : std_logic_vector( 7  downto 0 );
	signal	Fix2TOEDataLen	            : std_logic_vector(15  downto 0 );
	signal	Fix2TOERxDataReq			: std_logic;
	signal	Fix2TOEConnectReq		    : std_logic;
	signal	Fix2TOETerminateReq			: std_logic;
	signal	Fix2UserOperate				: std_logic;
	signal	Fix2UserNoEntriesError		: std_logic; 
	signal	Fix2UserError 	        	: std_logic_vector( 3 downto 0 );	
	signal	Fix2UserMsgVal2User			: std_logic_vector( 7 downto 0 );
	signal	Fix2UserSecIndic			: std_logic_vector( 4 downto 0 );   
	signal	Fix2UserEntriesVal			: std_logic_vector( 1 downto 0 );
	signal	Fix2UserBidPx				: std_logic_vector( 15 downto 0 );
	signal	Fix2UserBidPxNegExp			: std_logic_vector( 1 downto 0 );
	signal	Fix2UserBidSize				: std_logic_vector( 31 downto 0 );
	signal	Fix2UserBidTimeHour			: std_logic_vector( 7 downto 0 );
	signal	Fix2UserBidTimeMin          : std_logic_vector( 7 downto 0 ); 
	signal	Fix2UserBidTimeSec          : std_logic_vector( 15 downto 0 ); 
	signal	Fix2UserBidTimeSecNegExp    : std_logic_vector( 1 downto 0 ); 
	signal	Fix2UserOffPx			    : std_logic_vector( 15 downto 0 );
	signal	Fix2UserOffPxNegExp		    : std_logic_vector( 1 downto 0 );
	signal	Fix2UserOffSize			    : std_logic_vector( 31 downto 0 );
	signal	Fix2UserOffTimeHour		    : std_logic_vector( 7 downto 0 );
	signal	Fix2UserOffTimeMin          : std_logic_vector( 7 downto 0 ); 
	signal	Fix2UserOffTimeSec          : std_logic_vector( 15 downto 0 ); 
	signal	Fix2UserOffTimeSecNegExp    : std_logic_vector( 1 downto 0 ); 
	signal	Fix2UserSpecialPxFlag	    : std_logic_vector( 1 downto 0 );

	signal  TxDataRec					: FixOutDataRecord;   
	
	-- Mapping signal 
	signal	Fix2TOEDataVal_t			: std_logic;
	signal	Fix2TOEDataSop_t	        : std_logic;
	signal	Fix2TOEDataEop_t	        : std_logic;
	signal	Fix2TOEData_t	            : std_logic_vector( 7  downto 0 );
	signal	Fix2TOEDataLen_t	        : std_logic_vector(15  downto 0 );
	signal	Fix2TOERxDataReq_t			: std_logic;
	signal	Fix2TOEConnectReq_t         : std_logic;
	signal	Fix2TOETerminateReq_t    	: std_logic;
	signal	Fix2UserOperate_t        	: std_logic;
	signal	Fix2UserNoEntriesError_t	: std_logic; 
	signal	Fix2UserError_t  	     	: std_logic_vector( 3 downto 0 );	
	signal	Fix2UserMsgVal2User_t		: std_logic_vector( 7 downto 0 );
	signal	Fix2UserSecIndic_t			: std_logic_vector( 4 downto 0 );   
	signal	Fix2UserEntriesVal_t		: std_logic_vector( 1 downto 0 );
	signal	Fix2UserBidPx_t				: std_logic_vector( 15 downto 0 );
	signal	Fix2UserBidPxNegExp_t		: std_logic_vector( 1 downto 0 );
	signal	Fix2UserBidSize_t			: std_logic_vector( 31 downto 0 );
	signal	Fix2UserBidTimeHour_t		: std_logic_vector( 7 downto 0 );
	signal	Fix2UserBidTimeMin_t        : std_logic_vector( 7 downto 0 ); 
	signal	Fix2UserBidTimeSec_t        : std_logic_vector( 15 downto 0 ); 
	signal	Fix2UserBidTimeSecNegExp_t  : std_logic_vector( 1 downto 0 ); 
	signal	Fix2UserOffPx_t			    : std_logic_vector( 15 downto 0 );
	signal	Fix2UserOffPxNegExp_t		: std_logic_vector( 1 downto 0 );
	signal	Fix2UserOffSize_t			: std_logic_vector( 31 downto 0 );
	signal	Fix2UserOffTimeHour_t		: std_logic_vector( 7 downto 0 );
	signal	Fix2UserOffTimeMin_t        : std_logic_vector( 7 downto 0 ); 
	signal	Fix2UserOffTimeSec_t        : std_logic_vector( 15 downto 0 ); 
	signal	Fix2UserOffTimeSecNegExp_t  : std_logic_vector( 1 downto 0 ); 
	signal	Fix2UserSpecialPxFlag_t	    : std_logic_vector( 1 downto 0 );
	
	------------------------------------------
	-- Others
	signal  RTCTimeYear					: std_logic_vector(13 downto 0 );
	signal  RTCTimeMonth				: std_logic_vector( 3 downto 0 );
	signal  RTCTimeDay					: std_logic_vector( 4 downto 0 );
	signal  RTCTimeHour					: std_logic_vector( 4 downto 0 );
	signal  RTCTimeMin					: std_logic_vector( 5 downto 0 );
	signal  RTCTimeMilliSec				: std_logic_vector(16 downto 0 );

End Package PkSigTbFixProc;		