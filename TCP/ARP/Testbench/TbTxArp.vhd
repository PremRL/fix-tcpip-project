---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Filename     TxArp.vhd
-- Title        Testbench of TxArp 
-- 
-- Author       L.Ratchanon
-- Date         2020/09/19
-- Syntax       VHDL
-- Description      
-- 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TbTxArp Is
End Entity TbTxArp;

Architecture HTWTestBench Of TbTxArp Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
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

-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------

	signal	TM				: integer	range 0 to 65535;
	signal	TT				: integer	range 0 to 65535;
	
	signal	RstB			: std_logic;
	signal	Clk				: std_logic;
	
	-- Input 
	signal  SenderMACAddr_t	: std_logic_vector(47 downto 0 );
	signal  TargetMACAddr_t	: std_logic_vector(47 downto 0 );
	signal  SenderIpAddr_t	: std_logic_vector(31 downto 0 );
	signal  TargetIpAddr_t	: std_logic_vector(31 downto 0 );
	signal 	OptionCode_t	: std_logic;
	signal  ArpGenReq_t		: std_logic;
	
	signal  Ready_t			: std_logic;
	
	signal  SenderMACAddr	: std_logic_vector(47 downto 0 );
	signal  TargetMACAddr	: std_logic_vector(47 downto 0 );
	signal  SenderIpAddr	: std_logic_vector(31 downto 0 );
	signal  TargetIpAddr	: std_logic_vector(31 downto 0 );
	signal 	OptionCode		: std_logic;
	signal  ArpGenReq		: std_logic;
	
	signal  Ready			: std_logic;

	-- Output 
	signal  TxArpBusy		: std_logic;
	signal  Req				: std_logic;
	signal  DataOut			: std_logic_vector( 7 downto 0 );
	signal  DataOutVal		: std_logic;
	signal  DataOutSop		: std_logic;
	signal  DataOutEop		: std_logic;
	
	signal  TxArpBusy_t		: std_logic;
	signal  Req_t			: std_logic;
	signal  DataOut_t		: std_logic_vector( 7 downto 0 );
	signal  DataOutVal_t	: std_logic;
	signal  DataOutSop_t	: std_logic;
	signal  DataOutEop_t	: std_logic;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u_RstB : Process
	Begin
		RstB	<= '0';
		wait for 20*tClk;
		RstB	<= '1';
		wait;
	End Process u_RstB;

	u_Clk : Process
	Begin
		Clk		<= '1';
		wait for tClk/2;
		Clk		<= '0';
		wait for tClk/2;
	End Process u_Clk;
	
	--------------- Output process -------------------------
	
	u_Ready : Process
	Begin 
		if ( RstB='0' ) then 
			Ready	<= '0';
		elsif ( Req='1' ) then 
			Ready	<= '1';
		elsif ( DataOutEop='1' ) then 
			Ready	<= '0';
		else 
			Ready	<= Ready;
		end if; 
		wait until rising_edge(Clk);
	End Process u_Ready;
	
	u_TxArp : TxArp
	Port map 
	(
		RstB			=> RstB					,
		Clk				=> Clk                  ,

		SenderMACAddr	=> SenderMACAddr_t		,
		TargetMACAddr	=> TargetMACAddr_t	    ,
		SenderIpAddr	=> SenderIpAddr_t       ,
		TargetIpAddr	=> TargetIpAddr_t       ,
        OptionCode		=> OptionCode_t		    ,
		ArpGenReq		=> ArpGenReq_t		    ,

        TxArpBusy		=> TxArpBusy_t		    ,

		Req				=> Req_t				,
		Ready			=> Ready_t			    ,

		DataOut			=> DataOut_t			,
		DataOutVal		=> DataOutVal_t		    ,
		DataOutSop		=> DataOutSop_t		    ,
		DataOutEop		=> DataOutEop_t 		
	);
	
	
	
-- Signal assignment from testbench to TxArp with delay time
	SenderMACAddr_t		<= SenderMACAddr		after 1 ns;
	TargetMACAddr_t		<= TargetMACAddr		after 1 ns;
	SenderIpAddr_t		<= SenderIpAddr			after 1 ns;
    TargetIpAddr_t		<= TargetIpAddr	    	after 1 ns;
	OptionCode_t		<= OptionCode			after 1 ns;
	ArpGenReq_t			<= ArpGenReq			after 1 ns;

	Ready_t			    <= Ready				after 1 ns;

-- Signal assignment from TxArp to testbench with delay time
	TxArpBusy			<= TxArpBusy_t			after 1 ns;
	Req			        <= Req_t				after 1 ns;
	DataOut		        <= DataOut_t		    after 1 ns;
	DataOutVal	        <= DataOutVal_t	        after 1 ns;
	DataOutSop	        <= DataOutSop_t			after 1 ns;
	DataOutEop	        <= DataOutEop_t	        after 1 ns;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	u_Test : Process
	Begin
		-------------------------------------------
		-- TM=0 : Reset
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		-- Initialize 
		SenderMACAddr	<= x"001a6b6c0ccc";
		TargetMACAddr	<= x"001d09f092ab";
		SenderIpAddr	<= x"0a0a0a02";
		TargetIpAddr	<= x"0a0a0a01";
		ArpGenReq		<= '0';
		OptionCode		<= '0';

		wait for 50*tClk;
		-------------------------------------------
		-- TM=1 : Arp Gen  
		-------------------------------------------	
		
		-------------------------------------------
		-- TT = 0 : Request 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		ArpGenReq	<= '1';
		wait until rising_edge(Clk);
		ArpGenReq	<= '0';
		wait until rising_edge(Clk);
		wait until TxArpBusy='0' and rising_edge(Clk); 

		wait for 20*tClk;
		-------------------------------------------
		-- TT = 0 : Reply 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		ArpGenReq	<= '1';
		OptionCode	<= '1';
		wait until rising_edge(Clk);
		ArpGenReq	<= '0';
		wait until rising_edge(Clk);
		wait until TxArpBusy='0' and rising_edge(Clk); 

		wait for 20*tClk;
		--------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
		
	End Process u_Test;

End Architecture HTWTestBench;
		