----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     RxTPUCtrl.vhd
-- Title        RxTPUCtrl For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/11/04
-- Syntax       VHDL
-- Description      
-- 
-- Receiving processor of TCP/IP Processing Unit (TPU)
--
--
----------------------------------------------------------------------------------
-- Note
--
-- StateCtrl I/F 
--	CtrlStateMach : State Machine of TCP Mechanism Control consists 8 bits 
--	 -> bit 0 : State SYNSent 
--	 -> bit 1 : State Established 
-- 	 -> bit 2 : State CloseWait 
--	 -> bit 3 : State LastACK 
--	 -> bit 4 : State FinWait1 
--	 -> bit 5 : State FinWait2 
--	 -> bit 6 : State Closing 
--	 -> bit 7 : State Timewait
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxTPUCtrl Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
	
		-- TCPCtrl Interface	
	    CtrlSenderMACAddr		: in 	std_logic_vector(47 downto 0 );
		CtrlTargetMACAddr		: in	std_logic_vector(47 downto 0 );
		CtrlSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlSrcPort     		: in	std_logic_vector(15 downto 0 );
		CtrlDesPort     		: in	std_logic_vector(15 downto 0 );
		CtrlStateMach			: in 	std_logic_vector( 7 downto 0 );
		CtrlRST					: in 	std_logic;
		CtrlAddrVal				: in	std_logic;
		
		CtrlFlags				: out 	std_logic_vector( 8 downto 0 ); 
		CtrlAllRecv				: out	std_logic;	
		
		-- TxTPUCtrl Interface
		Tx2RxTPUSeqNum			: in	std_logic_vector(31 downto 0 );
		Tx2RxTPUCtrl			: in	std_logic_vector( 3 downto 0 );
		Tx2RxTPURetransEn		: in 	std_logic_vector( 3 downto 0 );
		
		Rx2TxTPUAckNum			: out	std_logic_vector(31 downto 0 );
		Rx2TxTPUSeqNumAcked		: out	std_logic_vector(31 downto 0 );
		Rx2TxTPUCSeqNumRet		: out 	std_logic_vector(31 downto 0 );
		Rx2TxTPURecWindow 		: out 	std_logic_vector(15 downto 0 );
		Rx2TxTPUWindow			: out	std_logic_vector(15 downto 0 );
		Rx2TxTPURetransOption	: out	std_logic_vector( 3 downto 0 );
		Rx2TxTPUAckNumUdt 		: out	std_logic;
		Rx2TxTPUSeqNumEn		: out	std_logic;
		
		-- RxTCPIP Interface
		Rx2TPUSeqNum			: in	std_logic_vector(31 downto 0 );
		Rx2TPUAckNum			: in	std_logic_vector(31 downto 0 );
		Rx2TPUPayloadLen		: in	std_logic_vector(15 downto 0 );
		Rx2TPUWinSize			: in	std_logic_vector(15 downto 0 );
		Rx2TPUFreeSpace			: in	std_logic_vector(15 downto 0 );
		Rx2TPUAckFlag			: in 	std_logic;
		Rx2TPUPshFlag           : in 	std_logic;
		Rx2TPURstFlag			: in 	std_logic;
		Rx2TPUSynFlag           : in 	std_logic;
		Rx2TPUFinFlag			: in 	std_logic;
		Rx2TPUPktValid          : in 	std_logic;
		Rx2TPUSeqNumError		: in 	std_logic;
		
		TPU2RxSenderMACAddr		: out 	std_logic_vector(47 downto 0 );
		TPU2RxTargetMACAddr		: out	std_logic_vector(47 downto 0 );
		TPU2RxSenderIpAddr		: out 	std_logic_vector(31 downto 0 );
		TPU2RxTargetIpAddr		: out 	std_logic_vector(31 downto 0 );
		TPU2RxExpSeqNum			: out	std_logic_vector(31 downto 0 );
		TPU2RxSrcPort     		: out	std_logic_vector(15 downto 0 );
		TPU2RxDesPort     		: out	std_logic_vector(15 downto 0 );
		TPU2RxInitFlag			: out	std_logic;
		TPU2RxDecodeEn			: out	std_logic;
		TPU2RxDataTransEn		: out	std_logic;
		TPU2RxAddrVal			: out	std_logic
	);
End Entity RxTPUCtrl;	
	
Architecture rtl Of RxTPUCtrl Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- FF control signal 
	signal	rRx2TPUPktValidFF		: std_logic_vector( 1 downto 0 );
	signal  rRx2TPUSeqNumErrorFF	: std_logic_vector( 1 downto 0 );
	
	-- FF Data signal 
	signal  rRx2TPUAckNumFF			: std_logic_vector(63 downto 0 );
	signal  rRx2TPUWinSizeFF		: std_logic_vector(31 downto 0 );
	signal  rRx2TPUFreeSpaceFF		: std_logic_vector(31 downto 0 );
	
	-- Expected SeqNum process
	signal  rRxTPUExpSeqNum	        : std_logic_vector(31 downto 0 );
	signal  rRxTPUFinPktVal			: std_logic_vector( 4 downto 0 );
	signal  rRxTPUPktVal			: std_logic;
	signal  rJumpedPktEn			: std_logic;
	signal  rDupACKEn				: std_logic;
	
	-- Initial packet process 
	signal  rAckNumInitEn			: std_logic_vector( 3 downto 0 );
	signal  rAckNumVal 				: std_logic;
	
	-- DupACK-based retransmission process 
	signal  rAckPktEn				: std_logic_vector( 2 downto 0 );
	signal  rAckPktCtrl				: std_logic_vector( 1 downto 0 );
	signal 	rAckPktCtrlCnt			: std_logic_vector( 1 downto 0 );
	signal  rAckPktRetrans			: std_logic;
	signal  rAckPktRetransFin		: std_logic;
	
	-- Control Timer process 
	signal  rCPktRefSeqNum			: std_logic_vector(31 downto 0 );
	signal  rCPktSeqNumUdt			: std_logic_vector( 4 downto 0 );
	signal  rCPktSet				: std_logic_vector( 1 downto 0 );
	signal  rCPktIdent				: std_logic_vector( 1 downto 0 );
	
	-- Timeout-based retransmission process 
	signal  rTimerCnt				: std_logic_vector(27 downto 0 );
	signal  rTimerSet 				: std_logic_vector( 2 downto 0 );
	signal  rTimerExpired			: std_logic_vector( 1 downto 0 );
	signal  rTimerAckChangeEn		: std_logic;
	signal  rTimerPktAcked			: std_logic;
	signal  rTimerRst				: std_logic;
	signal  rTimerCntRst			: std_logic;
	signal  rTimerCntEn				: std_logic;
	
	-- Timer retransmission control 
	signal  rTimerCtrlRetransOp		: std_logic_vector( 2 downto 0 );
	signal  rTimerCtrlSynAcked		: std_logic;
	signal  rTimerCtrlFinAcked		: std_logic;
	
	-- Sequence number & Acknowledgement number calculator 
	signal  rCPktRefSeqNumCal		: std_logic_vector(31 downto 0 );
	signal  rAckNumChangeCal        : std_logic_vector(31 downto 0 );
	signal  rExpSeqNumCal			: std_logic_vector(31 downto 0 );
	signal 	rAckNumCal              : std_logic_vector(31 downto 0 );
	
	-- TxTPU I/F 
	signal  rRxTPURetransReq		: std_logic_vector( 2 downto 0 );
	signal  rRxTPUAckRetransReq		: std_logic; 
	signal  rRxTPUAckNumUdt			: std_logic;

	-- RxTCPIP I/F 
	signal  rRxTPUCtrl0				: std_logic_vector( 2 downto 0 );
	signal  rRxTPUCtrl1				: std_logic_vector( 2 downto 0 );
	signal  rRxTPURecvErr			: std_logic;
	
	-- StateCtrl I/F 
	signal  rCtrlFlags				: std_logic_vector( 8 downto 0 );
	signal  rCtrlRxError			: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- TPU to RxTCPIP I/F 
	TPU2RxSenderMACAddr(47 downto 0 )	<= CtrlSenderMACAddr(47 downto 0 );			
	TPU2RxTargetMACAddr(47 downto 0 )	<= CtrlTargetMACAddr(47 downto 0 );				
	TPU2RxSenderIpAddr(31 downto 0 )	<= CtrlSenderIpAddr(31 downto 0 );					
	TPU2RxTargetIpAddr(31 downto 0 )	<= CtrlTargetIpAddr(31 downto 0 );					
	TPU2RxExpSeqNum(31 downto 0 )		<= rRxTPUExpSeqNum(31 downto 0 );     					
	TPU2RxSrcPort(15 downto 0 )		    <= CtrlSrcPort(15 downto 0 );	     		 		
	TPU2RxDesPort(15 downto 0 )		    <= CtrlDesPort(15 downto 0 );	 		
	TPU2RxInitFlag					    <= rRxTPUCtrl0(0);
	TPU2RxDecodeEn			            <= rRxTPUCtrl1(1);
 	TPU2RxDataTransEn		            <= rRxTPUCtrl1(2);
	TPU2RxAddrVal						<= CtrlAddrVal; 
	
	-- RxTPU to TxTPU I/F 
	Rx2TxTPUAckNum(31 downto 0 )		<= rRxTPUExpSeqNum(31 downto 0 );
	Rx2TxTPUSeqNumAcked(31 downto 0 )	<= rRx2TPUAckNumFF(63 downto 32);	
	Rx2TxTPURecWindow(15 downto 0 )	 	<= rRx2TPUWinSizeFF(31 downto 16);
	Rx2TxTPUWindow(15 downto 0 )		<= rRx2TPUFreeSpaceFF(31 downto 16);		
	Rx2TxTPURetransOption(3)			<= rRxTPURetransReq(2);
	Rx2TxTPURetransOption(2)			<= rRxTPUAckRetransReq;
	Rx2TxTPURetransOption(1)			<= rRxTPURetransReq(1);
	Rx2TxTPURetransOption(0)			<= rRxTPURetransReq(0);
	Rx2TxTPUAckNumUdt 					<= rRxTPUAckNumUdt;
	Rx2TxTPUSeqNumEn					<= rAckNumVal;
	
	-- RxTPU to StateCtrl 
	CtrlFlags( 8 downto 0 )				<= rCtrlFlags( 8 downto 0 );
	CtrlAllRecv							<= rTimerPktAcked; 
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------	
-----------------------------------------------------------
-- FF signal   
	
	-- FF control signal 
	u_FFRxTCPVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRx2TPUPktValidFF( 1 downto 0 )		<= (others=>'0');
				rRx2TPUSeqNumErrorFF( 1 downto 0 )	<= (others=>'0');
			else 
				rRx2TPUPktValidFF( 1 downto 0 )		<= rRx2TPUPktValidFF(0)&Rx2TPUPktValid;
				rRx2TPUSeqNumErrorFF( 1 downto 0 )	<= rRx2TPUSeqNumErrorFF(0)&Rx2TPUSeqNumError;
			end if;
		end if;
	End Process u_FFRxTCPVal;	
	
	-- FF data signal of RxTCPIP to sync with update signal 
	u_FFInputSignal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRx2TPUAckNumFF(63 downto 32)		<= rRx2TPUAckNumFF(31 downto 0 );
			rRx2TPUWinSizeFF(31 downto 16)		<= rRx2TPUWinSizeFF(15 downto 0 );		
	        rRx2TPUFreeSpaceFF(31 downto 0 )	<= (rRx2TPUFreeSpaceFF(15 downto 0)&Rx2TPUFreeSpace(15 downto 0));			
			
			-- Latching only validatation packet 
			if ( Rx2TPUPktValid='1' and ((Rx2TPUSeqNumError='0' and rRxTPUCtrl0(1)='1') 
				or rRxTPUCtrl0(0)='1') ) then 
				rRx2TPUWinSizeFF(15 downto 0 )		<= Rx2TPUWinSize(15 downto 0);
			else 		
				rRx2TPUWinSizeFF(15 downto 0 )		<= rRx2TPUWinSizeFF(15 downto 0 );
			end if;
		
			if ( Rx2TPUAckFlag='1' and Rx2TPUPktValid='1' and (rRxTPUCtrl0(0)='1'
				or (Rx2TPUSeqNumError='0' and rRxTPUCtrl0(1)='1')) ) then 
				rRx2TPUAckNumFF(31 downto 0 )		<= Rx2TPUAckNum(31 downto 0);
			else
				rRx2TPUAckNumFF(31 downto 0 )		<= rRx2TPUAckNumFF(31 downto 0 );
			end if;
		end if;
	End Process u_FFInputSignal;
	
-----------------------------------------------------------
-- Output generator to RxTCPIP 
	
	-- Bit 0 	: DecodeEn 
	-- Bit 1 	: DataTransEn 
	u_rRxTPUCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxTPUCtrl0( 2 downto 0 )	<= (others=>'0');
				rRxTPUCtrl1( 2 downto 0 )	<= (others=>'0');
			else 
				-- Using FF signal as an output 
				rRxTPUCtrl1( 2 downto 0 )	<= rRxTPUCtrl0( 2 downto 0 );
				
				-- Bit 0 : Init  
				-- Reset when not in SYNSemt State 
				if ( CtrlRST='1' or CtrlStateMach(0)='0' ) then 
					rRxTPUCtrl0(0)	<= '0';
				-- Sent SYN Packet 
				elsif ( Tx2RxTPUCtrl(2)='1' ) then 
					rRxTPUCtrl0(0)	<= '1';
				else 
					rRxTPUCtrl0(0)	<= rRxTPUCtrl0(0);
				end if;
				
				-- Bit 1 : DecodeEn 
				-- Reset when back to Idle 
				if ( CtrlRST='1' or CtrlStateMach(7 downto 0)="00000000" ) then 
					rRxTPUCtrl0(1)	<= '0';
				-- Rising edge of Established state 
				elsif ( CtrlStateMach(1)='1' ) then 
					rRxTPUCtrl0(1)	<= '1';
				else 
					rRxTPUCtrl0(1)	<= rRxTPUCtrl0(1);
				end if;
				
				-- Bit 2 : DataTransEn 
				-- Reset when state machine in Closing, CloseWait or Timewait state 
				-- Meaning that not in Established, FinWait1 and FinWait2 
				if ( CtrlRST='1' or (CtrlStateMach(5 downto 4)="00" 
					and CtrlStateMach(1)='0') ) then 
					rRxTPUCtrl0(2)	<= '0';
				-- Rising edge of Established state 
				elsif ( CtrlStateMach(1)='1' ) then 
					rRxTPUCtrl0(2)	<= '1';
				else 
					rRxTPUCtrl0(2)	<= rRxTPUCtrl0(2);
				end if;
			end if;
		end if;
	End Process u_rRxTPUCtrl;
	
-----------------------------------------------------------
-- Expected sequence number process 

	-- Receiving a packet with payload (in Data transfer state)
	u_rRxTPUPktVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxTPUPktVal	<= '0';
			else 
				if ( Rx2TPUPktValid='1' and Rx2TPUSeqNumError='0' 
					and rRxTPUCtrl0(2)='1' and Rx2TPUPayloadLen/=0 ) then 
					rRxTPUPktVal	<= '1';
				else 
					rRxTPUPktVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxTPUPktVal;
	
	u_rRxTPUFinPktVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxTPUFinPktVal( 4 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rRxTPUFinPktVal( 4 downto 1 )	<= rRxTPUFinPktVal( 3 downto 0 );
				if ( Rx2TPUPktValid='1' and Rx2TPUSeqNumError='0' 
					and rRxTPUCtrl0(2)='1' and Rx2TPUFinFlag='1' ) then 
					rRxTPUFinPktVal(0)	<= '1';
				else 
					rRxTPUFinPktVal(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxTPUFinPktVal;
	
	-- Expected sequence number of next packet (Acknowledgement number to transmit)  
	u_rRxTPUExpSeqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Latch from header of receiving packet 
			if ( rAckNumInitEn(1 downto 0)="01" ) then 
				rRxTPUExpSeqNum(31 downto 0 )	<= Rx2TPUSeqNum(31 downto 0 );
			-- SYN or ACK packet Received
			elsif ( rTimerCtrlSynAcked='1' or rRxTPUFinPktVal(0)='1' ) then 
				rRxTPUExpSeqNum(31 downto 0 )	<= rRxTPUExpSeqNum(31 downto 0 ) + 1;
			-- Data transferred with payload : Increment sequence number with length of payload 
			elsif ( rRxTPUPktVal='1' ) then 
				rRxTPUExpSeqNum(31 downto 0 )	<= rRxTPUExpSeqNum(31 downto 0 ) + Rx2TPUPayloadLen(15 downto 0 );
			else 
				rRxTPUExpSeqNum(31 downto 0 )	<= rRxTPUExpSeqNum(31 downto 0 );
			end if;
		end if;
	End Process u_rRxTPUExpSeqNum;

-----------------------------------------------------------
-- Out-of-order packet detection process 
-- Receiving unexpected sequence number (e.g. Receiving seqnum > ExpSeqNum 
-- or Receiving seqnum < ExpSeqNum) 
	
	-- Receiving seqnum > ExpSeqNum : Jumped packet 
	u_rJumpedPktEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then	
				rJumpedPktEn	<= '0';
			else 
				if ( rRxTPUCtrl0(1)='1' and rRx2TPUPktValidFF(0)='1'
					and rExpSeqNumCal(31 downto 16)=x"FFFF" ) then 
					rJumpedPktEn	<= '1';
				else 
					rJumpedPktEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rJumpedPktEn;
	
	-- Receiving seqnum < ExpSeqNum : DupACK 
	u_rDupACKEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then	
				rDupACKEn	<= '0';
			else 
				if ( rRxTPUCtrl0(1)='1' and rRx2TPUSeqNumErrorFF(0)='1' 
					and rRx2TPUPktValidFF(0)='1' and rExpSeqNumCal(31 downto 16)=x"0000" ) then 
					rDupACKEn	<= '1';
				else 
					rDupACKEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rDupACKEn;
	
-----------------------------------------------------------
-- Initial packet security process 
	
	-- Acknowledgement number validation 
	u_rAckNumInitEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAckNumInitEn( 3 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rAckNumInitEn( 3 downto 1 )	<= rAckNumInitEn(2 downto 0);
				-- Reset when Idle 
				if ( rAckNumInitEn(3)='1' ) then 
					rAckNumInitEn(0)	<= '0';
				-- Set : First packet that received in SYNSENT state which is SYN&ACK 
				-- and delayed 1 Clk to sync with SYN packet timer in RxTPUTimer 
				elsif ( rRx2TPUPktValidFF(0)='1' and Rx2TPUSynFlag='1'
					and Rx2TPUAckFlag='1' and CtrlStateMach(0)='1' and rCPktSet(0)='1' ) then 
					rAckNumInitEn(0)	<= '1';
				else 
					rAckNumInitEn(0)	<= rAckNumInitEn(0);
				end if;
			end if;
		end if;
	End Process u_rAckNumInitEn;
	
	-- Acknowledgement number validatation 
	u_rAckNumVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAckNumVal	<= '0';
			else 
				if ( CtrlStateMach(7 downto 0)=x"00" ) then 
					rAckNumVal	<= '0';
				-- Timer Acked SYN-Sent packet 
				elsif ( rAckNumInitEn(3 downto 0)="1111" and rTimerCtrlSynAcked='1' ) then 
					rAckNumVal	<= '1';
				else 
					rAckNumVal	<= rAckNumVal;
				end if;
			end if;
		end if;
	End Process u_rAckNumVal;
	
-----------------------------------------------------------
-- 3-DupACK Received retransmission process 
	
	-- Only ACK packet receiving 
	u_rAckPktEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then	
				rAckPktEn( 2 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rAckPktEn(2)	<= rAckPktEn(1);
				rAckPktEn(1)	<= rAckPktEn(0);
				if ( rRxTPUCtrl0(1)='1' and rRx2TPUPktValidFF(0)='1' and rRx2TPUSeqNumErrorFF(0)='0'
					and Rx2TPUPayloadLen=0 and Rx2TPUAckFlag='1' 
					and Rx2TPUPshFlag='0' and Rx2TPURstFlag='0'
					and Rx2TPUSynFlag='0' and Rx2TPUFinFlag='0' ) then 
					rAckPktEn(0)	<= '1';
				else 
					rAckPktEn(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAckPktEn;
	
	-- Bit 0	-> Check whether it can be retransmit or not 
	-- Bit 1	-> Cehck whether it is the same AckNum as previous one or not 
	u_rAckPktCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAckPktCtrl( 1 downto 0 )	<= (others=>'0');
			else 
				-- Check overflow of rAckNumCal : Acked seqnum - seqnum < 0 
				if ( rAckPktEn(0)='1' and rAckNumCal(31 downto 16)=x"FFFF" ) then 
					rAckPktCtrl(0)	<= '1';
				else 
					rAckPktCtrl(0)	<= '0';
				end if;
				
				-- Check same Acknowledgement number 
				if ( rAckPktEn(0)='1' and rAckNumChangeCal=0 ) then 
					rAckPktCtrl(1)	<= '1';
				else 
					rAckPktCtrl(1)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAckPktCtrl; 
	
	-- Receiving the same ACK packet counter  
 	u_rAckPktCtrlCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 		
			-- Increment when same AckNum received
			if ( rAckPktCtrl(1 downto 0)="11" ) then 
				rAckPktCtrlCnt( 1 downto 0 )	<= rAckPktCtrlCnt( 1 downto 0 ) + 1;
			-- Reset when AckNum Change 
			elsif ( rAckPktEn(1)='1' or rAckNumVal='0' ) then 
				rAckPktCtrlCnt( 1 downto 0 )	<= (others=>'0');
			else 
				rAckPktCtrlCnt( 1 downto 0 )	<= rAckPktCtrlCnt( 1 downto 0 );
			end if;
		end if;
	End Process u_rAckPktCtrlCnt;
	
	-- 3 ACK Retransmission requesting to retransmit payload  
	u_rAckPktRetrans : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAckPktRetrans	<= '0';
			else 
				-- 3 Acknowledgement packet received 
				if ( rAckPktEn(2)='1' and rAckPktCtrlCnt=2 
					and rCPktIdent(1 downto 0)/="01" ) then 
					rAckPktRetrans	<= '1';
				else 
					rAckPktRetrans	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAckPktRetrans;
	
	-- 3 ACK Retransmission requesting to retransmit fin packet 
	u_rAckPktRetransFin : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAckPktRetransFin	<= '0';
			else 
				-- 3 Acknowledgement packet received 
				if ( rAckPktEn(2)='1' and rAckPktCtrlCnt=2 
					and rCPktIdent(1 downto 0)="01" ) then 
					rAckPktRetransFin	<= '1';
				else 
					rAckPktRetransFin	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAckPktRetransFin;

-----------------------------------------------------------
-- Control packet : SYN & FIN & Payload  
	
	-- Session control 
	-- Set SYN packet Control 
	u_rCPktSet : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCPktSet( 1 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rCPktSet(1)	<= rCPktSet(0);
				if ( CtrlRST='1' or CtrlStateMach(0)='0' or rTimerRst='1' ) then 
					rCPktSet(0)	<= '0';	
				elsif ( Tx2RxTPUCtrl(2)='1' ) then 
					rCPktSet(0)	<= '1';
				else 
					rCPktSet(0)	<= rCPktSet(0);
				end if;
			end if;
		end if;
	End Process u_rCPktSet;
	
	-- Last FIN Packet for ack detection
	-- Or SYN Packet 
	u_rCPktIdent : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 	
				rCPktIdent( 1 downto 0 )	<= "00";	
			else 	
				-- SYN: Bit 1
				if ( (rTimerRst='1' and rTimerPktAcked='1') or CtrlStateMach(0)='0' ) then 
					rCPktIdent(1)	<= '0';
				-- Rising edge of SYN packet sent 
				elsif ( rCPktSet(1 downto 0)="01" ) then  
					rCPktIdent(1)	<= '1';	
				else 
					rCPktIdent(1)	<= rCPktIdent(1); 
				end if;
				
				-- FIN: Bit 0 
				if ( (rTimerRst='1' and rTimerPktAcked='1') or (CtrlStateMach(3)='0' 
					and CtrlStateMach(4)='0' and CtrlStateMach(6)='0') ) then 
					rCPktIdent(0)	<= '0';
				-- Sent FIN Packet (that's not retransmission packet)
				elsif ( rTimerSet(2)='1' ) then  
					rCPktIdent(0)	<= '1';	
				else 
					rCPktIdent(0)	<= rCPktIdent(0); 
				end if;
			end if;
		end if;
	End Process u_rCPktIdent;
	
	-- FIN Packet or Data Packet (That is not a retransmission packet)
	u_rCPktSeqNumUdt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCPktSeqNumUdt( 4 downto 0 )	<= (others=>'0');
			else
				-- Bit 4: FF signal from Bit 3 
				rCPktSeqNumUdt(4)	<= rCPktSeqNumUdt(3);
				
				-- Bit 3: Check whether the AckNum is valid or not 
				-- Used to set timer 
				if ( rCPktSeqNumUdt(1)='1' and rAckNumVal='1' ) then 
					rCPktSeqNumUdt(3)	<= '1';
				else 
					rCPktSeqNumUdt(3)	<= '0';
				end if; 
				
				-- Bit 2: Check whether the SeqNum has incremented or not 
				if ( rCPktSeqNumUdt(1)='1' and rAckNumVal='1' 
					and rCPktRefSeqNumCal(31 downto 16)=x"FFFF" ) then 
					rCPktSeqNumUdt(2)	<= '1';
				else 
					rCPktSeqNumUdt(2)	<= '0';
				end if;
				
				-- Bit 1: FF signal from Bit 0 
				rCPktSeqNumUdt(1)	<= rCPktSeqNumUdt(0);
				
				-- Bit 0: Sent Packet 
				if ( Tx2RxTPUCtrl(0)='1' ) then
					rCPktSeqNumUdt(0)	<= '1';
				else 
					rCPktSeqNumUdt(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCPktSeqNumUdt;
	
-----------------------------------------------------------
-- Timer : Timeout-based retransmission 	

	-- Set Timer signal 
	u_rTimerSet : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerSet( 2 downto 0 )	<= "000";
			else 
				-- Using FF signal 
				rTimerSet(2)	<= rTimerSet(1);
				rTimerSet(1)	<= rTimerSet(0);
				-- Set Timer: if sending SYN or packet that updated seqnum 
				if ( rCPktSeqNumUdt(4)='1' or rCPktSet(1 downto 0)="01" ) then 
					rTimerSet(0)	<= '1';
				else 
					rTimerSet(0)	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rTimerSet;
	
	-- Timeout counter enable 
	u_rTimerCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerCntEn	<= '0';
			else
				-- Timer Reset 
				if ( rTimerRst='1' or CtrlStateMach(6 downto 0)="0000000") then 
					rTimerCntEn	<= '0';
				-- Timer set 
				elsif ( rTimerSet(2)='1' ) then 
					rTimerCntEn	<= '1';
				else 
					rTimerCntEn	<= rTimerCntEn;
				end if;
			end if;
		end if;
	End Process u_rTimerCntEn;
	
	-- Timeout counter 
	u_rTimerCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rTimerCntEn='1' and rTimerCntRst='0' and rTimerSet(2)='0' ) then 
				rTimerCnt(27 downto 0 )	<= rTimerCnt(27 downto 0 ) - 1;
			else 
				--rTimerCnt(27 downto 0 )	<= x"773_5940"; -- Synthesis 1 sec 
				rTimerCnt(27 downto 0 )	<= x"000_07D0"; -- Simulation 2000 Clk 
			end if;
		end if;
	End Process u_rTimerCnt;
	
	-- Reset Timer operations
	-- Payload ACK with exact acknum (acknum = Seqnum)  
	u_rTimerPktAcked : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerPktAcked	<= '0';
			else 
				if ( (rAckNumVal='1' or rAckNumInitEn(0)='1') and rAckNumCal=0 ) then 
					rTimerPktAcked	<= '1';
				else 
					rTimerPktAcked	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTimerPktAcked;
	
	-- AckNum change detecting signal   
	u_rTimerAckChangeEn : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerAckChangeEn	<= '0';
			else  
				if ( rRx2TPUPktValidFF(0)='1' and rRx2TPUSeqNumErrorFF(0)='0'
					and Rx2TPUAckFlag='1' and rRxTPUCtrl0(1)='1' ) then 
					rTimerAckChangeEn	<= '1';
				else 
					rTimerAckChangeEn	<= '0';	
				end if;
			end if;
		end if;
	End Process u_rTimerAckChangeEn;
	
	-- Payload ACK with inexact acknum (acknum < Seqnum) 
	u_rTimerCntRst : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerCntRst	<= '0';
			else 
				-- Acknum Changing detected 
				if ( rAckNumChangeCal(31 downto 16)=x"FFFF" and rTimerAckChangeEn='1' ) then 
					rTimerCntRst	<= '1';
				else 
					rTimerCntRst	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTimerCntRst;
	
	-- Timeout 
	u_rTimerExpired : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerExpired( 1 downto 0 )	<= "00";
			else 
				-- FF signal 
				rTimerExpired(1)	<= rTimerExpired(0);
				if ( rTimerExpired(1)='1') then 
					rTimerExpired(0)	<= '0';
				-- Timeout 
				elsif ( rTimerCnt=1 and rTimerCntEn='1' ) then 
					rTimerExpired(0)	<= '1';
				else 
					rTimerExpired(0)	<= rTimerExpired(0);
				end if;
			end if;
		end if;
	End Process u_rTimerExpired;
	
	-- Timer Reset 
	u_rTimerRst : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerRst	<= '0';
			else 
				if ( rTimerPktAcked='1' 
					or rTimerCtrlRetransOp(2 downto 0)/="000"  ) then 
					rTimerRst	<= '1';
				else
					rTimerRst	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTimerRst;
	
-----------------------------------------------------------
-- Sequence number and Acknowledgement number calculator 

	-- Reference SeqNum : The highest sequence number that ever sent
	u_rCPktRefSeqNum : process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialization (rising edge of SYN set)
			if ( (rCPktSet(1 downto 0)="01" and rCPktIdent(1 downto 0)="00")
				-- FIN Packet or Data Packet (That is not a retransmission packet)
				or rCPktSeqNumUdt(2)='1' ) then 
				rCPktRefSeqNum( 31 downto 0 )	<= Tx2RxTPUSeqNum(31 downto 0 );
			else 
				rCPktRefSeqNum( 31 downto 0 )	<= rCPktRefSeqNum( 31 downto 0 ); 
			end if;
		end if;
	End Process u_rCPktRefSeqNum; 

	-- Expected sequnce number - Receiving sequnce number 
	u_rExpSeqNumCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rExpSeqNumCal(31 downto 0 )	<= rRxTPUExpSeqNum(31 downto 0 ) - Rx2TPUSeqNum(31 downto 0 );
		end if;
	End Process u_rExpSeqNumCal;
	
	u_rAckNumCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			-- Sending data with new Seqnum : RefSeqNum - TxSeqNum < 0 
			rCPktRefSeqNumCal(31 downto 0 )	<= rCPktRefSeqNum(31 downto 0 ) - Tx2RxTPUSeqNum(31 downto 0 );
			-- Receiving Acknum - seqnum < 0 
			rAckNumCal(31 downto 0 )		<= rRx2TPUAckNumFF(31 downto 0 ) - rCPktRefSeqNum( 31 downto 0 );
			-- Differential of Acknowledgement number (old - new)
			rAckNumChangeCal(31 downto 0 ) 	<= rRx2TPUAckNumFF(63 downto 32) - rRx2TPUAckNumFF(31 downto 0 );
		end if;
	End Process u_rAckNumCal;

-----------------------------------------------------------
-- AckNum error 

	-- if Receiving ACKnum is greater than or equal to Reference SeqNum (>=)
	u_rRxTPURecvErr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then  
				rRxTPURecvErr	<= '0';
			else 
				if ( (rAckNumVal='1' or rAckNumInitEn(0)='1') and rAckNumCal(31 downto 16)=x"0000" ) then 
					rRxTPURecvErr	<= '1';
				else 
					rRxTPURecvErr	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxTPURecvErr;
	
-----------------------------------------------------------
-- Timer control output 

	-- SYN Packet Acked 
	u_rTimerCtrlSynAcked : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerCtrlSynAcked	<= '0';
			else 
				if ( rCPktIdent(1 downto 0)="10" and rTimerRst='1'
					and rTimerPktAcked='1' ) then 
					rTimerCtrlSynAcked	<= '1';
				else 
					rTimerCtrlSynAcked	<= '0';
				end if;
			end if;
		end if; 
	End Process u_rTimerCtrlSynAcked; 
	
	-- FIN Packet Acked 
	u_rTimerCtrlFinAcked : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerCtrlFinAcked	<= '0';
			else 
				if ( rCPktIdent(1 downto 0)="01" and rTimerRst='1' 
					and rTimerPktAcked='1' ) then 
					rTimerCtrlFinAcked	<= '1';
				else 
					rTimerCtrlFinAcked	<= '0';
				end if;
			end if;
		end if; 
	End Process u_rTimerCtrlFinAcked; 
	
	-- Timeout-based retransmission Option 
	-- "00"	-> Payload
	-- "01"	-> SYN 
	-- "10"	-> FIN 
	u_rTimerCtrlRetransOp : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimerCtrlRetransOp( 2 downto 0 )	<= (others=>'0');
			else 
				-- SYN Retransmission
				if ( rTimerExpired(0)='1' and rCPktIdent(1 downto 0)="10" ) then 
					rTimerCtrlRetransOp(0)	<= '1';
				else 
					rTimerCtrlRetransOp(0)	<= '0';
				end if;
				
				-- FIN Retransmission
				if ( rTimerExpired(0)='1' and rCPktIdent(1 downto 0)="01" ) then 
					rTimerCtrlRetransOp(1)	<= '1';
				else 
					rTimerCtrlRetransOp(1)	<= '0';
				end if;
				
				-- Payload Retransmission
				if ( rTimerExpired(0)='1' and rCPktIdent(1 downto 0)="00" ) then 
					rTimerCtrlRetransOp(2)	<= '1';
				else 
					rTimerCtrlRetransOp(2)	<= '0';
				end if;
				
			end if;
		end if;
	End Process u_rTimerCtrlRetransOp;

-----------------------------------------------------------
-- Output generator to TxTPU 
	
	-- Requesting to retransmit SYN, FIN or payload packet 
	u_rRxTPURetransReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxTPURetransReq( 2 downto 0 )	<= (others=>'0');
			else 
				-- Bit 0 	-> SYN Retransmission 
				if ( CtrlRST='1' or CtrlStateMach(0)='0' or Tx2RxTPURetransEn(0)='1' ) then 
					rRxTPURetransReq(0)	<= '0';
				elsif ( rTimerCtrlRetransOp(0)='1' ) then 
					rRxTPURetransReq(0)	<= '1';
				else 
					rRxTPURetransReq(0)	<= rRxTPURetransReq(0);
				end if;
				
				-- Bit 1 	-> FIN Retransmission 
				if ( CtrlRST='1' or rAckNumVal='0' or Tx2RxTPURetransEn(1)='1' ) then 
					rRxTPURetransReq(1)	<= '0';
				elsif ( rTimerCtrlRetransOp(1)='1' or rAckPktRetransFin='1' ) then 
					rRxTPURetransReq(1)	<= '1';
				else 
					rRxTPURetransReq(1)	<= rRxTPURetransReq(1);
				end if;
				
				-- Bit 2 	-> Payload Retransmission 
				if ( CtrlRST='1' or rAckNumVal='0' or Tx2RxTPURetransEn(3)='1' ) then 
					rRxTPURetransReq(2)	<= '0';
				-- 3-ACK received or Timeout-based retransmission 
				elsif ( rTimerCtrlRetransOp(2)='1' or rAckPktRetrans='1' ) then 
					rRxTPURetransReq(2)	<= '1';
				else 
					rRxTPURetransReq(2)	<= rRxTPURetransReq(2);
				end if;
			end if;
		end if;
	End Process u_rRxTPURetransReq;
	
	-- Requesting to send 3 ACK due to out-of-order packet
	u_rRxTPUAckRetransReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 	
				rRxTPUAckRetransReq	<= '0';
			else 
				-- Sent 3 ACK 
				if ( CtrlRST='1' or Tx2RxTPURetransEn(2)='1' or rAckNumVal='0' ) then 
					rRxTPUAckRetransReq	<= '0';
				-- Jumped packet detected 
				elsif ( rJumpedPktEn='1' and rRxTPUCtrl0(2)='1' ) then 
					rRxTPUAckRetransReq	<= '1';
				else 
					rRxTPUAckRetransReq	<= rRxTPUAckRetransReq;
				end if;
			end if;
		end if;
	End Process u_rRxTPUAckRetransReq;
	
	-- Acknowledgement number has been updated or received Dup-Pkt or SYN&FIN Received 
	u_rRxTPUAckNumUdt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRxTPUAckNumUdt	<= '0';
			else 
				if ( rRxTPUPktVal='1' or rDupACKEn='1' 
					or rTimerCtrlSynAcked='1' or rRxTPUFinPktVal(2)='1' ) then 
					rRxTPUAckNumUdt	<= '1';
				else 
					rRxTPUAckNumUdt	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxTPUAckNumUdt;

-----------------------------------------------------------
-- Output generator to StateCtrl 
	
	u_rCtrlFlags : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlFlags( 8 downto 0 )	<= (others=>'0');
			else 
				-- NOT USED 
				rCtrlFlags( 8 downto 5 )	<= (others=>'0');
				
				-- Bit 4 : Acknowledgement 
					-- Acked SYN or FIN packet 
				if ( rTimerCtrlSynAcked='1' or rTimerCtrlFinAcked='1' ) then 
					rCtrlFlags(4)	<= '1';
				else 
					rCtrlFlags(4)	<= '0';
				end if;
				
				-- Bit 3 : PSH Data 
				if ( rRx2TPUPktValidFF(1)='1' and rRx2TPUSeqNumErrorFF(1)='0'
					and Rx2TPUPshFlag='1' and rRxTPUCtrl0(2)='1' ) then 
					rCtrlFlags(3)	<= '1';
				else 
					rCtrlFlags(3)	<= '0';
				end if;
				
				-- Bit 2 : RST 
				-- Initial State or SeqNumerror='0' 
				if ( rRx2TPUPktValidFF(1)='1' and Rx2TPURstFlag='1' 
					and (rRx2TPUSeqNumErrorFF(1)='0' or CtrlStateMach(0)='1') ) then 
					rCtrlFlags(2)	<= '1';
				else 
					rCtrlFlags(2)	<= '0';
				end if;
				
				-- Bit 1 : SYN 
				-- Acked SYN packet in SYNSent state, syncing with ACK flag 
				if ( rTimerCtrlSynAcked='1' ) then 
					rCtrlFlags(1)	<= '1';
				else 
					rCtrlFlags(1)	<= '0';
				end if;
				
				-- Bit 0 : FIN 
				-- Receiving FIN Flags, syncing with ACK flag 
				if ( rRxTPUFinPktVal(4)='1' ) then 
					rCtrlFlags(0)	<= '1';
				else 
					rCtrlFlags(0)	<= '0';
				end if;
				
			end if;			
		end if;
	End Process u_rCtrlFlags;
	
	u_rCtrlRxError : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlRxError	<= '0';
			else 
				-- Bit 0: Receiving AckNum is greater than Reference SeqNum 
				if ( rRxTPURecvErr='1' and rTimerPktAcked='0' ) then 
					rCtrlRxError	<= '1';
				else
					rCtrlRxError	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rCtrlRxError;
	
End Architecture rtl;