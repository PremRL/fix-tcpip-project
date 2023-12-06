----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTxFixMsg.vhd
-- Title        Mapping for TbTxFixMsg
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
use work.PkSigTbTxFixMsg.all;

Entity PkMapTbTxFixMsg Is
End Entity PkMapTbTxFixMsg;

Architecture HTWTestBench Of PkMapTbTxFixMsg Is 

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component TxFixMsg Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		FixCtrl2TxReq		: in	std_logic;
		FixCtrl2TxPossDupEn : in    std_logic;
		FixCtrl2TxReplyTest : in	std_logic;
		FixTx2CtrlBusy		: out	std_logic;
		
		-- Header Detail 
		MsgType				: in	std_logic_vector( 3  downto 0 );
		MsgSeqNum			: in	std_logic_vector(26  downto 0 );
		MsgSendTime			: in	std_logic_vector(50  downto 0 );
		MsgBeginString		: in	std_logic_vector(63  downto 0 );
		MsgSenderCompID		: in	std_logic_vector(127 downto 0 );
		MsgTargetCompID		: in	std_logic_vector(127 downto 0 );
		
		MsgBeginStringLen   : in	std_logic_vector( 3  downto 0 );
		MsgSenderCompIDLen	: in	std_logic_vector( 4  downto 0 );
		MsgTargetCompIDLen	: in	std_logic_vector( 4  downto 0 );
		
		-- Message Body 
		-- Logon 
		MsgGenTag98			: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag108		: in 	std_logic_vector(15  downto 0 ); 
		MsgGenTag141		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag553		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag554		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag1137		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag553Len		: in 	std_logic_vector( 4	 downto 0 );
		MsgGenTag554Len		: in 	std_logic_vector( 4	 downto 0 );
		-- Heartbeat
		MsgGenTag112		: in 	std_logic_vector(127 downto 0 );
		MsgGenTag112Len		: in 	std_logic_vector( 4	 downto 0 );
		-- MrkDataReq 
		MsgGenTag262		: in 	std_logic_vector(15  downto 0 ); 
		MsgGenTag263		: in 	std_logic_vector( 7  downto 0 ); 
		MsgGenTag264		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag265		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag266		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag146		: in 	std_logic_vector( 3  downto 0 ); 
		MsgGenTag22			: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag267		: in 	std_logic_vector( 2  downto 0 ); 
		MsgGenTag269		: in 	std_logic_vector(15  downto 0 ); 
		-- ResendReq 
		MsgGenTag7			: in 	std_logic_vector(26  downto 0 ); 
		MsgGenTag16			: in 	std_logic_vector( 7  downto 0 ); 
		-- SeqReset 
		MsgGenTag123		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag36			: in 	std_logic_vector(26  downto 0 );
		-- Reject 
		MsgGenTag45			: in 	std_logic_vector(26  downto 0 ); 
		MsgGenTag371		: in 	std_logic_vector(31  downto 0 ); 
		MsgGenTag372		: in 	std_logic_vector( 7  downto 0 );
		MsgGenTag373		: in 	std_logic_vector(15  downto 0 );
		MsgGenTag58			: in 	std_logic_vector(127 downto 0 );
		MsgGenTag371Len		: in 	std_logic_vector( 2  downto 0 ); 
		MsgGenTag373Len		: in 	std_logic_vector( 1  downto 0 ); 
		MsgGenTag58Len		: in 	std_logic_vector( 3  downto 0 ); 
		MsgGenTag371En		: in 	std_logic;
		MsgGenTag372En		: in 	std_logic;
		MsgGenTag373En		: in 	std_logic;
		MsgGenTag58En		: in 	std_logic;
		
		-- Market data 
		MrketData0			: in	std_logic_vector( 9 downto 0 );
		MrketData1			: in	std_logic_vector( 9 downto 0 );
		MrketData2			: in	std_logic_vector( 9 downto 0 );
		MrketData3			: in	std_logic_vector( 9 downto 0 );
		MrketData4			: in	std_logic_vector( 9 downto 0 );
		MrketDataEn			: in	std_logic_vector( 2 downto 0 );
		
		-- Market data validation 
		MrketVal			: out 	std_logic_vector( 4 downto 0 );
		MrketSymbol0		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID0	: out   std_logic_vector(15 downto 0 );
		MrketSymbol1		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID1    : out   std_logic_vector(15 downto 0 );
		MrketSymbol2		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID2    : out   std_logic_vector(15 downto 0 );
		MrketSymbol3		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID3    : out   std_logic_vector(15 downto 0 );
		MrketSymbol4		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID4    : out   std_logic_vector(15 downto 0 );
		
		-- TxTOE I/F 
		TOE2FixMemAlFull	: in 	std_logic;	
		
		Fix2TOEDataVal		: out 	std_logic;
		Fix2TOEDataSop		: out	std_logic;
		Fix2TOEDataEop		: out	std_logic;
		Fix2TOEData			: out 	std_logic_vector( 7  downto 0 );
		Fix2TOEDataLen		: out	std_logic_vector(15  downto 0 )
	);
	End Component TxFixMsg;

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
	
	
	u_TxFixMsg : TxFixMsg 
	Port map
	(
		Clk					=> Clk						,
		RstB				=> RstB				        ,

		FixCtrl2TxReq		=> FixCtrl2TxReq_t		    ,
		FixCtrl2TxPossDupEn => FixCtrl2TxPossDupEn_t    ,
		FixCtrl2TxReplyTest => FixCtrl2TxReplyTest_t	,
		FixTx2CtrlBusy		=> FixTx2CtrlBusy_t		    ,
		
		-- Header Detail        
		MsgType				=> MsgType_t				,
		MsgSeqNum			=> MsgSeqNum_t			    ,
		MsgSendTime			=> MsgSendTime_t			,
		MsgBeginString		=> MsgBeginString_t		    ,
		MsgSenderCompID		=> MsgSenderCompID_t		,
		MsgTargetCompID		=> MsgTargetCompID_t		,
		MsgBeginStringLen   => MsgBeginStringLen_t      ,
		MsgSenderCompIDLen	=> MsgSenderCompIDLen_t	    ,
		MsgTargetCompIDLen	=> MsgTargetCompIDLen_t	    ,

		-- Logon             
		MsgGenTag98			=> MsgGenTag98			    ,
		MsgGenTag108		=> MsgGenTag108		        ,
		MsgGenTag141		=> MsgGenTag141		        ,
		MsgGenTag553		=> MsgGenTag553		        ,
		MsgGenTag554		=> MsgGenTag554		        ,
		MsgGenTag1137		=> MsgGenTag1137		    ,
		MsgGenTag553Len		=> MsgGenTag553Len		    ,
		MsgGenTag554Len		=> MsgGenTag554Len		    ,
		-- Heartbeat             
		MsgGenTag112		=> MsgGenTag112		        ,
		MsgGenTag112Len		=> MsgGenTag112Len		    ,
		-- MrkDataReq       
		MsgGenTag262		=> MsgGenTag262		        ,
		MsgGenTag263		=> MsgGenTag263		        ,
		MsgGenTag264		=> MsgGenTag264		        ,
		MsgGenTag265		=> MsgGenTag265		        ,
		MsgGenTag266		=> MsgGenTag266		        ,
		MsgGenTag146		=> MsgGenTag146		        ,
		MsgGenTag22			=> MsgGenTag22			    ,
		MsgGenTag267		=> MsgGenTag267		        ,
		MsgGenTag269		=> MsgGenTag269		        ,
		-- ResendReq     
		MsgGenTag7			=> MsgGenTag7			    ,
		MsgGenTag16			=> MsgGenTag16			    ,
		-- SeqReset       
		MsgGenTag123		=> MsgGenTag123		        ,
		MsgGenTag36			=> MsgGenTag36			    ,
		-- Reject   
		MsgGenTag45			=> MsgGenTag45			    ,
		MsgGenTag371		=> MsgGenTag371		        ,
		MsgGenTag372		=> MsgGenTag372		        ,
		MsgGenTag373		=> MsgGenTag373		        ,
		MsgGenTag58			=> MsgGenTag58			    ,
		MsgGenTag371Len		=> MsgGenTag371Len		    ,
		MsgGenTag373Len		=> MsgGenTag373Len		    ,
		MsgGenTag58Len		=> MsgGenTag58Len		    ,
		MsgGenTag371En		=> MsgGenTag371En		    ,
		MsgGenTag372En		=> MsgGenTag372En		    ,
		MsgGenTag373En		=> MsgGenTag373En		    ,
		MsgGenTag58En		=> MsgGenTag58En		    ,

		MrketData0			=> MrketData0			    ,
		MrketData1			=> MrketData1			    ,
		MrketData2			=> MrketData2			    ,
		MrketData3			=> MrketData3			    ,
		MrketData4			=> MrketData4			    ,
		MrketDataEn			=> MrketDataEn			    ,

		MrketVal			=> MrketVal_t			    ,
		MrketSymbol0		=> MrketSymbol0_t		    ,
		MrketSecurityID0	=> MrketSecurityID0_t	    ,
		MrketSymbol1		=> MrketSymbol1_t		    ,
		MrketSecurityID1    => MrketSecurityID1_t       ,
		MrketSymbol2		=> MrketSymbol2_t		    ,
		MrketSecurityID2    => MrketSecurityID2_t       ,
		MrketSymbol3		=> MrketSymbol3_t		    ,
		MrketSecurityID3    => MrketSecurityID3_t       ,
		MrketSymbol4		=> MrketSymbol4_t		    ,
		MrketSecurityID4    => MrketSecurityID4_t       ,

		TOE2FixMemAlFull	=> TOE2FixMemAlFull_t	    ,
		Fix2TOEDataVal		=> Fix2TOEDataVal_t		    ,
		Fix2TOEDataSop		=> Fix2TOEDataSop_t		    ,
		Fix2TOEDataEop		=> Fix2TOEDataEop_t		    ,
		Fix2TOEData			=> Fix2TOEData_t			,
		Fix2TOEDataLen		=> Fix2TOEDataLen_t		
	);
	
-- Signal assignment from Testbench to TxFixMsg with delay time
	FixCtrl2TxReq_t		  		<= FixCtrl2TxReq			after 1 ns;
    FixCtrl2TxPossDupEn_t       <= FixCtrl2TxPossDupEn  	after 1 ns;
	FixCtrl2TxReplyTest_t		<= FixCtrl2TxReplyTest		after 1 ns;
	MsgType_t					<= MsgType					after 1 ns;
	MsgSeqNum_t			    	<= MsgSeqNum				after 1 ns;
	MsgSendTime_t				<= MsgSendTime				after 1 ns;
	MsgBeginString_t		    <= MsgBeginString			after 1 ns;
	MsgSenderCompID_t		    <= MsgSenderCompID			after 1 ns;
	MsgTargetCompID_t		    <= MsgTargetCompID			after 1 ns;
	MsgBeginStringLen_t         <= MsgBeginStringLen    	after 1 ns;
	MsgSenderCompIDLen_t	    <= MsgSenderCompIDLen		after 1 ns;
	MsgTargetCompIDLen_t	    <= MsgTargetCompIDLen		after 1 ns;
	TOE2FixMemAlFull_t			<= TOE2FixMemAlFull			after 1 ns;
	
-- Signal assignment from TxFixMsg to Testbench with delay time
	FixTx2CtrlBusy				<= FixTx2CtrlBusy_t			after 1 ns;
	MrketVal                    <= MrketVal_t               after 1 ns;
	MrketSymbol0				<= MrketSymbol0_t		   	after 1 ns;	 
	MrketSecurityID0	        <= MrketSecurityID0_t	    after 1 ns;
	MrketSymbol1		        <= MrketSymbol1_t		    after 1 ns;
	MrketSecurityID1            <= MrketSecurityID1_t       after 1 ns;
	MrketSymbol2		        <= MrketSymbol2_t		    after 1 ns;
	MrketSecurityID2            <= MrketSecurityID2_t       after 1 ns;
	MrketSymbol3		        <= MrketSymbol3_t		    after 1 ns;
	MrketSecurityID3            <= MrketSecurityID3_t       after 1 ns;
	MrketSymbol4		        <= MrketSymbol4_t		    after 1 ns;
	MrketSecurityID4            <= MrketSecurityID4_t       after 1 ns;
	Fix2TOEDataVal		        <= Fix2TOEDataVal_t		    after 1 ns;
	Fix2TOEDataSop		        <= Fix2TOEDataSop_t		    after 1 ns;
	Fix2TOEDataEop		        <= Fix2TOEDataEop_t		    after 1 ns;
	Fix2TOEData			        <= Fix2TOEData_t		    after 1 ns;
	Fix2TOEDataLen				<= Fix2TOEDataLen_t			after 1 ns;

-- Signal assignment from Testbench to Verify's package 
	FixOutDataRec.FixOutDataVal	<= Fix2TOEDataVal;		
    FixOutDataRec.FixOutDataSop	<= Fix2TOEDataSop;	
    FixOutDataRec.FixOutDataEop	<= Fix2TOEDataEop;	
    FixOutDataRec.FixOutData	<= Fix2TOEData;			
    FixOutDataRec.FixOutDataLen	<= Fix2TOEDataLen;	

-- Sendtime mapping 
	
	MsgSendTime(50 downto 0)	<= MsgSendTimeYear&MsgSendTimeMonth&MsgSendTimeDay
									&MsgSendTimeHour&MsgSendTimeMin&MsgSendTimeMilliSec;
									
End Architecture HTWTestBench;