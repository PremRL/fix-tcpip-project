----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		ClkAdaptor.vhd
-- Title		
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         

-- Version      1.00
-- Author       K.Norawit
-- Date         2020/10/06
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--	Comment below is FYI note
--	1.  
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

Entity ClkAdaptor Is
Port
(
	MacRstB					: in	std_logic;
	RstB					: in	std_logic;
	RxMacClk				: in	std_logic;
	Clk						: in	std_logic; 
	
	--	Input from RxMAC (RxMacClk)
	MacSOP					: in	std_logic;
	MacValid				: in	std_logic;
	MacEOP					: in	std_logic;
	MacData					: in	std_logic_vector( 7 downto 0 );
	MacError				: in	std_logic_vector( 1 downto 0 );
	
	-- TestErrorPort (RxMacClk)
	PktDropError			: out	std_logic;
	
	-- Output to RxTCPIP (Clk)
	SOP						: out	std_logic;
	DataValid				: out	std_logic;
	EOP						: out	std_logic;
	Data					: out	std_logic_vector( 7 downto 0 );
	RxMacError				: out	std_logic_vector( 1 downto 0 )
	
);
End Entity ClkAdaptor;

Architecture rt1 Of ClkAdaptor Is

----------------------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------------------
	
	Component AsynFIFO16x16 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC 
		
	);
	End Component AsynFIFO16x16;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	signal	rSOP				:	std_logic;
	signal	rDataValid			:	std_logic;
	signal	rEOP				:	std_logic;
	signal	rData				:	std_logic_vector( 7 downto 0 );
	signal	rRxMacError			:	std_logic_vector( 1 downto 0 );
	signal	rPktDropError		:	std_logic;
	
	-- FIFO Wr I/F (RxMacClk)
	signal	WrFull				: std_logic;
	signal	rWrReq				: std_logic;
	signal	rWrData				: std_logic_vector( 15 downto 0 );
	
	-- FIFO Rd I/F (Clk)
	signal	RdEmpty				: std_logic;
	signal	RdReq				: std_logic;
	signal	rRdReqFF			: std_logic;
	signal	rRdData				: std_logic_vector( 15 downto 0 );
	signal	AsynClear			: std_logic;
	
Begin

----------------------------------------------------------------------------------
-- Component Mapping
----------------------------------------------------------------------------------

	u_AsynFIFO16x16: AsynFIFO16x16
	Port map
	(	
		aclr		=> AsynClear,
		data		=> rWrData	,
		rdclk		=> Clk		,
		rdreq		=> RdReq   	,
		wrclk		=> RxMacClk ,
		wrreq		=> rWrReq   ,
		q			=> rRdData  ,
		rdempty		=> RdEmpty  ,
		wrfull		=> WrFull   

	);	

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	SOP				<= rSOP				;
	DataValid		<= rDataValid		;
	EOP				<= rEOP		        ;
	Data			<= rData		    ;
	RxMacError		<= rRxMacError		;
	PktDropError	<= rPktDropError    ;
	
----------------------------------------------------------------------------------
-- Internal Process (Combination)
----------------------------------------------------------------------------------
	
	RdReq		<= not RdEmpty;
	AsynClear	<= not RstB;
	
----------------------------------------------------------------------------------
--	Wr I/F (RxMacClk)
----------------------------------------------------------------------------------	
	
	u_rWrReq : Process(RxMacClk) Is
	Begin
		if ( rising_edge(RxMacClk) ) then
			if ( MacRstB='0' ) then
				rWrReq	<= '0';
			else
				if ( MacValid='1' ) then
					rWrReq		<= '1';
				else
					rWrReq		<= '0';
				end if;
			end if;
		end if;
	End Process u_rWrReq;
	
	u_rWrData : Process(RxMacClk) Is
	Begin
		if ( rising_edge(RxMacClk) ) then
			if ( MacValid='1' ) then
				-- redundant (bit 12-15)
				rWrData(15 downto 12)	<= x"0";
				
				-- Mac Error (bit 11 and 10)
				if ( MacError(1)='1' ) then
					rWrData(11)	<= '1';
				else
					rWrData(11)	<= '0';
				end if;
				
				if ( MacError(0)='1' ) then
					rWrData(10)	<= '1';
				else
					rWrData(10)	<= '0';
				end if;
				
				-- SOP (bit 9)
				if ( MacSOP='1' ) then
					rWrData(9)	<= '1';
				else
					rWrData(9)	<= '0';
				end if;
				
				-- EOP (bit 8)
				if ( MacEOP='1' ) then
					rWrData(8)	<= '1';
				else
					rWrData(8)	<= '0';
				end if;
				
				-- Data (bit 0-7)
				rWrData(7 downto 0)	<= MacData(7 downto 0);
			else
				rWrData(15 downto 0)	<= rWrData(15 downto 0);
			end if;
		end if;
	End Process u_rWrData;
	
	u_rPktDropError : Process(RxMacClk) Is
	Begin
		if ( rising_edge(RxMacClk) ) then
			if ( MacRstB='0' ) then
				rPktDropError	<= '0';
			else
				if ( MacValid='1' and WrFull='1' ) then
					rPktDropError	<= '1';
				else
					rPktDropError	<= rPktDropError;
				end if;
			end if;
		end if;
	End Process u_rPktDropError;
	
----------------------------------------------------------------------------------
--	Rd I/F (Clk) and Output to RxTCPIP
----------------------------------------------------------------------------------
	
	u_rRdReqFF : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRdReqFF	<= '0';
			else
				if ( RdReq='1' ) then
					rRdReqFF	<= '1';
				else
					rRdReqFF	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRdReqFF;
	
	u_rDataOut : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			rData(7 downto 0)	<= rRdData(7 downto 0);
		end if;
	End Process u_rDataOut;
	
	u_rDataValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rDataValid	<= '0';
			else
				if ( rRdReqFF='1' ) then
					rDataValid	<= '1';
				else
					rDataValid	<= '0';
				end if;
			end if;
		end if;
	End Process u_rDataValid;
	
	u_rFlagOut : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRxMacError(1 downto 0)	<= "00";
				rSOP					<= '0';
				rEOP					<= '0';
			else
				if ( rRdReqFF='1' ) then
					rRxMacError(1)		<= rRdData(11);
					rRxMacError(0)		<= rRdData(10);
					rSOP				<= rRdData(9);
					rEOP				<= rRdData(8);
				else
					rRxMacError(1 downto 0)	<= "00";
					rSOP					<= '0';
					rEOP					<= '0';
				end if;
			end if;
		end if;
	End Process u_rFlagOut;
	
End Architecture rt1;