----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TCPHdGen.vhd
-- Title        TCPHdGen For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/09/4
-- Syntax       VHDL
-- Description      
-- 
-- TCP Header Generator Module  
--
-- 				  TCP Header Format
--		*****************************************
-- Octet |	0	|	1	|	2	|	3		|       
-- 0	:	|	Source port	|   Destination port	|
-- 1	:	|			Sequence number			|
-- 2	:	|  		Acknowledgment number			|
-- 3 :	|off|Re|	 Flags	| 	Window Size		|	
-- 4 : 	|	Checksum		|	Urgent pointer	|
-- 5 : 	|		Options (if  data offset > 5)	|
-- 		*****************************************
--
-- List of feature
-- 1) Fixed Header size which is 20 byte meaning that no TCP Option available 
--	: Offset = 5 (4 bits), Offset is 32 bit word.
-- 2) Not supporting SACK (For now).
-- 3) All Flags are supported.
-- 4) Reserved is zero bits : Res = "000" (3 bits)
-- 5) Data checksum must be calculated before send to this module,
--	PayloadEn='1' if there is any payload with specific length 
---	and Checksum must be calculated.
--
-- Operation of this module. 
-- This module will wait for Start='1', with a specific control signal such as 
-- PayloadEn, DataLen, DataCheckSum and TCP variable for generating TCP Header 20 byte.
--
-- Other field :
-- 1) Checksum : 16-bit TCP Header checksum : IPv4 Pseudo header, TCP header and Data.
-- 2) Source port and Destination port : Fixed value with the input signal.
-- 3) Source IP Address and Destination IP Address : Fixed value with the input signal.
-- 4) TCP Option : Not supporting
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

Entity TCPHdGen Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- TCP/IP Processor interface  
			-- IPv4 Pseudo Header  
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );
			-- TCP Header 
		SouPort			: in 	std_logic_vector(15 downto 0 );
		DesPort			: in 	std_logic_vector(15 downto 0 );	
		SeqNum			: in	std_logic_vector(31 downto 0 );
		AckNum			: in	std_logic_vector(31 downto 0 );
		DataOffset		: in 	std_logic_vector( 3 downto 0 );
		Flags			: in	std_logic_vector( 8 downto 0 );
		Window			: in 	std_logic_vector(15 downto 0 );
		Urgent			: in 	std_logic_vector(15 downto 0 );
		OptionMss		: in 	std_logic_vector(15 downto 0 );
			-- Control I/F
		DataLen			: in 	std_logic_vector(15 downto 0 );
		PayloadEn		: in	std_logic;
		Start			: in	std_logic;
		
		-- Data Interface 
		DataCheckSum	: in 	std_logic_vector(15 downto 0 );
		
		-- Memory Interface 
		RamTCPHdWrData	: out 	std_logic_vector( 7 downto 0 );
		RamTCPHdWrAddr	: out	std_logic_vector( 5 downto 0 );
		RamTCPHdWrEn	: out 	std_logic
	);
End Entity TCPHdGen;	
	
Architecture rtl Of TCPHdGen Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	-- Detail : List of feature 
	constant cPSEUDO_HdProtocol	: std_logic_vector(15 downto 0 ) := x"0006";
	constant cOptionKind_Mss	: std_logic_vector( 7 downto 0 ) := x"02";
	constant cOptionLength_Mss	: std_logic_vector( 7 downto 0 ) := x"04";
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- Memory I/F 
	signal rRamTCPHdWrData		: std_logic_vector( 7 downto 0 );
	signal rRamTCPHdWrAddr		: std_logic_vector( 5 downto 0 );
	signal rRamTCPHdWrEn		: std_logic;
	
	-- TCP Header variable signal   
	signal rTCPLength	 		: std_logic_vector(15 downto 0 ); 
	signal rTCPHdOffset			: std_logic_vector( 3 downto 0 ); 
	signal rHdCheckSum			: std_logic_vector(16 downto 0 );
	
	-- Checksum Process
	signal rHdCheckSumData		: std_logic_vector(15 downto 0 );
	signal rHdCheckSumCnt		: std_logic_vector( 4 downto 0 );
	signal rHdCheckSumEn		: std_logic_vector( 1 downto 0 );
	signal rHdCheckSumVal		: std_logic_vector( 1 downto 0 );
	signal rSumEn				: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- TCP Header Generator To RamTCPHd
	RamTCPHdWrData		<= rRamTCPHdWrData( 7 downto 0 );	
	RamTCPHdWrAddr	    <= rRamTCPHdWrAddr( 5 downto 0 );	
	RamTCPHdWrEn	 	<= rRamTCPHdWrEn;	
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------	
-----------------------------------------------------------
-- Total length field (For pseudoheader)
	
	-- latch value from TCP/IP Processor when Start='1'. 
	-- In addition, Total length is length of IP header (20 byte) due to
	-- the total length of IPv4 Pseudo-header is TCP header plus length of data.
	-- Data ( signal : DataLen[Byte] )
	u_rTCPLength : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then  
			if ( Start='1' and PayloadEn='1' ) then 
				rTCPLength(15 downto 0 )	<= DataLen(15 downto 0 ) + 20;
			-- SYN flag set (MSS option) : 24  Bytes 
			elsif ( Start='1' and Flags(1)='1' ) then 
				rTCPLength(15 downto 0 )	<= x"0018";
			-- Only TCP Header : 20 Bytes [x"14"]
			elsif ( Start='1' ) then 
				rTCPLength(15 downto 0 )	<= x"0014";
			else 
				rTCPLength(15 downto 0 )	<= rTCPLength(15 downto 0 );
			end if;
		end if;
	End Process u_rTCPLength;
	
	u_rTCPHdOffset : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Option : MSS 
			if ( Start='1' and Flags(1)='1' ) then 
				rTCPHdOffset( 3 downto 0 )	<= "0110";
			-- Not option 
			elsif ( Start='1' ) then 
				rTCPHdOffset( 3 downto 0 )	<= "0101";
			else 
				rTCPHdOffset( 3 downto 0 )	<= rTCPHdOffset( 3 downto 0 );
			end if; 
		end if;
	End Process u_rTCPHdOffset; 
	
-----------------------------------------------------------
-- Checksum field 
-- Indicate that 16-bit checksum is no need to support an odd length header 
-- due to TCP Header always end up 32 bit word.  
	
	-- 16-bit Input Data Checksum 
	u_rHdCheckSumData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rSumEn='0' ) then 
				case ( rHdCheckSumCnt ) is 
					when "00000"	=>	rHdCheckSumData	<= IPSouAddr(31 downto 16);
					when "00001"	=>	rHdCheckSumData	<= IPSouAddr(15 downto 0 );
					when "00010"	=>	rHdCheckSumData	<= IPDesAddr(31 downto 16);
					when "00011"	=>	rHdCheckSumData	<= IPDesAddr(15 downto 0 );
					when "00100"	=>	rHdCheckSumData	<= cPSEUDO_HdProtocol(15 downto 0 );
					when "00101"	=>	rHdCheckSumData	<= rTCPLength(15 downto 0 );
					when "00110"	=>	rHdCheckSumData	<= SouPort(15 downto 0 );
					when "00111"	=>	rHdCheckSumData	<= DesPort(15 downto 0 );
					when "01000"	=>	rHdCheckSumData	<= SeqNum(31 downto 16);
					when "01001"	=>	rHdCheckSumData	<= SeqNum(15 downto 0 );
					when "01010"	=>	rHdCheckSumData	<= AckNum(31 downto 16);
					when "01011"	=>	rHdCheckSumData	<= AckNum(15 downto 0 );
					when "01100"	=>	rHdCheckSumData	<= rTCPHdOffset(3 downto 0)&"000"&Flags(8 downto 0);
					when "01101"	=>	rHdCheckSumData	<= window(15 downto 0 );
					when "01110"	=>	rHdCheckSumData	<= Urgent(15 downto 0 );
					when "01111"	=>	rHdCheckSumData	<= cOptionKind_Mss(7 downto 0)&cOptionLength_Mss(7 downto 0);
					when others 	=>  rHdCheckSumData	<= OptionMss(15 downto 0 );
				end case;
			else 
				rHdCheckSumData(15 downto 0 )	<= rHdCheckSumData(15 downto 0 );
			end if;
		end if;
	End Process u_rHdCheckSumData;

	-- Checksum Enable
	u_rHdCheckSumEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHdCheckSumEn( 1 downto 0 )	<= "00";
			else
				rHdCheckSumEn(1)	<= rHdCheckSumEn(0);
				if ( Start='1' ) then 
					rHdCheckSumEn(0)	<= '1';
				-- No TCP option 
				elsif ( ((rHdCheckSumCnt=14 and Flags(1)='0')
				-- TCP option - MSS 
					or rHdCheckSumCnt=16) and rSumEn='1' ) then 
					rHdCheckSumEn(0)	<= '0';
				else 
					rHdCheckSumEn(0)	<= rHdCheckSumEn(0);
				end if;
			end if;
		end if;
	End Process u_rHdCheckSumEn;
	
	-- Checksum validation after checksum calculated.
	u_rHdCheckSumVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHdCheckSumVal( 1 downto 0 )	<= "00";
			else 
				rHdCheckSumVal(1)	<= rHdCheckSumVal(0);
				if ( rHdCheckSumVal(1)='1' ) then 
					rHdCheckSumVal(0)	<= '0';
				elsif ( rHdCheckSumEn(1 downto 0)="10" ) then 
					rHdCheckSumVal(0)	<= '1';
				else	
					rHdCheckSumVal(0)	<= rHdCheckSumVal(0);
				end if;
			end if;
		end if;
	End Process u_rHdCheckSumVal;
	
	-- Counter for HdCheckSumData
	u_rHdCheckSumCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Start='1' ) then 
				rHdCheckSumCnt( 4 downto 0 )	<= (others=>'0');
			elsif ( rHdCheckSumEn(0)='1' and rSumEn='1' ) then 
				rHdCheckSumCnt( 4 downto 0 )	<= rHdCheckSumCnt( 4 downto 0 ) + 1;
			else 
				rHdCheckSumCnt( 4 downto 0 )	<= rHdCheckSumCnt( 4 downto 0 );
			end if; 
		end if;
	End Process u_rHdCheckSumCnt;
	
	-- Adding checksum signal  
	u_rSumEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Start='1' ) then 
				rSumEn	<= '0'; 
			else 
				rSumEn	<= not rSumEn;
			end if;
		end if;
	End Process u_rSumEn;
	
	-- 16-bit Checksum of TCP Header 
	u_rHdCheckSum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Start='1' and PayloadEn='1' ) then
				rHdCheckSum(16 downto 0 )	<= '0'&DataCheckSum(15 downto 0 );
			elsif ( Start='1' ) then 
				rHdCheckSum(16 downto 0 )	<= (others=>'0');
			-- Add 16-bit checksum 
			elsif ( rHdCheckSumEn(1)='1' and rSumEn='1' ) then 
				rHdCheckSum(16 downto 0 )	<= rHdCheckSum(16 downto 0 ) + ('0'&rHdCheckSumData(15 downto 0 ));
			-- Increment overflow bit 
			elsif ( rHdCheckSumEn(1)='1' ) then 
				rHdCheckSum(16)				<= '0';
				rHdCheckSum(15 downto 0 )	<= rHdCheckSum(15 downto 0 ) + rHdCheckSum(16);
			else 
				rHdCheckSum(16 downto 0 )	<= rHdCheckSum(16 downto 0 );
			end if;
		end if;
	End Process u_rHdCheckSum;

-----------------------------------------------------------
-- Output TCP Header Generator (Memory Interface)
	
	-- TCP Header Data Mapping  
	u_rRamTCPHdWrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- -- 1's complement Checksum field 
			if ( rHdCheckSumVal(1)='1' ) then 
				rRamTCPHdWrData( 7 downto 0 )	<= not rHdCheckSum( 7 downto 0 );
			elsif ( rHdCheckSumVal(0)='1' ) then 
				rRamTCPHdWrData( 7 downto 0 )	<= not rHdCheckSum(15 downto 8 );
			-- Other field 
			elsif ( rHdCheckSumEn(1)='1' and rSumEn='1' ) then 
				rRamTCPHdWrData( 7 downto 0 )	<= rHdCheckSumData(15 downto 8 );
			else
				rRamTCPHdWrData( 7 downto 0 )	<= rHdCheckSumData( 7 downto 0 );
			end if;
		end if;
	End Process u_rRamTCPHdWrData;
	
	-- Write Ram Addressing 
	u_rRamTCPHdWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( rHdCheckSumEn(1 downto 0)="01" ) then  
				rRamTCPHdWrAddr( 5 downto 0 )	<= (others=>'0');
			-- Jump back to Checksum field (End of Checksum) : 16
			elsif ( (rRamTCPHdWrAddr=19 and Flags(1)='0') or rRamTCPHdWrAddr=23 ) then 
				rRamTCPHdWrAddr( 5 downto 0 )	<= "010000";
			-- Jump over Checksum field to Urgent pointer : 18
			elsif ( rRamTCPHdWrAddr=15 ) then 
				rRamTCPHdWrAddr( 5 downto 0 )	<= "010010";
			elsif ( rRamTCPHdWrEn='1' ) then 
				rRamTCPHdWrAddr( 5 downto 0 )	<= rRamTCPHdWrAddr( 5 downto 0 ) + 1;
			else 
				rRamTCPHdWrAddr( 5 downto 0 )	<= rRamTCPHdWrAddr( 5 downto 0 );
			end if;
		end if;
	End Process u_rRamTCPHdWrAddr;
	
	-- Write Ram Enable 
	u_rRamTCPHdWrEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamTCPHdWrEn	<= '0';
			else 
				if ( rHdCheckSumVal(1 downto 0)="10" ) then 
					rRamTCPHdWrEn	<= '0';
				elsif ( rHdCheckSumCnt=6 and rSumEn='1' ) then 
					rRamTCPHdWrEn	<= '1';
				else 
					rRamTCPHdWrEn	<= rRamTCPHdWrEn;
				end if;
			end if;
		end if;
	End Process u_rRamTCPHdWrEn;
	
End Architecture rtl;