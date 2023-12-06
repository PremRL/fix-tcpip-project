----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     Bin2AsciiPipe.vhd
-- Title        Convert binary to ASCII with pipling 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- Fixed point binary (2 decimal digit) to Ascii code with decimal point supported  
-- 6 Clk cycle computational time before sending 1st digit out (No wait request)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity Bin2AsciiPipe Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		BinInStart			: in	std_logic;
		BinInData			: in 	std_logic_vector( 6 downto 0 ); -- Max 99 

		AsciiOutEop			: out 	std_logic;
		AsciiOutVal			: out 	std_logic;
		AsciiOutData		: out 	std_logic_vector( 7 downto 0 )
	);
End Entity Bin2AsciiPipe;

Architecture rtl Of Bin2AsciiPipe Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cFixed_Int09		: std_logic_vector(10 downto 0) :=  "000"&x"63"; -- 99
	constant cFixed_Int19		: std_logic_vector(10 downto 0) :=  "000"&x"C7"; -- 199
	constant cFixed_Int29		: std_logic_vector(10 downto 0) :=  "001"&x"2B"; -- 299
	constant cFixed_Int39		: std_logic_vector(10 downto 0) :=  "001"&x"8F"; -- 399
	constant cFixed_Int49		: std_logic_vector(10 downto 0) :=  "001"&x"F3"; -- 499
	constant cFixed_Int59		: std_logic_vector(10 downto 0) :=  "010"&x"57"; -- 599
	constant cFixed_Int69		: std_logic_vector(10 downto 0) :=  "010"&x"BB"; -- 699
	constant cFixed_Int79		: std_logic_vector(10 downto 0) :=  "011"&x"1F"; -- 799
	constant cFixed_Int89		: std_logic_vector(10 downto 0) :=  "011"&x"83"; -- 899
	
	constant cBCD2Ascii0		: std_logic_vector( 7 downto 0) :=	x"30";
	constant cBCD2Ascii1		: std_logic_vector( 7 downto 0) :=	x"31";
	constant cBCD2Ascii2		: std_logic_vector( 7 downto 0) :=	x"32";
	constant cBCD2Ascii3		: std_logic_vector( 7 downto 0) :=	x"33";
	constant cBCD2Ascii4		: std_logic_vector( 7 downto 0) :=	x"34";
	constant cBCD2Ascii5		: std_logic_vector( 7 downto 0) :=	x"35";
	constant cBCD2Ascii6		: std_logic_vector( 7 downto 0) :=	x"36";
	constant cBCD2Ascii7		: std_logic_vector( 7 downto 0) :=	x"37";
	constant cBCD2Ascii8		: std_logic_vector( 7 downto 0) :=	x"38";
	constant cBCD2Ascii9		: std_logic_vector( 7 downto 0) :=	x"39";
	constant cDotAscii			: std_logic_vector( 7 downto 0) :=	x"2E";
	

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- control 
	signal 	rCtrlCal			: std_logic_vector( 3 downto 0 );
	signal  rCtrlBusy			: std_logic;
	
	-- calculator 0 
	signal	rBinTemp0Cal1		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal2		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal3		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal4		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal5		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal6		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal7		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal8		: std_logic_vector(10 downto 0 );
	signal	rBinTemp0Cal9		: std_logic_vector(10 downto 0 );
	signal  rBinData0			: std_logic_vector( 9 downto 0 );
	signal  r1StDigitTemp		: std_logic_vector( 3 downto 0 );
	
	-- calculator 1 
	signal	rBinTemp1Cal1		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal2		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal3		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal4		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal5		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal6		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal7		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal8		: std_logic_vector(10 downto 0 );
	signal	rBinTemp1Cal9		: std_logic_vector(10 downto 0 );
	signal  rBinData1			: std_logic_vector( 9 downto 0 );
	
	
	-- Output signal 
	signal	rAsciiOutEop		: std_logic;
	signal	rAsciiOutVal		: std_logic_vector( 1 downto 0 );
	signal	rAsciiOutData		: std_logic_vector( 7 downto 0 );
	

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	AsciiOutEop					<= rAsciiOutEop;
	AsciiOutVal	                <= rAsciiOutVal(0);	
	AsciiOutData( 7 downto 0 )  <= rAsciiOutData( 7 downto 0 );
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
	
	u_rCtrlBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlBusy	<= '0';
			else 
				if ( rCtrlBusy='0' and BinInStart='1' ) then 
					rCtrlBusy	<= '1';
				else 
					rCtrlBusy	<= '0';
				end if;
			end if;
		end if;
	End Process u_rCtrlBusy;
	
	u_rCtrlCal : Process (Clk) Is 
	Begin 
		if (rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlCal( 2 downto 0 )	<= (others=>'0');
			else
				-- Bit 0: Encoding digit 0
				if ( rCtrlBusy='0' and BinInStart='1' ) then 
					rCtrlCal(0)	<= '1';
				elsif ( rCtrlCal(1)='0' ) then 
					rCtrlCal(0)	<= '0';
				else 
					rCtrlCal(0)	<= rCtrlCal(0);
				end if;
				
				-- Bit 1: Used to reset Bit 0 
				if ( rCtrlBusy='0' and BinInStart='1' ) then 
					rCtrlCal(1)	<= '1';
				else 
					rCtrlCal(1)	<= '0';
				end if;
				
				-- Bit 2: Encoding digit 1
				if ( rCtrlCal(1 downto 0)="01" ) then 
					rCtrlCal(2)	<= '1';
				elsif ( rCtrlCal(3)='0' ) then 
					rCtrlCal(2)	<= '0';
				else 
					rCtrlCal(2)	<= rCtrlCal(2);
				end if;
				
				-- Bit 3: Used to reset Bit 2 
				if ( rCtrlCal(1 downto 0)="01" ) then 
					rCtrlCal(3)	<= '1';
				else 
					rCtrlCal(3)	<= '0';
				end if;
				
			end if;
		end if;
	End Process u_rCtrlCal;
	

	u_rBinDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Calculating Binary data 0 
			-- Multiply with 10 (In Decimal)
			if ( BinInStart='1' ) then 
				rBinData0( 9 downto 0 )	<= (BinInData( 6 downto 0 )&"000") + ("00"&BinInData( 6 downto 0 )&'0');
			else 
				rBinData0( 9 downto 0 )	<= rBinData0( 9 downto 0 );
			end if;
			
			-- Calculating Binary data 1
			-- subtracting from rBinData0 and multiplying by 10 next clk cycle 
			-- Using Comparator to perform subtraction 
			
			-- overflow: 9 
			if ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal9(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal9(6 downto 0));
			-- overflow: 8 
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal8(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal8(6 downto 0));
			-- overflow: 7 
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal7(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal7(6 downto 0));
			-- overflow: 6
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal6(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal6(6 downto 0));
			-- overflow: 5
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal5(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal5(6 downto 0));
			-- overflow: 4
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal4(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal4(6 downto 0));
			-- overflow: 3
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal3(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal3(6 downto 0 ));
			-- overflow: 2
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal2(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal2(6 downto 0));
			-- overflow: 1
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal1(10)='1' ) then 
				rBinData1( 9 downto 0 )	<= not ("111"&rBinTemp0Cal1(6 downto 0));
			-- Not overflow
			elsif ( rCtrlCal(1 downto 0)="01" ) then 
				rBinData1( 9 downto 0 )	<= rBinData0( 9 downto 0 );
			else 
				rBinData1( 9 downto 0 )	<= (rBinData1( 6 downto 0 )&"000") + ("00"&rBinData1( 6 downto 0 )&'0');
			end if;
			
		end if;
	End Process u_rBinDataCal;
	
	u_rStDigitTemp : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal9(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"9";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal8(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"8";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal7(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"7";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal6(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"6";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal5(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"5";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal4(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"4";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal3(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"3";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal2(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"2";
			elsif ( rCtrlCal(1 downto 0)="01" and rBinTemp0Cal1(10)='1' ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"1";
			elsif ( rCtrlCal(1 downto 0)="01" ) then 
				r1StDigitTemp( 3 downto 0 )	<= x"0";
			else 
				r1StDigitTemp( 3 downto 0 )	<= r1StDigitTemp( 3 downto 0 ); 
			end if; 
		end if;
	End Process u_rStDigitTemp;
	
	u_rBinTempDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Calculate for Temp 0 
			rBinTemp0Cal1(10 downto 0)	<= cFixed_Int09(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal2(10 downto 0)	<= cFixed_Int19(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal3(10 downto 0)	<= cFixed_Int29(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal4(10 downto 0)	<= cFixed_Int39(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal5(10 downto 0)	<= cFixed_Int49(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal6(10 downto 0)	<= cFixed_Int59(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal7(10 downto 0)	<= cFixed_Int69(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal8(10 downto 0)	<= cFixed_Int79(10 downto 0) - ('0'&rBinData0(9 downto 0));
			rBinTemp0Cal9(10 downto 0)	<= cFixed_Int89(10 downto 0) - ('0'&rBinData0(9 downto 0));
			-- Calculate for Temp 1 
			rBinTemp1Cal1(10 downto 0)	<= cFixed_Int09(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal2(10 downto 0)	<= cFixed_Int19(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal3(10 downto 0)	<= cFixed_Int29(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal4(10 downto 0)	<= cFixed_Int39(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal5(10 downto 0)	<= cFixed_Int49(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal6(10 downto 0)	<= cFixed_Int59(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal7(10 downto 0)	<= cFixed_Int69(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal8(10 downto 0)	<= cFixed_Int79(10 downto 0) - ('0'&rBinData1(9 downto 0));
			rBinTemp1Cal9(10 downto 0)	<= cFixed_Int89(10 downto 0) - ('0'&rBinData1(9 downto 0));
		end if;
	End Process u_rBinTempDataCal;

----------------------------------------------------------------------------
-- Output Generator
	
	-- Data encode, validate when rCtrlCal bit 3 is set 
	u_rAsciiOutData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 

			-- Encode 9 
			if ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"9")
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal9(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii9;
			-- Encode 8
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"8")
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal8(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii8;
			-- Encode 7
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"7") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal7(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii7;
			-- Encode 6
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"6") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal6(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii6;
			-- Encode 5
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"5") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal5(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii5;
			-- Encode 4
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"4") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal4(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii4;
			-- Encode 3
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"3") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal3(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii3;
			-- Encode 2
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"2") 
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal2(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii2;
			-- Encode 1
			elsif ( (rCtrlCal(3 downto 2)="01" and r1StDigitTemp(3 downto 0)=x"1")
				or (rAsciiOutVal(1 downto 0)="11" and rBinTemp1Cal1(10)='1') ) then 
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii1;
			-- Encode 0
			else
				rAsciiOutData( 7 downto 0 )	<= cBCD2Ascii0;
			end if;
		end if;
	End Process u_rAsciiOutData;

	u_rAsciiOutEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutEop	<= '0';
			else 
				if ( rAsciiOutVal(1 downto 0)="11" ) then 
					rAsciiOutEop	<= '1';
				else 
					rAsciiOutEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAsciiOutEop;
	
	u_rAsciiOutVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutVal( 1 downto 0 )	<= "00";
			else 
				if ( rCtrlCal(3 downto 2)="01" ) then 
					rAsciiOutVal(0)	<= '1';
				elsif ( rAsciiOutEop='1' ) then 
					rAsciiOutVal(0)	<= '0';
				else 
					rAsciiOutVal(0)	<= rAsciiOutVal(0);
				end if;
				
				-- Bit 1: Used to create EOP and second digit of data 
				if ( rCtrlCal(3 downto 2)="01" ) then 
					rAsciiOutVal(1)	<= '1';
				else 
					rAsciiOutVal(1)	<= '0';	
				end if;
				
			end if;
		end if;
	End Process u_rAsciiOutVal; 
	
End Architecture rtl;