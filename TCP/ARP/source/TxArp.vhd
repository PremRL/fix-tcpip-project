---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Filename     TxArp.vhd
-- Title        TxArp 
-- 
-- Author       L.Ratchanon
-- Date         2020/09/19
-- Syntax       VHDL
-- Description      
-- 
-- ARP Packet Generation for 
-- Internet Protocol (IPv4) over Ethernet ARP packet.
--
-- Take necessary parameters such as SenderMACAddr, TargetMACAddr, SenderIpAddr,
-- TargetIpAddr and Operation to create an ARP packet. 
-- EtherType of Ethernet header frame must be x"0806" (ARP).
--
-- ARP Information
--
-- 							ARP Format 
-- 		**************************************************************************
-- Octet	|		0		|		1		|		2		|		3		|	
-- 0		|   			HTYPE 2 Bytes			| 			PTYPE 2 Bytes			| 
-- 4		|  HLEN 1 Byte	| 	PLEN 1 Byte	| 			OPER	 2 Bytes 		|
-- 8		|  			Sender hardware address (SHA) 6 Byte : First 4 byte		|
-- 12	| 		SHA 6 Byte : Last 2 byte	| SPA Sender protocol address 4 Byte	|
-- 16	|		SPA	Last 2 Byte			| 			 THA : First 2 bytes	|
-- 20	|		THA Target hardware address : Last 4 bytes					|
-- 24	|		TPA Target protocol address 4 Byte							|
--		**************************************************************************
--
-- Notation
-- 1) HTYPE is Hardware type by using ether, then HTYPE must be 1.
-- 2) PTYPE is Protocol type by using Ipv4, then PTYPE must be x"0800".
-- 3) HLEN is Hardware length of which Ethernet address length is 6.
-- 4) PLEN is Protocol length of which IPv4 address length is 4.
-- 5) OPER is Operation mode of ARP. the value must be either 1 or 2 depend on mode.
-- 6) SHA is Sender hardware address, Ethernet MAC address of ours.
-- 7) SPA is Sender IP address, IPv4 address of ours.
-- 8) THA is Target hardware address, Ethernet MAC address of ours target.
-- 9) TPA is Target protocol address, IPv4 address of ours target.
-- 
-- This module generating ARP packet depend on mode that selecting
-- meaning that when OptionCode='1' is a Reply operation mode (OPER=2)
-- and when OptionCode='0' is a Request operation mode (OPER=1)
--
-- About Operation Mode 
-- 1) Request operation
-- 		- Destination MAC address is unknown, then all equal to '1' (Boardcasting)
-- 		- OPER = 1
--		- THA is unknown, then this field is ignored.
--		- TPA must be known
-- 2) Reply operation 
-- 		- Destination MAC address must be known 
--		- OPER = 2
--		- THA = Destination MAC address
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

Entity TxArp Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- ARP controller interface  
		SenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		TargetMACAddr	: in	std_logic_vector(47 downto 0 );
		SenderIpAddr	: in 	std_logic_vector(31 downto 0 );
		TargetIpAddr	: in 	std_logic_vector(31 downto 0 );
		OptionCode		: in	std_logic;
		ArpGenReq		: in 	std_logic;
		
		TxArpBusy		: out	std_logic;
		
		-- EMAC Interface
		Req				: out	std_logic;
		Ready			: in	std_logic;
		
		DataOut			: out	std_logic_vector(7 downto 0);
		DataOutVal		: out	std_logic;
		DataOutSop		: out	std_logic;
		DataOutEop		: out	std_logic
	);
End Entity TxArp;	
	
Architecture rtl Of TxArp Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	-- Option Code field : OptionCode='1' is Reply else Request 
	constant cOPTIONCODE_Reply		: std_logic_vector( 7 downto 0 )	:= x"02";
	constant cOPTIONCODE_Request	: std_logic_vector( 7 downto 0 )	:= x"01";
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- ARP fixed format 
	type RomType		is array (0 to 7) of std_logic_vector(7 downto 0);
	signal rArpRom		: RomType :=
	(
	--	FLOW OF OPERATATION :		        START -------------------->
	--	>>-------------------->> END
	--	|	PType	|  HLen  | PLen |	  EtherType   |	HType	|
		x"08", x"00", x"06", x"04", x"08", x"06", x"00", x"01"
	);
	-- Sender and Target Address signal 
	signal rMACAddr			: std_logic_vector( 7 downto 0 );
	signal rIpAddr			: std_logic_vector( 7 downto 0 );
	signal rAddrCnt			: std_logic_vector( 2 downto 0 );
	
	-- Internal signal 
	signal rArpReq			: std_logic;
	signal rArpOutAddr		: std_logic_vector( 5 downto 0 );
	signal rChSel0			: std_logic_vector( 5 downto 0 );
	signal rChSel1			: std_logic_vector( 5 downto 0 );
	
	-- Controllet I/F 
	signal rTxArpBusy		: std_logic;
	
	-- EMAC signal 
	signal rDataOut			: std_logic_vector( 7 downto 0 );
	signal rDataOutVal		: std_logic;
	signal rDataOutSop      : std_logic;
	signal rDataOutEop      : std_logic;

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- EMAC I/F 
	Req					<= rArpReq;
	DataOut				<= rDataOut( 7 downto 0 );				
	DataOutVal			<= rDataOutVal;		
	DataOutSop			<= rDataOutSop;		
	DataOutEop			<= rDataOutEop;
	
	-- RxArp I/F
	TxArpBusy			<= rTxArpBusy;
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

-----------------------------------------------------------
-- Arp Addressing Process
	
	-- Addressing 
	u_rAddrCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset when end of Hardware Addr or end of SPA 
			if ( rAddrCnt=5 or (rAddrCnt=3 and rChSel0(4)='1') ) then 
				rAddrCnt( 2 downto 0 )	<= (others=>'0');
			elsif ( rChSel0(4 downto 1)/="0000" ) then 
				rAddrCnt( 2 downto 0 )	<= rAddrCnt( 2 downto 0 ) + 1;
			else 
				rAddrCnt( 2 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rAddrCnt;
	
	u_rMACAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Target MAC Address 
			if ( rChSel0(1)='1' and OptionCode='1' ) then 
				case ( rAddrCnt ) is 
					when "000"	=>	rMACAddr	<= TargetMACAddr(47 downto 40);	
					when "001"	=>	rMACAddr	<= TargetMACAddr(39 downto 32);	
					when "010"	=>	rMACAddr	<= TargetMACAddr(31 downto 24);	
					when "011"	=>	rMACAddr	<= TargetMACAddr(23 downto 16);	
					when "100"	=>	rMACAddr	<= TargetMACAddr(15 downto 8 );	
					when others	=>	rMACAddr	<= TargetMACAddr( 7 downto 0 );	
				end case; 
			-- Sender MAC Address 
			elsif ( rChSel0(2)='1' ) then  
				case ( rAddrCnt ) is 
					when "000"	=>	rMACAddr	<= SenderMACAddr(47 downto 40);	
					when "001"	=>	rMACAddr	<= SenderMACAddr(39 downto 32);	
					when "010"	=>	rMACAddr	<= SenderMACAddr(31 downto 24);	
					when "011"	=>	rMACAddr	<= SenderMACAddr(23 downto 16);	
					when "100"	=>	rMACAddr	<= SenderMACAddr(15 downto 8 );	
					when others	=>	rMACAddr	<= SenderMACAddr( 7 downto 0 );	
				end case;
			-- Target MAC Address : Broadcast 
			else 
				rMACAddr( 7 downto 0 )	<= x"FF";
			end if;
		end if;
	End Process u_rMACAddr;
	
	u_rIpAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Target IP Address 
			if ( rChSel0(3)='1' ) then 
				case ( rAddrCnt(1 downto 0) ) is
					when "00"	=> rIpAddr	<= TargetIpAddr(31 downto 24);
					when "01"	=> rIpAddr	<= TargetIpAddr(23 downto 16);
					when "10"	=> rIpAddr	<= TargetIpAddr(15 downto 8 );
					when others	=> rIpAddr	<= TargetIpAddr( 7 downto 0 );
				end case;
			-- Sender IP Address 
			else 
				case ( rAddrCnt(1 downto 0) ) is
					when "00"	=> rIpAddr	<= SenderIpAddr(31 downto 24);
					when "01"	=> rIpAddr	<= SenderIpAddr(23 downto 16);
					when "10"	=> rIpAddr	<= SenderIpAddr(15 downto 8 );
					when others	=> rIpAddr	<= SenderIpAddr( 7 downto 0 );
				end case;
			end if;
		end if;
	End Process u_rIpAddr;

-----------------------------------------------------------
-- TxArp Control signal 
	
	-- Request to TxEMAC 
	u_rArpReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rArpReq	<= '0';
			else 
				if ( ArpGenReq='1' and rTxArpBusy='0' ) then 
					rArpReq	<= '1';
				elsif ( Ready='1' ) then 
					rArpReq	<= '0';
				else 
					rArpReq	<= rArpReq;	
				end if;
			end if;
		end if;
	End Process u_rArpReq;
	
	-- Busy for ARP Processor 
	u_rTxArpBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxArpBusy	<= '0';
			else 
				-- Eop 
				if ( rChSel0(3)='0' and rChSel1(3)='1' ) then 
					rTxArpBusy	<= '0';
				-- Tx Req  
				elsif ( ArpGenReq='1' ) then 
					rTxArpBusy	<= '1';
				else 
					rTxArpBusy	<= rTxArpBusy;
				end if;
			end if;
		end if;
	End Process u_rTxArpBusy;
	
	-- Data Addressing by counter 
	-- Note that 
	-- 0 - 13	=> Ethernet header frame
	-- 14 - 41 	=> ARP Packet 
	u_rArpOutAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rChSel1(0)='1' ) then 
				rArpOutAddr( 5 downto 0 )	<= rArpOutAddr( 5 downto 0 ) + 1;
			else 
				rArpOutAddr( 5 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rArpOutAddr;
	
	-- Channel selection 
	-- All Zeros	=> Idle 
	-- bit(5)	=> Send Option Code 
	-- bit(4)	=> Send Sender IP Address 
	-- bit(3)	=> Send Target IP Address 
	-- bit(2)	=> Send Sender MAC Address 
	-- bit(1)	=> Send Target MAC Address 
	-- bit(0)	=> Send Data 
	u_rChSel : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rChSel0( 5 downto 0 )	<= "000000";
				rChSel1( 5 downto 0 )	<= "000000";
			else 
				rChSel1( 5 downto 0 )	<= rChSel0( 5 downto 0 );
				-- End of Arp 
				if ( rArpOutAddr=40 ) then 
					rChSel0(0)	<= '0';
				-- Start of Arp 
				elsif ( rArpReq='1' and Ready='1' ) then
					rChSel0(0)	<= '1';
				else 
					rChSel0(0)	<= rChSel0(0);
				end if;
				
				-- Target MAC 
				if ( (rArpReq='1' and Ready='1') or rArpOutAddr=30 ) then
					rChSel0(1)	<= '1';
				elsif ( rAddrCnt=5 ) then 
					rChSel0(1)	<= '0';
				else 
					rChSel0(1)	<= rChSel0(1);
				end if;
				
				-- Sender MAC 
				if ( rArpOutAddr=4 or rArpOutAddr=20 ) then
					rChSel0(2)	<= '1';
				elsif ( rAddrCnt=5 ) then 
					rChSel0(2)	<= '0';
				else 
					rChSel0(2)	<= rChSel0(2);
				end if;			
				
				-- Target IP 
				if ( rArpOutAddr=36 ) then
					rChSel0(3)	<= '1';
				elsif ( rAddrCnt=3 ) then 
					rChSel0(3)	<= '0';
				else 
					rChSel0(3)	<= rChSel0(3);
				end if;	
				
				-- Sender IP 
				if ( rArpOutAddr=26 ) then
					rChSel0(4)	<= '1';
				elsif ( rAddrCnt=3 ) then 
					rChSel0(4)	<= '0';
				else 
					rChSel0(4)	<= rChSel0(4);
				end if;	
				
				-- Option Code 
				if ( rArpOutAddr=18 ) then 
					rChSel0(5)	<= '1';
				elsif ( rChSel1(5)='1' ) then
					rChSel0(5)	<= '0';
				else 
					rChSel0(5)	<= rChSel0(5);
				end if;	
			end if;
		end if;
	End Process u_rChSel;
	
-----------------------------------------------------------
-- Output Generator 
	
	-- DataOut Mapping 
	u_rDataOut : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Sender/Target MAC 
			if ( rChSel1(1)='1' or rChSel1(2)='1' ) then 
				rDataOut( 7 downto 0 )	<= rMACAddr( 7 downto 0 );
			-- Sender/Target IP 
			elsif ( rChSel1(3)='1' or rChSel1(4)='1' ) then
				rDataOut( 7 downto 0 )	<= rIpAddr( 7 downto 0 );
			-- Option Code 
				-- First Byte : all zero 
			elsif ( rChSel1(5)='1' and rArpOutAddr(0)='0' ) then 
				rDataOut( 7 downto 0 )	<= x"00";
				-- Second Byte : Reply 
			elsif ( rChSel1(5)='1' and OptionCode='1' ) then 
				rDataOut( 7 downto 0 )	<= cOPTIONCODE_Reply;
				-- Second Byte : Request 
			elsif ( rChSel1(5)='1' ) then 
				rDataOut( 7 downto 0 )	<= cOPTIONCODE_Request;
			-- Others 
			else 
				rDataOut( 7 downto 0 )	<= rArpRom(conv_integer(rArpOutAddr(2 downto 0)));
			end if;
		end if;
	End Process u_rDataOut;
	
	-- Output validation 
	u_rDataOutVal : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rDataOutVal	<= '0';
			else 
				rDataOutVal	<= rChSel1(0);
			end if;
		end if;
	End Process u_rDataOutVal;
	
	-- Output Sop 
	u_rDataOutSop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rDataOutSop	<= '0';
			else 
				if ( rChSel1(0)='1' and rDataOutVal='0' ) then 
					rDataOutSop	<= '1';
				else 
					rDataOutSop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rDataOutSop;
	
	-- Output Eop 
	u_rDataOutEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rDataOutEop	<= '0';
			else 
				if ( rChSel0(3)='0' and rChSel1(3)='1' ) then 
					rDataOutEop	<= '1';
				else 
					rDataOutEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rDataOutEop;

End Architecture rtl;