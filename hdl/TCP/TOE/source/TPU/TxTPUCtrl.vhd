----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxTPUCtrl.vhd
-- Title        TxTPUCtrl For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/11/04
-- Syntax       VHDL
-- Description      
-- 
-- TCP/IP trasmission control of TCP Processing Unit  
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

Entity TxTPUCtrl Is
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
		CtrlDataEn				: in 	std_logic;
		CtrlRST					: in 	std_logic;

		CtrlLastSent			: out	std_logic;
		
		-- RxCtrl I/F 
		Rx2TxTPUAckNum			: in	std_logic_vector(31 downto 0 );
		Rx2TxTPUSeqNumAcked		: in	std_logic_vector(31 downto 0 );
		Rx2TxTPURecWindow		: in	std_logic_vector(15 downto 0 );
		Rx2TxTPUWindow			: in	std_logic_vector(15 downto 0 );
		Rx2TxTPURetransOption	: in	std_logic_vector( 3 downto 0 );
		Rx2TxTPUAckNumUdt 		: in	std_logic;
		Rx2TxTPUSeqNumEn		: in	std_logic;

		Tx2RxTPUSeqNum			: out	std_logic_vector(31 downto 0 );
		Tx2RxTPUCtrl			: out	std_logic_vector( 3 downto 0 );
		Tx2RxTPURetransEn		: out 	std_logic_vector( 3 downto 0 );
		
		-- TxTCPIP I/F 
		Tx2TPUPayloadLen		: in 	std_logic_vector(15 downto 0 );
		Tx2TPUPayloadReq   		: in 	std_logic; 
		Tx2TPUOpReply			: in	std_logic;
		Tx2TPUInitReady			: in 	std_logic;
		Tx2TPULastData			: in	std_logic;
		Tx2TPUTxCtrlBusy 		: in 	std_logic;
		
		TPU2TxMACSouAddr		: out	std_logic_vector(47 downto 0 );
		TPU2TxMACDesAddr		: out 	std_logic_vector(47 downto 0 );
		TPU2TxIPSouAddr			: out 	std_logic_vector(31 downto 0 );
		TPU2TxIPDesAddr			: out 	std_logic_vector(31 downto 0 );
		TPU2TxSouPort			: out 	std_logic_vector(15 downto 0 );
		TPU2TxDesPort			: out 	std_logic_vector(15 downto 0 );	
		TPU2TxSeqNum			: out	std_logic_vector(31 downto 0 );
		TPU2TxAckNum			: out	std_logic_vector(31 downto 0 );
		TPU2TxDataOffset		: out 	std_logic_vector( 3 downto 0 );
		TPU2TxFlags				: out	std_logic_vector( 8 downto 0 );
		TPU2TxWindow			: out 	std_logic_vector(15 downto 0 );
		TPU2TxUrgent			: out 	std_logic_vector(15 downto 0 );
		-- Control I/F	
		TPU2TxSeqNumIndex		: out 	std_logic_vector(31 downto 0 );	
		TPU2TxSeqNumIndexEn 	: out 	std_logic;	
		TPU2TxOperations		: out 	std_logic_vector( 3 downto 0 );			
		TPU2TxReset				: out 	std_logic;		
		TPU2TxTxReq 			: out 	std_logic;			
		TPU2TxPayloadEn			: out 	std_logic
	);
End Entity TxTPUCtrl;	
	
Architecture rtl Of TxTPUCtrl Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------

	Component LFSR Is
	Port 
	(
		Clk				: in	std_logic;

		RandWordBinary	: out 	std_logic_vector(31 downto 0 )
	);               
	End Component LFSR;   
	
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- StateCtrl I/F 
	signal	rCtrlStateMach0			: std_logic_vector(  7 downto 0 );
	
	-- RxTPU I/F 
	signal  rRx2TxTPUAckNumFF		: std_logic_vector(159 downto 0 );
	signal  rRx2TxTPUWindowFF		: std_logic_vector( 95 downto 0 );
	signal  rRx2TxTPURetransOptionFF: std_logic_vector(  3 downto 0 );
	signal  rRx2TxTPUAckNumUdtFF	: std_logic_vector(  1 downto 0 );
	
	-- TxTCPIP I/F 
	signal	rTxTPUSeqNum			: std_logic_vector( 31 downto 0 );
	signal  rTxTPUAckNum            : std_logic_vector( 31 downto 0 );
	signal  rTxTPUSeqNumInit		: std_logic_vector( 31 downto 0 );
	signal	rTxTPUExpSeqNum			: std_logic_vector( 31 downto 0 );
	signal	rTxTPUWindowCal			: std_logic_vector( 31 downto 0 );
	signal	rTxTPUFlowCtrlCal		: std_logic_vector( 31 downto 0 );
	signal  rTxTPUFlags				: std_logic_vector(  8 downto 0 ); 
	signal	rTxTCPCtrl				: std_logic_vector(  5 downto 0 );
	signal  rTxTCPCtrlSel0			: std_logic_vector(  5 downto 0 );
	signal  rTxTCPCtrlSel1			: std_logic_vector(  5 downto 0 );
	signal	rTx2RxTPURetransEn		: std_logic_vector(  3 downto 0 );
	signal	rTx2RxTPURetransEnFF	: std_logic_vector(  3 downto 0 );
	signal  rTxTPUFlowCtrl			: std_logic_vector(  1 downto 0 );
	signal	rTxTPURxNakCnt			: std_logic_vector(  1 downto 0 );
	signal  rTxTPUInit				: std_logic;
	signal  rTxTPUEstablished		: std_logic;
	signal  rTxTCPTerminated		: std_logic;
	signal  rTxTPURetrans			: std_logic;
	signal 	rTxTPUTxReq				: std_logic;
	signal  rTxTPUPayloadEn			: std_logic;
	signal  rTx2TPULastDataFF		: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- TPU to TxTCPIP I/F 
	TPU2TxMACSouAddr(47 downto 0 )		<= CtrlSenderMACAddr(47 downto 0 );	 	
	TPU2TxMACDesAddr(47 downto 0 )	    <= CtrlTargetMACAddr(47 downto 0 );	
	TPU2TxIPSouAddr(31 downto 0 )		<= CtrlSenderIpAddr(31 downto 0 );	
	TPU2TxIPDesAddr(31 downto 0 )		<= CtrlTargetIpAddr(31 downto 0 );	
	TPU2TxSouPort(15 downto 0 )		    <= CtrlSrcPort(15 downto 0 );     	
	TPU2TxDesPort(15 downto 0 )		    <= CtrlDesPort(15 downto 0 );     	
	TPU2TxSeqNum(31 downto 0 )		    <= rTxTPUSeqNum(31 downto 0 );
	TPU2TxAckNum(31 downto 0 )		    <= rTxTPUAckNum(31 downto 0 );
	TPU2TxDataOffset( 3 downto 0 )	    <= "0101";	-- Fixed Header 
 	TPU2TxFlags( 8 downto 0 )		    <= rTxTPUFlags( 8 downto 0 );
	TPU2TxWindow(15 downto 0 )		    <= rRx2TxTPUWindowFF(95 downto 80);
	TPU2TxUrgent(15 downto 0 )		    <= (others=>'0');
	
	TPU2TxSeqNumIndex(31 downto 0 )		<= Rx2TxTPUSeqNumAcked(31 downto 0 );		
	TPU2TxSeqNumIndexEn               	<= Rx2TxTPUSeqNumEn;
	TPU2TxOperations(3)	    			<= rTxTCPTerminated;
	TPU2TxOperations(2)	    			<= rTxTPURetrans;
	TPU2TxOperations(1)	    			<= rTxTPUInit;
	TPU2TxOperations(0)	    			<= CtrlDataEn;
	TPU2TxReset			                <= CtrlRST;
	TPU2TxTxReq 		                <= rTxTPUTxReq;
	TPU2TxPayloadEn		                <= rTxTPUPayloadEn;
	
	-- RxTPU I/F
	Tx2RxTPUSeqNum(31 downto 0 )	    <= rTxTPUSeqNum(31 downto 0 );
	Tx2RxTPUCtrl(3)						<= rTxTPUFlags(0); -- FIN 
	Tx2RxTPUCtrl(2)						<= rTxTPUFlags(1); -- SYN 
	Tx2RxTPUCtrl(1)						<= rTxTPUPayloadEn;
	Tx2RxTPUCtrl(0)						<= rTxTPUTxReq;
	Tx2RxTPURetransEn(3)				<= rTxTPURetrans;
	Tx2RxTPURetransEn(2)				<= rTx2RxTPURetransEn(2);
	Tx2RxTPURetransEn(1)				<= rTx2RxTPURetransEn(1);
	Tx2RxTPURetransEn(0)				<= rTx2RxTPURetransEn(0);
	
	-- StateCtrl I/F 
	CtrlLastSent	                    <= Tx2TPULastData;	
	
----------------------------------------------------------------------------------
-- DFF : Component Mapping 
----------------------------------------------------------------------------------
	
	u_rLFSR : LFSR
	Port map
	(
		Clk					=> Clk			,
	
		RandWordBinary		=> rTxTPUSeqNumInit		
	);
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------	
-----------------------------------------------------------
-- FF signal   
	
	u_FFInputSignal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 	
				rCtrlStateMach0( 7 downto 0 )			<= (others=>'0');
				rRx2TxTPUAckNumUdtFF( 1 downto 0 )		<= (others=>'0');
				rRx2TxTPURetransOptionFF( 3 downto 0 )	<= (others=>'0');
				rTx2TPULastDataFF						<= '0';
			else 
				rCtrlStateMach0( 7 downto 0 ) 			<= CtrlStateMach( 7 downto 0 ); 
				rRx2TxTPUAckNumUdtFF( 1 downto 0 )		<= rRx2TxTPUAckNumUdtFF(0)&Rx2TxTPUAckNumUdt;
				rRx2TxTPURetransOptionFF( 3 downto 0 )	<= Rx2TxTPURetransOption( 3 downto 0 );
				rTx2TPULastDataFF						<= Tx2TPULastData;
			end if;
		end if;
	End Process u_FFInputSignal;

-----------------------------------------------------------
-- TxTCPCtrl Control signal 
	
	-- Bit 0		-> Requesting to send SYN Packet  
	-- Bit 1 	-> Requesting to send FIN Packet 
	-- Bit 2		-> Requesting to send 3 ACK  
	-- Bit 3 	-> Requesting to retransmit data 
	-- Bit 4 	-> Requesting to send Packet with payload
	-- Bit 5 	-> Requesting to send ACK packet 
	u_rTxTCPCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 	
			if ( RstB='0' ) then 
				rTxTCPCtrl( 5 downto 0 )	<= (others=>'0');
			else 
				-- Bit 0 : SYN 
				if ( rTx2RxTPURetransEn(0)='1' or CtrlRST='1' ) then 
					rTxTCPCtrl(0)	<= '0';
					-- initiated 
				elsif ( (rTxTPUInit='1' and Tx2TPUInitReady='1') 
					-- Retransmission of SYN Packet 
					or Rx2TxTPURetransOption(0)='1' ) then
					rTxTCPCtrl(0)	<= '1';
				else 
					rTxTCPCtrl(0)	<= rTxTCPCtrl(0);
				end if;
				
				-- Bit 1 : FIN 
				if ( rTx2RxTPURetransEn(1)='1' or CtrlRST='1' ) then 
					rTxTCPCtrl(1)	<= '0';
					-- Rising edge of LastACK State 
				elsif ( (CtrlStateMach(3)='1' and rCtrlStateMach0(3)='0') 
					-- Rising edge of FinWait1 State 
					or (CtrlStateMach(4)='1' and rCtrlStateMach0(4)='0')  
					-- Retransmission of FIN packet 
					or Rx2TxTPURetransOption(1)='1' ) then 
					rTxTCPCtrl(1)	<= '1';
				else 
					rTxTCPCtrl(1)	<= rTxTCPCtrl(1);
				end if;	
				
				-- Bit 2 : 3 ACK  
				if ( rTx2RxTPURetransEn(2)='0' and Rx2TxTPURetransOption(2)='1' ) then 
					rTxTCPCtrl(2)	<= '1';
				else 
					rTxTCPCtrl(2)	<= '0';
				end if;	
				
				-- Bit 3 : retransmit data   
				if ( rTxTPURetrans='1' or CtrlRST='1' ) then 
					rTxTCPCtrl(3)	<= '0';
				-- Detect rising edge of Option 3 : Retransmission 
				elsif ( Rx2TxTPURetransOption(3)='1' and rRx2TxTPURetransOptionFF(3)='0' ) then 
					rTxTCPCtrl(3)	<= '1'; 
				else 
					rTxTCPCtrl(3)	<= rTxTCPCtrl(3);
				end if;	
				
				-- Bit 4 : Send Payload   
				if (rTxTCPCtrlSel1(5 downto 0)/="000000" or CtrlRST='1'
					or rTx2RxTPURetransEnFF(3)='1' or rTx2RxTPURetransEn(3)='1' ) then 
					rTxTCPCtrl(4)	<= '0';
				elsif ( Tx2TPUPayloadReq='1' and rTxTPUFlowCtrl(1)='1' 
					and rTxTPUEstablished='1' and rTxTPUFlowCtrlCal(31 downto 16)=0 ) then 
					rTxTCPCtrl(4)	<= '1';
				else
					rTxTCPCtrl(4)	<= rTxTCPCtrl(4);
				end if;
				
				-- Bit 5 : Send ACK  
				-- TxReq has already been set 
				if ( rRx2TxTPUAckNumUdtFF(1)='1' and CtrlRST='0' ) then 
					rTxTCPCtrl(5)	<= '1';
				-- Acknowledgement number has been updated
				elsif ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 1)/="00000" ) then 
					rTxTCPCtrl(5)	<= '0';
				else 
					rTxTCPCtrl(5)	<= rTxTCPCtrl(5);
				end if;
				
			end if;
		end if;
	End Process u_rTxTCPCtrl;
	
	-- Tx Output control selection 
	-- whenever rTxTCPCtrlSel0='1' and rTxTCPCtrlSel1='1' 
	u_rTxTCPCtrlSel	: Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 	
			if ( RstB='0' ) then 
				rTxTCPCtrlSel0( 5 downto 0 )	<= (others=>'0');
				rTxTCPCtrlSel1( 5 downto 0 )	<= (others=>'0');
			else 
				-- rTxTCPCtrlSel0 Filp-Flop 
				rTxTCPCtrlSel1( 5 downto 0 )	<= rTxTCPCtrlSel0( 5 downto 0 );	
				-- rTxTCPCtrlSel0 
				-- Selective : SYN 
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000" ) then 
					rTxTCPCtrlSel0(0)	<= '0';
				elsif ( rTxTCPCtrl(0)='1' and Tx2TPUTxCtrlBusy='0' 
					and rTxTCPCtrlSel0(5 downto 1)="00000" ) then
					rTxTCPCtrlSel0(0)	<= '1'; 
				else 
					rTxTCPCtrlSel0(0)	<= rTxTCPCtrlSel0(0);
				end if;
				
				-- Selective : FIN  
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000" 
					or rTxTCPCtrlSel0(0)='1' ) then 
					rTxTCPCtrlSel0(1)	<= '0';
				elsif ( rTxTCPCtrl(1)='1' and Tx2TPULastData='1' and Tx2TPUTxCtrlBusy='0'
					and rTxTCPCtrlSel0(5 downto 2)="0000" ) then
					rTxTCPCtrlSel0(1)	<= '1';
				else 
					rTxTCPCtrlSel0(1)	<= rTxTCPCtrlSel0(1);
				end if;
				
				-- Selective : 3 ACK  
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000" 
					or rTxTCPCtrlSel0(1 downto 0)/="00" ) then 
					rTxTCPCtrlSel0(2)	<= '0';
				elsif ( rTxTCPCtrl(2)='1' and rTxTCPCtrlSel0(5 downto 3)="000" and Tx2TPUTxCtrlBusy='0' ) then
					rTxTCPCtrlSel0(2)	<= '1';
				else 
					rTxTCPCtrlSel0(2)	<= rTxTCPCtrlSel0(2);
				end if;
				
				-- Selective : Retransmission  
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000" 
					or rTxTCPCtrlSel0(2 downto 0)/="000" ) then 
					rTxTCPCtrlSel0(3)	<= '0';
				elsif ( rTxTCPCtrl(3)='1' and rTxTCPCtrlSel0(5 downto 4)="00" ) then
					rTxTCPCtrlSel0(3)	<= '1';
				else 
					rTxTCPCtrlSel0(3)	<= rTxTCPCtrlSel0(3);
				end if;
				
				-- Selective : Payload 
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000"
					or rTxTCPCtrlSel0(3 downto 0)/="0000" ) then 
					rTxTCPCtrlSel0(4)	<= '0';
				elsif ( rTxTCPCtrl(4)='1' and rTxTCPCtrlSel0(5)='0' ) then
					rTxTCPCtrlSel0(4)	<= '1';
				else 
					rTxTCPCtrlSel0(4)	<= rTxTCPCtrlSel0(4);
				end if;
				
				-- Selective : ACK 
				if ( CtrlRST='1' or rTxTCPCtrlSel1(5 downto 0)/="000000"
					or rTxTCPCtrlSel0(4 downto 0)/="00000" ) then
					rTxTCPCtrlSel0(5)	<= '0';
				elsif ( rTxTCPCtrl(5)='1' ) then
					rTxTCPCtrlSel0(5)	<= '1';
				else 
					rTxTCPCtrlSel0(5)	<= rTxTCPCtrlSel0(5);
				end if;
				
			end if;
		end if;
	End Process u_rTxTCPCtrlSel;
	
	-- Initialization Tx I/F 
	u_rTxTPUInit : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxTPUInit	<= '0';
			else 
				if ( CtrlRST='1' or Tx2TPUInitReady='1' ) then 
					rTxTPUInit	<= '0';
				-- Initialization : Rising edge of SYNSent 
				elsif ( rCtrlStateMach0(0)='0' and CtrlStateMach(0)='1' ) then 
					rTxTPUInit	<= '1';
				else 
					rTxTPUInit	<= rTxTPUInit;
				end if;
			end if;
		end if;
	End Process u_rTxTPUInit;
	
	-- Retransmission signal to TxTCPIP 
	u_rTxTPURetrans : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxTPURetrans	<= '0';
			else 
				if ( Tx2TPUOpReply='1' or CtrlRST='1' ) then 
					rTxTPURetrans	<= '0';
				elsif ( rTxTCPCtrlSel0(3)='1' and rTxTCPCtrlSel1(3)='1' ) then 
					rTxTPURetrans	<= '1';
				else 
					rTxTPURetrans	<= rTxTPURetrans;
				end if;
			end if;
		end if;
	End Process u_rTxTPURetrans;
	
	-- Permission signal to send packet with payload 
	u_rTxTPUEstablished : Process (Clk) Is 
	Begin	
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxTPUEstablished	<= '0';
			else 
				-- Not send any packets with payload 
				if ( rTxTCPTerminated='1' or CtrlRST='1' ) then 
					rTxTPUEstablished	<= '0';
				-- Established State 
				elsif ( CtrlStateMach(1)='1' ) then 
					rTxTPUEstablished	<= '1';
				else 
					rTxTPUEstablished	<= rTxTPUEstablished;
				end if;
			end if;
		end if;
	End Process u_rTxTPUEstablished;
	
	-- Terminated signal to TxTCPTP for disability to send any payload 
	u_rTxTCPTerminated : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxTCPTerminated	<= '0';				
			else 
					-- Detect rising edge of FinWait2 state  
				if ( (CtrlStateMach(5)='1' and rCtrlStateMach0(5)='0')	
					-- FinWait1 to Timewait state 
					or (CtrlStateMach(7)='1' and rCtrlStateMach0(4)='1')
					-- Detect falling edge of closing state   
					or (CtrlStateMach(6)='0' and rCtrlStateMach0(6)='1')	
					-- Detect rising edge of LastACK State 
					or (CtrlStateMach(3)='1' and rCtrlStateMach0(3)='0') ) then 
					rTxTCPTerminated	<= '1';
				else 
					rTxTCPTerminated	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTxTCPTerminated;
	
	-- Authorization to send any TCP packet out off TxTCPIP 
	u_rTxTPUTxReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxTPUTxReq	<= '0';
			else 
				if ( ((rTxTCPCtrlSel0(0)='1' and rTxTCPCtrlSel1(0)='1') 
					or (rTxTCPCtrlSel0(1)='1' and rTxTCPCtrlSel1(1)='1')
					or (rTxTCPCtrlSel0(2)='1' and rTxTCPCtrlSel1(2)='1')
					or (rTxTCPCtrlSel0(4)='1' and rTxTCPCtrlSel1(4)='1')
					or (rTxTCPCtrlSel0(5)='1' and rTxTCPCtrlSel1(5)='1'))
					and CtrlRST='0' ) then 
					rTxTPUTxReq	<= '1';
				else 
					rTxTPUTxReq	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTxTPUTxReq;
	
	-- Sending data with payload 
	u_rTxTPUPayloadEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 	
			if ( RstB='0' ) then 
				rTxTPUPayloadEn	<= '0';
			else 
				if ( rTxTCPCtrlSel0(4)='1' and rTxTCPCtrlSel1(4)='1' ) then 
					rTxTPUPayloadEn	<= '1';
				else 
					rTxTPUPayloadEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTxTPUPayloadEn;
	
	-- Flags of TCP packet
	u_rTxTPUFlags : Process (Clk) Is
	Begin 	
		if ( rising_edge(Clk) ) then 
			-- NOT USED : NS | CWR | ECE | URG 
			rTxTPUFlags( 8 downto 5 )	<= (others=>'0');
			
			-- Bit 4 : ACK 
			-- After Synchronization 
			if ( CtrlStateMach(7 downto 1)="0000000" ) then 
				rTxTPUFlags(4)	<= '0';
			else 
				rTxTPUFlags(4)	<= '1';
			end if;
			
			-- Bit 3 : PSH 
			-- Send any payload 
			if ( rTxTCPCtrlSel0(4)='1' and rTxTCPCtrlSel1(4)='1' ) then 
				rTxTPUFlags(3)	<= '1';
			else 
				rTxTPUFlags(3)	<= '0';
			end if;
			
			-- Bit 2 : RST (NOT USED)
			rTxTPUFlags(2)	<= '0';
			
			-- Bit 1 : SYN 
			if ( rTxTCPCtrlSel0(0)='1' and rTxTCPCtrlSel1(0)='1' )  then 
				rTxTPUFlags(1)	<= '1';
			else 
				rTxTPUFlags(1)	<= '0';
			end if;
			
			-- Bit 0 : FIN  
			if ( rTxTCPCtrlSel0(1)='1' and rTxTCPCtrlSel1(1)='1' )  then 
				rTxTPUFlags(0)	<= '1';
			else 
				rTxTPUFlags(0)	<= '0';
			end if;
			
		end if;
	End Process u_rTxTPUFlags;
	
	-- Flow control 
	u_rTxTPUFlowCtrl : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 	
				rTxTPUFlowCtrl( 1 downto 0 )	<= (others=>'0');
			else 
				-- Both of data with Payload and retransmitted data 
				rTxTPUFlowCtrl(1)	<= rTxTPUFlowCtrl(0);
				rTxTPUFlowCtrl(0)	<= Tx2TPUPayloadReq;
			end if;
		end if;
	End Process u_rTxTPUFlowCtrl; 
	
	u_rTxTPUFlowCtrlCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Expected sequence number that will be send 
			rTxTPUExpSeqNum(31 downto 0 )	<= rTxTPUSeqNum(31 downto 0 ) + (x"0000"&Tx2TPUPayloadLen(15 downto 0));
			-- Receiving window + Receiving Acknowledgement number 
			rTxTPUWindowCal(31 downto 0 )	<= (x"0000"&Rx2TxTPURecWindow(15 downto 0)) + Rx2TxTPUSeqNumAcked(31 downto 0 );	
			-- Flow control algorithm : Receiving window + Receiving Acknowledgement number - Expected sequence number >= 0 
			rTxTPUFlowCtrlCal(31 downto 0 )	<= rTxTPUWindowCal(31 downto 0 ) - rTxTPUExpSeqNum(31 downto 0 );
		end if;
	End Process u_rTxTPUFlowCtrlCal;
	
-----------------------------------------------------------
-- TCP Sequence Number and Acknowledgement number Processing

	u_rTxTPUSeqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialization : Rising edge of SYNSent 
			if ( rCtrlStateMach0(0)='0' and CtrlStateMach(0)='1' ) then 
				rTxTPUSeqNum(31 downto 0 )	<= rTxTPUSeqNumInit(31 downto 0 );
			-- SYN & FIN Retransmission
			elsif ( (Rx2TxTPURetransOption(0)='1' and rTxTCPCtrlSel0(0)='1' and rTxTCPCtrlSel1(0)='1') 
				or (Rx2TxTPURetransOption(1)='1' and rTxTCPCtrlSel0(1)='1' and rTxTCPCtrlSel1(1)='1') )  then 
				rTxTPUSeqNum(31 downto 0 )	<= rTxTPUSeqNum(31 downto 0 ) - 1;
			-- Retransmission 
			elsif ( Rx2TxTPURetransOption(3)='1' and rTxTCPCtrlSel0(3)='1' and rTxTCPCtrlSel1(3)='1' ) then 
				rTxTPUSeqNum(31 downto 0 )	<= Rx2TxTPUSeqNumAcked(31 downto 0 );
			-- SYN & FIN sent 
			elsif ( (rTxTCPCtrlSel0(0)='0' and rTxTCPCtrlSel1(0)='1')	
				or (rTxTCPCtrlSel0(1)='0' and rTxTCPCtrlSel1(1)='1') ) then 
				rTxTPUSeqNum(31 downto 0 )	<= rTxTPUSeqNum(31 downto 0 ) + 1;
			-- Sent Payload 
			elsif ( rTxTPUTxReq='1' and rTxTPUPayloadEn='1' ) then 
				rTxTPUSeqNum(31 downto 0 )	<= rTxTPUSeqNum(31 downto 0 ) + (x"0000"&Tx2TPUPayloadLen(15 downto 0));
			else 
				rTxTPUSeqNum(31 downto 0 )	<= rTxTPUSeqNum(31 downto 0 );
			end if;
		end if;
	End Process u_rTxTPUSeqNum;
	
	u_rTxTPUAckNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- AckNum not valid 
			if ( Rx2TxTPUSeqNumEn='0' ) then 
				rTxTPUAckNum(31 downto 0 )	<= (others=>'0');
			else 
				rTxTPUAckNum(31 downto 0 )	<= rRx2TxTPUAckNumFF(159 downto 128);
			end if;
		end if;
	End Process u_rTxTPUAckNum;
	
-----------------------------------------------------------
-- Rx I/F 
	
	-- Retransmission Option response 
	u_rTx2RxTPURetransEn : Process (Clk) Is 
	Begin 	
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTx2RxTPURetransEn( 3 downto 0 )	<= (others=>'0');
				rTx2RxTPURetransEnFF( 3 downto 0 )	<= (others=>'0');
			else 
				rTx2RxTPURetransEnFF( 3 downto 0 )	<= rTx2RxTPURetransEn( 3 downto 0 );
				-- SYN Sent 
				if ( rTxTCPCtrlSel0(0)='1' and rTxTCPCtrlSel1(0)='1' ) then 
					rTx2RxTPURetransEn(0)	<= '1';
				else 
					rTx2RxTPURetransEn(0)	<= '0';
				end if;
				
				-- FIN Sent
				if ( rTxTCPCtrlSel0(1)='1' and rTxTCPCtrlSel1(1)='1' ) then 
					rTx2RxTPURetransEn(1)	<= '1';
				else 
					rTx2RxTPURetransEn(1)	<= '0';
				end if;
				
				-- 3 ACK Sent 
				if ( rTxTCPCtrlSel0(2)='1' and rTxTCPCtrlSel1(2)='1' 
					and rTxTPURxNakCnt(1)='1' ) then 
					rTx2RxTPURetransEn(2)	<= '1';
				else 
					rTx2RxTPURetransEn(2)	<= '0';
				end if;
				
				-- Payload retrans sent 
				if ( rTxTCPCtrlSel0(4)='1' and rTxTCPCtrlSel1(4)='1' 
					and Tx2TPUOpReply='1' ) then 
					rTx2RxTPURetransEn(3)	<= '1';
				else 
					rTx2RxTPURetransEn(3)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTx2RxTPURetransEn;
	
	-- Counter for sending 3 ACK 
	u_rTxTPURxNakCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Detect rising of Retransmission option 
			if ( Rx2TxTPURetransOption(2)='1' and rTxTCPCtrl(2)='0' ) then 
				rTxTPURxNakCnt( 1 downto 0 )	<= (others=>'0');
			-- Counter 
			elsif ( rTxTCPCtrlSel0(2)='1' and rTxTCPCtrlSel1(2)='1' ) then 
				rTxTPURxNakCnt( 1 downto 0 )	<= rTxTPURxNakCnt( 1 downto 0 ) + 1;
			else 
				rTxTPURxNakCnt( 1 downto 0 )	<= rTxTPURxNakCnt( 1 downto 0 );
			end if;
		end if;
	End Process u_rTxTPURxNakCnt;
	
	-- Using FF signal of window, AcKNum
	-- If the receiving window which is send from the server 
	-- is strictly to protocol this field is required.
	u_rRxTPUDataFF : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRx2TxTPUAckNumFF(159 downto 0 )	<= (rRx2TxTPUAckNumFF(127 downto 0 )&Rx2TxTPUAckNum(31 downto 0));
			rRx2TxTPUWindowFF( 95 downto 0 )	<= (rRx2TxTPUWindowFF( 79 downto 0 )&Rx2TxTPUWindow(15 downto 0));
		end if;
	End Process u_rRxTPUDataFF;

End Architecture rtl;