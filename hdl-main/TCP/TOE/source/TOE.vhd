----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TOE.vhd
-- Title        TCP/IP Offload Engine 
-- 
-- Author       L.Ratchanon
-- Date         2020/11/10
-- Syntax       VHDL
-- Description      
-- 
-- TCP/IP Offload Engine Mapping module 
--
--
----------------------------------------------------------------------------------
-- Note
--
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TOE Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		MacRstB					: in	std_logic;
		RxMacClk				: in	std_logic;
		
		-- User Interface 
		-- Control 
		User2TOEConnectReq		: in	std_logic;
		User2TOETerminateReq	: in 	std_logic;
	
		TOE2UserStatus			: out 	std_logic_vector( 3 downto 0 );	
		TOE2UserPSHFlagset		: out	std_logic;
		TOE2UserFINFlagset 		: out	std_logic;
		TOE2UserRSTFlagset		: out 	std_logic;
		
		-- TxTCP  
		User2TOETxDataVal		: in 	std_logic;
		User2TOETxDataSop		: in	std_logic;
		User2TOETxDataEop		: in	std_logic;
		User2TOETxDataIn		: in 	std_logic_vector( 7 downto 0 );
		User2TOETxDataLen		: in	std_logic_vector(15 downto 0 );
		
		TOE2UserTxMemAlFull		: out 	std_logic;
		
		-- Rx TCP 
		User2TOERxReq			: in	std_logic;
		
		TOE2UserRxSOP			: out	std_logic;
		TOE2UserRxEOP			: out	std_logic;
		TOE2UserRxValid			: out	std_logic;
		TOE2UserRxData			: out	std_logic_vector( 7 downto 0 );
		
		-- User Network Register Interface 
		UNG2TOESenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TOETargetMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TOESenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TOETargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TOESrcPort     		: in	std_logic_vector(15 downto 0 );
		UNG2TOEDesPort     		: in	std_logic_vector(15 downto 0 );
		
		UNG2TOEAddrVal			: in	std_logic;

		-- EMAC Interface 
		--TxMac 
		EMAC2TOETxReady			: in	std_logic;
	
		TOE2EMACTxReq			: out	std_logic;
		TOE2EMACTxDataOut		: out	std_logic_vector(7 downto 0);
		TOE2EMACTxDataOutVal	: out	std_logic;
		TOE2EMACTxDataOutSop	: out	std_logic;
		TOE2EMACTxDataOutEop	: out	std_logic;
		
		-- RxMac 
		EMAC2TOERxSOP			: in	std_logic;
		EMAC2TOERxValid			: in	std_logic;
		EMAC2TOERxEOP			: in	std_logic;
		EMAC2TOERxData			: in	std_logic_vector( 7 downto 0 );
		EMAC2TOERxError			: in	std_logic_vector( 1 downto 0 )
	);
End Entity TOE;	
	
Architecture rtl Of TOE Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant	cTCPoption_Mss 	: std_logic_vector(15 downto 0 ) := x"2300"; -- 8960 bytes 
	
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------

	Component TPUTCPIP Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		-- User Interface 
		UserConnectReq			: in	std_logic;
		UserTerminateReq		: in 	std_logic;
		
		UserStatus				: out 	std_logic_vector( 3 downto 0 );	
		UserPSHFlagset			: out	std_logic;
		UserFINFlagset 			: out	std_logic;
		UserRSTFlagset			: out 	std_logic;
		
		-- User Network Register Interface 
		UNG2TCPSenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TCPTargetMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TCPSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TCPTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TCPSrcPort     		: in	std_logic_vector(15 downto 0 );
		UNG2TCPDesPort     		: in	std_logic_vector(15 downto 0 );
		
		UNG2TCPAddrVal			: in	std_logic;
	
		-- TxTCPIP Interface
		Tx2TPUPayloadLen		: in 	std_logic_vector(15 downto 0 );
		Tx2TPUPayloadReq   		: in 	std_logic; 
		Tx2TPUOpReply			: in	std_logic;
		Tx2TPUInitReady			: in 	std_logic;
		Tx2TPULastData			: in	std_logic;
		Tx2TPUTxCtrlBusy 		: in 	std_logic;
		
		TPU2TxMACSouAddr		: out	std_logic_vector(47 downto 0 );
		TPU2TxMACDesAddr		: out 	std_logic_vector(47 downto 0 );
		TPU2TxIPSouAddr			: out 	std_logic_vector(31 downto 0 );
		TPU2TxIPDesAddr			: out 	std_logic_vector(31 downto 0 );
		TPU2TxSouPort			: out 	std_logic_vector(15 downto 0 );
		TPU2TxDesPort			: out 	std_logic_vector(15 downto 0 );	
		TPU2TxSeqNum			: out	std_logic_vector(31 downto 0 );
		TPU2TxAckNum			: out	std_logic_vector(31 downto 0 );
		TPU2TxDataOffset		: out 	std_logic_vector( 3 downto 0 );
		TPU2TxFlags				: out	std_logic_vector( 8 downto 0 );
		TPU2TxWindow			: out 	std_logic_vector(15 downto 0 );
		TPU2TxUrgent			: out 	std_logic_vector(15 downto 0 );

		TPU2TxSeqNumIndex		: out 	std_logic_vector(31 downto 0 );	
		TPU2TxSeqNumIndexEn 	: out 	std_logic;	
		TPU2TxOperations		: out 	std_logic_vector( 3 downto 0 );			
		TPU2TxReset				: out 	std_logic;		
		TPU2TxTxReq 			: out 	std_logic;			
		TPU2TxPayloadEn			: out 	std_logic;
		
		-- RxTCPIP Interface
		Rx2TPUSeqNum			: in	std_logic_vector(31 downto 0 );
		Rx2TPUAckNum			: in	std_logic_vector(31 downto 0 );
		Rx2TPUPayloadLen		: in	std_logic_vector(15 downto 0 );
		Rx2TPUWinSize			: in	std_logic_vector(15 downto 0 );
		Rx2TPUFreeSpace			: in	std_logic_vector(15 downto 0 );
		Rx2TPUAckFlag			: in 	std_logic;
		Rx2TPUPshFlag           : in 	std_logic;
		Rx2TPURstFlag			: in 	std_logic;
		Rx2TPUSynFlag           : in 	std_logic;
		Rx2TPUFinFlag			: in 	std_logic;
		Rx2TPUPktValid          : in 	std_logic;
		Rx2TPUSeqNumError		: in 	std_logic;
		
		TPU2RxSenderMACAddr		: out 	std_logic_vector(47 downto 0 );
		TPU2RxTargetMACAddr		: out	std_logic_vector(47 downto 0 );
		TPU2RxSenderIpAddr		: out 	std_logic_vector(31 downto 0 );
		TPU2RxTargetIpAddr		: out 	std_logic_vector(31 downto 0 );
		TPU2RxExpSeqNum			: out	std_logic_vector(31 downto 0 );
		TPU2RxSrcPort     		: out	std_logic_vector(15 downto 0 );
		TPU2RxDesPort     		: out	std_logic_vector(15 downto 0 );
		TPU2RxInitFlag			: out	std_logic;
		TPU2RxDecodeEn			: out	std_logic;
		TPU2RxDataTransEn		: out	std_logic;
		TPU2RxAddrVal			: out	std_logic
	);
	End Component TPUTCPIP;
	
	Component TxTCPIP Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
	
		-- User Interface
		UserDataVal				: in 	std_logic;
		UserDataSop				: in	std_logic;
		UserDataEop				: in	std_logic;
		UserDataIn				: in 	std_logic_vector( 7 downto 0 );
		UserDataLen				: in	std_logic_vector(15 downto 0 );
		
		UserMemAlFull			: out 	std_logic;
		
		-- TCP/IP Processor interface  
		-- Header field process 
		MACSouAddr				: in	std_logic_vector(47 downto 0 );
		MACDesAddr				: in 	std_logic_vector(47 downto 0 );
		IPSouAddr				: in 	std_logic_vector(31 downto 0 );
		IPDesAddr				: in 	std_logic_vector(31 downto 0 );
		SouPort					: in 	std_logic_vector(15 downto 0 );
		DesPort					: in 	std_logic_vector(15 downto 0 );	
		SeqNum					: in	std_logic_vector(31 downto 0 );
		AckNum					: in	std_logic_vector(31 downto 0 );
		DataOffset				: in 	std_logic_vector( 3 downto 0 );
		Flags					: in	std_logic_vector( 8 downto 0 );
		Window					: in 	std_logic_vector(15 downto 0 );
		Urgent					: in 	std_logic_vector(15 downto 0 );
		TCPOptionMss			: in	std_logic_vector(15 downto 0 );
		-- Control I/F	
		TPUAckedSeqnum			: in	std_logic_vector(31 downto 0 );		
		TPUOperations			: in 	std_logic_vector( 3 downto 0 );		
		TPUAckedSeqnumEn		: in	std_logic;		
		TPUReset				: in 	std_logic;		
		TPUTxReq 				: in 	std_logic;
		TPUPayloadEn			: in 	std_logic;			
		
		TPUPayloadLen			: out 	std_logic_vector(15 downto 0 );
		TPUPayloadReq   		: out 	std_logic; 
		TPUOpReply				: out	std_logic;
		TPUInitReady			: out 	std_logic;
		TPULastData				: out	std_logic;
		TPUTxCtrlBusy 			: out 	std_logic;
	
		-- EMAC Interface	
		EMACReady				: in	std_logic;
		
		EMACReq					: out	std_logic;
		EMACDataOut				: out	std_logic_vector(7 downto 0);
		EMACDataOutVal			: out	std_logic;
		EMACDataOutSop			: out	std_logic;
		EMACDataOutEop			: out	std_logic
	);
	End Component TxTCPIP;
	
	Component RxTCPIP Is
	Port 
	(
		MacRstB					: in	std_logic;
		RstB					: in	std_logic;
		RxMacClk				: in	std_logic;
		Clk						: in	std_logic; 
		
		-- Test Error Port
		PktDropError			: out	std_logic;							-- ClkAdaptor
		MacAddrValid			: out	std_logic_vector( 1 downto 0 );		-- RxHeaderDec
		IPVerValid				: out	std_logic;							-- RxHeaderDec
		ProtocolValid			: out	std_logic;                          -- RxHeaderDec
		SrcIPValid				: out	std_logic;                          -- RxHeaderDec
		DesIPValid				: out	std_logic;                          -- RxHeaderDec
		SrcPortValid			: out	std_logic;                          -- RxHeaderDec
		DesPortValid			: out	std_logic;                          -- RxHeaderDec
		CheckSumValid			: out	std_logic_vector( 1 downto 0 );     -- RxHeaderDec
		MacErrorFlag			: out	std_logic_vector( 1 downto 0 );     -- RxHeaderDec
		PlLenError				: out 	std_logic;	                        -- RxDataCrtl
		
		-- RxEMAC I/F
		MacSOP					: in	std_logic;
		MacValid				: in	std_logic;
		MacEOP					: in	std_logic;
		MacData					: in	std_logic_vector( 7 downto 0 );
		MacError				: in	std_logic_vector( 1 downto 0 );
		
		-- TPU I/F
		InitEn					: in	std_logic;
		DecodeEn				: in	std_logic;
		DataTransEn				: in	std_logic;
		ExpSeqNum				: in	std_logic_vector( 31 downto 0 );
		UserValid				: in	std_logic;
		UserSrcMac				: in	std_logic_vector( 47 downto 0 );
		UserDesMac				: in	std_logic_vector( 47 downto 0 );
		UserSrcIP				: in	std_logic_vector( 31 downto 0 );
		UserDesIP				: in	std_logic_vector( 31 downto 0 );
		UserSrcPort             : in	std_logic_vector( 15 downto 0 );
		UserDesPort             : in	std_logic_vector( 15 downto 0 );
		
		PktValid				: out	std_logic;
		SeqNumError				: out	std_logic;
		TCPSeqNum				: out	std_logic_vector( 31 downto 0 );
		TCPAck					: out	std_logic_vector( 31 downto 0 );
		TCPAckFlag				: out	std_logic;
		TCPPshFlag				: out	std_logic;
		TCPRstFlag				: out	std_logic;
		TCPSynFlag				: out	std_logic;
		TCPFinFlag				: out	std_logic;
		TCPWinSize				: out	std_logic_vector( 15 downto 0 );
		TCPPLLen				: out	std_logic_vector( 15 downto 0 );	-- Payload length
		RxWinSize				: out	std_logic_vector( 15 downto 0 );	-- Rx Window size
		
		-- FIX I/F (Upper layer I/F)
		FixReq					: in	std_logic;
		FixSOP					: out	std_logic;
		FixEOP					: out	std_logic;
		FixValid				: out	std_logic;
		FixData					: out	std_logic_vector( 7 downto 0 )
	);
	End Component RxTCPIP;
	
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	-- Mapping signal 
	-- TPU and TxTCP I/F 
	signal  rTx2TPUPayloadLen	: std_logic_vector(15 downto 0 );
	signal  rTx2TPUPayloadReq   : std_logic; 	
	signal  rTx2TPUOpReply		: std_logic;
	signal  rTx2TPUInitReady	: std_logic;	
	signal  rTx2TPULastData		: std_logic;
	signal  rTx2TPUTxCtrlBusy 	: std_logic;

	signal  rTPU2TxMACSouAddr	: std_logic_vector(47 downto 0 );
	signal  rTPU2TxMACDesAddr	: std_logic_vector(47 downto 0 );
	signal  rTPU2TxIPSouAddr	: std_logic_vector(31 downto 0 );	
	signal  rTPU2TxIPDesAddr	: std_logic_vector(31 downto 0 );	
	signal  rTPU2TxSouPort		: std_logic_vector(15 downto 0 );
	signal  rTPU2TxDesPort		: std_logic_vector(15 downto 0 );	
	signal  rTPU2TxSeqNum		: std_logic_vector(31 downto 0 );
	signal  rTPU2TxAckNum		: std_logic_vector(31 downto 0 );
	signal  rTPU2TxDataOffset	: std_logic_vector( 3 downto 0 );
	signal  rTPU2TxFlags		: std_logic_vector( 8 downto 0 );	
	signal  rTPU2TxWindow		: std_logic_vector(15 downto 0 );
	signal  rTPU2TxUrgent		: std_logic_vector(15 downto 0 );

	signal  rTPU2TxSeqNumIndex	: std_logic_vector(31 downto 0 );	
	signal  rTPU2TxSeqNumIndexEn: std_logic;	 
	signal  rTPU2TxOperations	: std_logic_vector( 3 downto 0 );	
	signal  rTPU2TxReset		: std_logic;			
    signal  rTPU2TxTxReq 		: std_logic;			
    signal  rTPU2TxPayloadEn	: std_logic;	
	
	-- TPU and RxTCP I/F 
	signal  rRx2TPUSeqNum		: std_logic_vector(31 downto 0 );
	signal  rRx2TPUAckNum		: std_logic_vector(31 downto 0 );
	signal  rRx2TPUPayloadLen	: std_logic_vector(15 downto 0 );
	signal  rRx2TPUWinSize		: std_logic_vector(15 downto 0 );
	signal  rRx2TPUFreeSpace	: std_logic_vector(15 downto 0 );	
	signal  rRx2TPUAckFlag		: std_logic;
	signal  rRx2TPUPshFlag      : std_logic; 
	signal  rRx2TPURstFlag		: std_logic;
	signal  rRx2TPUSynFlag      : std_logic; 
	signal  rRx2TPUFinFlag		: std_logic;
	signal  rRx2TPUPktValid     : std_logic; 
	signal  rRx2TPUSeqNumError	: std_logic;

	signal  rTPU2RxSenderMACAddr: std_logic_vector(47 downto 0 );	
	signal  rTPU2RxTargetMACAddr: std_logic_vector(47 downto 0 );	
	signal  rTPU2RxSenderIpAddr	: std_logic_vector(31 downto 0 );
	signal  rTPU2RxTargetIpAddr	: std_logic_vector(31 downto 0 );
	signal  rTPU2RxExpSeqNum	: std_logic_vector(31 downto 0 );	
	signal  rTPU2RxSrcPort     	: std_logic_vector(15 downto 0 );
	signal  rTPU2RxDesPort     	: std_logic_vector(15 downto 0 );
	signal  rTPU2RxInitFlag		: std_logic;
	signal  rTPU2RxDecodeEn		: std_logic;
	signal  rTPU2RxDataTransEn	: std_logic;
	signal  rTPU2RxAddrVal		: std_logic;
	
--------------------------------------------------
	-- RxTCP Error Flag 
	signal  rPktDropError		: std_logic;
	signal  rMacAddrValid		: std_logic_vector( 1 downto 0 );
	signal  rIPVerValid		    : std_logic;
	signal  rProtocolValid	    : std_logic;
	signal  rSrcIPValid		    : std_logic;
	signal  rDesIPValid		    : std_logic;
	signal  rSrcPortValid	    : std_logic;
	signal  rDesPortValid	    : std_logic;
	signal  rCheckSumValid	    : std_logic_vector( 1 downto 0 );
	signal  rMacErrorFlag	    : std_logic_vector( 1 downto 0 );
	signal  rPlLenError		    : std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- DFF : Component Mapping 
----------------------------------------------------------------------------------
	
	u_TPUTCPIP : TPUTCPIP
	Port map 
	(
		RstB					=> RstB						,
		Clk						=> Clk	                    ,
		
		UserConnectReq			=> User2TOEConnectReq		,
		UserTerminateReq		=> User2TOETerminateReq		,

		UserStatus				=> TOE2UserStatus			,
		UserPSHFlagset			=> TOE2UserPSHFlagset		,
		UserFINFlagset 			=> TOE2UserFINFlagset 		,
		UserRSTFlagset			=> TOE2UserRSTFlagset		,

		UNG2TCPSenderMACAddr	=> UNG2TOESenderMACAddr		,
		UNG2TCPTargetMACAddr	=> UNG2TOETargetMACAddr		,
		UNG2TCPSenderIpAddr		=> UNG2TOESenderIpAddr		,
		UNG2TCPTargetIpAddr		=> UNG2TOETargetIpAddr		,
		UNG2TCPSrcPort     		=> UNG2TOESrcPort     		,
		UNG2TCPDesPort     		=> UNG2TOEDesPort     		,
		
		UNG2TCPAddrVal			=> UNG2TOEAddrVal			,

		Tx2TPUPayloadLen		=> rTx2TPUPayloadLen		,
		Tx2TPUPayloadReq   		=> rTx2TPUPayloadReq   		,
		Tx2TPUOpReply			=> rTx2TPUOpReply			,
		Tx2TPUInitReady			=> rTx2TPUInitReady			,
		Tx2TPULastData			=> rTx2TPULastData			,
		Tx2TPUTxCtrlBusy 		=> rTx2TPUTxCtrlBusy 		,

		TPU2TxMACSouAddr		=> rTPU2TxMACSouAddr		,
		TPU2TxMACDesAddr		=> rTPU2TxMACDesAddr		,
		TPU2TxIPSouAddr			=> rTPU2TxIPSouAddr			,
		TPU2TxIPDesAddr			=> rTPU2TxIPDesAddr			,
		TPU2TxSouPort			=> rTPU2TxSouPort			,
		TPU2TxDesPort			=> rTPU2TxDesPort			,
		TPU2TxSeqNum			=> rTPU2TxSeqNum			,
		TPU2TxAckNum			=> rTPU2TxAckNum			,
		TPU2TxDataOffset		=> rTPU2TxDataOffset		,
		TPU2TxFlags				=> rTPU2TxFlags				,
		TPU2TxWindow			=> rTPU2TxWindow			,
		TPU2TxUrgent			=> rTPU2TxUrgent			,

		TPU2TxSeqNumIndex		=> rTPU2TxSeqNumIndex		,
		TPU2TxSeqNumIndexEn 	=> rTPU2TxSeqNumIndexEn 	,
		TPU2TxOperations		=> rTPU2TxOperations		,	
		TPU2TxReset				=> rTPU2TxReset				,
		TPU2TxTxReq 			=> rTPU2TxTxReq 			,
		TPU2TxPayloadEn			=> rTPU2TxPayloadEn			,

		Rx2TPUSeqNum			=> rRx2TPUSeqNum			,
		Rx2TPUAckNum			=> rRx2TPUAckNum			,
		Rx2TPUPayloadLen		=> rRx2TPUPayloadLen		,
		Rx2TPUWinSize			=> rRx2TPUWinSize			,
		Rx2TPUFreeSpace			=> rRx2TPUFreeSpace			,
		Rx2TPUAckFlag			=> rRx2TPUAckFlag			,
		Rx2TPUPshFlag           => rRx2TPUPshFlag           ,
		Rx2TPURstFlag			=> rRx2TPURstFlag			,
		Rx2TPUSynFlag           => rRx2TPUSynFlag           ,
		Rx2TPUFinFlag			=> rRx2TPUFinFlag			,
		Rx2TPUPktValid          => rRx2TPUPktValid          ,
		Rx2TPUSeqNumError		=> rRx2TPUSeqNumError		,

		TPU2RxSenderMACAddr		=> rTPU2RxSenderMACAddr		,
		TPU2RxTargetMACAddr		=> rTPU2RxTargetMACAddr		,
		TPU2RxSenderIpAddr		=> rTPU2RxSenderIpAddr		,
		TPU2RxTargetIpAddr		=> rTPU2RxTargetIpAddr		,
		TPU2RxExpSeqNum			=> rTPU2RxExpSeqNum			,
		TPU2RxSrcPort     		=> rTPU2RxSrcPort     		,
		TPU2RxDesPort     		=> rTPU2RxDesPort     		,
		TPU2RxInitFlag			=> rTPU2RxInitFlag			,
		TPU2RxDecodeEn			=> rTPU2RxDecodeEn			,
		TPU2RxDataTransEn		=> rTPU2RxDataTransEn		,
		TPU2RxAddrVal			=> rTPU2RxAddrVal			
	);

	
	u_TxTCPIP : TxTCPIP
	Port map 
	(
		RstB					=> RstB						,
		Clk				        => Clk	                    ,

		UserDataVal		        => User2TOETxDataVal		,
		UserDataSop		        => User2TOETxDataSop		,
		UserDataEop		        => User2TOETxDataEop		,
		UserDataIn		        => User2TOETxDataIn		    ,
		UserDataLen		        => User2TOETxDataLen		,

		UserMemAlFull	        => TOE2UserTxMemAlFull	    ,
	
		MACSouAddr		        => rTPU2TxMACSouAddr	    ,
		MACDesAddr		        => rTPU2TxMACDesAddr	    ,
		IPSouAddr		        => rTPU2TxIPSouAddr			,		
		IPDesAddr		        => rTPU2TxIPDesAddr		    ,     
		SouPort			        => rTPU2TxSouPort		    ,    
		DesPort			        => rTPU2TxDesPort		    ,    	
		SeqNum			        => rTPU2TxSeqNum			,		
		AckNum			        => rTPU2TxAckNum		    ,    	
		DataOffset		        => rTPU2TxDataOffset	    ,
		Flags			        => rTPU2TxFlags			    ,
		Window			        => rTPU2TxWindow		    ,
		Urgent			        => rTPU2TxUrgent		    ,
		TCPOptionMss			=> cTCPoption_Mss			,
		TPUAckedSeqnum			=> rTPU2TxSeqNumIndex       ,
		TPUOperations	        => rTPU2TxOperations	    ,
		TPUAckedSeqnumEn		=> rTPU2TxSeqNumIndexEn     ,
		TPUReset		        => rTPU2TxReset		        ,	
		TPUTxReq 		        => rTPU2TxTxReq 		    ,
		TPUPayloadEn	        => rTPU2TxPayloadEn	        ,

		TPUPayloadLen	        => rTx2TPUPayloadLen        ,
		TPUPayloadReq           => rTx2TPUPayloadReq        ,
		TPUOpReply		        => rTx2TPUOpReply	        ,
		TPUInitReady	        => rTx2TPUInitReady	        ,
		TPULastData		        => rTx2TPULastData	        ,
		TPUTxCtrlBusy 	        => rTx2TPUTxCtrlBusy        ,

		EMACReady		        => EMAC2TOETxReady			,

		EMACReq			        => TOE2EMACTxReq			,
		EMACDataOut		        => TOE2EMACTxDataOut		,
		EMACDataOutVal	        => TOE2EMACTxDataOutVal	    ,
		EMACDataOutSop	        => TOE2EMACTxDataOutSop	    ,
		EMACDataOutEop	        => TOE2EMACTxDataOutEop	
	);
	
	u_RxTCPIP : RxTCPIP
	Port map 
	(
		MacRstB					=> MacRstB					,
		RstB					=> RstB	                    ,
		RxMacClk				=> RxMacClk                 ,
		Clk						=> Clk		                ,

		PktDropError			=> rPktDropError			,	
		MacAddrValid			=> rMacAddrValid			,	
		IPVerValid				=> rIPVerValid				,	
		ProtocolValid			=> rProtocolValid			,	
		SrcIPValid				=> rSrcIPValid				,		
		DesIPValid				=> rDesIPValid			    , 		
		SrcPortValid			=> rSrcPortValid		    , 		
		DesPortValid			=> rDesPortValid			,		
		CheckSumValid			=> rCheckSumValid			,		
		MacErrorFlag			=> rMacErrorFlag			,	
		PlLenError				=> rPlLenError				,		
	
		MacSOP					=> EMAC2TOERxSOP	        ,
		MacValid				=> EMAC2TOERxValid	        ,
		MacEOP					=> EMAC2TOERxEOP	        ,
		MacData					=> EMAC2TOERxData	        ,
		MacError				=> EMAC2TOERxError	        ,
	
		InitEn					=> rTPU2RxInitFlag		    ,
		DecodeEn				=> rTPU2RxDecodeEn		    , 
		DataTransEn				=> rTPU2RxDataTransEn	    , 
		ExpSeqNum				=> rTPU2RxExpSeqNum		    ,
		UserValid				=> rTPU2RxAddrVal		    ,
		UserSrcMac				=> rTPU2RxTargetMACAddr		,
		UserDesMac				=> rTPU2RxSenderMACAddr     ,  
		UserSrcIP				=> rTPU2RxTargetIpAddr		,
		UserDesIP				=> rTPU2RxSenderIpAddr      , 
		UserSrcPort             => rTPU2RxDesPort		    ,
		UserDesPort             => rTPU2RxSrcPort           ,

		PktValid				=> rRx2TPUPktValid			,
		SeqNumError				=> rRx2TPUSeqNumError       ,
		TCPSeqNum				=> rRx2TPUSeqNum            ,
		TCPAck					=> rRx2TPUAckNum            ,
		TCPAckFlag				=> rRx2TPUAckFlag           ,
		TCPPshFlag				=> rRx2TPUPshFlag           ,
		TCPRstFlag				=> rRx2TPURstFlag           ,
		TCPSynFlag				=> rRx2TPUSynFlag           ,
		TCPFinFlag				=> rRx2TPUFinFlag           ,
		TCPWinSize				=> rRx2TPUWinSize           ,
		TCPPLLen				=> rRx2TPUPayloadLen        ,
		RxWinSize				=> rRx2TPUFreeSpace         ,

		FixReq					=> User2TOERxReq			,
		FixSOP					=> TOE2UserRxSOP			,
		FixEOP					=> TOE2UserRxEOP			,
		FixValid				=> TOE2UserRxValid			,
		FixData					=> TOE2UserRxData			
	);

End Architecture rtl;