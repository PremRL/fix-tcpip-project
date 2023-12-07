----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		PkTbFixGen.vhd
-- Title		Test RxFix
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       K.Norawit
-- Date         2021/02/20
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Package PkTbFixGen Is
	
	------------------------------------------------------------------------
	-- Constant declaration
	------------------------------------------------------------------------
	
	constant cAsciiSOH			: std_logic_vector( 7 downto 0 )	:= x"01";
	
	------------------------------------------------------------------------
	-- Array type declaration
	------------------------------------------------------------------------
	Type Pkt_array 		is array ( 0 to 1023 ) of std_logic_vector( 7 downto 0 );
	Type TotalPkt_array 	is array ( 0 to 1023 ) of Pkt_array;
	
	------------------------------------------------------------------------
	--  Signal declaration (TbDecoder global signal)
	------------------------------------------------------------------------
	signal	All_array		: TotalPkt_array;
	
	------------------------------------------------------------------------
	-- Recored declaration
	------------------------------------------------------------------------
	
	Type HdRecord is Record
		HdBeginStr		: std_logic_vector( 63 downto 0 );		-- x"383d" &		
		HdBodyLen		: std_logic_vector( 47 downto 0 );		-- x"393d" &		
		HdMsgType		: std_logic_vector( 31 downto 0 );		-- x"33353d" &
		HdSeqNum		: std_logic_vector( 31 downto 0 );		-- x"33343d" &
		HdSendComID		: std_logic_vector( 103 downto 0 );		-- x"34393d" &
		HdTarComID		: std_logic_vector( 103 downto 0 );		-- x"35363d" &
		HdSendTime		: std_logic_vector( 167 downto 0 );		-- x"35323d" &
		HdLastSeqNumProc: std_logic_vector( 31 downto 0 );		-- x"3336393d" &
		HdPossDup		: std_logic_vector( 7 downto 0 );		-- x"34333d" &
	End Record HdRecord; 										-- total: 109 byte
	
	Type LogonRecord is Record
		EncryptMet		: std_logic_vector( 7 downto 0 );		-- x"39383d" &
		HeartBtInt		: std_logic_vector( 15 downto 0 );		-- x"3130383d" &
		RstSeqNumFlag	: std_logic_vector( 7 downto 0 );		-- x"3134313d" &
		UserName		: std_logic_vector( 103 downto 0 );		-- x"3535333d" &
		Password		: std_logic_vector( 63 downto 0 );		-- x"3535343d" &
		AppVerID		: std_logic_vector( 7 downto 0 );		-- x"313133373d" &
	End Record LogonRecord;										-- total: 56 byte
	
	Type ResentReqRecord is Record
		BeginSeqNum		: std_logic_vector( 31 downto 0 );		-- x"373d" &
		EndSeqNum		: std_logic_vector( 31 downto 0 );		-- x"31363d" &
	End Record ResentReqRecord;									-- total: 15 byte
	
	Type RejectRecord is Record
		RefSeqNum		: std_logic_vector( 31 downto 0 );		-- x"34353d" &
		RefTagID		: std_logic_vector( 31 downto 0 );		-- x"3337313d" &
		RefMsgType		: std_logic_vector( 7 downto 0 );		-- x"3337323d" &
		ReajectReaon	: std_logic_vector( 15 downto 0 );		-- x"3337333d" &
		Reject_Text		: std_logic_vector( 79 downto 0 );		-- x"35383d" &
	End Record RejectRecord;									-- total: 44 byte
	
	Type SeqRstRecord is Record
		GapFillFlag		: std_logic_vector( 7 downto 0 );		-- x"3132333d" &
		NewSeqNum		: std_logic_vector( 31 downto 0 );		-- x"33363d" &
	End Record SeqRstRecord;									-- total: 15 byte
	
	Type SnapShotFullRecord is Record
		MDReqID			: std_logic_vector( 15 downto 0 );		-- x"3236323d" &
		Symbol			: std_logic_vector( 47 downto 0 );		-- x"35353d" &
		SecID			: std_logic_vector( 39 downto 0 );		-- x"34383d" &
		SecIDSrc		: std_logic_vector( 15 downto 0 );		-- x"32323d" &
		NoEntries		: std_logic_vector( 15 downto 0 );		-- x"3236383d" &
		EntryType0		: std_logic_vector( 7 downto 0 );		-- x"3236393d" &
		Price0			: std_logic_vector( 159 downto 0 );		-- x"3237303d" &
		Size0			: std_logic_vector( 63 downto 0 );		-- x"3237313d" &
		EntryTime0		: std_logic_vector( 95 downto 0 );		-- x"3237333d" &
		EntryType1		: std_logic_vector( 7 downto 0 );		-- x"3236393d" &
		Price1			: std_logic_vector( 63 downto 0 );		-- x"3237303d" &
		Size1			: std_logic_vector( 63 downto 0 );		-- x"3237313d" &
		EntryTime1		: std_logic_vector( 95 downto 0 );		-- x"3237333d" &
	End Record SnapShotFullRecord;								-- total: 149 byte
	
	------------------------------------------------------------------------
	-- Function and Procedure Header
	------------------------------------------------------------------------
	
	Procedure LogonBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	LogonRecIn		: in	LogonRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Logon_array		: out	Pkt_array
	);
	
	Procedure HB_or_TestReq_Build
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	TestReqID		: in	std_logic_vector( 63 downto 0 );	-- x"3131323d &"
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	HeartBt_array	: out	Pkt_array
	);
	
	Procedure EmptyFieldBuild		-- Ex. for Logout
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Empty_array		: out	Pkt_array
	);
	
	Procedure ReSentReqBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	ResentRecIn		: in	ResentReqRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	ResentReq_array	: out	Pkt_array
	);
	
	Procedure RejectBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	RejectRecIn		: in	RejectRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Reject_array	: out	Pkt_array
	);
	
	Procedure SeqRstBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	SeqRstRecIn		: in	SeqRstRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	SeqRst_array	: out	Pkt_array
	);
	
	Procedure SnapShotBuild
	(		
		signal	HdRecIn				: in	HdRecord;
		signal	SnapShotFullRecIn	: in	SnapShotFullRecord;
		signal	CSum				: in 	std_logic_vector( 23 downto 0 );
		signal	SnapShot_array		: out	Pkt_array
	);
	
	Procedure SnapShotBuild_Error
	(		
		signal	HdRecIn				: in	HdRecord;
		signal	SnapShotFullRecIn	: in	SnapShotFullRecord;
		signal	CSum				: in 	std_logic_vector( 23 downto 0 );
		signal	SnapShot_array		: out	Pkt_array
	);
	
	
End Package PkTbFixGen;

Package Body PkTbFixGen Is	
	
	------------------------------------------------------------------------
	-- Logon Build
	------------------------------------------------------------------------
	
	Procedure LogonBuild
	(	
		signal	HdRecIn			: in	HdRecord;
		signal	LogonRecIn		: in	LogonRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Logon_array		: out	Pkt_array
		
	) Is
	
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 171;		-- total size -1 
		variable	vLogon_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch			: std_logic_vector( 1375 downto 0 );
		
	Begin
		
		-- set Msg ( 109+56+7 = 172 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"39383d" 		& LogonRecIn.EncryptMet		& cAsciiSOH &
					x"3130383d" 	& LogonRecIn.HeartBtInt		& cAsciiSOH &
					x"3134313d" 	& LogonRecIn.RstSeqNumFlag	& cAsciiSOH &
					x"3535333d" 	& LogonRecIn.UserName		& cAsciiSOH &
					x"3535343d" 	& LogonRecIn.Password		& cAsciiSOH &
					x"313133373d" 	& LogonRecIn.AppVerID		& cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vLogon_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		Logon_array	<= vLogon_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Heartbeat or TestReq Build (Use this build for Test-request heartbeat only)
	------------------------------------------------------------------------
	
	Procedure HB_or_TestReq_Build
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	TestReqID		: in	std_logic_vector( 63 downto 0 );	-- x"3131323d" &
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	HeartBt_array	: out	Pkt_array
		
	) Is
		
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 128;		-- total size -1 
		variable	vHeartBt_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch			: std_logic_vector( 1031 downto 0 );
	
	Begin
		
		-- set Msg ( 109+13+7 = 129 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"3131323d" &	TestReqID					& cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
	
		-- build Msg
		For byte in 0 to vSize loop
			vHeartBt_array(byte) 	:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		HeartBt_array	<= vHeartBt_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Empty Field message build (for Logout or Heartbeat in general)
	------------------------------------------------------------------------
	
	Procedure EmptyFieldBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Empty_array		: out	Pkt_array
		
	) Is
	
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 115;		-- total size -1 
		variable	vEmpty_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch			: std_logic_vector( 927 downto 0 );
	
	Begin
		
		-- set Msg ( 109+7 = 116 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
	
		-- build Msg
		For byte in 0 to vSize loop
			vEmpty_array(byte) 	:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		Empty_array		<= vEmpty_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Resent Request Build
	------------------------------------------------------------------------
	
	Procedure ReSentReqBuild
	(		
		signal	HdRecIn				: in	HdRecord;
		signal	ResentRecIn			: in	ResentReqRecord;
		signal	CSum				: in 	std_logic_vector( 23 downto 0 );
		signal	ResentReq_array		: out	Pkt_array
		
	) Is
	
		-- miscellaneous
		variable	vSize				: integer range 0 to 65535 := 130;		-- total size -1 
		variable	vResentReq_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch				: std_logic_vector( 1047 downto 0 );
		
	Begin
		
		-- set Msg ( 109+15+7 = 131 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"373d" 	& 	ResentRecIn.BeginSeqNum		& cAsciiSOH &
					x"31363d" 	& 	ResentRecIn.EndSeqNum		& cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vResentReq_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		ResentReq_array		<= vResentReq_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Reject Build
	------------------------------------------------------------------------
	
	Procedure RejectBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	RejectRecIn		: in	RejectRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	Reject_array	: out	Pkt_array
		
	) Is
		
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 159;		-- total size -1 
		variable	vReject_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch				: std_logic_vector( 1279 downto 0 );
		
	Begin
		
		-- set Msg ( 109+44+7 = 160 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"34353d" 	&	RejectRecIn.RefSeqNum		& cAsciiSOH &
					x"3337313d" & 	RejectRecIn.RefTagID		& cAsciiSOH &
					x"3337323d" &   RejectRecIn.RefMsgType		& cAsciiSOH &
					x"3337333d" &   RejectRecIn.ReajectReaon    & cAsciiSOH &
					x"35383d" 	&   RejectRecIn.Reject_Text	    & cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vReject_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		Reject_array	<= vReject_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Sequence Reset Build
	------------------------------------------------------------------------
	
	Procedure SeqRstBuild
	(		
		signal	HdRecIn			: in	HdRecord;
		signal	SeqRstRecIn		: in	SeqRstRecord;
		signal	CSum			: in 	std_logic_vector( 23 downto 0 );
		signal	SeqRst_array	: out	Pkt_array
		
	) Is
		
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 129;		-- total size -1 
		variable	vSeqRst_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch				: std_logic_vector( 1039 downto 0 );
		
	Begin
		
		-- set Msg ( 109+14+7 = 130 byte )
		--			| Tag		|			Tag Field			|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr			& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen			& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    & cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    & cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    & cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    & cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    & cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    & cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    & cAsciiSOH &
					
					x"3132333d" &	SeqRstRecIn.GapFillFlag		& cAsciiSOH &
					x"33363d" 	&   SeqRstRecIn.NewSeqNum	    & cAsciiSOH &
					
					x"31303d"	&	CSum						& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vSeqRst_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		SeqRst_array	<= vSeqRst_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Market Data Snapshot Full Refresh Build
	------------------------------------------------------------------------
	
	Procedure SnapShotBuild
	(		
		signal	HdRecIn				: in	HdRecord;
		signal	SnapShotFullRecIn	: in	SnapShotFullRecord;
		signal	CSum				: in 	std_logic_vector( 23 downto 0 );
		signal	SnapShot_array		: out	Pkt_array
		
	) Is
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 264;		-- total size -1 
		variable	vSnapShot_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch				: std_logic_vector( 2119 downto 0 );
		
	Begin
		
		-- set Msg ( 109+149+7 = 265 byte )
		--			| Tag		|			Tag Field				|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr				& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen				& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    	& cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    	& cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    	& cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    	& cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    	& cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    	& cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    	& cAsciiSOH &
					
					x"3236323d" &	SnapShotFullRecIn.MDReqID		& cAsciiSOH &	
					x"35353d" 	&   SnapShotFullRecIn.Symbol		& cAsciiSOH &	
					x"34383d" 	&   SnapShotFullRecIn.SecID			& cAsciiSOH &
					x"32323d" 	&   SnapShotFullRecIn.SecIDSrc		& cAsciiSOH &
					x"3236383d" &   SnapShotFullRecIn.NoEntries		& cAsciiSOH &
					x"3236393d" &   SnapShotFullRecIn.EntryType0	& cAsciiSOH &
					x"3237303d" &   SnapShotFullRecIn.Price0		& cAsciiSOH &
					x"3237313d" &   SnapShotFullRecIn.Size0			& cAsciiSOH &
					x"3237333d" &   SnapShotFullRecIn.EntryTime0	& cAsciiSOH &
					x"3236393d" &   SnapShotFullRecIn.EntryType1	& cAsciiSOH &
					x"3237303d" &   SnapShotFullRecIn.Price1		& cAsciiSOH &
					x"3237313d" &   SnapShotFullRecIn.Size1			& cAsciiSOH &
					x"3237333d" &   SnapShotFullRecIn.EntryTime1	& cAsciiSOH &
					
					x"31303d"	&	CSum							& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vSnapShot_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		SnapShot_array	<= vSnapShot_array;
	End Procedure;
	
	------------------------------------------------------------------------
	-- Market Data Snapshot Full Refresh Build with Tagg Error
	------------------------------------------------------------------------
	
	Procedure SnapShotBuild_Error
	(		
		signal	HdRecIn				: in	HdRecord;
		signal	SnapShotFullRecIn	: in	SnapShotFullRecord;
		signal	CSum				: in 	std_logic_vector( 23 downto 0 );
		signal	SnapShot_array		: out	Pkt_array
		
	) Is
		-- miscellaneous
		variable	vSize			: integer range 0 to 65535 := 264;		-- total size -1 
		variable	vSnapShot_array	: Pkt_array	:= (others => (others=>'0'));
	
		-- bunch of interested fields
		variable	vbunch				: std_logic_vector( 2119 downto 0 );
		
	Begin
		
		-- set Msg ( 109+149+7 = 265 byte )
		--			| Tag		|			Tag Field				|    SOH	|
		vbunch	:= 	x"383d" 	&	HdRecIn.HdBeginStr				& cAsciiSOH &			
					x"393d" 	&	HdRecIn.HdBodyLen				& cAsciiSOH &
					x"33353d" 	&	HdRecIn.HdMsgType		    	& cAsciiSOH &
					x"33343d" 	&	HdRecIn.HdSeqNum		    	& cAsciiSOH &
					x"34393d" 	&	HdRecIn.HdSendComID		    	& cAsciiSOH &
					x"35363d" 	&	HdRecIn.HdTarComID		    	& cAsciiSOH &
					x"35323d" 	&	HdRecIn.HdSendTime		    	& cAsciiSOH &
					x"3336393d" &	HdRecIn.HdLastSeqNumProc    	& cAsciiSOH &
					x"34333d" 	&	HdRecIn.HdPossDup		    	& cAsciiSOH &
					
					x"3236323d" &	SnapShotFullRecIn.MDReqID		& cAsciiSOH &	
					x"35353d" 	&   SnapShotFullRecIn.Symbol		& cAsciiSOH &	
					x"34383d" 	&   SnapShotFullRecIn.SecID			& cAsciiSOH &
					x"32323d" 	&   SnapShotFullRecIn.SecIDSrc		& cAsciiSOH &
					x"3236383d" &   SnapShotFullRecIn.NoEntries		& cAsciiSOH &
					x"3236393d" &   SnapShotFullRecIn.EntryType0	& cAsciiSOH &
					x"3838383d" &   SnapShotFullRecIn.Price0		& cAsciiSOH &	-- error
					x"3237313d" &   SnapShotFullRecIn.Size0			& cAsciiSOH &
					x"3237333d" &   SnapShotFullRecIn.EntryTime0	& cAsciiSOH &	
					x"3236393d" &   SnapShotFullRecIn.EntryType1	& cAsciiSOH &
					x"3237303d" &   SnapShotFullRecIn.Price1		& cAsciiSOH &
					x"3939393d" &   SnapShotFullRecIn.Size1			& cAsciiSOH &	-- error
					x"3237333d" &   SnapShotFullRecIn.EntryTime1	& cAsciiSOH &
					
					x"31303d"	&	CSum							& cAsciiSOH;
		
		-- build Msg
		For byte in 0 to vSize loop
			vSnapShot_array(byte) 		:= vbunch( (8*((vSize-byte)+1))-1 downto (8*(vSize-byte)) );
		End loop;
		
		-- assign output signal
		SnapShot_array	<= vSnapShot_array;
	End Procedure;
	
	
	
End Package Body PkTbFixGen;
