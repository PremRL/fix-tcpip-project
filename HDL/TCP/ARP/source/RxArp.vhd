----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     RxArp.vhd
-- Title        RxArp 
-- 
-- Author       L.Ratchanon
-- Date         2020/09/19
-- Syntax       VHDL
-- Description      
-- 
-- ARP Packet Decoder for 
-- Internet Protocol (IPv4) over Ethernet ARP packet.
--
-- Take necessary parameters such as SenderMACAddr, TargetMACAddr, SenderIpAddr,
-- TargetIpAddr to validate an ARP packet. So that Hardware Address of ours target
-- and Operation can be obtained.
--
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
-- Moreover, when OptionCode='1' is a Reply operation mode (OPER=2)
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

Entity RxArp Is
	Port 
	(
		MacRstB			: in	std_logic;
		RstB			: in	std_logic;
		RxMacClk		: in	std_logic;
		Clk				: in	std_logic; 
		
		-- RxMac Interface 
		DataIn			: in	std_logic_vector(7 downto 0);
		DataInValid		: in	std_logic;
		RxSOP			: in	std_logic;
		RxEOP			: in	std_logic;
		RxError			: in	std_logic_vector(1 downto 0);   
		
		-- ARP Processor Interface 
		SenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		SenderIpAddr	: in 	std_logic_vector(31 downto 0 );
		TargetIpAddr	: in 	std_logic_vector(31 downto 0 );
		
		RxTargetMACAddr	: out	std_logic_vector(47 downto 0 );
		RxArpOpCode		: out	std_logic;
		RxArpVal		: out	std_logic
	);
End Entity RxArp;	
	
Architecture rtl Of RxArp Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	-- For Detail : Notation
	constant cMACHEADER_ETHERTYPE	: std_logic_vector(15 downto 0 )	:= x"0806"; -- ARP 
	constant cARPFORMAT_HT_ENET		: std_logic_vector(15 downto 0 )	:= x"0001"; -- enet
	constant cARPFORMAT_PT_IPV4		: std_logic_vector(15 downto 0 )	:= x"0800"; -- ipv4
	constant cARPFORMAT_HS			: std_logic_vector( 7 downto 0 )	:= x"06";	-- 6 bytes
	constant cARPFORMAT_PS			: std_logic_vector( 7 downto 0 )	:= x"04";	-- 4 bytes

	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- MAC RxMacClk Domain Internal signal 
		-- FF Input (Mac)
	signal	rDataInFF			: std_logic_vector( 15 downto 0 );
	signal	rDataInValFF		: std_logic;
	signal  rDataInSopFF		: std_logic;
	signal  rDataInEopFF		: std_logic;

		-- Decoding (Mac)
	signal	rRxByteCnt			: std_logic_vector( 5 downto 0 );
	signal  rRxDecodeEn			: std_logic_vector( 3 downto 0 );
	signal	rRxSDMacAddr		: std_logic_vector(47 downto 0 );
	signal	rRxTGMacAddr		: std_logic_vector(47 downto 0 );
	signal	rRxSDIpAddr			: std_logic_vector(31 downto 0 );
	signal 	rRxTGIpAddr			: std_logic_vector(31 downto 0 );
	signal  rRxOptionCode 		: std_logic;
	
		-- Validation (Mac)
	signal  rRxEnetTypeVal		: std_logic_vector( 1 downto 0 );
	signal  rRxHardTypeVal		: std_logic_vector( 1 downto 0 );
	signal  rRxOperationVal		: std_logic_vector( 1 downto 0 );
	signal  rRxProtTypeVal		: std_logic;
	signal  rRxHlenVal			: std_logic;
	signal  rRxPlenVal			: std_logic;
	signal  rRxError			: std_logic;
	signal  rRxArpValid			: std_logic;
	
		-- MAC Clock domain validation To User Clock Domain
	signal	rDataValidALat		: std_logic_vector( 1 downto 0 );
	
	------------------------------------------------------------------------------
	-- Async validation : MAC RxMacClk Domain to User Domain Validation 
	signal	rDataValidBLat		: std_logic_vector( 2 downto 0 );
	signal  rDataValidBLatA		: std_logic_vector( 2 downto 0 );
	
	------------------------------------------------------------------------------
	-- User Clk Domain Internal signal 
		-- User Clock Domain validation From MAC Clock 
	signal  rUserDataValid		: std_logic_vector( 2 downto 0 );
	
		-- Addressing Data transfer from MAC Clock signal 
	signal	rUserSDMacAddr		: std_logic_vector(47 downto 0 );
	signal	rUserTGMacAddr		: std_logic_vector(47 downto 0 );
	signal	rUserSDIpAddr		: std_logic_vector(31 downto 0 );
	signal 	rUserTGIpAddr		: std_logic_vector(31 downto 0 );
	signal  rUserOptionCode 	: std_logic;
		
		-- Comparator 
	signal  rComTGMacAddr		: std_logic_vector(47 downto 0 );
	signal  rComTGIpAddr		: std_logic_vector(31 downto 0 );
	signal  rComSDIpAddr		: std_logic_vector(31 downto 0 );

		-- Validation
	signal 	rUserIpVal			: std_logic_vector( 1 downto 0 );
	signal  rUserSDMacVal		: std_logic_vector( 1 downto 0 );
	signal  rUserRxArpValid		: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- RxArp to ARP Processor
	RxTargetMACAddr(47 downto 0 )	<= rUserSDMacAddr(47 downto 0 );
	RxArpOpCode						<= rUserOptionCode;
	RxArpVal						<= rUserRxArpValid;
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

-----------------------------------------------------------
-- FF input 
	
	u_InputFF : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
		
			if ( MacRstB='0' ) then 
				rDataInValFF	<= '0';
			else 
				rDataInValFF	<= DataInValid;
			end if;
			
			-- FF validation Data 
			-- FF validation Data 
			if ( rDataInValFF='1' ) then 
				rDataInFF(15 downto 8 )	<= rDataInFF( 7 downto 0 );
			else 
				rDataInFF(15 downto 8 )	<= rDataInFF(15 downto 8 );
			end if;
			
			rDataInFF( 7 downto 0 )	<= DataIn( 7 downto 0 );
			rDataInSopFF			<= RxSOP;
			rDataInEopFF			<= RxEOP;
		end if;
	End Process u_InputFF;
	
-----------------------------------------------------------
-- Decoding Control signal  
	
	-- Byte counter
	u_rRxByteCnt : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( RxSOP='1' and DataInValid='1' ) then 
				rRxByteCnt( 5 downto 0 )	<= (others=>'0');
			elsif ( rDataInValFF='1' ) then 
				rRxByteCnt( 5 downto 0 )	<= rRxByteCnt( 5 downto 0 ) + 1;
			else 
				rRxByteCnt( 5 downto 0 )	<= rRxByteCnt( 5 downto 0 );
			end if;
		end if;
	End Process u_rRxByteCnt;
	
	-- Shifting signal for address decoder 
	u_rRxDecodeEn : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxDecodeEn( 3 downto 0 )	<= "0000";
			else 
				-- Target MAC Address 
				if ( RxSOP='1' and DataInValid='1' ) then 
					rRxDecodeEn(0)	<= '1';
				elsif ( rRxByteCnt=5 and rDataInValFF='1' ) then 
					rRxDecodeEn(0)	<= '0';
				else 
					rRxDecodeEn(0)	<= rRxDecodeEn(0);
				end if;
				
				-- Sender MAC Address 
				if ( rRxByteCnt=5 and rDataInValFF='1' ) then 
					rRxDecodeEn(1)	<= '1';
				elsif ( rRxByteCnt=11 and rDataInValFF='1' ) then 
					rRxDecodeEn(1)	<= '0';
				else 
					rRxDecodeEn(1)	<= rRxDecodeEn(1);
				end if;
				
				-- Sender IP Address 
				if ( rRxByteCnt=27 and rDataInValFF='1' and rRxOperationVal(1)='1' ) then 
					rRxDecodeEn(2)	<= '1';
				elsif ( rRxByteCnt=31 and rDataInValFF='1' ) then 
					rRxDecodeEn(2)	<= '0';
				else 
					rRxDecodeEn(2)	<= rRxDecodeEn(2);
				end if;
				
				-- Target IP Address 
				if ( rRxByteCnt=37 and rDataInValFF='1' and rRxOperationVal(1)='1' ) then 
					rRxDecodeEn(3)	<= '1';
				elsif ( rRxByteCnt=41 and rDataInValFF='1' ) then 
					rRxDecodeEn(3)	<= '0';
				else 
					rRxDecodeEn(3)	<= rRxDecodeEn(3);
				end if;
			end if;
		end if;
	End Process u_rRxDecodeEn;

-----------------------------------------------------------
-- Validation Flag
	
	-- Ethernet type validation (In Ethernet header frame) = x"0806" 
	u_rRxEnetTypeVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxEnetTypeVal( 1 downto 0 )	<= "00";
			else 
				-- Byte Position : 12 and 13 Validation
				if ( rRxByteCnt=13 and rDataInValFF='1'
					and rDataInFF(15 downto 0)=cMACHEADER_ETHERTYPE ) then 
					rRxEnetTypeVal(0)	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxEnetTypeVal(0)	<= '0';
				else 
					rRxEnetTypeVal(0)	<= rRxEnetTypeVal(0);
				end if;
				
				-- FF Ethernet Type validation 
				if ( rRxEnetTypeVal(0)='1' and rDataInValFF='1' ) then 
					rRxEnetTypeVal(1)	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxEnetTypeVal(1)	<= '0';
				else 
					rRxEnetTypeVal(1)	<= rRxEnetTypeVal(1);
				end if;
			end if;
		end if;
	End Process u_rRxEnetTypeVal;
	
	-- HTYPE Validation (ARP Packet) = 1 
	u_rRxHardTypeVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxHardTypeVal( 1 downto 0 )	<= "00";
			else 
				-- Byte Position : 15 for Validation
				if ( rRxEnetTypeVal(1)='1' and rDataInValFF='1' 
					and rDataInFF(15 downto 0)=cARPFORMAT_HT_ENET ) then 
					rRxHardTypeVal(0)	<= '1';
				elsif ( rDataInValFF='1' ) then
					rRxHardTypeVal(0)	<= '0';
				else 
					rRxHardTypeVal(0)	<= rRxHardTypeVal(0);
				end if;
				
				-- FF Hardware Type validation 
				if ( rRxHardTypeVal(0)='1' and rDataInValFF='1' ) then 
					rRxHardTypeVal(1)	<= '1';
				elsif ( rDataInValFF='1' ) then
					rRxHardTypeVal(1)	<= '0';
				else 
					rRxHardTypeVal(1)	<= rRxHardTypeVal(1);
				end if;
			end if;
		end if;
	End Process u_rRxHardTypeVal;
	
	-- PTYPE Validation (ARP Packet) = x"0800"
	u_rRxProtTypeVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 	
			if ( MacRstB='0' ) then 
				rRxProtTypeVal	<= '0';
			else 
				-- Byte Position : 17 for Validation
				if ( rRxHardTypeVal(1)='1' and rDataInValFF='1' 
					and rDataInFF(15 downto 0)=cARPFORMAT_PT_IPV4 ) then
					rRxProtTypeVal	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxProtTypeVal	<= '0';
				else 
					rRxProtTypeVal	<= rRxProtTypeVal;
				end if;
			end if;
		end if;
	End Process u_rRxProtTypeVal;
	
	-- HLEN Validation (ARP Packet) = 6 
	u_rRxHlenVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxHlenVal	<= '0';
			else 
				-- Byte Position : 18 for Validation
				if ( rRxProtTypeVal='1' and rDataInValFF='1' 
					and rDataInFF(7 downto 0)=cARPFORMAT_HS ) then 
					rRxHlenVal	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxHlenVal	<= '0';
				else 
					rRxHlenVal	<= rRxHlenVal;
				end if;
			end if;
		end if;
	End Process u_rRxHlenVal;
	
	-- PLEN Validation (ARP Packet) = 4
	u_rRxPlenVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxPlenVal	<= '0';
			else 
				-- Byte Position : 19 for Validation
				if ( rRxHlenVal='1' and rDataInValFF='1' 
					and rDataInFF(7 downto 0)=cARPFORMAT_PS ) then 
					rRxPlenVal	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxPlenVal	<= '0';
				else 
					rRxPlenVal	<= rRxPlenVal;
				end if;
			end if;
		end if;
	End Process u_rRxPlenVal;
	
	-- OptionCode :  1 for request, 2 for reply.
	-- Control signal for others 
	u_rRxOperationVal : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxOperationVal( 1 downto 0 )	<= "00";
			else 
				-- first byte =: Byte position : 20
				if ( rRxPlenVal='1' and rDataInValFF='1' 
					and rDataInFF(7 downto 0)=x"00" ) then 
					rRxOperationVal(0)	<= '1';
				elsif ( rDataInValFF='1' ) then 
					rRxOperationVal(0)	<= '0';
				else 
					rRxOperationVal(0)	<= rRxOperationVal(0);
				end if;
				
				-- Byte position : 21
				-- Validation OptionCode Must be 1 or 2 
				if ( rRxOperationVal(0)='1' and rDataInValFF='1' and (rDataInFF(7 downto 0)=x"01" 
					or rDataInFF(7 downto 0)=x"02") ) then 
					rRxOperationVal(1)	<= '1';
				-- Reset 
				elsif ( rDataInEopFF='1' and rDataInValFF='1' ) then 
					rRxOperationVal(1)	<= '0';
				else 
					rRxOperationVal(1)	<= rRxOperationVal(1);
				end if;
			end if;
		end if;
	End Process u_rRxOperationVal;
	
	-- RxENAC error (CRC or Header format error)
	u_rRxError : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxError	<= '0';
			else 
				-- Reset after Eop 
				if ( rDataInEopFF='1' and rDataInValFF='1' ) then 
					rRxError	<= '0';
				elsif ( RxError(0)='1' or RxError(1)='1' ) then 
					rRxError	<= '1';
				else 
					rRxError	<= rRxError;
				end if;
			end if;
		end if;
	End Process u_rRxError;
	
	-- ARP Packet validation
	u_rRxArpValid : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rRxArpValid	<= '0';
			else 
				-- ARP Validation 
				-- Last DataIn throgh Fkip-Flop and Length of data must valid (Byte count = 59) ARP + Zero padding 
				-- All control signal valid including error flags 
				if ( rDataInEopFF='1' and rDataInValFF='1' and rRxByteCnt=59
					and rRxOperationVal(1)='1' and rRxError='0' ) then 
					rRxArpValid	<= '1';
				else	
					rRxArpValid	<= '0';	
				end if;
			end if;
		end if;
	End Process u_rRxArpValid;
	
-----------------------------------------------------------
-- Sender and Target Addressing Data 
	
	u_rRxTGMacAddr : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( rDataInValFF='1' and rRxDecodeEn(0)='1') then 
 				rRxTGMacAddr(47 downto 0 )	<= rRxTGMacAddr(39 downto 0)&rDataInFF(7 downto 0);
			else 
				rRxTGMacAddr(47 downto 0 )	<= rRxTGMacAddr(47 downto 0 );
			end if;
		end if;
	End Process u_rRxTGMacAddr;
	
	u_rRxSDMacAddr : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( rDataInValFF='1' and rRxDecodeEn(1)='1') then 
 				rRxSDMacAddr(47 downto 0 )	<= rRxSDMacAddr(39 downto 0)&rDataInFF(7 downto 0);
			else 
				rRxSDMacAddr(47 downto 0 )	<= rRxSDMacAddr(47 downto 0 );
			end if;
		end if;
	End Process u_rRxSDMacAddr;
	
	u_rRxSDIpAddr : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( rDataInValFF='1' and rRxDecodeEn(2)='1') then 
 				rRxSDIpAddr(31 downto 0 )	<= rRxSDIpAddr(23 downto 0)&rDataInFF(7 downto 0);
			else 
				rRxSDIpAddr(31 downto 0 )	<= rRxSDIpAddr(31 downto 0 );
			end if;
		end if;
	End Process u_rRxSDIpAddr;
	
	u_rRxTGIpAddr : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( rDataInValFF='1' and rRxDecodeEn(3)='1') then 
 				rRxTGIpAddr(31 downto 0 )	<= rRxTGIpAddr(23 downto 0)&rDataInFF(7 downto 0);
			else 
				rRxTGIpAddr(31 downto 0 )	<= rRxTGIpAddr(31 downto 0 );
			end if;
		end if;
	End Process u_rRxTGIpAddr;
	
	u_rRxOptionCode : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then
			-- Reply Operation 
			if ( rRxOperationVal(0)='1' and rDataInValFF='1' and rDataInFF(7 downto 0)=x"02" ) then 
				rRxOptionCode	<= '1';
			-- Request Operation 
			elsif ( rRxOperationVal(0)='1' and rDataInValFF='1' ) then 
				rRxOptionCode	<= '0';
			else 
				rRxOptionCode	<= rRxOptionCode;
			end if;
		end if;
	End Process u_rRxOptionCode;
	
-----------------------------------------------------------
-- Asynchronous Data Treansfer
-- Let A : RxMACClk Domain and B : UserClk Domain 

	u_rDataValidA : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rDataValidALat( 1 downto 0 ) <= "00";
			else 
				rDataValidALat(1)	<= rDataValidALat(0);
				-- ARP Packet Valid 
				if ( rRxArpValid='1' ) then 
					rDataValidALat(0)	<= '1';
				-- Data has transferred to User 
				elsif ( rDataValidBLatA( 2 downto 1 )="01" ) then 
					rDataValidALat(0)	<= '0';
				else 
					rDataValidALat(0)	<= rDataValidALat(0);
				end if;
			end if;
		end if;
	End Process u_rDataValidA;
	
	u_rDataValidBLatA : Process (RxMacClk) Is 
	Begin 
		if ( rising_edge(RxMacClk) ) then 
			if ( MacRstB='0' ) then 
				rDataValidBLatA( 2 downto 0 )	<= (others=>'0');
			else
				-- Async register : Used rDataValidALat(2)
				rDataValidBLatA(0)	<= rDataValidBLat(2);
				-- Add one more Flip-Flop before usage for async signal 
				rDataValidBLatA(1)	<= rDataValidBLatA(0);
				-- To detect rising edge of rDataValidALat
				rDataValidBLatA(2)	<= rDataValidBLatA(1);
			end if;
		end if;
	End Process u_rDataValidBLatA;
	
	u_rDataValidB : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rDataValidBLat( 2 downto 0 )	<= (others=>'0');
			else 
				-- Async register : Used rDataValidALat(1)
				rDataValidBLat(0)	<= rDataValidALat(1);
				-- Add one more Flip-Flop before usage for async signal 
				rDataValidBLat(1)	<= rDataValidBLat(0);
				-- To detect rising edge of rDataValidALat
				rDataValidBLat(2)	<= rDataValidBLat(1);
			end if;
		end if;
	End Process u_rDataValidB;
	
	-- Data Transferred to User Clock Domain 
	u_rDataBLat : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Validation
			if ( RstB='0' ) then 
				rUserDataValid( 2 downto 0 )	<= (others=>'0');
			else 
				rUserDataValid(2)	<= rUserDataValid(1);
				rUserDataValid(1)	<= rUserDataValid(0);
				-- Detect rising edge 
				if ( rDataValidBLat(2 downto 1)="01" ) then 
					rUserDataValid(0)	<= '1';				
				else 
					rUserDataValid(0)	<= '0';				
				end if;	
			end if;
			
			-- Data Path : Detect rising edge 
			if ( rDataValidBLat(2 downto 1)="01" ) then 
				rUserSDMacAddr(47 downto 0 )	<= rRxSDMacAddr(47 downto 0 );
				rUserTGMacAddr(47 downto 0 )	<= rRxTGMacAddr(47 downto 0 );
				rUserSDIpAddr(31 downto 0 )		<= rRxSDIpAddr(31 downto 0 );	
				rUserTGIpAddr(31 downto 0 )		<= rRxTGIpAddr(31 downto 0 );	
				rUserOptionCode 				<= rRxOptionCode; 					
			else 
				rUserSDMacAddr(47 downto 0 )	<= rUserSDMacAddr(47 downto 0 );
				rUserTGMacAddr(47 downto 0 )	<= rUserTGMacAddr(47 downto 0 );
				rUserSDIpAddr(31 downto 0 )		<= rUserSDIpAddr(31 downto 0 );	
				rUserTGIpAddr(31 downto 0 )		<= rUserTGIpAddr(31 downto 0 );	
				rUserOptionCode 				<= rUserOptionCode; 					
			end if;	
		end if;
	End Process u_rDataBLat;
	
-----------------------------------------------------------
-- Comparator 
	
	u_rComparator : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Target MAC Address Receiving must equal to our MAC Address 
			rComTGMacAddr(47 downto 0 )	<= rUserTGMacAddr(47 downto 0 ) - SenderMACAddr(47 downto 0 );
			-- Target IP Address Receiving must equal to our IP Address 
			rComTGIpAddr(31 downto 0 )	<= rUserTGIpAddr(31 downto 0 ) - SenderIpAddr(31 downto 0 );
			-- Sender IP Address Receiving must equal to our target IP Address 
			rComSDIpAddr(31 downto 0 )	<= rUserSDIpAddr(31 downto 0 ) - TargetIpAddr(31 downto 0 );
		end if;
	End Process u_rComparator;
	

-----------------------------------------------------------
-- User Clock Domain 
-- Filtering Packet 
	
	-- IP Validation 
	-- Bit 0	=> Sender IP Address Receiving checking
	-- Bit 1	=> Target IP Address Receiving checking
	u_rUserIpVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Sender IP Address Receiving must equal to our target IP Address 
			if ( rUserDataValid(1)='1' and rComSDIpAddr=0 ) then 
				rUserIpVal(0)	<= '1';
			else
				rUserIpVal(0)	<= '0';
			end if;
			
			-- Target IP Address Receiving must equal to our IP Address 
			if ( rUserDataValid(1)='1' and rComTGIpAddr=0 ) then 
				rUserIpVal(1)	<= '1';
			else
				rUserIpVal(1)	<= '0';
			end if;
		end if;
	End Process u_rUserIpVal;
	
	-- Note that : 
	-- Reply Operation ARP 	=> rUserOptionCode='1'
	-- Request Operation ARP	=> rUserOptionCode='0'
	u_rUserSDMacVal : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Target MAC Address Receiving must equal to our target MAC Address when rUserOptionCode='1' 
			if ( rUserDataValid(1)='1' and rUserOptionCode='1' and rComTGMacAddr=0 ) then 
				rUserSDMacVal(0)	<= '1';
			else 
				rUserSDMacVal(0)	<= '0';
			end if;
			
			-- Broadcast when rUserOptionCode='0' 
			if ( rUserDataValid(1)='1' and rUserOptionCode='0'
				and rUserTGMacAddr(47 downto 0)=x"FFFFFFFFFFFF" ) then 
				rUserSDMacVal(1)	<= '1';
			else 
				rUserSDMacVal(1)	<= '0';
			end if;
		end if;
	End Process u_rUserSDMacVal;

-----------------------------------------------------------
-- Output Generator 
	
	-- Valid to Arp Processor 
	u_rUserRxArpValid : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rUserRxArpValid	<= '0';
			else 
				if ( rUserDataValid(2)='1' and (rUserSDMacVal(0)='1' or rUserSDMacVal(1)='1')
					and rUserIpVal(1 downto 0)="11" ) then 
					rUserRxArpValid	<= '1';
				else 
					rUserRxArpValid	<= '0';
				end if;
			end if;
		end if;
	End Process u_rUserRxArpValid;
	
End Architecture rtl;