----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxFixMsg.vhd
-- Title        FIX message transmitter 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
--
--
-- MsgType 
-- '0001' : Log on
-- '0010' : Heartbeat
-- '0011' : MrkDataReq
-- '0100' : ResendReq
-- '0101' : SeqReset
-- '0110' : Reject 
-- '0111' : Log out  
-- '1000' : Generate validation 
-- '1111' : Reset Validation  
--
-- SendTime
-- (50 downto 37) Year
-- (36 downto 33) Month
-- (32 downto 28) Day
-- (27 downto 23) Hour
-- (22 downto 17) Min
-- (16 downto 0 ) Millisec
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity TxFixMsg Is
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
End Entity TxFixMsg;

Architecture rtl Of TxFixMsg Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component TxFixMsgCtrl Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		FixCtrl2TxReq		: in	std_logic;
		FixCtrl2TxPossDupEn : in    std_logic;
		FixCtrl2TxReplyTest : in    std_logic;
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
		
		-- TxFixMsgGen I/F 
		MsgGen2CtrlCheckSum : in 	std_logic_vector( 7  downto 0 );
		MsgGen2CtrlEnd 		: in 	std_logic;	
		MsgGen2CtrlBusy		: in 	std_logic;	
		
		Ctrl2GenMsgReq		: out	std_logic;
		Ctrl2GenMsgType	    : out	std_logic_vector( 2 downto 0 );
		
		-- Mux Ascii encoder I/F 
		AsciiOutReq			: In	std_logic; 
		AsciiOutVal			: In	std_logic; 
		AsciiOutEop			: In	std_logic; 
		AsciiOutData		: In 	std_logic_vector( 7 downto 0 );
		
		AsciiInStart		: out	std_logic; 
		AsciiInTransEn 		: out	std_logic; 
		AsciiInDecPointEn	: out	std_logic;
		AsciiInNegativeExp	: out 	std_logic_vector( 2 downto 0 );
		AsciiInData			: out 	std_logic_vector(26 downto 0 );
		
		-- Payload I/F 
		PayloadRdData		: in 	std_logic_vector( 7  downto 0 );
		PayloadWrAddr		: in 	std_logic_vector( 9  downto 0 );
		PayloadRdAddr		: out 	std_logic_vector( 9  downto 0 );
		
		-- TxTOE I/F 
		TOE2FixMemAlFull	: in 	std_logic;	
		
		Fix2TOEDataVal		: out 	std_logic;
		Fix2TOEDataSop		: out	std_logic;
		Fix2TOEDataEop		: out	std_logic;
		Fix2TOEData			: out 	std_logic_vector( 7  downto 0 );
		Fix2TOEDataLen		: out	std_logic_vector(15  downto 0 )
	);
	End Component TxFixMsgCtrl;
	
	Component TxFixMsgGen Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		TxCtrl2GenReq		: in	std_logic;
		TxCtrl2GenMsgType	: in	std_logic_vector( 2 downto 0 );
		
		Gen2TxCtrlBusy		: out	std_logic;
		
		-- Log-on 
		TxCtrl2GenTag98		: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag108	: in 	std_logic_vector(15  downto 0 ); -- Fixed 2 ascii character 00<= x <= 99 
		TxCtrl2GenTag141	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag553	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag554	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag1137	: in 	std_logic_vector( 7  downto 0 );
		
		TxCtrl2GenTag553Len	: in 	std_logic_vector( 4	 downto 0 );
		TxCtrl2GenTag554Len	: in 	std_logic_vector( 4	 downto 0 );
		
		-- Heartbeat
		TxCtrl2GenTag112	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag112Len	: in 	std_logic_vector( 4	 downto 0 );
		
		-- MrkDataReq 
		TxCtrl2GenTag262	: in 	std_logic_vector(15  downto 0 ); -- Fixed 2 
		TxCtrl2GenTag263	: in 	std_logic_vector( 7  downto 0 ); 
		TxCtrl2GenTag264	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag265	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag266	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag146	: in 	std_logic_vector( 3  downto 0 ); -- Binary 0< and <=5
		TxCtrl2GenTag22		: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag267	: in 	std_logic_vector( 2  downto 0 ); -- Binary <= 2 
		TxCtrl2GenTag269	: in 	std_logic_vector(15  downto 0 ); -- number of 269 field depend on 267 value 
		
		-- ResendReq 
		TxCtrl2GenTag7		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		TxCtrl2GenTag16		: in 	std_logic_vector( 7  downto 0 );  
		
		-- SeqReset 
		TxCtrl2GenTag123	: in 	std_logic_vector( 7  downto 0 ); 
		TxCtrl2GenTag36		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		
		-- Reject 
		TxCtrl2GenTag45		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		TxCtrl2GenTag371	: in 	std_logic_vector(31  downto 0 ); 
		TxCtrl2GenTag372	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag373	: in 	std_logic_vector(15  downto 0 );
		TxCtrl2GenTag58		: in 	std_logic_vector(127 downto 0 );
		
		TxCtrl2GenTag371Len	: in 	std_logic_vector( 2  downto 0 ); -- <= 4 
		TxCtrl2GenTag373Len	: in 	std_logic_vector( 1  downto 0 ); -- <= 2 
		TxCtrl2GenTag58Len	: in 	std_logic_vector( 3  downto 0 ); -- <= 16 
		TxCtrl2GenTag371En	: in 	std_logic;
		TxCtrl2GenTag372En	: in 	std_logic;
		TxCtrl2GenTag373En	: in 	std_logic;
		TxCtrl2GenTag58En	: in 	std_logic;
		
		-- Market data address 
		MrketData0			: in	std_logic_vector( 9 downto 0 );
		MrketData1			: in	std_logic_vector( 9 downto 0 );
		MrketData2			: in	std_logic_vector( 9 downto 0 );
		MrketData3			: in	std_logic_vector( 9 downto 0 );
		MrketData4			: in	std_logic_vector( 9 downto 0 );
		MrketDataEn			: in	std_logic_vector( 2 downto 0 ); -- 0< and <=5
		
		-- Output validation of Market data symbol and securityID 
		MrketSymbol0		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID0	: out   std_logic_vector(15 downto 0 );
		MrketVal0			: out   std_logic;
		MrketSymbol1		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID1    : out   std_logic_vector(15 downto 0 );
		MrketVal1           : out   std_logic;
		MrketSymbol2		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID2    : out   std_logic_vector(15 downto 0 );
		MrketVal2           : out   std_logic;
		MrketSymbol3		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID3    : out   std_logic_vector(15 downto 0 );
		MrketVal3           : out   std_logic;
		MrketSymbol4		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID4    : out   std_logic_vector(15 downto 0 );
		MrketVal4           : out   std_logic;
		
		-- AsciiEncoder Interface 
		AsciiOutReq			: In	std_logic; 
		AsciiOutVal			: In	std_logic; 
		AsciiOutEop			: In	std_logic; 
		AsciiOutData		: In 	std_logic_vector( 7 downto 0 );
		
		AsciiInStart		: out	std_logic; 
		AsciiInTransEn 		: out	std_logic; 
		AsciiInDecPointEn	: out	std_logic;
		AsciiInNegativeExp	: out 	std_logic_vector( 2 downto 0 );
		AsciiInData			: out 	std_logic_vector(26 downto 0 );
		
		-- Output message Interface 
		OutMsgWrAddr		: out 	std_logic_vector( 9 downto 0 );
		OutMsgWrData		: out 	std_logic_vector( 7 downto 0 );
		OutMsgWrEn			: out 	std_logic;
		
		OutMsgChecksum		: out 	std_logic_vector( 7 downto 0 );
		OutMsgEnd			: out 	std_logic
	);
	End Component TxFixMsgGen;
	
	Component MuxEncoder Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Input 0
		InMuxStart0			: in	std_logic; 
		InMuxTransEn0 		: in	std_logic; 
		InMuxDecPointEn0	: in	std_logic;
		InMuxNegativeExp0	: in 	std_logic_vector( 2 downto 0 );
		InMuxData0			: in 	std_logic_vector(26 downto 0 );
		
		-- Input 1 
		InMuxStart1			: in	std_logic; 
		InMuxTransEn1 		: in	std_logic; 
		InMuxDecPointEn1	: in	std_logic;
		InMuxNegativeExp1	: in 	std_logic_vector( 2 downto 0 );
		InMuxData1			: in 	std_logic_vector(26 downto 0 );
		
		-- Output 0 
		OutMuxReq0			: out	std_logic; 
		OutMuxVal0			: out	std_logic; 
		OutMuxEop0			: out	std_logic; 
		OutMuxData0			: out 	std_logic_vector( 7 downto 0 );
		
		-- Output 1 
		OutMuxReq1			: out	std_logic; 
		OutMuxVal1			: out	std_logic; 
		OutMuxEop1			: out	std_logic; 
		OutMuxData1			: out 	std_logic_vector( 7 downto 0 )
	);
	End Component MuxEncoder;

	Component Ram1024x8 Is
	Port
	(
		clock				: IN STD_LOGIC  := '1';
		data				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress			: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wraddress			: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wren				: IN STD_LOGIC  := '0';
		q					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	End Component Ram1024x8;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- Ctrl2MsgGen I/F 
	signal  rCtrl2GenMsgReq			: std_logic;
	signal  rCtrl2GenMsgType		: std_logic_vector( 2 downto 0 );
	
	-- MsgGen2Ctrl I/F 
	signal  rMsgGen2CtrlCheckSum	: std_logic_vector( 7 downto 0 );
    signal  rMsgGen2CtrlEnd 		: std_logic;
	signal  rMsgGen2CtrlBusy		: std_logic;
	
	-- Payload Ram I/F 
	signal  rPayloadWrData    		: std_logic_vector( 7 downto 0 );
	signal  rPayloadRdAddr    		: std_logic_vector( 9 downto 0 );
	signal  rPayloadWrAddr    		: std_logic_vector( 9 downto 0 );
	signal  rPayloadWrEn      		: std_logic;
	signal  rPaylaodRdData			: std_logic_vector( 7 downto 0 );
	
	-- MuxEncoder I/F 
	signal	rInMuxStart0			: std_logic; 
	signal	rInMuxTransEn0 		    : std_logic; 
	signal	rInMuxDecPointEn0	    : std_logic;
	signal	rInMuxNegativeExp0	    : std_logic_vector( 2 downto 0 );
	signal	rInMuxData0			    : std_logic_vector(26 downto 0 );
	signal	rInMuxStart1			: std_logic; 
	signal	rInMuxTransEn1 		    : std_logic; 
	signal	rInMuxDecPointEn1	    : std_logic;
	signal	rInMuxNegativeExp1	    : std_logic_vector( 2 downto 0 );
	signal	rInMuxData1			    : std_logic_vector(26 downto 0 );
	
	signal	rOutMuxReq0				: std_logic; 
	signal	rOutMuxVal0		        : std_logic; 
	signal	rOutMuxEop0		        : std_logic; 
	signal	rOutMuxData0		    : std_logic_vector( 7 downto 0 );
	signal	rOutMuxReq1		        : std_logic; 
	signal	rOutMuxVal1		        : std_logic; 
	signal	rOutMuxEop1		        : std_logic; 
	signal	rOutMuxData1		    : std_logic_vector( 7 downto 0 );
	
	-- Output 
	signal	rMrketVal0				: std_logic;
	signal	rMrketVal1              : std_logic;
	signal	rMrketVal2              : std_logic;
	signal	rMrketVal3              : std_logic;
	signal	rMrketVal4              : std_logic;
	
Begin 	
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	MrketVal( 4 downto 0 )	<= rMrketVal4&rMrketVal3&rMrketVal2&rMrketVal1&rMrketVal0;
	
----------------------------------------------------------------------------------
-- DFF: Component
----------------------------------------------------------------------------------

	u_TxFixMsgCtrl : TxFixMsgCtrl
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB                 ,

		FixCtrl2TxReq		=> FixCtrl2TxReq		,
		FixCtrl2TxPossDupEn => FixCtrl2TxPossDupEn  ,
		FixCtrl2TxReplyTest => FixCtrl2TxReplyTest	,
		FixTx2CtrlBusy		=> FixTx2CtrlBusy		,

		MsgType				=> MsgType				,
		MsgSeqNum			=> MsgSeqNum			,
		MsgSendTime			=> MsgSendTime			,
		MsgBeginString		=> MsgBeginString		,
		MsgSenderCompID		=> MsgSenderCompID		,
		MsgTargetCompID		=> MsgTargetCompID		,		
		MsgBeginStringLen   => MsgBeginStringLen    ,
		MsgSenderCompIDLen	=> MsgSenderCompIDLen	,
		MsgTargetCompIDLen	=> MsgTargetCompIDLen	,
	
		MsgGen2CtrlCheckSum => rMsgGen2CtrlCheckSum ,
		MsgGen2CtrlEnd 		=> rMsgGen2CtrlEnd 		,
		MsgGen2CtrlBusy		=> rMsgGen2CtrlBusy		,
		Ctrl2GenMsgReq		=> rCtrl2GenMsgReq		,
		Ctrl2GenMsgType	    => rCtrl2GenMsgType	    ,
		
		AsciiOutReq			=> rOutMuxReq0			,
		AsciiOutVal			=> rOutMuxVal0	        ,
		AsciiOutEop			=> rOutMuxEop0	        ,
		AsciiOutData		=> rOutMuxData0	        ,
		AsciiInStart		=> rInMuxStart0			, 
		AsciiInTransEn 		=> rInMuxTransEn0 		, 
		AsciiInDecPointEn	=> rInMuxDecPointEn0	, 
		AsciiInNegativeExp	=> rInMuxNegativeExp0	, 
		AsciiInData			=> rInMuxData0			, 

		PayloadRdData		=> rPaylaodRdData       ,
		PayloadWrAddr		=> rPayloadWrAddr       ,
		PayloadRdAddr		=> rPayloadRdAddr       ,
		
		TOE2FixMemAlFull	=> TOE2FixMemAlFull	    ,
		Fix2TOEDataVal		=> Fix2TOEDataVal		,
		Fix2TOEDataSop		=> Fix2TOEDataSop		,
		Fix2TOEDataEop		=> Fix2TOEDataEop		,
		Fix2TOEData			=> Fix2TOEData			,
		Fix2TOEDataLen		=> Fix2TOEDataLen		
	);
	
	u_Ram1024x8 : Ram1024x8
	Port map 
	(
		clock				=> Clk					,
		data				=> rPayloadWrData       ,
		rdaddress			=> rPayloadRdAddr       ,
		wraddress			=> rPayloadWrAddr       ,
		wren				=> rPayloadWrEn         ,
		q					=> rPaylaodRdData
	);
	
	u_TxFixMsgGen : TxFixMsgGen
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB                 ,
	
		TxCtrl2GenReq		=> rCtrl2GenMsgReq		,
		TxCtrl2GenMsgType	=> rCtrl2GenMsgType	    ,
		Gen2TxCtrlBusy		=> rMsgGen2CtrlBusy     ,

		-- Log-on                                                     
		TxCtrl2GenTag98		=> MsgGenTag98		    ,
		TxCtrl2GenTag108	=> MsgGenTag108	        ,
		TxCtrl2GenTag141	=> MsgGenTag141	        ,
		TxCtrl2GenTag553	=> MsgGenTag553	        ,
		TxCtrl2GenTag554	=> MsgGenTag554	        ,
		TxCtrl2GenTag1137	=> MsgGenTag1137	    ,
		TxCtrl2GenTag553Len	=> MsgGenTag553Len	    ,
		TxCtrl2GenTag554Len	=> MsgGenTag554Len	    ,
		-- Heartbeat                                                  
		TxCtrl2GenTag112	=> MsgGenTag112	        ,
		TxCtrl2GenTag112Len	=> MsgGenTag112Len	    ,
		-- MrkDataReq                                                 
		TxCtrl2GenTag262	=> MsgGenTag262	        ,
		TxCtrl2GenTag263	=> MsgGenTag263	        ,
		TxCtrl2GenTag264	=> MsgGenTag264	        ,
		TxCtrl2GenTag265	=> MsgGenTag265	        ,
		TxCtrl2GenTag266	=> MsgGenTag266	        ,
		TxCtrl2GenTag146	=> MsgGenTag146	        ,
		TxCtrl2GenTag22		=> MsgGenTag22		    ,
		TxCtrl2GenTag267	=> MsgGenTag267	        ,
		TxCtrl2GenTag269	=> MsgGenTag269	        ,
		-- ResendReq                                                  
		TxCtrl2GenTag7		=> MsgGenTag7		    ,
		TxCtrl2GenTag16		=> MsgGenTag16		    ,
		-- SeqReset                                                   
		TxCtrl2GenTag123	=> MsgGenTag123	        ,
		TxCtrl2GenTag36		=> MsgGenTag36		    ,
		-- Reject                                                     
		TxCtrl2GenTag45		=> MsgGenTag45		    ,
		TxCtrl2GenTag371	=> MsgGenTag371	        ,
		TxCtrl2GenTag372	=> MsgGenTag372	        ,
		TxCtrl2GenTag373	=> MsgGenTag373	        ,
		TxCtrl2GenTag58		=> MsgGenTag58		    ,
		TxCtrl2GenTag371Len	=> MsgGenTag371Len	    ,
		TxCtrl2GenTag373Len	=> MsgGenTag373Len	    ,
		TxCtrl2GenTag58Len	=> MsgGenTag58Len	    ,
		TxCtrl2GenTag371En	=> MsgGenTag371En	    ,
		TxCtrl2GenTag372En	=> MsgGenTag372En	    ,
		TxCtrl2GenTag373En	=> MsgGenTag373En	    ,
		TxCtrl2GenTag58En	=> MsgGenTag58En	    ,

		-- Market data address         
		MrketData0			=> MrketData0			,
		MrketData1			=> MrketData1			,
		MrketData2			=> MrketData2			,
		MrketData3			=> MrketData3			,
		MrketData4			=> MrketData4			,
		MrketDataEn			=> MrketDataEn			,

		-- Output validation                                          
		MrketSymbol0		=> MrketSymbol0		    ,
		MrketSecurityID0	=> MrketSecurityID0	    ,
		MrketVal0			=> rMrketVal0			,
		MrketSymbol1		=> MrketSymbol1		    ,
		MrketSecurityID1    => MrketSecurityID1     ,
		MrketVal1           => rMrketVal1           ,
		MrketSymbol2		=> MrketSymbol2		    ,
		MrketSecurityID2    => MrketSecurityID2     ,
		MrketVal2           => rMrketVal2           ,
		MrketSymbol3		=> MrketSymbol3		    ,
		MrketSecurityID3    => MrketSecurityID3     ,
		MrketVal3           => rMrketVal3           ,
		MrketSymbol4		=> MrketSymbol4		    ,
		MrketSecurityID4    => MrketSecurityID4     ,
		MrketVal4           => rMrketVal4           ,
	
		AsciiOutReq			=> rOutMuxReq1			,
		AsciiOutVal			=> rOutMuxVal1		    ,
		AsciiOutEop			=> rOutMuxEop1		    ,
		AsciiOutData		=> rOutMuxData1		    ,
		AsciiInStart		=> rInMuxStart1			,
		AsciiInTransEn 		=> rInMuxTransEn1 		,
		AsciiInDecPointEn	=> rInMuxDecPointEn1	,
		AsciiInNegativeExp	=> rInMuxNegativeExp1	,
		AsciiInData			=> rInMuxData1			,

		OutMsgWrAddr		=> rPayloadWrAddr		,
		OutMsgWrData		=> rPayloadWrData       ,
		OutMsgWrEn			=> rPayloadWrEn         ,
		OutMsgChecksum		=> rMsgGen2CtrlCheckSum ,
		OutMsgEnd			=> rMsgGen2CtrlEnd 		
	);
	
	u_MuxEncoder : MuxEncoder
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB				    ,

		InMuxStart0			=> rInMuxStart0			,
		InMuxTransEn0 		=> rInMuxTransEn0 		,
		InMuxDecPointEn0	=> rInMuxDecPointEn0	,
		InMuxNegativeExp0	=> rInMuxNegativeExp0	,
		InMuxData0			=> rInMuxData0			,
		InMuxStart1			=> rInMuxStart1			,
		InMuxTransEn1 		=> rInMuxTransEn1 		,
		InMuxDecPointEn1	=> rInMuxDecPointEn1	,
		InMuxNegativeExp1	=> rInMuxNegativeExp1	,
		InMuxData1			=> rInMuxData1			,

		OutMuxReq0			=> rOutMuxReq0			,
		OutMuxVal0			=> rOutMuxVal0			,
		OutMuxEop0			=> rOutMuxEop0			,
		OutMuxData0			=> rOutMuxData0			,
		OutMuxReq1			=> rOutMuxReq1			,
		OutMuxVal1			=> rOutMuxVal1			,
		OutMuxEop1			=> rOutMuxEop1			,
		OutMuxData1			=> rOutMuxData1			
	);                      
	
End Architecture rtl;
  