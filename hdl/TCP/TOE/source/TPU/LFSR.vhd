----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     LFSR.vhd
-- Title        LFSR random generator
-- 
-- Author       L.Ratchanon
-- Date         2020/11/04
-- Syntax       VHDL
-- Description    
-- 
-- Linear-feedback shift register : Fibonacci LFSRs
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity LFSR Is
	Port 
	(
		Clk				: in	std_logic;

		RandWordBinary	: out 	std_logic_vector(31 downto 0 )
	);
	
End Entity LFSR;


Architecture rtl Of LFSR Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cStartSeed : std_logic_vector(31 downto 0) := x"ABCD1234";
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	signal rLFSR 		: std_logic_vector(31 downto 0) := x"00000000";

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	RandWordBinary(31 downto 0)	<= rLFSR(31 downto 0);
	
-- Reference 
-- [1]	Linear Feedback Shift Registers in Virtex Devices
-- [2]	Table of Linear Feedback Shift Registers, Roy Ward, Tim Molteno 2007. 

----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
	
	-- 32-bits LFSR feedback polynomial : x^32 + x^30 + x^26 + x^25 + 1
	-- Using Fibonacci LFSRs 
	u_rLFSR : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialize all-zeroes state 
			if ( rLFSR=0 ) then 
				rLFSR(31 downto 0)	<= cStartSeed;
			else
				rLFSR(31 downto 1)	<= rLFSR(30 downto 0);
				rLFSR(0)			<= rLFSR(31) xnor rLFSR(29) xnor rLFSR(25) xnor rLFSR(24);
			end if;
		end if;	
	End Process u_rLFSR;

End Architecture rtl;