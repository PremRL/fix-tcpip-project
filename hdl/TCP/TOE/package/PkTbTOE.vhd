----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTOE.vhd
-- Title        Package for TbTOE
-- 
-- Author       L.Ratchanon
-- Date         2020/11/10
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note 
--
-- AutoVerify : Support only there's no validation drop. 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;
use STD.TEXTIO.all;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package

Package PkTbTOE Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant	t_Clk				: time 	  := 10 ns;
	constant	cFIXED_MACHdSize	: integer := 14;
	constant	cFIXED_TCPHdSize	: integer := 20;
	constant	cFIXED_IPHdSize		: integer := 20;
	constant	cFIXED_HeaderSize 	: integer := cFIXED_MACHdSize + cFIXED_TCPHdSize + cFIXED_IPHdSize;
	constant	cFIXED_PseudoHd		: integer := 12;
	constant	cTCPHeaderIndex		: integer := 34;
	constant 	cIPChecksumIndex	: integer := 24;
	constant 	cTCPChecksumIndex	: integer := 50;
	
------------------------------------------------------------------------
-- Array type declaration
------------------------------------------------------------------------
	
	Type	array65535ofu8	 is array (0 to 65535) of std_logic_vector( 7 downto 0 );

-------------------------------------
	-- Record of Verify signal 
	Type ExpDataRecord Is Record
		ExpMACDes		: std_logic_vector(47 downto 0 );
		ExpMACSou		: std_logic_vector(47 downto 0 );
		ExpEnetType		: std_logic_vector(15 downto 0 );
		ExpIPVerIHL		: std_logic_vector( 7 downto 0 );
		ExpDSCPECN 		: std_logic_vector( 7 downto 0 );
		ExpProtocol		: std_logic_vector( 7 downto 0 );
		ExpIPSou		: std_logic_vector(31 downto 0 );
		ExpIPDes		: std_logic_vector(31 downto 0 );
		ExpSouPort		: std_logic_vector(15 downto 0 );
		ExpDesPort		: std_logic_vector(15 downto 0 );
		ExpOffs			: std_logic_vector( 6 downto 0 );
	End Record ExpDataRecord;
	
	Type TCPDataRecord Is Record
		TCPSeqNum		: std_logic_vector(31 downto 0 );
		TCPAckNum		: std_logic_vector(31 downto 0 );
		TCPAckFlag		: std_logic;
		TCPPshFlag		: std_logic;
		TCPRstFlag		: std_logic;
		TCPSynFlag		: std_logic;
		TCPFinFlag		: std_logic;
	End Record TCPDataRecord;
	
	-- Record of DataIn signal 
	Type DataGenRecord Is Record  
		DataGenVal		: std_logic;
		DataGenSop  	: std_logic;
		DataGenEop		: std_logic;
		DataGenLen		: std_logic_vector(15 downto 0 );
		DataGen			: std_logic_vector( 7 downto 0 );
	End Record DataGenRecord;
	
	Type RxDataGenRecord Is Record
		RxDataGenVal   	: std_logic;
		RxDataGenSop   	: std_logic;
		RxDataGenEop   	: std_logic;
		RxDataGen		: std_logic_vector( 7 downto 0 );
		RxDataGenError	: std_logic_vector( 1 downto 0 );
	End Record RxDataGenRecord;
	
	Type PktTCPIPRecord Is Record
		MacDes			: std_logic_vector(47 downto 0 );
		MacSrc          : std_logic_vector(47 downto 0 );
		MacEtherType    : std_logic_vector(15 downto 0 );
		IPVerIHL        : std_logic_vector( 7 downto 0 );
		IPDSCPEC        : std_logic_vector( 7 downto 0 );
		IPIdent         : std_logic_vector(15 downto 0 );
		IPFlags         : std_logic_vector(15 downto 0 );
		IPTTL           : std_logic_vector( 7 downto 0 );
		IPProtocol      : std_logic_vector( 7 downto 0 );
		IPSrcAddr       : std_logic_vector(31 downto 0 );
		IPDesAddr       : std_logic_vector(31 downto 0 );
		TCPSrcPort      : std_logic_vector(15 downto 0 );
		TCPDesPort      : std_logic_vector(15 downto 0 );
		TCPSeqNum       : std_logic_vector(31 downto 0 );
		TCPAckNum       : std_logic_vector(31 downto 0 );
		TCPDataOff      : std_logic_vector( 3 downto 0 );
		TCPAckFlag      : std_logic;
		TCPPshFlag      : std_logic; 
		TCPRstFlag      : std_logic; 
		TCPSynFlag      : std_logic; 
		TCPFinFlag      : std_logic; 
		TCPWinSize      : std_logic_vector(15 downto 0 );
		TCPUrgent       : std_logic_vector(15 downto 0 );
	End Record PktTCPIPRecord;
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	
----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------

	-------------------------------------
	-- Procedure of TxVerify
	Procedure TxVerify
	(
		signal		TCPDataRec		: out 	TCPDataRecord;
		signal 		ExpDataRec		: in  	ExpDataRecord;
		signal	    DataOutVal		: in 	std_logic;
		signal		DataOutSop		: in 	std_logic;
		signal 		DataOutEop		: in	std_logic;
		signal		DataOut			: in 	std_logic_vector( 7 downto 0 );
		signal 		DataOutFF		: in	std_logic_vector(47 downto 0 ); 
		signal 		Clk				: in 	std_logic
	);
	
	-------------------------------------
	-- Procedure of upper layer data Initialization   
	Procedure DataGenInitial
	(
		signal		DataGenRec		: out	DataGenRecord
	);
	
	-------------------------------------
	-- Procedure of upper layer data generating  
	Procedure UserDataInGen
	(
		signal		DataGenRec		: out	DataGenRecord;
		variable	vDataGenLength	: in	integer range 0 to 65535;
		variable	vDataGenValue	: in	integer range 0 to 255;
		variable	vDataGenOp		: in	integer range 0 to 1;
		signal		Clk				: in	std_logic
	);
	
	-------------------------------------
	-- Procedure of upper layer data Initialization   
	Procedure RxDataGenInitial
	(
		signal		RxDataGenRec	: out	RxDataGenRecord
	);
	
	-------------------------------------
	-- Procedure of TCP Server data generator 
	Procedure RxTCPDataGen 
	(
		signal		RxDataGenRec		: out	RxDataGenRecord;
		signal      PktTCPIPRec			: in 	PktTCPIPRecord;
		variable 	vPayloadLen			: integer range 0 to 16383;
		variable 	vPayloadValue		: integer range 0 to 255;
		variable	vRxMacErrorOp		: integer range 0 to 1; 
		signal 		Clk					: std_logic 
	);
	
End Package PkTbTOE;		

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package Body

Package Body PkTbTOE Is

	-- converts a std_logic_vector into a hex string.
	Function hstr(slv: std_logic_vector) Return string Is
		variable hexlen		: integer;
		variable longslv 	: std_logic_vector(260 downto 0) := (others => '0');
		variable hex 		: string(1 to 64);
		variable fourbit 	: std_logic_vector(3 downto 0);
	Begin
		hexlen := (slv'left+1 - slv'right)/4;		
		if (slv'left+1 - slv'right) mod 4 /= 0 then
		 hexlen := hexlen + 1;
		end if;		
		longslv(slv'left-slv'right downto 0) := slv;		
		For i in (hexlen -1) downto 0 loop
			fourbit := longslv(((i*4)+3) downto (i*4));
			case fourbit is
				when "0000" => hex(hexlen -i) := '0';
				when "0001" => hex(hexlen -i) := '1';
				when "0010" => hex(hexlen -i) := '2';
				when "0011" => hex(hexlen -i) := '3';
				when "0100" => hex(hexlen -i) := '4';
				when "0101" => hex(hexlen -i) := '5';
				when "0110" => hex(hexlen -i) := '6';
				when "0111" => hex(hexlen -i) := '7';
				when "1000" => hex(hexlen -i) := '8';
				when "1001" => hex(hexlen -i) := '9';
				when "1010" => hex(hexlen -i) := 'A';
				when "1011" => hex(hexlen -i) := 'B';
				when "1100" => hex(hexlen -i) := 'C';
				when "1101" => hex(hexlen -i) := 'D';
				when "1110" => hex(hexlen -i) := 'E';
				when "1111" => hex(hexlen -i) := 'F';
				when "ZZZZ" => hex(hexlen -i) := 'z';
				when "UUUU" => hex(hexlen -i) := 'u';
				when "XXXX" => hex(hexlen -i) := 'x';
				when others => hex(hexlen -i) := '?';
			end case;
		End loop;
		Return hex(1 to hexlen);
    End Function hstr;

	-------------------------------------
	-- Auto verify TxTCP/IP Output 
	Procedure TxVerify
	(
		signal 		TCPDataRec		: out 	TCPDataRecord; 
		signal 		ExpDataRec		: in 	ExpDataRecord;
		signal	    DataOutVal		: in 	std_logic;
		signal		DataOutSop		: in 	std_logic;
		signal 		DataOutEop		: in	std_logic;
		signal		DataOut			: in 	std_logic_vector( 7 downto 0 );
		signal 		DataOutFF		: in	std_logic_vector(47 downto 0 );  
		signal 		Clk				: in 	std_logic	
	) Is
	variable	TCPChecksum : std_logic_vector(16 downto 0 ) := (others=>'0');
	variable	IPChecksum 	: std_logic_vector(16 downto 0 ) := (others=>'0');
	variable	IHL			: integer range 0 to 64 := 20;
	variable	TCPOffset	: integer range 0 to 64 := 20;
	variable	rTotLen		: std_logic_vector(15 downto 0 );
	variable	TCPLen		: std_logic_vector(15 downto 0 );
	variable	DataLen		: std_logic_vector(15 downto 0 );
	variable 	ByteCnt		: integer range 0 to 31 := 0;
	Begin
		-- MAC Header
		wait for 4.5*t_Clk;
		Assert (ExpDataRec.ExpMACDes=DataOutFF(39 downto 0)&DataOut(7 downto 0)) 
		Report "ERROR MAC : Destination MAC Address not match"&hstr(DataOutFF(39 downto 0))&hstr(DataOut(7 downto 0))
		Severity Failure; 
		
		wait for 6*t_Clk;
		Assert (ExpDataRec.ExpMACSou=DataOutFF(39 downto 0)&DataOut(7 downto 0)) 
		Report "ERROR MAC : Source MAC Address not match"
		Severity Failure; 
		
		wait for 2*t_Clk;
		Assert (ExpDataRec.ExpEnetType=DataOutFF(7 downto 0)&DataOut(7 downto 0)) 
		Report "ERROR MAC : EthernetType not match"
		Severity Failure;

		-- IP Header 
		L1 : Loop 
			wait for t_Clk;
			if ( ByteCnt=0 ) then 
				Assert (ExpDataRec.ExpIPVerIHL=DataOut) 
				Report "ERROR IP : Ver and IHL not match"
				Severity Failure;
				IHL		:= conv_integer(DataOut(3 downto 0)&"00");
			elsif ( ByteCnt=1 ) then 
				Assert (ExpDataRec.ExpDSCPECN=DataOut) 
				Report "ERROR IP : DSCP and ECN not match"
				Severity Failure;
			elsif ( ByteCnt=2 or ByteCnt=3 ) then 
				rTotLen	:= rTotLen(7 downto 0)&DataOut(7 downto 0);
			elsif ( ByteCnt=9 ) then 
				Assert (ExpDataRec.ExpProtocol=DataOut) 
				Report "ERROR IP : Protocol not match"
				Severity Failure;
				TCPLen	:= rTotLen - IHL;
			elsif ( ByteCnt=15 ) then 
				Assert (ExpDataRec.ExpIPSou=DataOutFF(23 downto 0)&DataOut) 
				Report "ERROR IP : Source IP not match"
				Severity Failure;
			elsif ( ByteCnt=19 ) then 
				Assert (ExpDataRec.ExpIPDes=DataOutFF(23 downto 0)&DataOut) 
				Report "ERROR IP : Destination IP not match"
				Severity Failure;
			end if;
			
			-- IP CheckSum
			if ( (ByteCnt mod 2) = 1 ) then 
				IPChecksum(16 downto 0 )	:= IPChecksum(16 downto 0 ) + ('0'&DataOutFF(7 downto 0)&DataOut);
				IPChecksum(15 downto 0)		:= IPChecksum(15 downto 0) + IPChecksum(16);
				IPChecksum(16)				:= '0'; 
			end if;
			
			-- TCP Pseudo-header
			if ( ByteCnt=9 ) then
				TCPChecksum(16 downto 0 )	:= '0'&x"00"&DataOut;
			elsif ( ByteCnt=11 ) then 
				TCPChecksum(16 downto 0 )	:= TCPChecksum(16 downto 0 ) + ('0'&TCPLen(15 downto 0 ));
			elsif ( ByteCnt=13 or ByteCnt=15 or ByteCnt=17 or ByteCnt=19 ) then 
				TCPChecksum(16 downto 0 )	:= TCPChecksum(16 downto 0 ) + ('0'&DataOutFF(7 downto 0)&DataOut);
			end if;
			TCPChecksum(15 downto 0)		:= TCPChecksum(15 downto 0) + TCPChecksum(16);
			TCPChecksum(16)					:= '0';
			
			ByteCnt	:= ByteCnt + 1;
			exit L1 when ByteCnt=IHL;
		End Loop;
		
		-- IP CheckSum verification
		Assert (IPChecksum(15 downto 0)=x"FFFF") 
		Report "ERROR IP : IP CheckSum Invalid"
		Severity Failure;
		
		-- TCP Header 
		ByteCnt	:= 0;
		L2 : Loop
			wait for t_Clk;
			if ( ByteCnt=1 ) then 
				Assert (ExpDataRec.ExpSouPort=DataOutFF(7 downto 0)&DataOut) 
				Report "ERROR TCP : Source Port not match"
				Severity Failure;
			elsif ( ByteCnt=3 ) then 
				Assert (ExpDataRec.ExpDesPort=DataOutFF(7 downto 0)&DataOut) 
				Report "ERROR TCP : Destination port not match"
				Severity Failure;
			elsif ( ByteCnt=7 ) then 
				TCPDataRec.TCPSeqNum	<= DataOutFF(23 downto 0)&DataOut;
			elsif ( ByteCnt=11 ) then 
				TCPDataRec.TCPAckNum	<= DataOutFF(23 downto 0)&DataOut;
			elsif ( ByteCnt=12 ) then 
				TCPOffset	:= conv_integer(DataOut(7 downto 4)&"00");	
				DataLen		:= TCPLen - TCPOffset;
			elsif ( ByteCnt=13 ) then  
				TCPDataRec.TCPAckFlag	<= DataOut(4);
				TCPDataRec.TCPPshFlag	<= DataOut(3);
				TCPDataRec.TCPRstFlag   <= DataOut(2);
				TCPDataRec.TCPSynFlag	<= DataOut(1);
				TCPDataRec.TCPFinFlag	<= DataOut(0);
				if ( not (TCPOffset=24 and DataOut(1)='1') 
					and not (TCPOffset=20) ) then 
					Report "ERROR TCP : Data offset not match"
					Severity Failure;
				end if;
			end if;
			
			-- TCP header CheckSum
			if ( (ByteCnt mod 2) = 1 ) then 
				TCPChecksum(16 downto 0 )	:= TCPChecksum(16 downto 0 ) + ('0'&DataOutFF(7 downto 0)&DataOut);
				TCPChecksum(15 downto 0)	:= TCPChecksum(15 downto 0) + TCPChecksum(16);
				TCPChecksum(16)				:= '0'; 
			end if;
			
			ByteCnt	:= ByteCnt + 1;
			exit L2 when ByteCnt=TCPOffset;
		End Loop;
		
		-- payload 
		if ( DataLen/=0 ) then 
			for i in 1 to conv_integer(DataLen) loop
				wait for t_Clk;
				if (i=conv_integer(DataLen) and (i mod 2=1)) then 
					TCPChecksum(16 downto 0 )	:= TCPChecksum(16 downto 0 ) + ('0'&DataOut&x"00");
				elsif (i mod 2=0) then 
					TCPChecksum(16 downto 0 )	:= TCPChecksum(16 downto 0 ) + ('0'&DataOutFF(7 downto 0)&DataOut);
				end if;
				TCPChecksum(15 downto 0)	:= TCPChecksum(15 downto 0) + TCPChecksum(16);
				TCPChecksum(16)				:= '0'; 
			end loop;
		end if;
		
		-- TCP CheckSum
		Assert ( TCPChecksum(15 downto 0)=x"FFFF" )
		Report "ERROR TCP CheckSum"
		Severity Failure;
		
		-- Length valid 
		Assert ( DataOutEop='1' and DataOutVal='1' ) 
		Report "ERROR Length of Payload"
		Severity Failure;

	End Procedure TxVerify;
	
	-------------------------------------
	-- Initialize DataGen 
	Procedure DataGenInitial
	(
		signal		DataGenRec		: out	DataGenRecord
	) Is
	Begin
		DataGenRec.DataGenVal		<= '0';
		DataGenRec.DataGenSop		<= '0';
		DataGenRec.DataGenEop		<= '0';
		DataGenRec.DataGenLen		<= (others=>'0');
		DataGenRec.DataGen			<= (others=>'0');
	End Procedure DataGenInitial;

	-------------------------------------
	-- DataGen Generator 
	-- 
	--  Note : if vDataGenOp=1, enable validation dropping. 
 	Procedure UserDataInGen
	(
		signal		DataGenRec		: out	DataGenRecord;
		variable	vDataGenLength	: in	integer range 0 to 65535;
		variable	vDataGenValue	: in	integer range 0 to 255;
		variable	vDataGenOp		: in	integer range 0 to 1;
		signal		Clk				: in	std_logic
	) Is
	Begin
		
		For i in 0 to vDataGenLength loop
			wait until rising_edge(Clk);
			DataGenRec.DataGenVal		<= '1';
			DataGenRec.DataGen			<= conv_std_logic_vector(vDataGenValue, DataGenRec.DataGen'length);
			DataGenRec.DataGenLen		<= conv_std_logic_vector(vDataGenLength, DataGenRec.DataGenLen'length);
			-- SOP Byte  
			if ( i=0 ) then 
				DataGenRec.DataGenSop		<= '1';
			elsif ( i=1 ) then 
				DataGenRec.DataGenSop		<= '0';
			end if;
			
			-- EOP Byte
			if ( i=vDataGenLength-1 ) then 
				DataGenRec.DataGenEop		<= '1';
			end if;
			-- Option validation drop 
			if ( vDataGenOp=1 ) then 
				DataGenRec.DataGenVal		<= '0';
				DataGenRec.DataGen			<= not conv_std_logic_vector(vDataGenValue, DataGenRec.DataGen'length);
				wait until rising_edge(Clk);
				DataGenRec.DataGenVal		<= '1';
				DataGenRec.DataGen			<= conv_std_logic_vector(vDataGenValue, DataGenRec.DataGen'length);
			end if;
		End loop;
		
		DataGenRec.DataGenVal		<= '0';
		DataGenRec.DataGenSop		<= '0';
		DataGenRec.DataGenEop		<= '0';
		DataGenRec.DataGenLen		<= (others=>'0');
		DataGenRec.DataGen			<= (others=>'0');
		wait until rising_edge(Clk);
		
	End Procedure UserDataInGen;
	
	-------------------------------------
	-- TCP Server data generator 
	Procedure RxDataGenInitial
	(
		signal		RxDataGenRec		: out	RxDataGenRecord
	) Is
	Begin
		RxDataGenRec.RxDataGenVal   <= '0';
		RxDataGenRec.RxDataGenSop   <= '0';
		RxDataGenRec.RxDataGenEop   <= '0';
		RxDataGenRec.RxDataGen		<= (others=>'0');
		RxDataGenRec.RxDataGenError	<= (others=>'0');
	End Procedure RxDataGenInitial;
	
	-------------------------------------
	-- TCP Server data generator 
	Procedure RxTCPDataGen 
	(
		signal		RxDataGenRec		: out	RxDataGenRecord;
		signal      PktTCPIPRec			: in 	PktTCPIPRecord;
		variable 	vPayloadLen			: integer range 0 to 16383;
		variable 	vPayloadValue		: integer range 0 to 255;
		variable	vRxMacErrorOp		: integer range 0 to 1;
		signal 		Clk					: std_logic 
	) Is
	variable	vTCPChecksum 	: std_logic_vector(16 downto 0 ) := (others=>'0');
	variable	vIPChecksum  	: std_logic_vector(16 downto 0 ) := (others=>'0');
	variable 	vTempChecksum	: std_logic_vector( 7 downto 0 ) := (others=>'0');
	variable	vIPTotLen		: std_logic_vector(15 downto 0 ) := x"0028"; -- IP + TCP Header 
	variable 	vRxDataRam		: array65535ofu8 := (others => (others=>'0'));
	variable	vHeaderRam		: std_logic_vector(8*cFIXED_HeaderSize-1 downto 0 );
	variable	vPseudoRam		: std_logic_vector(8*cFIXED_PseudoHd-1 downto 0 );
	variable	vLength			: integer range 0 to 65535;
	variable 	vTransLength	: integer range 0 to 65535;
	
	Begin
		wait until rising_edge(Clk);
		-- Header length : MAC + IP + TCP 
		vLength := cFIXED_HeaderSize;
		-- IP total length 
		if ( vPayloadLen/=0 ) then 
			vIPTotLen	:= vIPTotLen + vPayloadLen; 
		end if;
		
		-- MAC&TCP&IP Header 
		vHeaderRam	:= 	PktTCPIPRec.MacDes & PktTCPIPRec.MacSrc & PktTCPIPRec.MacEtherType &
						PktTCPIPRec.IPVerIHL & PktTCPIPRec.IPDSCPEC & vIPTotLen &
						PktTCPIPRec.IPIdent & PktTCPIPRec.IPFlags & PktTCPIPRec.IPTTL &
						PktTCPIPRec.IPProtocol & x"0000" & PktTCPIPRec.IPSrcAddr & 
						PktTCPIPRec.IPDesAddr & PktTCPIPRec.TCPSrcPort & PktTCPIPRec.TCPDesPort & 
						PktTCPIPRec.TCPSeqNum & PktTCPIPRec.TCPAckNum & PktTCPIPRec.TCPDataOff &
						"0000000" & PktTCPIPRec.TCPAckFlag & PktTCPIPRec.TCPPshFlag &
						PktTCPIPRec.TCPRstFlag & PktTCPIPRec.TCPSynFlag & PktTCPIPRec.TCPFinFlag &
						PktTCPIPRec.TCPWinSize & x"0000" & PktTCPIPRec.TCPUrgent;
						
		-- build Header (54 bytes)
		For byte in 0 to cFIXED_HeaderSize-1 loop
			vRxDataRam(byte) 	:= vHeaderRam( (8*((cFIXED_HeaderSize-byte-1)+1))-1 downto (8*(cFIXED_HeaderSize-byte-1)) );
		End loop;
		
		-- Add Payload to the Packet 
		if ( vPayloadLen/=0 ) then 
			vLength	:= vLength + vPayloadLen; 
			For i in 0 to vPayloadLen-1 loop 
				vRxDataRam( cFIXED_HeaderSize+i ) := conv_std_logic_vector(vPayloadValue, vRxDataRam(0)'length);
			End loop;
		end if; 
		
		-- Checksum calculation 
		-- IPv4 checksum 
		For i in 0 to cFIXED_IPHdSize/2-1 loop 
			vIPChecksum(16 downto 0)	:= vIPChecksum(16 downto 0) + ('0'&vRxDataRam(2*i+cFIXED_MACHdSize)&vRxDataRam(2*i+1+cFIXED_MACHdSize));
			vIPChecksum(15 downto 0)	:= vIPChecksum(15 downto 0) + vIPChecksum(16);
			vIPChecksum(16)				:= '0';
		End loop;
		vRxDataRam(cIPChecksumIndex)	:= not vIPChecksum(15 downto 8 );
		vRxDataRam(cIPChecksumIndex+1)	:= not vIPChecksum( 7 downto 0 );
		
		-- TCP checksum 
		-- Pseudo-header 
		vPseudoRam		:= PktTCPIPRec.IPSrcAddr & PktTCPIPRec.IPDesAddr & x"00" & 										
						PktTCPIPRec.IPProtocol & conv_std_logic_vector(conv_integer(vIPTotLen)-cFIXED_IPHdSize, 16);
		For i in 0 to (cFIXED_PseudoHd/2)-1 loop  
			vTCPChecksum(16 downto 0)	:= vTCPChecksum(16 downto 0) + vPseudoRam( (8*((cFIXED_PseudoHd-2*i-1)+1))-1 downto (8*(cFIXED_PseudoHd-2*(i+1))) );
			vTCPChecksum(15 downto 0)	:= vTCPChecksum(15 downto 0) + vTCPChecksum(16);
			vTCPChecksum(16)			:= '0';
		End loop;
		-- TCP Header & Payload 
		For i in cTCPHeaderIndex to vLength-1 loop 
			if ( (i mod 2 = 0) and (i = vLength-1) ) then 
				vTCPChecksum(16 downto 0)	:= vTCPChecksum(16 downto 0) + ('0'&vRxDataRam(i)&x"00");
			elsif ( i mod 2 = 0 ) then 
				vTempChecksum				:= vRxDataRam(i);
			else 
				vTCPChecksum(16 downto 0)	:= vTCPChecksum(16 downto 0) + ('0'&vTempChecksum&vRxDataRam(i));
			end if;
			vTCPChecksum(15 downto 0)	:= vTCPChecksum(15 downto 0) + vTCPChecksum(16);
			vTCPChecksum(16)			:= '0';
		End loop;
		vRxDataRam(cTCPChecksumIndex)	:= not vTCPChecksum(15 downto 8 );
		vRxDataRam(cTCPChecksumIndex+1)	:= not vTCPChecksum( 7 downto 0 );
		 
		-- Generating Data 
		wait until rising_edge(Clk);
		RxDataGenRec.RxDataGenVal			<= '1';
		RxDataGenRec.RxDataGenSop			<= '1';
		RxDataGenRec.RxDataGen				<= vRxDataRam(0);
		if ( vLength<=60 ) then 
			vTransLength	:= 60;	-- Zero padding 
		else
			vTransLength	:= vLength;
		end if;
		
		For i in 1 to vTransLength loop 
			wait until rising_edge(Clk);
			-- DataPath 
			if ( i<=vLength ) then 
				RxDataGenRec.RxDataGen			<= vRxDataRam(i);
			else 
				RxDataGenRec.RxDataGen			<= (others=>'0');
			end if;
			
			-- Start Byte 
			if ( i=1 ) then 
				RxDataGenRec.RxDataGenSop	<= '0';
			-- Last Byte
			elsif ( i=vTransLength-1 ) then 
				RxDataGenRec.RxDataGenEop	<= '1';
				-- Error Option 
				if ( vRxMacErrorOp=1 ) then 
					RxDataGenRec.RxDataGenError(0)	<= '1';
				end if; 
			end if;
		End loop;
		
		RxDataGenRec.RxDataGenVal   		<= '0';
		RxDataGenRec.RxDataGenSop   		<= '0';
		RxDataGenRec.RxDataGenEop   		<= '0';
		RxDataGenRec.RxDataGen				<= (others=>'0');
		RxDataGenRec.RxDataGenError			<= (others=>'0');
		wait until rising_edge(Clk);

	End Procedure RxTCPDataGen;
	
End Package Body PkTbTOE;