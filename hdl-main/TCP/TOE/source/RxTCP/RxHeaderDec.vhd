----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		RxHeaderDec.vhd
-- Title		
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         

-- Version      1.00
-- Author       K.Norawit
-- Date         2020/11/04
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--	Comment below is FYI note
--	1. 
--	   
--	2.	
--	3.	
--	4.	
--	5.	
--	6.	
--	7.		
--	8.	
--		
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxHeaderDec Is
Port
(
	RstB					: in	std_logic;
	Clk						: in	std_logic; 
	
	--	Input from RxMAC and TPU
	MacSOP					: in	std_logic;
	MacValid				: in	std_logic;
	MacEOP					: in	std_logic;
	MacData					: in	std_logic_vector( 7 downto 0 );
	MacError				: in	std_logic_vector( 1 downto 0 );
	DecodeEn				: in	std_logic;
	InitEn					: in	std_logic;
	ExpSeqNum				: in	std_logic_vector( 31 downto 0 );
	
	-- Input from User for IP and Port checking
	UserValid				: in	std_logic;
	UserSrcMac				: in	std_logic_vector( 47 downto 0 );
	UserDesMac				: in	std_logic_vector( 47 downto 0 );
	UserSrcIP				: in	std_logic_vector( 31 downto 0 );
	UserDesIP				: in	std_logic_vector( 31 downto 0 );
	UserSrcPort             : in	std_logic_vector( 15 downto 0 );
	UserDesPort             : in	std_logic_vector( 15 downto 0 );
	
	-- Validation and error flag for (error) condition checking
	MacAddrValid			: out	std_logic_vector( 1 downto 0 );
	IPVerValid				: out	std_logic;
	ProtocolValid			: out	std_logic;
	SrcIPValid				: out	std_logic;
	DesIPValid				: out	std_logic;
	SrcPortValid			: out	std_logic;
	DesPortValid			: out	std_logic;
	CheckSumValid			: out	std_logic_vector( 1 downto 0 );
	MacErrorFlag			: out	std_logic_vector( 1 downto 0 );
	SeqNumError				: out	std_logic;
	
	-- DataCtrl I/F
	WinUpReq				: out	std_logic;
	
	--	Decoded fields and Valid from TCP header to TPU
	PktValid				: out	std_logic;
	TCPSeqNum				: out	std_logic_vector( 31 downto 0 );
	TCPAck					: out	std_logic_vector( 31 downto 0 );
	TCPAckFlag				: out	std_logic;
	TCPPshFlag				: out	std_logic;
	TCPRstFlag				: out	std_logic;
	TCPSynFlag				: out	std_logic;
	TCPFinFlag				: out	std_logic;
	TCPWinSize				: out	std_logic_vector( 15 downto 0 );
	PayloadLen				: out	std_logic_vector( 15 downto 0 );
	
	-- Queue Writing I/F
	QWrFull					: in	std_logic;
	QCnt					: in	std_logic_vector( 7 downto 0 );	-- no use
	QWrReq					: out	std_logic;
	QWrData					: out	std_logic_vector( 16 downto 0 );
	
	-- Payload Writing I/F
	PLRamWrData				: out	std_logic_vector( 7 downto 0 );
	PLRamWrEn				: out	std_logic;
	PLRamWrAddr				: out	std_logic_vector( 15 downto 0 )
	
);
End Entity RxHeaderDec;

Architecture rt1 Of RxHeaderDec Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant	cIPv4					: integer	:= 4;
	constant	cIPv4Type				: std_logic_vector( 15 downto 0 )	:= x"0800";
	constant	cTCP					: integer	:= 6;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	type SerStateType is
					(
						--	to extract head-field of the message 
						stIdle				,
						stEthFrame			,
						stIPHeader			,
						stTCP				,
						stWaitCSum			,
						stCSumFin			,
						stConCheck			,
						stSendQCtrl		
					);
	
	signal 	rState				: SerStateType						;
	signal	rDecodeEnLat		: std_logic							;
	signal	rPrePktValid		: std_logic							;
	signal	rPktValid			: std_logic							;
	signal	rValDelayCnt		: std_logic_vector( 1 downto 0 )	;
	signal	rWinUpReq			: std_logic							;
	
	--	Add flip flop for Input from RxMAC
	signal	rMacSOP				: std_logic							;
	signal	rMacValid			: std_logic							;
	signal	rMacEOP				: std_logic							;
	signal	rMacData			: std_logic_vector( 7 downto 0 )	;
	signal	rMacData1			: std_logic_vector( 7 downto 0 )	;
	signal	rMacError			: std_logic_vector( 1 downto 0 )	;
	
	-- Error flag
	signal	rMacAddrValid	    : std_logic_vector( 1 downto 0 )	;
	signal	rIPVerValid			: std_logic							;
	signal	rProtocolValid	    : std_logic							;
	signal	rSrcIPValid		    : std_logic							;
	signal	rDesIPValid		    : std_logic							;
	signal	rSrcPortValid	    : std_logic							;
	signal	rDesPortValid	    : std_logic							;
	signal	rIPCheckSumValid	: std_logic							;
	signal	rTCPCheckSumValid	: std_logic							;
	signal	rMacErrorFlag	    : std_logic_vector( 1 downto 0 )	;
	signal	rSeqNumError		: std_logic							;
	signal	rSeqNumErrorDelay	: std_logic							;
	
	-- Ethernet Frame
	signal	rEthCnt				: std_logic_vector( 3 downto 0 )	;
	signal	rMacAddr			: std_logic_vector( 47 downto 0 )	;
	signal	rEthType			: std_logic_vector( 15 downto 0 )	;
	
	-- IP header
	signal	rIHL				: std_logic_vector( 3 downto 0 )	;
	signal	rTotalLen			: std_logic_vector( 15 downto 0 )	;
	signal	rSrcIP				: std_logic_vector( 31 downto 0 )	;
	signal	rDesIP				: std_logic_vector( 31 downto 0 )	;
	
	signal	rIPHeadCnt			: std_logic_vector( 5 downto 0 )	;
	signal	rIPCheckSum			: std_logic_vector( 16 downto 0 )	;
	
	-- TCP header
	signal	rTCPCnt				: std_logic_vector( 15 downto 0 )	;
	signal	rTCPLen				: std_logic_vector( 15 downto 0 )	;
	signal	rPayloadLen			: std_logic_vector( 15 downto 0 )	;
	
	signal	rSrcPort			: std_logic_vector( 15 downto 0 )	;
	signal	rDesPort			: std_logic_vector( 15 downto 0 )	;
	signal	rSeqNum				: std_logic_vector( 31 downto 0 )	;
	signal	rAck				: std_logic_vector( 31 downto 0 )	;
	signal	rAckFlag			: std_logic							;
	signal	rPshFlag			: std_logic							;
	signal	rRstFlag			: std_logic							;
	signal	rSynFlag			: std_logic							;
	signal	rFinFlag			: std_logic							;
	signal	rWinSize			: std_logic_vector( 15 downto 0 )	;
	signal	rDataOffset			: std_logic_vector( 3 downto 0 )	;
	
	signal	rTCPCheckSum		: std_logic_vector( 16 downto 0 )	;
	signal	rPayloadFlag		: std_logic							;
	signal	rPsudoHdFlag		: std_logic							;
	signal	rPaddingFlag		: std_logic							;
	
	-- Payload Ram I/F
		-- NOTE: rPLRamWrData is the same signal as rMacData1 (1 FF)
	signal	rPLRamWrEn			: std_logic							;
	signal	rPLRamWrAddr		: std_logic_vector( 15 downto 0 )	;
	
	-- Queue FIFO I/F
	signal	rQWrReq				: std_logic;
	signal	rQWrData			: std_logic_vector( 16 downto 0 );
	
Begin

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- Validation and error flag for (error) condition checking (TestPort)
	MacAddrValid			<= rMacAddrValid		;
	IPVerValid				<= rIPVerValid			;
	ProtocolValid	        <= rProtocolValid	    ;
	SrcIPValid		        <= rSrcIPValid		    ;
	DesIPValid		        <= rDesIPValid		    ;
	SrcPortValid	        <= rSrcPortValid	    ;
	DesPortValid	        <= rDesPortValid	    ;
	CheckSumValid(0)	    <= rIPCheckSumValid    	;
	CheckSumValid(1)		<= rTCPCheckSumValid	;
	MacErrorFlag	        <= rMacErrorFlag	    ;
	SeqNumError				<= rSeqNumErrorDelay	;
	
	-- Decoded fields from TCP header and valid
	PktValid				<= rPktValid			;
	TCPSeqNum				<= rSeqNum        		;
	TCPAck			        <= rAck        			;
	TCPAckFlag              <= rAckFlag        		;
	TCPPshFlag              <= rPshFlag        		;
	TCPRstFlag              <= rRstFlag        		;
	TCPSynFlag              <= rSynFlag        		;
	TCPFinFlag              <= rFinFlag        		;
	TCPWinSize				<= rWinSize				;
	PayloadLen				<= rPayloadLen			;
	
	-- Memories I/F
	PLRamWrData				<= rMacData1			;
	PLRamWrEn	            <= rPLRamWrEn	        ;
	PLRamWrAddr	            <= rPLRamWrAddr         ;
	
	-- Queue I/F
	QWrReq					<= rQWrReq				;
	QWrData                 <= rQWrData              ;
	
	-- Data Control path I/F
	WinUpReq				<= rWinUpReq			;
	
----------------------------------------------------------------------------------
-- Internal Process
----------------------------------------------------------------------------------
	
	u_rState : Process(Clk)	Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rState	<= stIdle;
			else
				case ( rState ) Is
					
					when stIdle		=>
						-- at first byte of the packet
						if ( rMacValid='1' and rMacSOP='1' and rMacEOP/='1' and
							 ( DecodeEn='1' or InitEn='1' ) ) then
							rState	<= stEthFrame;	
						else
							rState	<= stIdle;
						end if;
					
					when stEthFrame	=>
						-- at last byte of Ethernet frame
						if ( rMacValid='1' and rEthCnt(3 downto 0)=14 ) then
							-- Type in Ethernet frame is IPv4 (x0800) and Mac address are valid
							if ( (rEthType(7 downto 0)&rMacData(7 downto 0))=cIPv4Type and rMacAddrValid="11" ) then
								rState	<= stIPHeader;
							else
								rState	<= stIdle;
							end if;
						else
							rState		<= stEthFrame;
						end if;
					
					when stIPHeader	=>
						-- last byte of IP header
						if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=rIHL(3 downto 0)&"00" ) then
							rState	<= stTCP;	
						else
							rState	<= stIPHeader;
						end if;
	
					when stTCP	=>
						-- last byte of TCP packet (include zero padding)
						if ( rMacValid='1' and rMacEOP='1' ) then
							rState	<= stWaitCSum;
						else
							rState	<= stTCP;
						end if;
					
					when stWaitCSum	=>
						-- for checksum overflow bit adding
						-- 1clk state
						rState		<= stCSumFin;
						
					when stCSumFin =>
						-- 1clk state
						rState		<= stConCheck;
	
					when stConCheck	=>
						-- 1clk state
						rState		<= stSendQCtrl;
						
					when stSendQCtrl	=>
						-- 1clk state
						rState		<= stIdle;	
				end case;
			end if;
		end if;
	End Process u_rState;
	
----------------------------------------------------------------------------------
--	Add flip-flop for Input from RxMAC
----------------------------------------------------------------------------------
	
	u_DataIn : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			rMacSOP						<= MacSOP;
			rMacEOP						<= MacEOP;
			rMacData(7 downto 0)		<= MacData(7 downto 0);
		end if;
	End Process u_DataIn;
	
	u_rMacValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMacValid	<= '0';
				rMacError	<= "00";
			else
				rMacValid	<= MacValid;
				rMacError	<= MacError;
			end if;
		end if;
	End Process u_rMacValid;
	
	u_rMacDataFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( rMacValid='1' ) then
				rMacData1(7 downto 0)	<= rMacData(7 downto 0);
			else
				rMacData1(7 downto 0)	<= rMacData1(7 downto 0);
			end if;
		end if;
	End Process u_rMacDataFF;
	
----------------------------------------------------------------------------------
--	Latching
----------------------------------------------------------------------------------	
	
	u_rDecodeEnLat: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rDecodeEnLat	<= '0';
			else	
				-- Latch at SOP 
				if ( rMacValid='1' and rMacSOP='1' ) then
					rDecodeEnLat 	<= DecodeEn;
				else
					rDecodeEnLat	<= rDecodeEnLat;
				end if;
			end if;
		end if;
	End Process u_rDecodeEnLat;
	
----------------------------------------------------------------------------------
-- Validation for decoded TCP header field to TPU and its delay counter
-- The delay counter makes PkrValid release syn with window size update (from the Data Ctrl) 
----------------------------------------------------------------------------------

	u_rPrePktValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPrePktValid	<= '0';
			else
				-- 1 clk set when all condition valid
				if ( rState=stConCheck and rMacAddrValid="11" and
					 rIPVerValid='1' and rProtocolValid='1' and
					 rSrcIPValid='1' and rDesIPValid='1' and rSrcPortValid='1' and
					 rDesPortValid='1' and rIPCheckSumValid='1' and rTCPCheckSumValid='1' and
					 rMacErrorFlag(1 downto 0)="00" ) then
					rPrePktValid	<= '1';
				else
					rPrePktValid	<= '0';
				end if;
			end if;
		end if;
	End Process u_rPrePktValid;
	
	u_rValDelayCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rValDelayCnt	<= "00";
			else
				-- reset when counted 2 clk (Cnt=2) --> adjust to syn with WinSize
				if ( rValDelayCnt(1 downto 0)="01" ) then
					rValDelayCnt(1 downto 0)	<= "00";	
				-- increament
				elsif ( rPrePktValid='1' or 
						rValDelayCnt(1 downto 0)=1 ) then
					rValDelayCnt(1 downto 0)	<= rValDelayCnt(1 downto 0) + 1;
				else
					rValDelayCnt(1 downto 0)	<= rValDelayCnt(1 downto 0);
				end if;
			end if;
		end if;
	End Process u_rValDelayCnt;

	u_DelayOutFlag: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPktValid	<= '0';
			else
				-- delay to syn with Window size result
				if ( rValDelayCnt(1 downto 0)="01" ) then
					rPktValid			<= '1';
					rSeqNumErrorDelay	<= rSeqNumError;
				else
					rPktValid			<= '0';
					rSeqNumErrorDelay	<= '0';
				end if;
			end if;
		end if;
	End Process u_DelayOutFlag;
	
----------------------------------------------------------------------------------
--	Error flag and condition validation flag
----------------------------------------------------------------------------------
	
	u_rMacAddrValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMacAddrValid(1 downto 0)	<= "00";
			else
				-- reset when reach the last state of the packet (ConCheck)
				-- or when the out-of-focus message end (ex. UDP/ other Mac addr source)
				if ( rState=stConCheck ) or (rMacEOP='1' and rState=stIdle) then
					rMacAddrValid(1 downto 0)	<= "00";
					
				-- bit1 set when Destination Mac Addr is valid
				elsif ( rMacValid='1' and rEthCnt(3 downto 0)=7 and 
						UserValid='1' and rMacAddr(47 downto 0)=UserDesMac(47 downto 0) ) then
					rMacAddrValid(1)				<= '1';
				-- bit0 set when Source Mac Addr is valid
				elsif ( rMacValid='1' and rEthCnt(3 downto 0)=13 and 
						UserValid='1' and rMacAddr(47 downto 0)=UserSrcMac(47 downto 0) ) then
					rMacAddrValid(0)				<= '1';
				else
					rMacAddrValid(1 downto 0)	<= rMacAddrValid(1 downto 0);
				end if;
			end if;
		end if;
	End Process u_rMacAddrValid;
	
	u_rIPVerValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rIPVerValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				-- or when the out-of-focus message end (ex. UDP/ other Mac addr source)
				if ( rState=stConCheck ) or (rMacEOP='1' and rState=stIdle) then
					rIPVerValid		<= '0';
			
				-- first byte of IP header
				-- if version is 4 (IPv4), the validation is set
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=1 and rMacData(7 downto 4)=cIPv4 ) then
					rIPVerValid		<= '1';
				else
					rIPVerValid		<= rIPVerValid;
				end if;
			end if;
		end if;
	End Process u_rIPVerValid;
	
	u_rProtocolValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rProtocolValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rProtocolValid	<= '0';
				
				-- at 10th byte of IP header
				-- if protocol is 6 (TCP), the validation is set
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=10 and
					 rMacData(7 downto 0)=cTCP ) then
					rProtocolValid	<= '1';
				else
					rProtocolValid	<= rProtocolValid;
				end if;
			end if;
		end if;
	End Process u_rProtocolValid;
	
	u_rSrcIPValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSrcIPValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rSrcIPValid		<= '0';
	
				-- 17th byte of IP header, Src IP is now stable
				-- if SrcIP stated in IP header is the same as the one from user,
				-- the validation is set
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=17 and
						UserValid='1' and rSrcIP(31 downto 0)=UserSrcIP(31 downto 0) ) then
					rSrcIPValid		<= '1';
				else
					rSrcIPValid		<= rSrcIPValid;
				end if;
			end if;
		end if;
	End Process u_rSrcIPValid;
	
	u_rDesIPValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rDesIPValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rDesIPValid		<= '0';
				
				-- 1st byte of TCP header, Des IP is now stable
				-- if DesIP stated in IP header is the same as the one from user,
				-- the validation is set
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=1 and
						UserValid='1' and rDesIP(31 downto 0)=UserDesIP(31 downto 0) ) then
					rDesIPValid		<= '1';
				
				else
					rDesIPValid		<= rDesIPValid;
				end if;
			end if;
		end if;
	End Process u_rDesIPValid;
	
	u_rSrcPortValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSrcPortValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rSrcPortValid		<= '0';
			
				-- 3rd byte of TCP header, Src Port is now stable
				-- if SrcPort stated in TCP header is the same as the one from user,
				-- the validation is set
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=3 and
						UserValid='1' and rSrcPort(15 downto 0)=UserSrcPort(15 downto 0) ) then
					rSrcPortValid	<= '1';
				else
					rSrcPortValid		<= rSrcPortValid;
				end if;
			end if;
		end if;
	End Process u_rSrcPortValid;
	
	u_rDesPortValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rDesPortValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rDesPortValid		<= '0';
				
				-- 5th byte of TCP header, Des Port is now stable
				-- if DesPort stated in TCP header is the same as the one from user,
				-- the validation is set
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=5 and
						UserValid='1' and rDesPort(15 downto 0)=UserDesPort(15 downto 0) ) then
					rDesPortValid	<= '1';
				else
					rDesPortValid		<= rDesPortValid;
				end if;
			end if;
		end if;
	End Process u_rDesPortValid;
	
	u_rIPCheckSumValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rIPCheckSumValid	<= '0';
			else
				-- reset when reach the last state of the packet (ConCheck) 
				if ( rState=stConCheck ) then
					rIPCheckSumValid		<= '0';
				
				-- 2nd byte of TCP header, IP checksum is now stable (and finish)
				-- if the IP checksum is correct, the validation is set
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=2 and
					 rIPCheckSum(16 downto 0)='0'&x"FFFF" ) then
					rIPCheckSumValid	<= '1';
				else
					rIPCheckSumValid		<= rIPCheckSumValid;
				end if;
			end if;
		end if;
	End Process u_rIPCheckSumValid;
	
	u_rTCPCheckSumValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTCPCheckSumValid	<= '0';
			else
				-- at the CSumFin State, the last byte of data is added to TCP chechsum,
				-- but the overflow bit is not added
				if ( rState=stCSumFin and rTCPCheckSum(16 downto 0)='0'&x"FFFF" ) then
					rTCPCheckSumValid		<= '1';
				else
					rTCPCheckSumValid	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTCPCheckSumValid;
	
	u_rMacErrorFlag: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMacErrorFlag	<= "00";
			else	
				-- each bit set when Mac error is set, and reset when state reach stConCheck
				-- additional reset when start of packet to prevent error latching from 
				-- former packet (in case: state did not reach stConCheck )
				if ( rState=stConCheck or rMacSOP='1' ) then
					rMacErrorFlag(0) 	<= '0';
				elsif ( rMacError(0)='1' ) then
					rMacErrorFlag(0) 	<= '1';
				else
					rMacErrorFlag(0)	<= rMacErrorFlag(0);
				end if;
				
				if ( rState=stConCheck or rMacSOP='1' ) then
					rMacErrorFlag(1) 	<= '0';
				elsif ( rMacError(1)='1' ) then
					rMacErrorFlag(1) 	<= '1';
				else
					rMacErrorFlag(1)	<= rMacErrorFlag(1);
				end if;
			end if;
		end if;
	End Process u_rMacErrorFlag;
	
	u_rSeqNumError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rSeqNumError	<= '0';
			else
				-- reset when delay counter is done or SOP arrives (in case delay counter never runs)
				if ( rValDelayCnt(1 downto 0)="10" or rMacSOP='1' ) then
					rSeqNumError	<= '0';

				-- concern and check TCP SeqNum when DecodeEn is set
				elsif ( rState=stConCheck and rDecodeEnLat='1' and
					 (rSeqNum(31 downto 0)/=ExpSeqNum(31 downto 0)) ) then
					rSeqNumError	<= '1';
				else
					rSeqNumError	<= rSeqNumError;
				end if;
			end if;
		end if;
	End Process u_rSeqNumError;
	
----------------------------------------------------------------------------------
--	Ethernet Frame
----------------------------------------------------------------------------------
	
	u_rEthCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rEthCnt(3 downto 0)	<= x"0";
			else
				-- initialise when SOP is fed
				if ( rMacValid='1' and rMacSOP='1' and (DecodeEn='1' or InitEn='1') ) then
					rEthCnt(3 downto 0)	<= x"2";
				-- increament in stEthFrame
				elsif ( rMacValid='1' and rState=stEthFrame ) then 
					rEthCnt(3 downto 0)	<= rEthCnt(3 downto 0) + 1;
				else
					rEthCnt(3 downto 0)	<= rEthCnt(3 downto 0);
				end if;
			end if;
		end if;
	End Process u_rEthCnt;
	
	u_rEthType : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect Ethernet Type when 13th and 14th byte of Etehrnet frame are fed
			if ( rMacValid='1' and (rEthCnt(3 downto 0)=13 or rEthCnt(3 downto 0)=14) ) then
				rEthType(15 downto 8)	<= rEthType(7 downto 0);
				rEthType(7 downto 0)	<= rMacData(7 downto 0);
			else
				rEthType(15 downto 0)	 <= rEthType(15 downto 0);
			end if;
		end if;
	End Process u_rEthType;

----------------------------------------------------------------------------------
-- Mac, IP header [left shift] registers (field decoders) and byte counter
----------------------------------------------------------------------------------	
	
	u_rMacAddr : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rMacAddr(47 downto 0)	<= (others=>'0');
			else
				-- collect Mac Addr in when Ethernet Frame (Mac header is fed)
				if ( rMacSOP='1' or (rMacValid='1' and rState=stEthFrame) ) then
					rMacAddr(47 downto 40)		<= rMacAddr(39 downto 32);
					rMacAddr(39 downto 32)		<= rMacAddr(31 downto 24);
					rMacAddr(31 downto 24)		<= rMacAddr(23 downto 16);
					rMacAddr(23 downto 16)		<= rMacAddr(15 downto 8);
					rMacAddr(15 downto 8)		<= rMacAddr(7 downto 0);
					rMacAddr(7 downto 0)		<= rMacData(7 downto 0);
				else
					rMacAddr(47 downto 0)		<= rMacAddr(47 downto 0);
				end if;
			end if;
		end if;
	End Process u_rMacAddr;
	
	u_rIPHeadCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rIPHeadCnt(5 downto 0)	<= "00"&x"0";
			else
				-- at last byte of Ethernet frame, intitialize if Type is TPv4
				if ( rMacValid='1' and rEthCnt(3 downto 0)=14 and 
					 (rEthType(7 downto 0)&rMacData(7 downto 0))=cIPv4Type ) then
					rIPHeadCnt(5 downto 0)	<= "00"&x"1";
				-- while bytes in IP header are fed in 
				elsif ( rMacValid='1' and rState=stIPHeader  ) then
					rIPHeadCnt(5 downto 0)	<= rIPHeadCnt(5 downto 0) + 1;
				else
					rIPHeadCnt(5 downto 0)	<= rIPHeadCnt(5 downto 0);
				end if;
			end if;
		end if;			
	End Process u_rIPHeadCnt;
	
	u_rIHL : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect IHL value when first byte of IP header is fed
			if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=1 ) then
				rIHL(3 downto 0)	<= rMacData(3 downto 0);
			else
				rIHL(3 downto 0)	<= rIHL(3 downto 0);
			end if;
		end if;
	End Process u_rIHL;

	u_rTotalLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of TotalLen 
			-- when the 3rd and 4th bytes of IP hearder are fed.
			if ( rMacValid='1' and 
			   ( rIPHeadCnt(5 downto 0)=3 or rIPHeadCnt(5 downto 0)=4 ) ) then
				rTotalLen(15 downto 8)		<= rTotalLen(7 downto 0);
				rTotalLen(7 downto 0)		<= rMacData(7 downto 0);
			else
				rTotalLen(15 downto 0)		<= rTotalLen(15 downto 0);
			end if;
		end if;
	End Process u_rTotalLen;

	u_rSrcIP : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of SrcIP
			-- when the 13th - 16th bytes of IP heaer are fed.
			if ( rMacValid='1' and 
			   ( rIPHeadCnt(5 downto 0)=13 or rIPHeadCnt(5 downto 0)=14 or
				 rIPHeadCnt(5 downto 0)=15 or rIPHeadCnt(5 downto 0)=16 ) ) then
				rSrcIP(31 downto 24)	<= rSrcIP(23 downto 16);
				rSrcIP(23 downto 16)	<= rSrcIP(15 downto 8);
				rSrcIP(15 downto 8)		<= rSrcIP(7 downto 0);
				rSrcIP(7 downto 0)		<= rMacData(7 downto 0);
			else
				rSrcIP(31 downto 0)		<= rSrcIP(31 downto 0);
			end if;
		end if;
	End Process u_rSrcIP;

	u_rDesIP : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of DesIP
			-- when the 17th - 20th bytes of IP heaer are fed.
			if ( rMacValid='1' and 
			   ( rIPHeadCnt(5 downto 0)=17 or rIPHeadCnt(5 downto 0)=18 or
				 rIPHeadCnt(5 downto 0)=19 or rIPHeadCnt(5 downto 0)=20 ) ) then	
				rDesIP(31 downto 24)	<= rDesIP(23 downto 16);
				rDesIP(23 downto 16)	<= rDesIP(15 downto 8);
				rDesIP(15 downto 8)		<= rDesIP(7 downto 0);
				rDesIP(7 downto 0)		<= rMacData(7 downto 0);
			else
				rDesIP(31 downto 0)	<= rDesIP(31 downto 0);
			end if;
		end if;
	End Process u_rDesIP;

----------------------------------------------------------------------------------
-- TCP header [left shift] registers (field decoders), TCP Len and byte counter 
----------------------------------------------------------------------------------	
	
	u_rTCPCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTCPCnt(15 downto 0)	<= (others=>'0');
			else
				-- initialize at last byte of IP header
				if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=rIHL(3 downto 0)&"00" ) then
					rTCPCnt(15 downto 0)	<= x"0001";
				-- while bytes in TCP header are fed in
				elsif ( rMacValid='1' and rState=stTCP ) then
					rTCPCnt(15 downto 0)		<= rTCPCnt(15 downto 0) + 1;
				else
					rTCPCnt(15 downto 0)		<= rTCPCnt(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTCPCnt;
	
	u_rTCPLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTCPLen(15 downto 0)	<= (others=>'0');
			else
				-- calculate TCPLen when rTotalLen is collected completely 
				-- @ 5th byte of IP header
				if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=5 ) then
					rTCPLen(15 downto 0) 	<= rTotalLen(15 downto 0) - (x"00"&"00"&rIHL(3 downto 0)&"00");
				else
					rTCPLen(15 downto 0)	<= rTCPLen(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTCPLen;

	u_rPayloadLen : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPayloadLen(15 downto 0)	<= (others=>'0');
			else
				-- calculate PayloadLen when rDataOffset is collected completely 
				-- @ 14th byte of TCP header
				if ( rMacValid='1' and rTCPCnt(15 downto 0)=14 ) then
					rPayloadLen(15 downto 0)	<= rTCPLen(15 downto 0) - (x"00"&"00"&rDataOffset(3 downto 0)&"00");
				else
					rPayloadLen(15 downto 0)	<= rPayloadLen(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rPayloadLen;
	
	u_rSrcPort : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of SrcPort 
			-- when the 1st and 2nd bytes of TCP hearder are fed. 
			if ( rMacValid='1' and 
			   ( rTCPCnt(15 downto 0)=1 or rTCPCnt(15 downto 0)=2 ) ) then
				rSrcPort(15 downto 8)	<= rSrcPort(7 downto 0);
				rSrcPort(7 downto 0)	<= rMacData(7 downto 0);
			else
				rSrcPort(15 downto 0)	<= rSrcPort(15 downto 0);
			end if;
		end if;
	End Process u_rSrcPort;

	u_rDesPort : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of DesPort 
			-- when the 3rd and 4th bytes of TCP hearder are fed. 
			if ( rMacValid='1' and 
			   ( rTCPCnt(15 downto 0)=3 or rTCPCnt(15 downto 0)=4 ) ) then
				rDesPort(15 downto 8)	<= rDesPort(7 downto 0);
				rDesPort(7 downto 0)	<= rMacData(7 downto 0);
			else
				rDesPort(15 downto 0)	<= rDesPort(15 downto 0);
			end if;
		end if;
	End Process u_rDesPort;

	u_rSeqNum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of SeqNum 
			-- when the 5th - 8th bytes of TCP hearder are fed. 
			if ( rMacValid='1' and 
			   ( rTCPCnt(15 downto 0)=5 or rTCPCnt(15 downto 0)=6 or
				 rTCPCnt(15 downto 0)=7 or rTCPCnt(15 downto 0)=8 ) ) then
				rSeqNum(31 downto 24)	<= rSeqNum(23 downto 16);
				rSeqNum(23 downto 16)	<= rSeqNum(15 downto 8);
				rSeqNum(15 downto 8)	<= rSeqNum(7 downto 0);
				rSeqNum(7 downto 0)		<= rMacData(7 downto 0);
			else
				rSeqNum(31 downto 0)	<= rSeqNum(31 downto 0);
			end if;
		end if;
	End Process u_rSeqNum;

	u_rAck : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect each byte of ACK 
			-- when the 9th - 12th bytes of TCP hearder are fed. 
			if ( rMacValid='1' and 
			   ( rTCPCnt(15 downto 0)=9 or rTCPCnt(15 downto 0)=10 or
				 rTCPCnt(15 downto 0)=11 or rTCPCnt(15 downto 0)=12 ) ) then
				rAck(31 downto 24)		<= rAck(23 downto 16);
				rAck(23 downto 16)		<= rAck(15 downto 8);
				rAck(15 downto 8)		<= rAck(7 downto 0);
				rAck(7 downto 0)		<= rMacData(7 downto 0);
			else
				rAck(31 downto 0)		<= rAck(31 downto 0);
			end if;
		end if;
	End Process u_rAck;

	u_rDataOffset : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect DataOffset value when the 13th byte of TCP header is fed
			if (  rMacValid='1' and rTCPCnt(15 downto 0)=13 ) then
				rDataOffset(3 downto 0)	<= rMacData(7 downto 4);
			else
				rDataOffset(3 downto 0)	<=	rDataOffset(3 downto 0);
			end if;
		end if;
	End Process u_rDataOffset;

	u_TCPFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect TCP flag value when the 14th byte of TCP header is fed
			if (  rMacValid='1' and rTCPCnt(15 downto 0)=14 ) then
				rAckFlag	<= rMacData(4);
				rPshFlag	<= rMacData(3);
				rRstFlag    <= rMacData(2);
				rSynFlag    <= rMacData(1);
				rFinFlag    <= rMacData(0);
			else
				rAckFlag	<= rAckFlag;
				rPshFlag	<= rPshFlag;
				rRstFlag    <= rRstFlag;
				rSynFlag    <= rSynFlag;
				rFinFlag    <= rFinFlag;
			end if;
		end if;
	End Process u_TCPFlag;
	
	u_rWinSize : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- collect Window size value 
			-- when the 15th - 16th bytes of TCP hearder are fed. 
			if ( rMacValid='1' and 
			   ( rTCPCnt(15 downto 0)=15 or rTCPCnt(15 downto 0)=16 ) ) then
				rWinSize(15 downto 8)	<= rWinSize(7 downto 0);
				rWinSize(7 downto 0)	<= rMacData(7 downto 0);
			else
				rWinSize(15 downto 0)	<= rWinSize(15 downto 0);
			end if;
		end if;
	End Process u_rWinSize;

----------------------------------------------------------------------------------
--	Checksum and flag for TCP checksum (in Psudo header)
----------------------------------------------------------------------------------	
	
	u_rPsudoHdFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPsudoHdFlag		<= '0';
			else
				-- reset when last byte of each Psudo header fields in IP header are fed
				-- @ 20th byte 
				if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=20 ) then
					rPsudoHdFlag		<= '0';
				-- set while Psudo header fields in IP header are fed(@ 12th byte)
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=12 )  then
					rPsudoHdFlag		<= '1';
				else
					rPsudoHdFlag		<= rPsudoHdFlag;
				end if;
			end if;
		end if;
	End Process u_rPsudoHdFlag;
	
	u_rPaddingFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPaddingFlag		<= '0';
			else
				-- make sure to reset
				if ( rMacSOP='1' or rMacEOP='1' ) then
					rPaddingFlag	<= '0';
				
				-- set
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=rTCPLen(15 downto 0) and rMacEOP/='1' ) then
					rPaddingFlag	<= '1';
				else
					rPaddingFlag	<= '0';
				end if;
			end if;
		end if;
	End Process u_rPaddingFlag;
	
	u_rIPCheckSum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rIPCheckSum(16 downto 0)	<= (others=>'0');
			else
				-- initialize IP checksum value by the first and second byte of IP header
				if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=2 ) then
					rIPCheckSum(16 downto 0)	<= '0' & rMacData1(7 downto 0) & rMacData(7 downto 0);
				
				-- in IP header state, add new 16-bit data when rIPHeadCnt is even.
				elsif ( rMacValid='1' and rState=stIPHeader and rIPHeadCnt(0)='0') then
					rIPCheckSum(16 downto 0)	<=	rIPCheckSum(16 downto 0) + 
													('0' & rMacData1(7 downto 0) & rMacData(7 downto 0));
				
				-- in IP header state, add overflow bit when rIPHeadCnt is odd.
				-- also add overflow bit when the last byte of IP header is already added  
				elsif rMacValid='1' and ((rState=stIPHeader and rIPHeadCnt(0)='1') or rTCPCnt(15 downto 0)=1)  then
					rIPCheckSum(16)				<= 	'0';
					rIPCheckSum(15 downto 0)	<= 	rIPCheckSum(15 downto 0) +
													(x"00" & "0000000" & rIPCheckSum(16));
					
				else
					rIPCheckSum(16 downto 0)	<= rIPCheckSum(16 downto 0);
				end if;			
			end if;
		end if;
	End Process u_rIPCheckSum;

	u_rTCPCheckSum : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTCPCheckSum(16 downto 0)	<= (others=>'0');
			else
				-- coding below base on each period which TCP checksum is operated.
				-- some reducdant else-if condition is separated to show the cases clearly.
			
				-- initialize TCP checksum value by Protocal field (byte) in IP header(at 10th byte)
				-- note: Protocal field in IP header is a part of Psudo header in TCP checksum
				if ( rMacValid='1' and rIPHeadCnt(5 downto 0)=10 ) then	
					rTCPCheckSum(16 downto 0)	<= 	'0' & x"00" & rMacData(7 downto 0);
				
				-- at 11th byte of IP header, add TCPLen into checksum
				-- 16-bit TCPLen is a part of Psudo header 
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=11 ) then
					rTCPCheckSum(16 downto 0)	<=	rTCPCheckSum(16 downto 0) + 
													('0' & rTCPLen(15 downto 0));
				
				-- at 12th byte of IP header, add overflow bit due to TCPLen adding
				elsif ( rMacValid='1' and rIPHeadCnt(5 downto 0)=12 ) then
					rTCPCheckSum(16)				<= 	'0';
					rTCPCheckSum(15 downto 0)	<= 	rTCPCheckSum(15 downto 0) +
													(x"00" & "0000000" & rTCPCheckSum(16));
				
				-- while rPsudoHdFlag is set and rIPHeadCnt is even, add new 16-bit data.
				elsif ( rMacValid='1' and rPsudoHdFlag='1' and rIPHeadCnt(0)='0' ) then
					rTCPCheckSum(16 downto 0)	<=	rTCPCheckSum(16 downto 0) + 
													('0' & rMacData1(7 downto 0) & rMacData(7 downto 0));
					
				-- while rPsudoHdFlag is set and rIPHeadCnt is odd, add overflow bit.
				elsif ( rMacValid='1' and rPsudoHdFlag='1' and rIPHeadCnt(0)='1' ) then
					rTCPCheckSum(16)				<= 	'0';
					rTCPCheckSum(15 downto 0)	<= 	rTCPCheckSum(15 downto 0) +
													(x"00" & "0000000" & rTCPCheckSum(16));
													
				-- if TCPLen is odd, add last byte (8 bit) via special case 
				elsif ( rMacValid='1' and rTCPCnt(15 downto 0)=rTCPLen(15 downto 0) and rTCPLen(0)='1'  ) then	
					rTCPCheckSum(16 downto 0)	<=	rTCPCheckSum(16 downto 0) + 
													('0' & rMacData(7 downto 0) & x"00");

				-- in TCP state, if last bit of rTCPCnt is 0, add new 16-bit data
				elsif ( rMacValid='1' and rTCPCnt(0)='0' and rState=stTCP and rPaddingFlag/='1' ) then
					rTCPCheckSum(16 downto 0)	<=	rTCPCheckSum(16 downto 0) + 
													('0' & rMacData1(7 downto 0) & rMacData(7 downto 0));
					
				-- in TCP state, if last bit of rTCPCnt is 1, add overflow bit / or in State Wait
				elsif ( rMacValid='1' and rTCPCnt(0)='1' and rState=stTCP ) or rState=stWaitCSum then
					rTCPCheckSum(16)				<= 	'0';
					rTCPCheckSum(15 downto 0)	<= 	rTCPCheckSum(15 downto 0) +
													(x"00" & "0000000" & rTCPCheckSum(16));
				else
					rTCPCheckSum(16 downto 0)	<= rTCPCheckSum(16 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTCPCheckSum;
	
	-- **Note**:	This TCP checksum assumes that at the last byte adding, if the checksum is correct
	--				"there is no overflow bit".
	
----------------------------------------------------------------------------------
-- Payload Ram Wr I/F
-- Note: Ram Wr Data is the same signal as rMacData1 (1 FF) 
----------------------------------------------------------------------------------	
	
	u_rPayloadFlag : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPayloadFlag		<= '0';
			else
				-- reset when the last byte of payload is fed 
				if ( rMacValid='1' and rState=stTCP and 
					 rTCPCnt(15 downto 0)=rTCPLen(15 downto 0) ) then
					rPayloadFlag	<= '0';
				-- set at the last byte of TCP header 
				elsif ( rState=stTCP and rMacValid='1' and rPayloadLen(15 downto 0)/=0 and
					 rTCPCnt(15 downto 0)=(x"00"&"00"&rDataOffset(3 downto 0)&"00") ) then
					rPayloadFlag	<= '1';
				else
					rPayloadFlag	<= rPayloadFlag;
				end if;
			end if;
		end if;
	End Process u_rPayloadFlag;
	
	u_rPLRamWrEn : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPLRamWrEn		<= '0';
			else
				-- Wr payload's Ram when payload (byte) is fed
				if ( rMacValid='1' and rPayloadFlag='1' ) then
					rPLRamWrEn	<= '1';
				else
					rPLRamWrEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rPLRamWrEn;
	
	u_rPLRamWrAddr : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPLRamWrAddr(15 downto 0)	<= (others=>'0');
			else
				-- increament if Ram WrEn is set
				-- This Ram WrAddr is the Wr pointer which indicates the next free space in Ram
				if ( rPLRamWrEn='1' ) then
					rPLRamWrAddr(15 downto 0)	<= rPLRamWrAddr(15 downto 0) + 1;
				else
					rPLRamWrAddr(15 downto 0)	<= rPLRamWrAddr(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rPLRamWrAddr;

----------------------------------------------------------------------------------
-- DataCtrl I/F
-- rWinUpReq: 	To request window siez update from Data Control path 
----------------------------------------------------------------------------------	
	
	u_rWinUpReq : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rWinUpReq	<= '0';
			else
				if ( rPrePktValid='1' and rPayloadLen(15 downto 0)/=0 ) then 
					rWinUpReq	<= '1';
				else
					rWinUpReq	<= '0';
				end if;
			end if;
		end if;
	End Process u_rWinUpReq;

----------------------------------------------------------------------------------
-- Queue I/F
----------------------------------------------------------------------------------	
	
	u_rQWrReq: Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rQWrReq	<= '0';
			else	
				-- Write queue when condition checking is done and there is a payload in pkt
				if ( rState=stSendQCtrl and rPayloadLen(15 downto 0)/=0  and
					 QWrFull/='1' ) then
					rQWrReq		<= '1';
				else
					rQWrReq		<= '0';
				end if;
			end if;
		end if;
	End Process u_rQWrReq;

	u_rQWrData : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- syn with rPrePktValid
			if ( rState=stSendQCtrl ) then
				-- if all condition valid and SeqNum is the expexted one, that payload is kept
				-- else --> flush
				if ( rPrePktValid='1' and rSeqNumError='0' ) then
					rQWrData(16)			<= '1';
					rQWrData(15 downto 0)	<= rPayloadLen(15 downto 0);
				else
					rQWrData(16)			<= '0';
					rQWrData(15 downto 0)	<= rPayloadLen(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rQWrData;
	
End Architecture rt1;