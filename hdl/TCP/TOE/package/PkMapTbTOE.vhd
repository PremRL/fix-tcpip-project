-- Package Mapping TestBench
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.PkSigTbTOE.all;

Entity PkMapTbTOE Is
End Entity PkMapTbTOE;

Architecture HTWTestBench Of PkMapTbTOE Is 

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component TOE Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		MacRstB					: in	std_logic;
		RxMacClk				: in	std_logic;
		
		-- User Interface 
		-- Control 
		User2TOEConnectReq		: in	std_logic;
		User2TOETerminateReq	: in 	std_logic;
		
		TOE2UserStatus			: out 	std_logic_vector( 3 downto 0 );	
		TOE2UserPSHFlagset		: out	std_logic;
		TOE2UserFINFlagset 		: out	std_logic;
		TOE2UserRSTFlagset		: out 	std_logic;
		
		-- TxTCP  
		User2TOETxDataVal		: in 	std_logic;
		User2TOETxDataSop		: in	std_logic;
		User2TOETxDataEop		: in	std_logic;
		User2TOETxDataIn		: in 	std_logic_vector( 7 downto 0 );
		User2TOETxDataLen		: in	std_logic_vector(15 downto 0 );
		
		TOE2UserTxMemAlFull		: out 	std_logic;
		
		-- Rx TCP 
		User2TOERxReq			: in	std_logic;
		TOE2UserRxSOP			: out	std_logic;
		TOE2UserRxEOP			: out	std_logic;
		TOE2UserRxValid			: out	std_logic;
		TOE2UserRxData			: out	std_logic_vector( 7 downto 0 );
		
		-- User Network Register Interface 
		UNG2TOESenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TOETargetMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TOESenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TOETargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TOESrcPort     		: in	std_logic_vector(15 downto 0 );
		UNG2TOEDesPort     		: in	std_logic_vector(15 downto 0 );
		
		UNG2TOEAddrVal			: in	std_logic;

		-- EMAC Interface 
		--TxMac 
		EMAC2TOETxReady			: in	std_logic;
	
		TOE2EMACTxReq			: out	std_logic;
		TOE2EMACTxDataOut		: out	std_logic_vector(7 downto 0);
		TOE2EMACTxDataOutVal	: out	std_logic;
		TOE2EMACTxDataOutSop	: out	std_logic;
		TOE2EMACTxDataOutEop	: out	std_logic;
		
		-- RxMac 
		EMAC2TOERxSOP			: in	std_logic;
		EMAC2TOERxValid			: in	std_logic;
		EMAC2TOERxEOP			: in	std_logic;
		EMAC2TOERxData			: in	std_logic_vector( 7 downto 0 );
		EMAC2TOERxError			: in	std_logic_vector( 1 downto 0 )
	);
	End Component TOE;	

Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	-- System 
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
		RxMacClk		<= '1';
		wait for tClk/2;
		RxMacClk		<= '0';
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
		rDelay	<='0';
		wait for tClk;
		rDelay	<= '1';
		wait;
	End Process u_rDelay;
	
	-- TxEMAC Interface 
	u_EMAC2TOETxReady : Process 
	Begin 
		if ( RstB='0' ) then
			EMAC2TOETxReady	<= '0';
		else 
			if ( TOE2EMACTxReq='1' ) then 
				EMAC2TOETxReady	<='1';
				wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
				EMAC2TOETxReady	<= '0';
				wait for 11*tClk;
			else 
				EMAC2TOETxReady	<= '0';
			end if;
		end if;
		wait until rising_edge(Clk);
	End Process u_EMAC2TOETxReady;
	
	-- For verification
	u_TOE2EMACTxDataOutFF : Process 
	Begin 
		TOE2EMACTxDataOutFF(47 downto 0)	<= TOE2EMACTxDataOutFF(39 downto 0)&TOE2EMACTxDataOut(7 downto 0);
		wait until rising_edge(Clk);
	End Process u_TOE2EMACTxDataOutFF;

	-- Mapping 
	u_TOE : TOE
	Port map 
	(
		RstB					=> RstB						,
		Clk						=> Clk						,
	
		MacRstB					=> MacRstB					,
		RxMacClk				=> RxMacClk				    ,

		User2TOEConnectReq		=> User2TOEConnectReq_t		,
		User2TOETerminateReq	=> User2TOETerminateReq_t	,
		TOE2UserStatus			=> TOE2UserStatus_t			,
		TOE2UserPSHFlagset		=> TOE2UserPSHFlagset_t		,
		TOE2UserFINFlagset 		=> TOE2UserFINFlagset_t 	,	
		TOE2UserRSTFlagset		=> TOE2UserRSTFlagset_t		,

		User2TOETxDataVal		=> User2TOETxDataVal_t		,
		User2TOETxDataSop		=> User2TOETxDataSop_t		,
		User2TOETxDataEop		=> User2TOETxDataEop_t		,
		User2TOETxDataIn		=> User2TOETxDataIn_t		,
		User2TOETxDataLen		=> User2TOETxDataLen_t		,
		TOE2UserTxMemAlFull		=> TOE2UserTxMemAlFull_t	,	
	
		User2TOERxReq			=> User2TOERxReq_t			,
		TOE2UserRxSOP			=> TOE2UserRxSOP_t			,
		TOE2UserRxEOP			=> TOE2UserRxEOP_t			,
		TOE2UserRxValid			=> TOE2UserRxValid_t		,	
		TOE2UserRxData			=> TOE2UserRxData_t			,

		UNG2TOESenderMACAddr	=> UNG2TOESenderMACAddr_t	,
		UNG2TOETargetMACAddr	=> UNG2TOETargetMACAddr_t	, 
		UNG2TOESenderIpAddr		=> UNG2TOESenderIpAddr_t	,
		UNG2TOETargetIpAddr		=> UNG2TOETargetIpAddr_t	,
		UNG2TOESrcPort     		=> UNG2TOESrcPort_t     	,
		UNG2TOEDesPort     		=> UNG2TOEDesPort_t     	,
		UNG2TOEAddrVal			=> UNG2TOEAddrVal_t			,

		EMAC2TOETxReady			=> EMAC2TOETxReady_t		,	
		TOE2EMACTxReq			=> TOE2EMACTxReq_t			,
		TOE2EMACTxDataOut		=> TOE2EMACTxDataOut_t		,
		TOE2EMACTxDataOutVal	=> TOE2EMACTxDataOutVal_t	,
		TOE2EMACTxDataOutSop	=> TOE2EMACTxDataOutSop_t	,
		TOE2EMACTxDataOutEop	=> TOE2EMACTxDataOutEop_t	,
	
		EMAC2TOERxSOP			=> EMAC2TOERxSOP_t			,
		EMAC2TOERxValid			=> EMAC2TOERxValid_t		,	
		EMAC2TOERxEOP			=> EMAC2TOERxEOP_t			,
		EMAC2TOERxData			=> EMAC2TOERxData_t			,
		EMAC2TOERxError			=> EMAC2TOERxError_t	
	);
	

-- Signal assignment from testbench to TOE with delay time
	User2TOEConnectReq_t		<= User2TOEConnectReq				after 1 ns;
	User2TOETerminateReq_t  	<= User2TOETerminateReq     		after 1 ns;
    User2TOETxDataVal_t	    	<= DataGenRecOut.DataGenVal			after 1 ns;
    User2TOETxDataSop_t	    	<= DataGenRecOut.DataGenSop			after 1 ns;
	User2TOETxDataEop_t	    	<= DataGenRecOut.DataGenEop			after 1 ns;
	User2TOETxDataIn_t	    	<= DataGenRecOut.DataGen			after 1 ns;
	User2TOETxDataLen_t	    	<= DataGenRecOut.DataGenLen			after 1 ns;
	User2TOERxReq_t         	<= User2TOERxReq            		after 1 ns;
	UNG2TOESenderMACAddr_t		<= UNG2TOESenderMACAddr     		after 1 ns;
	UNG2TOETargetMACAddr_t 		<= UNG2TOETargetMACAddr				after 1 ns;
	UNG2TOESenderIpAddr_t		<= UNG2TOESenderIpAddr	    		after 1 ns;
	UNG2TOETargetIpAddr_t		<= UNG2TOETargetIpAddr	    		after 1 ns;
	UNG2TOESrcPort_t     		<= UNG2TOESrcPort     	    		after 1 ns;
	UNG2TOEDesPort_t     		<= UNG2TOEDesPort     	    		after 1 ns;
	UNG2TOEAddrVal_t			<= UNG2TOEAddrVal		    		after 1 ns;
	EMAC2TOETxReady_t       	<= EMAC2TOETxReady         			after 1 ns;
	EMAC2TOERxSOP_t		    	<= RxDataGenRecOut.RxDataGenSop     after 1 ns;
	EMAC2TOERxValid_t	    	<= RxDataGenRecOut.RxDataGenVal     after 1 ns;
	EMAC2TOERxEOP_t		    	<= RxDataGenRecOut.RxDataGenEop     after 1 ns;
	EMAC2TOERxData_t			<= RxDataGenRecOut.RxDataGen        after 1 ns;
	EMAC2TOERxError_t	    	<= RxDataGenRecOut.RxDataGenError   after 1 ns;
	
-- Sinal assignment from TOE to testbench with delay time
	TOE2UserStatus				<= TOE2UserStatus_t					after 1 ns;
	TOE2UserPSHFlagset		    <= TOE2UserPSHFlagset_t	    		after 1 ns;
	TOE2UserFINFlagset 		    <= TOE2UserFINFlagset_t 			after 1 ns;
	TOE2UserRSTFlagset		    <= TOE2UserRSTFlagset_t	    		after 1 ns;
	TOE2UserTxMemAlFull         <= TOE2UserTxMemAlFull_t    		after 1 ns;
	TOE2UserRxSOP		        <= TOE2UserRxSOP_t		    		after 1 ns;
	TOE2UserRxEOP		        <= TOE2UserRxEOP_t		    		after 1 ns;
	TOE2UserRxValid		        <= TOE2UserRxValid_t				after 1 ns; 
	TOE2UserRxData		        <= TOE2UserRxData_t		    		after 1 ns;
	TOE2EMACTxReq		        <= TOE2EMACTxReq_t		    		after 1 ns;
	TOE2EMACTxDataOut	        <= TOE2EMACTxDataOut_t	    		after 1 ns;
	TOE2EMACTxDataOutVal        <= TOE2EMACTxDataOutVal_t   		after 1 ns;
	TOE2EMACTxDataOutSop        <= TOE2EMACTxDataOutSop_t   		after 1 ns;
	TOE2EMACTxDataOutEop        <= TOE2EMACTxDataOutEop_t   		after 1 ns;
	
End Architecture HTWTestBench;