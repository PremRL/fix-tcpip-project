----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     IPHdGen.vhd
-- Title        IPHdGen For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/09/11
-- Syntax       VHDL
-- Description      
-- 
-- IPv4 Header Generator Module  
--
-- 				  IPv4 Header Format
--		******************************************
-- Octet 	|	0	|	1	|	2	|	3	|       
-- 0	:	|Ver| IHL	| DSCP|ECN|	Total Length	|
-- 1	:	|	Identification	|Flags|Fragm 	Off	|
-- 2	:	|   TTL	| Protocol|  Header Checksum	|
-- 3 :	|		  Source IP Address 			|
-- 4 : 	|		Destination IP Address			|
-- 5 : 	|		Options (if IHL > 5)			|
-- 		******************************************
--
-- List of feature
-- 1) IPv4 Header Generating : Ver = 4 (4 bits)
-- 2) Fixed Header size which is 20 byte meaning that no IP Option available : IHL = 5 (4 bits), IHL is 32 bit word.
-- 3) Not supporting ToS and ECN : DSCP(6 bit) and ECN (2 bits) all of them are zeros.
-- 4) Not supporting IP Flagments meaning Flags and Fragment Offset included 2 bytes are x"4000".
-- 5) Fixed Time-To-Live values : TTL = 60[x"40"] (1 byte)
-- 6) Fixed Protocol which is TCP : Protocol = 6 (1 byte)
--
-- Operation of this module. 
-- This module will wait for Start='1', with a specific control signal such as 
-- PayloadEn and DataLen, for generating IPv4 Header 20 byte.
--
-- Other field :
-- 1) Identification : identifying the group of fragments of a single IP datagram.
-- 2) Header Checksum : 16-bit IPv4 Header checksum 
-- 3) Source IP Address and Destination IP Address : Fixed value with the input signal.
-- 4) IP Option : Not supporting
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

Entity IPHdGen Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- TxOutCtrl Interface
			-- IPv4 Header 
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );
			-- Control
		DataLen			: in 	std_logic_vector(15 downto 0 ); -- MAX 8960 byte 
		PayloadEn		: in	std_logic;
		Start			: in	std_logic;
		TCPoption		: in 	std_logic;
		
		-- Memory Interface 
		RamIPHdWrData	: out 	std_logic_vector( 7 downto 0 );
		RamIPHdWrAddr	: out	std_logic_vector( 5 downto 0 );
		RamIPHdWrEn		: out 	std_logic
	);
End Entity IPHdGen;	
	
Architecture rtl Of IPHdGen Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	-- Detail : List of feature 
	constant cHEADER_VerIHL		: std_logic_vector( 7 downto 0 ) := x"45";
	constant cHEADER_DSCPECN	: std_logic_vector( 7 downto 0 ) := x"00";	
	constant cHEADER_Flag		: std_logic_vector(15 downto 0 ) := x"4000";	
	constant cHEADER_TTL		: std_logic_vector( 7 downto 0 ) := x"40";	
	constant cHEADER_Protocol	: std_logic_vector( 7 downto 0 ) := x"06";	
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	signal rRamIPHdWrDataFF	: std_logic_vector( 7 downto 0 );
	signal rRamIPHdWrData	: std_logic_vector( 7 downto 0 );
	signal rRamIPHdWrAddr	: std_logic_vector( 4 downto 0 );
	signal rRamIPHdWrAddrFF	: std_logic_vector( 5 downto 0 );
	signal rRamIPHdWrEn		: std_logic_vector( 1 downto 0 );
	
	-- IP Header varying field  
	signal rTotalLen	 	: std_logic_vector(15 downto 0 );
	signal rIdent			: std_logic_vector(15 downto 0 );
	signal rHdCheckSum		: std_logic_vector(16 downto 0 );
	
	signal rHdCheckSumEn	: std_logic_vector( 2 downto 0 );
	signal rSumEn			: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- Using FF control signal for syncing with Data signal 
	RamIPHdWrData		<= rRamIPHdWrData( 7 downto 0 );	
	RamIPHdWrAddr	    <= rRamIPHdWrAddrFF( 5 downto 0 );	
	RamIPHdWrEn		    <= rRamIPHdWrEn(1);	
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

-----------------------------------------------------------
-- IP Header Generator
	
	-- IP Header Data Mapping  
	u_rRamIPHdWrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRamIPHdWrDataFF( 7 downto 0 )	<= rRamIPHdWrData( 7 downto 0 );
			case ( rRamIPHdWrAddr ) is 
				when "00000" => rRamIPHdWrData <= cHEADER_VerIHL( 7 downto 0 );
				when "00001" => rRamIPHdWrData <= cHEADER_DSCPECN( 7 downto 0 );
				when "00010" => rRamIPHdWrData <= rTotalLen(15 downto 8 );
	            when "00011" => rRamIPHdWrData <= rTotalLen( 7 downto 0 );
				when "00100" => rRamIPHdWrData <= rIdent(15 downto 8 );
				when "00101" => rRamIPHdWrData <= rIdent( 7 downto 0 );
				when "00110" => rRamIPHdWrData <= cHEADER_Flag(15 downto 8 );
				when "00111" => rRamIPHdWrData <= cHEADER_Flag( 7 downto 0 );
				when "01000" => rRamIPHdWrData <= cHEADER_TTL( 7 downto 0 );
				when "01001" => rRamIPHdWrData <= cHEADER_Protocol( 7 downto 0 );
				when "01010" => rRamIPHdWrData <= not rHdCheckSum(15 downto 8 );
				when "01011" => rRamIPHdWrData <= not rHdCheckSum( 7 downto 0 );
				when "01100" => rRamIPHdWrData <= IPSouAddr(31 downto 24);
				when "01101" => rRamIPHdWrData <= IPSouAddr(23 downto 16);
				when "01110" => rRamIPHdWrData <= IPSouAddr(15 downto 8 );
				when "01111" => rRamIPHdWrData <= IPSouAddr( 7 downto 0 );
				when "10000" => rRamIPHdWrData <= IPDesAddr(31 downto 24);
				when "10001" => rRamIPHdWrData <= IPDesAddr(23 downto 16);
				when "10010" => rRamIPHdWrData <= IPDesAddr(15 downto 8 );
				when others  => rRamIPHdWrData <= IPDesAddr( 7 downto 0 );
			end case;
		end if;
	End Process u_rRamIPHdWrData;
	
	-- Using FF signal for addressing RAM
	u_rRamIPHdWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRamIPHdWrAddrFF( 5 downto 0 )	<= '0'&rRamIPHdWrAddr( 4 downto 0 );
			if ( Start='1' ) then 
				rRamIPHdWrAddr( 4 downto 0 )	<= (others=>'0');
			-- Not writing Checksum filed when calulating Checksum, 
			-- jump from writing Protocol field to Source IP Address.  
			elsif ( rRamIPHdWrAddr=9 ) then
				rRamIPHdWrAddr( 4 downto 0 )	<= "01100";
			-- Returning to Checksum field for writing (Checksum has already Calculated). 
			elsif ( rRamIPHdWrAddr=19 ) then 
				rRamIPHdWrAddr( 4 downto 0 )	<= "01010";
			elsif ( rRamIPHdWrEn(0)='1' ) then 
				rRamIPHdWrAddr( 4 downto 0 )	<= rRamIPHdWrAddr( 4 downto 0 ) + 1;
			else 
				rRamIPHdWrAddr( 4 downto 0 )	<= rRamIPHdWrAddr( 4 downto 0 );
			end if;
		end if;
	End Process u_rRamIPHdWrAddr;
	
	-- Using FF signal for enable writing signal  
	u_rRamIPHdWrEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamIPHdWrEn(1 downto 0)	<= "00";
			else 
				rRamIPHdWrEn(1)	<= rRamIPHdWrEn(0);
				-- Reset holding for calculating checksum field or End of Writing   
				if ( rRamIPHdWrAddr=19 or rRamIPHdWrAddr=11 ) then 
					rRamIPHdWrEn(0)	<= '0';
				-- Set Write Enable if Start or Checksum has already calculated.
				elsif ( Start='1' or rHdCheckSumEn(2 downto 1)="10") then
					rRamIPHdWrEn(0)	<= '1';
				else 
					rRamIPHdWrEn(0)	<= rRamIPHdWrEn(0);
				end if;
			end if;
		end if;
	End Process u_rRamIPHdWrEn;
	
-----------------------------------------------------------
-- Identidication and Total length field
	
	-- Identification of IP Flagments (NOt supporting)
	u_rIdent : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rIdent(15 downto 0 )	<= x"0000";
			else 
				-- Increment Identidication for every packet that has sent.
				if ( rHdCheckSumEn(1 downto 0)="10" ) then 
					rIdent(15 downto 0 )	<= rIdent(15 downto 0 ) + 1;
				else 
					rIdent(15 downto 0 )	<= rIdent(15 downto 0 );
				end if;
			end if;
		end if;
	End Process u_rIdent;
	
	-- latch value from TxOutCtrl when Start='1'. 
	-- In addition, Total length is length of IP header (20 byte)
	-- plus length of Payload which is TCP header (20 byte) and  
	-- Data ( signal : DataLen[Byte] )
	u_rTotalLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Send packet with TCP Payload 
			if ( Start='1' and PayloadEn='1' ) then 
				rTotalLen(15 downto 0 )	<= DataLen(15 downto 0 ) + x"0028";
			-- 44 bytes (No TCP payload)
			elsif ( Start='1' and TCPoption='1' ) then 
				rTotalLen(15 downto 0 )	<= x"002C";	
			-- 40 bytes (No TCP payload)
			elsif ( Start='1' ) then 
				rTotalLen(15 downto 0 )	<= x"0028";
			else 
				rTotalLen(15 downto 0 )	<= rTotalLen(15 downto 0 );
			end if;
		end if;
	End Process u_rTotalLen;
	
-----------------------------------------------------------
-- Checksum field 
-- Indicate that 16-bit checksum is no need to support an odd length header 
-- due to IPv4 Header always end up 32 bit word.  

	-- Checksum Enable
	u_rHdCheckSumEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHdCheckSumEn( 2 downto 0 )	<= "000";
			else
				rHdCheckSumEn( 2 downto 1 )	<= rHdCheckSumEn(1)&rHdCheckSumEn(0);
				if ( Start='1' ) then 
					rHdCheckSumEn(0)	<= '1';
				-- End of calculating checksum 
				elsif ( rRamIPHdWrAddr=19 ) then 
					rHdCheckSumEn(0)	<= '0';
				else 
					rHdCheckSumEn(0)	<= rHdCheckSumEn(0);
				end if;
			end if;
		end if;
	End Process u_rHdCheckSumEn;
	
	-- Adding checksum signal  
	u_rSumEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rHdCheckSumEn(1 downto 0)="01" ) then 
				rSumEn	<= '0'; 
			else 
				rSumEn	<= not rSumEn;
			end if;
		end if;
	End Process u_rSumEn;
	
	-- 16-bit Checksum of IPv4 Header 
	u_rHdCheckSum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rHdCheckSumEn(1 downto 0)="01" ) then 
				rHdCheckSum(16 downto 0 )	<= (others=>'0');
			-- Add 16-bit checksum 
			elsif ( rHdCheckSumEn(1)='1' and rSumEn='1' ) then 
				rHdCheckSum(16 downto 0 )	<= rHdCheckSum(16 downto 0 ) + ('0'&rRamIPHdWrDataFF(7 downto 0)&rRamIPHdWrData(7 downto 0));
			-- Increment overflow bit 
			else
				rHdCheckSum(16)				<= '0';
				rHdCheckSum(15 downto 0 )	<= rHdCheckSum(15 downto 0 ) + rHdCheckSum(16);
			end if;
		end if;
	End Process u_rHdCheckSum;
	
End Architecture rtl;