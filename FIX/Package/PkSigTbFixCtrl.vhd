----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkSigTbFixCtrl.vhd
-- Title        Signal Declaration of TbFixCtrl
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
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;
use work.PkTbFixCtrl.all;

Package PkSigTbFixCtrl Is

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
	signal  UserFixConn					: std_logic;	
	signal  UserFixDisConn				: std_logic;	
	signal  UserFixRTCTime				: std_logic_vector( 50 downto 0 );	
	signal  UserFixSenderCompID			: std_logic_vector(127 downto 0 );	
	signal  UserFixTargetCompID			: std_logic_vector(127 downto 0 );	
	signal  UserFixUsername				: std_logic_vector(127 downto 0 );	
	signal  UserFixPassword         	: std_logic_vector(127 downto 0 );   
	signal  UserFixSenderCompIDLen		: std_logic_vector( 4  downto 0 );	
	signal  UserFixTargetCompIDLen		: std_logic_vector( 4  downto 0 );	
	signal  UserFixUsernameLen			: std_logic_vector( 4  downto 0 );	
	signal  UserFixPasswordLen	    	: std_logic_vector( 4  downto 0 );
	
	signal  UserFixMrketData0			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData1			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData2			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData3			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData4			: std_logic_vector( 9 downto 0 );	
	signal  UserFixNoRelatedSym			: std_logic_vector( 3  downto 0 );	
	signal  UserFixMDEntryTypes			: std_logic_vector(15  downto 0 );	
	signal  UserFixNoMDEntryTypes		: std_logic_vector( 2  downto 0 );
	
	signal  TOE2FixStatus		    	: std_logic_vector( 3 downto 0 );	  
	signal  TOE2FixPSHFlagset	    	: std_logic;  
	signal  TOE2FixFINFlagset 	    	: std_logic;  
	signal  TOE2FixRSTFlagset	    	: std_logic;
	
	signal  Tx2CtrlBusy           		: std_logic;
	
	signal  Tx2CtrlMrketVal				: std_logic_vector( 4 downto 0 );	
	signal  Tx2CtrlMrketSymbol0			: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID0		: std_logic_vector(15 downto 0 );	
	signal  Tx2CtrlMrketSymbol1			: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID1 	: std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol2			: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID2 	: std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol3			: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID3 	: std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol4			: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID4 	: std_logic_vector(15 downto 0 );   
	
	-- Mapping signal 
	signal  UserFixConn_t				: std_logic;	
	signal  UserFixDisConn_t			: std_logic;	
	signal  UserFixRTCTime_t			: std_logic_vector( 50 downto 0 );	
	signal  UserFixSenderCompID_t		: std_logic_vector(127 downto 0 );	
	signal  UserFixTargetCompID_t		: std_logic_vector(127 downto 0 );	
	signal  UserFixUsername_t			: std_logic_vector(127 downto 0 );	
	signal  UserFixPassword_t       	: std_logic_vector(127 downto 0 );   
	signal  UserFixSenderCompIDLen_t	: std_logic_vector( 4  downto 0 );	
	signal  UserFixTargetCompIDLen_t	: std_logic_vector( 4  downto 0 );	
	signal  UserFixUsernameLen_t		: std_logic_vector( 4  downto 0 );	
	signal  UserFixPasswordLen_t		: std_logic_vector( 4  downto 0 );

	signal  UserFixMrketData0_t			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData1_t			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData2_t			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData3_t			: std_logic_vector( 9 downto 0 );	
	signal  UserFixMrketData4_t			: std_logic_vector( 9 downto 0 );	
	signal  UserFixNoRelatedSym_t		: std_logic_vector( 3  downto 0 );	
	signal  UserFixMDEntryTypes_t		: std_logic_vector(15  downto 0 );	
	signal  UserFixNoMDEntryTypes_t		: std_logic_vector( 2  downto 0 );

	signal  TOE2FixStatus_t		  		: std_logic_vector( 3 downto 0 );	  
	signal  TOE2FixPSHFlagset_t	  		: std_logic;  
	signal  TOE2FixFINFlagset_t    		: std_logic;  
	signal  TOE2FixRSTFlagset_t	  		: std_logic;

	signal  Tx2CtrlBusy_t           	: std_logic;

	signal  Tx2CtrlMrketVal_t			: std_logic_vector( 4 downto 0 );	
	signal  Tx2CtrlMrketSymbol0_t		: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID0_t	: std_logic_vector(15 downto 0 );	
	signal  Tx2CtrlMrketSymbol1_t		: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID1_t   : std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol2_t		: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID2_t   : std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol3_t		: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID3_t   : std_logic_vector(15 downto 0 );   
	signal  Tx2CtrlMrketSymbol4_t		: std_logic_vector(47 downto 0 );	
	signal  Tx2CtrlMrketSecurityID4_t   : std_logic_vector(15 downto 0 );   

	signal  Rx2CtrlSeqNum_t				: std_logic_vector(31 downto 0 );  
	signal  Rx2CtrlMsgTypeVal_t			: std_logic_vector( 7 downto 0 );   
	signal  Rx2CtrlSeqNumError_t		: std_logic;  
	signal  Rx2CtrlPossDupFlag_t		: std_logic;  
	signal  Rx2CtrlMsgTimeYear_t		: std_logic_vector(10 downto 0 );   
	signal  Rx2CtrlMsgTimeMonth_t		: std_logic_vector( 3 downto 0 );   
	signal  Rx2CtrlMsgTimeDay_t			: std_logic_vector( 4 downto 0 );   
	signal  Rx2CtrlMsgTimeHour_t		: std_logic_vector( 4 downto 0 );   
	signal  Rx2CtrlMsgTimeMin_t			: std_logic_vector( 5 downto 0 );   
	signal  Rx2CtrlMsgTimeSec_t			: std_logic_vector(15 downto 0 );   
	signal  Rx2CtrlMsgTimeSecNegExp_t	: std_logic_vector( 1 downto 0 );   
	signal  Rx2CtrlTagErrorFlag_t		: std_logic;  
	signal  Rx2CtrlErrorTagLatch_t		: std_logic_vector(31 downto 0 );      
	signal  Rx2CtrlErrorTagLen_t		: std_logic_vector( 5 downto 0 );  
	signal  Rx2CtrlBodyLenError_t		: std_logic;  
	signal  Rx2CtrlCsumError_t			: std_logic;      
	signal  Rx2CtrlEncryptMetError_t	: std_logic;  
	signal  Rx2CtrlAppVerIdError_t		: std_logic;      
	signal  Rx2CtrlHeartBtInt_t			: std_logic_vector( 7 downto 0 );   
	signal  Rx2CtrlResetSeqNumFlag_t	: std_logic;  
	signal  Rx2CtrlTestReqId_t			: std_logic_vector(63 downto 0 );       
	signal  Rx2CtrlTestReqIdLen_t		: std_logic_vector( 5 downto 0 );   
	signal	Rx2CtrlTestReqIdVal_t		: std_logic;
	signal  Rx2CtrlBeginSeqNum_t		: std_logic_vector(31 downto 0 );   
	signal  Rx2CtrlEndSeqNum_t			: std_logic_vector(31 downto 0 );       
	signal  Rx2CtrlRefSeqNum_t			: std_logic_vector(31 downto 0 );       
	signal  Rx2CtrlRefTagId_t			: std_logic_vector(15 downto 0 );   
	signal  Rx2CtrlRefMsgType_t			: std_logic_vector( 7 downto 0 );   
	signal  Rx2CtrlRejectReason_t		: std_logic_vector( 2 downto 0 );   
	signal  Rx2CtrlGapFillFlag_t		: std_logic;  
	signal  Rx2CtrlNewSeqNum_t			: std_logic_vector(31 downto 0 );       
	signal  Rx2CtrlMDReqId_t			: std_logic_vector(15 downto 0 );   
	signal  Rx2CtrlMDReqIdLen_t			: std_logic_vector( 5 downto 0 ); 

	------------------------------------------
	-- output 
	signal  UserFixOperate				: std_logic;	
	signal  UserFixError 	            : std_logic_vector( 3 downto 0 );

	signal  Fix2TOEConnectReq			: std_logic;
	signal  Fix2TOETerminateReq		    : std_logic;
	signal  Fix2TOERxDataReq		    : std_logic;

	signal  Ctrl2TxReq					: std_logic;
	signal  Ctrl2TxPossDupEn            : std_logic;
	signal  Ctrl2TxReplyTest            : std_logic;

	signal  Ctrl2TxMsgType				: std_logic_vector( 3  downto 0 );
	signal  Ctrl2TxMsgSeqNum			: std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgSendTime			: std_logic_vector(50  downto 0 );
	signal  Ctrl2TxMsgBeginString		: std_logic_vector(63  downto 0 );
	signal  Ctrl2TxMsgSenderCompID		: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgTargetCompID		: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgBeginStringLen   	: std_logic_vector( 3  downto 0 );
	signal  Ctrl2TxMsgSenderCompIDLen	: std_logic_vector( 4  downto 0 );
	signal  Ctrl2TxMsgTargetCompIDLen	: std_logic_vector( 4  downto 0 );

	signal  Ctrl2TxMsgGenTag98			: std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag108		    : std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag141		    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag553		    : std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag554		    : std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag1137	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag553Len	    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag554Len	    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag112			: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag112Len	    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag262			: std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag263	        : std_logic_vector( 7  downto 0 ); 
	signal  Ctrl2TxMsgGenTag264	        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag265	        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag266	        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag146	        : std_logic_vector( 3  downto 0 ); 
	signal  Ctrl2TxMsgGenTag22	        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag267	        : std_logic_vector( 2  downto 0 ); 
	signal  Ctrl2TxMsgGenTag269	        : std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag7			: std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgGenTag16	        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag123			: std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag36	        : std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgGenTag45			: std_logic_vector(26  downto 0 ); 
	signal  Ctrl2TxMsgGenTag371			: std_logic_vector(31  downto 0 ); 
	signal  Ctrl2TxMsgGenTag372			: std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag373			: std_logic_vector(15  downto 0 );
	signal  Ctrl2TxMsgGenTag58			: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag371Len		: std_logic_vector( 2  downto 0 ); 
	signal  Ctrl2TxMsgGenTag373Len		: std_logic_vector( 1  downto 0 ); 
	signal  Ctrl2TxMsgGenTag58Len		: std_logic_vector( 3  downto 0 ); 
	signal  Ctrl2TxMsgGenTag371En		: std_logic;
	signal  Ctrl2TxMsgGenTag372En		: std_logic;
	signal  Ctrl2TxMsgGenTag373En		: std_logic;
	signal  Ctrl2TxMsgGenTag58En	    : std_logic;	

	signal  Ctrl2TxMrketData0			: std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData1	        : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData2	        : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData3	        : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData4	        : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketDataEn	        : std_logic_vector( 2 downto 0 );

	signal  Ctrl2RxTOEConn				: std_logic;
	signal  Ctrl2RxExpSeqNum	        : std_logic_vector(31 downto 0 );
	signal  Ctrl2RxSecValid		        : std_logic_vector( 4 downto 0 );
	signal  Ctrl2RxSecSymbol0	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol1	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol2	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol3	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol4	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecId0		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId1		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId2		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId3		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId4		        : std_logic_vector(15 downto 0 );

	-- Mapping signal 
	signal  UserFixOperate_t			: std_logic;	
	signal  UserFixError_t 	            : std_logic_vector( 3 downto 0 );

	signal  Fix2TOEConnectReq_t			: std_logic;
	signal  Fix2TOETerminateReq_t		: std_logic;
	signal  Fix2TOERxDataReq_t			: std_logic;

	signal  Ctrl2TxReq_t				: std_logic;
	signal  Ctrl2TxPossDupEn_t 		    : std_logic;
	signal  Ctrl2TxReplyTest_t 		    : std_logic;

	signal  Ctrl2TxMsgType_t			: std_logic_vector( 3  downto 0 );
	signal  Ctrl2TxMsgSeqNum_t			: std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgSendTime_t		: std_logic_vector(50  downto 0 );
	signal  Ctrl2TxMsgBeginString_t		: std_logic_vector(63  downto 0 );
	signal  Ctrl2TxMsgSenderCompID_t	: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgTargetCompID_t	: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgBeginStringLen_t  : std_logic_vector( 3  downto 0 );
	signal  Ctrl2TxMsgSenderCompIDLen_t	: std_logic_vector( 4  downto 0 );
	signal  Ctrl2TxMsgTargetCompIDLen_t	: std_logic_vector( 4  downto 0 );

	signal  Ctrl2TxMsgGenTag98_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag108_t	    : std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag141_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag553_t	    : std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag554_t	    : std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag1137_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag553Len_t    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag554Len_t    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag112_t		: std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag112Len_t    : std_logic_vector( 4	 downto 0 );
	signal  Ctrl2TxMsgGenTag262_t		: std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag263_t	    : std_logic_vector( 7  downto 0 ); 
	signal  Ctrl2TxMsgGenTag264_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag265_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag266_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag146_t	    : std_logic_vector( 3  downto 0 ); 
	signal  Ctrl2TxMsgGenTag22_t	    : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag267_t	    : std_logic_vector( 2  downto 0 ); 
	signal  Ctrl2TxMsgGenTag269_t	    : std_logic_vector(15  downto 0 ); 
	signal  Ctrl2TxMsgGenTag7_t	    	: std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgGenTag16_t        : std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag123_t		: std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag36_t	    : std_logic_vector(26  downto 0 );
	signal  Ctrl2TxMsgGenTag45_t	    : std_logic_vector(26  downto 0 ); 
	signal  Ctrl2TxMsgGenTag371_t		: std_logic_vector(31  downto 0 ); 
	signal  Ctrl2TxMsgGenTag372_t		: std_logic_vector( 7  downto 0 );
	signal  Ctrl2TxMsgGenTag373_t		: std_logic_vector(15  downto 0 );
	signal  Ctrl2TxMsgGenTag58_t	    : std_logic_vector(127 downto 0 );
	signal  Ctrl2TxMsgGenTag371Len_t 	: std_logic_vector( 2  downto 0 ); 
	signal  Ctrl2TxMsgGenTag373Len_t 	: std_logic_vector( 1  downto 0 ); 
	signal  Ctrl2TxMsgGenTag58Len_t		: std_logic_vector( 3  downto 0 ); 
	signal  Ctrl2TxMsgGenTag371En_t		: std_logic;
	signal  Ctrl2TxMsgGenTag372En_t		: std_logic;
	signal  Ctrl2TxMsgGenTag373En_t		: std_logic;
	signal  Ctrl2TxMsgGenTag58En_t	    : std_logic;	

	signal  Ctrl2TxMrketData0_t			: std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData1_t		    : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData2_t		    : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData3_t		    : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketData4_t		    : std_logic_vector( 9 downto 0 );
	signal  Ctrl2TxMrketDataEn_t		: std_logic_vector( 2 downto 0 );

	signal  Ctrl2RxTOEConn_t			: std_logic;
	signal  Ctrl2RxExpSeqNum_t	        : std_logic_vector(31 downto 0 );
	signal  Ctrl2RxSecValid_t	        : std_logic_vector( 4 downto 0 );
	signal  Ctrl2RxSecSymbol0_t	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol1_t	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol2_t	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol3_t	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecSymbol4_t	        : std_logic_vector(47 downto 0 );
	signal  Ctrl2RxSecId0_t		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId1_t		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId2_t		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId3_t		        : std_logic_vector(15 downto 0 );
	signal  Ctrl2RxSecId4_t		        : std_logic_vector(15 downto 0 );
	
	------------------------------------------
	-- Others
	signal  RTCTimeYear					: std_logic_vector(13 downto 0 );
	signal  RTCTimeMonth				: std_logic_vector( 3 downto 0 );
	signal  RTCTimeDay					: std_logic_vector( 4 downto 0 );
	signal  RTCTimeHour					: std_logic_vector( 4 downto 0 );
	signal  RTCTimeMin					: std_logic_vector( 5 downto 0 );
	signal  RTCTimeMilliSec				: std_logic_vector(16 downto 0 );
	
	-- Package 
	signal  RxDataRec					: PktRx2CtrlRecord; 

End Package PkSigTbFixCtrl;		