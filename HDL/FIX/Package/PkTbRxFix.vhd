----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkTbRxFix.vhd
-- Title        Package for TbRxFix
-- 
-- Author       K. Norawit
-- Date         2021/02/20
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note 
--
-- AutoVerify : Support iff message has checksum field.
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;
use work.PkSigTbRxFix.all;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package

Package PkTbRxFix Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant	t_Clk				: time 	  := 10 ns;
	
	constant	c_MsgTypeHeartBt	: std_logic_vector( 7 downto 0 )	:= "00000001";
	constant	c_MsgTypeTestReq	: std_logic_vector( 7 downto 0 )	:= "00000010";
	constant	c_MsgTypeResendReq	: std_logic_vector( 7 downto 0 )	:= "00000100";
	constant	c_MsgTypeReject		: std_logic_vector( 7 downto 0 )	:= "00001000";
	constant	c_MsgTypeSeqRst		: std_logic_vector( 7 downto 0 )	:= "00010000";
	constant	c_MsgTypeLogOut		: std_logic_vector( 7 downto 0 )	:= "00100000";
	constant	c_MsgTypeLogOn		: std_logic_vector( 7 downto 0 )	:= "01000000";
	constant	c_MsgTypeSnapShot	: std_logic_vector( 7 downto 0 )	:= "10000000";
	
----------------------------------------------------------------------------------
-- Function declaration																
----------------------------------------------------------------------------------
	
	Function hstr(slv: std_logic_vector) Return string;
	
----------------------------------------------------------------------------------
-- Procedure declaration
----------------------------------------------------------------------------------

	-------------------------------------
	-- Procedure of Verify
	Procedure Verify_LogOn
	(
		signal 	Clk				: in 	std_logic;
		signal  ExpHdDecRec		: OutHdDecRecord;
		signal  ExpLogOnRec		: OutLogOnRecord;
		signal  OutHdDecRec		: OutHdDecRecord;
		signal  OutLogOnRec		: OutLogOnRecord
	);
	
	Procedure Verify_Empty
	(
		signal 	Clk				: in 	std_logic;
		signal  ExpHdDecRec		: OutHdDecRecord;
		signal  OutHdDecRec		: OutHdDecRecord
	);
	
	Procedure Verify_TestReqId
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpTestReqIdRec		: OutTestReqIdRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutTestReqIdRec		: OutTestReqIdRecord
	);
	
	Procedure Verify_ResendReq
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpResentReqRec		: OutResentReqRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutResentReqRec		: OutResentReqRecord
	);
	
	Procedure Verify_Reject
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpRejectRec		: OutRejectRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutRejectRec		: OutRejectRecord
	);
	
	Procedure Verify_SeqRst
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpSeqRstRec		: OutSeqRstRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutSeqRstRec		: OutSeqRstRecord
	);
	
	Procedure Verify_SnapShot
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpSnapShotRec		: OutSnapShotRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutSnapShotRec		: OutSnapShotRecord
	);
	
End Package PkTbRxFix;		

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Package Body

Package Body PkTbRxFix Is

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

	--------------------------------------------
	-- Auto verify LogOn
	--------------------------------------------
	Procedure Verify_LogOn
	(
		signal 	Clk				: in 	std_logic;
		signal  ExpHdDecRec		: OutHdDecRecord;
		signal  ExpLogOnRec		: OutLogOnRecord;
		signal  OutHdDecRec		: OutHdDecRecord;
		signal  OutLogOnRec		: OutLogOnRecord
		
	) Is
		
	Begin
		
		
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
		
			-----------------------------
			-- Logon field check
			-----------------------------
				Assert (ExpHdDecRec.MsgVal2User=OutHdDecRec.MsgVal2User) 
				Report 	"ERROR MsgVal2User :Exp is: "&hstr(ExpHdDecRec.MsgVal2User)&
						"Outcome is: "&hstr(OutHdDecRec.MsgVal2User)
				Severity Failure;
				
				Assert (ExpLogOnRec.HeartBtInt=OutLogOnRec.HeartBtInt) 
				Report 	"ERROR HeartBtInt :Exp is: "&hstr(ExpLogOnRec.HeartBtInt)&
						"Outcome is: "&hstr(OutLogOnRec.HeartBtInt)
				Severity Failure;
				
				Assert (ExpLogOnRec.ResetSeqNumFlag=OutLogOnRec.ResetSeqNumFlag) 
				Report 	"ERROR ResetSeqNumFlag"
				Severity Failure;
				
				Assert (ExpLogOnRec.EncryptMetError=OutLogOnRec.EncryptMetError) 
				Report 	"ERROR EncryptMetError"
				Severity Failure;
				
				Assert (ExpLogOnRec.AppVerIdError=OutLogOnRec.AppVerIdError) 
				Report 	"ERROR AppVerIdError"
				Severity Failure;
			end if;
			
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;	
		
	End Procedure Verify_LogOn;
	
	--------------------------------------------
	-- Auto verify Empty field message
	--------------------------------------------
	Procedure Verify_Empty
	(
		signal 	Clk				: in 	std_logic;
		signal  ExpHdDecRec		: OutHdDecRecord;
		signal  OutHdDecRec		: OutHdDecRecord
		
	) Is
	
	Begin
		
		
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			end if;
		
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;
		
	End Procedure Verify_Empty;
	
	--------------------------------------------
	-- Auto verify message with TestReqId
	--------------------------------------------
	Procedure Verify_TestReqId
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpTestReqIdRec		: OutTestReqIdRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutTestReqIdRec		: OutTestReqIdRecord
		
	) Is
	
	Begin
			
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			
			-----------------------------
			-- TestReqId field check
			-----------------------------
			
				Assert (ExpTestReqIdRec.TestReqIdVal=OutTestReqIdRec.TestReqIdVal) 
				Report 	"ERROR TestReqIdVal"
				Severity Failure;
				
				if ( OutTestReqIdRec.TestReqIdVal='1' ) then
					Assert (ExpTestReqIdRec.TestReqId=OutTestReqIdRec.TestReqId) 
					Report 	"ERROR TestReqId :Exp is: "&hstr(ExpTestReqIdRec.TestReqId)&
							"Outcome is: "&hstr(OutTestReqIdRec.TestReqId)
					Severity Failure;
					
					Assert (ExpTestReqIdRec.TestReqIdLen=OutTestReqIdRec.TestReqIdLen) 
					Report 	"ERROR TestReqIdLen :Exp is: "&hstr(ExpTestReqIdRec.TestReqIdLen)&
							"Outcome is: "&hstr(OutTestReqIdRec.TestReqIdLen)
					Severity Failure;
				end if;
			end if;
			
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;
		
	End Procedure Verify_TestReqId;
	
	--------------------------------------------
	-- Auto verify Resend Request
	--------------------------------------------
	Procedure Verify_ResendReq
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpResentReqRec		: OutResentReqRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutResentReqRec		: OutResentReqRecord
	) Is
	
	Begin
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			
			-----------------------------
			-- Resend Request field check
			-----------------------------
				Assert (ExpHdDecRec.MsgVal2User=OutHdDecRec.MsgVal2User) 
				Report 	"ERROR MsgVal2User :Exp is: "&hstr(ExpHdDecRec.MsgVal2User)&
						"Outcome is: "&hstr(OutHdDecRec.MsgVal2User)
				Severity Failure;
				
				Assert (ExpResentReqRec.BeginSeqNum=OutResentReqRec.BeginSeqNum) 
				Report 	"ERROR BeginSeqNum :Exp is: "&hstr(ExpResentReqRec.BeginSeqNum)&
						"Outcome is: "&hstr(OutResentReqRec.BeginSeqNum)
				Severity Failure;
				
				Assert (ExpResentReqRec.EndSeqNum=OutResentReqRec.EndSeqNum) 
				Report 	"ERROR EndSeqNum :Exp is: "&hstr(ExpResentReqRec.EndSeqNum)&
						"Outcome is: "&hstr(OutResentReqRec.EndSeqNum)
				Severity Failure;
			end if;
			
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;
		
	End Procedure Verify_ResendReq;
	
	--------------------------------------------
	-- Auto verify Reject
	--------------------------------------------
	Procedure Verify_Reject
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpRejectRec		: OutRejectRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutRejectRec		: OutRejectRecord
		
	) Is
	
	Begin
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			
			-----------------------------
			-- Reject field check
			-----------------------------
				Assert (ExpHdDecRec.MsgVal2User=OutHdDecRec.MsgVal2User) 
				Report 	"ERROR MsgVal2User :Exp is: "&hstr(ExpHdDecRec.MsgVal2User)&
						"Outcome is: "&hstr(OutHdDecRec.MsgVal2User)
				Severity Failure;
			
				Assert (ExpRejectRec.RefSeqNum=OutRejectRec.RefSeqNum) 
				Report 	"ERROR RefSeqNum :Exp is: "&hstr(ExpRejectRec.RefSeqNum)&
						"Outcome is: "&hstr(OutRejectRec.RefSeqNum)
				Severity Failure;
			
				Assert (ExpRejectRec.RefTagId=OutRejectRec.RefTagId) 
				Report 	"ERROR RefTagId :Exp is: "&hstr(ExpRejectRec.RefTagId)&
						"Outcome is: "&hstr(OutRejectRec.RefTagId)
				Severity Failure;
				
				Assert (ExpRejectRec.RefMsgType=OutRejectRec.RefMsgType) 
				Report 	"ERROR RefMsgType :Exp is: "&hstr(ExpRejectRec.RefMsgType)&
						"Outcome is: "&hstr(OutRejectRec.RefMsgType)
				Severity Failure;
				
				Assert (ExpRejectRec.RejectReason=OutRejectRec.RejectReason) 
				Report 	"ERROR RejectReason :Exp is: "&hstr(ExpRejectRec.RejectReason)&
						"Outcome is: "&hstr(OutRejectRec.RejectReason)
				Severity Failure;
			end if;
			
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;

	End Procedure Verify_Reject;
	
	--------------------------------------------
	-- Auto verify Sequence Reset
	--------------------------------------------
	Procedure Verify_SeqRst
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpSeqRstRec		: OutSeqRstRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutSeqRstRec		: OutSeqRstRecord
	) Is
	
	Begin
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			
			-----------------------------
			-- Reject field check
			-----------------------------
				Assert (ExpHdDecRec.MsgVal2User=OutHdDecRec.MsgVal2User) 
				Report 	"ERROR MsgVal2User :Exp is: "&hstr(ExpHdDecRec.MsgVal2User)&
						"Outcome is: "&hstr(OutHdDecRec.MsgVal2User)
				Severity Failure;
			
				Assert (ExpSeqRstRec.GapFillFlag=OutSeqRstRec.GapFillFlag) 
				Report 	"ERROR GapFillFlag"
				Severity Failure;
			
				Assert (ExpSeqRstRec.NewSeqNum=OutSeqRstRec.NewSeqNum) 
				Report 	"ERROR NewSeqNum :Exp is: "&hstr(ExpSeqRstRec.NewSeqNum)&
						"Outcome is: "&hstr(OutSeqRstRec.NewSeqNum)
				Severity Failure;
			end if;
			
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;
		
	End Procedure Verify_SeqRst;
	
	--------------------------------------------
	-- Auto verify Snapshot
	--------------------------------------------
	Procedure Verify_SnapShot
	(
		signal 	Clk					: in 	std_logic;
		signal  ExpHdDecRec			: OutHdDecRecord;
		signal  ExpSnapShotRec		: OutSnapShotRecord;
		signal  OutHdDecRec			: OutHdDecRecord;
		signal  OutSnapShotRec		: OutSnapShotRecord
	) Is
	
	Begin
		
		-----------------------------
		-- header check
		-----------------------------
		if ( ExpHdDecRec.MsgTypeVal=OutHdDecRec.MsgTypeVal and OutHdDecRec.MsgTypeVal/=0 ) then
			Report "Msg is accepted";
		
			Assert (ExpHdDecRec.BLenError=OutHdDecRec.BLenError) 
			Report 	"ERROR BodyLenVal"
			Severity Failure;
			
			Assert (ExpHdDecRec.CSumError=OutHdDecRec.CSumError) 
			Report 	"ERROR CSumError"
			Severity Failure;
			
			
			Assert (ExpHdDecRec.TagError=OutHdDecRec.TagError) 
			Report 	"ERROR* TagError(Val)"
			Severity Failure;
			
			if (ExpHdDecRec.TagError='1') then
				Assert (ExpHdDecRec.ErrorTagLatch=OutHdDecRec.ErrorTagLatch) 
				Report 	"ERROR* ErrorTagLatch"
				Severity Failure;	
				
				
				Assert (ExpHdDecRec.ErrorTagLen=OutHdDecRec.ErrorTagLen) 
				Report 	"ERROR* ErrorTagLen : Exp is: "&hstr(ExpHdDecRec.ErrorTagLen)&
						"Outcome is: "&hstr(OutHdDecRec.ErrorTagLen)
				Severity Failure;
			else
			
				Assert (ExpHdDecRec.SeqNumError=OutHdDecRec.SeqNumError) 
				Report 	"ERROR* SeqNumError(Val)"
				Severity Failure;
				
				
				Assert (ExpHdDecRec.SeqNum=OutHdDecRec.SeqNum) 
				Report 	"ERROR* SeqNum : Exp is: "&hstr(ExpHdDecRec.SeqNum)&
						"Outcome is: "&hstr(OutHdDecRec.SeqNum)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.PossDupFlag=OutHdDecRec.PossDupFlag) 
				Report 	"ERROR PossDupFlag :Exp is: "&hstr("000"&ExpHdDecRec.PossDupFlag)&
						"Outcome is: "&hstr("000"&OutHdDecRec.PossDupFlag)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeYear=OutHdDecRec.TimeYear) 
				Report 	"ERROR TimeYear :Exp is: "&hstr(ExpHdDecRec.TimeYear)&
						"Outcome is: "&hstr(OutHdDecRec.TimeYear)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMonth=OutHdDecRec.TimeMonth) 
				Report 	"ERROR TimeMonth :Exp is: "&hstr(ExpHdDecRec.TimeMonth)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMonth)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeDay=OutHdDecRec.TimeDay) 
				Report 	"ERROR TimeDay :Exp is: "&hstr(ExpHdDecRec.TimeDay)&
						"Outcome is: "&hstr(OutHdDecRec.TimeDay)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeMin=OutHdDecRec.TimeMin) 
				Report 	"ERROR TimeMin :Exp is: "&hstr(ExpHdDecRec.TimeMin)&
						"Outcome is: "&hstr(OutHdDecRec.TimeMin)
				Severity Failure;
				
				
				Assert (ExpHdDecRec.TimeSec=OutHdDecRec.TimeSec) 
				Report 	"ERROR TimeSec :Exp is: "&hstr(ExpHdDecRec.TimeSec)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSec)
				Severity Failure;
				
				Assert (ExpHdDecRec.TimeSecNegExp=OutHdDecRec.TimeSecNegExp) 
				Report 	"ERROR TimeSecNegExp :Exp is: "&hstr(ExpHdDecRec.TimeSecNegExp)&
						"Outcome is: "&hstr(OutHdDecRec.TimeSecNegExp)
				Severity Failure;
			
			-----------------------------
			-- Snapshot field check
			-----------------------------
				Assert (ExpHdDecRec.MsgVal2User=OutHdDecRec.MsgVal2User) 
				Report 	"ERROR MsgVal2User :Exp is: "&hstr(ExpHdDecRec.MsgVal2User)&
						"Outcome is: "&hstr(OutHdDecRec.MsgVal2User)
				Severity Failure;
			
				Assert (ExpSnapShotRec.MDReqId=OutSnapShotRec.MDReqId) 
				Report 	"ERROR MDReqId :Exp is: "&hstr(ExpSnapShotRec.MDReqId)&
						"Outcome is: "&hstr(OutSnapShotRec.MDReqId)
				Severity Failure;		
				
				Assert (ExpSnapShotRec.MDReqIdLen=OutSnapShotRec.MDReqIdLen) 
				Report 	"MDReqIdLen:Exp is: "&hstr(ExpSnapShotRec.MDReqIdLen)&
						"Outcome is: "&hstr(OutSnapShotRec.MDReqIdLen)		
				Severity Failure;
		
				Assert (ExpSnapShotRec.SecIndic=OutSnapShotRec.SecIndic) 
				Report 	"ERROR SecIndic :Exp is: "&hstr(ExpSnapShotRec.SecIndic)&
						"Outcome is: "&hstr(OutSnapShotRec.SecIndic)		
				Severity Failure;
		
				if ( ExpSnapShotRec.EntriesVal=OutSnapShotRec.EntriesVal ) then
				
					if (OutSnapShotRec.EntriesVal(0)='1') then
						
						if (OutSnapShotRec.SpecialPxFlag(0)='0') then 
							Assert (ExpSnapShotRec.BidPx=OutSnapShotRec.BidPx) 
							Report 	"ERROR BidPx :Exp is: "&hstr(ExpSnapShotRec.BidPx)&
									"Outcome is: "&hstr(OutSnapShotRec.BidPx)
							Severity Failure;
				
							Assert (ExpSnapShotRec.BidPxNegExp=OutSnapShotRec.BidPxNegExp) 
							Report 	"ERROR BidPxNegExp :Exp is: "&hstr(ExpSnapShotRec.BidPxNegExp)&
									"Outcome is: "&hstr(OutSnapShotRec.BidPxNegExp)		
							Severity Failure;
						end if;
						
						Assert (ExpSnapShotRec.BidSize=OutSnapShotRec.BidSize) 
						Report 	"ERROR BidSize :Exp is: "&hstr(ExpSnapShotRec.BidSize)&
								"Outcome is: "&hstr(OutSnapShotRec.BidSize)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.BidTimeHour=OutSnapShotRec.BidTimeHour) 
						Report 	"ERROR BidTimeHour :Exp is: "&hstr(ExpSnapShotRec.BidTimeHour)&
								"Outcome is: "&hstr(OutSnapShotRec.BidTimeHour)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.BidTimeMin=OutSnapShotRec.BidTimeMin) 
						Report 	"ERROR BidTimeMin :Exp is: "&hstr(ExpSnapShotRec.BidTimeMin)&
								"Outcome is: "&hstr(OutSnapShotRec.BidTimeMin)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.BidTimeSec=OutSnapShotRec.BidTimeSec) 
						Report 	"ERROR BidTimeSec :Exp is: "&hstr(ExpSnapShotRec.BidTimeSec)&
								"Outcome is: "&hstr(OutSnapShotRec.BidTimeSec)	
						Severity Failure;
				
						Assert (ExpSnapShotRec.BidTimeSecNegExp=OutSnapShotRec.BidTimeSecNegExp) 
						Report 	"ERROR BidTimeSecNegExp :Exp is: "&hstr(ExpSnapShotRec.BidTimeSecNegExp)&
								"Outcome is: "&hstr(OutSnapShotRec.BidTimeSecNegExp)		
						Severity Failure;
					end if;
					
					if (OutSnapShotRec.EntriesVal(1)='1') then
						
						if (OutSnapShotRec.SpecialPxFlag(1)='0') then 
							Assert (ExpSnapShotRec.OffPx=OutSnapShotRec.OffPx) 
							Report 	"ERROR OffPx :Exp is: "&hstr(ExpSnapShotRec.OffPx)&
									"Outcome is: "&hstr(OutSnapShotRec.OffPx)
							Severity Failure;
					
							Assert (ExpSnapShotRec.OffPxNegExp=OutSnapShotRec.OffPxNegExp) 
							Report 	"ERROR OffPxNegExp :Exp is: "&hstr(ExpSnapShotRec.OffPxNegExp)&
									"Outcome is: "&hstr(OutSnapShotRec.OffPxNegExp)		
							Severity Failure;
						end if;
						
						Assert (ExpSnapShotRec.OffSize=OutSnapShotRec.OffSize) 
						Report 	"ERROR OffSize :Exp is: "&hstr(ExpSnapShotRec.OffSize)&
								"Outcome is: "&hstr(OutSnapShotRec.OffSize)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.OffTimeHour=OutSnapShotRec.OffTimeHour) 
						Report 	"ERROR OffTimeHour :Exp is: "&hstr(ExpSnapShotRec.OffTimeHour)&
								"Outcome is: "&hstr(OutSnapShotRec.OffTimeHour)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.OffTimeMin=OutSnapShotRec.OffTimeMin) 
						Report 	"ERROR OffTimeMin :Exp is: "&hstr(ExpSnapShotRec.OffTimeMin)&
								"Outcome is: "&hstr(OutSnapShotRec.OffTimeMin)		
						Severity Failure;
				
						Assert (ExpSnapShotRec.OffTimeSec=OutSnapShotRec.OffTimeSec) 
						Report 	"ERROR OffTimeSec :Exp is: "&hstr(ExpSnapShotRec.OffTimeSec)&
								"Outcome is: "&hstr(OutSnapShotRec.OffTimeSec)
						Severity Failure;
				
						Assert (ExpSnapShotRec.OffTimeSecNegExp=OutSnapShotRec.OffTimeSecNegExp) 
						Report 	"ERROR OffTimeSecNegExp :Exp is: "&hstr(ExpSnapShotRec.OffTimeSecNegExp)&
								"Outcome is: "&hstr(OutSnapShotRec.OffTimeSecNegExp)		
						Severity Failure;
					end if;
					
				else
					Report 	"ERROR EntriesVal: :Exp is: "&hstr(ExpSnapShotRec.EntriesVal)&
							"Outcome is: "&hstr(OutSnapShotRec.EntriesVal)		
					Severity Failure;
				end if;
				
				Assert (ExpSnapShotRec.SpecialPxFlag=OutSnapShotRec.SpecialPxFlag) 
				Report 	"ERROR SpecialPxFlag :Exp is: "&hstr(ExpSnapShotRec.SpecialPxFlag)&
						"Outcome is: "&hstr(OutSnapShotRec.SpecialPxFlag)		
				Severity Failure;
		
				Assert (ExpSnapShotRec.NoEntriesError=OutSnapShotRec.NoEntriesError) 
				Report 	"ERROR SpecialPxFlag :Exp is: "&hstr("000"&ExpSnapShotRec.NoEntriesError)&
						"Outcome is: "&hstr("000"&OutSnapShotRec.NoEntriesError)		
				Severity Failure;
				
			end if;
	
		elsif ( ExpHdDecRec.MsgTypeVal/=OutHdDecRec.MsgTypeVal ) then
			Report 	"Msg is dropped";
			Report 	"ERROR MsgTypeValid :Exp is: "&hstr(ExpHdDecRec.MsgTypeVal)&
					"Outcome is: "&hstr(OutHdDecRec.MsgTypeVal)
			Severity Failure;
		
		else
			Report 	"Msg is dropped";
		end if;
	
	End Procedure Verify_SnapShot;
	
End Package Body PkTbRxFix;
	
