----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxOutCtrl.vhd
-- Title        Output controller for TCP/IP Tx 
-- 
-- Version	 	0.02
-- Author     	L.Ratchanon
-- Date        	2020/10/23
-- Syntax      	VHDL
-- Description	Add control signal for queue signaling 
--
-- Version	 	0.01
-- Author      	L.Ratchanon
-- Date        	2020/09/11
-- Syntax      	VHDL
-- Description	New Creation   
-- 
-- TCP/IP Output DataPath and Control signal Module  
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

Entity TxOutCtrl Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
		
		-- TCP/IP Processor Unit interface  
			-- MAC Header
		MACSouAddr		: in	std_logic_vector(47 downto 0 );
		MACDesAddr		: in 	std_logic_vector(47 downto 0 );
			-- IPv4 Header 
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
			-- Control I/F
		TxPayloadEn		: in	std_logic;
		TxReq			: in	std_logic;
		TxBusy 			: out 	std_logic;
		
		-- Queuing&ChecksSumCal Interface 
		DataLen			: in 	std_logic_vector(15 downto 0 );
		CheckSumCalData	: in 	std_logic_vector(15 downto 0 );
		CheckSumCalEnd	: in	std_logic;
		
		-- IP Header Interface		
		RamIPHdRdData	: in	std_logic_vector( 7 downto 0 );
		RamIPHdRdAddr	: out	std_logic_vector( 5 downto 0 );
		IPSouAddrGen	: out 	std_logic_vector(31 downto 0 );		
		IPDesAddrGen	: out 	std_logic_vector(31 downto 0 );
		
		-- TCP Header Interface		
		SouPortGen		: out 	std_logic_vector(15 downto 0 );	
		DesPortGen		: out 	std_logic_vector(15 downto 0 );
	    SeqNumGen		: out 	std_logic_vector(31 downto 0 );	
		AckNumGen		: out 	std_logic_vector(31 downto 0 );
		DataOffsetGen	: out 	std_logic_vector( 3 downto 0 );
		FlagsGen		: out 	std_logic_vector( 8 downto 0 );
		WindowGen		: out 	std_logic_vector(15 downto 0 );
		UrgentGen		: out 	std_logic_vector(15 downto 0 );
		DataChecksum	: out 	std_logic_vector(15 downto 0 );
	
		RamTCPHdRdData	: in 	std_logic_vector( 7 downto 0 );
		RamTCPHdRdAddr	: out	std_logic_vector( 5 downto 0 );
		
		-- Payload Memory Interface	
		RamLoadRdData	: in 	std_logic_vector( 7 downto 0 );
		RamLoadRdAddr	: out 	std_logic_vector(13 downto 0 );
		
		-- Control Interface 
		CtrlDataLen		: out 	std_logic_vector(15 downto 0 );
		CtrlStart		: out	std_logic;
		CtrlPayloadEn	: out	std_logic;
		
		-- EMAC Interface	
		EMACReady		: in	std_logic;
		
		EMACReq			: out 	std_logic;
		EMACDataOut		: out	std_logic_vector(7 downto 0);
		EMACDataOutVal	: out	std_logic;
		EMACDataOutSop	: out	std_logic;
		EMACDataOutEop	: out	std_logic
	);
End Entity TxOutCtrl;	
	
Architecture rtl Of TxOutCtrl Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	-- 0800 : IPv4
	constant cMAC_EthernetType	: std_logic_vector(15 downto 0 ) := x"0800";
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- Ethernet MAC header 
	signal rDataMAC				: std_logic_vector( 7 downto 0 );
	signal rDataMACCnt			: std_logic_vector( 3 downto 0 );
	
	-- IP Header I/F 
	signal rRamIPHdRdAddr		: std_logic_vector( 5 downto 0 );
	
	-- TCP Header I/F 
	signal rSeqNumGen0			: std_logic_vector(31 downto 0 );	
	signal rFlagsGen0			: std_logic_vector( 8 downto 0 );
	signal rSeqNumGen1			: std_logic_vector(31 downto 0 );
	signal rAckNumGen1			: std_logic_vector(31 downto 0 );
	signal rFlagsGen1			: std_logic_vector( 8 downto 0 );
	
	signal rRamTCPHdRdAddr		: std_logic_vector( 5 downto 0 );
	
	-- Payload I/F
	signal rDataLen				: std_logic_vector(15 downto 0 );
	signal rRamLoadRdAddr		: std_logic_vector(13 downto 0 );
	signal rCheckSumCalEndLat	: std_logic;
	
	-- Control I/F
	signal rTxOutStart 			: std_logic;
	signal rRdPayloadEn			: std_logic;
	signal rCheckSumWait		: std_logic;
	signal rTxAckReq			: std_logic;
	signal rTxBusy				: std_logic;
	signal rTxOutBusy			: std_logic;
	signal rTxOutBusyFF			: std_logic; 
	
	-- Output signal 
	signal rChSel0				: std_logic_vector( 3 downto 0 );
	signal rChSel1				: std_logic_vector( 3 downto 0 );
	
	signal rDataOut				: std_logic_vector( 7 downto 0 );
	signal rDataOutVal		    : std_logic;
	signal rDataOutSop		    : std_logic;
	signal rDataOutEop		    : std_logic;
	signal rEMACReq				: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- TCP/IP/Payload Control I/F
	IPSouAddrGen(31 downto 0 )	<= IPSouAddr(31 downto 0 );			
	IPDesAddrGen(31 downto 0 )  <= IPDesAddr(31 downto 0 );
	SouPortGen(15 downto 0 )    <= SouPort(15 downto 0 );  
	DesPortGen(15 downto 0 )    <= DesPort(15 downto 0 );  
	
	SeqNumGen(31 downto 0 )		<= rSeqNumGen1(31 downto 0 );			
	AckNumGen(31 downto 0 )		<= rAckNumGen1(31 downto 0 );		
	DataOffsetGen( 3 downto 0 )	<= DataOffset( 3 downto 0 );	
	FlagsGen( 8 downto 0 )		<= rFlagsGen1( 8 downto 0 );		
	WindowGen(15 downto 0 )		<= Window(15 downto 0 );	
	UrgentGen(15 downto 0 )		<= Urgent(15 downto 0 );
	DataCheckSum(15 downto 0 )	<= CheckSumCalData(15 downto 0 );
	
	CtrlDataLen(15 downto 0 )	<= DataLen(15 downto 0 );
	CtrlStart 					<= rTxOutStart;
	CtrlPayloadEn				<= rRdPayloadEn;
	
	-- Memory interface For TCP - IP - Payload 
	RamIPHdRdAddr( 5 downto 0 )	<= rRamIPHdRdAddr( 5 downto 0 );
	RamTCPHdRdAddr( 5 downto 0 )<= rRamTCPHdRdAddr( 5 downto 0 );
	RamLoadRdAddr(13 downto 0 )	<= rRamLoadRdAddr(13 downto 0 );
	
	-- Output To EMAC  
	EMACReq						<= rEMACReq;
	
	EMACDataOut( 7 downto 0 )	<= rDataOut( 7 downto 0 );		
	EMACDataOutVal            	<= rDataOutVal;           
	EMACDataOutSop            	<= rDataOutSop;           
	EMACDataOutEop            	<= rDataOutEop;          
	
	-- TPU I/F   
	TxBusy						<= rTxBusy;	
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------	
-----------------------------------------------------------
-- Tx TCP/IP Control Interface 

	-- rEMACReq for sending packet to EMAC
	-- Extecting EMACReady is set to transfer data to EMAC 
	u_rEMACReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rEMACReq	<= '0';
			else
				-- Send data to EMAC 
				if ( EMACReady='1' ) then 
					rEMACReq	<= '0';
				-- Requesting to send data to EMAC 
					-- No Payload Request (TCP data)  
				elsif ( (TxReq='1' and TxPayloadEn='0' and rTxBusy='0') 
					-- Payload Request : Wait for end of checksum 
					or ( (CheckSumCalEnd='1' or rCheckSumCalEndLat='1')
					and rCheckSumWait='1' and rTxOutBusy='0') 
					-- ACK Packet 
					or (rTxAckReq='1' and rTxOutBusy='0' 
					and rRdPayloadEn='0' and rCheckSumWait='0') ) then 
					rEMACReq	<= '1';
				else 
					rEMACReq	<= rEMACReq;
				end if;
			end if;
		end if;
	End Process u_rEMACReq;
	
	-- Start signal (Sending data to EMAC)
	-- rTxOutStart is control signal which is controling TCPHdGen module and
	-- IPHdGen to generate header and starting to transfer data to EMAC 
	u_rTxOutStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxOutStart	<= '0';
			else 
				-- EMAC give permission to send data 
				if ( rEMACReq='1' and EMACReady='1' ) then 
					rTxOutStart	<= '1';
				else 
					rTxOutStart	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTxOutStart;
	
	-- Wait for calculating checksum 
	-- TPU requests for sending data with upperlayer payload 
	-- this signal is set for waiting for checksum calculation
	u_rCheckSumWait : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCheckSumWait	<= '0';
			else 
				-- Request to send data with payload 
				if ( TxReq='1' and TxPayloadEn='1' ) then 
					rCheckSumWait	<= '1';
				-- Reset : Control signal rTxOutStart has been set 
				elsif ( (CheckSumCalEnd='1' or rCheckSumCalEndLat='1')
					and rTxOutBusy='0' ) then 
					rCheckSumWait	<= '0';
				else 
					rCheckSumWait	<= rCheckSumWait;
				end if;
			end if;
		end if;
	End Process u_rCheckSumWait;
	
	-- Latch rCheckSumCalEnd
	-- This signal latching for acknowledgement that CheckSumCal
	-- has already calculated checksum. In case of TxOutCtrl is 
	-- not ready for transfering data. 
	u_rCheckSumCalEndLat : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCheckSumCalEndLat	<= '0';
			else 
				-- Reset : When TxOutCtrl is ready for transfering data 
				if ( rTxOutBusy='0' ) then 
					rCheckSumCalEndLat	<= '0';
				-- Set : When CheckSumCal has already calculated checksum 
				elsif ( CheckSumCalEnd='1' ) then 
					rCheckSumCalEndLat	<= '1';
				else 
					rCheckSumCalEndLat	<= rCheckSumCalEndLat;
				end if;
			end if;
		end if;
	End Process u_rCheckSumCalEndLat;
	
	-- ACK packet update  
	u_rTxAckReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxAckReq	<= '0';
			else 
				if ( rTxOutBusyFF='0' and rTxBusy='1' ) then 
					rTxAckReq	<= '0';
				-- Only ACK was set 
				elsif ( TxReq='1' and TxPayloadEn='0' and Flags(8 downto 0)="000010000") then 
					rTxAckReq	<= '1';
				else 
					rTxAckReq	<= rTxAckReq; 
				end if;
			end if;
		end if;
	End Process u_rTxAckReq;
	
	-- Data transfering flag (TxOutCtrl is not ready for transfering data)
	u_rTxOutBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then  
			if ( RstB='0' ) then 
				rTxOutBusy		<= '0';
				rTxOutBusyFF	<= '0';
			else 
				rTxOutBusyFF	<= rTxOutBusy;
				-- Reset : Already sent data 
				if ( rDataOutEop='1' ) then 
					rTxOutBusy	<= '0';
				-- Set : Starting to send data 
				elsif ( rEMACReq='1' and EMACReady='1' ) then 
					rTxOutBusy	<= '1';
				else 
					rTxOutBusy	<= rTxOutBusy;
				end if;
			end if;
		end if;
	End Process u_rTxOutBusy;

	-- Busy signal for Requesting (TxOutCtrl Busy flag)
	u_rTxBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then  
			if ( RstB='0' ) then 
				rTxBusy	<= '0';
			else 
				-- Set : Request to send data 
				if ( TxReq='1' or rTxAckReq='1' ) then 
					rTxBusy	<= '1';
				-- Reset : Last byte has been transferred and not in state of wait-for-checksum 
				elsif ( rDataOutEop='1' and rCheckSumWait='0' ) then 
					rTxBusy	<= '0';
				else 
					rTxBusy	<= rTxBusy;
				end if;
			end if;
		end if;
	End Process u_rTxBusy;
	
	-- Enable to read payload 
	u_rRdPayloadEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRdPayloadEn	<= '0';
			else 
				-- Enable to read data from RamData
				if ( rCheckSumWait='1' and rTxOutBusy='0'
					and (CheckSumCalEnd='1' or rCheckSumCalEndLat='1') ) then 
					rRdPayloadEn	<= '1';
				-- Reset when last byte has been transferred 
				elsif ( rDataOutEop='1' ) then 
					rRdPayloadEn	<= '0';
				else 
					rRdPayloadEn	<= rRdPayloadEn;
				end if;
			end if;
		end if;
	End Process u_rRdPayloadEn;
	
	-- TCP Header generating Ctrl 
	u_TCPControl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			-- Latching Input control signal 
			if ( TxReq='1' and (rTxBusy='0' or (rTxOutBusy='1' and rCheckSumWait='0')) ) then 
				rSeqNumGen0(31 downto 0 )		<= SeqNum(31 downto 0 );
				rFlagsGen0( 8 downto 0 )		<= Flags( 8 downto 0 );
			else 
				rSeqNumGen0(31 downto 0 )		<= rSeqNumGen0(31 downto 0 );				
				rFlagsGen0( 8 downto 0 )		<= rFlagsGen0( 8 downto 0 );			
			end if;
			
			-- Using These signals as an input for generating
			if ( rEMACReq='1' and EMACReady='1' ) then 
				rSeqNumGen1(31 downto 0 )		<= rSeqNumGen0(31 downto 0 );
				rAckNumGen1(31 downto 0 )		<= AckNum(31 downto 0 );
				rFlagsGen1( 8 downto 0 )		<= rFlagsGen0( 8 downto 0 );
			else 
				rSeqNumGen1(31 downto 0 )		<= rSeqNumGen1(31 downto 0 );	
				rAckNumGen1(31 downto 0 )		<= rAckNumGen1(31 downto 0 );
				rFlagsGen1( 8 downto 0 )		<= rFlagsGen1( 8 downto 0 );				
			end if;
		end if;
	End Process u_TCPControl;

-----------------------------------------------------------
-- Output control signal 
	
	-- Channel selection 
	-- "0000"	=> Idle 
	-- "0001"	=> MAC Header 
	-- "0010"	=> IP Header 
	-- "0100"	=> TCP Header 
	-- "1000"	=> Payload 
	-- Using FF signal for Output control siugnal generating 
	u_rChSel : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rChSel1( 3 downto 0 )	<= "0000";
				rChSel0( 3 downto 0 )	<= "0000";
			else
				rChSel1( 3 downto 0 )	<= rChSel0( 3 downto 0 );
				-- Sending MAC Header 
				if ( rEMACReq='1' and EMACReady='1' ) then 
					rChSel0(0)	<= '1';	
				-- Last byte of MAC Header (14 byte)
				elsif ( rDataMACCnt=13 ) then 
					rChSel0(0)	<= '0';
				else 
					rChSel0(0)	<= rChSel0(0);
				end if;
				
				-- Sending IP Header 
				if ( rChSel0(0)='1' and rDataMACCnt=13 ) then 
					rChSel0(1)	<= '1';
				-- Last byte of IP Header (20 byte : No option)
				elsif ( rRamIPHdRdAddr=19 ) then 
					rChSel0(1)	<= '0';
				else 
					rChSel0(1)	<= rChSel0(1);
				end if;
				
				-- Sending TCP Header 
				if ( rChSel0(1)='1' and rRamIPHdRdAddr=19 ) then 
					rChSel0(2)	<= '1';
				-- Last byte of TCP Header (TCP option MSS supported)
				elsif ( ((rRamTCPHdRdAddr=19 and rFlagsGen1(1)='0')
					or rRamTCPHdRdAddr=23) ) then 
					rChSel0(2)	<= '0';
				else 
					rChSel0(2)	<= rChSel0(2);
				end if;
				
				-- Sending Payload (If PayloadEn='1')
				if ( rChSel0(2)='1' and rRamTCPHdRdAddr=19 
					and rRdPayloadEn='1' ) then 
					rChSel0(3)	<= '1';
				-- Last byte of Payload
				elsif ( rDataLen=1 ) then 
					rChSel0(3)	<= '0';
				else 
					rChSel0(3)	<= rChSel0(3);
				end if;
			end if;
		end if;
	End Process u_rChSel;
	
	-- MAC header 
	u_rDataMAC : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			case ( rDataMACCnt ) is 
				when "0000"	=> rDataMAC <= MACDesAddr(47 downto 40);
				when "0001"	=> rDataMAC <= MACDesAddr(39 downto 32);
				when "0010"	=> rDataMAC <= MACDesAddr(31 downto 24);
				when "0011"	=> rDataMAC <= MACDesAddr(23 downto 16);
				when "0100"	=> rDataMAC <= MACDesAddr(15 downto 8 );
				when "0101"	=> rDataMAC <= MACDesAddr( 7 downto 0 );
				when "0110"	=> rDataMAC <= MACSouAddr(47 downto 40);
				when "0111"	=> rDataMAC <= MACSouAddr(39 downto 32);
				when "1000"	=> rDataMAC <= MACSouAddr(31 downto 24);
				when "1001"	=> rDataMAC <= MACSouAddr(23 downto 16);
				when "1010"	=> rDataMAC <= MACSouAddr(15 downto 8 );
				when "1011"	=> rDataMAC <= MACSouAddr( 7 downto 0 );
				when "1100"	=> rDataMAC <= cMAC_EthernetType(15 downto 8 );
				when others	=> rDataMAC <= cMAC_EthernetType( 7 downto 0 );
			end case;
		end if;
	End Process u_rDataMAC;
	
	-- MAC Header counter : 0 - 13
	u_rDataMACCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( (rEMACReq='1' and EMACReady='1') 
				or rChSel0(0)='1' ) then
				rDataMACCnt( 3 downto 0 )	<= rDataMACCnt( 3 downto 0 ) + 1;
			else 
				rDataMACCnt( 3 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rDataMACCnt;
	
	-- IP header Memory Addressing 
	u_rRamIPHdRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rChSel0(1)='1' ) then 
				rRamIPHdRdAddr( 5 downto 0 )	<= rRamIPHdRdAddr( 5 downto 0 ) + 1;
			else 
				rRamIPHdRdAddr( 5 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rRamIPHdRdAddr;
	
	-- TCP Header Memory Addressing 
	u_rRamTCPHdRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rChSel0(2)='1' ) then 
				rRamTCPHdRdAddr( 5 downto 0 )	<= rRamTCPHdRdAddr( 5 downto 0 ) + 1;
			else 
				rRamTCPHdRdAddr( 5 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rRamTCPHdRdAddr;
	
	-- Payload Memory Addressing 
	u_rRamLoadRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamLoadRdAddr(13 downto 0 )	<= (others=>'0');
			else 
				if ( rChSel0(3)='1' ) then 
					rRamLoadRdAddr(13 downto 0 )	<= rRamLoadRdAddr(13 downto 0 ) + 1;
				else 
					rRamLoadRdAddr(13 downto 0 )	<= rRamLoadRdAddr(13 downto 0 ); 
				end if;
			end if;
		end if;
	End Process u_rRamLoadRdAddr;
	
	-- Payload length 
	u_rDataLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Starting to send data 
			if ( rTxOutStart='1' ) then 
				rDataLen(15 downto 0 )	<= DataLen(15 downto 0 );
			-- Transfering data
			elsif ( rChSel0(3)='1' ) then 	
				rDataLen(15 downto 0 )	<= rDataLen(15 downto 0 ) - 1;
			else 
				rDataLen(15 downto 0 )	<= rDataLen(15 downto 0 );
			end if;
		end if;
	End Process u_rDataLen;
	
-----------------------------------------------------------
-- Output Generator 
	
	-- DataPath for Output
	-- "0001"	=> MAC Header 
	-- "0010"	=> IP Header 
	-- "0100"	=> TCP Header 
	-- "1000"	=> Payload 
	u_rDataOut : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Payload 
			if ( rChSel1(3)='1' ) then 
				rDataOut( 7 downto 0 )	<= RamLoadRdData( 7 downto 0 );
			-- TCP Header 
			elsif ( rChSel1(2)='1' ) then 
				rDataOut( 7 downto 0 )	<= RamTCPHdRdData( 7 downto 0 );
			-- IP Header 
			elsif ( rChSel1(1)='1' ) then 
				rDataOut( 7 downto 0 )	<= RamIPHdRdData( 7 downto 0 );
			-- MAC Header 
			else 
				rDataOut( 7 downto 0 )	<= rDataMAC( 7 downto 0 );
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
				if ( rChSel1(3 downto 0)/="0000" or rChSel0(0)='1' ) then 
					rDataOutVal	<= '1';
				else 
					rDataOutVal	<= '0';
				end if;
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
				if ( rChSel1(0)='0' and rChSel0(0)='1' ) then 
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
				-- 2 possible way : 
				-- 1) No Payload	=> TCP Header Last Byte 
				-- 2) With Payload	=> Payload Last Byte
				if ( (rRdPayloadEn='0' and rChSel0(2)='0' and rChSel1(2)='1' ) 
					or (rChSel0(3)='0' and rChSel1(3)='1') ) then 
					rDataOutEop	<= '1';
				else 
					rDataOutEop	<= '0';	
				end if;
			end if;
		end if;
	End Process u_rDataOutEop;

End Architecture rtl;