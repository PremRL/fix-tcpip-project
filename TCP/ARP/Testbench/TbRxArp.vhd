----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     RxArp.vhd
-- Title        Testbench of RxArp 
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

Entity TbRxArp Is
End Entity TbRxArp;

Architecture HTWTestBench Of TbRxArp Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
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
	signal  DataIn_t			: std_logic_vector( 7 downto 0 );
	signal  DataInValid_t		: std_logic;
	signal  RxSOP_t				: std_logic;
	signal  RxEOP_t				: std_logic;
	signal  RxError_t			: std_logic_vector(1 downto 0);

	signal  DataIn				: std_logic_vector( 7 downto 0 );
	signal  DataInValid			: std_logic;
	signal  RxSOP				: std_logic;
	signal  RxEOP				: std_logic;
	signal  RxError				: std_logic_vector(1 downto 0);

	signal	SenderMACAddr		: std_logic_vector(47 downto 0 );
	signal  SenderIpAddr		: std_logic_vector(31 downto 0 );
	signal  TargetIpAddr		: std_logic_vector(31 downto 0 );

	-- Output 	
	signal  RxTargetMACAddr		: std_logic_vector(47 downto 0 );
	signal  RxArpOpCode			: std_logic;
	signal  RxArpVal			: std_logic;

	signal  RxTargetMACAddr_t	: std_logic_vector(47 downto 0 );
	signal  RxArpOpCode_t		: std_logic;
	signal  RxArpVal_t			: std_logic;
	
	type RomType		is array (0 to 47) of std_logic_vector(7 downto 0);
	constant rData1		: RomType :=
	(
		x"00", x"1a", x"6b", x"6c", x"0c", x"cc", x"00", x"1d", 
		x"09", x"f0", x"92", x"ab", x"08", x"06", x"00", x"01",
		x"08", x"00", x"06", x"04", x"00", x"02", x"00", x"1d",
		x"09", x"f0", x"92", x"ab", x"0a", x"0a", x"0a", x"01",
		x"00", x"1a", x"6b", x"6c", x"0c", x"cc", x"0a", x"0a",
		x"0a", x"02", x"00", x"00", x"00", x"00", x"00", x"00"
	);
	
	constant rData2		: RomType :=
	(
		x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"1a",
		x"6b", x"6c", x"0c", x"cc", x"08", x"06", x"00", x"01",
		x"08", x"00", x"06", x"04", x"00", x"01", x"00", x"1a",
		x"6b", x"6c", x"0c", x"cc", x"0a", x"0a", x"0a", x"01",
		x"00", x"00", x"00", x"00", x"00", x"00", x"0a", x"0a",
		x"0a", x"02", x"00", x"00", x"00", x"00", x"00", x"00"
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
	
	u_RxArp : RxArp
	Port map 
	(
		MacRstB			=> MacRstB				,
		RstB			=> RstB			        ,
		RxMacClk		=> MacClk		        ,
		Clk				=> Clk				    ,

		DataIn			=> DataIn_t			    ,
		DataInValid		=> DataInValid_t		,
		RxSOP			=> RxSOP_t			    ,
		RxEOP			=> RxEOP_t			    ,
		RxError			=> RxError_t			,

		SenderMACAddr	=> SenderMACAddr	    ,
		SenderIpAddr	=> SenderIpAddr	        ,
		TargetIpAddr	=> TargetIpAddr	        ,

		RxTargetMACAddr	=> RxTargetMACAddr_t	,
		RxArpOpCode		=> RxArpOpCode_t		,
		RxArpVal		=> RxArpVal_t		    
	);
	
	
	
-- Signal assignment from testbench to TxArp with delay time
	DataIn_t			<= DataIn				after 1 ns;
	DataInValid_t		<= DataInValid			after 1 ns;
    RxSOP_t				<= RxSOP				after 1 ns;
	RxEOP_t				<= RxEOP				after 1 ns;
	RxError_t		    <= RxError				after 1 ns;
	
-- Signal assignment from TxArp to testbench with delay time
	RxTargetMACAddr		<= RxTargetMACAddr_t	after 1 ns;
	RxArpOpCode			<= RxArpOpCode_t		after 1 ns;
	RxArpVal		    <= RxArpVal_t			after 1 ns;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	u_Test : Process
	variable	rDataCnt	: integer range 0 to 63;
	Begin
		-------------------------------------------
		-- TM=0 : Reset
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		-- Initialize 
		SenderMACAddr	<= x"001a6b6c0ccc";
		SenderIpAddr	<= x"0a0a0a02";
		TargetIpAddr	<= x"0a0a0a01";
		DataIn			<= (others=>'0');
		DataInValid		<= '0';
		RxSOP			<= '0';
		RxEOP			<= '0';
		RxError			<= "00";
		
		wait for 50*tClk;
		-------------------------------------------
		-- TM=1 : Arp Normal   
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Reply received
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L1 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			DataIn		<= rData1(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L1 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 0 : Request received
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData2(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L2 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			DataIn		<= rData2(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L2 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=2 : Arp Not valid   
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Ethernet Type not valid 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L3 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt=12 ) then 
				DataIn	<= x"08";
			elsif ( rDataCnt=13 ) then 
				DataIn	<= x"00";
			else 	
				DataIn	<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L3 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 1 : Hardware Type not valid 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L4 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=15 ) then 
				DataIn		<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L4 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 3 : Protocol Type not valid 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L5 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=17 ) then 
				DataIn		<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L5 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 4 : Hardware  Len not valid 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L6 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=18 ) then 
				DataIn		<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L6 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 5 : Protocol len not vaild 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L7 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=19 ) then 
				DataIn		<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L7 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 6 : Operation not valid 1 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L8 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=20 ) then 
				DataIn		<= rData1(rDataCnt);	
			else 
				DataIn		<= x"FF";
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L8 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 7 : Operation not valid 2
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L9 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt/=21 ) then 
				DataIn		<= rData1(rDataCnt);	
			else 
				DataIn		<= x"00";
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L9 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=3 : Validation drop 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Ethernet Type not valid 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L10 : Loop 
			wait until rising_edge(MacClk); 
			DataInValid	<= '0';
			DataIn		<= x"FF";
			wait until rising_edge(MacClk); 
			DataInValid	<= '1';
			rDataCnt	:= rDataCnt + 1;
			DataIn		<= rData1(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L10 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=4 : Addr not valid 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Target MAC addr not vaild while Requesting 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData2(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L11 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt=2 ) then 
				DataIn	<= x"00";
			else 
				DataIn		<= rData2(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L11 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 1 : Target MAC addr not vaild while Replying 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L12 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt=2 ) then 
				DataIn	<= x"00";
			else 
				DataIn		<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L12 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 2 : Sender IP addr not vaild 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L13 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt=30 ) then 
				DataIn	<= not rData1(rDataCnt);
			else 
				DataIn	<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L13 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT = 3 : Sender IP addr not vaild 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData1(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L14 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			if ( rDataCnt=40 ) then 
				DataIn	<= not rData1(rDataCnt);
			else 
				DataIn	<= rData1(rDataCnt);	
			end if;
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxEOP	<= '1';
			end if;
			exit L14 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=4 : Error flags 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : RxError(1)  =  '1'
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM);
		
		rDataCnt		:= 0;
		DataIn			<= rData2(rDataCnt);
		DataInValid		<= '1';
		RxSOP			<= '1';
		
		L15 : Loop 
			wait until rising_edge(MacClk); 
			rDataCnt	:= rDataCnt + 1;
			DataIn		<= rData2(rDataCnt);	
			RxSOP		<= '0';
			if ( rDataCnt=41 ) then 
				RxError(1)	<= '1';
				RxEOP		<= '1';
			end if;
			exit L15 when rDataCnt=42;
		End Loop;
		DataInValid		<= '0';
		RxEOP			<= '0';
		RxError(1)		<= '0';
		wait until rising_edge(MacClk); 
		
		wait for 20*tClk;
		--------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
		
	End Process u_Test;

End Architecture HTWTestBench;
		