----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxFixMsgCtrl.vhd
-- Title        FIX message generating control 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
--
--
-- MsgType 
-- '0000' : TestReq 
-- '0001' : Log on
-- '0010' : Heartbeat
-- '0011' : MrkDataReq
-- '0100' : ResendReq
-- '0101' : SeqReset
-- '0110' : Reject 
-- '0111' : Log out  
-- '1000' : Generate validation 
-- '1111' : Reset Validation  
--
-- SendTime
-- (50 downto 37) Year
-- (36 downto 33) Month
-- (32 downto 28) Day
-- (27 downto 23) Hour
-- (22 downto 17) Min
-- (16 downto 0 ) Millisec
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity TxFixMsgCtrl Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		FixCtrl2TxReq		: in	std_logic;
		FixCtrl2TxPossDupEn : in    std_logic;
		FixCtrl2TxReplyTest : in    std_logic;
		FixTx2CtrlBusy		: out	std_logic;
		
		-- Header Detail 
		MsgType				: in	std_logic_vector( 3  downto 0 );
		MsgSeqNum			: in	std_logic_vector(26  downto 0 );
		MsgSendTime			: in	std_logic_vector(50  downto 0 );
		MsgBeginString		: in	std_logic_vector(63  downto 0 );
		MsgSenderCompID		: in	std_logic_vector(127 downto 0 );
		MsgTargetCompID		: in	std_logic_vector(127 downto 0 );
		
		MsgBeginStringLen   : in	std_logic_vector( 3  downto 0 );
		MsgSenderCompIDLen	: in	std_logic_vector( 4  downto 0 );
		MsgTargetCompIDLen	: in	std_logic_vector( 4  downto 0 );
		
		-- TxFixMsgGen I/F 
		MsgGen2CtrlCheckSum : in 	std_logic_vector( 7  downto 0 );
		MsgGen2CtrlEnd 		: in 	std_logic;	
		MsgGen2CtrlBusy		: in 	std_logic;	
		
		Ctrl2GenMsgReq		: out	std_logic;
		Ctrl2GenMsgType	    : out	std_logic_vector( 2 downto 0 );
		
		-- Mux Ascii encoder I/F 
		AsciiOutReq			: In	std_logic; 
		AsciiOutVal			: In	std_logic; 
		AsciiOutEop			: In	std_logic; 
		AsciiOutData		: In 	std_logic_vector( 7 downto 0 );
		
		AsciiInStart		: out	std_logic; 
		AsciiInTransEn 		: out	std_logic; 
		AsciiInDecPointEn	: out	std_logic;
		AsciiInNegativeExp	: out 	std_logic_vector( 2 downto 0 );
		AsciiInData			: out 	std_logic_vector(26 downto 0 );
		
		-- Payload I/F 
		PayloadRdData		: in 	std_logic_vector( 7  downto 0 );
		PayloadWrAddr		: in 	std_logic_vector( 9  downto 0 );
		PayloadRdAddr		: out 	std_logic_vector( 9  downto 0 );
		
		-- TxTOE I/F 
		TOE2FixMemAlFull	: in 	std_logic;	
		
		Fix2TOEDataVal		: out 	std_logic;
		Fix2TOEDataSop		: out	std_logic;
		Fix2TOEDataEop		: out	std_logic;
		Fix2TOEData			: out 	std_logic_vector( 7  downto 0 );
		Fix2TOEDataLen		: out	std_logic_vector(15  downto 0 )
	);
End Entity TxFixMsgCtrl;

Architecture rtl Of TxFixMsgCtrl Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component Bin2AsciiPipe Is
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
	End Component Bin2AsciiPipe;
	
	Component Ram128x8 Is
	Port
	(
		clock				: IN STD_LOGIC  := '1';
		data				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress			: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wraddress			: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wren				: IN STD_LOGIC  := '0';
		q					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	End Component Ram128x8;
	
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cLength_AddMsg				: std_logic_vector(15 downto 0 ) := x"0012"; -- 18
	constant cLength_Add2Sig			: std_logic_vector(11 downto 0 ) := x"002"; -- 2
	constant cLength_AddBody			: std_logic_vector( 6 downto 0 ) := "010"&x"1"; -- 33 = 33 
	constant cLength_Tag43				: std_logic_vector( 6 downto 0 ) := "000"&x"5"; -- 5 
	
	
	constant cAscii_SOH 				: std_logic_vector( 7 downto 0 ) := x"01";
	constant cAscii_Hyphen				: std_logic_vector( 7 downto 0 ) := x"2D";
	constant cAscii_SemCol				: std_logic_vector( 7 downto 0 ) := x"3A";
	constant cAscii_Equal 				: std_logic_vector( 7 downto 0 ) := x"3D";
	constant cAscii_Y					: std_logic_vector( 7 downto 0 ) := x"59";
	
	constant cTagNum8					: std_logic_vector( 7 downto 0 ) := x"38"; 
	constant cTagNum9					: std_logic_vector( 7 downto 0 ) := x"39"; 
	constant cTagNum10					: std_logic_vector(15 downto 0 ) := x"3130"; 
	constant cTagNum34					: std_logic_vector(15 downto 0 ) := x"3334"; 
	constant cTagNum35					: std_logic_vector(15 downto 0 ) := x"3335"; 
	constant cTagNum43					: std_logic_vector(15 downto 0 ) := x"3433";
	constant cTagNum49					: std_logic_vector(15 downto 0 ) := x"3439";
	constant cTagNum52					: std_logic_vector(15 downto 0 ) := x"3532"; 
	constant cTagNum56					: std_logic_vector(15 downto 0 ) := x"3536"; 	
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- FF signal 
	signal  rMsgSendTimeFF				: std_logic_vector(50 downto 0 );
	signal  rMsgSeqNumFF				: std_logic_vector(26 downto 0 );
	signal  rMsgTypeFF					: std_logic_vector( 3 downto 0 );
	signal	rMsgPossDupEnFF				: std_logic;
	
	-- Control 
	signal	rCtrlChkTxBusy				: std_logic;
	signal  rFixTx2CtrlBusy				: std_logic;
	signal  rAsciiMsgType				: std_logic_vector( 7 downto 0 );
	
	-- TxFixMsgGen I/F 
	signal  rCtrl2GenMsgType			: std_logic_vector( 2 downto 0 );
	signal	rTxCtrl2GenEnd				: std_logic_vector( 1 downto 0 );
	signal  rTxCtrl2GenReq				: std_logic;
	
	-- Ascii encoder process 
	signal  rAsciiEncData				: std_logic_vector(26 downto 0 );
	signal  rAsciiEncNegativeExp		: std_logic_vector( 2 downto 0 );
	signal  rAsciiEncStart				: std_logic;
	signal  rAsciiEncTransEn			: std_logic;
	signal  rAsciiEncDecPointEn			: std_logic;
	
	signal	rAsciiOutCnt				: std_logic_vector( 2 downto 0 );
	signal	rAsciiOutBuffShCnt			: std_logic_vector( 2 downto 0 );
	signal  rAsciiOutBuffReady			: std_logic_vector( 1 downto 0 );
	signal  rAsciiOutBuffShEn			: std_logic_vector( 1 downto 0 );
	signal  rAsciiOutBuffStart			: std_logic;
	signal  rAsciiOutBodyLenReady		: std_logic;
	
	signal  rAsciiOutBuff1				: std_logic_vector(47 downto 0 );
	signal  rAsciiOutBuff0				: std_logic_vector(31 downto 0 );
	
	-- AsciiPipe encoder process 	
	signal  rAsciiPipOutData			: std_logic_vector( 7 downto 0 );
	signal  rAsciiPipOutVal				: std_logic;
	
	signal  rAsciiPipData				: std_logic_vector( 6 downto 0 );
	signal  rAsciiPipCnt				: std_logic_vector( 3 downto 0 );
	signal  rAsciiPipStart				: std_logic;
	
	-- Generate Header After Tag 9 Process 
	signal  rFixGenHd0Tag35				: std_logic_vector( 2 downto 0 );
	signal  rFixGenHd0Tag34             : std_logic_vector( 3 downto 0 );
	signal  rFixGenHd0Tag49             : std_logic_vector( 1 downto 0 );
	signal  rFixGenHd0Tag56             : std_logic_vector( 1 downto 0 );
	signal  rFixGenHd0Tag52             : std_logic_vector( 3 downto 0 );
	signal  rFixGenHd0Tag43             : std_logic_vector( 1 downto 0 );
	
	signal  rFixGenHd0DataCnt			: std_logic_vector( 4 downto 0 );
	signal  rFixGenHd0LenCnt			: std_logic_vector( 4 downto 0 );
	signal  rFixGenHd0AsciiReq			: std_logic_vector( 1 downto 0 );
	signal  rFixGenHd0LenCntEn			: std_logic;
	
	signal  rFixGenHd0Data				: std_logic_vector(31 downto 0 );
	signal  rFixGenHd0Equal				: std_logic_vector( 1 downto 0 );
	signal  rFixGenHd0Hyphen			: std_logic;
	signal  rFixGenHd0SemCol			: std_logic;
	signal  rFixGenHd0Eop				: std_logic;
	signal  rFixGenHd0Soh				: std_logic;
	signal  rFixGenHd0Val				: std_logic;
	
	-- RAM Header process 
	signal  rFixGenHd0WrData			: std_logic_vector( 7 downto 0 );
	signal  rFixGenHd0WrAddr			: std_logic_vector( 6 downto 0 );
	signal  rFixGenHd0RdAddr			: std_logic_vector( 6 downto 0 );
	signal  rFixGenHd0RdData			: std_logic_vector( 7 downto 0 );
	signal  rFixGenHd0WrEn				: std_logic;
	
	signal  rFixGenHd0Checksum			: std_logic_vector( 7 downto 0 );
	signal  rFixGenHd0Length			: std_logic_vector( 6 downto 0 );
	signal  rFixGenHd0End				: std_logic;
	
	signal  rFixGenHd0RdVal				: std_logic_vector( 1 downto 0 );
	signal  rFixGenHd0RdEnd				: std_logic_vector( 1 downto 0 );
	
	-- Generate Header 1 and Trailer Process 
	signal  rFixGen1Start				: std_logic_vector( 2 downto 0 );
	signal  rFixGenHd1Tag8				: std_logic_vector( 2 downto 0 );
	signal  rFixGenHd1Tag9              : std_logic_vector( 3 downto 0 );
	signal  rFixGenTrlTag10           : std_logic_vector( 4 downto 0 );
	
	signal  rFixGen1BodyLen				: std_logic_vector(11 downto 0 );
	signal  rFixGen1AsciiTranEn			: std_logic;
	
	signal  rFixGen1DataCnt				: std_logic_vector( 3 downto 0 );
	signal  rFixGenHd1LenCnt			: std_logic_vector( 3 downto 0 );
	signal  rFixGenHd1LenCntEn			: std_logic;
	
	signal  rFixGen1Data				: std_logic_vector(31 downto 0 );
	signal  rFixGen1Eop					: std_logic_vector( 1 downto 0 );
	signal  rFixGen1Val					: std_logic;
	
	-- Payload Ram Process 
	signal  rPayloadLength				: std_logic_vector( 9 downto 0 );
	signal  rPayloadRdAddr				: std_logic_vector( 9 downto 0 );
	signal  rPayloadRdVal				: std_logic_vector( 1 downto 0 );
	signal  rPayloadRdEnd				: std_logic_vector( 1 downto 0 );
	signal  rPayloadRdEn				: std_logic;
	
	-- Checksum Process 
	signal  rFixGenCheckSum				: std_logic_vector( 7 downto 0 );
	signal  rFixCheckSumStart			: std_logic_vector( 2 downto 0 );
	
	-- Output generator 
	signal  rFix2TOEDataLen				: std_logic_vector(15 downto 0 );
	signal  rFix2TOEData				: std_logic_vector( 7 downto 0 );
	signal  rFix2TOEDataVal				: std_logic;
	signal  rFix2TOEDataEop				: std_logic;
	signal  rFix2TOEDataSop				: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	FixTx2CtrlBusy					<=  rFixTx2CtrlBusy; 
	
	Fix2TOEDataVal					<=  rFix2TOEDataVal;
	Fix2TOEDataSop		            <=  rFix2TOEDataSop;
	Fix2TOEDataEop		            <=  rFix2TOEDataEop;
	Fix2TOEData( 7 downto 0 )		<= 	rFix2TOEData( 7 downto 0 );
	Fix2TOEDataLen(15 downto 0 )	<= 	rFix2TOEDataLen(15 downto 0 );
	
	-- MsgGen 
	Ctrl2GenMsgReq					<= 	rTxCtrl2GenReq;
	Ctrl2GenMsgType( 2 downto 0 )	<=	rCtrl2GenMsgType( 2 downto 0 );    
	
	-- Ascii encoder 
	AsciiInStart					<= 	rAsciiEncStart;	
	AsciiInTransEn 		            <=  rAsciiEncTransEn;
	AsciiInDecPointEn	            <=  rAsciiEncDecPointEn;
	AsciiInNegativeExp( 2 downto 0 )<= 	rAsciiEncNegativeExp( 2 downto 0 );
	AsciiInData(26 downto 0 )		<=  rAsciiEncData(26 downto 0 );
	
	-- Paylaod RAM 
	PayloadRdAddr( 9 downto 0 )		<=  rPayloadRdAddr( 9 downto 0 );		
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-- Control Interface 

	u_rCtrlChkTxBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then 
				rCtrlChkTxBusy	<= '1';
			else 
				if ( FixCtrl2TxReq='1' and (TOE2FixMemAlFull='0'
					or MsgType(3)='1') ) then 
					rCtrlChkTxBusy	<= '0';
				else 
					rCtrlChkTxBusy	<= '1';
				end if; 
			end if;
		end if;
	End Process u_rCtrlChkTxBusy;
	
	u_rFixTx2CtrlBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixTx2CtrlBusy	<= '0';
			else 
				if ( rFix2TOEDataEop='1' or rTxCtrl2GenEnd(1)='1' ) then 
					rFixTx2CtrlBusy	<= '0';
				elsif ( FixCtrl2TxReq='1' and rCtrlChkTxBusy='0' ) then 
					rFixTx2CtrlBusy	<= '1'; 
				else
					rFixTx2CtrlBusy	<= rFixTx2CtrlBusy;
				end if; 
			end if;		
		end if;
	End Process u_rFixTx2CtrlBusy;
	
	u_rFixTx2CtrlDataFF : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( FixCtrl2TxReq='1' and rFixTx2CtrlBusy='0' ) then 
				rMsgPossDupEnFF					<= FixCtrl2TxPossDupEn;
				rMsgTypeFF( 3 downto 0 )		<= MsgType( 3 downto 0 );
				rMsgSeqNumFF( 26 downto 0 )		<= MsgSeqNum( 26 downto 0 );
				rMsgSendTimeFF(50 downto 0 )	<= MsgSendTime(50 downto 0 );
			else 
				rMsgPossDupEnFF					<= rMsgPossDupEnFF;
				rMsgTypeFF( 3 downto 0 )		<= rMsgTypeFF( 3 downto 0 );		
			    rMsgSeqNumFF( 26 downto 0 )		<= rMsgSeqNumFF( 26 downto 0 );	
			    rMsgSendTimeFF(50 downto 0 )	<= rMsgSendTimeFF(50 downto 0 );
			end if; 
		end if;
	End Process u_rFixTx2CtrlDataFF;
	
	-- "000" IS NOT USED 
	u_rAsciiMsgType : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			case (rMsgTypeFF(2 downto 0)) is 
				when "000"	=> rAsciiMsgType(7 downto 0)	<= x"31"; -- TestReq => '1'
				when "001"	=> rAsciiMsgType(7 downto 0)	<= x"41"; -- Logon => 'A'
				when "010"	=> rAsciiMsgType(7 downto 0)	<= x"30"; -- Heartbeat => '0'
				when "011"	=> rAsciiMsgType(7 downto 0)	<= x"56"; -- MrkDataReq => 'V'
				when "100"	=> rAsciiMsgType(7 downto 0)	<= x"32"; -- ResendReq => '2'
				when "101"	=> rAsciiMsgType(7 downto 0)	<= x"34"; -- SeqReset => '4'
				when "110"	=> rAsciiMsgType(7 downto 0)	<= x"33"; -- Reject => '3'
				when others	=> rAsciiMsgType(7 downto 0)	<= x"35"; -- Log out => '5'
			end case; 
		end if;
	End Process u_rAsciiMsgType;
	
-----------------------------------------------------------
-- TxFixMsgGen I/F 
	
	u_rTxCtrl2GenReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTxCtrl2GenReq	<= '0';
			else 
				if ( MsgGen2CtrlBusy='1' ) then 
					rTxCtrl2GenReq	<= '0';
				elsif ( FixCtrl2TxReq='1' and rFixTx2CtrlBusy='1'
					and rMsgTypeFF(3 downto 0)/="0111" 
					and (rMsgTypeFF(3 downto 0)/="0010" or FixCtrl2TxReplyTest='1') ) then 
					rTxCtrl2GenReq	<= '1';
				else 
					rTxCtrl2GenReq	<= rTxCtrl2GenReq; 
				end if;
			end if;
		end if;
	End Process u_rTxCtrl2GenReq;
	
	u_rCtrl2GenMsgType : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- TestReq 
			if ( rMsgTypeFF(3 downto 0)="0000" ) then 
				rCtrl2GenMsgType( 2 downto 0 )	<= "010"; -- Gen 112 
			else 
				rCtrl2GenMsgType( 2 downto 0 )	<= rMsgTypeFF(2 downto 0);
			end if;
		end if;
	End Process u_rCtrl2GenMsgType;
	
	u_rTxCtrl2GenEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then 
				rTxCtrl2GenEnd( 1 downto 0 )	<= (others=>'0');
			else 
				if ( MsgGen2CtrlBusy='1' and rTxCtrl2GenReq='1' and rMsgTypeFF(3)='1' ) then 
					rTxCtrl2GenEnd(0)	<= '1';
				elsif ( MsgGen2CtrlBusy='0' ) then 
					rTxCtrl2GenEnd(0)	<= '0';
				else 
					rTxCtrl2GenEnd(0)	<= rTxCtrl2GenEnd(0);
				end if; 
				
				if ( rTxCtrl2GenEnd(0)='1' and MsgGen2CtrlBusy='0' ) then 
					rTxCtrl2GenEnd(1)	<= '1';
				else 
					rTxCtrl2GenEnd(1)	<= '0';
				end if; 
			end if; 
		end if; 
	End Process u_rTxCtrl2GenEnd;	

-----------------------------------------------------------
-- Ascii encoder process 
	
	u_rAsciiOutCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixTx2CtrlBusy='0' ) then 
				rAsciiOutCnt( 2 downto 0 )	<= (others=>'0');
			elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
				rAsciiOutCnt( 2 downto 0 )	<= rAsciiOutCnt( 2 downto 0 ) + 1;
			else 
				rAsciiOutCnt( 2 downto 0 )	<= rAsciiOutCnt( 2 downto 0 );
			end if; 
		end if;
	End Process u_rAsciiOutCnt;
	
	u_rAsciiEncStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiEncStart	<= '0';
			else 
				if ( rFixGenHd0Tag35(1 downto 0)="01" or rFixGenHd0Tag35(2 downto 1)="01" 
					or (rAsciiOutCnt=0 and rAsciiEncTransEn='1') 
					or rFixGen1Start(2)='1' or rFixCheckSumStart(2)='1' ) then 
					rAsciiEncStart	<= '1';
				else 
					rAsciiEncStart	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rAsciiEncStart;
	
	u_rAsciiEncTransEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiEncTransEn	<= '0';
			else 
				if ( AsciiOutReq='1' and rAsciiEncTransEn='0'
					and (rFixGen1AsciiTranEn='1' or rAsciiOutCnt=0 
					or rAsciiOutCnt=1 or rAsciiOutCnt=2) ) then 
					rAsciiEncTransEn	<= '1';
				else 
					rAsciiEncTransEn	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rAsciiEncTransEn;
	
	u_rAsciiEncData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Encode SeqNum 
			if ( rFixGenHd0Tag35(1 downto 0)="01"  ) then 
				rAsciiEncData(26 downto 0 )	<= rMsgSeqNumFF(26 downto 0 );
			-- Encode year 
			elsif ( rFixGenHd0Tag35(2 downto 1)="01" ) then 
				rAsciiEncData(26 downto 0 )	<= '0'&x"000"&rMsgSendTimeFF(50 downto 37);
			-- Encode millisec 
			elsif ( rAsciiOutCnt=0 and rAsciiEncTransEn='1' ) then 
				rAsciiEncData(26 downto 0 )	<= "00"&x"00"&rMsgSendTimeFF(16 downto 0 );
			-- Encode Bodylength
			elsif ( rFixGen1Start(2)='1' ) then 
				rAsciiEncData(26 downto 0 )	<= "000"&x"000"&rFixGen1BodyLen(11 downto 0 );
			-- Encode Checksum 
			else 
				rAsciiEncData(26 downto 0 )	<= "000"&x"0000"&rFixGenCheckSum(7 downto 0 );
			end if; 
			
			-- Encode millisec  
			if ( rAsciiOutCnt=0 and rAsciiEncTransEn='1' ) then 
				rAsciiEncDecPointEn					<= '1';
				rAsciiEncNegativeExp( 2 downto 0 )	<= "011"; -- 3 
			-- Encode Bodylength
			elsif ( rFixGen1Start(2)='1' ) then 
				rAsciiEncDecPointEn					<= '0';
				rAsciiEncNegativeExp( 2 downto 0 )	<= "100"; -- 4=5 Fixed length 
			-- Encode Checksum
			elsif ( rFixCheckSumStart(2)='1' ) then 
				rAsciiEncDecPointEn					<= '0';
				rAsciiEncNegativeExp( 2 downto 0 )	<= "010"; -- 2=3 Fixed length  
			-- Others only an integer value 
			else 
				rAsciiEncDecPointEn					<= '0';
				rAsciiEncNegativeExp( 2 downto 0 )	<= "000";
			end if; 
		end if;
	End Process u_rAsciiEncData;
	
	-- Ascii output buffering 
	u_rAsciiOutBuff : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Storing year in Ascii 
			if ( (rAsciiOutCnt=1 and AsciiOutVal='1')
				or rAsciiOutBuffShEn(0)='1' ) then 
				rAsciiOutBuff0(31 downto 0 )	<= rAsciiOutBuff0(23 downto 0 )&AsciiOutData(7 downto 0);
			else 
				rAsciiOutBuff0(31 downto 0 )	<= rAsciiOutBuff0(31 downto 0 ); 
			end if; 
			
			-- Storing millisecond in Ascii 
			if ( (rAsciiOutCnt=2 and AsciiOutVal='1')
				or rAsciiOutBuffShEn(1)='1' ) then 
				rAsciiOutBuff1(47 downto 0 )	<= rAsciiOutBuff1(39 downto 0 )&AsciiOutData(7 downto 0);
			else 
				rAsciiOutBuff1(47 downto 0 )	<= rAsciiOutBuff1(47 downto 0 ); 
			end if; 
		end if;
	End Process u_rAsciiOutBuff;
	
	u_rAsciiOutBuffReady : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutBuffReady( 1 downto 0 )	<= (others=>'0');
			else 
				if ( rFixTx2CtrlBusy='0' ) then 
					rAsciiOutBuffReady(0)	<= '0';
				elsif ( rAsciiOutCnt=1 and AsciiOutVal='1' ) then 
					rAsciiOutBuffReady(0)	<= '1';
				else 
					rAsciiOutBuffReady(0)	<= rAsciiOutBuffReady(0);
				end if;
				
				if ( rFixTx2CtrlBusy='0' ) then 
					rAsciiOutBuffReady(1)	<= '0';
				elsif ( rAsciiOutCnt=2 and AsciiOutVal='1' and AsciiOutEop='1' ) then 
					rAsciiOutBuffReady(1)	<= '1';
				else 
					rAsciiOutBuffReady(1)	<= rAsciiOutBuffReady(1);
				end if;
			end if; 
		end if;
	End Process u_rAsciiOutBuffReady;
	
	-- Start sending data in buffer (year or millisec)
	u_rAsciiOutBuffStart : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutBuffStart	<= '0';
			else 
				-- FixGenHd request for year 
				if ( ((rAsciiOutBuffReady(0)='1' and rFixGenHd0AsciiReq(0)='1') 
					-- FixGenHd request for millisec 
					or (rAsciiOutBuffReady(1)='1' and rFixGenHd0AsciiReq(1)='1'))
					and rAsciiOutBuffStart='0' ) then 
					rAsciiOutBuffStart	<= '1';
				else 
					rAsciiOutBuffStart	<= '0';
				end if; 
			end if; 
		end if;
	End Process u_rAsciiOutBuffStart;
	
	u_rAsciiOutBuffShEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rAsciiOutBuffShEn( 1 downto 0 )	<= (others=>'0');
			else 
				if ( rAsciiOutBuffShCnt=3 ) then 
					rAsciiOutBuffShEn(0)	<= '0';
				-- Start shifting year value 
				elsif ( rAsciiOutBuffStart='1' and rFixGenHd0AsciiReq(0)='1' ) then 
					rAsciiOutBuffShEn(0)	<= '1';
				else 
					rAsciiOutBuffShEn(0)	<= rAsciiOutBuffShEn(0);
				end if;
				
				if ( rAsciiOutBuffShCnt=5 ) then 
					rAsciiOutBuffShEn(1)	<= '0';
				-- Start shifting millisec value 
				elsif ( rAsciiOutBuffStart='1' and rFixGenHd0AsciiReq(1)='1' ) then 
					rAsciiOutBuffShEn(1)	<= '1';
				else 
					rAsciiOutBuffShEn(1)	<= rAsciiOutBuffShEn(1);
				end if;
			end if; 
		end if; 
	End Process u_rAsciiOutBuffShEn; 
	
	u_rAsciiOutBuffShCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutBuffShCnt( 2 downto 0 )	<= (others=>'0');
			else
				if ( rAsciiOutBuffShEn(1 downto 0)/="00" ) then 
					rAsciiOutBuffShCnt( 2 downto 0 )	<= rAsciiOutBuffShCnt( 2 downto 0 ) + 1;
				else 
					rAsciiOutBuffShCnt( 2 downto 0 )	<= (others=>'0');
				end if; 
			end if; 
		end if; 
	End Process u_rAsciiOutBuffShCnt; 
	
	u_rAsciiOutBodyLenReady : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiOutBodyLenReady	<= '0';
			else 
				if ( rFixGen1AsciiTranEn='1' ) then 
					rAsciiOutBodyLenReady	<= '0';
				elsif ( rAsciiOutCnt=2 and AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rAsciiOutBodyLenReady	<= '1';
				else 
					rAsciiOutBodyLenReady	<= rAsciiOutBodyLenReady;
				end if;
			end if;
		end if;
	End Process u_rAsciiOutBodyLenReady;
	
-----------------------------------------------------------
-- AsciiPipe encoder process 
	
	u_Bin2AsciiPipe : Bin2AsciiPipe 
	Port map 
	(	
		Clk					=> Clk					,	
		RstB				=> RstB				    ,
		
		BinInStart			=> rAsciiPipStart		,	
		BinInData			=> rAsciiPipData		,	
	
		AsciiOutEop			=> open 			    ,
		AsciiOutVal			=> rAsciiPipOutVal		,	
		AsciiOutData		=> rAsciiPipOutData		
	);
	
	u_rAsciiPipCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiPipCnt( 3 downto 0 )	<= (others=>'0');
			else 
				-- Reset by overflow
				if ( rAsciiPipCnt/=0 or (rAsciiOutBuffReady(0)='1' and rFixGenHd0AsciiReq(0)='1') ) then 
					rAsciiPipCnt( 3 downto 0 )	<= rAsciiPipCnt( 3 downto 0 ) + 1;
				else 
					rAsciiPipCnt( 3 downto 0 )	<= (others=>'0');
				end if;
			end if;
		end if;
	End Process u_rAsciiPipCnt;
	
	u_rAsciiPipData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Minute 
			if ( rAsciiPipCnt=8 ) then 
				rAsciiPipData( 6 downto 0 )	<= '0'&rMsgSendTimeFF(22 downto 17);
			-- Hour 
			elsif ( rAsciiPipCnt=5 ) then 
				rAsciiPipData( 6 downto 0 )	<= "00"&rMsgSendTimeFF(27 downto 23);
			-- Day 
			elsif ( rAsciiPipCnt=2 ) then 
				rAsciiPipData( 6 downto 0 )	<= "00"&rMsgSendTimeFF(32 downto 28);
			-- Month 
			else 
				rAsciiPipData( 6 downto 0 )	<= "000"&rMsgSendTimeFF(36 downto 33);
			end if; 
 		end if; 
	End Process u_rAsciiPipData;
	
	-- Start encoding the data 
	u_rAsciiPipStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiPipStart	<= '0';
			else 
				if ( ((rAsciiOutBuffReady(0)='1' and rFixGenHd0AsciiReq(0)='1') 
					or rAsciiPipCnt=2 or rAsciiPipCnt=5 or rAsciiPipCnt=8) and rAsciiPipStart='0' ) then 
					rAsciiPipStart	<= '1';
				else 
					rAsciiPipStart	<= '0';
				end if; 
			end if; 	
 		end if; 
	End Process u_rAsciiPipStart;
	
-----------------------------------------------------------
-- Generate Header After Tag 9 Process 
	
	u_rFixGenHd0Tag : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Tag35( 2 downto 0 )	<= (others=>'0');
				rFixGenHd0Tag34( 3 downto 0 )	<= (others=>'0');
				rFixGenHd0Tag49( 1 downto 0 )	<= (others=>'0');
				rFixGenHd0Tag56( 1 downto 0 )	<= (others=>'0');
				rFixGenHd0Tag52( 3 downto 0 )	<= (others=>'0');
				rFixGenHd0Tag43( 1 downto 0 )	<= (others=>'0');
			else 
				rFixGenHd0Tag35(2 downto 1)	<= rFixGenHd0Tag35(1 downto 0);
				if ( (MsgGen2CtrlEnd='1' or (FixCtrl2TxReq='1' and (rMsgTypeFF(3 downto 0)="0111" 
					or (rMsgTypeFF(3 downto 0)="0010" and FixCtrl2TxReplyTest='0')))) and rFixTx2CtrlBusy='1' ) then 
					rFixGenHd0Tag35(0)	<= '1';
				elsif ( rFixGenHd0Equal(1)='1' ) then 
					rFixGenHd0Tag35(0)	<= '0';
				else
					rFixGenHd0Tag35(0)	<= rFixGenHd0Tag35(0); 
				end if; 
				
				rFixGenHd0Tag34(3 downto 1)	<= rFixGenHd0Tag34(2 downto 0);
				if ( rFixGenHd0Equal(1)='1' and rFixGenHd0Tag35(1)='1' ) then 
					rFixGenHd0Tag34(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rFixGenHd0Tag34(0)	<= '0';
				else
					rFixGenHd0Tag34(0)	<= rFixGenHd0Tag34(0); 
				end if; 
				
				rFixGenHd0Tag49(1)	<= rFixGenHd0Tag49(0);
				if ( AsciiOutEop='1' and AsciiOutVal='1' and rFixGenHd0Tag34(1)='1' ) then 
					rFixGenHd0Tag49(0)	<= '1';
				elsif ( rFixGenHd0LenCnt=1 and rFixGenHd0LenCntEn='1' ) then 
					rFixGenHd0Tag49(0)	<= '0';
				else
					rFixGenHd0Tag49(0)	<= rFixGenHd0Tag49(0); 
				end if; 
				
				rFixGenHd0Tag56(1)	<= rFixGenHd0Tag56(0);
				if ( rFixGenHd0LenCnt=1 and rFixGenHd0LenCntEn='1' and rFixGenHd0Tag49(1)='1' ) then 
					rFixGenHd0Tag56(0)	<= '1';
				elsif ( rFixGenHd0LenCnt=1 and rFixGenHd0LenCntEn='1' ) then 
					rFixGenHd0Tag56(0)	<= '0';
				else
					rFixGenHd0Tag56(0)	<= rFixGenHd0Tag56(0); 
				end if; 
				
				rFixGenHd0Tag52(3 downto 1)	<= rFixGenHd0Tag52(2 downto 0);
				if ( rFixGenHd0LenCnt=1 and rFixGenHd0LenCntEn='1' and rFixGenHd0Tag56(1)='1' ) then 
					rFixGenHd0Tag52(0)	<= '1';
				elsif ( rAsciiOutBuffShCnt=5 ) then 
					rFixGenHd0Tag52(0)	<= '0';
				else
					rFixGenHd0Tag52(0)	<= rFixGenHd0Tag52(0); 
				end if; 
				
				rFixGenHd0Tag43(1)	<= rFixGenHd0Tag43(0);
				if ( rAsciiOutBuffShCnt=5 and rMsgPossDupEnFF='1' ) then 
					rFixGenHd0Tag43(0)	<= '1';
				elsif ( rFixGenHd0Equal(1)='1' ) then 
					rFixGenHd0Tag43(0)	<= '0';
				else
					rFixGenHd0Tag43(0)	<= rFixGenHd0Tag43(0); 
				end if; 
			end if; 
		end if; 
	End Process u_rFixGenHd0Tag;
	
	-- String of tag 49 and 56 process 
	u_rFixGenHd0DataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0Tag35(1 downto 0)="01" or rFixGenHd0Soh='1' or rAsciiOutBuffStart='1' ) then 
				rFixGenHd0DataCnt( 4 downto 0 )	<= (others=>'0');
			else 
				rFixGenHd0DataCnt( 4 downto 0 )	<= rFixGenHd0DataCnt( 4 downto 0 ) + 1;
			end if;
		end if; 
	End Process u_rFixGenHd0DataCnt;
	
	u_rFixGenHd0LenCnt : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0Tag49(1 downto 0)="01" ) then 
				rFixGenHd0LenCnt( 4 downto 0 )	<= MsgSenderCompIDLen( 4 downto 0 );
			elsif ( rFixGenHd0Tag56(1 downto 0)="01" ) then 
				rFixGenHd0LenCnt( 4 downto 0 )	<= MsgTargetCompIDLen( 4 downto 0 );
			elsif ( rFixGenHd0LenCntEn='1' ) then 
				rFixGenHd0LenCnt( 4 downto 0 )	<= rFixGenHd0LenCnt( 4 downto 0 ) - 1;
			else 
				rFixGenHd0LenCnt( 4 downto 0 )	<= rFixGenHd0LenCnt( 4 downto 0 );
			end if; 
		end if; 
	End Process u_rFixGenHd0LenCnt;
	
	u_rFixGenHd0LenCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0LenCntEn	<= '0';
			else 
				if ( rFixGenHd0Equal(0)='1' and (rFixGenHd0Tag49(1)='1' 
					or rFixGenHd0Tag56(1)='1') ) then 
					rFixGenHd0LenCntEn	<= '1';
				elsif ( rFixGenHd0LenCnt=1 ) then 
					rFixGenHd0LenCntEn	<= '0';
				else 
					rFixGenHd0LenCntEn	<= rFixGenHd0LenCntEn;
				end if; 
			end if; 
		end if; 
	End Process u_rFixGenHd0LenCntEn;
	
	-- Tag 52 (MsgSendTime) Process 
	u_rFixGenHd0AsciiReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0AsciiReq( 1 downto 0 )	<= (others=>'0');
			else 
				if ( rAsciiOutBuffStart='1' ) then 
					rFixGenHd0AsciiReq(0)	<= '0';
				elsif ( rFixGenHd0Tag52(2 downto 1)="01" ) then 
					rFixGenHd0AsciiReq(0)	<= '1';
				else 
					rFixGenHd0AsciiReq(0)	<= rFixGenHd0AsciiReq(0); 
				end if; 
				
				if ( rAsciiOutBuffStart='1' ) then 
					rFixGenHd0AsciiReq(1)	<= '0';
				elsif ( rAsciiPipCnt=14 ) then 
					rFixGenHd0AsciiReq(1)	<= '1';
				else 
					rFixGenHd0AsciiReq(1)	<= rFixGenHd0AsciiReq(1); 
				end if; 
			end if;
		end if;
	End Process u_rFixGenHd0AsciiReq; 
	
	u_rFixGenHd0Char : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Hyphen <= '0';
				rFixGenHd0SemCol <= '0';
			else 
				if ( rAsciiPipCnt=9 ) then 
					rFixGenHd0Hyphen	<= '1';
				else 
					rFixGenHd0Hyphen	<= '0';
				end if; 
				
				if ( rAsciiPipCnt=12 or rAsciiPipCnt=15 ) then 
					rFixGenHd0SemCol 	<= '1';
				else 
					rFixGenHd0SemCol 	<= '0';
				end if; 
			end if;
		end if; 
	End Process u_rFixGenHd0Char;
	
	-- Output of Market data message 
	u_rFixGenHd0Eop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Eop		<= '0';
			else 
				-- When PossDupFlag set 
				if ( (rFixGenHd0Equal(1)='1' and rFixGenHd0Tag43(1)='1')
					-- when MsgSendTime already transmitted 
					or (rAsciiOutBuffShCnt=5 and rMsgPossDupEnFF='0') ) then 
					rFixGenHd0Eop	<= '1'; 
				else 
					rFixGenHd0Eop	<= '0';
				end if;
			end if;
		end if;	
	End Process u_rFixGenHd0Eop;
	
	u_rFixGenHd0Soh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Soh		<= '0';
			else 
				-- Used Equal sign as an end flag indicator of Tag 35, 43
				if ( (rFixGenHd0Equal(1)='1' and (rFixGenHd0Tag35(1)='1' or rFixGenHd0Tag43(1)='1')) 
					-- End of Tag 49, 56 
					or (rFixGenHd0LenCnt=1 and rFixGenHd0LenCntEn='1') 
					-- End of Tag 34
					or (AsciiOutEop='1' and AsciiOutVal='1' and rAsciiOutCnt=0) 
					-- End of Tag 52
					or rAsciiOutBuffShCnt=5 ) then 
					rFixGenHd0Soh	<= '1';
				else 
					rFixGenHd0Soh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rFixGenHd0Soh;
	
	u_rFixGenHd0Equal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Equal( 1 downto 0 )	<= (others=>'0');
			else 
				rFixGenHd0Equal(1)	<= rFixGenHd0Equal(0);
				if ( (rFixGenHd0DataCnt=1 and (rFixGenHd0Tag35(1)='1' or rFixGenHd0Tag49(1)='1'
					or rFixGenHd0Tag56(1)='1' or rFixGenHd0Tag43(1)='1'))
					or rFixGenHd0Tag34(3 downto 2)="01" or rFixGenHd0Tag52(3 downto 2)="01" ) then 
					rFixGenHd0Equal(0)	<= '1';
				else 
					rFixGenHd0Equal(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rFixGenHd0Equal;
	
	u_rFixGenHd0Val : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0Val	<= '0';
			else 
				if ( rAsciiOutBuffStart='1' or rFixGenHd0Tag35(1 downto 0)="01"
					or (rFixGenHd0Tag34(1)='1' and AsciiOutEop='1' and AsciiOutVal='1') ) then 
					rFixGenHd0Val	<= '1';
				elsif ( (rFixGenHd0Equal(0)='1' and (rFixGenHd0Tag34(1)='1' or 
					rFixGenHd0Tag52(1)='1')) or (rFixGenHd0DataCnt=14 and rFixGenHd0AsciiReq(1)='1')
					or rFixGenHd0Eop='1' ) then 
					rFixGenHd0Val	<= '0';
				else 
					rFixGenHd0Val	<= rFixGenHd0Val;
				end if;
			end if;
		end if;
	End Process u_rFixGenHd0Val;
	
	-- Using Bit 31 downto 24 as a output 
	u_rFixGenHd0Data : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			if ( rFixGenHd0Tag35(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum35&x"00"&rAsciiMsgType(7 downto 0); 
			elsif ( rFixGenHd0Tag34(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum34&x"0000"; 
			elsif ( rFixGenHd0Tag49(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum49&x"0000"; 
			elsif ( rFixGenHd0Tag56(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum56&x"0000"; 
			elsif ( rFixGenHd0Tag52(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum52&x"0000"; 
			elsif ( rFixGenHd0Tag43(1 downto 0)="01" ) then 
				rFixGenHd0Data(31 downto 0 )	<= cTagNum43&x"00"&cAscii_Y; 
			-------------
			-- Field 49 value 
			elsif ( rFixGenHd0Tag49(1)='1' and rFixGenHd0DataCnt=2 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgSenderCompID(127 downto 96);
			elsif ( rFixGenHd0Tag49(1)='1' and rFixGenHd0DataCnt=6 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgSenderCompID( 95 downto 64);
			elsif ( rFixGenHd0Tag49(1)='1' and rFixGenHd0DataCnt=10 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgSenderCompID( 63 downto 32);
			elsif ( rFixGenHd0Tag49(1)='1' and rFixGenHd0DataCnt=14 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgSenderCompID( 31 downto 0 );
			-- Field 56 value	 
			elsif ( rFixGenHd0Tag56(1)='1' and rFixGenHd0DataCnt=2 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgTargetCompID(127 downto 96);
			elsif ( rFixGenHd0Tag56(1)='1' and rFixGenHd0DataCnt=6 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgTargetCompID( 95 downto 64);
			elsif ( rFixGenHd0Tag56(1)='1' and rFixGenHd0DataCnt=10 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgTargetCompID( 63 downto 32);
			elsif ( rFixGenHd0Tag56(1)='1' and rFixGenHd0DataCnt=14 ) then 
				rFixGenHd0Data(31 downto 0 )	<= MsgTargetCompID( 31 downto 0 );
			-------------
			-- Byte shifting 
			else
				rFixGenHd0Data(31 downto 0 )	<= rFixGenHd0Data(23 downto 0 )&x"00";
			end if; 
		end if;
	End Process u_rFixGenHd0Data;
	
-----------------------------------------------------------
-- RAM Header process 

	u_RamHd128 : Ram128x8
	Port map 
	(
		clock		=> Clk 					,
		data		=> rFixGenHd0WrData     ,
		rdaddress	=> rFixGenHd0RdAddr     ,
		wraddress	=> rFixGenHd0WrAddr     ,
		wren		=> rFixGenHd0WrEn       ,
		q		    => rFixGenHd0RdData
	);
	
	u_rFixGenHd0WrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Direct Ascii Muxencoder (SeqNum)
			if ( AsciiOutVal='1' and rAsciiOutCnt=0 ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= AsciiOutData( 7 downto 0 );
			-- Indirect Ascii Muxencoder (Buffing 0 Year)
			elsif ( rAsciiOutBuffShEn(0)='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= rAsciiOutBuff0(31 downto 24);
			-- Indirect Ascii Muxencoder (Buffing 1 Millisec)
			elsif ( rAsciiOutBuffShEn(1)='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= rAsciiOutBuff1(47 downto 40);
			-- Data from Ascii PipeEncdoer 
			elsif ( rAsciiPipOutVal='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= rAsciiPipOutData( 7 downto 0 );
			-- Constant SOH 
			elsif ( rFixGenHd0Soh='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= cAscii_SOH( 7 downto 0 );
			-- Constant Equal 
			elsif ( rFixGenHd0Equal(0)='1' ) then
				rFixGenHd0WrData( 7 downto 0 )	<= cAscii_Equal( 7 downto 0 );
			-- Constant Hyphen 
			elsif ( rFixGenHd0Hyphen='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= cAscii_Hyphen( 7 downto 0 );
			-- Constant Semicolon  
			elsif ( rFixGenHd0SemCol='1' ) then 
				rFixGenHd0WrData( 7 downto 0 )	<= cAscii_SemCol( 7 downto 0 );
			-- Direct data 
			else 
				rFixGenHd0WrData( 7 downto 0 )	<= rFixGenHd0Data(31 downto 24);
			end if;
		end if; 
	End Process u_rFixGenHd0WrData;
	
	u_rFixGenHd0WrEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rFixGenHd0WrEn	<= '0';
			else 
				if ( (AsciiOutVal='1' and rAsciiOutCnt=0) or rFixGenHd0Val='1'  ) then 
					rFixGenHd0WrEn	<= '1';
				else 
					rFixGenHd0WrEn	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rFixGenHd0WrEn; 
	
	u_rFixGenHd0WrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0Tag35(1 downto 0)="01" ) then 
				rFixGenHd0WrAddr( 6 downto 0 )	<= (others=>'0');
			elsif ( rFixGenHd0WrEn='1' ) then 
				rFixGenHd0WrAddr( 6 downto 0 )	<= rFixGenHd0WrAddr( 6 downto 0 ) + 1;
			else 
				rFixGenHd0WrAddr( 6 downto 0 )	<= rFixGenHd0WrAddr( 6 downto 0 );
			end if;
		end if;
	End Process u_rFixGenHd0WrAddr; 
	
	-- Data of Header 0 
	u_rFixGenHd0Checksum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0Tag35(1 downto 0)="01" ) then 
				rFixGenHd0Checksum( 7 downto 0 )	<= (others=>'0');
			elsif ( rFixGenHd0WrEn='1' ) then 
				rFixGenHd0Checksum( 7 downto 0 )	<= rFixGenHd0Checksum( 7 downto 0 ) + rFixGenHd0WrData( 7 downto 0 );
			else 
				rFixGenHd0Checksum( 7 downto 0 )	<= rFixGenHd0Checksum( 7 downto 0 );
			end if;
		end if;
	End Process u_rFixGenHd0Checksum; 
	
	-- Data of Header 0 
	u_rFixGenHd0Length : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0Tag35(1 downto 0)="01" ) then 
				rFixGenHd0Length( 6 downto 0 )	<= (others=>'0');
			elsif ( rFixGen1Start(0)='1' and rMsgPossDupEnFF='1' ) then 
				rFixGenHd0Length( 6 downto 0 )	<= rFixGenHd0Length( 6 downto 0 ) + cLength_AddBody + cLength_Tag43
													+ ("00"&MsgSenderCompIDLen) + ("00"&MsgTargetCompIDLen);
			elsif ( rFixGen1Start(0)='1' ) then 
				rFixGenHd0Length( 6 downto 0 )	<= rFixGenHd0Length( 6 downto 0 ) + cLength_AddBody 
													+ ("00"&MsgSenderCompIDLen) + ("00"&MsgTargetCompIDLen);
			-- Counting Tag 34 and 35
			elsif ( rFixGenHd0WrEn='1' and (rFixGenHd0Tag34(2)='1' or rFixGenHd0Tag35(2)='1') ) then 
				rFixGenHd0Length( 6 downto 0 )	<= rFixGenHd0Length( 6 downto 0 ) + 1;
			-- Reading 
			elsif ( rFixGenHd0RdVal(0)='1' ) then 
				rFixGenHd0Length( 6 downto 0 )	<= rFixGenHd0Length( 6 downto 0 ) - 1;
			else 
				rFixGenHd0Length( 6 downto 0 )	<= rFixGenHd0Length( 6 downto 0 );
			end if;
		end if;
	End Process u_rFixGenHd0Length; 

	-- checksum validation 
	u_rFixGenHd0End : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0End	<= '0';
			else
				if ( rFixGenHd0Eop='1' ) then 
					rFixGenHd0End	<= '1';
				else 
					rFixGenHd0End	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rFixGenHd0End; 	

	-- Read RAM Header Process 
	u_rFixGenHd0RdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0RdVal(0)='1' ) then 
				rFixGenHd0RdAddr( 6 downto 0 )	<= rFixGenHd0RdAddr( 6 downto 0 ) + 1;
			else 
				rFixGenHd0RdAddr( 6 downto 0 )	<= (others=>'0');
			end if;
		end if; 
	End Process u_rFixGenHd0RdAddr;
	
	u_rFixGenHd0RdVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0RdVal(1 downto 0 )	<= (others=>'0');
			else 
				rFixGenHd0RdVal(1)	<= rFixGenHd0RdVal(0);
				-- Start sending seoond header from Hd ram 
				if ( rFixGen1Eop(0)='1' and rFixGenHd1Tag9(1)='1' ) then 
					rFixGenHd0RdVal(0)	<= '1';
				elsif ( rFixGenHd0RdEnd(1)='1' ) then 
					rFixGenHd0RdVal(0)	<= '0';
				else 
					rFixGenHd0RdVal(0)	<= rFixGenHd0RdVal(0);
				end if; 
			end if; 
		end if; 
	End Process u_rFixGenHd0RdVal; 
	
	-- Detect End of transmitting Header 
	u_rFixGenHd0RdEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd0RdEnd( 1 downto 0 )	<= "00";
			else 
				rFixGenHd0RdEnd(1)	<= rFixGenHd0RdEnd(0);
				if ( rPayloadRdVal(0)='1' or rFixGenTrlTag10(0)='1' ) then 
					rFixGenHd0RdEnd(0)	<= '0';
				elsif ( rFixGenHd0RdVal(1)='1' and rFixGenHd0Length=3 ) then 
					rFixGenHd0RdEnd(0)	<= '1';
				else 
					rFixGenHd0RdEnd(0)	<= rFixGenHd0RdEnd(0); 
				end if; 
			end if; 
		end if; 
	End Process u_rFixGenHd0RdEnd; 
	
-----------------------------------------------------------
-- Generate Header 1 Process and Trailer
-- Start generating when end of tag 35 in Generate Header 0 Process 
	
	-- Detect Start of Process 
	u_rFixGen1Start : Process (Clk) Is 
	Begin 	
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGen1Start( 2 downto 0 )	<= "000";
			else 
				rFixGen1Start(2 downto 1)	<= rFixGen1Start(1 downto 0);
				-- End of Writing Tag 34 in Header RAM 
				if ( rFixGenHd0Tag34(2 downto 1)="10" ) then 
					rFixGen1Start(0)	<= '1';
				else 
					rFixGen1Start(0)	<= '0';	
				end if;
			end if;
		end if;
	End Process u_rFixGen1Start;
	
	u_rFixGen1BodyLen	: Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGen1Start(1)='1' ) then 
				rFixGen1BodyLen(11 downto 0 )	<= ('0'&x"0"&rFixGenHd0Length(6 downto 0)) + ("00"&rPayloadLength(9 downto 0));
			else 
				rFixGen1BodyLen(11 downto 0 )	<= rFixGen1BodyLen(11 downto 0 ); 
			end if; 
		end if;
	End Process u_rFixGen1BodyLen;
	
	u_rFixGen1Tag : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rFixGenHd1Tag8( 2 downto 0 )	<= (others=>'0');
				rFixGenHd1Tag9( 3 downto 0 )	<= (others=>'0');
				rFixGenTrlTag10( 4 downto 0 )	<= (others=>'0'); 
			else 
				rFixGenHd1Tag8(2 downto 1)	<= rFixGenHd1Tag8(1 downto 0);
				if ( rFixGen1Start(0)='1' ) then 
					rFixGenHd1Tag8(0)	<= '1';
				elsif ( rFixGenHd1LenCnt=1 and rFixGenHd1LenCntEn='1' ) then 
					rFixGenHd1Tag8(0)	<= '0';
				else 
					rFixGenHd1Tag8(0)	<= rFixGenHd1Tag8(0);
				end if; 
				
				rFixGenHd1Tag9(3 downto 1)	<= rFixGenHd1Tag9(2 downto 0);
				if ( rFixGenHd1LenCnt=1 and rFixGenHd1LenCntEn='1' ) then 
					rFixGenHd1Tag9(0)	<= '1';
				elsif ( rFixGen1Eop(0)='1' ) then 
					rFixGenHd1Tag9(0)	<= '0';
				else 
					rFixGenHd1Tag9(0)	<= rFixGenHd1Tag9(0);
				end if; 
				
				rFixGenTrlTag10(4 downto 1)	<= rFixGenTrlTag10(3 downto 0);
				if ( rPayloadRdEnd(1)='1' or (rFixGenHd0RdEnd(1)='1' and rPayloadRdEn='0') ) then 
					rFixGenTrlTag10(0)	<= '1';
				elsif ( rFixGen1Eop(0)='1' ) then 
					rFixGenTrlTag10(0)	<= '0';
				else 
					rFixGenTrlTag10(0)	<= rFixGenTrlTag10(0);
				end if; 
			end if;
		end if;
	End Process u_rFixGen1Tag;
	
	u_rFixGen1AsciiTranEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGen1AsciiTranEn	<= '0';
			else 
				if ( rAsciiEncTransEn='1' ) then 
					rFixGen1AsciiTranEn	<= '0';
					-- Transferring Bodylength 
				elsif ( (rAsciiOutBodyLenReady='1' and rFixGenHd1Tag9(0)='1')
					-- Transferring Checksum
					or (rPayloadRdEnd(0)='1' or (rFixGenHd0RdEnd(0)='1' and rPayloadRdEn='0')) ) then 
					rFixGen1AsciiTranEn	<= '1';
				else 
					rFixGen1AsciiTranEn	<= rFixGen1AsciiTranEn; 
				end if; 
			end if; 
		end if;
	End Process u_rFixGen1AsciiTranEn;
	
	u_rFixGen1DataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd1Tag8(1 downto 0)="01" or rFixGenHd1Tag9(1 downto 0)="01" 
				or rFixGenTrlTag10(1 downto 0)="01" ) then 
				rFixGen1DataCnt( 3 downto 0 )	<= (others=>'0');
			else 
				rFixGen1DataCnt( 3 downto 0 )	<= rFixGen1DataCnt( 3 downto 0 ) + 1;
			end if; 
		end if;
	End Process u_rFixGen1DataCnt;
	
	u_rFixGenHd1LenCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd1Tag8(1 downto 0)="01" ) then 
				rFixGenHd1LenCnt( 3 downto 0 )	<= MsgBeginStringLen( 3 downto 0 );
			elsif ( rFixGenHd1LenCntEn='1' ) then 
				rFixGenHd1LenCnt( 3 downto 0 )	<= rFixGenHd1LenCnt( 3 downto 0 ) - 1;
			else 
				rFixGenHd1LenCnt( 3 downto 0 )	<= rFixGenHd1LenCnt( 3 downto 0 );
			end if;
		end if;
	End Process u_rFixGenHd1LenCnt;
	
	u_rFixGenHd1LenCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGenHd1LenCntEn	<= '0';
			else 
				if ( rFixGenHd1Tag8(1)='1' and rFixGen1DataCnt=1 ) then 
					rFixGenHd1LenCntEn	<= '1';
				elsif ( rFixGenHd1LenCnt=1 ) then 
					rFixGenHd1LenCntEn	<= '0';
				else 
					rFixGenHd1LenCntEn	<= rFixGenHd1LenCntEn;
				end if;
			end if;
		end if;
	End Process u_rFixGenHd1LenCntEn;
	
	-- Output of Market data message 
	-- EOP bit 0 - 1: End of Tag 9 
	-- EOP bit 2: End of Tag 10 
	u_rFixGen1Eop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGen1Eop( 1 downto 0 )	<= "00";
			else 
				rFixGen1Eop(1)	<= rFixGen1Eop(0); 
				if ( AsciiOutEop='1' and AsciiOutVal='1' and (rAsciiOutCnt=3 or rAsciiOutCnt=4) ) then 
					rFixGen1Eop(0)	<= '1'; 
				else 
					rFixGen1Eop(0)	<= '0';
				end if;

			end if;
		end if;
	End Process u_rFixGen1Eop;
	
	u_rFixGen1Val : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixGen1Val	<= '0';
			else 
				if ( rFixGenHd1Tag8(1 downto 0)="01" or rFixGenTrlTag10(1 downto 0)="01" 
					or (AsciiOutVal='1' and (rAsciiOutCnt=3 or rAsciiOutCnt=4)) ) then 
					rFixGen1Val	<= '1';
				elsif ( rFixGenHd1Tag9(3 downto 2)="01" or rFixGen1Eop(1)='1'
					or rFixGenTrlTag10(4 downto 3)="01" ) then 
					rFixGen1Val	<= '0';
				else 
					rFixGen1Val	<= rFixGen1Val;
				end if;
			end if;
		end if;
	End Process u_rFixGen1Val;
	
	-- Using Bit 31 downto 24 as a output 
	u_rFixGen1Data : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			-- Add SOH 
			if ( (rFixGenHd1LenCnt=1 and rFixGenHd1LenCntEn='1') or rFixGen1Eop(0)='1' ) then 
				rFixGen1Data(31 downto 0 )	<= cAscii_SOH&x"000000";
			-------------
			-- Tag and value 
			elsif ( rFixGenHd1Tag8(1 downto 0)="01" ) then 
				rFixGen1Data(31 downto 0 )	<= cTagNum8&cAscii_Equal&x"0000"; 
			elsif ( rFixGenHd1Tag9(1 downto 0)="01" ) then 
				rFixGen1Data(31 downto 0 )	<= cTagNum9&cAscii_Equal&x"0000"; 
			elsif ( rFixGenTrlTag10(1 downto 0)="01" ) then 
				rFixGen1Data(31 downto 0 )	<= cTagNum10&cAscii_Equal&x"00"; 
			-------------
			-- Ascii encoder 
			elsif ( AsciiOutVal='1' and (rAsciiOutCnt=3 or rAsciiOutCnt=4) ) then 
				rFixGen1Data(31 downto 0 )	<= AsciiOutData(7 downto 0)&x"000000";
			-------------
			-- Field 8 value 
			elsif ( rFixGenHd1Tag8(1)='1' and rFixGen1DataCnt=1 ) then 
				rFixGen1Data(31 downto 0 )	<= MsgBeginString(63 downto 32);
			elsif ( rFixGenHd1Tag8(1)='1' and rFixGen1DataCnt=5 ) then 
				rFixGen1Data(31 downto 0 )	<= MsgBeginString(31 downto 0 );
			-------------
			-- Byte shifting 
			else
				rFixGen1Data(31 downto 0 )	<= rFixGen1Data(23 downto 0 )&x"00";
			end if; 
		end if;
	End Process u_rFixGen1Data;

-----------------------------------------------------------
-- Payload Ram Process 

	u_rPayloadLength : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset: Write - Read 
			if ( rFixGenHd0Tag35(1 downto 0)="01" ) then 
				rPayloadLength( 9 downto 0 )	<= PayloadWrAddr( 9 downto 0 ) - rPayloadRdAddr( 9 downto 0 );
			-- Reading from payload ram 
			elsif ( rPayloadRdVal(0)='1' ) then 
				rPayloadLength( 9 downto 0 )	<= rPayloadLength( 9 downto 0 ) - 1;
			else 
				rPayloadLength( 9 downto 0 )	<= rPayloadLength( 9 downto 0 );
			end if;
		end if;
	End Process u_rPayloadLength;
	
	u_rPayloadRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Reset when Generating validation 
			if ( rTxCtrl2GenReq='1' and rMsgTypeFF(3 downto 0)="1000" ) then 
				rPayloadRdAddr( 9 downto 0 )	<= (others=>'0');
			-- Reading 
			elsif ( rPayloadRdVal(0)='1' ) then 
				rPayloadRdAddr( 9 downto 0 )	<= rPayloadRdAddr( 9 downto 0 ) + 1; 
			else 
				rPayloadRdAddr( 9 downto 0 )	<= rPayloadRdAddr( 9 downto 0 );
			end if; 
		end if;
	End Process u_rPayloadRdAddr;
	
	u_rPayloadRdEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rPayloadRdEn	<= '0';
			else 
				if ( MsgGen2CtrlEnd='1' and rFixTx2CtrlBusy='1' ) then 
					rPayloadRdEn	<= '1';
				elsif ( rPayloadRdVal(1)='1' ) then 
					rPayloadRdEn	<= '0';
				else 	
					rPayloadRdEn	<= rPayloadRdEn;
				end if; 
			end if; 
		end if;
	End Process u_rPayloadRdEn;
	
	u_rPayloadRdVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rPayloadRdVal( 1 downto 0 )	<= (others=>'0');
			else 
				rPayloadRdVal(1)	<= rPayloadRdVal(0);
				-- Start reading 
				if ( rPayloadRdEn='1' and rFixGenHd0RdEnd(1)='1' ) then 
					rPayloadRdVal(0)	<= '1';
				elsif ( rPayloadRdEnd(1)='1' ) then 
					rPayloadRdVal(0)	<= '0';
				else 
					rPayloadRdVal(0)	<= rPayloadRdVal(0);
				end if; 
			end if; 
		end if;
	End Process u_rPayloadRdVal;
	
	-- Detect End of transmitting Paylaod  
	u_rPayloadRdEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rPayloadRdEnd( 1 downto 0 )	<= "00";
			else 
				rPayloadRdEnd(1)	<= rPayloadRdEnd(0);
				if ( rFixGenTrlTag10(0)='1' ) then 
					rPayloadRdEnd(0)	<= '0';
				elsif ( rPayloadRdVal(1)='1' and rPayloadLength=3 ) then 
					rPayloadRdEnd(0)	<= '1';
				else 
					rPayloadRdEnd(0)	<= rPayloadRdEnd(0); 
				end if; 
			end if; 
		end if; 
	End Process u_rPayloadRdEnd; 
	
-----------------------------------------------------------
-- Checksum Process 
	
	-- Bit 0: End of Header 0
	-- Bit 1: End of Header 1
	-- Bit 2: Start Ascii encoding checksum 
	u_rFixCheckSumStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFixCheckSumStart( 2 downto 0 )	<= (others=>'0');
			else 
				if ( rFixGen1Eop(1)='1' and rFixGenHd1Tag9(1)='1' ) then 
					rFixCheckSumStart(0)	<= '1';
				elsif ( rFixCheckSumStart(1)='1' ) then 
					rFixCheckSumStart(0)	<= '0';
				else 
					rFixCheckSumStart(0)	<= rFixCheckSumStart(0); 
				end if; 
				
				if ( rFixGenHd0End='1' ) then 
					rFixCheckSumStart(1)	<= '1';
				elsif ( rFixCheckSumStart(0)='1' ) then 
					rFixCheckSumStart(1)	<= '0';
				else 
					rFixCheckSumStart(1)	<= rFixCheckSumStart(1); 
				end if; 
				
				if ( rFixCheckSumStart(1 downto 0)="11" ) then 
					rFixCheckSumStart(2)	<= '1';
				else 
					rFixCheckSumStart(2)	<= '0';
				end if; 
			end if;
		end if; 
	End Process u_rFixCheckSumStart;
	
	u_rFixGenCheckSum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd1Tag8(1 downto 0)="01" and rPayloadRdEn='1' ) then 
				rFixGenCheckSum( 7 downto 0 )	<= MsgGen2CtrlCheckSum( 7 downto 0 );
			elsif ( rFixGenHd1Tag8(1 downto 0)="01" ) then 
				rFixGenCheckSum( 7 downto 0 )	<= (others=>'0');
			elsif ( rFixGen1Val='1' ) then 
				rFixGenCheckSum( 7 downto 0 )	<= rFixGenCheckSum( 7 downto 0 ) + rFixGen1Data(31 downto 24);
			elsif ( rFixCheckSumStart(1 downto 0)="11" ) then 
				rFixGenCheckSum( 7 downto 0 )	<= rFixGenCheckSum( 7 downto 0 ) + rFixGenHd0Checksum( 7 downto 0 );
			else 
				rFixGenCheckSum( 7 downto 0 )	<= rFixGenCheckSum( 7 downto 0 );
			end if; 
		end if;
	End Process u_rFixGenCheckSum;
	

-----------------------------------------------------------
-- Output generator 

	u_rFix2TOEData : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGenHd0RdVal(1)='1' ) then 
				rFix2TOEData( 7 downto 0 )	<= rFixGenHd0RdData( 7 downto 0 );
			elsif ( rPayloadRdVal(1)='1' ) then 
				rFix2TOEData( 7 downto 0 )	<= PayloadRdData( 7 downto 0 );
			else
				rFix2TOEData( 7 downto 0 )	<= rFixGen1Data(31 downto 24);
			end if; 
		end if;
	End Process u_rFix2TOEData;
	
	u_rFix2TOEDataSop : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOEDataSop	<= '0';
			else 	
				if ( rFixGenHd1Tag8(2 downto 1)="01" ) then 
					rFix2TOEDataSop	<= '1';
				else 
					rFix2TOEDataSop	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rFix2TOEDataSop;
	
	u_rFix2TOEDataEop : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOEDataEop	<= '0';
			else 	
				if ( rFixGen1Eop(1)='1' and rFixGenTrlTag10(1)='1' ) then 
					rFix2TOEDataEop	<= '1';
				else 
					rFix2TOEDataEop	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rFix2TOEDataEop;
	
	u_rFix2TOEDataVal : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rFix2TOEDataVal	<= '0';
			else 	
				if ( rFixGen1Val='1' or rPayloadRdVal(1)='1' or rFixGenHd0RdVal(1)='1' ) then 
					rFix2TOEDataVal	<= '1';
				else 
					rFix2TOEDataVal	<= '0';
				end if;
			end if; 
		end if;
	End Process u_rFix2TOEDataVal;
	
	u_rFix2TOEDataLen	: Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rFixGen1Start(1)='1' ) then 
				rFix2TOEDataLen(15 downto 0 )	<= ('0'&x"00"&rFixGenHd0Length(6 downto 0)) + ("00"&x"0"&rPayloadLength(9 downto 0))
													+ (x"000"&MsgBeginStringLen) + cLength_AddMsg;
			else 
				rFix2TOEDataLen(15 downto 0 )	<= rFix2TOEDataLen(15 downto 0 ); 
			end if; 
		end if;
	End Process u_rFix2TOEDataLen;
	
End Architecture rtl;
  