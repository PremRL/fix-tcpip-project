----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbAscii2Bin.vhd
-- Title        Package for TbAscii2Bin
-- 
-- Author       L.Ratchanon
-- Date         2021/01/23
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

Package PkTbAscii2Bin Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

-------------------------------------
	
	Type AsciiDataGenRecord Is Record
		AsciiDataGenVal : std_logic;
		AsciiDataGenSop : std_logic;
		AsciiDataGenEop : std_logic;
		AsciiDataGen	: std_logic_vector( 7 downto 0 );
	End Record AsciiDataGenRecord;
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	function to_slv(str: string) return std_logic_vector; 
	Function int2Ascii(IntData: Integer) Return std_logic_vector;

----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------
	
	-------------------------------------
	-- Procedure of upper layer data Initialization   
	Procedure AsciiDataGenInitial
	(
		signal		AsciiDataGenRec		: out	AsciiDataGenRecord
	);
	
	-------------------------------------
	-- Procedure of TCP Server data generator 
	Procedure AsciiDataGen 
	(
		signal		AsciiDataGenRec		: out	AsciiDataGenRecord;
		variable 	vDataValue			: string;
		signal 		Clk					: std_logic 
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
	
	-------------------------------------
	-- Data Initialization 
	Procedure AsciiDataGenInitial
	(
		signal		AsciiDataGenRec		: out	AsciiDataGenRecord
	) Is
	Begin
		AsciiDataGenRec.AsciiDataGenVal   <= '0';
		AsciiDataGenRec.AsciiDataGenSop   <= '0';
		AsciiDataGenRec.AsciiDataGenEop   <= '0';
		AsciiDataGenRec.AsciiDataGen	  <= (others=>'0');
	End Procedure AsciiDataGenInitial;
	
	-------------------------------------
	-- Data Genarator 
	Procedure AsciiDataGen 
	(
		signal		AsciiDataGenRec		: out	AsciiDataGenRecord;
		variable 	vDataValue			: string;
		signal 		Clk					: std_logic 
	) Is
	variable	vLength			: integer := vDataValue'length;
	variable	vDataOut	 	: std_logic_vector(8*vLength - 1 downto 0);
	Begin
		-- Gen Data 
		vDataOut(8*vLength - 1 downto 0) 	:= to_slv(vDataValue);
		
		wait until rising_edge(Clk);
		AsciiDataGenRec.AsciiDataGenVal   	<= '1';
		AsciiDataGenRec.AsciiDataGenSop		<= '1';
		For i in (vLength-1) downto 0 loop 
			AsciiDataGenRec.AsciiDataGen		<= vDataOut(8*(i+1)-1 downto 8*i);
			wait until rising_edge(Clk);
			AsciiDataGenRec.AsciiDataGenSop	<= '0';
		End loop;
		AsciiDataGenRec.AsciiDataGen		<= (others=>'0');
		AsciiDataGenRec.AsciiDataGenVal   	<= '0';
		wait until rising_edge(Clk);

	End Procedure AsciiDataGen;
	
End Package Body PkTbAscii2Bin;