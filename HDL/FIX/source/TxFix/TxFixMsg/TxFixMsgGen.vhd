----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxFixMsgGen.vhd
-- Title        FIX message generator 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
-- Note
-- Maximum capacity is 2, Users must send InMuxStart <= 2 times whether it is the 
-- same input path or not. Can not take more than one input on any path at the same time
--
-- TxCtrl2GenMsgType 
-- '000' : Generate validation 
-- '001' : Logon
-- '010' : Heartbeat with 112 
-- '011' : MrkDataReq
-- '100' : ResendReq
-- '101' : SeqReset
-- '110' : Reject 
-- '111' : Reset Validation  
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity TxFixMsgGen Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		-- Control 
		TxCtrl2GenReq		: in	std_logic;
		TxCtrl2GenMsgType	: in	std_logic_vector( 2 downto 0 );
		
		Gen2TxCtrlBusy		: out	std_logic;
		
		-- Log-on 
		TxCtrl2GenTag98		: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag108	: in 	std_logic_vector(15  downto 0 ); -- Fixed 2 ascii character 00<= x <= 99 
		TxCtrl2GenTag141	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag553	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag554	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag1137	: in 	std_logic_vector( 7  downto 0 );
		
		TxCtrl2GenTag553Len	: in 	std_logic_vector( 4	 downto 0 );
		TxCtrl2GenTag554Len	: in 	std_logic_vector( 4	 downto 0 );
		
		-- Heartbeat
		TxCtrl2GenTag112	: in 	std_logic_vector(127 downto 0 );
		TxCtrl2GenTag112Len	: in 	std_logic_vector( 4	 downto 0 );
		
		-- MrkDataReq 
		TxCtrl2GenTag262	: in 	std_logic_vector(15  downto 0 ); -- Fixed 2 
		TxCtrl2GenTag263	: in 	std_logic_vector( 7  downto 0 ); 
		TxCtrl2GenTag264	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag265	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag266	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag146	: in 	std_logic_vector( 3  downto 0 ); -- Binary 0< and <=5
		TxCtrl2GenTag22		: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag267	: in 	std_logic_vector( 2  downto 0 ); -- Binary <= 2 
		TxCtrl2GenTag269	: in 	std_logic_vector(15  downto 0 ); -- number of 269 field depend on 267 value 
		
		-- ResendReq 
		TxCtrl2GenTag7		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		TxCtrl2GenTag16		: in 	std_logic_vector( 7  downto 0 );  
		
		-- SeqReset 
		TxCtrl2GenTag123	: in 	std_logic_vector( 7  downto 0 ); 
		TxCtrl2GenTag36		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		
		-- Reject 
		TxCtrl2GenTag45		: in 	std_logic_vector(26  downto 0 ); -- Binary 
		TxCtrl2GenTag371	: in 	std_logic_vector(31  downto 0 ); 
		TxCtrl2GenTag372	: in 	std_logic_vector( 7  downto 0 );
		TxCtrl2GenTag373	: in 	std_logic_vector(15  downto 0 );
		TxCtrl2GenTag58		: in 	std_logic_vector(127 downto 0 );
		
		TxCtrl2GenTag371Len	: in 	std_logic_vector( 2  downto 0 ); -- <= 4 
		TxCtrl2GenTag373Len	: in 	std_logic_vector( 1  downto 0 ); -- <= 2 
		TxCtrl2GenTag58Len	: in 	std_logic_vector( 3  downto 0 ); -- <= 16 
		TxCtrl2GenTag371En	: in 	std_logic;
		TxCtrl2GenTag372En	: in 	std_logic;
		TxCtrl2GenTag373En	: in 	std_logic;
		TxCtrl2GenTag58En	: in 	std_logic;
		
		-- Market data address 
		MrketData0			: in	std_logic_vector( 9 downto 0 );
		MrketData1			: in	std_logic_vector( 9 downto 0 );
		MrketData2			: in	std_logic_vector( 9 downto 0 );
		MrketData3			: in	std_logic_vector( 9 downto 0 );
		MrketData4			: in	std_logic_vector( 9 downto 0 );
		MrketDataEn			: in	std_logic_vector( 2 downto 0 ); -- 0< and <=5
		
		-- Output validation of Market data symbol and securityID 
		MrketSymbol0		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID0	: out   std_logic_vector(15 downto 0 );
		MrketVal0			: out   std_logic;
		MrketSymbol1		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID1    : out   std_logic_vector(15 downto 0 );
		MrketVal1           : out   std_logic;
		MrketSymbol2		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID2    : out   std_logic_vector(15 downto 0 );
		MrketVal2           : out   std_logic;
		MrketSymbol3		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID3    : out   std_logic_vector(15 downto 0 );
		MrketVal3           : out   std_logic;
		MrketSymbol4		: out	std_logic_vector(47 downto 0 );
		MrketSecurityID4    : out   std_logic_vector(15 downto 0 );
		MrketVal4           : out   std_logic;
		
		-- AsciiEncoder Interface 
		AsciiOutReq			: In	std_logic; 
		AsciiOutVal			: In	std_logic; 
		AsciiOutEop			: In	std_logic; 
		AsciiOutData		: In 	std_logic_vector( 7 downto 0 );
		
		AsciiInStart		: out	std_logic; 
		AsciiInTransEn 		: out	std_logic; 
		AsciiInDecPointEn	: out	std_logic;
		AsciiInNegativeExp	: out 	std_logic_vector( 2 downto 0 );
		AsciiInData			: out 	std_logic_vector(26 downto 0 );
		
		-- Output message Interface 
		OutMsgWrAddr		: out 	std_logic_vector( 9 downto 0 );
		OutMsgWrData		: out 	std_logic_vector( 7 downto 0 );
		OutMsgWrEn			: out 	std_logic;
		
		OutMsgChecksum		: out 	std_logic_vector( 7 downto 0 );
		OutMsgEnd			: out 	std_logic
	);
End Entity TxFixMsgGen;

Architecture rtl Of TxFixMsgGen Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component Ascii2Bin16bit Is
	Port 
	(
		Clk					: in	std_logic;
		RstB				: in	std_logic; 
		
		AsciiInSop			: in 	std_logic;
		AsciiInEop			: in 	std_logic;
		AsciiInVal			: in 	std_logic;
		AsciiInData			: in 	std_logic_vector( 7 downto 0 );
		
		BinOutVal			: out	std_logic;
		BinOutData			: out 	std_logic_vector(15 downto 0 )
	);
	End Component Ascii2Bin16bit;
	
	Component Rom1024x8 Is
	Port 
	(
		Clk			: in	std_logic;

		RdAddr		: in 	std_logic_vector( 9 downto 0);
		RdData		: out 	std_logic_vector( 7 downto 0)
	);
	End Component Rom1024x8;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant cAscii_SOH 				: std_logic_vector( 7 downto 0 ) := x"01";
	constant cAscii_Equal 				: std_logic_vector( 7 downto 0 ) := x"3D";
	
	constant cGenVal_RomFormatEnd  		: std_logic_vector( 3 downto 0 ) := x"B"; -- 11
	constant cGenVal_SecurityIDStart	: std_logic_vector( 3 downto 0 ) := x"7"; -- 7
	
	constant cTagNum_LO98 				: std_logic_vector(15 downto 0 ) := x"3938";
	constant cTagNum_LO108 				: std_logic_vector(23 downto 0 ) := x"313038";
	constant cTagNum_LO141 				: std_logic_vector(23 downto 0 ) := x"313431";
	constant cTagNum_LO553 				: std_logic_vector(23 downto 0 ) := x"353533";
	constant cTagNum_LO554 				: std_logic_vector(23 downto 0 ) := x"353534";
	constant cTagNum_LO1137 			: std_logic_vector(31 downto 0 ) := x"31313337";
	constant cTagNum_HBT112				: std_logic_vector(23 downto 0 ) := x"313132";
	constant cTagNum_MRK22				: std_logic_vector(15 downto 0 ) := x"3232";
	constant cTagNum_MRK48				: std_logic_vector(15 downto 0 ) := x"3438";
	constant cTagNum_MRK55				: std_logic_vector(15 downto 0 ) := x"3535";
	constant cTagNum_MRK146				: std_logic_vector(23 downto 0 ) := x"313436";
	constant cTagNum_MRK262				: std_logic_vector(23 downto 0 ) := x"323632";
	constant cTagNum_MRK263				: std_logic_vector(23 downto 0 ) := x"323633";
	constant cTagNum_MRK264				: std_logic_vector(23 downto 0 ) := x"323634";
	constant cTagNum_MRK265				: std_logic_vector(23 downto 0 ) := x"323635";
	constant cTagNum_MRK266				: std_logic_vector(23 downto 0 ) := x"323636";
	constant cTagNum_MRK267				: std_logic_vector(23 downto 0 ) := x"323637";
	constant cTagNum_MRK269				: std_logic_vector(23 downto 0 ) := x"323639";
	constant cTagNum_RRQ7				: std_logic_vector( 7 downto 0 ) := x"37"; 
	constant cTagNum_RRQ16				: std_logic_vector(15 downto 0 ) := x"3136"; 
	constant cTagNum_RST123				: std_logic_vector(23 downto 0 ) := x"313233"; 
	constant cTagNum_RST36				: std_logic_vector(15 downto 0 ) := x"3336"; 
	constant cTagNum_RJT45				: std_logic_vector(15 downto 0 ) := x"3435"; 
	constant cTagNum_RJT371				: std_logic_vector(23 downto 0 ) := x"333731"; 
	constant cTagNum_RJT372				: std_logic_vector(23 downto 0 ) := x"333732"; 
	constant cTagNum_RJT373				: std_logic_vector(23 downto 0 ) := x"333733"; 
	constant cTagNum_RJT58				: std_logic_vector(15 downto 0 ) := x"3538"; 
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- Control 
	signal  rMsgGenCtrl0			: std_logic_vector( 7 downto 0 );
	signal  rMsgGenCtrl1			: std_logic_vector( 7 downto 0 );
	signal  rGen2TxCtrlBusy			: std_logic;
	
	-- ROM Market data 
	signal  rMrkRdAddr				: std_logic_vector( 9 downto 0 );
	signal  rMrkRdData				: std_logic_vector( 7 downto 0 );
	signal  rMrkDataReqNum			: std_logic_vector( 4 downto 0 );
	signal  rMrkDataCnt				: std_logic_vector( 2 downto 0 );
	signal  rMrkDataCntFF			: std_logic_vector( 2 downto 0 );
	signal  rMrkDataEnd				: std_logic_vector( 2 downto 0 );
	
	-- Ascii decoder and Gen valid process 
	signal	rGenValRdCnt  			: std_logic_vector( 3 downto 0 );
	signal  rGenValCheckEnd			: std_logic_vector( 1 downto 0 );
	signal  rGenValRdEn				: std_logic;
	signal  rAsciiInSop				: std_logic;	
	signal  rAsciiInEop				: std_logic;	
	signal  rAsciiInVal				: std_logic;	
	
	signal  rBinOutData				: std_logic_vector(15 downto 0 );
	signal  rBinOutVal				: std_logic;
	
	signal  rMrketVal				: std_logic_vector( 4 downto 0 );
	signal  rMrketSymbol0			: std_logic_vector(47 downto 0 );
	signal  rMrketSymbol1			: std_logic_vector(47 downto 0 );
	signal  rMrketSymbol2			: std_logic_vector(47 downto 0 );
	signal  rMrketSymbol3			: std_logic_vector(47 downto 0 );
	signal  rMrketSymbol4			: std_logic_vector(47 downto 0 );
	signal  rMrketSecurityID0		: std_logic_vector(15 downto 0 );
	signal  rMrketSecurityID1		: std_logic_vector(15 downto 0 );
	signal  rMrketSecurityID2		: std_logic_vector(15 downto 0 );
	signal  rMrketSecurityID3		: std_logic_vector(15 downto 0 );
	signal  rMrketSecurityID4		: std_logic_vector(15 downto 0 );
	
	-- Generate Log on Process 
	signal  rLogOnMsgDataCnt		: std_logic_vector( 4 downto 0 );
	signal  rLogOnLenCnt			: std_logic_vector( 4 downto 0 );
	signal  rLogOnUserTagEn			: std_logic_vector( 1 downto 0 );
	signal  rLogOnPassTagEn			: std_logic_vector( 1 downto 0 );
	signal  rLogOnLastTagEn			: std_logic_vector( 1 downto 0 );
	signal  rLogOnLenCntEn			: std_logic;
	signal  rLogOnFixedTagEn		: std_logic;
	
	signal  rLogOnMsgData			: std_logic_vector(31 downto 0 );
	signal  rLogOnMsgEqual			: std_logic;
	signal  rLogOnMsgSoh			: std_logic;
	signal  rLogOnMsgVal			: std_logic;
	signal  rLogOnMsgEop			: std_logic;
	
	-- Generate Heartbeat process 
	signal  rHbtMsgLenCnt			: std_logic_vector( 4 downto 0 );
	signal  rHbtMsgDataCnt			: std_logic_vector( 3 downto 0 );
	signal  rHbtMsgLenCntEn			: std_logic;
	
	signal  rHbtMsgData				: std_logic_vector(31 downto 0 );
	signal  rHbtMsgVal				: std_logic_vector( 1 downto 0 );
	signal  rHbtMsgEqual			: std_logic;
	signal  rHbtMsgSoh				: std_logic;
	signal  rHbtMsgEop				: std_logic;
	
	-- Generate MrkDataReq
	signal  rMrkMsgDataCnt			: std_logic_vector( 3 downto 0 );
	signal  rMrkMsgTag262En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag263En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag264En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag265En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag266En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag146En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag267En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag55En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag48En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag22En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgTag269En			: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgRptSymEnd0		: std_logic_vector( 3 downto 0 );
	signal  rMrkMsgRptSymCnt0		: std_logic_vector( 2 downto 0 );
	signal  rMrkMsgRptSymEnd1		: std_logic_vector( 1 downto 0 );
	signal  rMrkMsgRptSymCnt1		: std_logic; 
	
	signal  rMrkDatJumpAddr			: std_logic_vector( 3 downto 0 );
	signal  rMrkDatRdAddrCnt		: std_logic_vector( 2 downto 0 );
	signal  rMrkDatRdAddrCntEn		: std_logic_vector( 1 downto 0 );
	signal  rMrkDatAsciiTransEn		: std_logic; 
	signal  rMrkDatStartRd			: std_logic; 
	
	signal  rMrkMsgData				: std_logic_vector(31 downto 0 );
	signal  rMrkMsgEqual			: std_logic_vector( 2 downto 0 );
	signal  rMrkMsgVal				: std_logic;
	signal  rMrkMsgSoh				: std_logic;
	signal  rMrkMsgEop				: std_logic;
	
	-- Generate ResendReq
	signal  rRrqMsgTag16En			: std_logic_vector( 3 downto 0 );
	signal  rRrqMsgTag7En			: std_logic_vector( 2 downto 0 );
	
	signal  rRrqMsgData				: std_logic_vector(15 downto 0 );
	signal  rRrqMsgEqual			: std_logic_vector( 1 downto 0 );
	signal  rRrqMsgVal				: std_logic;
	signal  rRrqMsgSoh				: std_logic;
	signal  rRrqMsgEop				: std_logic;
	
	-- Generate SeqReset
	signal  rRstMsgTag123En			: std_logic_vector( 4 downto 0 );
	signal  rRstMsgTag36En			: std_logic_vector( 3 downto 0 );
	
	signal  rRstMsgData				: std_logic_vector(15 downto 0 );
	signal  rRstMsgEqual			: std_logic_vector( 1 downto 0 );
	signal  rRstMsgVal				: std_logic;
	signal  rRstMsgSoh				: std_logic;
	signal  rRstMsgEop				: std_logic;
	
	-- Generate Reject 
	signal  rRjtMsgDataCnt			: std_logic_vector( 3 downto 0 );
	signal  rRjtMsgLenCnt			: std_logic_vector( 3 downto 0 );
	signal  rRjtMsgEnd				: std_logic_vector( 3 downto 0 );
	signal  rRjtMsgTag45En			: std_logic_vector( 3 downto 0 );
	signal  rRjtMsgTag58En			: std_logic_vector( 3 downto 0 );
	signal  rRjtMsgTag371En			: std_logic_vector( 1 downto 0 );
	signal  rRjtMsgTag372En			: std_logic_vector( 1 downto 0 );
	signal  rRjtMsgTag373En			: std_logic_vector( 1 downto 0 );
	signal  rRjtMsgLenCntEn			: std_logic;

	signal  rRjtMsgData				: std_logic_vector(31 downto 0 );
	signal  rRjtMsgEqual			: std_logic_vector( 1 downto 0 );
	signal  rRjtMsgVal				: std_logic;
	signal  rRjtMsgSoh				: std_logic;
	signal  rRjtMsgEop				: std_logic;
	
	-- Ascii Encoder signal 
	signal  rAsciiInData			: std_logic_vector(26 downto 0 );
	signal  rAsciiInTransEn			: std_logic;
	signal  rAsciiInStart			: std_logic;
	
	-- Output message 
	signal  rOutMsgWrAddr			: std_logic_vector( 9 downto 0 );
	signal  rOutMsgWrData			: std_logic_vector( 7 downto 0 );
	signal  rOutMsgChecksum			: std_logic_vector( 7 downto 0 );
	signal  rOutMsgEnd				: std_logic_vector( 1 downto 0 );
	signal  rOutMsgWrEn				: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	Gen2TxCtrlBusy					<= rGen2TxCtrlBusy;
	
	MrketSymbol0(47 downto 0 )		<= rMrketSymbol0(47 downto 0 );		 
	MrketSecurityID0(15 downto 0 )	<= rMrketSecurityID0(15 downto 0 );			
	MrketVal0			            <= rMrketVal(0);			            
	MrketSymbol1(47 downto 0 )		<= rMrketSymbol1(47 downto 0 );		
	MrketSecurityID1(15 downto 0 )	<= rMrketSecurityID1(15 downto 0 );	   
	MrketVal1                       <= rMrketVal(1);                      
	MrketSymbol2(47 downto 0 )		<= rMrketSymbol2(47 downto 0 );		
	MrketSecurityID2(15 downto 0 )	<= rMrketSecurityID2(15 downto 0 );	    
	MrketVal2                       <= rMrketVal(2);                       
	MrketSymbol3(47 downto 0 )		<= rMrketSymbol3(47 downto 0 );		
	MrketSecurityID3(15 downto 0 )	<= rMrketSecurityID3(15 downto 0 );	    
	MrketVal3                       <= rMrketVal(3);                       
	MrketSymbol4(47 downto 0 )		<= rMrketSymbol4(47 downto 0 );		
	MrketSecurityID4(15 downto 0 )	<= rMrketSecurityID4(15 downto 0 );	    
	MrketVal4                       <= rMrketVal(4);
	
	AsciiInStart					<= rAsciiInStart;
	AsciiInTransEn 		            <= rAsciiInTransEn; 
	AsciiInDecPointEn	            <= '0'; -- NOT USED 
	AsciiInNegativeExp( 2 downto 0 )<= "000"; -- NOT USED 
	AsciiInData(26 downto 0 )		<= rAsciiInData(26 downto 0 );
	
	OutMsgWrAddr( 9 downto 0 )		<= rOutMsgWrAddr( 9 downto 0 );
	OutMsgWrData( 7 downto 0 )		<= rOutMsgWrData( 7 downto 0 );		
	OutMsgWrEn			            <= rOutMsgWrEn;			            

	OutMsgChecksum( 7 downto 0 )	<= rOutMsgChecksum( 7 downto 0 );	
	OutMsgEnd			            <= rOutMsgEnd(1);			            
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-- Control Interface 

	u_rGen2TxCtrlBusy : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then 
				rGen2TxCtrlBusy	<= '0';
			else
				if ( rMsgGenCtrl0(7 downto 0)=x"00" ) then 
					rGen2TxCtrlBusy	<= '0';
				elsif ( TxCtrl2GenReq='1' ) then 
					rGen2TxCtrlBusy	<= '1';
				else 
					rGen2TxCtrlBusy	<= rGen2TxCtrlBusy;
				end if;
			end if;
		end if;
	End Process u_rGen2TxCtrlBusy; 
	
	u_rMsgGenCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMsgGenCtrl0( 7 downto 0 )	<= (others=>'0');
				rMsgGenCtrl1( 7 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rMsgGenCtrl1( 7 downto 0 )	<= rMsgGenCtrl0( 7 downto 0 ); 
				-- Bit 0: Validation generator
				if ( rGenValCheckEnd(1 downto 0)="10" ) then 
					rMsgGenCtrl0(0)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="000" ) then 
					rMsgGenCtrl0(0)	<= '1';
				else 
					rMsgGenCtrl0(0)	<= rMsgGenCtrl0(0); 
				end if; 
				
				-- Bit 1: Log-on generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(1)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="001" ) then 
					rMsgGenCtrl0(1)	<= '1';
				else 
					rMsgGenCtrl0(1)	<= rMsgGenCtrl0(1); 
				end if; 
				
				-- Bit 2: Heartbeat generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(2)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="010" ) then 
					rMsgGenCtrl0(2)	<= '1';
				else 
					rMsgGenCtrl0(2)	<= rMsgGenCtrl0(2); 
				end if; 
				
				-- Bit 3: MrkDataReq generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(3)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="011" ) then 
					rMsgGenCtrl0(3)	<= '1';
				else 
					rMsgGenCtrl0(3)	<= rMsgGenCtrl0(3); 
				end if; 
				
				-- Bit 4: ResendReq generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(4)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="100" ) then 
					rMsgGenCtrl0(4)	<= '1';
				else 
					rMsgGenCtrl0(4)	<= rMsgGenCtrl0(4); 
				end if; 
				
				-- Bit 5: SeqReset generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(5)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="101" ) then 
					rMsgGenCtrl0(5)	<= '1';
				else 
					rMsgGenCtrl0(5)	<= rMsgGenCtrl0(5); 
				end if; 
				
				-- Bit 6: Reject generator
				if ( rOutMsgEnd(0)='1' ) then 
					rMsgGenCtrl0(6)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="110" ) then 
					rMsgGenCtrl0(6)	<= '1';
				else 
					rMsgGenCtrl0(6)	<= rMsgGenCtrl0(6); 
				end if; 
				
				-- Bit 7: Validation drop generator
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMsgGenCtrl0(7)	<= '0';
				elsif ( rGen2TxCtrlBusy='0' and TxCtrl2GenReq='1' 
					and TxCtrl2GenMsgType(2 downto 0)="111" ) then 
					rMsgGenCtrl0(7)	<= '1';
				else 
					rMsgGenCtrl0(7)	<= rMsgGenCtrl0(7); 
				end if; 
			end if;
		end if;
	End Process u_rMsgGenCtrl;
	
-------------------------------------------------------------------------
-- validation of Market data symbol and securityID 
	
	u_Ascii2Bin16bit : Ascii2Bin16bit 
	Port map 
	(
		Clk					=> Clk					 ,
		RstB				=> RstB                  ,
	
		AsciiInSop			=> rAsciiInSop           ,
		AsciiInEop			=> rAsciiInEop           ,
		AsciiInVal			=> rAsciiInVal           ,
		AsciiInData			=> rMrkRdData            ,

		BinOutVal			=> rBinOutVal            ,
		BinOutData			=> rBinOutData
	);
	
	-- Read Rom Enable 
	u_rGenValRdEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rGenValRdEn 	<= '0';
			else 
				-- Stop Reading when end of securityID
				if ( rGenValRdCnt=cGenVal_RomFormatEnd ) then 
					rGenValRdEn <= '0';
				-- Start increment Rom Market data Address 
				elsif ( rMrkDataReqNum(4 downto 0)/="00000" and rMsgGenCtrl0(0)='1' ) then 
					rGenValRdEn	<= '1';
				else
					rGenValRdEn <= rGenValRdEn;
				end if;
			end if;
		end if;
	End Process u_rGenValRdEn;
	
	u_rGenValCheckEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rGenValCheckEnd( 1 downto 0 ) 	<= "00";
			else 
				if ( rAsciiInEop='1' and rMrkDataEnd/=0 ) then 
					rGenValCheckEnd(0) 	<= '1';
				else 
					rGenValCheckEnd(0) 	<= '0';
				end if; 
				
				if ( rAsciiInEop='1' ) then 
					rGenValCheckEnd(1) 	<= '1';
				else 
					rGenValCheckEnd(1) 	<= '0';
				end if; 
			end if; 			
		end if;
	End Process u_rGenValCheckEnd; 

	-- Counter 0 - 11 
	u_rGenValRdCnt : Process (Clk) Is 
	Begin
		if ( rising_edge(Clk) ) then 
			if ( rGenValRdEn='0' ) then 
				rGenValRdCnt( 3 downto 0 )	<= (others=>'0');
			else 
				rGenValRdCnt( 3 downto 0 )	<= rGenValRdCnt( 3 downto 0 ) + 1; 
			end if;
		end if;
	End Process u_rGenValRdCnt;
	
	-- Ascii2Bin16bit Input generator 
	u_rAsciiInCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rGenValRdCnt=cGenVal_SecurityIDStart ) then 
				rAsciiInSop	<= '1';
			else 
				rAsciiInSop	<= '0';
			end if;
			
			if ( rGenValRdCnt=cGenVal_RomFormatEnd ) then 
				rAsciiInEop	<= '1';
			else 
				rAsciiInEop	<= '0';
			end if; 
		end if;
	End Process u_rAsciiInCtrl;

	u_rAsciiInVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiInVal	<= '0';
			else 
				if ( rAsciiInEop='1' ) then 
					rAsciiInVal	<= '0';
				elsif ( rGenValRdCnt=cGenVal_SecurityIDStart ) then 
					rAsciiInVal	<= '1';
				else 
					rAsciiInVal	<= rAsciiInVal; 
				end if;
			end if;
		end if;
	End Process u_rAsciiInVal;

-------------------------------------------------------------------------
-- Output generator for Market data validation  

	u_rMrketVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrketVal( 4 downto 0 )	<= (others=>'0');
			else 
				-- Market data number 0 validation 
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMrketVal(0)	<= '0';
				elsif ( rBinOutVal='1' and rMrkDataCntFF=1 ) then  
					rMrketVal(0)	<= '1';
				else
					rMrketVal(0)	<= rMrketVal(0);
				end if;
				
				-- Market data number 2 validation 
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMrketVal(1)	<= '0';
				elsif ( rBinOutVal='1' and rMrkDataCntFF=2 ) then  
					rMrketVal(1)	<= '1';
				else
					rMrketVal(1)	<= rMrketVal(1);
				end if;
				
				-- Market data number 3 validation 
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMrketVal(2)	<= '0';
				elsif ( rBinOutVal='1' and rMrkDataCntFF=3 ) then  
					rMrketVal(2)	<= '1';
				else
					rMrketVal(2)	<= rMrketVal(2);
				end if;
				
				-- Market data number 4 validation 
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMrketVal(3)	<= '0';
				elsif ( rBinOutVal='1' and rMrkDataCntFF=4 ) then  
					rMrketVal(3)	<= '1';
				else
					rMrketVal(3)	<= rMrketVal(3);
				end if;
				
				-- Market data number 5 validation 
				if ( rMsgGenCtrl0(7)='1' ) then 
					rMrketVal(4)	<= '0';
				elsif ( rBinOutVal='1' and rMrkDataCntFF=5 ) then  
					rMrketVal(4)	<= '1';
				else
					rMrketVal(4)	<= rMrketVal(4);
				end if;
			end if;
		end if;
	End Process u_rMrketVal;
	
	u_rMrketSymbol : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rGenValRdCnt(3)='0' and rGenValRdCnt(2 downto 1)/="00" and rMrkDataCntFF=1 ) then 
				rMrketSymbol0(47 downto 0 )	<= rMrketSymbol0(39 downto 0)&rMrkRdData(7 downto 0);
			else 
				rMrketSymbol0(47 downto 0 )	<= rMrketSymbol0(47 downto 0 );
			end if; 
			
			if ( rGenValRdCnt(3)='0' and rGenValRdCnt(2 downto 1)/="00" and rMrkDataCntFF=2 ) then 
				rMrketSymbol1(47 downto 0 )	<= rMrketSymbol1(39 downto 0)&rMrkRdData(7 downto 0);
			else 
				rMrketSymbol1(47 downto 0 )	<= rMrketSymbol1(47 downto 0 );
			end if; 
			
			if ( rGenValRdCnt(3)='0' and rGenValRdCnt(2 downto 1)/="00" and rMrkDataCntFF=3 ) then 
				rMrketSymbol2(47 downto 0 )	<= rMrketSymbol2(39 downto 0)&rMrkRdData(7 downto 0);
			else 
				rMrketSymbol2(47 downto 0 )	<= rMrketSymbol2(47 downto 0 );
			end if; 
			
			if ( rGenValRdCnt(3)='0' and rGenValRdCnt(2 downto 1)/="00" and rMrkDataCntFF=4 ) then 
				rMrketSymbol3(47 downto 0 )	<= rMrketSymbol3(39 downto 0)&rMrkRdData(7 downto 0);
			else 
				rMrketSymbol3(47 downto 0 )	<= rMrketSymbol3(47 downto 0 );
			end if; 
			
			if ( rGenValRdCnt(3)='0' and rGenValRdCnt(2 downto 1)/="00" and rMrkDataCntFF=5 ) then 
				rMrketSymbol4(47 downto 0 )	<= rMrketSymbol4(39 downto 0)&rMrkRdData(7 downto 0);
			else 
				rMrketSymbol4(47 downto 0 )	<= rMrketSymbol4(47 downto 0 );
			end if; 
		end if;
	End Process u_rMrketSymbol;
	
	u_rMrketSecurityID : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rBinOutVal='1' and rMrkDataCntFF=1 ) then 
				rMrketSecurityID0(15 downto 0 )	<= rBinOutData(15 downto 0 );
			else 
				rMrketSecurityID0(15 downto 0 )	<= rMrketSecurityID0(15 downto 0 );
			end if; 
			
			if ( rBinOutVal='1' and rMrkDataCntFF=2 ) then 
				rMrketSecurityID1(15 downto 0 )	<= rBinOutData(15 downto 0 );
			else 
				rMrketSecurityID1(15 downto 0 )	<= rMrketSecurityID1(15 downto 0 );
			end if; 
			
			if ( rBinOutVal='1' and rMrkDataCntFF=3 ) then 
				rMrketSecurityID2(15 downto 0 )	<= rBinOutData(15 downto 0 );
			else 
				rMrketSecurityID2(15 downto 0 )	<= rMrketSecurityID2(15 downto 0 );
			end if; 
			
			if ( rBinOutVal='1' and rMrkDataCntFF=4 ) then 
				rMrketSecurityID3(15 downto 0 )	<= rBinOutData(15 downto 0 );
			else 
				rMrketSecurityID3(15 downto 0 )	<= rMrketSecurityID3(15 downto 0 );
			end if; 
			
			if ( rBinOutVal='1' and rMrkDataCntFF=5 ) then 
				rMrketSecurityID4(15 downto 0 )	<= rBinOutData(15 downto 0 );
			else 
				rMrketSecurityID4(15 downto 0 )	<= rMrketSecurityID4(15 downto 0 );
			end if; 
		end if;
	End Process u_rMrketSecurityID;
	
-------------------------------------------------------------------------
-- RAM Market data Addressing 
	
	u_RomMrkData : Rom1024x8 
	Port map 
	(
		Clk			=> Clk					,

		RdAddr		=> rMrkRdAddr           ,
		RdData		=> rMrkRdData	
	);
	
	u_rMrkDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rMrkDataCntFF( 2 downto 0 )		<= rMrkDataCnt( 2 downto 0 );
			if ( rMsgGenCtrl0(0)='0' and rMsgGenCtrl0(3)='0' ) then 
				rMrkDataCnt( 2 downto 0 )	<= (others=>'0');
			elsif ( rMrkDataReqNum(4 downto 0)/="00000" ) then 
				rMrkDataCnt( 2 downto 0 )	<= rMrkDataCnt( 2 downto 0 ) + 1;
			else 
				rMrkDataCnt( 2 downto 0 )	<= rMrkDataCnt( 2 downto 0 );
			end if; 
		end if;
	End Process u_rMrkDataCnt;
	
	u_rMrkDataEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rMrkDataEnd( 2 downto 0 )	<= rMrkDataCntFF( 2 downto 0 ) - MrketDataEn( 2 downto 0 );
		end if;
	End Process u_rMrkDataEnd;
	
	u_rMrkDataReqNum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( (rMsgGenCtrl1(0)='0' and rMsgGenCtrl0(0)='1')
				or (rMrkMsgRptSymCnt0=0 and rMrkMsgTag55En(1 downto 0)="01") ) then 
				rMrkDataReqNum(0)	<= '1';
			else 
				rMrkDataReqNum(0)	<= '0';
			end if; 
			
			if ( (rGenValCheckEnd(0)='1' and rMrkDataCnt=1)
				or (rMrkMsgRptSymCnt0=1 and rMrkMsgTag55En(1 downto 0)="01") ) then 
				rMrkDataReqNum(1)	<= '1';
			else 
				rMrkDataReqNum(1)	<= '0';
			end if; 
			
			if ( (rGenValCheckEnd(0)='1' and rMrkDataCnt=2)
				or (rMrkMsgRptSymCnt0=2 and rMrkMsgTag55En(1 downto 0)="01") ) then 
				rMrkDataReqNum(2)	<= '1';
			else 
				rMrkDataReqNum(2)	<= '0';
			end if; 
			
			if ( (rGenValCheckEnd(0)='1' and rMrkDataCnt=3)
				or (rMrkMsgRptSymCnt0=3 and rMrkMsgTag55En(1 downto 0)="01") ) then 
				rMrkDataReqNum(3)	<= '1';
			else 
				rMrkDataReqNum(3)	<= '0';
			end if; 
			
			if ( (rGenValCheckEnd(0)='1' and rMrkDataCnt=4)
				or (rMrkMsgRptSymCnt0=4 and rMrkMsgTag55En(1 downto 0)="01") ) then 
				rMrkDataReqNum(4)	<= '1';
			else 
				rMrkDataReqNum(4)	<= '0';
			end if; 
			
		end if;
	End Process u_rMrkDataReqNum; 
	
	u_rMrkRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Market data number 0 
			if ( rMrkDataReqNum(0)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= MrketData0;
			-- Market data number 1
			elsif ( rMrkDataReqNum(1)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= MrketData1;
			-- Market data number 2
			elsif ( rMrkDataReqNum(2)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= MrketData2;
			-- Market data number 3
			elsif ( rMrkDataReqNum(3)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= MrketData3;
			-- Market data number 4
			elsif ( rMrkDataReqNum(4)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= MrketData4; 
			-- Jumped Address 
			elsif ( rMrkDatStartRd='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= rMrkRdAddr( 9 downto 0 ) + ("0"&x"0"&rMrkDatJumpAddr(3 downto 0));
			-- Read enable 
			elsif ( rGenValRdEn='1' or rMrkDatRdAddrCntEn(0)='1' ) then 
				rMrkRdAddr( 9 downto 0 )	<= rMrkRdAddr( 9 downto 0 ) + 1;
			else 
				rMrkRdAddr( 9 downto 0 )	<= rMrkRdAddr( 9 downto 0 );
			end if;
		end if;
	End Process u_rMrkRdAddr;

-------------------------------------------------------------------------
-- Generate Logon process 
	
	u_rLogOnMsgDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( (rMsgGenCtrl1(1)='0' and rMsgGenCtrl0(1)='1')
				or rLogOnUserTagEn(1 downto 0)="01" or rLogOnPassTagEn(1 downto 0)="01"
				or rLogOnLastTagEn(1 downto 0)="01" ) then 
				rLogOnMsgDataCnt( 4 downto 0 )	<= (others=>'0');
			else 
				rLogOnMsgDataCnt( 4 downto 0 )	<= rLogOnMsgDataCnt( 4 downto 0 ) + 1;
			end if;
		end if;
	End Process u_rLogOnMsgDataCnt; 
	
	u_rLogOnLenCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rLogOnUserTagEn(1 downto 0)="01" ) then 
				rLogOnLenCnt( 4 downto 0 )	<= TxCtrl2GenTag553Len( 4 downto 0 );
			elsif ( rLogOnPassTagEn(1 downto 0)="01" ) then 
				rLogOnLenCnt( 4 downto 0 )	<= TxCtrl2GenTag554Len( 4 downto 0 );
			elsif ( rLogOnLenCntEn='1' ) then 
				rLogOnLenCnt( 4 downto 0 )	<= rLogOnLenCnt( 4 downto 0 ) - 1;
			else 
				rLogOnLenCnt( 4 downto 0 )	<= rLogOnLenCnt( 4 downto 0 );
			end if;
		end if;
	End Process u_rLogOnLenCnt;
	
	u_rLogOnLenCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnLenCntEn	<= '0';
			else 
				if ( rLogOnLenCnt=1 and rLogOnLenCntEn='1' ) then 
					rLogOnLenCntEn	<= '0';
				elsif ( rLogOnMsgEqual='1' and (rLogOnUserTagEn(1)='1'
					or rLogOnPassTagEn(1)='1') ) then 
					rLogOnLenCntEn	<= '1';
				else 
					rLogOnLenCntEn	<= rLogOnLenCntEn;
				end if; 
			end if; 
		end if;
	End Process u_rLogOnLenCntEn;
	
	u_rLogOnFixedTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnFixedTagEn	<= '0';
			else 
				if ( rMsgGenCtrl1(1)='0' and rMsgGenCtrl0(1)='1' ) then
					rLogOnFixedTagEn	<= '1';
				elsif ( rLogOnMsgDataCnt=17 ) then 
					rLogOnFixedTagEn	<= '0';
				else 
					rLogOnFixedTagEn	<= rLogOnFixedTagEn;
				end if; 
			end if;
		end if;
	End Process u_rLogOnFixedTagEn;
	
	u_rLogOnUserTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnUserTagEn( 1 downto 0 )	<= (others=>'0');
			else 
				rLogOnUserTagEn(1)	<= rLogOnUserTagEn(0);
				if ( rLogOnFixedTagEn='1' and rLogOnMsgDataCnt=17 and TxCtrl2GenTag553Len/=0 ) then
					rLogOnUserTagEn(0)	<= '1';
				elsif ( rLogOnLenCntEn='1' and rLogOnLenCnt=1 ) then 
					rLogOnUserTagEn(0)	<= '0';
				else 
					rLogOnUserTagEn(0)	<= rLogOnUserTagEn(0);
				end if; 
			end if;
		end if;
	End Process u_rLogOnUserTagEn;
	
	u_rLogOnPassTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnPassTagEn( 1 downto 0 )	<= (others=>'0');
			else 
				rLogOnPassTagEn(1)	<= rLogOnPassTagEn(0);
				if ( ((rLogOnFixedTagEn='1' and rLogOnMsgDataCnt=17) 
					or (rLogOnLenCntEn='1' and rLogOnUserTagEn(0)='1' and rLogOnLenCnt=1))
					and TxCtrl2GenTag554Len/=0 ) then
					rLogOnPassTagEn(0)	<= '1';
				elsif ( (rLogOnLenCntEn='1' and rLogOnLenCnt=1) or rLogOnUserTagEn(0)='1' ) then 
					rLogOnPassTagEn(0)	<= '0';
				else 
					rLogOnPassTagEn(0)	<= rLogOnPassTagEn(0);
				end if; 
			end if;
		end if;
	End Process u_rLogOnPassTagEn;
	
	u_rLogOnLastTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnLastTagEn( 1 downto 0 )	<= (others=>'0');
			else 
				rLogOnLastTagEn(1)	<= rLogOnLastTagEn(0); 
				if ( (rLogOnFixedTagEn='1' and rLogOnMsgDataCnt=17) 
					or (rLogOnLenCntEn='1' and rLogOnLenCnt=1) ) then
					rLogOnLastTagEn(0)	<= '1';
				elsif ( rLogOnUserTagEn(0)='1' or rLogOnPassTagEn(0)='1' or rLogOnMsgEqual='1' ) then 
					rLogOnLastTagEn(0)	<= '0';
				else 
					rLogOnLastTagEn(0)	<= rLogOnLastTagEn(0);
				end if; 
			end if;
		end if;
	End Process u_rLogOnLastTagEn;
	
	-- Output of the Logon message 
	u_rLogOnMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnMsgVal	<= '0';
			else 
				if ( rLogOnFixedTagEn='1' ) then 
					rLogOnMsgVal	<= '1';
				elsif ( rLogOnMsgEop='1' ) then
					rLogOnMsgVal	<= '0';
				else 
					rLogOnMsgVal	<= rLogOnMsgVal; 
				end if;
			end if;
		end if;
	End Process u_rLogOnMsgVal;
	
	u_rLogOnMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnMsgEop	<= '0';
			else 
				if ( rLogOnLastTagEn(1)='1' and rLogOnMsgDataCnt=5 ) then 
					rLogOnMsgEop	<= '1';
				else 
					rLogOnMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rLogOnMsgEop;
	
	u_rLogOnMsgSoh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnMsgSoh	<= '0';
			else 
				if ( (rLogOnLenCntEn='1' and rLogOnLenCnt=1)
					or ((rLogOnMsgDataCnt=4 or rLogOnMsgDataCnt=11 or rLogOnMsgDataCnt=17) and rLogOnFixedTagEn='1')
					or (rLogOnMsgDataCnt=5 and rLogOnLastTagEn(1)='1') ) then 
					rLogOnMsgSoh	<= '1';
				else 
					rLogOnMsgSoh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rLogOnMsgSoh;
	
	u_rLogOnMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rLogOnMsgEqual	<= '0';
			else 
				if ( ((rLogOnMsgDataCnt=2 or rLogOnMsgDataCnt=8 or rLogOnMsgDataCnt=15) and rLogOnFixedTagEn='1')
					or (rLogOnMsgDataCnt=2 and (rLogOnUserTagEn(0)='1' or rLogOnPassTagEn(0)='1'))
					or (rLogOnMsgDataCnt=3 and rLogOnLastTagEn(0)='1') ) then 
					rLogOnMsgEqual	<= '1';
				else 
					rLogOnMsgEqual	<= '0';
				end if;
			end if;
		end if;
	End Process u_rLogOnMsgEqual;
	
	-- Using Bit 31 downto 24 as a output 
	u_rLogOnMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			-- Last 3 Tag 
			if ( rLogOnUserTagEn(1 downto 0)="01" ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO553&x"00"; 
			elsif ( rLogOnPassTagEn(1 downto 0)="01" ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO554&x"00"; 
			elsif ( rLogOnLastTagEn(1 downto 0)="01" ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO1137; 
			-- Username 
			elsif ( rLogOnMsgDataCnt=3 and rLogOnUserTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag553(127 downto 96);
			elsif ( rLogOnMsgDataCnt=7 and rLogOnUserTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag553( 95 downto 64);
			elsif ( rLogOnMsgDataCnt=11 and rLogOnUserTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag553( 63 downto 32);
			elsif ( rLogOnMsgDataCnt=15 and rLogOnUserTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag553( 31 downto 0);
			-- Password 
			elsif ( rLogOnMsgDataCnt=3 and rLogOnPassTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag554(127 downto 96);
			elsif ( rLogOnMsgDataCnt=7 and rLogOnPassTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag554( 95 downto 64);
			elsif ( rLogOnMsgDataCnt=11 and rLogOnPassTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag554( 63 downto 32);
			elsif ( rLogOnMsgDataCnt=15 and rLogOnPassTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag554( 31 downto 0);
			-- last tag value 
			elsif ( rLogOnMsgDataCnt=4 and rLogOnLastTagEn(1)='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= TxCtrl2GenTag1137( 7 downto 0)&x"000000";
			-------------
			-- Frist 3 tag 
			elsif ( rLogOnMsgDataCnt=0 and rLogOnFixedTagEn='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO98&TxCtrl2GenTag98&cTagNum_LO108(23 downto 16);
			elsif ( rLogOnMsgDataCnt=6 and rLogOnFixedTagEn='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO108(15 downto 0)&TxCtrl2GenTag108;
			elsif ( rLogOnMsgDataCnt=12 and rLogOnFixedTagEn='1' ) then 
				rLogOnMsgData(31 downto 0 )	<= cTagNum_LO141&TxCtrl2GenTag141;
			-------------
			-- Byte shifting 
			elsif ( rLogOnMsgEqual='0' and rLogOnMsgSoh='0' ) then 
				rLogOnMsgData(31 downto 0 )	<= rLogOnMsgData(23 downto 0 )&x"00";
			else 
				rLogOnMsgData(31 downto 0 )	<= rLogOnMsgData(31 downto 0 );
			end if; 
		end if;
	End Process u_rLogOnMsgData;
	
-------------------------------------------------------------------------
-- Generate Heartbeat process 

	u_rHbtMsgDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rHbtMsgVal(1 downto 0)="01" ) then 
				rHbtMsgDataCnt( 3 downto 0 )	<= (others=>'0');
			else 
				rHbtMsgDataCnt( 3 downto 0 )	<= rHbtMsgDataCnt( 3 downto 0 ) + 1; 
			end if;
		end if;
	End Process u_rHbtMsgDataCnt;
	
	u_rHbtMsgLenCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMsgGenCtrl0(2)='1' and rMsgGenCtrl1(2)='0' ) then 
				rHbtMsgLenCnt( 4 downto 0 )	<= TxCtrl2GenTag112Len( 4 downto 0 );
			elsif ( rHbtMsgLenCntEn='1' ) then 
				rHbtMsgLenCnt( 4 downto 0 )	<= rHbtMsgLenCnt( 4 downto 0 ) - 1;
			else 
				rHbtMsgLenCnt( 4 downto 0 )	<= rHbtMsgLenCnt( 4 downto 0 );
			end if;
		end if;
	End Process u_rHbtMsgLenCnt;
	
	-- Used rHbtMsgVal(1) as a output validation 
	u_rHbtMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHbtMsgVal( 1 downto 0 )	<= (others=>'0');
			else 
				rHbtMsgVal(1)	<= rHbtMsgVal(0); 
				if ( rHbtMsgLenCntEn='1' and rHbtMsgLenCnt=1 ) then 
					rHbtMsgVal(0)	<= '0';
				elsif ( rMsgGenCtrl0(2)='1' and rMsgGenCtrl1(2)='0' ) then 
					rHbtMsgVal(0)	<= '1';
				else
					rHbtMsgVal(0)	<= rHbtMsgVal(0); 
				end if;
			end if;
		end if;
	End Process u_rHbtMsgVal;

	u_rHbtMsgLenCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHbtMsgLenCntEn	<= '0';
			else 
				if ( rHbtMsgLenCntEn='1' and rHbtMsgLenCnt=1 ) then 
					rHbtMsgLenCntEn	<= '0';
				elsif ( rHbtMsgVal(1)='1' and rHbtMsgDataCnt=3 ) then 
					rHbtMsgLenCntEn	<= '1';
				else 
					rHbtMsgLenCntEn	<= rHbtMsgLenCntEn; 
				end if;
			end if;
		end if; 
	End Process u_rHbtMsgLenCntEn;
	
	-- For Heartbeat SOH and EOP is the same 
	u_rHbtMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHbtMsgSoh	<= '0';
				rHbtMsgEop	<= '0';
			else 
				if ( rHbtMsgLenCntEn='1' and rHbtMsgLenCnt=1 ) then 
					rHbtMsgSoh	<= '1';
					rHbtMsgEop	<= '1';
				else 
					rHbtMsgSoh	<= '0';
					rHbtMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rHbtMsgEop;
	
	u_rHbtMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rHbtMsgEqual	<= '0';
			else 
				if ( rHbtMsgVal(1)='1' and rHbtMsgDataCnt=2 ) then 
					rHbtMsgEqual	<= '1';
				else 
					rHbtMsgEqual	<= '0';
				end if;
			end if;
		end if;
	End Process u_rHbtMsgEqual;
	
	-- Using Bit 31 downto 24 as a output 
	u_rHbtMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			-- Tag 
			if ( rHbtMsgVal(1 downto 0)="01" ) then 
				rHbtMsgData(31 downto 0 )	<= cTagNum_HBT112&x"00"; 
			-- Value  
			elsif ( rHbtMsgEqual='1' ) then 
				rHbtMsgData(31 downto 0 )	<= TxCtrl2GenTag112(127 downto 96);
			elsif ( rHbtMsgDataCnt=7 and rHbtMsgVal(0)='1' ) then 
				rHbtMsgData(31 downto 0 )	<= TxCtrl2GenTag112( 95 downto 64);
			elsif ( rHbtMsgDataCnt=11 and rHbtMsgVal(0)='1' ) then 
				rHbtMsgData(31 downto 0 )	<= TxCtrl2GenTag112( 63 downto 32);
			elsif ( rHbtMsgDataCnt=15 and rHbtMsgVal(0)='1' ) then 
				rHbtMsgData(31 downto 0 )	<= TxCtrl2GenTag112( 31 downto 0);
			-------------
			-- Byte shifting 
			else
				rHbtMsgData(31 downto 0 )	<= rHbtMsgData(23 downto 0 )&x"00";
			end if; 
		end if;
	End Process u_rHbtMsgData;

-------------------------------------------------------------------------
-- Generate MrkDataReq
	
	u_rMrkMsgDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMrkMsgTag262En(1 downto 0)="01" or rMrkMsgSoh='1' ) then 
				rMrkMsgDataCnt( 3 downto 0 )	<= (others=>'0');
			else 
				rMrkMsgDataCnt( 3 downto 0 )	<= rMrkMsgDataCnt( 3 downto 0 ) + 1; 
			end if;
		end if;
	End Process u_rMrkMsgDataCnt;
	
	u_rMrkMsgTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgTag262En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag263En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag264En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag265En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag266En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag146En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag267En( 1 downto 0 )	<= (others=>'0');
			else 
				rMrkMsgTag262En(1)	<= rMrkMsgTag262En(0); 
				if ( rMsgGenCtrl0(3)='1' and rMsgGenCtrl1(3)='0' ) then 
					rMrkMsgTag262En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=5 ) then 
					rMrkMsgTag262En(0)	<= '0';
				else 
					rMrkMsgTag262En(0)	<= rMrkMsgTag262En(0);
				end if;
				
				rMrkMsgTag263En(1)	<= rMrkMsgTag263En(0); 
				if ( rMrkMsgDataCnt=5 and rMrkMsgTag262En(1)='1' ) then 
					rMrkMsgTag263En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=4 ) then 
					rMrkMsgTag263En(0)	<= '0';
				else 
					rMrkMsgTag263En(0)	<= rMrkMsgTag263En(0);
				end if;
				
				rMrkMsgTag264En(1)	<= rMrkMsgTag264En(0); 
				if ( rMrkMsgDataCnt=4 and rMrkMsgTag263En(1)='1' ) then 
					rMrkMsgTag264En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=4 ) then 
					rMrkMsgTag264En(0)	<= '0';
				else 
					rMrkMsgTag264En(0)	<= rMrkMsgTag264En(0);
				end if;
				
				rMrkMsgTag265En(1)	<= rMrkMsgTag265En(0); 
				if ( rMrkMsgDataCnt=4 and rMrkMsgTag264En(1)='1' ) then 
					rMrkMsgTag265En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=4 ) then 
					rMrkMsgTag265En(0)	<= '0';
				else 
					rMrkMsgTag265En(0)	<= rMrkMsgTag265En(0);
				end if;
				
				rMrkMsgTag266En(1)	<= rMrkMsgTag266En(0); 
				if ( rMrkMsgDataCnt=4 and rMrkMsgTag265En(1)='1' ) then 
					rMrkMsgTag266En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=4 ) then 
					rMrkMsgTag266En(0)	<= '0';
				else 
					rMrkMsgTag266En(0)	<= rMrkMsgTag266En(0);
				end if;
				
				rMrkMsgTag146En(1)	<= rMrkMsgTag146En(0); 
				if ( rMrkMsgDataCnt=4 and rMrkMsgTag266En(1)='1' ) then 
					rMrkMsgTag146En(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rMrkMsgTag146En(0)	<= '0';
				else 
					rMrkMsgTag146En(0)	<= rMrkMsgTag146En(0);
				end if;
			
				rMrkMsgTag267En(1)	<= rMrkMsgTag267En(0); 
				if ( rMrkMsgEqual(1)='1'and rMrkMsgTag22En(1)='1' and rMrkMsgRptSymEnd0=1 ) then 
					rMrkMsgTag267En(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rMrkMsgTag267En(0)	<= '0';
				else 
					rMrkMsgTag267En(0)	<= rMrkMsgTag267En(0);
				end if;
			end if;
		end if; 
	End Process u_rMrkMsgTagEn;
	
	-- Repeat group 
	u_rMrkMsgTagRptEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgTag55En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag48En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag22En( 1 downto 0 )	<= (others=>'0');
				rMrkMsgTag269En( 1 downto 0 )	<= (others=>'0');
			else 
				-- Repeat Group 1 
				rMrkMsgTag55En(1)	<= rMrkMsgTag55En(0); 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rMrkMsgTag146En(1)='1') 
					or (rMrkMsgEqual(1)='1' and rMrkMsgTag22En(1)='1' and rMrkMsgRptSymEnd0/=1) ) then 
					rMrkMsgTag55En(0)	<= '1';
				elsif ( rMrkDatRdAddrCntEn(1 downto 0)="10" ) then 
					rMrkMsgTag55En(0)	<= '0';
				else 
					rMrkMsgTag55En(0)	<= rMrkMsgTag55En(0);
				end if;
				
				rMrkMsgTag48En(1)	<= rMrkMsgTag48En(0); 
				if ( rMrkDatRdAddrCntEn(1 downto 0)="10" and rMrkMsgTag55En(1)='1' ) then 
					rMrkMsgTag48En(0)	<= '1';
				elsif ( rMrkDatRdAddrCntEn(1 downto 0)="10" ) then 
					rMrkMsgTag48En(0)	<= '0';
				else 
					rMrkMsgTag48En(0)	<= rMrkMsgTag48En(0);
				end if;
				
				rMrkMsgTag22En(1)	<= rMrkMsgTag22En(0); 
				if ( rMrkDatRdAddrCntEn(1 downto 0)="10" and rMrkMsgTag48En(1)='1' ) then 
					rMrkMsgTag22En(0)	<= '1';
				elsif ( rMrkMsgDataCnt=3 ) then 
					rMrkMsgTag22En(0)	<= '0';
				else 
					rMrkMsgTag22En(0)	<= rMrkMsgTag22En(0);
				end if;
				
				-- Repeat Group 2 
				rMrkMsgTag269En(1)	<= rMrkMsgTag269En(0); 
				if ( AsciiOutEop='1' and AsciiOutVal='1' and rMrkMsgTag267En(1)='1' ) then 
					rMrkMsgTag269En(0)	<= '1';
				elsif ( rMrkMsgEqual(1)='1' and rMrkMsgTag269En(1)='1' and rMrkMsgRptSymEnd1=1 ) then 
					rMrkMsgTag269En(0)	<= '0';
				else 
					rMrkMsgTag269En(0)	<= rMrkMsgTag269En(0);
				end if;
			end if;
		end if; 
	End Process u_rMrkMsgTagRptEn;
	
	u_rMrkMsgRptSymCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMrkMsgTag146En(1 downto 0)="01" ) then 
				rMrkMsgRptSymCnt0( 2 downto 0 )	<= (others=>'0');
			-- End of each Repeat group 0
			elsif ( rMrkMsgEqual(1)='1' and rMrkMsgTag22En(1)='1' ) then 
				rMrkMsgRptSymCnt0( 2 downto 0 )	<= rMrkMsgRptSymCnt0( 2 downto 0 ) + 1;
			else 
				rMrkMsgRptSymCnt0( 2 downto 0 )	<= rMrkMsgRptSymCnt0( 2 downto 0 );
			end if;
			
			if ( rMrkMsgTag267En(1 downto 0)="01" ) then 
				rMrkMsgRptSymCnt1	<= '0';
			-- End of each Repeat group 1
			elsif ( rMrkMsgEqual(1)='1' and rMrkMsgTag269En(1)='1' ) then 
				rMrkMsgRptSymCnt1	<= '1';
			else 
				rMrkMsgRptSymCnt1	<= rMrkMsgRptSymCnt1;
			end if;
		end if;
	End Process u_rMrkMsgRptSymCnt;
	
	u_rMrkMsgRptSymEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rMrkMsgRptSymEnd0( 3 downto 0 )	<= TxCtrl2GenTag146( 3 downto 0) - ('0'&rMrkMsgRptSymCnt0( 2 downto 0 ));
			rMrkMsgRptSymEnd1( 1 downto 0 )	<= TxCtrl2GenTag267( 1 downto 0) - ('0'&rMrkMsgRptSymCnt1);
		end if;
	End Process u_rMrkMsgRptSymEnd;
	
	-- Read ROM control signal of Market data message 
	u_rMrkDatStartRd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkDatStartRd	<= '0';
			else 
				if ( (rMrkMsgEqual(0)='1' and rMrkMsgTag55En(1)='1')
					or (rMrkMsgDataCnt=0 and rMrkMsgTag48En(1)='1') ) then 
					rMrkDatStartRd	<= '1';
				else 
					rMrkDatStartRd	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rMrkDatStartRd;
	
	u_rMrkDatJumpAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMrkMsgEqual(0)='1' and rMrkMsgTag55En(1)='1' ) then 
				rMrkDatJumpAddr( 3 downto 0 )	<= rMrkRdData( 7 downto 4 ); 
			elsif ( rMrkDatStartRd='1' ) then  
				rMrkDatJumpAddr( 3 downto 0 )	<= rMrkRdData( 3 downto 0 ); 
			elsif ( rMrkDatRdAddrCntEn( 1 downto 0)="01" ) then 
				rMrkDatJumpAddr( 3 downto 0 )	<= rMrkDatJumpAddr( 3 downto 0 ) - 1; 
			else 
				rMrkDatJumpAddr( 3 downto 0 )	<= rMrkDatJumpAddr( 3 downto 0 );
			end if; 
		end if;
	End Process u_rMrkDatJumpAddr;
	
	u_rMrkDatRdAddrCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMrkMsgTag55En(1)='1' and rMrkMsgEqual(0)='1' ) then 
				rMrkDatRdAddrCnt( 2 downto 0 )	<= "111"; -- 7 
			elsif ( rMrkMsgDataCnt=0 and rMrkMsgTag48En(1)='1' ) then  
				rMrkDatRdAddrCnt( 2 downto 0 )	<= "101"; -- 5
			elsif ( rMrkDatStartRd='1' ) then 
				rMrkDatRdAddrCnt( 2 downto 0 )	<= rMrkDatRdAddrCnt( 2 downto 0 ) - rMrkDatJumpAddr( 2 downto 0 );-- jumped 
			else 
				rMrkDatRdAddrCnt( 2 downto 0 )	<= rMrkDatRdAddrCnt( 2 downto 0 ) - 1;
			end if; 
		end if;
	End Process u_rMrkDatRdAddrCnt;
	
	u_rMrkDatRdAddrCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkDatRdAddrCntEn( 1 downto 0 )	<= (others=>'0');	
			else 
				rMrkDatRdAddrCntEn(1)	<= rMrkDatRdAddrCntEn(0);
				if ( rMrkDatStartRd='1' ) then 
					rMrkDatRdAddrCntEn(0)	<= '1';
				elsif ( rMrkDatRdAddrCnt=1 ) then 
					rMrkDatRdAddrCntEn(0)	<= '0';
				else 
					rMrkDatRdAddrCntEn(0)	<= rMrkDatRdAddrCntEn(0);
				end if; 
			end if;
		end if;
	End Process u_rMrkDatRdAddrCntEn;
	
	-- Ascii control 
	u_rMrkDatAsciiTransEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkDatAsciiTransEn	<= '0';
			else 
				if ( rAsciiInTransEn='1' ) then 
					rMrkDatAsciiTransEn	<= '0';
				elsif ( rMrkMsgTag146En(1 downto 0)="01" or rMrkMsgTag267En(1 downto 0)="01" ) then 
					rMrkDatAsciiTransEn	<= '1';
				else 
					rMrkDatAsciiTransEn	<= rMrkDatAsciiTransEn;
				end if;
			end if;
		end if;
	End Process u_rMrkDatAsciiTransEn;
	
	-- Output of Market data message 
	u_rMrkMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgEop		<= '0';
			else 
				if ( rMrkMsgEqual(1)='1' and rMrkMsgTag269En(1)='1' and rMrkMsgRptSymEnd1=1 ) then 
					rMrkMsgEop	<= '1';
				else 
					rMrkMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rMrkMsgEop;
	
	u_rMrkMsgSoh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgSoh		<= '0';
			else 
				-- Used Equal sign as a indicator 
				if ( (rMrkMsgEqual(2)='1' and rMrkMsgTag262En(1)='1') or (rMrkMsgEqual(1)='1' 
					and (rMrkMsgTag263En(1)='1' or rMrkMsgTag264En(1)='1' or rMrkMsgTag265En(1)='1' 
					or rMrkMsgTag266En(1)='1' or rMrkMsgTag22En(1)='1' or rMrkMsgTag269En(1)='1'))
					-- Used Ascii encoding output as a indicator 
					or (AsciiOutEop='1' and AsciiOutVal='1' and rMsgGenCtrl1(3)='1')
					-- Used Read Rom signal as a indicator 
					or rMrkDatRdAddrCntEn(1 downto 0)="10" ) then 
					rMrkMsgSoh	<= '1';
				else 
					rMrkMsgSoh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rMrkMsgSoh;
	
	u_rMrkMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgEqual( 2 downto 0 )	<= (others=>'0');
			else 
				rMrkMsgEqual(2)	<= rMrkMsgEqual(1);
				rMrkMsgEqual(1)	<= rMrkMsgEqual(0);
				if ( (rMrkMsgDataCnt=2 and (rMrkMsgTag262En(1)='1' or rMrkMsgTag263En(1)='1'
					or rMrkMsgTag264En(1)='1' or rMrkMsgTag265En(1)='1' or rMrkMsgTag266En(1)='1'
					or rMrkMsgTag146En(1)='1' or rMrkMsgTag267En(1)='1' or rMrkMsgTag269En(1)='1'))
					or (rMrkMsgDataCnt=1 and (rMrkMsgTag55En(1)='1' or rMrkMsgTag48En(1)='1' 
					or rMrkMsgTag22En(1)='1')) ) then 
					rMrkMsgEqual(0)	<= '1';
				else 
					rMrkMsgEqual(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rMrkMsgEqual;
	
	u_rMrkMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rMrkMsgVal	<= '0';
			else 
				if ( rMrkMsgTag262En(1 downto 0)="01" or (AsciiOutEop='1' and AsciiOutVal='1'
					and rMsgGenCtrl1(3)='1') or rMrkDatRdAddrCntEn(1 downto 0)="01" ) then 
					rMrkMsgVal	<= '1';
				elsif ( (rMrkMsgEqual(0)='1' and (rMrkMsgTag146En(1)='1' or rMrkMsgTag267En(1)='1'
					or rMrkMsgTag55En(1)='1')) or rMrkMsgEop='1' ) then 
					rMrkMsgVal	<= '0';
				else 
					rMrkMsgVal	<= rMrkMsgVal;
				end if;
			end if;
		end if;
	End Process u_rMrkMsgVal;
	
	-- Using Bit 31 downto 24 as a output 
	u_rMrkMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			if ( rMrkMsgTag262En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK262&TxCtrl2GenTag262(15 downto 8); 
			elsif ( rMrkMsgTag262En(1)='1' and rMrkMsgEqual(1)='1' ) then 
				rMrkMsgData(31 downto 0 )	<= TxCtrl2GenTag262(7 downto 0)&x"000000"; 
			elsif ( rMrkMsgTag263En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK263&TxCtrl2GenTag263(7 downto 0); 
			elsif ( rMrkMsgTag264En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK264&TxCtrl2GenTag264(7 downto 0); 
			elsif ( rMrkMsgTag265En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK265&TxCtrl2GenTag265(7 downto 0); 
			elsif ( rMrkMsgTag266En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK266&TxCtrl2GenTag266(7 downto 0); 
			elsif ( rMrkMsgTag146En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK146&x"00"; 
			elsif ( rMrkMsgTag55En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK55&x"0000"; 
			elsif ( rMrkMsgTag48En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK48&x"0000"; 
			elsif ( rMrkMsgTag22En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK22&TxCtrl2GenTag22(7 downto 0)&x"00"; 
			elsif ( rMrkMsgTag267En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK267&x"00"; 
			elsif ( rMrkMsgTag269En(1 downto 0)="01" ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK269&TxCtrl2GenTag269(15 downto 8); 
			elsif ( rMrkMsgTag269En(1)='1' and rMrkMsgEqual(2)='1' ) then 
				rMrkMsgData(31 downto 0 )	<= cTagNum_MRK269&TxCtrl2GenTag269(7 downto 0); 
			-------------
			-- Byte shifting 
			elsif ( rMrkMsgEqual(0)='0' ) then 
				rMrkMsgData(31 downto 0 )	<= rMrkMsgData(23 downto 0 )&x"00";
			else 
				rMrkMsgData(31 downto 0 )	<= rMrkMsgData(31 downto 0 );
			end if; 
		end if;
	End Process u_rMrkMsgData; 

-------------------------------------------------------------------------	
-- Generate ResendReq
	
	u_rRrqMsgTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRrqMsgTag7En( 2 downto 0 )		<= (others=>'0');
				rRrqMsgTag16En( 3 downto 0 )	<= (others=>'0');
			else 
				rRrqMsgTag7En(2 downto 1)	<= rRrqMsgTag7En(1 downto 0);
				if ( rMsgGenCtrl0(4)='1' and rMsgGenCtrl1(4)='0' ) then 
					rRrqMsgTag7En(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rRrqMsgTag7En(0)	<= '0';
				else 
					rRrqMsgTag7En(0)	<= rRrqMsgTag7En(0);
				end if;
				
				rRrqMsgTag16En(3 downto 1)	<= rRrqMsgTag16En(2 downto 0); 
				if ( AsciiOutEop='1' and AsciiOutVal='1' and rRrqMsgTag7En(1)='1' ) then 
					rRrqMsgTag16En(0)	<= '1';
				elsif ( rRrqMsgEqual(1)='1' ) then 
					rRrqMsgTag16En(0)	<= '0';
				else 
					rRrqMsgTag16En(0)	<= rRrqMsgTag16En(0);
				end if;
			
			end if;
		end if; 
	End Process u_rRrqMsgTagEn;
	
	-- Output of ResendReq data message 
	u_rRrqMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRrqMsgEop		<= '0';
			else 
				if ( rRrqMsgEqual(1)='1' and rRrqMsgTag16En(1)='1' ) then 
					rRrqMsgEop	<= '1';
				else 
					rRrqMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRrqMsgEop;
	
	u_rRrqMsgSoh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRrqMsgSoh		<= '0';
			else 
				-- Used Equal sign as a indicator 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRrqMsgTag7En(1)='1')
					or (rRrqMsgEqual(1)='1' and rRrqMsgTag16En(1)='1') ) then 
					rRrqMsgSoh	<= '1';
				else 
					rRrqMsgSoh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRrqMsgSoh;
	
	u_rRrqMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRrqMsgEqual( 1 downto 0 )	<= "00";
			else 
				rRrqMsgEqual(1)	<= rRrqMsgEqual(0);
				if ( rRrqMsgTag7En(2 downto 0)="011" or rRrqMsgTag16En(3 downto 0)="0111" ) then 
					rRrqMsgEqual(0)	<= '1';
				else 
					rRrqMsgEqual(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRrqMsgEqual;
	
	u_rRrqMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRrqMsgVal	<= '0';
			else 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRrqMsgTag7En(1)='1') 
					or rRrqMsgTag7En(1 downto 0)="01" ) then 
					rRrqMsgVal	<= '1';
				elsif ( rRrqMsgEop='1' or (rRrqMsgEqual(0)='1' and rRrqMsgTag7En(1)='1') ) then 
					rRrqMsgVal	<= '0';
				else 
					rRrqMsgVal	<= rRrqMsgVal;
				end if;
			end if;
		end if;
	End Process u_rRrqMsgVal;
	
	-- Using Bit 31 downto 24 as a output 
	u_rRrqMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			if ( rRrqMsgTag7En(1 downto 0)="01" ) then 
				rRrqMsgData(15 downto 0 )	<= cTagNum_RRQ7(7 downto 0)&x"00";
			elsif ( rRrqMsgTag16En(1 downto 0)="01" ) then 
				rRrqMsgData(15 downto 0 )	<= cTagNum_RRQ16(15 downto 0);
			elsif ( rRrqMsgEqual(0)='1' ) then 
				rRrqMsgData(15 downto 0 )	<= TxCtrl2GenTag16(7 downto 0)&x"00";
			-------------
			-- Byte shifting 
			else
				rRrqMsgData(15 downto 0 )	<= rRrqMsgData(7 downto 0 )&x"00";
			end if; 
		end if;
	End Process u_rRrqMsgData; 
	
-------------------------------------------------------------------------
-- Generate SeqReset
	
	u_rRstMsgTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRstMsgTag123En( 4 downto 0 )	<= (others=>'0');
				rRstMsgTag36En( 3 downto 0 )	<= (others=>'0');
			else 
				rRstMsgTag123En(4 downto 1)	<= rRstMsgTag123En(3 downto 0); 
				if ( rMsgGenCtrl0(5)='1' and rMsgGenCtrl1(5)='0' ) then 
					rRstMsgTag123En(0)	<= '1';
				elsif ( rRstMsgEqual(1)='1' ) then 
					rRstMsgTag123En(0)	<= '0';
				else 
					rRstMsgTag123En(0)	<= rRstMsgTag123En(0);
				end if;
				
				rRstMsgTag36En(3 downto 1)	<= rRstMsgTag36En(2 downto 0); 
				if ( rRstMsgEqual(1)='1' and rRstMsgTag123En(1)='1' ) then 
					rRstMsgTag36En(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rRstMsgTag36En(0)	<= '0';
				else 
					rRstMsgTag36En(0)	<= rRstMsgTag36En(0);
				end if;
			
			end if;
		end if; 
	End Process u_rRstMsgTagEn;
	
	-- Output of ResendReq data message 
	u_rRstMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRstMsgEop		<= '0';
			else 
				if ( AsciiOutEop='1' and AsciiOutVal='1' and rRstMsgTag36En(1)='1' ) then 
					rRstMsgEop	<= '1';
				else 
					rRstMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRstMsgEop;
	
	u_rRstMsgSoh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRstMsgSoh		<= '0';
			else 
				-- Used Equal sign as a indicator 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRstMsgTag36En(1)='1')
					or ( rRstMsgEqual(1)='1' and rRstMsgTag123En(1)='1') ) then 
					rRstMsgSoh	<= '1';
				else 
					rRstMsgSoh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRstMsgSoh;
	
	u_rRstMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRstMsgEqual( 1 downto 0 )	<= "00";
			else 
				rRstMsgEqual(1)	<= rRstMsgEqual(0);
				if ( rRstMsgTag123En(4 downto 0)="01111" or rRstMsgTag36En(3 downto 0)="0111" ) then 
					rRstMsgEqual(0)	<= '1';
				else 
					rRstMsgEqual(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRstMsgEqual;
	
	u_rRstMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRstMsgVal	<= '0';
			else 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRstMsgTag36En(1)='1')
					or rRstMsgTag123En(1 downto 0)="01" ) then 
					rRstMsgVal	<= '1';
				elsif ( rRstMsgEop='1' or (rRstMsgEqual(0)='1' and rRstMsgTag36En(1)='1') ) then 
					rRstMsgVal	<= '0';
				else 
					rRstMsgVal	<= rRstMsgVal;
				end if;
			end if;
		end if;
	End Process u_rRstMsgVal;
	
	-- Using Bit 15 downto 8 as a output 
	u_rRstMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			if ( rRstMsgTag123En(1 downto 0)="01" ) then 
				rRstMsgData(15 downto 0 )	<= cTagNum_RST123(23 downto 8);
			elsif ( rRstMsgTag123En(3 downto 0)="0111" ) then 
				rRstMsgData(15 downto 0 )	<= cTagNum_RST123(7 downto 0)&x"00";
			elsif ( rRstMsgTag36En(1 downto 0)="01" ) then 
				rRstMsgData(15 downto 0 )	<= cTagNum_RST36(15 downto 0);
			-------------
			-- Byte shifting 
			else
				rRstMsgData(15 downto 0 )	<= rRstMsgData(7 downto 0)&TxCtrl2GenTag123(7 downto 0);
			end if; 
		end if;
	End Process u_rRstMsgData; 

-------------------------------------------------------------------------
-- Generate Reject 
	
	u_rRjtMsgTagEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgTag45En( 3 downto 0 )	<= (others=>'0');
				rRjtMsgTag371En( 1 downto 0 )	<= (others=>'0');
				rRjtMsgTag372En( 1 downto 0 )	<= (others=>'0');
				rRjtMsgTag373En( 1 downto 0 )	<= (others=>'0');
				rRjtMsgTag58En( 3 downto 0 )	<= (others=>'0');
			else 
				rRjtMsgTag45En(3 downto 1)	<= rRjtMsgTag45En(2 downto 0); 
				if ( rMsgGenCtrl0(6)='1' and rMsgGenCtrl1(6)='0' ) then 
					rRjtMsgTag45En(0)	<= '1';
				elsif ( AsciiOutEop='1' and AsciiOutVal='1' ) then 
					rRjtMsgTag45En(0)	<= '0';
				else 
					rRjtMsgTag45En(0)	<= rRjtMsgTag45En(0);
				end if;
				
				rRjtMsgTag371En(1)	<= rRjtMsgTag371En(0); 
				if ( AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1'
					and TxCtrl2GenTag371En='1' ) then 
					rRjtMsgTag371En(0)	<= '1';
				elsif ( rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1 ) then 
					rRjtMsgTag371En(0)	<= '0';
				else 
					rRjtMsgTag371En(0)	<= rRjtMsgTag371En(0);
				end if;
				
				rRjtMsgTag372En(1)	<= rRjtMsgTag372En(0); 
				if ( ((AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1')
					or (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1 and rRjtMsgTag371En(1)='1'))
					and TxCtrl2GenTag372En='1' ) then 
					rRjtMsgTag372En(0)	<= '1';
				elsif ( rRjtMsgEqual(1)='1' or rRjtMsgTag371En(0)='1' ) then 
					rRjtMsgTag372En(0)	<= '0';
				else 
					rRjtMsgTag372En(0)	<= rRjtMsgTag372En(0);
				end if;
				
				rRjtMsgTag373En(1)	<= rRjtMsgTag373En(0); 
				if ( ((AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1')
					or (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1 and rRjtMsgTag371En(1)='1')
					or (rRjtMsgEqual(1)='1' and rRjtMsgTag372En(1)='1'))
					and TxCtrl2GenTag373En='1' ) then 
					rRjtMsgTag373En(0)	<= '1';
				elsif ( (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1) 
					or rRjtMsgTag372En(0)='1' or rRjtMsgTag371En(0)='1' ) then 
					rRjtMsgTag373En(0)	<= '0';
				else 
					rRjtMsgTag373En(0)	<= rRjtMsgTag373En(0);
				end if;
				
				rRjtMsgTag58En(3 downto 1)	<= rRjtMsgTag58En(2 downto 0);
				if ( ((AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1')
					or (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1 and (rRjtMsgTag371En(1)='1' or rRjtMsgTag373En(1)='1'))
					or (rRjtMsgEqual(1)='1' and rRjtMsgTag372En(1)='1'))
					and TxCtrl2GenTag58En='1' ) then 
					rRjtMsgTag58En(0)	<= '1';
				elsif ( (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1) or rRjtMsgTag371En(0)='1'
					or rRjtMsgTag372En(0)='1' or rRjtMsgTag373En(0)='1' ) then 
					rRjtMsgTag58En(0)	<= '0';
				else 
					rRjtMsgTag58En(0)	<= rRjtMsgTag58En(0);
				end if;
				
			end if;
		end if; 
	End Process u_rRjtMsgTagEn;
	
	u_rRjtMsgDataCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rRjtMsgSoh='1' ) then 
				rRjtMsgDataCnt( 3 downto 0 )	<= (others=>'0');
			else 
				rRjtMsgDataCnt( 3 downto 0 )	<= rRjtMsgDataCnt( 3 downto 0 ) + 1;
			end if; 
		end if;
	End Process u_rRjtMsgDataCnt;
	
	u_rRjtMsgLenCnt : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rRjtMsgTag371En(1 downto 0)="01" ) then 
				rRjtMsgLenCnt( 3 downto 0 )	<= '0'&TxCtrl2GenTag371Len(2 downto 0);
			elsif ( rRjtMsgTag373En(1 downto 0)="01" ) then 
				rRjtMsgLenCnt( 3 downto 0 )	<= "00"&TxCtrl2GenTag373Len(1 downto 0);
			elsif ( rRjtMsgTag58En(1 downto 0)="01" ) then 
				rRjtMsgLenCnt( 3 downto 0 )	<= TxCtrl2GenTag58Len(3 downto 0);
			elsif ( rRjtMsgLenCntEn='1' ) then 
				rRjtMsgLenCnt( 3 downto 0 )	<= rRjtMsgLenCnt( 3 downto 0 ) - 1;
			else 
				rRjtMsgLenCnt( 3 downto 0 )	<= rRjtMsgLenCnt( 3 downto 0 );
			end if; 
		end if;
	End Process u_rRjtMsgLenCnt;
	
	u_rRjtMsgLenCntEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgLenCntEn	<= '0';
			else 
				if ( rRjtMsgEqual(0)='1' and (rRjtMsgTag371En(1)='1' 
					or rRjtMsgTag373En(1)='1' or rRjtMsgTag58En(1)='1') ) then 
					rRjtMsgLenCntEn	<= '1';
				elsif ( rRjtMsgLenCnt=1 ) then 
					rRjtMsgLenCntEn	<= '0';
				else 
					rRjtMsgLenCntEn	<= rRjtMsgLenCntEn;
				end if; 
			end if;
		end if;
	End Process u_rRjtMsgLenCntEn;
	
	u_rRjtMsgEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rRjtMsgTag45En(1)='1' and TxCtrl2GenTag58En='0' and TxCtrl2GenTag371En='0' 
				and TxCtrl2GenTag372En='0' and TxCtrl2GenTag373En='0' ) then 
				rRjtMsgEnd(0)	<= '1';
			else 
				rRjtMsgEnd(0)	<= '0';
			end if; 
			
			if ( rRjtMsgTag371En(1)='1' and TxCtrl2GenTag58En='0' 
				and TxCtrl2GenTag372En='0' and TxCtrl2GenTag373En='0' ) then 
				rRjtMsgEnd(1)	<= '1';
			else 
				rRjtMsgEnd(1)	<= '0';
			end if; 
			
			if ( rRjtMsgTag372En(1)='1' and TxCtrl2GenTag58En='0' and TxCtrl2GenTag373En='0' ) then 
				rRjtMsgEnd(2)	<= '1';
			else 
				rRjtMsgEnd(2)	<= '0';
			end if;
			
			if ( rRjtMsgTag373En(1)='1' and TxCtrl2GenTag58En='0' ) then 
				rRjtMsgEnd(3)	<= '1';
			else 
				rRjtMsgEnd(3)	<= '0';
			end if;
		end if; 
	End Process u_rRjtMsgEnd;
	
	-- Output of ResendReq data message 
	u_rRjtMsgEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgEop		<= '0';
			else 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgEnd(0)='1')
					or (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1 
					and (rRjtMsgEnd(1)='1' or rRjtMsgEnd(3)='1' or rRjtMsgTag58En(1)='1'))
					or (rRjtMsgEnd(2)='1' and rRjtMsgEqual(1)='1') ) then 
					rRjtMsgEop	<= '1';
				else 
					rRjtMsgEop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRjtMsgEop;
	
	u_rRjtMsgSoh : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgSoh		<= '0';
			else 
				-- Used Equal sign as a indicator 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1')
					or (rRjtMsgLenCntEn='1' and rRjtMsgLenCnt=1)
					or (rRjtMsgEqual(1)='1' and rRjtMsgTag372En(1)='1') ) then 
					rRjtMsgSoh	<= '1';
				else 
					rRjtMsgSoh	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRjtMsgSoh;
	
	u_rRjtMsgEqual : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgEqual( 1 downto 0 )	<= "00";
			else 
				rRjtMsgEqual(1)	<= rRjtMsgEqual(0);
				if ( rRjtMsgTag45En(3 downto 0)="0111" or rRjtMsgTag58En(3 downto 0)="0111" 
					or ( rRjtMsgDataCnt=2 and (rRjtMsgTag371En(1)='1' 
					or rRjtMsgTag372En(1)='1' or rRjtMsgTag373En(1)='1')) ) then 
					rRjtMsgEqual(0)	<= '1';
				else 
					rRjtMsgEqual(0)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRjtMsgEqual;
	
	u_rRjtMsgVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRjtMsgVal	<= '0';
			else 
				if ( (AsciiOutEop='1' and AsciiOutVal='1' and rRjtMsgTag45En(1)='1')
					or rRjtMsgTag45En(1 downto 0)="01" ) then 
					rRjtMsgVal	<= '1';
				elsif ( rRjtMsgEop='1' or (rRjtMsgEqual(0)='1' and rRjtMsgTag45En(1)='1') ) then 
					rRjtMsgVal	<= '0';
				else 
					rRjtMsgVal	<= rRjtMsgVal;
				end if;
			end if;
		end if;
	End Process u_rRjtMsgVal;
	
	-- Using Bit 31 downto 24 as a output 
	u_rRjtMsgData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-------------
			if ( rRjtMsgTag45En(1 downto 0)="01" ) then 
				rRjtMsgData(31 downto 0 )	<= cTagNum_RJT45(15 downto 0)&x"0000";
			elsif ( rRjtMsgTag371En(1 downto 0)="01" ) then 
				rRjtMsgData(31 downto 0 )	<= cTagNum_RJT371(23 downto 0)&x"00";
			elsif ( rRjtMsgTag372En(1 downto 0)="01" ) then 
				rRjtMsgData(31 downto 0 )	<= cTagNum_RJT372(23 downto 0)&x"00";
			elsif ( rRjtMsgTag373En(1 downto 0)="01" ) then 
				rRjtMsgData(31 downto 0 )	<= cTagNum_RJT373(23 downto 0)&x"00";
			elsif ( rRjtMsgTag58En(1 downto 0)="01" ) then 
				rRjtMsgData(31 downto 0 )	<= cTagNum_RJT58(15 downto 0)&x"0000";
			elsif ( rRjtMsgTag371En(1)='1' and rRjtMsgDataCnt=3 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag371(31 downto 0);
			elsif ( rRjtMsgTag373En(1)='1' and rRjtMsgDataCnt=3 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag373(15 downto 0)&x"0000";
			elsif ( rRjtMsgTag58En(1)='1' and rRjtMsgDataCnt=2 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag58(127 downto 96);
			elsif ( rRjtMsgTag58En(1)='1' and rRjtMsgDataCnt=6 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag58( 95 downto 64);
			elsif ( rRjtMsgTag58En(1)='1' and rRjtMsgDataCnt=10 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag58( 63 downto 32);
			elsif ( rRjtMsgTag58En(1)='1' and rRjtMsgDataCnt=14 ) then 
				rRjtMsgData(31 downto 0 )	<= TxCtrl2GenTag58( 31 downto 0);
			-------------
			-- Byte shifting 
			else
				rRjtMsgData(31 downto 0 )	<= rRjtMsgData(23 downto 0)&TxCtrl2GenTag372(7 downto 0);
			end if; 
		end if;
	End Process u_rRjtMsgData; 
	
-------------------------------------------------------------------------
-- Ascii Encoder process 

	u_rAsciiInData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMsgGenCtrl0(3)='1' and rMsgGenCtrl1(3)='0' ) then 
				rAsciiInData(26 downto 0 )	<= "000"&x"00000"&TxCtrl2GenTag146(3 downto 0);
			elsif ( rMrkMsgTag262En(1 downto 0)="01" ) then 
				rAsciiInData(26 downto 0 )	<= x"000000"&TxCtrl2GenTag267(2 downto 0);
			elsif ( rMsgGenCtrl0(4)='1' and rMsgGenCtrl1(4)='0' ) then 
				rAsciiInData(26 downto 0 )	<= TxCtrl2GenTag7(26 downto 0 );
			elsif ( rMsgGenCtrl0(5)='1' and rMsgGenCtrl1(5)='0' ) then 
				rAsciiInData(26 downto 0 )	<= TxCtrl2GenTag36(26 downto 0 );
			else 
				rAsciiInData(26 downto 0 )	<= TxCtrl2GenTag45(26 downto 0 );
			end if; 
		end if; 
	End Process u_rAsciiInData;
	
	u_rAsciiInStart : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiInStart	<= '0';
			else 
				if ( (rMsgGenCtrl0(3)='1' and rMsgGenCtrl1(3)='0')
					or (rMsgGenCtrl0(4)='1' and rMsgGenCtrl1(4)='0')
					or (rMsgGenCtrl0(5)='1' and rMsgGenCtrl1(5)='0')
					or (rMsgGenCtrl0(6)='1' and rMsgGenCtrl1(6)='0')
					or rMrkMsgTag262En(1 downto 0)="01" ) then 
					rAsciiInStart	<= '1'; 
				else 
					rAsciiInStart	<= '0';
				end if;
			end if; 
		end if; 
	End Process u_rAsciiInStart;
	
	u_rAsciiInTransEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rAsciiInTransEn	<= '0';
			else 
				if ( AsciiOutReq='1' and (rMrkDatAsciiTransEn='1' 
					or rMsgGenCtrl1(4)='1' or rMsgGenCtrl1(5)='1' or rMsgGenCtrl1(6)='1') ) then 
					rAsciiInTransEn	<= '1'; 
				else 
					rAsciiInTransEn	<= '0';
				end if;
			end if; 
		end if; 
	End Process u_rAsciiInTransEn;

-------------------------------------------------------------------------
-- Output Message process 

	u_rOutMsgWrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( AsciiOutVal='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= AsciiOutData( 7 downto 0 );
			elsif ( rLogOnMsgSoh='1' or rHbtMsgSoh='1' or rMrkMsgSoh='1' 
				or rRrqMsgSoh='1' or rRstMsgSoh='1' or rRjtMsgSoh='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= cAscii_SOH( 7 downto 0 );
			elsif ( rLogOnMsgEqual='1' or rHbtMsgEqual='1' or rMrkMsgEqual(0)='1' 
				or rRrqMsgEqual(0)='1' or rRstMsgEqual(0)='1' or rRjtMsgEqual(0)='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= cAscii_Equal( 7 downto 0 );
			elsif ( rMrkDatRdAddrCntEn(1)='1' ) then
				rOutMsgWrData( 7 downto 0 )	<= rMrkRdData( 7 downto 0 );
			elsif ( rMsgGenCtrl0(1)='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= rLogOnMsgData(31 downto 24);
			elsif ( rMsgGenCtrl0(2)='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= rHbtMsgData(31 downto 24);
			elsif ( rMsgGenCtrl0(3)='1' ) then  
				rOutMsgWrData( 7 downto 0 )	<= rMrkMsgData(31 downto 24);
			elsif ( rMsgGenCtrl0(4)='1' ) then  
				rOutMsgWrData( 7 downto 0 )	<= rRrqMsgData(15 downto 8 );
			elsif ( rMsgGenCtrl0(5)='1' ) then 
				rOutMsgWrData( 7 downto 0 )	<= rRstMsgData(15 downto 8 );
			else 
				rOutMsgWrData( 7 downto 0 )	<= rRjtMsgData(31 downto 24);
			end if;
		end if; 
	End Process u_rOutMsgWrData;
	
	u_rOutMsgWrEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rOutMsgWrEn	<= '0';
			else 
				if ( AsciiOutVal='1' or rLogOnMsgVal='1' or rHbtMsgVal(1)='1' or rMrkMsgVal='1' 
					or rRrqMsgVal='1' or rRstMsgVal='1' or rRjtMsgVal='1' ) then 
					rOutMsgWrEn	<= '1';
				else 
					rOutMsgWrEn	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rOutMsgWrEn; 
	
	u_rOutMsgWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( rMsgGenCtrl0(0)='1' ) then 
				rOutMsgWrAddr( 9 downto 0 )	<= (others=>'0');
			elsif ( rOutMsgWrEn='1' ) then 
				rOutMsgWrAddr( 9 downto 0 )	<= rOutMsgWrAddr( 9 downto 0 ) + 1;
			else 
				rOutMsgWrAddr( 9 downto 0 )	<= rOutMsgWrAddr( 9 downto 0 );
			end if;
		end if;
	End Process u_rOutMsgWrAddr; 
	
	u_rOutMsgChecksum : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( TxCtrl2GenReq='1' and rGen2TxCtrlBusy='0' ) then 
				rOutMsgChecksum( 7 downto 0 )	<= (others=>'0');
			elsif ( rOutMsgWrEn='1' ) then 
				rOutMsgChecksum( 7 downto 0 )	<= rOutMsgChecksum( 7 downto 0 ) + rOutMsgWrData( 7 downto 0 );
			else 
				rOutMsgChecksum( 7 downto 0 )	<= rOutMsgChecksum( 7 downto 0 );
			end if;
		end if;
	End Process u_rOutMsgChecksum; 
	
	-- Used bit 1 as a checksum validation 
	u_rOutMsgEnd : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rOutMsgEnd( 1 downto 0 )	<= "00";
			else
				rOutMsgEnd(1)	<= rOutMsgEnd(0);
				if ( rLogOnMsgEop='1' or rHbtMsgEop='1' or rMrkMsgEop='1' 
					or rRrqMsgEop='1' or rRstMsgEop='1' or rRjtMsgEop='1' ) then 
					rOutMsgEnd(0)	<= '1';
				else 
					rOutMsgEnd(0)	<= '0';
				end if; 
			end if;
		end if;
	End Process u_rOutMsgEnd; 
	
End Architecture rtl;
