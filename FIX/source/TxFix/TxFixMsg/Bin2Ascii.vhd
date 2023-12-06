----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     Bin2Ascii.vhd
-- Title        Convert binary to ASCII
-- 
-- Author       L.Ratchanon
-- Date         2021/01/23
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- Fixed point binary to Ascii code with decimal point supported  
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity Bin2Ascii Is
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
End Entity Bin2Ascii;

Architecture rtl Of Bin2Ascii Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cFixed_Int09		: std_logic_vector(31 downto 0) :=  x"05F5_E0FF"; -- 99,999,999
	constant cFixed_Int19		: std_logic_vector(31 downto 0) :=  x"0BEB_C1FF"; -- 199,999,999
	constant cFixed_Int29		: std_logic_vector(31 downto 0) :=  x"11E1_A2FF"; -- 299,999,999
	constant cFixed_Int39		: std_logic_vector(31 downto 0) :=  x"17D7_83FF"; -- 399,999,999
	constant cFixed_Int49		: std_logic_vector(31 downto 0) :=  x"1DCD_64FF"; -- 499,999,999
	constant cFixed_Int59		: std_logic_vector(31 downto 0) :=  x"23C3_45FF"; -- 599,999,999
	constant cFixed_Int69		: std_logic_vector(31 downto 0) :=  x"29B9_26FF"; -- 699,999,999
	constant cFixed_Int79		: std_logic_vector(31 downto 0) :=  x"2FAF_07FF"; -- 799,999,999
	constant cFixed_Int89		: std_logic_vector(31 downto 0) :=  x"35A4_E8FF"; -- 899,999,999
	
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
	
	constant RAM_DEPTH : integer := 9;
	constant RAM_WIDTH : integer := 8;

	type array9ofu8 is array (0 to RAM_DEPTH - 1) of std_logic_vector( RAM_WIDTH-1 downto 0);
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	signal rRAM9x8 				: array9ofu8;
	
	-- control 
	signal 	rCtrlCal			: std_logic_vector( 4 downto 0 );
	signal  rBinInDecPointEn	: std_logic;
	
	-- calculator 
	signal	rBinTempDataCal1	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal2	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal3	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal4	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal5	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal6	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal7	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal8	: std_logic_vector(30 downto 0 );
	signal	rBinTempDataCal9	: std_logic_vector(30 downto 0 );
	signal  rBinDataCal			: std_logic_vector(29 downto 0 );
	
	-- calculating counter 
	signal  rByteCnt			: std_logic_vector( 2 downto 0 );
	signal  rIntByteCnt			: std_logic_vector( 2 downto 0 );
	
	-- Write interface 
	signal  rMapBin2AsciiData	: std_logic_vector( 7 downto 0 );
	signal  rWrDataCnt			: std_logic_vector( 3 downto 0 );
	signal  rWrAddr				: std_logic_vector( 3 downto 0 );
	
	-- Read Interface 
	signal  rRdLength			: std_logic_vector( 3 downto 0 );
	signal  rRdAddr             : std_logic_vector( 3 downto 0 );
	signal  rRdRamEn			: std_logic;
	
	-- Output signal 
	signal	rAsciiOutReq		: std_logic;	
	signal	rAsciiOutEop		: std_logic;
	signal	rAsciiOutVal		: std_logic;
	signal	rAsciiOutData		: std_logic_vector( 7 downto 0 );
	

Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

	AsciiOutReq					<= rAsciiOutReq;			
	AsciiOutEop					<= rAsciiOutEop;
	AsciiOutVal	                <= rAsciiOutVal;	
	AsciiOutData( 7 downto 0 )  <= rAsciiOutData( 7 downto 0 );
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

	u_FFsignal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( BinInStart='1' ) then 
				rBinInDecPointEn	<= BinInDecPointEn;
			else 
				rBinInDecPointEn	<= rBinInDecPointEn;
			end if;
		end if;
	End Process u_FFsignal;

	u_rCtrlCal : Process (Clk) Is 
	Begin 
		if (rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rCtrlCal( 4 downto 0 )	<= (others=>'0');
			else
				-- Bit 0: This is busy signal for calculating output message 
				if ( rByteCnt=0 and  rCtrlCal(2)='1' ) then 
					rCtrlCal(0)	<= '0';
				elsif ( BinInStart='1' ) then 
					rCtrlCal(0)	<= '1';
				else 
					rCtrlCal(0)	<= rCtrlCal(0);
				end if;
				
				-- Bit 1: Calulating overflow process 
				if ( rCtrlCal(2)='1' ) then 
					rCtrlCal(1)	<= '0';
				elsif ( rCtrlCal(0)='1' ) then 
					rCtrlCal(1)	<= '1';
				else 
					rCtrlCal(1)	<= rCtrlCal(1);
				end if;
				
				-- Bit 2: Comparing signal 
				if ( rCtrlCal(1)='1' and rCtrlCal(2)='0' ) then 
					rCtrlCal(2)	<= '1';
				else 
					rCtrlCal(2)	<= '0';
				end if;
				
				-- Bit 3: Data encode enable 
					-- there's 1-9 encoding or control signal for always encoding has been set 
				if ( (rCtrlCal(2)='1' and (rBinTempDataCal1(30)='1' or rCtrlCal(4)='1')) 
					-- Add Dot 
					or (rCtrlCal(3)='1' and rCtrlCal(1 downto 0)="01" 
					and rIntByteCnt=7 and rBinInDecPointEn='1') ) then 
					rCtrlCal(3)	<= '1';
				else 
					rCtrlCal(3)	<= '0';
				end if;
				
				-- Bit 4: Always encode data 
				if ( BinInStart='1') then 
					rCtrlCal(4)	<= '0';
				-- there's some BCD positive integer already been encoded or 
				-- last Integer byte 
				elsif ( rCtrlCal(3)='1' or rIntByteCnt=0 ) then 
					rCtrlCal(4)	<= '1';
				else 
					rCtrlCal(4)	<= rCtrlCal(4);
				end if;
				
			end if;
		end if;
	End Process u_rCtrlCal;
	
	u_rByteCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( BinInStart='1' ) then 
				rByteCnt( 2 downto 0 )	<= "111"; 
			elsif ( rCtrlCal(2)='1' ) then  
				rByteCnt( 2 downto 0 )	<= rByteCnt( 2 downto 0 ) - 1; 
			else 
				rByteCnt( 2 downto 0 )	<= rByteCnt( 2 downto 0 );
			end if;
		end if;
	End Process u_rByteCnt;
	
	-- Counting integer of binary value 
	u_rIntByteCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( BinInStart='1' ) then 
				rIntByteCnt( 2 downto 0 )	<= "111" - BinInNegativeExp(2 downto 0); 
			elsif ( rCtrlCal(2)='1' ) then  
				rIntByteCnt( 2 downto 0 )	<= rIntByteCnt( 2 downto 0 ) - 1; 
			else 
				rIntByteCnt( 2 downto 0 )	<= rIntByteCnt( 2 downto 0 );
			end if;
		end if;
	End Process u_rIntByteCnt;

	u_rBinDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( BinInStart='1' ) then 
				rBinDataCal(29 downto 0 )	<= "000"&BinInData(26 downto 0 );
			-- Multiply with 10 (In Decimal)
			elsif ( rCtrlCal(0)='1' and rCtrlCal(1)='0' ) then 
				rBinDataCal(29 downto 0 )	<= (rBinDataCal(26 downto 0 )&"000") + ("00"&rBinDataCal(26 downto 0 )&'0');
			-- After compare 
			-- overflow: 9 
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal9(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal9(26 downto 0 ));
			-- overflow: 8 
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal8(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal8(26 downto 0 ));
			-- overflow: 7 
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal7(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal7(26 downto 0 ));
			-- overflow: 6
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal6(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal6(26 downto 0 ));
			-- overflow: 5
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal5(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal5(26 downto 0 ));
			-- overflow: 4
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal4(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal4(26 downto 0 ));
			-- overflow: 3
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal3(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal3(26 downto 0 ));
			-- overflow: 2
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal2(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal2(26 downto 0 ));
			-- overflow: 1
			elsif ( rCtrlCal(2)='1' and rBinTempDataCal1(30)='1' ) then 
				rBinDataCal(29 downto 0 )	<= not ("111"&rBinTempDataCal1(26 downto 0 ));
			else 
				rBinDataCal(29 downto 0 )	<= rBinDataCal(29 downto 0 );
			end if;
		end if;
	End Process u_rBinDataCal;
	
	u_rBinTempDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rBinTempDataCal1(30 downto 0)	<= cFixed_Int09(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal2(30 downto 0)	<= cFixed_Int19(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal3(30 downto 0)	<= cFixed_Int29(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal4(30 downto 0)	<= cFixed_Int39(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal5(30 downto 0)	<= cFixed_Int49(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal6(30 downto 0)	<= cFixed_Int59(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal7(30 downto 0)	<= cFixed_Int69(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal8(30 downto 0)	<= cFixed_Int79(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
			rBinTempDataCal9(30 downto 0)	<= cFixed_Int89(30 downto 0) - ('0'&rBinDataCal(29 downto 0));
		end if;
	End Process u_rBinTempDataCal;

----------------------------------------------------------------------------
-- Binary to ASCII code process and write ram Interface 
	
	-- Data encode, validate when rCtrlCal bit 3 is set 
	u_rMapBin2AsciiData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Encode Dot 
			if ( rCtrlCal(1)='0' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cDotAscii;
			-- Encode 9 
			elsif ( rBinTempDataCal9(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii9;
			-- Encode 8
			elsif ( rBinTempDataCal8(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii8;
			-- Encode 7
			elsif ( rBinTempDataCal7(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii7;
			-- Encode 6
			elsif ( rBinTempDataCal6(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii6;
			-- Encode 5
			elsif ( rBinTempDataCal5(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii5;
			-- Encode 4
			elsif ( rBinTempDataCal4(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii4;
			-- Encode 3
			elsif ( rBinTempDataCal3(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii3;
			-- Encode 2
			elsif ( rBinTempDataCal2(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii2;
			-- Encode 1
			elsif ( rBinTempDataCal1(30)='1' ) then 
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii1;
			-- Encode 0
			else
				rMapBin2AsciiData( 7 downto 0 )	<= cBCD2Ascii0;
			end if;
		end if;
	End Process u_rMapBin2AsciiData;
	
	u_rWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rWrAddr( 3 downto 0 )	<= (others=>'0');
			else 
				-- Reset when 8
				if ( rWrAddr(3)='1' and rCtrlCal(3)='1' ) then 
					rWrAddr( 3 downto 0 )	<= (others=>'0');
				-- Increment if writing data 
				elsif ( rCtrlCal(3)='1' ) then 
					rWrAddr( 3 downto 0 )	<= rWrAddr( 3 downto 0 ) + 1;
				else 
					rWrAddr( 3 downto 0 )	<= rWrAddr( 3 downto 0 );
				end if;
			end if;
		end if;
	End Process u_rWrAddr;
	
	u_rWrDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset 
			if ( BinInStart='1' ) then 
				rWrDataCnt( 3 downto 0 )	<= (others=>'0');
			elsif ( rCtrlCal(3)='1' ) then 
				rWrDataCnt( 3 downto 0 )	<= rWrDataCnt( 3 downto 0 ) + 1;
			else 
				rWrDataCnt( 3 downto 0 )	<= rWrDataCnt( 3 downto 0 );
			end if;
		end if;
	End Process u_rWrDataCnt; 
	
	u_rRAM9x8 : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rCtrlCal(3)='1' ) then 
				rRAM9x8(conv_integer(rWrAddr))	<= rMapBin2AsciiData( 7 downto 0 );
			else 
				rRAM9x8(conv_integer(rWrAddr))	<= rRAM9x8(conv_integer(rWrAddr));
			end if;
		end if;
	End Process u_rRAM9x8;

----------------------------------------------------------------------------
-- Read Interface 
	
	u_rRdLength : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rAsciiOutReq='1' and AsciiInReady='0' ) then 
				rRdLength( 3 downto 0 )	<= rWrDataCnt( 3 downto 0 );
			else 
				rRdLength( 3 downto 0 )	<= rRdLength( 3 downto 0 ) - 1;
			end if;
		end if;
	End Process u_rRdLength;
	
	u_rRdRamEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRdRamEn	<= '0';
			else 
				if ( rAsciiOutReq='1' and AsciiInReady='0' ) then 
					rRdRamEn	<= '1';
				elsif ( rRdLength=1 ) then 
					rRdRamEn	<= '0';
				else 
					rRdRamEn	<= rRdRamEn;
				end if;
			end if;
		end if;
	End Process u_rRdRamEn;
	
	u_rRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRdAddr( 3 downto 0 )	<= (others=>'0');
			else 
				-- Reset when 8
				if ( rRdAddr(3)='1' and (rAsciiOutReq='0' or AsciiInReady='1') and rRdRamEn='1' ) then 
					rRdAddr( 3 downto 0 )	<= (others=>'0');
				-- Increment if reading data 
				elsif ( (rAsciiOutReq='0' or AsciiInReady='1') and rRdRamEn='1' ) then 
					rRdAddr( 3 downto 0 )	<= rRdAddr( 3 downto 0 ) + 1;
				else 
					rRdAddr( 3 downto 0 )	<= rRdAddr( 3 downto 0 );
				end if;
			end if;
		end if;
	End Process u_rRdAddr;
	
----------------------------------------------------------------------------
-- Output Generator 
	
	u_rAsciiOutReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutReq	<= '0';
			else 
				if ( AsciiInReady='1' ) then 
					rAsciiOutReq	<= '0';
				elsif ( rCtrlCal(3 downto 0)="1000" ) then 
					rAsciiOutReq	<= '1';
				else 
					rAsciiOutReq	<= rAsciiOutReq;
				end if;
			end if;
		end if; 
	End Process u_rAsciiOutReq; 
	
	u_rAsciiOutEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutEop	<= '0';
			else 
				if ( (rAsciiOutReq='0' or AsciiInReady='1')
					and rRdRamEn='1' and rRdLength=1) then 
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
				rAsciiOutVal	<= '0';
			else 
				if ( (rAsciiOutReq='0' or AsciiInReady='1') and rRdRamEn='1' ) then 
					rAsciiOutVal	<= '1';
				else 
					rAsciiOutVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rAsciiOutVal; 
	
	u_rAsciiOutData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rAsciiOutData( 7 downto 0 )	<= rRAM9x8(conv_integer(rRdAddr));
		end if;
	End Process u_rAsciiOutData;
	
End Architecture rtl;