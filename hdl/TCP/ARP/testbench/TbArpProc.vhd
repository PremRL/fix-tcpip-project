----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     ArpProc.vhd
-- Title        Testbench of ArpProc 
-- 
-- Author       L.Ratchanon
-- Date         2020/09/19
-- Syntax       VHDL
-- Description      
-- 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TbArpProc Is
End Entity TbArpProc;

Architecture HTWTestBench Of TbArpProc Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component ArpProc Is
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
	End Component ArpProc;

-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------

	signal	TM					: integer	range 0 to 65535;
	signal	TT					: integer	range 0 to 65535;

	signal	MacRstB				: std_logic;
	signal	RstB				: std_logic;
	signal	MacClk				: std_logic;
	signal	Clk					: std_logic;
	signal  rDelay				: std_logic := '0';
	
	-- Input 
	signal  SenderMACAddr_t		: std_logic_vector(47 downto 0 );
	signal  SenderIpAddr_t		: std_logic_vector(31 downto 0 );
	signal  TargetIpAddr_t		: std_logic_vector(31 downto 0 );
	signal  ArpMacReq_t			: std_logic;
	
	signal  TxReady_t			: std_logic;
	signal  RxData_t			: std_logic_vector( 7 downto 0 );
	signal  RxDataValid_t		: std_logic;
	signal  RxSOP_t				: std_logic;
	signal  RxEOP_t				: std_logic;
	signal  RxError_t			: std_logic_vector(1 downto 0);
	
	signal  SenderMACAddr		: std_logic_vector(47 downto 0 );
	signal  SenderIpAddr		: std_logic_vector(31 downto 0 );
	signal  TargetIpAddr		: std_logic_vector(31 downto 0 );
	signal  ArpMacReq			: std_logic;
	
	signal  TxReady				: std_logic := '0';
	signal  RxData				: std_logic_vector( 7 downto 0 );
	signal  RxDataValid			: std_logic;
	signal  RxSOP				: std_logic;
	signal  RxEOP				: std_logic;
	signal  RxError				: std_logic_vector(1 downto 0);

	-- Output 	
	signal  TargetMACAddr		: std_logic_vector(47 downto 0 );
	signal  TargetMACAddrVal	: std_logic;
	
	signal  TxReq				: std_logic;
	signal  TxData				: std_logic_vector( 7 downto 0 );
	signal  TxDataValid			: std_logic;
	signal  TxDataSOP			: std_logic;
	signal  TxDataEOP			: std_logic;

	signal  TargetMACAddr_t		: std_logic_vector(47 downto 0 );
	signal  TargetMACAddrVal_t	: std_logic;
	
	signal  TxReq_t				: std_logic;
	signal  TxData_t			: std_logic_vector( 7 downto 0 );
	signal  TxDataValid_t		: std_logic;
	signal  TxDataSOP_t			: std_logic;
	signal  TxDataEOP_t			: std_logic;
	
	type RomType		is array (0 to 71) of std_logic_vector(7 downto 0);
	constant rData1		: RomType :=
	(
		x"00", x"1a", x"6b", x"6c", x"0c", x"cc", x"00", x"1d", 
		x"09", x"f0", x"92", x"ab", x"08", x"06", x"00", x"01",
		x"08", x"00", x"06", x"04", x"00", x"02", x"00", x"1d",
		x"09", x"f0", x"92", x"ab", x"0a", x"0a", x"0a", x"01",
		x"00", x"1a", x"6b", x"6c", x"0c", x"cc", x"0a", x"0a",
		x"0a", x"02", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"
	);
	
	constant rData2		: RomType :=
	(
		x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"1d", 
		x"09", x"f0", x"92", x"ab", x"08", x"06", x"00", x"01",
		x"08", x"00", x"06", x"04", x"00", x"01", x"00", x"1d", 
		x"09", x"f0", x"92", x"ab", x"0a", x"0a", x"0a", x"01",
		x"00", x"00", x"00", x"00", x"00", x"00", x"0a", x"0a",
		x"0a", x"02", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"
	);
	
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u_RstB : Process
	Begin
		MacRstB <= '0';
		RstB	<= '0';
		wait for 20*tClk;
		MacRstB <= '1';
		RstB	<= '1';
		wait until TM=2 and TT=0;
		MacRstB <= '0';
		RstB	<= '0';
		wait for 20*tClk;
		MacRstB <= '1';
		RstB	<= '1';
		wait;
	End Process u_RstB;

	u_MacClk : Process
	Begin
		MacClk		<= '1';
		wait for tClk/2;
		MacClk		<= '0';
		wait for tClk/2;
	End Process u_MacClk;
	
	u_Clk : Process
	Begin
		if ( rDelay='0' ) then 
			wait for tClk/3;
		end if;
		Clk		<= '1';
		wait for tClk/2;
		Clk		<= '0';
		wait for tClk/2;
	End Process u_Clk;
	
	u_rDelay : Process 
	Begin 
		wait for tClk;
		rDelay	<= '1';
		wait;
	End Process u_rDelay;
	
	u_TxReady : Process 
	Begin 
		if ( TxReq='1' ) then 
			TxReady	<= '1';
		elsif ( TxDataEOP='1' ) then 
			TxReady	<= '0';
		else 
			TxReady	<= TxReady;
		end if;
		wait until rising_edge(Clk);
	End Process u_TxReady;
	
	u_ArpProc : ArpProc
	Port map 
	(	
		RstB				=> RstB					,		
		Clk				    => Clk              	,

		RxMacRstB		    => MacRstB  	       	,
		RxMacClk		    => MacClk	          	,

		SenderMACAddr	    => SenderMACAddr_t  	,
		SenderIpAddr	    => SenderIpAddr_t   	,
		TargetIpAddr	    => TargetIpAddr_t   	,
		ArpMacReq		    => ArpMacReq_t      	,

		TargetMACAddr	    => TargetMACAddr_t  	,
		TargetMACAddrVal    => TargetMACAddrVal_t	,

		TxReq			    => TxReq_t          	,
		TxReady			    => TxReady_t        	,

		TxData			    => TxData_t				,
		TxDataValid		    => TxDataValid_t		,	 
		TxDataSOP		    => TxDataSOP_t			,
		TxDataEOP		    => TxDataEOP_t			,

		RxData			    => RxData_t				,
		RxDataValid		    => RxDataValid_t		,	 
		RxSOP			    => RxSOP_t				,
		RxEOP			    => RxEOP_t				,
		RxError			    => RxError_t				 
	);
	
	
	
-- Signal assignment from testbench to TxArp with delay time
	SenderMACAddr_t 	<= SenderMACAddr		after 1 ns;
	SenderIpAddr_t  	<= SenderIpAddr  		after 1 ns;
    TargetIpAddr_t  	<= TargetIpAddr  		after 1 ns;
	ArpMacReq_t     	<= ArpMacReq     		after 1 ns;
	TxReady_t			<= TxReady				after 1 ns;
	RxData_t		    <= RxData		        after 1 ns;
	RxDataValid_t	    <= RxDataValid	        after 1 ns;
	RxSOP_t			    <= RxSOP			    after 1 ns;
	RxEOP_t			    <= RxEOP			    after 1 ns;
	RxError_t		    <= RxError		        after 1 ns;
	
-- Signal assignment from TxArp to testbench with delay time
	TargetMACAddr		<= TargetMACAddr_t		after 1 ns;
	TargetMACAddrVal	<= TargetMACAddrVal_t	after 1 ns;
	TxReq				<= TxReq_t				after 1 ns;
	TxData			    <= TxData_t			    after 1 ns;
	TxDataValid		    <= TxDataValid_t		after 1 ns;    
	TxDataSOP		    <= TxDataSOP_t		    after 1 ns;
	TxDataEOP		    <= TxDataEOP_t		    after 1 ns;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	u_Test : Process
	variable	rDataCnt	: integer range 0 to 64;
	Begin
		-------------------------------------------
		-- TM=0 : Reset
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		-- Initialize 
		SenderMACAddr	<= x"001a6b6c0ccc";
		SenderIpAddr 	<= x"0a0a0a02";
		TargetIpAddr 	<= x"0a0a0a01";
		ArpMacReq    	<= '0';
		RxData			<= (others=>'0');
		RxDataValid		<= '0';
		RxSOP			<= '0';
		RxEOP			<= '0';
		RxError			<= "00";

		wait for 50*tClk;
		wait until rising_edge(Clk);
		-------------------------------------------
		-- TM=1 : Send Arp Request and get reply back 
		-------------------------------------------	
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		-- Request
		ArpMacReq		<= '1';
		wait until rising_edge(Clk);
		ArpMacReq		<= '0';
		wait until rising_edge(Clk);
		wait until TxDataEOP='1' and rising_edge(Clk);
		wait for 50*tClk;
		
		wait until rising_edge(MacClk); 
		-- Reply 
		rDataCnt		:= 0;
		RxData			<= rData1(rDataCnt);
		RxDataValid		<= '1';
		RxSOP			<= '1';
		
		L1 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			RxData		<= rData1(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=59 ) then 
				RxEOP	<= '1';
			end if;
			exit L1 when rDataCnt=60;
		End Loop;
		RxDataValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=2 : receiving Request 
		-------------------------------------------	
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		wait for 50*tClk; wait until rising_edge(Clk);
		-- Request
		ArpMacReq		<= '1';
		wait until rising_edge(Clk);
		ArpMacReq		<= '0';
		wait until rising_edge(Clk);
		wait for 20*tClk;
		
		wait until rising_edge(MacClk); 
		-- Request 
		rDataCnt		:= 0;
		RxData			<= rData2(rDataCnt);
		RxDataValid		<= '1';
		RxSOP			<= '1';
		
		L2 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			RxData		<= rData2(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=59 ) then 
				RxEOP	<= '1';
			end if;
			exit L2 when rDataCnt=60;
		End Loop;
		RxDataValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		wait until TxDataEOP='1';
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=3 : Error at Eop 
		-------------------------------------------	
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		wait for 50*tClk; wait until rising_edge(Clk);
		-- Request 
		rDataCnt		:= 0;
		RxData			<= rData2(rDataCnt);
		RxDataValid		<= '1';
		RxSOP			<= '1';
		
		L3 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			RxData		<= rData2(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=59 ) then 
				-- Error 
				RxError	<= "01";
				RxEOP	<= '1';
			end if;
			exit L3 when rDataCnt=60;
		End Loop;
		RxDataValid		<= '0';
		RxEOP			<= '0';
		RxError			<= "00";
		wait until rising_edge(MacClk); 
		
		--------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
		
	End Process u_Test;

End Architecture HTWTestBench;
		