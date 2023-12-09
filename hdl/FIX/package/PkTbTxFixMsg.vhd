----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbTxFixMsg.vhd
-- Title        Package for TbTxFixMsg
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
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
use ieee.numeric_std.all;
use IEEE.MATH_REAL.all;
use STD.TEXTIO.all;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package

Package PkTbTxFixMsg Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

-------------------------------------
	
	Type FixOutDataRecord Is Record
		FixOutDataVal		: std_logic;
		FixOutDataSop		: std_logic;
		FixOutDataEop		: std_logic;
		FixOutData			: std_logic_vector( 7 downto 0 );
		FixOutDataLen		: std_logic_vector(15 downto 0 );
	End Record FixOutDataRecord;
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	function to_slv(str: string) return std_logic_vector; 
	Function Ascii2Int(Data: std_logic_vector) Return Integer;

----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------
	
	-------------------------------------
	-- Procedure of Fix Data Verification  
	Procedure FixOutDataVerify 
	(
		signal		FixOutDataRec		: in	FixOutDataRecord;
		signal 		Clk					: std_logic 
	);
	
End Package PkTbTxFixMsg;		

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package Body

Package Body PkTbTxFixMsg Is

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
	
	-------------------------------------
	-- Data out verifying 
	Procedure FixOutDataVerify 
	(
		signal		FixOutDataRec		: in	FixOutDataRecord;
		signal 		Clk					: std_logic 
	) Is
	variable	vMsgLength			: integer := 0;
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
		
		Assert (conv_std_logic_vector(vChecksumInt, vChecksumData'length)=vChecksumData) 
		Report "ERROR Checksum. Verify value= " & integer'image(conv_integer(vChecksumData))
		& " Message content value= " & integer'image(vChecksumInt)
		Severity Failure;
		
	End Procedure FixOutDataVerify;
	
End Package Body PkTbTxFixMsg;