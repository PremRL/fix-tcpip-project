----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbBin2AsciiPipe.vhd
-- Title        Testbench of Converting binary to ASCII with pipling 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
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

Entity TbBin2AsciiPipe Is
End Entity TbBin2AsciiPipe;

Architecture HTWTestBench Of TbBin2AsciiPipe Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component Bin2AsciiPipe Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		BinInStart			: in	std_logic;
		BinInData			: in 	std_logic_vector( 6 downto 0 ); -- Max 99 

		AsciiOutEop			: out 	std_logic;
		AsciiOutVal			: out 	std_logic;
		AsciiOutData		: out 	std_logic_vector( 7 downto 0 )
	);
	End Component Bin2AsciiPipe;

-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	TM					: integer	range 0 to 65535;
	signal	TT					: integer	range 0 to 65535;
	
	signal	RstB				: std_logic;
	signal	Clk					: std_logic;
	
	-- Input 
	signal 	BinInStart			: std_logic;
	signal 	BinInData			: std_logic_vector( 6 downto 0 );
	
	signal  BinInStart_t		: std_logic;
	signal  BinInData_t			: std_logic_vector( 6 downto 0 );
	
	-- output 
	signal  AsciiOutEop			: std_logic;
	signal  AsciiOutVal			: std_logic;
	signal  AsciiOutData		: std_logic_vector( 7 downto 0 );
	
	signal  AsciiOutEop_t		: std_logic;
	signal  AsciiOutVal_t		: std_logic;
	signal  AsciiOutData_t		: std_logic_vector( 7 downto 0 );
	
	-- Verifying 
	signal  AsciiDataInRec		: AsciiDataInRecord;
	signal  BinInNegativeExp	: std_logic_vector( 1 downto 0 );

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

	
	u_Bin2AsciiPipe : Bin2AsciiPipe
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB					,

		BinInStart			=> BinInStart_t			,
		BinInData			=> BinInData_t			,	
		
		AsciiOutEop			=> AsciiOutEop_t		,
		AsciiOutVal			=> AsciiOutVal_t		,
		AsciiOutData		=> AsciiOutData_t		
	);

-- Signal assignment from testbench to Bin2Ascii with delay time
	BinInStart_t					<= BinInStart			after 1 ns;
	BinInData_t			    		<= BinInData			after 1 ns;

-- Sinal assignment from Bin2Ascii to testbench with delay time
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
		BinInData			<= (others=>'0');
		BinInNegativeExp	<= "00";

		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Testing value  
		-------------------------------------------
		TM <= 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		wait for 10*tClk;
		wait until rising_edge(Clk);
		
		For i in 0 to 99 loop 
		
		BinInStart			<= '1';
		BinInData			<= conv_std_logic_vector(i, 7);
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		wait until rising_edge(Clk);
		
		End loop;
		
		wait for 10*tClk;
		wait until rising_edge(Clk);
		
		For i in 0 to 99 loop 
		
		BinInStart			<= '1';
		BinInData			<= conv_std_logic_vector(i, 7);
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		wait until rising_edge(Clk);
		wait until rising_edge(Clk);
		
		End loop;
		
		wait for 50*tClk;
		-------------------------------------------
		-- TM=2 : Testing value  
		-------------------------------------------
		TM <= 2; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		
		BinInStart			<= '1';
		BinInData			<= conv_std_logic_vector(95, 7);
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		wait until rising_edge(Clk);
		
		BinInStart			<= '1';
		BinInData			<= conv_std_logic_vector(16, 7);
		wait until rising_edge(Clk);
		BinInStart			<= '0';
		wait until rising_edge(Clk);
		
		wait for 100*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;