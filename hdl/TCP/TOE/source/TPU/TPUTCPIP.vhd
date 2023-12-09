----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TPUTCPIP.vhd
-- Title        TPUTCPIP For TCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/11/04
-- Syntax       VHDL
-- Description      
-- 
-- TCP/IP Processing Unit  
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

Entity TPUTCPIP Is
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
End Entity TPUTCPIP;	
	
Architecture rtl Of TPUTCPIP Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------

	Component StateCtrl Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		-- User Interface	
		UserSrcPort     		: in	std_logic_vector(15 downto 0 );
		UserDesPort     		: in	std_logic_vector(15 downto 0 );
		UserConnectReq			: in	std_logic;
		UserTerminateReq		: in 	std_logic;
		
		UserStatus				: out 	std_logic_vector( 3 downto 0 );	
		UserPSHFlagset			: out	std_logic;
		UserFINFlagset 			: out	std_logic;
		UserRSTFlagset			: out 	std_logic;
		
		-- User Network register Interface  
		UNG2TCPSenderMACAddr	: in 	std_logic_vector(47 downto 0 );
		UNG2TCPTargetMACAddr	: in	std_logic_vector(47 downto 0 );
		UNG2TCPSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		UNG2TCPTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		
		UNG2TCPAddrVal			: in	std_logic;
	
		-- TCPCtrl Interface
		CtrlFlags				: in 	std_logic_vector( 8 downto 0 ); 
		CtrlLastSent			: in	std_logic;
		CtrlAllRecv				: in	std_logic;	
		
	    CtrlSenderMACAddr		: out 	std_logic_vector(47 downto 0 );
		CtrlTargetMACAddr		: out	std_logic_vector(47 downto 0 );
		CtrlSenderIpAddr		: out 	std_logic_vector(31 downto 0 );
		CtrlTargetIpAddr		: out 	std_logic_vector(31 downto 0 );
		CtrlSrcPort     		: out	std_logic_vector(15 downto 0 );
		CtrlDesPort     		: out	std_logic_vector(15 downto 0 );
		CtrlStateMach			: out 	std_logic_vector( 7 downto 0 );
		CtrlDataEn				: out 	std_logic;
		CtrlRST					: out 	std_logic;
		CtrlAddrVal				: out	std_logic
	);
	End Component StateCtrl;
	
	Component RxTPUCtrl Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
	
		-- TCPCtrl Interface	
	    CtrlSenderMACAddr		: in 	std_logic_vector(47 downto 0 );
		CtrlTargetMACAddr		: in	std_logic_vector(47 downto 0 );
		CtrlSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlSrcPort     		: in	std_logic_vector(15 downto 0 );
		CtrlDesPort     		: in	std_logic_vector(15 downto 0 );
		CtrlStateMach			: in 	std_logic_vector( 7 downto 0 );
		CtrlRST					: in 	std_logic;
		CtrlAddrVal				: in	std_logic;
		
		CtrlFlags				: out 	std_logic_vector( 8 downto 0 ); 
		CtrlAllRecv				: out	std_logic;	
		
		-- TxTPUCtrl Interface
		Tx2RxTPUSeqNum			: in	std_logic_vector(31 downto 0 );
		Tx2RxTPUCtrl			: in	std_logic_vector( 3 downto 0 );
		Tx2RxTPURetransEn		: in 	std_logic_vector( 3 downto 0 );
		
		Rx2TxTPUAckNum			: out	std_logic_vector(31 downto 0 );
		Rx2TxTPUSeqNumAcked		: out	std_logic_vector(31 downto 0 );
		Rx2TxTPURecWindow 		: out 	std_logic_vector(15 downto 0 );
		Rx2TxTPUWindow			: out	std_logic_vector(15 downto 0 );
		Rx2TxTPURetransOption	: out	std_logic_vector( 3 downto 0 );
		Rx2TxTPUAckNumUdt 		: out	std_logic;
		Rx2TxTPUSeqNumEn		: out	std_logic;
		
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
	End Component RxTPUCtrl;
	
	Component TxTPUCtrl Is
	Port 
	(
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		-- TCPCtrl Interface
	    CtrlSenderMACAddr		: in 	std_logic_vector(47 downto 0 );
		CtrlTargetMACAddr		: in	std_logic_vector(47 downto 0 );
		CtrlSenderIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlTargetIpAddr		: in 	std_logic_vector(31 downto 0 );
		CtrlSrcPort     		: in	std_logic_vector(15 downto 0 );
		CtrlDesPort     		: in	std_logic_vector(15 downto 0 );
		CtrlStateMach			: in 	std_logic_vector( 7 downto 0 );
		CtrlDataEn				: in 	std_logic;
		CtrlRST					: in 	std_logic;
		
		CtrlLastSent			: out	std_logic;
		
		-- RxCtrl I/F 
		Rx2TxTPUAckNum			: in	std_logic_vector(31 downto 0 );
		Rx2TxTPUSeqNumAcked		: in	std_logic_vector(31 downto 0 );
		Rx2TxTPURecWindow		: in	std_logic_vector(15 downto 0 );
		Rx2TxTPUWindow			: in	std_logic_vector(15 downto 0 );
		Rx2TxTPURetransOption	: in	std_logic_vector( 3 downto 0 );
		Rx2TxTPUAckNumUdt 		: in	std_logic;
		Rx2TxTPUSeqNumEn		: in	std_logic;

		Tx2RxTPUSeqNum			: out	std_logic_vector(31 downto 0 );
		Tx2RxTPUCtrl			: out	std_logic_vector( 3 downto 0 );
		Tx2RxTPURetransEn		: out 	std_logic_vector( 3 downto 0 );
		
		-- TxTCPIP I/F 
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
		-- Control I/F	
		TPU2TxSeqNumIndex		: out 	std_logic_vector(31 downto 0 );	
		TPU2TxSeqNumIndexEn 	: out 	std_logic;	
		TPU2TxOperations		: out 	std_logic_vector( 3 downto 0 );			
		TPU2TxReset				: out 	std_logic;		
		TPU2TxTxReq 			: out 	std_logic;			
		TPU2TxPayloadEn			: out 	std_logic
	);
	End Component TxTPUCtrl;
	
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- StateCtrl to Tx/RxTPUCtrl I/F 
	signal	rCtrlSenderMACAddr		: std_logic_vector(47 downto 0 );
	signal 	rCtrlTargetMACAddr		: std_logic_vector(47 downto 0 );
	signal  rCtrlSenderIpAddr		: std_logic_vector(31 downto 0 );
	signal  rCtrlTargetIpAddr		: std_logic_vector(31 downto 0 );
	signal  rCtrlSrcPort     		: std_logic_vector(15 downto 0 );
	signal  rCtrlDesPort     		: std_logic_vector(15 downto 0 );
	signal  rCtrlStateMach			: std_logic_vector( 7 downto 0 );
	signal  rCtrlDataEn				: std_logic;
	signal  rCtrlRST				: std_logic;
	signal  rCtrlAddrVal			: std_logic;
	
	-- Tx/RxTPUCtrl to StateCtrl I/F 
	signal	rCtrlFlags				: std_logic_vector( 8 downto 0 ); 
	signal  rCtrlLastSent			: std_logic;
	signal  rCtrlAllRecv			: std_logic;
	
	-- TxTPUCtrl to RxTPUCtrl I/F 
	signal  rTx2RxTPUTMNextSeqNum	: std_logic_vector(31 downto 0 );
	signal  rTx2RxTPUSeqNum			: std_logic_vector(31 downto 0 );
	signal  rTx2RxTPUCtrl			: std_logic_vector( 3 downto 0 );
	signal  rTx2RxTPURetransEn		: std_logic_vector( 3 downto 0 );
	
	-- RxTPUCtrl to TxTPUCtrl I/F 
	signal  rRx2TxTPUAckNum			: std_logic_vector(31 downto 0 );
	signal  rRx2TxTPUSeqNumAcked	: std_logic_vector(31 downto 0 );
	signal  rRx2TxTPURecWindow		: std_logic_vector(15 downto 0 );
	signal  rRx2TxTPUWindow			: std_logic_vector(15 downto 0 );
	signal  rRx2TxTPURetransOption	: std_logic_vector( 3 downto 0 );
	signal  rRx2TxTPUAckNumUdt 		: std_logic;
	signal  rRx2TxTPUSYNUdt			: std_logic;
	
	-- RxTPUCtrl(Timer) to TxTPUCtrl I/F 
	signal  rTM2TxTPUSeqNum			: std_logic_vector(31 downto 0 );
	signal  rRx2TxTPUSeqNumEn		: std_logic;
	signal  rTM2TxTPUTimerFull		: std_logic;

Begin 

----------------------------------------------------------------------------------
-- DFF : Component Mapping 
----------------------------------------------------------------------------------
	
	u_rStateCtrl : StateCtrl
	Port map
	(
		RstB					=> RstB						,
	    Clk						=> Clk						,
	
		UserSrcPort     		=> UNG2TCPSrcPort     		,
		UserDesPort     		=> UNG2TCPDesPort     		,
		UserConnectReq			=> UserConnectReq			,
		UserTerminateReq		=> UserTerminateReq		    ,

		UserStatus				=> UserStatus				,
		UserPSHFlagset			=> UserPSHFlagset			,
        UserFINFlagset 			=> UserFINFlagset 			,
		UserRSTFlagset			=> UserRSTFlagset			,
	
		UNG2TCPSenderMACAddr	=> UNG2TCPSenderMACAddr	    ,
		UNG2TCPTargetMACAddr	=> UNG2TCPTargetMACAddr	    ,
		UNG2TCPSenderIpAddr		=> UNG2TCPSenderIpAddr		,
		UNG2TCPTargetIpAddr		=> UNG2TCPTargetIpAddr		,
	
		UNG2TCPAddrVal			=> UNG2TCPAddrVal			,
		
		CtrlFlags				=> rCtrlFlags				,
		CtrlLastSent			=> rCtrlLastSent			,
		CtrlAllRecv				=> rCtrlAllRecv				, 

		CtrlSenderMACAddr		=> rCtrlSenderMACAddr		,
		CtrlTargetMACAddr		=> rCtrlTargetMACAddr		,
		CtrlSenderIpAddr		=> rCtrlSenderIpAddr		,
		CtrlTargetIpAddr		=> rCtrlTargetIpAddr		,
		CtrlSrcPort     		=> rCtrlSrcPort     		,
		CtrlDesPort     		=> rCtrlDesPort     		,
		CtrlStateMach			=> rCtrlStateMach			,
		CtrlDataEn				=> rCtrlDataEn				,
	    CtrlRST					=> rCtrlRST					,
		CtrlAddrVal				=> rCtrlAddrVal				
	);
	
	u_rRxTPUCtrl : RxTPUCtrl
	Port map
	(
		RstB					=> RstB					 	,
	    Clk						=> Clk						,

		CtrlSenderMACAddr		=> rCtrlSenderMACAddr		,
		CtrlTargetMACAddr		=> rCtrlTargetMACAddr		,
		CtrlSenderIpAddr		=> rCtrlSenderIpAddr		,
		CtrlTargetIpAddr		=> rCtrlTargetIpAddr		,
		CtrlSrcPort     		=> rCtrlSrcPort     		,
		CtrlDesPort     		=> rCtrlDesPort     		,
        CtrlStateMach			=> rCtrlStateMach			,
		CtrlRST					=> rCtrlRST					,
		CtrlAddrVal				=> rCtrlAddrVal				,

		CtrlFlags				=> rCtrlFlags				,
		CtrlAllRecv				=> rCtrlAllRecv				, 

		Tx2RxTPUSeqNum			=> rTx2RxTPUSeqNum			,
        Tx2RxTPUCtrl			=> rTx2RxTPUCtrl			,
		Tx2RxTPURetransEn		=> rTx2RxTPURetransEn		,

		Rx2TxTPUAckNum			=> rRx2TxTPUAckNum			,
		Rx2TxTPUSeqNumAcked		=> rRx2TxTPUSeqNumAcked		,
		Rx2TxTPURecWindow 		=> rRx2TxTPURecWindow 		,
		Rx2TxTPUWindow			=> rRx2TxTPUWindow			,
		Rx2TxTPURetransOption	=> rRx2TxTPURetransOption	,
        Rx2TxTPUAckNumUdt 		=> rRx2TxTPUAckNumUdt 		,
		Rx2TxTPUSeqNumEn		=> rRx2TxTPUSeqNumEn		,

		Rx2TPUSeqNum			=> Rx2TPUSeqNum			    ,
	    Rx2TPUAckNum			=> Rx2TPUAckNum			    ,
		Rx2TPUPayloadLen		=> Rx2TPUPayloadLen		    ,
		Rx2TPUWinSize			=> Rx2TPUWinSize			,
		Rx2TPUFreeSpace			=> Rx2TPUFreeSpace			,
		Rx2TPUAckFlag			=> Rx2TPUAckFlag			,
		Rx2TPUPshFlag           => Rx2TPUPshFlag            ,
		Rx2TPURstFlag			=> Rx2TPURstFlag			,
		Rx2TPUSynFlag           => Rx2TPUSynFlag            ,
		Rx2TPUFinFlag			=> Rx2TPUFinFlag			,
		Rx2TPUPktValid          => Rx2TPUPktValid           ,
		Rx2TPUSeqNumError		=> Rx2TPUSeqNumError		,

		TPU2RxSenderMACAddr		=> TPU2RxSenderMACAddr		,
		TPU2RxTargetMACAddr		=> TPU2RxTargetMACAddr		,
		TPU2RxSenderIpAddr		=> TPU2RxSenderIpAddr		,
		TPU2RxTargetIpAddr		=> TPU2RxTargetIpAddr		,
		TPU2RxExpSeqNum			=> TPU2RxExpSeqNum			,
		TPU2RxSrcPort     		=> TPU2RxSrcPort     		,
		TPU2RxDesPort     		=> TPU2RxDesPort     		,
		TPU2RxInitFlag			=> TPU2RxInitFlag			,
		TPU2RxDecodeEn			=> TPU2RxDecodeEn			,
		TPU2RxDataTransEn		=> TPU2RxDataTransEn		,
		TPU2RxAddrVal			=> TPU2RxAddrVal			
	);
	
	u_rTxTPUCtrl : TxTPUCtrl
	Port map
	(
		RstB					=> RstB						,
	    Clk						=> Clk						,

		CtrlSenderMACAddr		=> rCtrlSenderMACAddr		,
		CtrlTargetMACAddr		=> rCtrlTargetMACAddr		,
		CtrlSenderIpAddr		=> rCtrlSenderIpAddr		,
		CtrlTargetIpAddr		=> rCtrlTargetIpAddr		,
		CtrlSrcPort     		=> rCtrlSrcPort     		,
        CtrlDesPort     		=> rCtrlDesPort     		,
		CtrlStateMach			=> rCtrlStateMach			,
        CtrlDataEn				=> rCtrlDataEn				,
		CtrlRST					=> rCtrlRST					,

		CtrlLastSent			=> rCtrlLastSent			,

        Rx2TxTPUAckNum			=> rRx2TxTPUAckNum			,
		Rx2TxTPUSeqNumAcked		=> rRx2TxTPUSeqNumAcked		,
        Rx2TxTPURecWindow		=> rRx2TxTPURecWindow		,
		Rx2TxTPUWindow			=> rRx2TxTPUWindow			,
		Rx2TxTPURetransOption	=> rRx2TxTPURetransOption	,
		Rx2TxTPUAckNumUdt 		=> rRx2TxTPUAckNumUdt 		,
		Rx2TxTPUSeqNumEn		=> rRx2TxTPUSeqNumEn		,

		Tx2RxTPUSeqNum			=> rTx2RxTPUSeqNum			,
	    Tx2RxTPUCtrl			=> rTx2RxTPUCtrl			,
		Tx2RxTPURetransEn		=> rTx2RxTPURetransEn		,

		Tx2TPUPayloadLen		=> Tx2TPUPayloadLen		    ,
		Tx2TPUPayloadReq   		=> Tx2TPUPayloadReq   		,
		Tx2TPUOpReply			=> Tx2TPUOpReply			,
		Tx2TPUInitReady			=> Tx2TPUInitReady			,
		Tx2TPULastData			=> Tx2TPULastData			,
		Tx2TPUTxCtrlBusy 		=> Tx2TPUTxCtrlBusy 		,

        TPU2TxMACSouAddr		=> TPU2TxMACSouAddr		    ,
		TPU2TxMACDesAddr		=> TPU2TxMACDesAddr		    ,
		TPU2TxIPSouAddr			=> TPU2TxIPSouAddr			,
		TPU2TxIPDesAddr			=> TPU2TxIPDesAddr			,
		TPU2TxSouPort			=> TPU2TxSouPort			,
		TPU2TxDesPort			=> TPU2TxDesPort			,
		TPU2TxSeqNum			=> TPU2TxSeqNum			    ,
		TPU2TxAckNum			=> TPU2TxAckNum			    ,
		TPU2TxDataOffset		=> TPU2TxDataOffset		    ,
		TPU2TxFlags				=> TPU2TxFlags				,
		TPU2TxWindow			=> TPU2TxWindow			    ,
		TPU2TxUrgent			=> TPU2TxUrgent			    ,
		TPU2TxSeqNumIndex		=> TPU2TxSeqNumIndex		,
		TPU2TxSeqNumIndexEn 	=> TPU2TxSeqNumIndexEn 	    ,
		TPU2TxOperations		=> TPU2TxOperations		    ,
		TPU2TxReset				=> TPU2TxReset				,
		TPU2TxTxReq 			=> TPU2TxTxReq 			    ,
		TPU2TxPayloadEn			=> TPU2TxPayloadEn			
	);

End Architecture rtl;