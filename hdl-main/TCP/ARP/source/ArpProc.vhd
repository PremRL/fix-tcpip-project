----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     ArpProc.vhd
-- Title        ArpProc 
-- 
-- Author       L.Ratchanon
-- Date         2020/09/19
-- Syntax       VHDL
-- Description      
-- 
-- Processor For 
-- Internet Protocol (IPv4) over Ethernet ARP packet
-- To obtain the Ethernet MAC address of ours target IP 
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

Entity ArpProc Is
	Port 
	(
		-- User
		RstB			: in	std_logic;
		Clk				: in	std_logic;
		
		-- RxEMAC 
		RxMacRstB		: in	std_logic;
		RxMacClk		: in	std_logic;
	
		-- TCP/IP Processor Unit Interface 
		SenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		SenderIpAddr	: in 	std_logic_vector(31 downto 0 );
		TargetIpAddr	: in 	std_logic_vector(31 downto 0 );
		ArpMacReq		: in 	std_logic;
		
		TargetMACAddr	: out	std_logic_vector(47 downto 0 );
		TargetMACAddrVal: out	std_logic;

		-- TxEMAC Interface
		TxReq			: out	std_logic;
		TxReady			: in	std_logic;
		
		TxData			: out	std_logic_vector(7 downto 0);
		TxDataValid		: out	std_logic;
		TxDataSOP		: out	std_logic;
		TxDataEOP		: out	std_logic;
		
		-- RxEMAC Interface 
		RxData			: in	std_logic_vector(7 downto 0);
		RxDataValid		: in	std_logic;
		RxSOP			: in	std_logic;
		RxEOP			: in	std_logic;
		RxError			: in	std_logic_vector(1 downto 0)
	);
End Entity ArpProc;	
	
Architecture rtl Of ArpProc Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component TxArp Is
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
	End Component TxArp;
	
	Component RxArp Is
	Port 
	(
		MacRstB			: in	std_logic;
		RstB			: in	std_logic;
		RxMacClk		: in	std_logic;
		Clk				: in	std_logic; 
		
		-- Data form RxMac --> UDPRX
		DataIn			: in	std_logic_vector(7 downto 0);
		DataInValid		: in	std_logic;
		RxSOP			: in	std_logic;
		RxEOP			: in	std_logic;
		RxError			: in	std_logic_vector(1 downto 0);   
		
		-- ARP Processor
		SenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		SenderIpAddr	: in 	std_logic_vector(31 downto 0 );
		TargetIpAddr	: in 	std_logic_vector(31 downto 0 );
		
		RxTargetMACAddr	: out	std_logic_vector(47 downto 0 );
		RxArpOpCode		: out	std_logic;
		RxArpVal		: out	std_logic
	);
	End Component RxArp;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	
	-- Rx Signal 
	signal	RxArpTGMacAddr 		: std_logic_vector(47 downto 0 );
	signal	RxArpOpCode    		: std_logic;
	signal	RxArpVal			: std_logic;
	
	-- Process ARP 
	signal  rTimeOut			: std_logic_vector(27 downto 0 );
	signal  rAddrValCnt			: std_logic_vector( 3 downto 0 );
	signal  rAddrVal			: std_logic;
	signal  rReplyEn			: std_logic;
	signal  rRequestEn			: std_logic;
	signal  rTimeOutEn			: std_logic;
	
	-- Tx Signal 
	signal  rArpGenOp			: std_logic_vector( 1 downto 0 );
	signal  rOptionCode			: std_logic;
	signal  rArpGenReq			: std_logic;
	signal  TxArpBusy			: std_logic;
	
	-- Output signal 
	signal  rTargetMACAddr		: std_logic_vector(47 downto 0 );
	signal  rTargetMACAddrVal 	: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	TargetMACAddr(47 downto 0 )	<= rTargetMACAddr(47 downto 0 );	
	TargetMACAddrVal			<= rTargetMACAddrVal;
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

-----------------------------------------------------------
-- TxArp Mapping 
	
	u_TxArp : TxArp
	Port map 
	(
		RstB			=> RstB				,
		Clk				=> Clk				,

		SenderMACAddr	=> SenderMACAddr	, 
		TargetMACAddr	=> rTargetMACAddr	, 
		SenderIpAddr	=> SenderIpAddr	    , 
		TargetIpAddr	=> TargetIpAddr	    , 
		OptionCode		=> rOptionCode		,
		ArpGenReq		=> rArpGenReq		,
		TxArpBusy		=> TxArpBusy		,

		Req				=> TxReq			,	
		Ready			=> TxReady			,
		DataOut			=> TxData			,		
		DataOutVal		=> TxDataValid		,
		DataOutSop		=> TxDataSop		,
		DataOutEop		=> TxDataEop		
	);

-----------------------------------------------------------
-- RxArp Mapping 

	u_RxArp : RxArp
	Port map 
	(
		MacRstB			=> RxMacRstB		,	
		RstB			=> RstB		        ,
		RxMacClk		=> RxMacClk	        ,
		Clk				=> Clk			    ,

		DataIn			=> RxData		    ,
		DataInValid		=> RxDataValid	    ,
		RxSOP			=> RxSOP		    ,
		RxEOP			=> RxEOP		    ,
		RxError			=> RxError		    ,

		SenderMACAddr	=> SenderMACAddr	,
		SenderIpAddr	=> SenderIpAddr	    ,
		TargetIpAddr	=> TargetIpAddr	    ,

		RxTargetMACAddr	=> RxArpTGMacAddr   ,
		RxArpOpCode		=> RxArpOpCode      ,
		RxArpVal		=> RxArpVal
	);
	
-----------------------------------------------------------
-- Initialization  
	
	u_rAddrVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAddrVal	<= '0';
			else 
				-- Delaying constraint for receiving side address validation 
				if ( rAddrValCnt(3 downto 0)=x"F" ) then 
					rAddrVal	<= '1';
				elsif ( ArpMacReq='1' and rTargetMACAddrVal='0' ) then 
					rAddrVal	<= '0';
				else 
					rAddrVal	<= rAddrVal;
				end if;
			end if;
		end if;
	End Process u_rAddrVal;
	
	-- Counter for some constraint
	u_rAddrValCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then  
				rAddrValCnt( 3 downto 0 )	<= (others=>'0');
			else 
				if ( (ArpMacReq='1' and rTargetMACAddrVal='0') or rAddrValCnt/=0 ) then 
					rAddrValCnt( 3 downto 0 )	<= rAddrValCnt( 3 downto 0 ) + 1;
				else 
					rAddrValCnt( 3 downto 0 )	<= (others=>'0');
				end if;
			end if;
		end if;
	End Process u_rAddrValCnt;

-----------------------------------------------------------
-- MAC Address 
	
	u_rTargetMACAddrVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTargetMACAddrVal	<= '0';
			else 
				-- Target MAC Address Validation 
				if ( RxArpVal='1' and rAddrVal='1' ) then 
					rTargetMACAddrVal	<= '1';
				else 
					rTargetMACAddrVal	<= rTargetMACAddrVal;
				end if;
			end if;
		end if;
	End Process u_rTargetMACAddrVal;
	
	u_rTargetMACAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Target MAC Address 
			if ( RxArpVal='1' and rAddrVal='1' ) then 
				rTargetMACAddr(47 downto 0 )	<= RxArpTGMacAddr(47 downto 0 );
			else 
				rTargetMACAddr(47 downto 0 )	<= rTargetMACAddr(47 downto 0 );
			end if;
		end if;
	End Process u_rTargetMACAddr;
	
-----------------------------------------------------------
-- Requesting to send ARP Packet
	
	-- Reply Operation requesting to send 
	u_rReplyEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rReplyEn	<= '0';
			else 
				-- Reply Operation has taken
				if ( rArpGenOp(0)='1' ) then 
					rReplyEn	<= '0';
				-- Requesting a Reply operation packet to send out  
				elsif ( RxArpVal='1' and rAddrVal='1' and RxArpOpCode='0' ) then 
					rReplyEn	<= '1';
				else 
					rReplyEn	<= rReplyEn;
				end if;
			end if;
		end if;
	End Process u_rReplyEn;
	
	-- Request Operation requesting to send 
	u_rRequestEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRequestEn	<= '0';
			else 
				-- Request Operation has taken
				if ( rArpGenOp(1)='1' or rTargetMACAddrVal='1' ) then 
					rRequestEn	<= '0';
				-- Requesting a Request operation packet to send out  
				elsif ( (rTimeOutEn='1' and rTimeOut(27 downto 25)="111") 
					or ArpMacReq='1' ) then 
					rRequestEn	<= '1';
				else 
					rRequestEn	<= rRequestEn;
				end if;
			end if;
		end if;
	End Process u_rRequestEn;
	
	-- Generate Tx Packet for sending 
	u_rArpGenReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rArpGenReq	<= '0';
			else 
				-- Send TxOut Reply/Request
				if ( TxArpBusy='0' and (rReplyEn='1'
					or rRequestEn='1') ) then 	
					rArpGenReq	<= '1';
				else 
					rArpGenReq	<= '0';
				end if;
			end if;
		end if;
	End Process u_rArpGenReq;
	
	-- ARP Generation order 
	-- bit 1	=> Tx send Request
	-- bit 0 => Tx send Reply 
	u_rArpGenOp : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rArpGenOp( 1 downto 0 )	<= "00";
			else 
				-- Reply operation taken 
				if ( TxArpBusy='0' and rReplyEn='1' ) then 
					rArpGenOp(0)	<= '1';
				else 
					rArpGenOp(0)	<= '0';
				end if;
				-- Request operation taken 
				if ( TxArpBusy='0' and rReplyEn='0' and rRequestEn='1' ) then 
					rArpGenOp(1)	<= '1';
				else
					rArpGenOp(1)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rArpGenOp;
	
	u_rOptionCode : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOptionCode	<= '0';
			else 
				-- Reply Operation
				if ( rArpGenOp(0)='1' ) then 
					rOptionCode	<= '1';
				-- Request Operation
				elsif ( rArpGenOp(1)='1' ) then 
					rOptionCode	<= '0';
				else 
					rOptionCode <= rOptionCode;
				end if;
			end if;
		end if;
	End Process u_rOptionCode;
	
	-- Resend Timer for Request (broadcasting) 1 sec 
	u_rTimer : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rTimeOutEn='1' ) then 
				rTimeOut(27 downto 0 )	<= rTimeOut(27 downto 0 ) + 1;
			else 
				rTimeOut(27 downto 0 )	<= (others=>'0');
			end if;
		end if;
	End Process u_rTimer;
	
	-- Timer counter enable 
	u_rTimeOutEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTimeOutEn	<= '0';
			else 
				if ( rTimeOut(27 downto 25)="111" ) then 
					rTimeOutEn	<= '0';
				elsif ( rArpGenReq='1' ) then 
					rTimeOutEn	<= '1';
				else 
					rTimeOutEn	<= rTimeOutEn;
				end if;
			end if;
		end if;
	End Process u_rTimeOutEn;
	
End Architecture rtl;