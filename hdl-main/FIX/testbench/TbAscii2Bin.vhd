----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbAscii2Bin.vhd
-- Title        Testbench of converting ASCII characters to binary 
-- 
-- Author       L.Ratchanon
-- Date        	2021/01/23
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

Entity TbAscii2Bin Is
End Entity TbAscii2Bin;

Architecture HTWTestBench Of TbAscii2Bin Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component Ascii2Bin Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		AsciiInSop			: in 	std_logic;
		AsciiInEop			: in 	std_logic;
		AsciiInVal			: in 	std_logic;
		AsciiInData			: in 	std_logic_vector( 7 downto 0 );
		
		BinOutVal			: out	std_logic;
		BinOutNegativeExp	: out	std_logic_vector( 1 downto 0 );
		BinOutData			: out 	std_logic_vector(26 downto 0 )
	);
	End Component Ascii2Bin;

	
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	TM					: integer	range 0 to 65535;
	signal	TT					: integer	range 0 to 65535;
	
	signal	RstB				: std_logic;
	signal	Clk					: std_logic;
	
	-- Input 
	signal  AsciiInSop_t		: std_logic;
	signal  AsciiInEop_t		: std_logic;
	signal  AsciiInVal_t		: std_logic;
	signal  AsciiInData_t		: std_logic_vector( 7 downto 0 );
	
	-- output 
	signal  BinOutVal			: std_logic;
	signal  BinOutNegativeExp	: std_logic_vector( 1 downto 0 );
	signal  BinOutData			: std_logic_vector(26 downto 0 );
	
	signal  BinOutVal_t			: std_logic;
	signal  BinOutNegativeExp_t	: std_logic_vector( 1 downto 0 );
	signal  BinOutData_t		: std_logic_vector(26 downto 0 );

	-- Package 
	signal  AsciiDataGenRecOut	: AsciiDataGenRecord;
	
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
	
	
	u_Ascii2Bin : Ascii2Bin 
	Port map 
	(
		Clk					=> Clk					,
		RstB				=> RstB			   		,

		AsciiInSop			=> AsciiInSop_t			,
		AsciiInEop			=> AsciiInEop_t			,
		AsciiInVal			=> AsciiInVal_t			,
		AsciiInData			=> AsciiInData_t		,	

		BinOutVal			=> BinOutVal_t			,
		BinOutNegativeExp	=> BinOutNegativeExp_t	,
		BinOutData			=> BinOutData_t
	);

-- Signal assignment from testbench to Ascii2Bin with delay time
	AsciiInSop_t		<= AsciiDataGenRecOut.AsciiDataGenSop 	after 1 ns;
	AsciiInEop_t	    <= AsciiDataGenRecOut.AsciiDataGenEop 	after 1 ns;
	AsciiInVal_t	    <= AsciiDataGenRecOut.AsciiDataGenVal 	after 1 ns;
	AsciiInData_t       <= AsciiDataGenRecOut.AsciiDataGen	  	after 1 ns;

-- Sinal assignment from Ascii2Bin to testbench with delay time
	BinOutVal			<= BinOutVal_t							after 1 ns;
	BinOutNegativeExp   <= BinOutNegativeExp_t   				after 1 ns;
	BinOutData			<= BinOutData_t							after 1 ns;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	u_Test : Process
	variable 	vDataValue			: String (1 to 20);
	
	Begin
		-------------------------------------------
		-- TM=0 : Result 
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		AsciiDataGenInitial(AsciiDataGenRecOut);

		wait for 20*tClk;
		-------------------------------------------
		-- TM=0 : Testing value  
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Send value 123 
		vDataValue(1 to 4)	:= "123:"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk;
		
		vDataValue(1 to 4)	:= "123;"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk;
		
		vDataValue(1 to 4)	:= "123<"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk;
		
		vDataValue(1 to 4)	:= "123="; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk; 
		
		vDataValue(1 to 4)	:= "123>"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk;
		
		vDataValue(1 to 4)	:= "123?"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 4), Clk);
		wait for 10*tClk;
		
		-- Send value 1.001 
		vDataValue(1 to 6)	:= "1.001|"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 6), Clk);
		wait for 10*tClk;
		
		-- Send value 0 
		vDataValue(1 to 6)	:= "0.451|";
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 6), Clk);
		wait for 10*tClk;
		
		-- Send value 1024.0 
		vDataValue(1 to 7)	:= "1024.0|";
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 7), Clk);
		wait for 10*tClk;
		
		-- Send value 522154
		vDataValue(1 to 7)	:= "522154:";
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 7), Clk);
		wait for 10*tClk;
		
		-- Send value 99999.999
		vDataValue(1 to 10)	:= "99999.999|"; 
		AsciiDataGen(AsciiDataGenRecOut, vDataValue(1 to 10), Clk);
		wait for 10*tClk;
		
		wait for 20*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;