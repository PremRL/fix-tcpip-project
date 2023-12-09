----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTxFixMsgGen.vhd
-- Title        Mapping for TxFixMsgGen
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
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
use work.PkSigTbTxFixMsgGen.all;

Entity PkMapTbTxFixMsgGen Is
End Entity PkMapTbTxFixMsgGen;

Architecture HTWTestBench Of PkMapTbTxFixMsgGen Is 

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
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
	
	
	u_TxFixMsgGen : TxFixMsgGen 
	Port map
	(
		Clk						=> Clk						,
		RstB				    => RstB                     ,

		TxCtrl2GenReq		    => TxCtrl2GenReq_t		    ,
		TxCtrl2GenMsgType	    => TxCtrl2GenMsgType_t	    ,

		Gen2TxCtrlBusy		    => Gen2TxCtrlBusy_t		    ,

		TxCtrl2GenTag98		    => TxCtrl2GenTag98		    ,
		TxCtrl2GenTag108	    => TxCtrl2GenTag108	        ,
		TxCtrl2GenTag141	    => TxCtrl2GenTag141	        ,
		TxCtrl2GenTag553	    => TxCtrl2GenTag553	        ,
		TxCtrl2GenTag554	    => TxCtrl2GenTag554	        ,
		TxCtrl2GenTag1137	    => TxCtrl2GenTag1137	    ,
		TxCtrl2GenTag553Len	    => TxCtrl2GenTag553Len	    ,
		TxCtrl2GenTag554Len	    => TxCtrl2GenTag554Len	    ,

		TxCtrl2GenTag112	    => TxCtrl2GenTag112	        ,
		TxCtrl2GenTag112Len	    => TxCtrl2GenTag112Len	    ,

		TxCtrl2GenTag262	    => TxCtrl2GenTag262	        ,
		TxCtrl2GenTag263	    => TxCtrl2GenTag263	        ,
		TxCtrl2GenTag264	    => TxCtrl2GenTag264	        ,
		TxCtrl2GenTag265	    => TxCtrl2GenTag265	        ,
		TxCtrl2GenTag266	    => TxCtrl2GenTag266	        ,
		TxCtrl2GenTag146	    => TxCtrl2GenTag146	        ,
		TxCtrl2GenTag22		    => TxCtrl2GenTag22		    ,
		TxCtrl2GenTag267	    => TxCtrl2GenTag267	        ,
		TxCtrl2GenTag269        => TxCtrl2GenTag269         ,

		TxCtrl2GenTag7		    => TxCtrl2GenTag7		    ,
		TxCtrl2GenTag16		    => TxCtrl2GenTag16		    ,

		TxCtrl2GenTag123	    => TxCtrl2GenTag123	        ,
		TxCtrl2GenTag36		    => TxCtrl2GenTag36		    ,

		TxCtrl2GenTag45		    => TxCtrl2GenTag45		    ,
		TxCtrl2GenTag371	    => TxCtrl2GenTag371	        ,
		TxCtrl2GenTag372	    => TxCtrl2GenTag372	        ,
		TxCtrl2GenTag373	    => TxCtrl2GenTag373	        ,
		TxCtrl2GenTag58		    => TxCtrl2GenTag58		    ,
		TxCtrl2GenTag371Len	    => TxCtrl2GenTag371Len	    ,
		TxCtrl2GenTag373Len	    => TxCtrl2GenTag373Len	    ,
		TxCtrl2GenTag58Len	    => TxCtrl2GenTag58Len	    ,
		TxCtrl2GenTag371En	    => TxCtrl2GenTag371En	    ,
		TxCtrl2GenTag372En	    => TxCtrl2GenTag372En	    ,
		TxCtrl2GenTag373En	    => TxCtrl2GenTag373En	    ,
		TxCtrl2GenTag58En	    => TxCtrl2GenTag58En	    ,

		MrketData0			    => MrketData0			    ,
		MrketData1			    => MrketData1			    ,
		MrketData2			    => MrketData2			    ,
		MrketData3			    => MrketData3			    ,
		MrketData4			    => MrketData4			    ,
		MrketDataEn			    => MrketDataEn_t            ,
		MrketSymbol0		    => MrketSymbol0_t		    ,
		MrketSecurityID0	    => MrketSecurityID0_t	    ,
		MrketVal0			    => MrketVal0_t			    ,
		MrketSymbol1		    => MrketSymbol1_t		    ,
		MrketSecurityID1        => MrketSecurityID1_t       , 
		MrketVal1               => MrketVal1_t              , 
		MrketSymbol2		    => MrketSymbol2_t		    ,
		MrketSecurityID2        => MrketSecurityID2_t       , 
		MrketVal2               => MrketVal2_t              , 
		MrketSymbol3		    => MrketSymbol3_t		    ,
		MrketSecurityID3        => MrketSecurityID3_t       , 
		MrketVal3               => MrketVal3_t              , 
		MrketSymbol4		    => MrketSymbol4_t		    ,
		MrketSecurityID4        => MrketSecurityID4_t       , 
		MrketVal4               => MrketVal4_t              , 
		
		AsciiOutReq			    => AsciiOutReq			    ,    
		AsciiOutVal			    => AsciiOutVal			    ,    
		AsciiOutEop			    => AsciiOutEop			    ,    
		AsciiOutData		    => AsciiOutData		        ,
		AsciiInStart		    => AsciiInStart		        ,
		AsciiInTransEn 		    => AsciiInTransEn 		    ,    
		AsciiInDecPointEn	    => AsciiInDecPointEn	    ,
		AsciiInNegativeExp	    => AsciiInNegativeExp	    ,
		AsciiInData			    => AsciiInData			    ,    

		OutMsgWrAddr		    => OutMsgWrAddr_t		    ,
		OutMsgWrData		    => OutMsgWrData_t		    ,
		OutMsgWrEn			    => OutMsgWrEn_t			    ,
		OutMsgChecksum		    => OutMsgChecksum_t		    ,
		OutMsgEnd			    => OutMsgEnd_t			    
	);
	
	
	u_MuxEncoder : MuxEncoder 
	Port map 
	(
		Clk					=> Clk						,
		RstB				=> RstB				        ,

		InMuxStart0			=> InMuxStart0_t			,
		InMuxTransEn0 		=> InMuxTransEn0_t 		    ,
		InMuxDecPointEn0	=> InMuxDecPointEn0_t	    ,
		InMuxNegativeExp0	=> InMuxNegativeExp0_t	    ,
		InMuxData0			=> InMuxData0_t			    ,

		InMuxStart1			=> '0'						,
		InMuxTransEn1 		=> '0' 		    			,
		InMuxDecPointEn1	=> '0'	    				,
		InMuxNegativeExp1	=> "000"	    			,
		InMuxData1			=> (others=>'0')			,

		OutMuxReq0			=> OutMuxReq0_t			    ,
		OutMuxVal0			=> OutMuxVal0_t			    ,
		OutMuxEop0			=> OutMuxEop0_t			    ,
		OutMuxData0			=> OutMuxData0_t			,

		OutMuxReq1			=> open			    		,
		OutMuxVal1			=> open			    		,
		OutMuxEop1			=> open			    		,
		OutMuxData1			=> open			
	);

-- Signal assignment from TxFixMsgGen to MuxEncoder with delay time
	InMuxStart0_t					<= AsciiInStart		    	after 1 ns;
	InMuxTransEn0_t 		    	<= AsciiInTransEn 			after 1 ns;
	InMuxDecPointEn0_t	    		<= AsciiInDecPointEn		after 1 ns;
	InMuxNegativeExp0_t	    		<= AsciiInNegativeExp		after 1 ns;
	InMuxData0_t					<= AsciiInData				after 1 ns;
	
	
-- Sinal assignment from MuxEncoder to TxFixMsgGen with delay time
	AsciiOutReq						<= OutMuxReq0_t	 			after 1 ns;
	AsciiOutVal						<= OutMuxVal0_t				after 1 ns;
	AsciiOutEop		       			<= OutMuxEop0_t				after 1 ns;
	AsciiOutData		       		<= OutMuxData0_t    		after 1 ns;
	
-- Signal assignment from Testbench to TxFixMsgGen with delay time
	TxCtrl2GenReq_t					<= TxCtrl2GenReq			after 1 ns;
	TxCtrl2GenMsgType_t				<= TxCtrl2GenMsgType 		after 1 ns;
	MrketDataEn_t					<= MrketDataEn				after 1 ns;
	
-- Signal assignment from TxFixMsgGen to Testbench with delay time
	Gen2TxCtrlBusy					<= Gen2TxCtrlBusy_t			after 1 ns;
	MrketSymbol0					<= MrketSymbol0_t		   	after 1 ns;	 
	MrketSecurityID0	            <= MrketSecurityID0_t	    after 1 ns;
	MrketVal0			            <= MrketVal0_t			    after 1 ns;
	MrketSymbol1		            <= MrketSymbol1_t		    after 1 ns;
	MrketSecurityID1                <= MrketSecurityID1_t       after 1 ns;
	MrketVal1                       <= MrketVal1_t              after 1 ns;
	MrketSymbol2		            <= MrketSymbol2_t		    after 1 ns;
	MrketSecurityID2                <= MrketSecurityID2_t       after 1 ns;
	MrketVal2                       <= MrketVal2_t              after 1 ns;
	MrketSymbol3		            <= MrketSymbol3_t		    after 1 ns;
	MrketSecurityID3                <= MrketSecurityID3_t       after 1 ns;
	MrketVal3                       <= MrketVal3_t              after 1 ns;
	MrketSymbol4		            <= MrketSymbol4_t		    after 1 ns;
	MrketSecurityID4                <= MrketSecurityID4_t       after 1 ns;
	MrketVal4                       <= MrketVal4_t              after 1 ns;
	OutMsgWrAddr		   			<= OutMsgWrAddr_t			after 1 ns;
	OutMsgWrData		            <= OutMsgWrData_t		    after 1 ns;
	OutMsgWrEn			            <= OutMsgWrEn_t			    after 1 ns;
	OutMsgChecksum		            <= OutMsgChecksum_t		    after 1 ns;
	OutMsgEnd			            <= OutMsgEnd_t			    after 1 ns;
	
End Architecture HTWTestBench;