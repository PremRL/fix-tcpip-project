----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbFixCtrl.vhd
-- Title        Package for FixCtrl
-- 
-- Author       L.Ratchanon
-- Date         2021/03/07
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note 
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

Package PkTbFixCtrl Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
------------------------------------------------------------------------
-- Array type declaration
------------------------------------------------------------------------
	

	Type PktRx2CtrlRecord Is Record
		Rx2CtrlSeqNum			    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlMsgTypeVal		    : std_logic_vector( 7 downto 0 ); 
		Rx2CtrlSeqNumError		    : std_logic;   
		Rx2CtrlPossDupFlag		    : std_logic;   
		Rx2CtrlMsgTimeYear		    : std_logic_vector(10 downto 0 ); 
		Rx2CtrlMsgTimeMonth		    : std_logic_vector( 3 downto 0 ); 
		Rx2CtrlMsgTimeDay		    : std_logic_vector( 4 downto 0 ); 
		Rx2CtrlMsgTimeHour		    : std_logic_vector( 4 downto 0 ); 
		Rx2CtrlMsgTimeMin		    : std_logic_vector( 5 downto 0 ); 
		Rx2CtrlMsgTimeSec		    : std_logic_vector(15 downto 0 ); 
		Rx2CtrlMsgTimeSecNegExp	    : std_logic_vector( 1 downto 0 ); 
		Rx2CtrlTagErrorFlag		    : std_logic;   
		Rx2CtrlErrorTagLatch	    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlErrorTagLen		    : std_logic_vector( 5 downto 0 ); 
		Rx2CtrlBodyLenError		    : std_logic;   
		Rx2CtrlCsumError		    : std_logic;       
		Rx2CtrlEncryptMetError	    : std_logic;   
		Rx2CtrlAppVerIdError	    : std_logic;       
		Rx2CtrlHeartBtInt		    : std_logic_vector( 7 downto 0 ); 
		Rx2CtrlResetSeqNumFlag	    : std_logic;   
		Rx2CtrlTestReqId		    : std_logic_vector(63 downto 0 ); 
		Rx2CtrlTestReqIdLen		    : std_logic_vector( 5 downto 0 ); 
		Rx2CtrlTestReqIdVal		    : std_logic; 
		Rx2CtrlBeginSeqNum		    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlEndSeqNum		    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlRefSeqNum		    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlRefTagId			    : std_logic_vector(15 downto 0 ); 
		Rx2CtrlRefMsgType		    : std_logic_vector( 7 downto 0 ); 
		Rx2CtrlRejectReason		    : std_logic_vector( 2 downto 0 ); 
		Rx2CtrlGapFillFlag		    : std_logic;   
		Rx2CtrlNewSeqNum		    : std_logic_vector(31 downto 0 ); 
		Rx2CtrlMDReqId			    : std_logic_vector(15 downto 0 ); 
		Rx2CtrlMDReqIdLen			: std_logic_vector( 5 downto 0 ); 
	End Record PktRx2CtrlRecord;
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	
----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------
	
	-------------------------------------
	-- Procedure of Rx data Initialization   
	Procedure DataGenInitial
	(
		signal		DataGenRec		: out	PktRx2CtrlRecord
	);
	
End Package PkTbFixCtrl;		

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package Body

Package Body PkTbFixCtrl Is

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
	-- Initialize DataGen 
	Procedure DataGenInitial
	(
		signal		DataGenRec		: out	PktRx2CtrlRecord
	) Is
	Begin
		DataGenRec.Rx2CtrlSeqNum			    <= (others=>'0');
		DataGenRec.Rx2CtrlMsgTypeVal		    <= (others=>'0');
		DataGenRec.Rx2CtrlSeqNumError		    <= '0';
		DataGenRec.Rx2CtrlPossDupFlag		    <= '0';
		DataGenRec.Rx2CtrlMsgTimeYear		    <= conv_std_logic_vector(2021, 11);
		DataGenRec.Rx2CtrlMsgTimeMonth		    <= conv_std_logic_vector(3, 4);
		DataGenRec.Rx2CtrlMsgTimeDay		    <= conv_std_logic_vector(31, 5);
		DataGenRec.Rx2CtrlMsgTimeHour		    <= conv_std_logic_vector(12, 5);
		DataGenRec.Rx2CtrlMsgTimeMin		    <= conv_std_logic_vector(52, 6);
		DataGenRec.Rx2CtrlMsgTimeSec		    <= conv_std_logic_vector(12345, 16);
		DataGenRec.Rx2CtrlMsgTimeSecNegExp	    <= "11"; -- -3 
		DataGenRec.Rx2CtrlTagErrorFlag		    <= '0';
		DataGenRec.Rx2CtrlErrorTagLatch	        <= (others=>'0');    
		DataGenRec.Rx2CtrlErrorTagLen		    <= (others=>'0');
		DataGenRec.Rx2CtrlBodyLenError		    <= '0';
		DataGenRec.Rx2CtrlCsumError		        <= '0';    
		DataGenRec.Rx2CtrlEncryptMetError	    <= '0';
		DataGenRec.Rx2CtrlAppVerIdError	        <= '0';   
		DataGenRec.Rx2CtrlHeartBtInt		    <= (others=>'0');
		DataGenRec.Rx2CtrlResetSeqNumFlag	    <= '0';
		DataGenRec.Rx2CtrlTestReqId		        <= (others=>'0');    
		DataGenRec.Rx2CtrlTestReqIdLen		    <= (others=>'0');
		DataGenRec.Rx2CtrlTestReqIdVal		    <= '0';
		DataGenRec.Rx2CtrlBeginSeqNum		    <= (others=>'0');
		DataGenRec.Rx2CtrlEndSeqNum		        <= (others=>'0');    
		DataGenRec.Rx2CtrlRefSeqNum		        <= (others=>'0');    
		DataGenRec.Rx2CtrlRefTagId			    <= (others=>'0');
		DataGenRec.Rx2CtrlRefMsgType		    <= (others=>'0');
		DataGenRec.Rx2CtrlRejectReason		    <= (others=>'0');
		DataGenRec.Rx2CtrlGapFillFlag		    <= '0';
		DataGenRec.Rx2CtrlNewSeqNum		        <= (others=>'0');    
		DataGenRec.Rx2CtrlMDReqId			    <= (others=>'0');
		DataGenRec.Rx2CtrlMDReqIdLen			<= (others=>'0');
	End Procedure DataGenInitial;
	
End Package Body PkTbFixCtrl;