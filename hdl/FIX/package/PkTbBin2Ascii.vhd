----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbBin2Ascii.vhd
-- Title        Package for PkTbBin2Ascii
-- 
-- Author       L.Ratchanon
-- Date        	2021/01/23
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note 
--
-- AutoVerify 
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

Package PkTbAscii2Bin Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

-------------------------------------
	
	Type AsciiDataInRecord Is Record
		AsciiDataInVal : std_logic;
		AsciiDataInEop : std_logic;
		AsciiDataIn	   : std_logic_vector( 7 downto 0 );
	End Record AsciiDataInRecord;
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	function to_slv(str: string) return std_logic_vector; 
	Function int2Ascii(IntData: Integer) Return std_logic_vector;
	Function Ascii2Int(Data: std_logic_vector) Return Integer;
	
----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------
	
	-------------------------------------
	-- Procedure of TCP Server data generator 
	Procedure VerifyIntAscii 
	(
		signal		AsciiDataInRec		: In	AsciiDataInRecord;
		signal	 	rDataValue			: In 	std_logic_vector(26 downto 0 );
		signal      rDataNegExp 		: In 	std_logic_vector( 2 downto 0 )
	);
	
End Package PkTbAscii2Bin;		

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package Body

Package Body PkTbAscii2Bin Is

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
	Function int2Ascii(IntData: Integer) Return std_logic_vector Is
		variable Temp		: std_logic_vector(7 downto 0);
	Begin
		case IntData is
			when 9 		=> Temp := x"39";
			when 8 		=> Temp := x"38";
			when 7 		=> Temp := x"37";
			when 6 		=> Temp := x"36";
			when 5 		=> Temp := x"35";
			when 4 		=> Temp := x"34";
			when 3 		=> Temp := x"33";
			when 2 		=> Temp := x"32";
			when 1 		=> Temp := x"31";
			when others => Temp := x"30";
		end case;
		Return Temp;
    End Function int2Ascii;
	
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
	
	-- Data Genarator 
	Procedure VerifyIntAscii 
	(
		signal		AsciiDataInRec		: In	AsciiDataInRecord;
		signal	 	rDataValue			: In	std_logic_vector(26 downto 0 );
		signal      rDataNegExp 		: In	std_logic_vector( 2 downto 0 )
	) Is
		variable	vDataInteger	: Integer range 0 to 134217727 := 0;
		variable	vDataNegExp	 	: std_logic_vector( 2 downto 0 ) := "000";
		variable 	vNegExpCntEn	: std_logic := '0';
		variable    tClk			: time 		:= 10 ns;
	Begin
	
		wait until AsciiDataInRec.AsciiDataInVal='1';
		wait for 0.5*tClk;
		L1 : Loop 
			if ( vNegExpCntEn='1' ) then 
				vDataNegExp		:= vDataNegExp + 1;
			end if;
			
			if ( AsciiDataInRec.AsciiDataIn/=x"2E" ) then 
				vDataInteger	:= vDataInteger*10 + Ascii2Int(AsciiDataInRec.AsciiDataIn);
			else 
				vNegExpCntEn	:= '1';
			end if;

			exit L1 when AsciiDataInRec.AsciiDataInEop='1';
			wait for tClk; 
		End Loop; 
		-- Assert error 
		Assert (vDataNegExp(2 downto 0)=rDataNegExp) 
		Report "ERROR Negative Exponention Invalid"
		Severity Failure;
		
		Assert (conv_std_logic_vector(vDataInteger, rDataValue'length)=rDataValue) 
		Report "ERROR Integer data Invalid=" & integer'image(vDataInteger)
		Severity Failure;
		
	End Procedure VerifyIntAscii;
	
End Package Body PkTbAscii2Bin;