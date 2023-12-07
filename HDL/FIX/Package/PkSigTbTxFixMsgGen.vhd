----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTxFixMsgGen.vhd
-- Title        Signal declaration for TxFixMsgGen
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
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;

Package PkSigTbTxFixMsgGen Is

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
	signal  TxCtrl2GenReq		 	: std_logic;
	signal  TxCtrl2GenMsgType	    : std_logic_vector( 2 downto 0 );
	
	-- Logon 
	signal  TxCtrl2GenTag98		    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag108	    : std_logic_vector(15  downto 0 );
	signal  TxCtrl2GenTag141	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag553	    : std_logic_vector(127 downto 0 );
	signal  TxCtrl2GenTag554	    : std_logic_vector(127 downto 0 );
	signal  TxCtrl2GenTag1137	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag553Len	    : std_logic_vector( 4  downto 0 );
	signal  TxCtrl2GenTag554Len	    : std_logic_vector( 4  downto 0 );
	
	-- Heartbeat 
	signal  TxCtrl2GenTag112	    : std_logic_vector(127 downto 0 );
	signal  TxCtrl2GenTag112Len	    : std_logic_vector( 4  downto 0 );
	
	-- MrkDataReq 
	signal  TxCtrl2GenTag262	    : std_logic_vector(15  downto 0 );
	signal  TxCtrl2GenTag263	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag264	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag265	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag266	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag146	    : std_logic_vector( 3  downto 0 );
	signal  TxCtrl2GenTag22		    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag267	    : std_logic_vector( 2  downto 0 );
	signal  TxCtrl2GenTag269        : std_logic_vector(15  downto 0 );
	
	-- ResendReq 
	signal  TxCtrl2GenTag7		    : std_logic_vector(26  downto 0 );
	signal  TxCtrl2GenTag16		    : std_logic_vector( 7  downto 0 );
	
	-- SeqReset 
	signal  TxCtrl2GenTag123	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag36		    : std_logic_vector(26  downto 0 );
	
	-- Reject 
	signal  TxCtrl2GenTag45		    : std_logic_vector(26  downto 0 );
	signal  TxCtrl2GenTag371	    : std_logic_vector(31  downto 0 );
	signal  TxCtrl2GenTag372	    : std_logic_vector( 7  downto 0 );
	signal  TxCtrl2GenTag373	    : std_logic_vector(15  downto 0 );
	signal  TxCtrl2GenTag58		    : std_logic_vector(127 downto 0 );
	signal  TxCtrl2GenTag371Len	    : std_logic_vector( 2  downto 0 );
	signal  TxCtrl2GenTag373Len	    : std_logic_vector( 1  downto 0 );
	signal  TxCtrl2GenTag58Len	    : std_logic_vector( 3  downto 0 );
	signal  TxCtrl2GenTag371En	    : std_logic;
	signal  TxCtrl2GenTag372En	    : std_logic;
	signal  TxCtrl2GenTag373En	    : std_logic;
	signal  TxCtrl2GenTag58En	    : std_logic;
	
	-- Mrket data Addressing 
	signal  MrketData0			    : std_logic_vector( 9 downto 0 );
	signal  MrketData1			    : std_logic_vector( 9 downto 0 );
	signal  MrketData2			    : std_logic_vector( 9 downto 0 );
	signal  MrketData3			    : std_logic_vector( 9 downto 0 );
	signal  MrketData4			    : std_logic_vector( 9 downto 0 );
	signal  MrketDataEn			    : std_logic_vector( 2 downto 0 );
	
	signal  TxCtrl2GenReq_t			: std_logic;
	signal  TxCtrl2GenMsgType_t		: std_logic_vector( 2 downto 0 );
	signal  MrketDataEn_t			: std_logic_vector( 2 downto 0 );
	
	-- Output 
	signal	Gen2TxCtrlBusy			: std_logic;
	
	signal  MrketSymbol0			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID0		: std_logic_vector(15 downto 0 );
	signal  MrketVal0				: std_logic;
	signal  MrketSymbol1			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID1    	: std_logic_vector(15 downto 0 );
	signal  MrketVal1           	: std_logic;
	signal  MrketSymbol2			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID2    	: std_logic_vector(15 downto 0 );
	signal  MrketVal2           	: std_logic;
	signal  MrketSymbol3			: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID3    	: std_logic_vector(15 downto 0 );
	signal  MrketVal3           	: std_logic;
	signal  MrketSymbol4	 		: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID4 		: std_logic_vector(15 downto 0 );
	signal  MrketVal4         		: std_logic;
	
	signal  OutMsgWrAddr	 		: std_logic_vector( 9 downto 0 );
	signal  OutMsgWrData	 		: std_logic_vector( 7 downto 0 );
	signal  OutMsgWrEn		 		: std_logic;
	signal  OutMsgChecksum		    : std_logic_vector( 7 downto 0 );
    signal  OutMsgEnd		        : std_logic;

	signal	Gen2TxCtrlBusy_t		: std_logic;
	
	signal  MrketSymbol0_t		 	: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID0_t	 	: std_logic_vector(15 downto 0 );
	signal  MrketVal0_t			 	: std_logic;
	signal  MrketSymbol1_t		 	: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID1_t    	: std_logic_vector(15 downto 0 );
	signal  MrketVal1_t           	: std_logic;
	signal  MrketSymbol2_t		 	: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID2_t    	: std_logic_vector(15 downto 0 );
	signal  MrketVal2_t           	: std_logic;
	signal  MrketSymbol3_t		 	: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID3_t    	: std_logic_vector(15 downto 0 );
	signal  MrketVal3_t          	: std_logic;
	signal  MrketSymbol4_t		 	: std_logic_vector(47 downto 0 );
	signal  MrketSecurityID4_t    	: std_logic_vector(15 downto 0 );
	signal  MrketVal4_t           	: std_logic;
	
	signal  OutMsgWrAddr_t			: std_logic_vector( 9 downto 0 );
	signal  OutMsgWrData_t			: std_logic_vector( 7 downto 0 );
	signal  OutMsgWrEn_t			: std_logic;
	signal  OutMsgChecksum_t	    : std_logic_vector( 7 downto 0 );
	signal  OutMsgEnd_t		     	: std_logic;
	
	-- Encoder I/F 
	signal  AsciiOutReq	            : std_logic;
	signal  AsciiOutVal	            : std_logic;
	signal  AsciiOutEop	            : std_logic;
	signal  AsciiOutData            : std_logic_vector( 7 downto 0 );
	
	signal  AsciiInStart		    : std_logic; 
	signal  AsciiInTransEn 		    : std_logic; 
	signal  AsciiInDecPointEn		: std_logic;
	signal  AsciiInNegativeExp	    : std_logic_vector( 2 downto 0 );
	signal  AsciiInData			    : std_logic_vector(26 downto 0 );
	
	signal  InMuxStart0_t			: std_logic;
	signal  InMuxTransEn0_t 		: std_logic;
	signal  InMuxDecPointEn0_t		: std_logic;
	signal  InMuxNegativeExp0_t		: std_logic_vector( 2 downto 0 );
	signal  InMuxData0_t			: std_logic_vector(26 downto 0 );

	signal  OutMuxReq0_t	 		: std_logic;
	signal  OutMuxVal0_t		    : std_logic;
	signal  OutMuxEop0_t		    : std_logic;
	signal  OutMuxData0_t           : std_logic_vector( 7 downto 0 );
	
	
End Package PkSigTbTxFixMsgGen;		