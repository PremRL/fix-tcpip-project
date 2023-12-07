----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     StateCtrl.vhd
-- Title        StateCtrl For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/10/13
-- Syntax       VHDL
-- Description      
-- 
-- State Machine Module of TCP Processing Unit 
--
-- Notation for User Ineterface 
-- 1) UserStatus 4 bit	->	LSB	: Closed 
--					->	bit1	: Connecting
--					->	bit2 : Established 
--					->	MSB	: Terminating
--  	 Note that only 
-- 2) UserPSHCtrlFlagset : Server demands client to push data upstearm
-- 3) UserFINCtrlFlagset : Server demands client to terminate the connection 
-- 4) UserConnectReq : Input from upper layer for requesting connection
-- 5) UserTerminateReq : Input from upper layer for terminating connection
-- 6) The other inputs are addressing : IP, MAC, and TCPPort  
-- **------------------------**
--
-- Notation for ArpProc Interface 
-- 1) All outputs Addr are both IP addr and sender MAC addr
-- 2) ArpMacReq : Requesting ARP operation.
-- 3) ArpTargetMACAddrVal : After Requesting ARP operation, the StateCtrl module
-- 	 waits for this signal to verify the Target MAC Address
-- 4) ArpTargetMACAddr : Target MAC Address received, Validate when 
--	 ArpTargetMACAddrVal is set
-- **------------------------**	
--
-- Notation TCPCtrl Interface 
-- 1) CtrlCtrlFlags 9 bits defined as following :
--	 -> bit 0 : FIN	"Terminating the Connection"
--	 -> bit 1 : SYN 	"Synchronization (Connecting)"
--	 -> bit 2 : RST  	"Reset the system => Left the connection immediately"
--	 -> bit 3 : PSH  	"Push the Data => Send to upper layer" 
--	 -> bit 4 : ACK  	"Acknowledgement => In this design, only set when replying SYN or FIN"
--	 -> bit 5 : URG  	"NOT USED"
--	 -> bit 6 : ECE  	"NOT USED"
--	 -> bit 7 : CWR  	"NOT USED"
--	 -> bit 8 : NS   	"NOT USED"
-- 2) CtrlConnReady For permitting upper layer to stack data in queue
-- 3) CtrlStateMach : State Machine of TCP Machanism Control consists 8 bits 
--	 -> bit 0 : State SYNSent 
--	 -> bit 1 : State Established 
-- 	 -> bit 2 : State CloseWait 
--	 -> bit 3 : State LastACK 
--	 -> bit 4 : State FinWait1 
--	 -> bit 5 : State FinWait2 
--	 -> bit 6 : State Closing 
--	 -> bit 7 : State Timewait
-- 4) CtrlAddrValid : All the Address that sending to TCPCtrl are valid 
-- 5) the others : Address of MAC, IP, and TCPPort to TCPCtrl	
-- **------------------------**	
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

Entity StateCtrl Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		-- User Interface	
		UserSrcPort     		: in	std_logic_vector(15 downto 0 );
		UserDesPort     		: in	std_logic_vector(15 downto 0 );
		UserConnectReq			: in	std_logic;
		UserTerminateReq		: in 	std_logic;
		
		UserStatus				: out 	std_logic_vector( 3 downto 0 );	
		UserPSHFlagset			: out	std_logic;
		UserFINFlagset 			: out	std_logic;
		UserRSTFlagset			: out 	std_logic;
		
		-- User Network register Interface  
		UNG2TCPSenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TCPTargetMACAddr	: in	std_logic_vector(47 downto 0 );
		UNG2TCPSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TCPTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		
		UNG2TCPAddrVal			: in	std_logic;
	
		-- TCPCtrl Interface
		CtrlFlags				: in 	std_logic_vector( 8 downto 0 ); 
		CtrlLastSent			: in	std_logic;
		CtrlAllRecv				: in	std_logic;
		
	    CtrlSenderMACAddr		: out 	std_logic_vector(47 downto 0 );
		CtrlTargetMACAddr		: out	std_logic_vector(47 downto 0 );
		CtrlSenderIpAddr		: out 	std_logic_vector(31 downto 0 );
		CtrlTargetIpAddr		: out 	std_logic_vector(31 downto 0 );
		CtrlSrcPort     		: out	std_logic_vector(15 downto 0 );
		CtrlDesPort     		: out	std_logic_vector(15 downto 0 );
		CtrlStateMach			: out 	std_logic_vector( 7 downto 0 );
		CtrlDataEn				: out 	std_logic;
		CtrlRST					: out 	std_logic;
		CtrlAddrVal				: out	std_logic
	);
End Entity StateCtrl;	
	
Architecture rtl Of StateCtrl Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	type StateType is
					(
						stInitiate,		
						stIdle,			
						stSYNSent,		
						stEstablished,	
						stFinWait1,		
						stFinWait2,		
						stClosing,
						stCloseWait,
						stLastACK,
						stTimeWait
					);
					
	signal rState				: StateType;

	-- User I/F 
	signal  rConnecting			: std_logic_vector( 1 downto 0 );
	signal  rEstablished		: std_logic_vector( 1 downto 0 );
	signal  rClosed				: std_logic;
	signal  rTerminating		: std_logic;
	signal  rSenderFINSet		: std_logic;
	signal  rSenderPSHSet		: std_logic;
	signal  rSenderRSTSet		: std_logic;
	
	-- TCPCtrl I/F
	signal  rCtrlState			: std_logic_vector( 7 downto 0 );
	
	-- Internal 
	signal  rTimeout			: std_logic_vector(32 downto 0 );
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	-- User I/F 
	UserStatus(3)					<= rTerminating;
	UserStatus(2)					<= rEstablished(1);
	UserStatus(1)					<= rConnecting(1);
	UserStatus(0)					<= rClosed;
	UserPSHFlagset					<= rSenderPSHSet;
	UserFINFlagset 					<= rSenderFINSet;
	UserRSTFlagset					<= rSenderRSTSet;
	
	-- TCPCtrl I/F 
	CtrlSenderMACAddr(47 downto 0 )	<= UNG2TCPSenderMACAddr(47 downto 0 );	
	CtrlTargetMACAddr(47 downto 0 )	<= UNG2TCPTargetMACAddr(47 downto 0 );	
	CtrlSenderIpAddr(31 downto 0 )	<= UNG2TCPSenderIpAddr(31 downto 0 );	
    CtrlTargetIpAddr(31 downto 0 )	<= UNG2TCPTargetIpAddr(31 downto 0 );	
	CtrlSrcPort(15 downto 0 )		<= UserSrcPort(15 downto 0 );
	CtrlDesPort(15 downto 0 )		<= UserDesPort(15 downto 0 );
    CtrlStateMach( 7 downto 0 )		<= rCtrlState( 7 downto 0 );
    CtrlDataEn						<= rEstablished(1);
	CtrlRST							<= rSenderRSTSet;
	CtrlAddrVal						<= UNG2TCPAddrVal;
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------	
-----------------------------------------------------------
-- State Machine 
	
	u_rState : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rState	<= stInitiate;
			else 	
				case ( rState ) Is 

					when stInitiate	=>
						if ( UNG2TCPAddrVal='1' ) then 
							rState	<= stIdle;
						else 
							rState	<= stInitiate;
						end if;
							
					when stIdle		=>
						-- Connection initialization 
						if ( rConnecting(1 downto 0)="01" ) then 
							rState	<= stSYNSent;
						else
							rState	<= stIdle;
						end if;
					
					when stSYNSent	=>
						-- RST flag set 
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- ACK and SYN Flags set 
						elsif ( CtrlFlags(4)='1' and CtrlFlags(1)='1' ) then 
							rState	<= stEstablished;
						else
							rState	<= stSYNSent;
						end if;
					
					when stEstablished	=>
						-- RST flag set 
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- FIN flag set 
						elsif ( CtrlFlags(0)='1' ) then 
							rState	<= stCloseWait;
						-- Connection terminating 
						elsif ( rTerminating='1' and CtrlLastSent='1' and CtrlAllRecv='1' ) then 
							rState	<= stFinWait1; 
						else 
							rState	<= stEstablished;
						end if;
 	
					when stCloseWait=>
						-- RST flag set 
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- Connection terminating 
						elsif ( rTerminating='1' and CtrlLastSent='1' and CtrlAllRecv='1' ) then 
							rState	<= stLastACK;
						else 
							rState	<= stCloseWait;
						end if;
					
					when stLastACK	=>
						-- RST flag set ot ACK flag set 
						if ( CtrlFlags(2)='1' or CtrlFlags(4)='1' ) then 
							rState	<= stIdle;
						else 
							rState	<= stLastACK;
						end if;
					
					when stFinWait1	=>
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- FIN and ACK Flags set 
						elsif ( CtrlFlags(0)='1' and CtrlFlags(4)='1' ) then 
							rState 	<= stTimeWait;
						-- FIN flag set 
						elsif ( CtrlFlags(0)='1' ) then 
							rState	<= stClosing;	
						-- ACK flag set 
						elsif ( CtrlFlags(4)='1' ) then 
							rState 	<= stFinWait2;
						else 
							rState	<= stFinWait1;
						end if;
						
					when stFinWait2	=>
						-- RST flag set 
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- FIN flag set 
						elsif ( CtrlFlags(0)='1' ) then 
							rState 	<= stTimeWait;
						else 
							rState	<= stFinWait2;
						end if;	
					
					when stClosing	=>
						-- RST flag set 
						if ( CtrlFlags(2)='1' ) then 
							rState	<= stIdle;
						-- ACK flag set 
						elsif ( CtrlFlags(4)='1' ) then 
							rState 	<= stTimeWait;
						else 
							rState	<= stClosing;
						end if;	
						
					when stTimeWait	=>
						if ( CtrlFlags(2)='1' or rTimeout=1 ) then  
							rState	<= stIdle;
						else 
							rState	<= stTimeWait;
						end if;	
				
				end case;
			end if;
		end if;
	End Process u_rState;
	
-----------------------------------------------------------
-- User I/F 
	
	-- UserStatus for User 
	-- Connection closed 
	u_rClosed : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rClosed	<= '1';
			else 
				-- Disconnected
				if ( (rState=stIdle and rTerminating='1') or CtrlFlags(2)='1' ) then 
					rClosed	<= '1';
				-- Connecting
				elsif ( rConnecting(1 downto 0)="01" ) then 
					rClosed	<= '0';
				else 
					rClosed	<= rClosed;
				end if;
			end if;
		end if;
	End Process u_rClosed;
	
	-- Connecting 
	u_rConnecting : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rConnecting( 1 downto 0 )	<= "00";
			else 
				rConnecting(1)	<= rConnecting(0);
				-- Enable upper layer to send data in queue (connected)
				if ( (CtrlFlags(4)='1' and CtrlFlags(1)='1' and rState=stSYNSent)
					-- RST Flag has been set 
					or CtrlFlags(2)='1' ) then 
					rConnecting(0)	<= '0';
				-- Requesting for connection
				elsif ( UserConnectReq='1' and rState=stIdle and rTerminating='0' ) then 
					rConnecting(0)	<= '1';
				else 
					rConnecting(0)	<= rConnecting(0);
				end if;
			end if;
		end if;
	End Process u_rConnecting;
	
	-- Data transfer 
	u_rEstablished : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rEstablished( 1 downto 0 )	<= "00";
			else
				rEstablished(1)		<= rEstablished(0);
				-- Upper layer request for connection termination 
				if ( ((rState=stEstablished or rState=stCloseWait) and UserTerminateReq='1')
					-- RST Flag has been set 
					or CtrlFlags(2)='1' ) then 
					rEstablished(0)	<= '0';
				-- Enable upper layer to send data in queue (Pseudo-connected)
				elsif ( CtrlFlags(4)='1' and CtrlFlags(1)='1' and rState=stSYNSent ) then 
					rEstablished(0)	<= '1';
				else 
					rEstablished(0)	<= rEstablished(0);
				end if;
			end if;
		end if;
	End Process u_rEstablished;
	
	-- Connection termination 
	u_rTerminating : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTerminating	<= '0';
			else 
				-- Closed connection
				if ( rState=stIdle or CtrlFlags(2)='1' ) then 
					rTerminating	<= '0';
				-- Closing connection
				elsif ( rEstablished(1 downto 0)="10" ) then
					rTerminating	<= '1';
				else 
					rTerminating	<= rTerminating;
				end if;
			end if;
		end if;
	End Process u_rTerminating;
	
	-- TCP Option to upper layer 
	-- Request for connection termination to upper layer 
	u_rSenderFINSet : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rSenderFINSet	<= '0';
			else 
				-- User disconecting 
				if ( rEstablished(0)='0' ) then 
					rSenderFINSet	<= '0';
				-- FIN flag set 
				elsif ( rState=stEstablished and CtrlFlags(0)='1' ) then 
					rSenderFINSet	<= '1';
				else 
					rSenderFINSet	<= rSenderFINSet;
				end if; 
			end if;
		end if;
	End Process u_rSenderFINSet;
	
	-- Request upper layer to Push data 
	u_rSenderPSHSet : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rSenderPSHSet	<= '0';
			else 
				-- PSH flag set 
				if ( CtrlFlags(3)='1' ) then 
					rSenderPSHSet	<= '1';
				else 
					rSenderPSHSet	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rSenderPSHSet;
	
	-- TCP/IP RST Flag 
	u_rSenderRSTSet : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then   
				rSenderRSTSet	<= '0';
			else 
				if ( CtrlFlags(2)='1' ) then
					rSenderRSTSet	<= '1';
				else 
					rSenderRSTSet	<= '0';
				end if;
			end if;
		end if;
	End Process u_rSenderRSTSet;

-----------------------------------------------------------
-- State control I/F 
	
	-- State 
	u_rCtrlState : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlState( 7 downto 0 )	<= (others=>'0');
			else 
				if ( rState=stSYNSent ) then 
					rCtrlState(0)	<= '1';
				else 
					rCtrlState(0)	<= '0';
				end if;
				
				if ( rState=stEstablished ) then 
					rCtrlState(1)	<= '1';
				else 
					rCtrlState(1)	<= '0';
				end if;
				
				if ( rState=stCloseWait ) then 
					rCtrlState(2)	<= '1';
				else 
					rCtrlState(2)	<= '0';
				end if;
				
				if ( rState=stLastACK ) then 
					rCtrlState(3)	<= '1';
				else 
					rCtrlState(3)	<= '0';
				end if;
				
				if ( rState=stFinWait1 ) then 
					rCtrlState(4)	<= '1';
				else 
					rCtrlState(4)	<= '0';
				end if;
				
				if ( rState=stFinWait2 ) then 
					rCtrlState(5)	<= '1';
				else 
					rCtrlState(5)	<= '0';
				end if;
				
				if ( rState=stClosing ) then 
					rCtrlState(6)	<= '1';
				else 
					rCtrlState(6)	<= '0';
				end if;
				
				if ( rState=stTimeWait ) then 
					rCtrlState(7)	<= '1';
				else 
					rCtrlState(7)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlState;

-----------------------------------------------------------
-- Timewait signal 
-- Common wait time : 60 seconds ( 7,500,000,000 clk for 125 MHz )

	u_rTimeout : Process (Clk) Is 
	Begin 	
		if ( rising_edge(Clk) ) then 
			if ( rState=stTimeWait ) then 
				rTimeout(32 downto 0 )	<= rTimeout(32 downto 0 ) - 1;
			else
				rTimeout(32 downto 0 )	<= '0'&x"0000_07D0"; -- Simulation 2000 Clk 
				--rTimeout(32 downto 0 )	<= '1'&x"BF08_EB00"; -- Synthesis  
			end if;
		end if;
	End Process u_rTimeout;
	
End Architecture rtl;