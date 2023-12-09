----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbMuxEncoder.vhd
-- Title        Testbench of Mutiplexer for multiple ASCII encoders and users 
-- 
-- Author       L.Ratchanon
-- Date         2021/01/31
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
use work.PkTbMuxEncoder.all;

Entity TbMuxEncoder Is
End Entity TbMuxEncoder;

Architecture HTWTestBench Of TbMuxEncoder Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

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

-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	TM					: integer	range 0 to 65535;
	signal	TT					: integer	range 0 to 65535;
	
	signal	RstB				: std_logic;
	signal	Clk					: std_logic;
	
	-- Input 
	signal 	InMuxStart0			: std_logic;
	signal 	InMuxTransEn0 		: std_logic;
	signal 	InMuxDecPointEn0	: std_logic;
	signal 	InMuxNegativeExp0	: std_logic_vector( 1 downto 0 );
	signal  InMuxData0			: std_logic_vector(26 downto 0 );
	signal  InMuxStart1			: std_logic;
	signal  InMuxTransEn1 		: std_logic;
	signal  InMuxDecPointEn1	: std_logic;
	signal  InMuxNegativeExp1	: std_logic_vector( 1 downto 0 );
	signal  InMuxData1			: std_logic_vector(26 downto 0 );
	
	signal 	InMuxStart0_t		: std_logic;
	signal 	InMuxTransEn0_t 	: std_logic;
	signal 	InMuxDecPointEn0_t	: std_logic;
	signal 	InMuxNegativeExp0_t	: std_logic_vector( 2 downto 0 );
	signal  InMuxData0_t		: std_logic_vector(26 downto 0 );
	signal  InMuxStart1_t		: std_logic;
	signal  InMuxTransEn1_t 	: std_logic;
	signal  InMuxDecPointEn1_t	: std_logic;
	signal  InMuxNegativeExp1_t	: std_logic_vector( 2 downto 0 );
	signal  InMuxData1_t		: std_logic_vector(26 downto 0 );
	
	-- output 
	signal  OutMuxReq0			: std_logic;
	signal  OutMuxVal0			: std_logic;
	signal  OutMuxEop0			: std_logic;
	signal  OutMuxData0			: std_logic_vector( 7 downto 0 );
	signal  OutMuxReq1			: std_logic;
	signal  OutMuxVal1			: std_logic;
	signal  OutMuxEop1			: std_logic;
	signal  OutMuxData1			: std_logic_vector( 7 downto 0 );
	
	signal 	OutMuxReq0_t		: std_logic;
	signal 	OutMuxVal0_t		: std_logic;
	signal 	OutMuxEop0_t		: std_logic;
	signal 	OutMuxData0_t  		: std_logic_vector( 7 downto 0 );
	signal 	OutMuxReq1_t		: std_logic;
	signal 	OutMuxVal1_t		: std_logic;
	signal 	OutMuxEop1_t		: std_logic;
	signal 	OutMuxData1_t  		: std_logic_vector( 7 downto 0 );
	
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
	
	u_InMuxTransEn0 : Process 
	Begin 
		if (RstB='0') then 
			InMuxTransEn0	<= '0';
		elsif ( OutMuxReq0='1' ) then 
			wait for 2*tClk;
			wait until rising_edge(Clk);
			InMuxTransEn0	<= '1';
			wait until rising_edge(Clk);
			InMuxTransEn0	<= '0';
		else 
			InMuxTransEn0	<= InMuxTransEn0;
		end if;
		wait until rising_edge(Clk);
	End Process u_InMuxTransEn0;
	
	u_InMuxTransEn1 : Process 
	Begin 
		if (RstB='0') then 
			InMuxTransEn1	<= '0';
		elsif ( OutMuxReq1='1' ) then 
			InMuxTransEn1	<= '1';
			wait until rising_edge(Clk);
			InMuxTransEn1	<= '0';
		else 
			InMuxTransEn1	<= InMuxTransEn1;
		end if;
		wait until rising_edge(Clk);
	End Process u_InMuxTransEn1;
	
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

		InMuxStart1			=> InMuxStart1_t			,
		InMuxTransEn1 		=> InMuxTransEn1_t 		    ,
		InMuxDecPointEn1	=> InMuxDecPointEn1_t	    ,
		InMuxNegativeExp1	=> InMuxNegativeExp1_t	    ,
		InMuxData1			=> InMuxData1_t			    ,

		OutMuxReq0			=> OutMuxReq0_t			    ,
		OutMuxVal0			=> OutMuxVal0_t			    ,
		OutMuxEop0			=> OutMuxEop0_t			    ,
		OutMuxData0			=> OutMuxData0_t			,

		OutMuxReq1			=> OutMuxReq1_t			    ,
		OutMuxVal1			=> OutMuxVal1_t			    ,
		OutMuxEop1			=> OutMuxEop1_t			    ,
		OutMuxData1			=> OutMuxData1_t			
		
	);

-- Signal assignment from testbench to MuxEncoder with delay time
	InMuxStart0_t					<= InMuxStart0				after 1 ns;
	InMuxTransEn0_t 		    	<= InMuxTransEn0 			after 1 ns;
	InMuxDecPointEn0_t	    		<= InMuxDecPointEn0			after 1 ns;
	InMuxNegativeExp0_t	    		<= '0'&InMuxNegativeExp0	after 1 ns;
	InMuxData0_t					<= InMuxData0				after 1 ns;
	InMuxStart1_t					<= InMuxStart1				after 1 ns;
	InMuxTransEn1_t 		    	<= InMuxTransEn1 			after 1 ns;
	InMuxDecPointEn1_t	    		<= InMuxDecPointEn1			after 1 ns;
	InMuxNegativeExp1_t	    		<= '0'&InMuxNegativeExp1	after 1 ns;
	InMuxData1_t					<= InMuxData1				after 1 ns;

-- Sinal assignment from MuxEncoder to testbench with delay time
	OutMuxReq0						<= OutMuxReq0_t	 			after 1 ns;
	OutMuxVal0						<= OutMuxVal0_t				after 1 ns;
	OutMuxEop0		       			<= OutMuxEop0_t				after 1 ns;
	OutMuxData0		       			<= OutMuxData0_t    		after 1 ns;
	OutMuxReq1						<= OutMuxReq1_t	 			after 1 ns;
	OutMuxVal1		                <= OutMuxVal1_t				after 1 ns;
	OutMuxEop1		                <= OutMuxEop1_t				after 1 ns;
	OutMuxData1		                <= OutMuxData1_t    		after 1 ns;
	
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

		InMuxStart0			<= '0';
		InMuxDecPointEn0	<= '0';
		InMuxNegativeExp0	<= "00";
		InMuxData0			<= (others=>'0');
		InMuxStart1			<= '0';
		InMuxDecPointEn1	<= '0';	
		InMuxNegativeExp1	<= "00";
		InMuxData1			<= (others=>'0');

		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Testing value  
		-------------------------------------------
		TM <= 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Path 0 to Encoder 0 
		-- Binary value 1024 
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '0';
		InMuxNegativeExp0	<= "00";
		InMuxData0			<= "000"&x"000400";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		
		-- Path 1 to Encoder 0 
		-- Binary value 510.909 
		wait until rising_edge(Clk);
		InMuxStart1			<= '1';
		InMuxDecPointEn1	<= '1';
		InMuxNegativeExp1	<= "11";
		InMuxData1			<= "000"&x"07CBBD";
		wait until rising_edge(Clk);
		InMuxStart1			<= '0';
		wait until OutMuxEop1='1' and rising_edge(Clk); 
		
		-- Path 0 to Encoder 0 and 1 
		-- Binary value 0
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '0';
		InMuxNegativeExp0	<= "00";
		InMuxData0			<= (others=>'0');
		wait until rising_edge(Clk);
		
		-- Binary value 99,999,999
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '0';
		InMuxNegativeExp0	<= "00";
		InMuxData0			<= "101"&x"F5E0FF";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		
		-- Path 0 to Encoder 0 and 0 
		-- Binary value 123456
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '0';
		InMuxNegativeExp0	<= "00";
		InMuxData0			<= "000"&x"01E240";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		
		-- Binary value 456789.01
		wait until InMuxTransEn0='1' and OutMuxReq0='1' and rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '1';
		InMuxNegativeExp0	<= "10";
		InMuxData0			<= "010"&x"B90135";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		
		-- Swap 1
		-- Path 0 to encider 0 and Path 1 to encoder 1 
		-- Binary value 0.5
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '1';
		InMuxNegativeExp0	<= "01";
		InMuxData0			<= "000"&x"000005";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		-- Binary value 0.000
		InMuxStart1			<= '1';
		InMuxDecPointEn1	<= '1';
		InMuxNegativeExp1	<= "11";
		InMuxData1			<= "000"&x"000000";
		wait until rising_edge(Clk);
		InMuxStart1			<= '0';
		wait until OutMuxEop1='1' and rising_edge(Clk); 
		
		-- Swap 2
		-- Path 0 to encider 1 and Path 1 to encoder 0 
		-- Binary value 0.001
		wait until rising_edge(Clk);
		InMuxStart1			<= '1';
		InMuxDecPointEn1	<= '1';
		InMuxNegativeExp1	<= "11";
		InMuxData1			<= "000"&x"000001";
		wait until rising_edge(Clk);
		InMuxStart1			<= '0';
		
		-- Binary value 1234.56
		wait for 10*tClk;
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '1';
		InMuxNegativeExp0	<= "10";
		InMuxData0			<= "000"&x"01E240";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Buging verification 
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Binary value 1234.56
		wait for 10*tClk;
		wait until rising_edge(Clk);
		InMuxStart0			<= '1';
		InMuxDecPointEn0	<= '1';
		InMuxNegativeExp0	<= "10";
		InMuxData0			<= "000"&x"01E240";
		wait until rising_edge(Clk);
		InMuxStart0			<= '0';
		wait until OutMuxEop0='1' and rising_edge(Clk); 
		
		
		wait for 100*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;