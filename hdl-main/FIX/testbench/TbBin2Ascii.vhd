----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbBin2Ascii.vhd
-- Title        Testbench of converting binary to ASCII
-- 
-- Author       L.Ratchanon
-- Date         2021/01/23
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use STD.textio.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_textio.all;
use work.PkTbAscii2Bin.all;

Entity TbBin2Ascii Is
End Entity TbBin2Ascii;

Architecture HTWTestBench Of TbBin2Ascii Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component Bin2Ascii Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		BinInStart			: in	std_logic;
		BinInDecPointEn		: in    std_logic;
		BinInNegativeExp	: in	std_logic_vector( 2 downto 0 );
		BinInData			: in 	std_logic_vector(26 downto 0 );
		
		AsciiInReady		: in	std_logic;
		AsciiOutReq			: out	std_logic;
		AsciiOutEop			: out 	std_logic;
		AsciiOutVal			: out 	std_logic;
		AsciiOutData		: out 	std_logic_vector( 7 downto 0 )
	);
	End Component Bin2Ascii;

-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	TM					: integer	range 0 to 65535;
	signal	TT					: integer	range 0 to 65535;
	
	signal	RstB				: std_logic;
	signal	Clk					: std_logic;
	
	-- Input 
	signal 	BinInStart			: std_logic;
	signal 	BinInDecPointEn		: std_logic;
	signal 	BinInNegativeExp	: std_logic_vector( 2 downto 0 );
	signal 	BinInData			: std_logic_vector(26 downto 0 );
	
	signal  BinInStart_t		: std_logic;
	signal  BinInDecPointEn_t	: std_logic;
	signal  BinInNegativeExp_t	: std_logic_vector( 2 downto 0 );
	signal  BinInData_t			: std_logic_vector(26 downto 0 );
	
	-- output 
	signal  AsciiInReady		: std_logic;
	signal  AsciiOutReq			: std_logic;
	signal  AsciiOutEop			: std_logic;
	signal  AsciiOutVal			: std_logic;
	signal  AsciiOutData		: std_logic_vector( 7 downto 0 );
	
	signal  AsciiInReady_t		: std_logic;
	signal  AsciiOutReq_t		: std_logic;
	signal  AsciiOutEop_t		: std_logic;
	signal  AsciiOutVal_t		: std_logic;
	signal  AsciiOutData_t		: std_logic_vector( 7 downto 0 );
	
	signal  AsciiDataInRec		: AsciiDataInRecord;

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
	
	u_rAsciiInReady : Process 
	Begin 
		if (RstB='0') then 
			AsciiInReady	<= '0';
		elsif ( AsciiOutReq='1' ) then 
			AsciiInReady	<= '1';
		elsif ( AsciiOutEop='1' ) then 
			AsciiInReady	<= '0';
		else 
			AsciiInReady	<= AsciiInReady;
		end if;
		wait until rising_edge(Clk);
	End Process u_rAsciiInReady;
	
	u_Bin2Ascii : Bin2Ascii 
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB					,

		BinInStart			=> BinInStart_t			,
		BinInDecPointEn		=> BinInDecPointEn_t	,
		BinInNegativeExp	=> BinInNegativeExp_t	,
		BinInData			=> BinInData_t			,	

		AsciiInReady		=> AsciiInReady_t		,
		AsciiOutReq			=> AsciiOutReq_t		,
		AsciiOutEop			=> AsciiOutEop_t		,
		AsciiOutVal			=> AsciiOutVal_t		,
		AsciiOutData		=> AsciiOutData_t		
		
	);

-- Signal assignment from testbench to Bin2Ascii with delay time
	BinInStart_t					<= BinInStart			after 1 ns;
	BinInDecPointEn_t	    		<= BinInDecPointEn		after 1 ns;
	BinInNegativeExp_t	    		<= BinInNegativeExp		after 1 ns;
	BinInData_t			    		<= BinInData			after 1 ns;
	AsciiInReady_t					<= AsciiInReady			after 1 ns;

-- Sinal assignment from Bin2Ascii to testbench with delay time
	AsciiOutReq						<= AsciiOutReq_t	 	after 1 ns;
	AsciiOutEop						<= AsciiOutEop_t		after 1 ns;
	AsciiOutVal		       			<= AsciiOutVal_t		after 1 ns;
	AsciiOutData	       			<= AsciiOutData_t	    after 1 ns;
	
-- Signal assignment to package 
	AsciiDataInRec.AsciiDataInVal	<= AsciiOutVal; 
	AsciiDataInRec.AsciiDataInEop	<= AsciiOutEop;
	AsciiDataInRec.AsciiDataIn	  	<= AsciiOutData; 

-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	u_Test : Process
	Begin
		-------------------------------------------
		-- TM=0 : Initialization  
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 

		BinInStart			<= '0';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "000";
		BinInData			<= (others=>'0');

		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Testing value  
		-------------------------------------------
		TM <= 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Binary value 1024 
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "000";
		BinInData			<= "000"&x"000400";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 510.909 
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "011";
		BinInData			<= "000"&x"07CBBD";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 0
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "000";
		BinInData			<= (others=>'0');
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 99,999,999
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "000";
		BinInData			<= "101"&x"F5E0FF";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 123456
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "000";
		BinInData			<= "000"&x"01E240";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 456789.01
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "010";
		BinInData			<= "010"&x"B90135";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 0.5
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "001";
		BinInData			<= "000"&x"000005";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 0.000
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "011";
		BinInData			<= "000"&x"000000";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 0.001
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "011";
		BinInData			<= "000"&x"000001";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		-- Binary value 1234.56
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '1';
		BinInNegativeExp	<= "010";
		BinInData			<= "000"&x"01E240";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		VerifyIntAscii(AsciiDataInRec, BinInData, BinInNegativeExp);
		
		
		-- Binary value 012
		wait until rising_edge(Clk);
		BinInStart			<= '1';
		BinInDecPointEn		<= '0';
		BinInNegativeExp	<= "011";
		BinInData			<= "000"&x"00000C";
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		
		wait for 100*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;