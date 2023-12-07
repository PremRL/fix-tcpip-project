----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		PkTbFixProc.vhd
-- Title		Package for TbFixProc
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       L.Ratchanon 
-- Date         2021/02/20
-- Remark       Using string based function 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.all;
use STD.TEXTIO.all;

Package PkTbFixProc Is
	
	------------------------------------------------------------------------
	-- Constant declaration
	------------------------------------------------------------------------
	
	constant cAsciiSOH			: std_logic_vector( 7 downto 0 )	:= x"01";
	
	------------------------------------------------------------------------
	-- Array type declaration
	------------------------------------------------------------------------
	Type 	Pkt_array 		is array ( 0 to 1023 ) of std_logic_vector( 7 downto 0 );
	
	------------------------------------------------------------------------
	-- Recored declaration
	------------------------------------------------------------------------
	
	Type RxTCPDataRecord is Record
		RxTCPValid		: std_logic; 	
		RxTCPSop		: std_logic; 
		RxTCPEop		: std_logic; 
		RxTCPData		: std_logic_vector( 7 downto 0 ); 
	End	Record;
	
	Type HdRecord is Record
		HdBeginStr		: string ( 1 to 32); 	
		HdMsgType		: string ( 1 to 32); 	 	
		HdSeqNum		: string ( 1 to 32); 		
		HdSendComID		: string ( 1 to 32); 	
		HdTarComID		: string ( 1 to 32); 	 
		HdSendTime		: string ( 1 to 32); 	-- String Format : 20210314-21:50:12.523
		HdPossDup		: string ( 1 to 32); 	
		HdBeginStrLen	: integer range 1 to 32; 
		HdMsgTypeLen	: integer range 1 to 32; 
		HdSeqNumLen		: integer range 1 to 32; 
		HdSendComIDLen	: integer range 1 to 32; 
		HdTarComIDLen	: integer range 1 to 32; 
		HdSendTimeLen	: integer range 1 to 32; 
		HdPossDupLen	: integer range 0 to 32; 
	End Record HdRecord; 									
	
	Type LogonRecord is Record
		EncryptMet		: string ( 1 to 32); 
		HeartBtInt		: string ( 1 to 32); 
		RstSeqNumFlag	: string ( 1 to 32); 
		UserName		: string ( 1 to 32); 
		Password		: string ( 1 to 32);
		AppVerID		: string ( 1 to 32); 
		EncryptMetLen	: integer range 1 to 32;
		HeartBtIntLen	: integer range 1 to 32;
		RstSeqNumFlagLen: integer range 1 to 32;
		UserNameLen		: integer range 1 to 32;
		PasswordLen		: integer range 1 to 32;
		AppVerIDLen		: integer range 1 to 32;
	End Record LogonRecord;									
	
	Type ResentReqRecord is Record
		BeginSeqNum		: string ( 1 to 32); 
		EndSeqNum		: string ( 1 to 32); 
		BeginSeqNumLen	: integer range 1 to 32;
		EndSeqNumLen	: integer range 1 to 32;
	End Record ResentReqRecord;								
	
	Type RejectRecord is Record
		RefSeqNum		: string ( 1 to 32);
		RefTagID		: string ( 1 to 32);
		RefMsgType		: string ( 1 to 32); 
		ReajectReaon	: string ( 1 to 32); 
		Reject_Text		: string ( 1 to 32);
		EncodedText		: string ( 1 to 32);
		RefSeqNumLen	: integer range 1 to 32;
		RefTagIDLen		: integer range 1 to 32;
		RefMsgTypeLen	: integer range 1 to 32;
		ReajectReaonLen	: integer range 1 to 32;
		Reject_TextLen	: integer range 1 to 32;
		EncodedTextLen	: integer range 0 to 32;
	End Record RejectRecord;								
	
	Type SeqRstRecord is Record
		GapFillFlag		: string ( 1 to 32);
		NewSeqNum		: string ( 1 to 32);
		GapFillFlagLen	: integer range 1 to 32;
		NewSeqNumLen	: integer range 1 to 32;
	End Record SeqRstRecord;								
	
	Type SnapShotFullRecord is Record
		MDReqID			: string ( 1 to 32);
		Symbol			: string ( 1 to 32);
		SecID			: string ( 1 to 32);
		SecIDSrc		: string ( 1 to 32);
		NoEntries		: string ( 1 to 32);
		EntryType0		: string ( 1 to 32);
		Price0			: string ( 1 to 32);
		Size0			: string ( 1 to 32);
		EntryTime0		: string ( 1 to 32);
		EntryType1		: string ( 1 to 32);
		Price1			: string ( 1 to 32);
		Size1			: string ( 1 to 32);
		EntryTime1		: string ( 1 to 32);
		MDReqIDLen		: integer range 1 to 32;
		SymbolLen		: integer range 1 to 32;
		SecIDLen		: integer range 1 to 32;
		SecIDSrcLen		: integer range 1 to 32;
		NoEntriesLen	: integer range 1 to 32;
		EntryType0Len	: integer range 1 to 32;
		Price0Len		: integer range 1 to 32;
		Size0Len		: integer range 1 to 32;
		EntryTime0Len	: integer range 1 to 32;
		EntryType1Len	: integer range 1 to 32;
		Price1Len		: integer range 1 to 32;
		Size1Len		: integer range 1 to 32;
		EntryTime1Len	: integer range 1 to 32;
	End Record SnapShotFullRecord;				
	
	Type FixOutDataRecord Is Record
		FixOutDataVal	: std_logic;
		FixOutDataSop	: std_logic;
		FixOutDataEop	: std_logic;
		FixOutData		: std_logic_vector( 7 downto 0 );
		FixOutDataLen	: std_logic_vector(15 downto 0 );
	End Record FixOutDataRecord;	
	
	------------------------------------------------------------------------
	-- Function and Procedure Header
	------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	Function to_slv(str: string) return std_logic_vector; 
	Function fIntToStringLeading0(a : natural; d : integer range 1 to 9) return string;
	Function Ascii2Int(Data: std_logic_vector) Return Integer;
	
	Procedure RxTCPDataInit 
	(
		signal	RxDataRec	: out RxTCPDataRecord
	);
	
	Procedure RxTCPDataGen 
	(
		variable 	RxDataLength 		: in 	integer;
		variable	RxDataArray			: in  	Pkt_array;
		signal		RxDataRec			: out 	RxTCPDataRecord;
		signal 		Clk					: in	std_logic 
	);
	
	Procedure FixHdTrBuild 
	(
		variable	HdRecIn				: in	HdRecord; 
		variable  	BodyMsgLength		: in	integer; 
		variable	ErrorOption			: in	integer; -- 0 Normal, 1 Bodylength error, 2 Checksum error, 3 both error
		variable 	MessageLength		: out	integer; 
		variable 	DataMsgArray		: inout Pkt_array
	);
	
	Procedure LogonBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	LogonRecIn			: in	LogonRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure HB_or_TestReq_Build
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	TestReqID			: in	string;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure EmptyFieldBuild		-- Ex. for Logout
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	ErrorOption			: in	integer; -- 0 Normal, 1 Bodylength error, 2 Checksum error, 3 both error
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure ReSentReqBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	ResentRecIn			: in	ResentReqRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure RejectBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	RejectRecIn			: in	RejectRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure SeqRstBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	SeqRstRecIn			: in	SeqRstRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure SnapShotBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	SnapShotFullRecIn	: in	SnapShotFullRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	);
	
	Procedure FixOutDataVerify 
	(
		signal		FixOutDataRec		: in	FixOutDataRecord;
		variable	ExpMsgType			: in	std_logic_vector(7 downto 0);
		signal 		Clk					: std_logic 
	);
	
End Package PkTbFixProc;

Package Body PkTbFixProc Is	

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
	
	function to_slv(str : string) return std_logic_vector is
		alias str_norm : string(str'length downto 1) is str;
		variable res_v : std_logic_vector(8 * str'length - 1 downto 0);
	begin
		for idx in str_norm'range loop
			res_v(8 * idx - 1 downto 8 * idx - 8) := std_logic_vector(to_unsigned(character'pos(str_norm(idx)), 8));
		end loop;
		return res_v;
	end function;
	
	function fIntToStringLeading0(a : natural; d : integer range 1 to 9) return string is
		variable vString : string(1 to d);
	begin
		if(a >= 10**d) then
			return integer'image(a);
		else
		for i in 0 to d-1 loop
			vString(d-i to d-i) := integer'image(a/(10**i) mod 10);
		end loop;
		return vString;
		end if;
	end function;
	
	-- converts a integer into an Ascii code.
	Function Ascii2Int(Data: std_logic_vector) Return Integer Is
		variable Temp		: Integer range 0 to 9;
	Begin
		case Data( 7 downto 0 ) is
			when x"39" 	=> Temp := 9;
			when x"38" 	=> Temp := 8;
			when x"37" 	=> Temp := 7;
			when x"36" 	=> Temp := 6;
			when x"35" 	=> Temp := 5;
			when x"34" 	=> Temp := 4;
			when x"33" 	=> Temp := 3;
			when x"32" 	=> Temp := 2;
			when x"31" 	=> Temp := 1;
			when others => Temp := 0;
		end case;
		Return Temp;
    End Function Ascii2Int;
	
	
	------------------------------------------------------------------------
	-- Rx TCP Data Transfer 
	------------------------------------------------------------------------
	Procedure RxTCPDataInit 
	(
		signal	RxDataRec	: out RxTCPDataRecord
	) Is 
	Begin
		RxDataRec.RxTCPValid	<= '0';
		RxDataRec.RxTCPSop		<= '0';
		RxDataRec.RxTCPEop		<= '0';
		RxDataRec.RxTCPData		<= (others=>'0');
	End Procedure RxTCPDataInit;
	
	Procedure RxTCPDataGen 
	(
		variable 	RxDataLength 	: in 	integer;
		variable	RxDataArray		: in  	Pkt_array;
		signal		RxDataRec		: out 	RxTCPDataRecord;
		signal 		Clk				: in	std_logic 
	) Is 
	Begin 
		
		wait until rising_edge(Clk);
		RxDataRec.RxTCPValid   	<= '1';
		RxDataRec.RxTCPSop		<= '1';
		For byte in 0 to RxDataLength-1 loop 
			RxDataRec.RxTCPData		<= RxDataArray(byte);
			if ( byte=RxDataLength-1 ) then 
				RxDataRec.RxTCPEop		<= '1';
			end if;
			wait until rising_edge(Clk);
			RxDataRec.RxTCPEop	<= '0';
			RxDataRec.RxTCPSop	<= '0';
		End loop;
		RxDataRec.RxTCPData		<= (others=>'0');
		RxDataRec.RxTCPValid   	<= '0';
		wait until rising_edge(Clk);
	
	End Procedure RxTCPDataGen; 
	
	------------------------------------------------------------------------
	-- Fix Data Generator 
	------------------------------------------------------------------------
	Procedure FixHdTrBuild 
	(
		variable	HdRecIn				: in	HdRecord; 
		variable  	BodyMsgLength		: in	integer; 
		variable	ErrorOption			: in	integer;
		variable 	MessageLength		: out	integer; 
		variable 	DataMsgArray		: inout Pkt_array
	) Is 
	
	variable 	vFixBodyLength	: integer := 0;
	variable 	vFixHdLength 	: integer := 0;
	variable	vFixCheckSum	: integer range 0 to 255 := 0;
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable 	vFixDataMsgTemp	: Pkt_array; 
	
	Begin 
		-- Header with PossDupFlag  
		vFixBodyLength 	:= 20 + HdRecIn.HdMsgTypeLen + HdRecIn.HdSeqNumLen
							+ HdRecIn.HdSendComIDLen + HdRecIn.HdTarComIDLen
							+ HdRecIn.HdSendTimeLen;
		vFixDataTemp(0 to vFixBodyLength*8-1)	:= to_slv("35=") & to_slv(HdRecIn.HdMsgType(1 to HdRecIn.HdMsgTypeLen)) & cAsciiSOH
							& to_slv("34=") & to_slv(HdRecIn.HdSeqNum(1 to HdRecIn.HdSeqNumLen)) & cAsciiSOH
							& to_slv("49=") & to_slv(HdRecIn.HdSendComID(1 to HdRecIn.HdSendComIDLen)) & cAsciiSOH 
							& to_slv("56=") & to_slv(HdRecIn.HdTarComID(1 to HdRecIn.HdTarComIDLen)) & cAsciiSOH 
							& to_slv("52=") & to_slv(HdRecIn.HdSendTime(1 to HdRecIn.HdSendTimeLen)) & cAsciiSOH;
		For byte in 0 to vFixBodyLength-1 loop
			vFixDataMsgTemp(byte) 		:= vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- If PossDupFlag is set 
		if ( HdRecIn.HdPossDupLen/=0 ) then 
			vFixDataTemp(0 to (4+HdRecIn.HdPossDupLen)*8-1) := to_slv("43=") & to_slv(HdRecIn.HdPossDup(1 to HdRecIn.HdPossDupLen)) & cAsciiSOH;	
			For byte in 0 to (4+HdRecIn.HdPossDupLen)-1 loop
				vFixDataMsgTemp(vFixBodyLength+byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
			End loop;
			vFixBodyLength	:= vFixBodyLength + 4 + HdRecIn.HdPossDupLen;
		end if;
		
		-- Add Body Message 
		if ( BodyMsgLength/=0 ) then 
			For byte in 0 to BodyMsgLength-1 loop
				vFixDataMsgTemp(vFixBodyLength+byte) := DataMsgArray(byte);
			End loop;
			vFixBodyLength	:= vFixBodyLength + BodyMsgLength;
		end if;
		
		-- Writing Bodylength Tag 
		vFixHdLength	:= 6 + HdRecIn.HdBeginStrLen + 5;
		vFixDataMsgTemp( vFixHdLength to vFixHdLength+vFixBodyLength-1 ) := vFixDataMsgTemp(0 to vFixBodyLength-1);
		if ( ErrorOption=1 or ErrorOption=3 ) then	-- Bodylength error generating 
			vFixDataTemp(0 to vFixHdLength*8-1)	:= to_slv("8=") & to_slv(HdRecIn.HdBeginStr(1 to HdRecIn.HdBeginStrLen)) & cAsciiSOH
					& to_slv("9=") & to_slv(fIntToStringLeading0(vFixBodyLength + 1, 5)) & cAsciiSOH;
		else 
			vFixDataTemp(0 to vFixHdLength*8-1)	:= to_slv("8=") & to_slv(HdRecIn.HdBeginStr(1 to HdRecIn.HdBeginStrLen)) & cAsciiSOH
					& to_slv("9=") & to_slv(fIntToStringLeading0(vFixBodyLength, 5)) & cAsciiSOH;
		end if;
		For byte in 0 to vFixHdLength-1 loop
				vFixDataMsgTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;			
		vFixBodyLength	:= vFixBodyLength + vFixHdLength;
		
		-- Writting checksum 
		For i in 0 to vFixBodyLength-1 Loop 
			vFixCheckSum	:= (vFixCheckSum + to_integer(unsigned(vFixDataMsgTemp(i)))) mod 256;
		end loop;		
		if ( ErrorOption=2 or ErrorOption=3 ) then -- Checksum error generating 
			vFixCheckSum	:= (vFixCheckSum + 1) mod 256;
 		end if; 
		vFixDataTemp(0 to 7*8-1)	:= to_slv("10=") & to_slv(fIntToStringLeading0(vFixCheckSum, 3)) & cAsciiSOH;
		For byte in 0 to 7-1 loop
				vFixDataMsgTemp(vFixBodyLength+byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		vFixBodyLength	:= vFixBodyLength + 7;
		
		-- assign output 
		MessageLength	:= vFixBodyLength;
		DataMsgArray	:= vFixDataMsgTemp;
	End Procedure FixHdTrBuild;	
	
	Procedure LogonBuild
	(	
		variable	HdRecIn				: in	HdRecord;
		variable	LogonRecIn			: in	LogonRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is
	
	variable	vMessageLength	: integer;	
	variable	vErrorOption	: integer := 0;		
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;
		
	Begin
		vMessageLength	:= 20 + LogonRecIn.EncryptMetLen + LogonRecIn.HeartBtIntLen
							  + LogonRecIn.RstSeqNumFlagLen + LogonRecIn.AppVerIDLen;
		vFixDataTemp(0 to vMessageLength*8-1)	:=	to_slv("98=") 	& to_slv(LogonRecIn.EncryptMet(1 to LogonRecIn.EncryptMetLen))		& cAsciiSOH &
						to_slv("108=") 		& to_slv(LogonRecIn.HeartBtInt(1 to LogonRecIn.HeartBtIntLen))		& cAsciiSOH &
						to_slv("141=") 		& to_slv(LogonRecIn.RstSeqNumFlag(1 to LogonRecIn.RstSeqNumFlagLen))& cAsciiSOH &
						to_slv("1137=") 	& to_slv(LogonRecIn.AppVerID(1 to LogonRecIn.AppVerIDLen))			& cAsciiSOH;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure LogonBuild; 
	

	-- Heartbeat or TestReq Build (Use this build for Test-request heartbeat only)
	Procedure HB_or_TestReq_Build
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	TestReqID			: in	string;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is
		
	variable	vMessageLength	: integer;		
	variable	vErrorOption	: integer := 0;	
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;
	
	Begin
		vMessageLength	:= 	5 + TestReqID'length;
		vFixDataTemp(0 to vMessageLength*8-1)	:= 	to_slv("112=") & to_slv(TestReqID)	& cAsciiSOH;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure HB_or_TestReq_Build;
	
	-- Empty Field message build (for Logout or Heartbeat in general)
	Procedure EmptyFieldBuild
	(		
		variable	HdRecIn			: in	HdRecord;
		variable 	ErrorOption		: in	integer;
		variable	MessageLength	: out	integer; 
		variable	DataMsgArray	: out 	Pkt_array
	) Is
	
	variable	vMessageLength	: integer := 0;		
	variable	vDataArrayTemp	: Pkt_array;
	
	Begin
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, ErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure EmptyFieldBuild;

	Procedure ReSentReqBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	ResentRecIn			: in	ResentReqRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is
	
	variable	vMessageLength	: integer;		
	variable	vErrorOption	: integer := 0;	
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;
		
	Begin
		vMessageLength	:= 	7 + ResentRecIn.BeginSeqNumLen + ResentRecIn.EndSeqNumLen;
		vFixDataTemp(0 to vMessageLength*8-1)	:= 	to_slv("7=") & to_slv(ResentRecIn.BeginSeqNum(1 to ResentRecIn.BeginSeqNumLen)) & cAsciiSOH
							& to_slv("16=") & to_slv(ResentRecIn.EndSeqNum(1 to ResentRecIn.EndSeqNumLen)) & cAsciiSOH;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;

		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure ReSentReqBuild;
	
	Procedure RejectBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	RejectRecIn			: in	RejectRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is

	variable	vMessageLength	: integer;		
	variable	vErrorOption	: integer := 0;	
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;

	Begin
		vMessageLength	:= 	19 + RejectRecIn.RefSeqNumLen + RejectRecIn.RefTagIDLen
							+ RejectRecIn.RefMsgTypeLen + RejectRecIn.ReajectReaonLen;
		vFixDataTemp(0 to vMessageLength*8-1)	:= 	to_slv("45=") & to_slv(RejectRecIn.RefSeqNum(1 to RejectRecIn.RefSeqNumLen)) & cAsciiSOH
							& to_slv("371=") & to_slv(RejectRecIn.RefTagID(1 to RejectRecIn.RefTagIDLen)) & cAsciiSOH
							& to_slv("372=") & to_slv(RejectRecIn.RefMsgType(1 to RejectRecIn.RefMsgTypeLen)) & cAsciiSOH
							& to_slv("373=") & to_slv(RejectRecIn.ReajectReaon(1 to RejectRecIn.ReajectReaonLen)) & cAsciiSOH;
		if ( RejectRecIn.EncodedTextLen/=0 ) then
			vFixDataTemp(vMessageLength*8 to (vMessageLength+5+RejectRecIn.EncodedTextLen)*8-1) := to_slv("355=") & to_slv(RejectRecIn.EncodedText(1 to RejectRecIn.EncodedTextLen)) & cAsciiSOH;
			vMessageLength	:= vMessageLength + 5 + RejectRecIn.EncodedTextLen;
		end if;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure RejectBuild;
	
	Procedure SeqRstBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	SeqRstRecIn			: in	SeqRstRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is
		
	variable	vMessageLength	: integer;		
	variable	vErrorOption	: integer := 0;	
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;

	Begin
		vMessageLength	:= 	9 + SeqRstRecIn.GapFillFlagLen + SeqRstRecIn.NewSeqNumLen;
		vFixDataTemp(0 to vMessageLength*8-1)	:= 	to_slv("123=") & to_slv(SeqRstRecIn.GapFillFlag(1 to SeqRstRecIn.GapFillFlagLen)) & cAsciiSOH
							& to_slv("36=") & to_slv(SeqRstRecIn.NewSeqNum(1 to SeqRstRecIn.NewSeqNumLen)) & cAsciiSOH;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure SeqRstBuild;
	
	Procedure SnapShotBuild
	(		
		variable	HdRecIn				: in	HdRecord;
		variable	SnapShotFullRecIn	: in	SnapShotFullRecord;
		variable	MessageLength		: out	integer; 
		variable	DataMsgArray		: out 	Pkt_array
	) Is
	
	variable	vMessageLength	: integer;		
	variable	vErrorOption	: integer := 0;	
	variable	vFixDataTemp	: std_logic_vector( 0 to 1375 );
	variable	vDataArrayTemp	: Pkt_array;
	
	Begin
		vMessageLength	:= 	62 + SnapShotFullRecIn.MDReqIDLen + SnapShotFullRecIn.SymbolLen
							+ SnapShotFullRecIn.SecIDLen + SnapShotFullRecIn.SecIDSrcLen
							+ SnapShotFullRecIn.NoEntriesLen + SnapShotFullRecIn.EntryType0Len
							+ SnapShotFullRecIn.Price0Len + SnapShotFullRecIn.Size0Len
							+ SnapShotFullRecIn.EntryTime0Len + SnapShotFullRecIn.EntryType1Len
							+ SnapShotFullRecIn.Price1Len + SnapShotFullRecIn.Size1Len
							+ SnapShotFullRecIn.EntryTime1Len;
		vFixDataTemp(0 to vMessageLength*8-1)	:= 	to_slv("262=") & to_slv(SnapShotFullRecIn.MDReqID(1 to SnapShotFullRecIn.MDReqIDLen)) & cAsciiSOH
							& to_slv("55=") & to_slv(SnapShotFullRecIn.Symbol(1 to SnapShotFullRecIn.SymbolLen)) & cAsciiSOH
							& to_slv("48=") & to_slv(SnapShotFullRecIn.SecID(1 to SnapShotFullRecIn.SecIDLen)) & cAsciiSOH
							& to_slv("22=") & to_slv(SnapShotFullRecIn.SecIDSrc(1 to SnapShotFullRecIn.SecIDSrcLen)) & cAsciiSOH
							& to_slv("268=") & to_slv(SnapShotFullRecIn.NoEntries(1 to SnapShotFullRecIn.NoEntriesLen)) & cAsciiSOH
							& to_slv("269=") & to_slv(SnapShotFullRecIn.EntryType0(1 to SnapShotFullRecIn.EntryType0Len)) & cAsciiSOH
							& to_slv("270=") & to_slv(SnapShotFullRecIn.Price0(1 to SnapShotFullRecIn.Price0Len)) & cAsciiSOH
							& to_slv("271=") & to_slv(SnapShotFullRecIn.Size0(1 to SnapShotFullRecIn.Size0Len)) & cAsciiSOH
							& to_slv("273=") & to_slv(SnapShotFullRecIn.EntryTime0(1 to SnapShotFullRecIn.EntryTime0Len)) & cAsciiSOH
							& to_slv("269=") & to_slv(SnapShotFullRecIn.EntryType1(1 to SnapShotFullRecIn.EntryType1Len)) & cAsciiSOH
							& to_slv("270=") & to_slv(SnapShotFullRecIn.Price1(1 to SnapShotFullRecIn.Price1Len)) & cAsciiSOH
							& to_slv("271=") & to_slv(SnapShotFullRecIn.Size1(1 to SnapShotFullRecIn.Size1Len)) & cAsciiSOH
							& to_slv("273=") & to_slv(SnapShotFullRecIn.EntryTime1(1 to SnapShotFullRecIn.EntryTime1Len)) & cAsciiSOH;
		For byte in 0 to vMessageLength-1 loop
				vDataArrayTemp(byte) := vFixDataTemp( (8*byte) to (8*(byte+1))-1 );
		End loop;
		
		-- Build Header and trailer
		FixHdTrBuild(HdRecIn, vMessageLength, vErrorOption, MessageLength, vDataArrayTemp);
		DataMsgArray	:= vDataArrayTemp;
	End Procedure SnapShotBuild;
	
	------------------------------------------------------------------------
	-- TxFix Dataout verifying 
	------------------------------------------------------------------------
	Procedure FixOutDataVerify 
	(
		signal			FixOutDataRec		: in	FixOutDataRecord;
		variable		ExpMsgType			: in	std_logic_vector(7 downto 0);
		signal 			Clk					: std_logic 
	) Is
	variable	vMsgLength			: integer := 0;
	variable 	vMsgTypeVal			: std_logic;
	variable	vMsgType			: std_logic_vector( 7 downto 0 );
	variable	vBodyLength			: integer := 0;
	variable	vBodyLengthEn		: std_logic_vector( 1 downto 0 ) := "00";
	variable	vChecksumInt	 	: integer := 0;
	variable	vChecksumEn			: std_logic_vector( 1 downto 0 ) := "01";
	variable	vChecksumData	 	: std_logic_vector( 7 downto 0 ) := (others=>'0');
	variable	vDataTag	 		: std_logic_vector(31 downto 0 ) := (others=>'0');
	Begin
		
		wait until rising_edge(Clk) and FixOutDataRec.FixOutDataVal='1' 
		and FixOutDataRec.FixOutDataSop='1';
		
		vMsgLength	:= conv_integer(FixOutDataRec.FixOutDataLen);
		
		L1 : Loop 
			if (FixOutDataRec.FixOutDataVal='1') then 
				vMsgLength 			:= vMsgLength - 1;	-- FIX whole message length (must be 0)
				vDataTag			:= vDataTag(23 downto 0 )&FixOutDataRec.FixOutData; -- Detect 35 and 10 tag
				
				-- bodylength Data
				if ( FixOutDataRec.FixOutData/=x"01" and vBodyLengthEn(0)='1' ) then 
					vBodyLength		:= vBodyLength*10 + Ascii2Int(FixOutDataRec.FixOutData);
				-- When running through body message 
				elsif ( vBodyLengthEn(1)='1' ) then 
					vBodyLength 	:= vBodyLength - 1; --(must be 0)
				end if;
				
				-- Last tag 10: Checksum 
				if ( FixOutDataRec.FixOutData/=x"01" and vChecksumEn(1)='1' ) then 
					vChecksumInt	:= vChecksumInt*10 + Ascii2Int(FixOutDataRec.FixOutData);
				end if;
				
				-- Checksum out data 
				if ( vChecksumEn(0)='1' or vBodyLengthEn(1)='1' ) then 
					vChecksumData 	:= vChecksumData + FixOutDataRec.FixOutData;
				end if;
			
				if ( vBodyLengthEn(1)='1' ) then 
					vChecksumEn(0)	:= '0';
				end if; 
				
				if ( vMsgTypeVal='1' ) then 
					vMsgType	:= FixOutDataRec.FixOutData;
				end if; 
				
				-- Bodylength process 
				if ( FixOutDataRec.FixOutData=x"01" and vBodyLengthEn(0)='1' ) then  -- SOH
					vBodyLengthEn(1)	:= '1'; 
				-- End of body message 
				elsif ( vBodyLength=0 and vBodyLengthEn(1)='1' ) then 
					vBodyLengthEn(1)	:= '0';
				else 
					vBodyLengthEn(1)	:= vBodyLengthEn(1);
				end if; 
				if ( vDataTag(23 downto 0)=x"01393D" ) then  -- SOH 9 = 
					vBodyLengthEn(0)	:= '1';
				elsif ( FixOutDataRec.FixOutData=x"01" ) then 
					vBodyLengthEn(0)	:= '0';
				else 
					vBodyLengthEn(0)	:= vBodyLengthEn(0); 
				end if; 
				
				if ( vDataTag=x"0133353D" ) then -- SOH 3 5 = 
					vMsgTypeVal	:=	'1';
				else
					vMsgTypeVal	:=	'0';
				end if;
				
				-- Checksum process 
				if ( vDataTag=x"0131303D" ) then  -- SOH 1 0 = 
					vChecksumEn(1)		:= '1';
				end if; 
			end if; 
			
			exit L1 when FixOutDataRec.FixOutDataVal='1' and FixOutDataRec.FixOutDataEop='1';
			wait until FixOutDataRec.FixOutDataVal='1' and rising_edge(Clk);
		End Loop;
		
		-- Assert error 
		Assert (vBodyLength=0) 
		Report "ERROR Bodylength Invalid: " & integer'image(vBodyLength)
		Severity Failure;
		
		Assert (vMsgLength=0) 
		Report "ERROR Messagelength Invalid: " & integer'image(vMsgLength)
		Severity Failure;
		
		Assert (vMsgType=ExpMsgType) 
		Report "ERROR MessageType Invalid: " & character'val(to_integer(unsigned(vMsgType)))
		Severity Failure; 
		
		Assert (std_logic_vector(to_unsigned(vChecksumInt, vChecksumData'length))=vChecksumData) 
		Report "ERROR Checksum. Verify value= " & integer'image(conv_integer(vChecksumData))
		& " Message content value= " & integer'image(vChecksumInt)
		Severity Failure;
		
	End Procedure FixOutDataVerify;
	
End Package Body PkTbFixProc;
