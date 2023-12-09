----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     CheckSumCal.vhd
-- Title        Payload CheckSum
-- 
-- Version	 	0.02
-- Author      	L.Ratchanon
-- Date        	2020/10/23
-- Syntax      	VHDL
-- Description 	Add signals to interface with Queue module 
--
-- Version	 	0.01
-- Author      	L.Ratchanon
-- Date        	2020/09/11
-- Syntax      	VHDL
-- Description 	New Creation    
--
-- CheckSum Calculation for Data Payload
----------------------------------------------------------------------------------
-- Note
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity CheckSumCal Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- Queue Processor Interface (Data Input)
		Q2CDataLen		: in	std_logic_vector(15 downto 0 );
		Q2CDataIn		: in 	std_logic_vector( 7 downto 0 );
		Q2CDataVal		: in 	std_logic;
		Q2CDataSop		: in	std_logic;
		Q2CDataEop		: in	std_logic;
		Q2CCheckSumEnd	: in	std_logic;
		
		Q2CBusy			: out 	std_logic;
		
		-- Memory Interface
		RamLoadWrData	: out 	std_logic_vector( 7 downto 0 );
		RamLoadWrAddr	: out	std_logic_vector(13 downto 0 );
		RamLoadWrEn		: out 	std_logic;
		
		-- TxOutCtrl Interface
		Start			: in	std_logic;
		PayloadEn		: in	std_logic;
		
		PayloadLen		: out	std_logic_vector(15 downto 0 );
		CheckSum		: out 	std_logic_vector(15 downto 0 );
		CheckSumCalEnd	: out 	std_logic
	);
End Entity CheckSumCal;	
	
Architecture rtl Of CheckSumCal Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	signal rQ2CDataInFF		: std_logic_vector( 7 downto 0 );
	signal rQ2CDataEopFF	: std_logic_vector( 1 downto 0 );
	signal rQ2CDataValFF	: std_logic_vector( 1 downto 0 );

	signal rCheckSum		: std_logic_vector(16 downto 0 );
	signal rSumEn			: std_logic;
	signal rQ2CBusy			: std_logic;
	
	signal rRamLoadWrAddr	: std_logic_vector(13 downto 0 );
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- TCP/IP Interface
	PayloadLen(15 downto 0 )<= Q2CDataLen(15 downto 0 );
	CheckSum(15 downto 0 )	<= rCheckSum(15 downto 0 );
	CheckSumCalEnd			<= Q2CCheckSumEnd;
	
	-- Queue Process Interface 
	Q2CBusy					<= rQ2CBusy;
	
	-- Memory Interface
	RamLoadWrData			<= rQ2CDataInFF( 7 downto 0 );		
	RamLoadWrAddr	        <= rRamLoadWrAddr(13 downto 0 );	
	RamLoadWrEn		        <= rQ2CDataValFF(0);	
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-- FF Data Input 

	u_rQ2CDataInFF : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then 
				rQ2CDataEopFF( 1 downto 0 )	<= "00";
			    rQ2CDataValFF( 1 downto 0 )	<= "00";
			else 
				rQ2CDataEopFF( 1 downto 0 )	<= rQ2CDataEopFF(0)&Q2CDataEop;
				rQ2CDataValFF( 1 downto 0 )	<= rQ2CDataValFF(0)&Q2CDataVal;
			end if;
			
			if ( Q2CDataVal='1' ) then 
				rQ2CDataInFF( 7 downto 0 )	<= Q2CDataIn( 7 downto 0 );
			else 
				rQ2CDataInFF( 7 downto 0 )	<= rQ2CDataInFF( 7 downto 0 );
			end if;
		end if;
	End Process u_rQ2CDataInFF;
	
----------------------------------------------------------------------------------
-- Adding signal  
	
	u_rSumEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Q2CDataSop='1' ) then 
				rSumEn	<= '1';
			elsif ( rQ2CBusy='0' ) then 
				rSumEn	<= '0';
			elsif ( Q2CDataVal='1' ) then 
				rSumEn	<= not rSumEn;
			else 
				rSumEn	<= rSumEn;
			end if;
		end if;
	End Process u_rSumEn;

----------------------------------------------------------------------------------
-- Output Generator 
	
	-- 16-bit Checksum 
	u_rCheckSum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rQ2CBusy='0' ) then 
				rCheckSum(16 downto 0 )	<= (others=>'0');
			-- Add 16-bit checksum 
			elsif ( Q2CDataVal='1' and rSumEn='1' ) then 
				rCheckSum(16 downto 0 )	<= rCheckSum(16 downto 0 ) + ('0'&rQ2CDataInFF(7 downto 0)&Q2CDataIn(7 downto 0));
			-- if length of data is odd number, then add the last data byte to CheckSum with padding zero on the MSB byte.
			elsif ( rQ2CDataEopFF(0)='1' and rQ2CDataValFF(0)='1' and rSumEn='1' ) then 
				rCheckSum(16 downto 0 )	<= rCheckSum(16 downto 0 ) + ('0'&rQ2CDataInFF(7 downto 0)&x"00");
			-- Increment overflow bit
			else
				rCheckSum(16)			<= '0';
				rCheckSum(15 downto 0 )	<= rCheckSum(15 downto 0 ) + rCheckSum(16);
			end if;
		end if;
	end Process u_rCheckSum;
	
	-- Busy 
	u_rQ2CBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rQ2CBusy	<= '0';
			else 
				if ( Start='1' and PayloadEn='1' ) then 
					rQ2CBusy	<= '0';
				elsif ( Q2CDataSop='1' and Q2CDataVal='1' ) then 
					rQ2CBusy	<= '1';
				else 
					rQ2CBusy	<= rQ2CBusy;
				end if;
			end if;
		end if;
	End Process u_rQ2CBusy;

	-- Memory I/F
	u_rRamLoadWrAddr : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamLoadWrAddr(13 downto 0 )	<= (others=>'0');
			else 
				if ( rQ2CDataValFF(0)='1' ) then 
					rRamLoadWrAddr(13 downto 0 )	<= rRamLoadWrAddr(13 downto 0 ) + 1;
				else 
					rRamLoadWrAddr(13 downto 0 )	<= rRamLoadWrAddr(13 downto 0 );
				end if;
			end if;
		end if;
	End Process u_rRamLoadWrAddr;
	
End Architecture rtl;