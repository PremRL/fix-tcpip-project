----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTxFixMsg.vhd
-- Title        Signal Declaration for TbTxFixMsg
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
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
USE work.PkTbTxFixMsg.all;

Package PkSigTbTxFixMsg Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	
----------------------------------------------------------------------------------
-- Signal declaration																
----------------------------------------------------------------------------------
	
	signal	TM						: integer	range 0 to 65535;
	signal	TT						: integer	range 0 to 65535;
	
	signal	RstB					: std_logic;
	signal	Clk						: std_logic;
	
	-- Input 
	signal  FixCtrl2TxReq		 	: std_logic;
	signal  FixCtrl2TxPossDupEn     : std_logic;
	signal 	FixCtrl2TxReplyTest		: std_logic;
	signal  MsgType					: std_logic_vector( 3  downto 0 );
	signal  MsgSeqNum				: std_logic_vector(26  downto 0 );
	signal  MsgSendTime				: std_logic_vector(50  downto 0 );
	signal  MsgBeginString			: std_logic_vector(63  downto 0 );
	signal  MsgSenderCompID			: std_logic_vector(127 downto 0 );
	signal  MsgTargetCompID			: std_logic_vector(127 downto 0 );
	signal  MsgBeginStringLen   	: std_logic_vector( 3  downto 0 );
	signal  MsgSenderCompIDLen		: std_logic_vector( 4  downto 0 );
	signal  MsgTargetCompIDLen		: std_logic_vector( 4  downto 0 );
	signal	TOE2FixMemAlFull	 	: std_logic;
	
	-- Logon 
	signal 	MsgGenTag98				: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag108			: std_logic_vector(15  downto 0 ); 
	signal 	MsgGenTag141			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag553			: std_logic_vector(127 downto 0 );
	signal 	MsgGenTag554			: std_logic_vector(127 downto 0 );
	signal 	MsgGenTag1137			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag553Len			: std_logic_vector( 4  downto 0 );
	signal 	MsgGenTag554Len			: std_logic_vector( 4  downto 0 );
	-- Heartbeat	
	signal 	MsgGenTag112			: std_logic_vector(127 downto 0 );
	signal 	MsgGenTag112Len			: std_logic_vector( 4  downto 0 );
	-- MrkDataReq 	
	signal 	MsgGenTag262			: std_logic_vector(15  downto 0 ); 
	signal 	MsgGenTag263			: std_logic_vector( 7  downto 0 ); 
	signal 	MsgGenTag264			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag265			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag266			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag146			: std_logic_vector( 3  downto 0 ); 
	signal 	MsgGenTag22				: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag267			: std_logic_vector( 2  downto 0 ); 
	signal 	MsgGenTag269			: std_logic_vector(15  downto 0 ); 
	-- ResendReq 	
	signal 	MsgGenTag7				: std_logic_vector(26  downto 0 ); 
	signal 	MsgGenTag16				: std_logic_vector( 7  downto 0 ); 
	-- SeqReset 	
	signal 	MsgGenTag123			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag36				: std_logic_vector(26  downto 0 );
	-- Reject 	
	signal 	MsgGenTag45				: std_logic_vector(26  downto 0 ); 
	signal 	MsgGenTag371			: std_logic_vector(31  downto 0 ); 
	signal 	MsgGenTag372			: std_logic_vector( 7  downto 0 );
	signal 	MsgGenTag373			: std_logic_vector(15  downto 0 );
	signal 	MsgGenTag58				: std_logic_vector(127 downto 0 );
	signal 	MsgGenTag371Len			: std_logic_vector( 2  downto 0 ); 
	signal 	MsgGenTag373Len			: std_logic_vector( 1  downto 0 ); 
	signal 	MsgGenTag58Len			: std_logic_vector( 3  downto 0 ); 
	signal 	MsgGenTag371En			: std_logic;
	signal 	MsgGenTag372En			: std_logic;
	signal 	MsgGenTag373En			: std_logic;
	signal 	MsgGenTag58En			: std_logic;
	-- Market data 	
	signal 	MrketData0				: std_logic_vector( 9 downto 0 );
	signal 	MrketData1				: std_logic_vector( 9 downto 0 );
	signal 	MrketData2				: std_logic_vector( 9 downto 0 );
	signal 	MrketData3				: std_logic_vector( 9 downto 0 );
	signal 	MrketData4				: std_logic_vector( 9 downto 0 );
	signal 	MrketDataEn				: std_logic_vector( 2 downto 0 );
	
	
	signal	FixCtrl2TxReq_t		  	: std_logic;	
	signal	FixCtrl2TxPossDupEn_t   : std_logic;    
	signal 	FixCtrl2TxReplyTest_t	: std_logic;
	signal	MsgType_t				: std_logic_vector( 3  downto 0 );	
	signal	MsgSeqNum_t			    : std_logic_vector(26  downto 0 );	
	signal	MsgSendTime_t			: std_logic_vector(50  downto 0 );	
	signal	MsgBeginString_t		: std_logic_vector(63  downto 0 );    
	signal	MsgSenderCompID_t		: std_logic_vector(127 downto 0 );    
	signal	MsgTargetCompID_t		: std_logic_vector(127 downto 0 );    
	signal	MsgBeginStringLen_t     : std_logic_vector( 3  downto 0 );    
	signal	MsgSenderCompIDLen_t	: std_logic_vector( 4  downto 0 );    
	signal	MsgTargetCompIDLen_t	: std_logic_vector( 4  downto 0 );    
	signal	TOE2FixMemAlFull_t		: std_logic;		

	-- Output 
	signal	FixTx2CtrlBusy			: std_logic;
	
	signal  MrketVal				: std_logic_vector( 4 downto 0 );
	signal  MrketSymbol0			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID0		: std_logic_vector(15 downto 0 );
	signal  MrketSymbol1			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID1    	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol2			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID2    	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol3			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID3    	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol4			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID4    	: std_logic_vector(15 downto 0 );
	
	signal  Fix2TOEDataVal			: std_logic;
	signal  Fix2TOEDataSop			: std_logic;
	signal  Fix2TOEDataEop			: std_logic;
	signal  Fix2TOEData				: std_logic_vector( 7 downto 0 );
    signal  Fix2TOEDataLen			: std_logic_vector(15 downto 0 );

	signal	FixTx2CtrlBusy_t		: std_logic;
	
	signal  MrketVal_t           	: std_logic_vector( 4 downto 0 );
	signal  MrketSymbol0_t			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID0_t		: std_logic_vector(15 downto 0 );
	signal  MrketSymbol1_t			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID1_t  	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol2_t			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID2_t   	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol3_t			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID3_t  	: std_logic_vector(15 downto 0 );
	signal  MrketSymbol4_t			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID4_t   	: std_logic_vector(15 downto 0 );
	
	signal  Fix2TOEDataVal_t		: std_logic;
	signal  Fix2TOEDataSop_t		: std_logic;
	signal  Fix2TOEDataEop_t		: std_logic;
	signal  Fix2TOEData_t			: std_logic_vector( 7 downto 0 );
    signal  Fix2TOEDataLen_t		: std_logic_vector(15 downto 0 );
	
	-- Others
	signal  MsgSendTimeYear			: std_logic_vector(13 downto 0 );
	signal  MsgSendTimeMonth		: std_logic_vector( 3 downto 0 );
	signal  MsgSendTimeDay			: std_logic_vector( 4 downto 0 );
	signal  MsgSendTimeHour			: std_logic_vector( 4 downto 0 );
	signal  MsgSendTimeMin			: std_logic_vector( 5 downto 0 );
	signal  MsgSendTimeMilliSec		: std_logic_vector(16 downto 0 );
	
	signal  FixOutDataRec			: FixOutDataRecord;

End Package PkSigTbTxFixMsg;		