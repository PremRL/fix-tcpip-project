----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     Ascii2Bin.vhd
-- Title        Convert ASCII characters to binary 
-- 
-- Author       L.Ratchanon
-- Date        	2021/01/23
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- This module decode an ASCII code byte by byte. 
-- Maximum integer supported : 8 byte (99,999,999 -- 27 bits) 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity Ascii2Bin Is
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
End Entity Ascii2Bin;

Architecture rtl Of Ascii2Bin Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	signal rAsciiInValFF		: std_logic;
	
	signal rAsc2BinDataFF 		: std_logic_vector(26 downto 0 );
	signal rAsc2BinData 		: std_logic_vector(26 downto 0 );
	signal rAscii2BinNumMap 	: std_logic_vector( 3 downto 0 );
	
	signal rAscii2BinCtrl 		: std_logic_vector( 3 downto 0 );
	signal rBinOutNegativeExp	: std_logic_vector( 1 downto 0 );
	signal rBinOutVal			: std_logic;

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	BinOutVal						<= rBinOutVal; 
	BinOutData(26 downto 0 )		<= rAsc2BinDataFF(26 downto 0 );
	BinOutNegativeExp( 1 downto 0 )	<= rBinOutNegativeExp( 1 downto 0 );
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

	u_rFFInputSignal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiInValFF	<= '0';
			else 
				rAsciiInValFF	<= AsciiInVal;
			end if;
		end if;
	End Process u_rFFInputSignal;

	u_rAscii2BinCtrl : Process (Clk) Is 
	Begin 	
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAscii2BinCtrl( 3 downto 0 )	<= (others=>'0');
			else 
				-- Bit 0: Control bit 
				if ( AsciiInSop='1' and AsciiInVal='1' ) then 
					rAscii2BinCtrl(0)	<= '1';
				elsif ( rAscii2BinCtrl(1)='1' ) then 
					rAscii2BinCtrl(0)	<= '0';
				else 
					rAscii2BinCtrl(0)	<= rAscii2BinCtrl(0);
				end if;
				
				-- Bit 1: detect end of integer 
				if ( (AsciiInData(7 downto 4)/=x"3" or AsciiInData(3 downto 2)="11" or  
					AsciiInData(3 downto 0)=x"A" or AsciiInData(3 downto 0)=x"B") 
					and AsciiInVal='1' ) then 
					rAscii2BinCtrl(1)	<= '1';
				else 
					rAscii2BinCtrl(1)	<= '0';
				end if;
				
				-- Bit 2: detect dot for decimal point start extracting 
				if ( rAscii2BinCtrl(1)='1' and rAscii2BinCtrl(3)='1' ) then 
					rAscii2BinCtrl(2)	<= '0';
				elsif ( AsciiInData(7 downto 0)=x"2E" and AsciiInVal='1' and rAscii2BinCtrl(0)='1' ) then 
					rAscii2BinCtrl(2)	<= '1';
				else 
					rAscii2BinCtrl(2)	<= rAscii2BinCtrl(2); 
				end if;
				
				-- Bit 3: FF bit 2 
				rAscii2BinCtrl(3)		<= rAscii2BinCtrl(2);
				
			end if;
		end if;
	End Process u_rAscii2BinCtrl;
	
	-- ASCII code to Binary. Number only 0 - 9 (x"30" --> x"39")
	u_rAscii2BinNumMap : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			-- 9 down to 0 
			case ( AsciiInData ) Is 
				When x"39"	=> rAscii2BinNumMap	<= "1001";
				When x"38"	=> rAscii2BinNumMap	<= "1000";
				When x"37"	=> rAscii2BinNumMap	<= "0111";
				When x"36"	=> rAscii2BinNumMap	<= "0110";
				When x"35"	=> rAscii2BinNumMap	<= "0101";
				When x"34"	=> rAscii2BinNumMap	<= "0100";
				When x"33"	=> rAscii2BinNumMap	<= "0011";
				When x"32"	=> rAscii2BinNumMap	<= "0010";
				When x"31"	=> rAscii2BinNumMap	<= "0001";
				When others	=> rAscii2BinNumMap	<= "0000";
			end case; 
		end if;
	End Process u_rAscii2BinNumMap;
	
	u_rAsc2BinData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Used FF signal 
			rAsc2BinDataFF(26 downto 0 )		<= rAsc2BinData(26 downto 0 ); 
			-- Reset Value 
			if ( AsciiInSop='1' and AsciiInVal='1' ) then 
				rAsc2BinData(26 downto 0 )		<= (others=>'0');
			-- Add input and multiplier it self (By 10)
			elsif ( (rAscii2BinCtrl(0)='1' or rAscii2BinCtrl(3 downto 2)="11") 
				and rAscii2BinCtrl(1)='0' and rAsciiInValFF='1' ) then 
				rAsc2BinData(26 downto 0 )		<= (rAsc2BinData(25 downto 0)&'0') + (rAsc2BinData(23 downto 0)&"000")
													+ ("000"&x"00000"&rAscii2BinNumMap(3 downto 0));
			else 
				rAsc2BinData(26 downto 0 )		<= rAsc2BinData(26 downto 0 ); 
			end if;
		end if;
	End Process u_rAsc2BinData;
	
	u_rBinOutNegativeExp : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset 
			if ( rAscii2BinCtrl(1 downto 0)="11" ) then 
				rBinOutNegativeExp( 1 downto 0 )	<= (others=>'0');
			elsif ( rAscii2BinCtrl(3 downto 1)="110") then 
				rBinOutNegativeExp( 1 downto 0 )	<= rBinOutNegativeExp( 1 downto 0 )	+ 1;
			else 
				rBinOutNegativeExp( 1 downto 0 )	<= rBinOutNegativeExp( 1 downto 0 );
			end if;
		end if;
	End Process u_rBinOutNegativeExp;
		
	u_rBinOutVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rBinOutVal		<= '0';
			else 
				if ( rAscii2BinCtrl(1)='1' and (rAscii2BinCtrl(2)='0' or rAscii2BinCtrl(3)='1') ) then 
					rBinOutVal	<= '1';
				else 
					rBinOutVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rBinOutVal; 
	
End Architecture rtl;