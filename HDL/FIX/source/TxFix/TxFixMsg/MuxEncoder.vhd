----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     MuxEncoder.vhd
-- Title        Mutiplexer for multiple ASCII encoders and users 
-- 
-- Author       L.Ratchanon
-- Date         2021/01/31
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- Maximum capacity is 2, Users must send InMuxStart <= 2 times whether it is the 
-- same input path or not. Can not take more than one input on any path at the same time
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity MuxEncoder Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Input 0
		InMuxStart0			: in	std_logic; 
		InMuxTransEn0 		: in	std_logic; 
		InMuxDecPointEn0	: in	std_logic;
		InMuxNegativeExp0	: in 	std_logic_vector( 2 downto 0 );
		InMuxData0			: in 	std_logic_vector(26 downto 0 );
		
		-- Input 1 
		InMuxStart1			: in	std_logic; 
		InMuxTransEn1 		: in	std_logic; 
		InMuxDecPointEn1	: in	std_logic;
		InMuxNegativeExp1	: in 	std_logic_vector( 2 downto 0 );
		InMuxData1			: in 	std_logic_vector(26 downto 0 );
		
		-- Output 0 
		OutMuxReq0			: out	std_logic; 
		OutMuxVal0			: out	std_logic; 
		OutMuxEop0			: out	std_logic; 
		OutMuxData0			: out 	std_logic_vector( 7 downto 0 );
		
		-- Output 1 
		OutMuxReq1			: out	std_logic; 
		OutMuxVal1			: out	std_logic; 
		OutMuxEop1			: out	std_logic; 
		OutMuxData1			: out 	std_logic_vector( 7 downto 0 )
	);
End Entity MuxEncoder;

Architecture rtl Of MuxEncoder Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component Bin2Ascii Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		BinInStart			: in	std_logic;
		BinInDecPointEn		: in    std_logic;
		BinInNegativeExp	: in	std_logic_vector( 2 downto 0 );
		BinInData			: in 	std_logic_vector(26 downto 0 );
		
		AsciiInReady		: in	std_logic;
		AsciiOutReq			: out	std_logic;
		AsciiOutEop			: out 	std_logic;
		AsciiOutVal			: out 	std_logic;
		AsciiOutData		: out 	std_logic_vector( 7 downto 0 )
	);
	End Component Bin2Ascii;

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- control 
	signal 	rCtrlMux0			: std_logic_vector( 1 downto 0 );
	signal 	rCtrlMux1			: std_logic_vector( 1 downto 0 );
	
	-- Encoder Interface 
	signal  rEncoderStart		: std_logic_vector( 1 downto 0 );
	signal  rEncoderInReady		: std_logic_vector( 1 downto 0 );
	
	signal  rEncoderData0		: std_logic_vector(26 downto 0 );
	signal  rEncoderNegativeExp0: std_logic_vector( 2 downto 0 );
	signal  rEncoderDecPointEn0 : std_logic;
	signal  rEncoderData1		: std_logic_vector(26 downto 0 );
	signal  rEncoderNegativeExp1: std_logic_vector( 2 downto 0 );
	signal  rEncoderDecPointEn1 : std_logic;
	
	signal  rEncoderOutData0	: std_logic_vector( 7 downto 0 );
	signal  rEncoderOutReq0		: std_logic;
	signal  rEncoderOutVal0		: std_logic;
	signal  rEncoderOutEop0		: std_logic;
	signal  rEncoderOutData1	: std_logic_vector( 7 downto 0 );
	signal  rEncoderOutReq1		: std_logic;
	signal  rEncoderOutVal1		: std_logic;
	signal  rEncoderOutEop1		: std_logic;
	
	-- Output control  
	signal	rOutMuxBusy			: std_logic_vector( 1 downto 0 );
	signal	rOutMuxSel			: std_logic_vector( 1 downto 0 );
	
	-- Output signal  
	signal  rOutMuxData0		: std_logic_vector( 7 downto 0 );
	signal  rOutMuxData1		: std_logic_vector( 7 downto 0 );
	signal  rOutMuxReq			: std_logic_vector( 1 downto 0 );
	signal  rOutMuxVal			: std_logic_vector( 1 downto 0 );
	signal  rOutMuxEop			: std_logic_vector( 1 downto 0 );

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	OutMuxReq0					<= rOutMuxReq(0);
	OutMuxVal0					<= rOutMuxVal(0);
	OutMuxEop0	                <= rOutMuxEop(0);
	OutMuxData0( 7 downto 0 )	<= rOutMuxData0( 7 downto 0 );
	
	OutMuxReq1	                <= rOutMuxReq(1);
	OutMuxVal1	                <= rOutMuxVal(1);
	OutMuxEop1	                <= rOutMuxEop(1);
	OutMuxData1( 7 downto 0 )	<= rOutMuxData1( 7 downto 0 );
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-- Control signals 

	-- Bit 0: Encoder number 0 responsibility 
	-- Bit 1: Encoder number 1 responsibility 
	-- rCtrlMux0 represents encoder operating 
	-- rCtrlMux1 represents value that "0": Path 0 and "1": Path 1 
	u_rCtrlMux : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlMux0( 1 downto 0 )	<= (others=>'0');
				rCtrlMux1( 1 downto 0 )	<= (others=>'0');
			else 
				if ( (rOutMuxReq(0)='1' and InMuxTransEn0='1' and rOutMuxSel(0)='0') 
					or (rOutMuxReq(1)='1' and InMuxTransEn1='1' and rOutMuxSel(1)='0') ) then 
					rCtrlMux0(0)	<= '0';
				elsif ( rCtrlMux0(0)='0' and (InMuxStart0='1' or InMuxStart1='1') ) then 
					rCtrlMux0(0)	<= '1';
				else 
					rCtrlMux0(0)	<= rCtrlMux0(0);
				end if;
				
				if ( (rOutMuxReq(0)='1' and InMuxTransEn0='1' and rOutMuxSel(0)='1') 
					or (rOutMuxReq(1)='1' and InMuxTransEn1='1' and rOutMuxSel(1)='1') ) then 
					rCtrlMux0(1)	<= '0';
				elsif ( rCtrlMux0(1 downto 0)="01" and (InMuxStart0='1' or InMuxStart1='1') ) then 
					rCtrlMux0(1)	<= '1';
				else 
					rCtrlMux0(1)	<= rCtrlMux0(1);
				end if;
				
				if ( rCtrlMux0(0)='0' and InMuxStart1='1' ) then 
					rCtrlMux1(0)	<= '1';
				elsif ( rCtrlMux0(0)='0' and InMuxStart0='1' ) then 
					rCtrlMux1(0)	<= '0';
				else 
					rCtrlMux1(0)	<= rCtrlMux1(0);
				end if; 
				
				if ( rCtrlMux0(1 downto 0)="01" and InMuxStart1='1' ) then 
					rCtrlMux1(1)	<= '1';
				elsif ( rCtrlMux0(1 downto 0)="01" and InMuxStart0='1' ) then 
					rCtrlMux1(1)	<= '0';
				else 
					rCtrlMux1(1)	<= rCtrlMux1(1);
				end if; 
			end if;
		end if;
	End Process u_rCtrlMux;

----------------------------------------------------------
-- Encoder Interface 
	
	-- Start signal to initialize the encoder 
	u_rEncoderStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rEncoderStart( 1 downto 0 )	<= (others=>'0');
			else 
				if ( rCtrlMux0(0)='0' and (InMuxStart0='1' or InMuxStart1='1') ) then 
					rEncoderStart(0)	<= '1';
				else 
					rEncoderStart(0)	<= '0';
				end if;
				
				if ( rCtrlMux0(1 downto 0)="01" and (InMuxStart0='1' or InMuxStart1='1') ) then 
					rEncoderStart(1)	<= '1';
				else 
					rEncoderStart(1)	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rEncoderStart;
	
	-- Data that wanted to encoder 
	u_rEncoderData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rCtrlMux0(0)='0' and InMuxStart0='1' ) then 
				rEncoderDecPointEn0					<= InMuxDecPointEn0;
				rEncoderNegativeExp0( 2 downto 0 )	<= InMuxNegativeExp0;
				rEncoderData0( 26 downto 0 )		<= InMuxData0;
			elsif ( rCtrlMux0(0)='0' and InMuxStart1='1' ) then 
				rEncoderDecPointEn0					<= InMuxDecPointEn1;
				rEncoderNegativeExp0( 2 downto 0 )	<= InMuxNegativeExp1;
				rEncoderData0( 26 downto 0 )		<= InMuxData1;
			else 
				rEncoderDecPointEn0					<= rEncoderDecPointEn0;
				rEncoderNegativeExp0( 2 downto 0 )	<= rEncoderNegativeExp0( 2 downto 0 );
				rEncoderData0( 26 downto 0 )		<= rEncoderData0( 26 downto 0 );
			end if;
			
			if ( rCtrlMux0(1 downto 0)="01" and InMuxStart0='1' ) then 
				rEncoderDecPointEn1					<= InMuxDecPointEn0;
				rEncoderNegativeExp1( 2 downto 0 )	<= InMuxNegativeExp0;
				rEncoderData1( 26 downto 0 )		<= InMuxData0;
			elsif ( rCtrlMux0(1 downto 0)="01" and InMuxStart1='1' ) then 
				rEncoderDecPointEn1					<= InMuxDecPointEn1;
				rEncoderNegativeExp1( 2 downto 0 )	<= InMuxNegativeExp1;
				rEncoderData1( 26 downto 0 )		<= InMuxData1;
			else 
				rEncoderDecPointEn1					<= rEncoderDecPointEn1;
				rEncoderNegativeExp1( 2 downto 0 )	<= rEncoderNegativeExp1( 2 downto 0 );
				rEncoderData1( 26 downto 0 )		<= rEncoderData1( 26 downto 0 );
			end if;
		end if;
	End Process u_rEncoderData;
	
	-- Ready signal idicated that ready to receive output from Encoder
	-- Bit 0: Encoder number 0 
	-- Bit 1: Encoder number 1 
	u_rEncoderInReady : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rEncoderInReady( 1 downto 0 )	<= (others=>'0');
			else 
				if ( rEncoderOutEop0='1' and rEncoderOutVal0='1' ) then 
					rEncoderInReady(0)	<= '0';
				elsif ( (rOutMuxReq(0)='1' and InMuxTransEn0='1' and rOutMuxSel(0)='0') 
					or (rOutMuxReq(1)='1' and InMuxTransEn1='1' and rOutMuxSel(1)='0') ) then 
					rEncoderInReady(0)	<= '1';
				else 
					rEncoderInReady(0)	<= rEncoderInReady(0); 
				end if;
				
				if ( rEncoderOutEop1='1' and rEncoderOutVal1='1' ) then 
					rEncoderInReady(1)	<= '0';
				elsif ( (rOutMuxReq(0)='1' and InMuxTransEn0='1' and rOutMuxSel(0)='1') 
					or (rOutMuxReq(1)='1' and InMuxTransEn1='1' and rOutMuxSel(1)='1') ) then 
					rEncoderInReady(1)	<= '1';
				else 
					rEncoderInReady(1)	<= rEncoderInReady(1); 
				end if;
			end if; 
		end if;
	End Process u_rEncoderInReady;
	
	u_rBin2Ascii0 : Bin2Ascii
	Port map 
	(
		Clk					=> Clk						,
		RstB				=> RstB                     ,

		BinInStart			=> rEncoderStart(0)         ,
		BinInDecPointEn		=> rEncoderDecPointEn0      ,
		BinInNegativeExp	=> rEncoderNegativeExp0     ,
		BinInData			=> rEncoderData0            ,
	
		AsciiInReady		=> rEncoderInReady(0)       ,
		AsciiOutReq			=> rEncoderOutReq0          ,
		AsciiOutEop			=> rEncoderOutEop0          ,
		AsciiOutVal			=> rEncoderOutVal0          ,
		AsciiOutData		=> rEncoderOutData0
	);

	u_rBin2Ascii1 : Bin2Ascii
	Port map 
	(
		Clk					=> Clk						,
		RstB				=> RstB                     ,
	
		BinInStart			=> rEncoderStart(1)         ,
		BinInDecPointEn		=> rEncoderDecPointEn1      ,
		BinInNegativeExp	=> rEncoderNegativeExp1     ,
		BinInData			=> rEncoderData1            ,

		AsciiInReady		=> rEncoderInReady(1)       ,
		AsciiOutReq			=> rEncoderOutReq1          ,
		AsciiOutEop			=> rEncoderOutEop1          ,
		AsciiOutVal			=> rEncoderOutVal1          ,
		AsciiOutData		=> rEncoderOutData1
	);

----------------------------------------------------------
-- Output path control 
	
	-- Output path busy 
	-- Bit0 => path number 0
	-- Bit1 => path number 1
	u_rOutMuxBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOutMuxBusy( 1 downto 0 )	<= (others=>'0');
			else 
				if ( (rEncoderOutEop0='1' and rEncoderOutVal0='1' and rOutMuxSel(0)='0')
					or (rEncoderOutEop1='1' and rEncoderOutVal1='1' and rOutMuxSel(0)='1') ) then 
					rOutMuxBusy(0)		<= '0';
				elsif ( (rEncoderOutReq0='1' and rCtrlMux1(0)='0') 
					or (rEncoderOutReq1='1' and rCtrlMux1(1)='0') ) then 
					rOutMuxBusy(0)		<= '1';
				else 
					rOutMuxBusy(0)		<= rOutMuxBusy(0);
				end if;
				
				if ( (rEncoderOutEop0='1' and rEncoderOutVal0='1' and rOutMuxSel(1)='0')
					or (rEncoderOutEop1='1' and rEncoderOutVal1='1' and rOutMuxSel(1)='1') ) then 
					rOutMuxBusy(1)		<= '0';
				elsif ( (rEncoderOutReq0='1' and rCtrlMux1(0)='1') 
					or (rEncoderOutReq1='1' and rCtrlMux1(1)='1') ) then 
					rOutMuxBusy(1)		<= '1';
				else 
					rOutMuxBusy(1)		<= rOutMuxBusy(1);
				end if;
			end if; 
		end if;
	End Process u_rOutMuxBusy;
	
	-- Output path selection 
	-- Bit0 => path number 0
	-- Bit1 => path number 1
	-- Value => '0': taking output from encoder number 0 and '1': taking output from encoder number 1
	u_rOutMuxSel : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rEncoderOutReq0='1' and rCtrlMux1(0)='0' and rOutMuxBusy(0)='0' ) then 
				rOutMuxSel(0)		<= '0';
			elsif ( rEncoderOutReq1='1' and rCtrlMux1(1)='0' and rOutMuxBusy(0)='0' ) then 
				rOutMuxSel(0)		<= '1';
			else 
				rOutMuxSel(0)		<= rOutMuxSel(0);
			end if;
			
			if ( rEncoderOutReq0='1' and rCtrlMux1(0)='1' and rOutMuxBusy(1)='0' ) then 
				rOutMuxSel(1)		<= '0';
			elsif ( rEncoderOutReq1='1' and rCtrlMux1(1)='1' and rOutMuxBusy(1)='0' ) then 
				rOutMuxSel(1)		<= '1';
			else 
				rOutMuxSel(1)		<= rOutMuxSel(1);
			end if;
		end if;
	End Process u_rOutMuxSel;
	
----------------------------------------------------------
-- Output generator 
	
	-- Request to send data out 
	-- Bit0 => path number 0
	-- Bit1 => path number 1
	u_rOutMuxReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOutMuxReq( 1 downto 0 )	<= (others=>'0');
			else 
				if ( InMuxTransEn0='1' ) then 
					rOutMuxReq(0)	<= '0';
				elsif ( rOutMuxBusy(0)='0' and ((rEncoderOutReq0='1' and rCtrlMux1(0)='0') 
					or (rEncoderOutReq1='1' and rCtrlMux1(1)='0')) ) then 
					rOutMuxReq(0)	<= '1';
				else 
					rOutMuxReq(0)	<= rOutMuxReq(0);
				end if;
				
				if ( InMuxTransEn1='1' ) then 
					rOutMuxReq(1)	<= '0';
				elsif ( rOutMuxBusy(1)='0' and ((rEncoderOutReq0='1' and rCtrlMux1(0)='1') 
					or (rEncoderOutReq1='1' and rCtrlMux1(1)='1')) ) then 
					rOutMuxReq(1)	<= '1';
				else 
					rOutMuxReq(1)	<= rOutMuxReq(1);
				end if;
			end if; 
		end if;
	End Process u_rOutMuxReq;
	
	-- Output validation 
	-- Bit0 => path number 0
	-- Bit1 => path number 1
	u_rOutMuxVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOutMuxVal( 1 downto 0 )	<= (others=>'0');
			else 
				if ( (rEncoderOutVal0='1' and rOutMuxBusy(0)='1' and rOutMuxSel(0)='0') 
					or (rEncoderOutVal1='1' and rOutMuxBusy(0)='1' and rOutMuxSel(0)='1') ) then 
					rOutMuxVal(0)	<= '1';
				else 
					rOutMuxVal(0)	<= '0';
				end if;
				
				if ( (rEncoderOutVal0='1' and rOutMuxBusy(1)='1' and rOutMuxSel(1)='0') 
					or (rEncoderOutVal1='1' and rOutMuxBusy(1)='1' and rOutMuxSel(1)='1') ) then 
					rOutMuxVal(1)	<= '1';
				else 
					rOutMuxVal(1)	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rOutMuxVal;
	
	-- Output EOP  
	-- Bit0 => path number 0
	-- Bit1 => path number 1
	u_rOutMuxEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOutMuxEop( 1 downto 0 )	<= (others=>'0');
			else 
				if ( (rEncoderOutEop0='1' and rOutMuxBusy(0)='1' and rOutMuxSel(0)='0') 
					or (rEncoderOutEop1='1' and rOutMuxBusy(0)='1' and rOutMuxSel(0)='1')  ) then 
					rOutMuxEop(0)	<= '1';
				else 
					rOutMuxEop(0)	<= '0';
				end if;
				
				if ( (rEncoderOutEop0='1' and rOutMuxBusy(1)='1' and rOutMuxSel(1)='0') 
					or (rEncoderOutEop1='1' and rOutMuxBusy(1)='1' and rOutMuxSel(1)='1')  ) then 
					rOutMuxEop(1)	<= '1';
				else 
					rOutMuxEop(1)	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rOutMuxEop;
	
	-- Output data 
	u_rOutMuxData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rOutMuxBusy(0)='1' and rOutMuxSel(0)='0' ) then 
				rOutMuxData0( 7 downto 0 )	<= rEncoderOutData0;
			else 
				rOutMuxData0( 7 downto 0 )	<= rEncoderOutData1;
			end if;
			
			if ( rOutMuxBusy(1)='1' and rOutMuxSel(1)='0' ) then 
				rOutMuxData1( 7 downto 0 )	<= rEncoderOutData0;
			else 
				rOutMuxData1( 7 downto 0 )	<= rEncoderOutData1;
			end if;
		end if;
	End Process u_rOutMuxData;
	
End Architecture rtl;