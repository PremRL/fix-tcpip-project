----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxTCPIP.vhd
-- Title        TxTCPTP Mapping Module
-- 
-- Version	  	0.02
-- Author       L.Ratchanon
-- Date         2020/10/23
-- Syntax       VHDL
-- Description  Add Queue module 
--
-- Version	  	0.01
-- Author       L.Ratchanon
-- Date         2020/09/11
-- Syntax       VHDL
-- Description  New Creation    
--
-- Mapping Module
----------------------------------------------------------------------------------
-- Note
-- TPUOperations :		Bit 0 => Queuing Enable (Permission to write data)
--			   		Bit 1 => Initialization (Connecting)
--					Bit 2 => Retransmission 
--					Bit 3 => Keep-alive 
--					Bit 4 => Termination (Not sending any data)
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TxTCPIP Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- User Interface
		UserDataVal		: in 	std_logic;
		UserDataSop		: in	std_logic;
		UserDataEop		: in	std_logic;
		UserDataIn		: in 	std_logic_vector( 7 downto 0 );
		UserDataLen		: in	std_logic_vector(15 downto 0 );
		
		UserMemAlFull	: out 	std_logic;
		
		-- TCP/IP Processor interface  
		-- Header field process 
		MACSouAddr		: in	std_logic_vector(47 downto 0 );
		MACDesAddr		: in 	std_logic_vector(47 downto 0 );
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );
		SouPort			: in 	std_logic_vector(15 downto 0 );
		DesPort			: in 	std_logic_vector(15 downto 0 );	
		SeqNum			: in	std_logic_vector(31 downto 0 );
		AckNum			: in	std_logic_vector(31 downto 0 );
		DataOffset		: in 	std_logic_vector( 3 downto 0 );
		Flags			: in	std_logic_vector( 8 downto 0 );
		Window			: in 	std_logic_vector(15 downto 0 );
		Urgent			: in 	std_logic_vector(15 downto 0 );
		TCPOptionMss	: in	std_logic_vector(15 downto 0 );
		-- Control I/F	
		TPUAckedSeqnum	: in	std_logic_vector(31 downto 0 );		
		TPUOperations	: in 	std_logic_vector( 3 downto 0 );		
		TPUAckedSeqnumEn: in	std_logic;
		TPUReset		: in 	std_logic;		
		TPUTxReq 		: in 	std_logic;	
		TPUPayloadEn	: in 	std_logic;			
		
		TPUPayloadLen	: out 	std_logic_vector(15 downto 0 );
		TPUPayloadReq   : out 	std_logic; 
		TPUOpReply		: out	std_logic;
		TPUInitReady	: out 	std_logic;
		TPULastData		: out	std_logic;
		TPUTxCtrlBusy 	: out 	std_logic;
	
		-- EMAC Interface	
		EMACReady		: in	std_logic;
		
		EMACReq			: out	std_logic;
		EMACDataOut		: out	std_logic_vector(7 downto 0);
		EMACDataOutVal	: out	std_logic;
		EMACDataOutSop	: out	std_logic;
		EMACDataOutEop	: out	std_logic
	);
End Entity TxTCPIP;	
	
Architecture rtl Of TxTCPIP Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component IPHdGen Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- TCP/IP Processor interface  
			-- IPv4 Header 
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );

			-- Control I/F
		DataLen			: in 	std_logic_vector(15 downto 0 ); -- MAX 8960 byte 
		PayloadEn		: in	std_logic;
		Start			: in	std_logic;
		TCPoption		: in 	std_logic;
		
		-- Memory Interface 
		RamIPHdWrData	: out 	std_logic_vector( 7 downto 0 );
		RamIPHdWrAddr	: out	std_logic_vector( 5 downto 0 );
		RamIPHdWrEn		: out 	std_logic
	);
	End Component IPHdGen;	

	Component TCPHdGen Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- TCP/IP Processor interface  
			-- IPv4 Pseudo Header  
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );
			-- TCP Header 
		SouPort			: in 	std_logic_vector(15 downto 0 );
		DesPort			: in 	std_logic_vector(15 downto 0 );	
		SeqNum			: in	std_logic_vector(31 downto 0 );
		AckNum			: in	std_logic_vector(31 downto 0 );
		DataOffset		: in 	std_logic_vector( 3 downto 0 );
		Flags			: in	std_logic_vector( 8 downto 0 );
		Window			: in 	std_logic_vector(15 downto 0 );
		Urgent			: in 	std_logic_vector(15 downto 0 );
		DataCheckSum	: in	std_logic_vector(15 downto 0 );
		OptionMss		: in 	std_logic_vector(15 downto 0 );
			-- Control I/F
		DataLen			: in 	std_logic_vector(15 downto 0 );
		PayloadEn		: in	std_logic;
		Start			: in	std_logic;
		
		-- Memory Interface 
		RamTCPHdWrData	: out 	std_logic_vector( 7 downto 0 );
		RamTCPHdWrAddr	: out	std_logic_vector( 5 downto 0 );
		RamTCPHdWrEn	: out 	std_logic
	);
	End Component TCPHdGen;	
	
	Component TxQueue Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
		
		-- Upper layer DataPath Interface
		UserDataVal		: in 	std_logic;
		UserDataSop		: in	std_logic;
		UserDataEop		: in	std_logic;
		UserDataIn		: in 	std_logic_vector( 7 downto 0 );
		UserDataLen		: in	std_logic_vector(15 downto 0 );
		
		UserMemAlFull	: out 	std_logic;
		
		-- TCP/IP Processor interface (TransCtrl)
		TPUAckedSeqnum	: in 	std_logic_vector(31 downto 0 );
		TPUSeqNum		: in 	std_logic_vector(31 downto 0 );
		TPUOperations	: in	std_logic_vector( 3 downto 0 );
		TPUAckedSeqnumEn: in	std_logic;
		TPUReset		: in	std_logic;
		TPUTxReq 		: in	std_logic;
		TPUPayloadEn	: in	std_logic;
	
		TPUPayloadLen	: out 	std_logic_vector(15 downto 0 );
		TPUPayloadReq   : out 	std_logic; 
		TPUOpReply		: out	std_logic;
		TPUInitReady	: out 	std_logic;
		TPULastData		: out	std_logic;	
		
		-- CheckSumCal Interface  
		Q2CBusy			: in 	std_logic;
		
		Q2CDataLen		: out	std_logic_vector(15 downto 0 );
		Q2CDataIn		: out 	std_logic_vector( 7 downto 0 );
		Q2CDataVal		: out 	std_logic;
		Q2CDataSop		: out	std_logic;
		Q2CDataEop		: out	std_logic;
		Q2CCheckSumEnd	: out	std_logic
	);
	End Component TxQueue;	
	
	Component CheckSumCal Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
	
		-- Queue Processor Interface (Data Input)
		Q2CDataLen		: in	std_logic_vector(15 downto 0 );
		Q2CDataIn		: in 	std_logic_vector( 7 downto 0 );
		Q2CDataVal		: in 	std_logic;
		Q2CDataSop		: in	std_logic;
		Q2CDataEop		: in	std_logic;
		Q2CCheckSumEnd	: in 	std_logic;
		
		Q2CBusy			: out 	std_logic;
		
		-- Memory Interface
		RamLoadWrData	: out 	std_logic_vector( 7 downto 0 );
		RamLoadWrAddr	: out	std_logic_vector(13 downto 0 );
		RamLoadWrEn		: out 	std_logic;
		
		-- TxOutCtrl Interface
		Start			: in	std_logic;
		PayloadEn		: in	std_logic;
		
		PayloadLen		: out	std_logic_vector(15 downto 0 );
		CheckSum		: out 	std_logic_vector(15 downto 0 );
		CheckSumCalEnd	: out 	std_logic
	);
	End Component CheckSumCal;	
	
	Component TxOutCtrl Is
	Port 
	(
		RstB			: in	std_logic;
		Clk				: in	std_logic;
		
		-- TCP/IP Processor Unit interface  
			-- MAC Header
		MACSouAddr		: in	std_logic_vector(47 downto 0 );
		MACDesAddr		: in 	std_logic_vector(47 downto 0 );
			-- IPv4 Header 
		IPSouAddr		: in 	std_logic_vector(31 downto 0 );
		IPDesAddr		: in 	std_logic_vector(31 downto 0 );
			-- TCP Header 
		SouPort			: in 	std_logic_vector(15 downto 0 );
		DesPort			: in 	std_logic_vector(15 downto 0 );	
		SeqNum			: in	std_logic_vector(31 downto 0 );
		AckNum			: in	std_logic_vector(31 downto 0 );
		DataOffset		: in 	std_logic_vector( 3 downto 0 );
		Flags			: in	std_logic_vector( 8 downto 0 );
		Window			: in 	std_logic_vector(15 downto 0 );
		Urgent			: in 	std_logic_vector(15 downto 0 );
			-- Control I/F
		TxPayloadEn		: in	std_logic;
		TxReq			: in	std_logic;
		TxBusy 			: out 	std_logic;
		
		-- Queuing&ChecksSumCal Interface 
		DataLen			: in 	std_logic_vector(15 downto 0 );
		CheckSumCalData	: in 	std_logic_vector(15 downto 0 );
		CheckSumCalEnd	: in	std_logic;
		
		-- IP Header Interface		
		RamIPHdRdData	: in	std_logic_vector( 7 downto 0 );
		RamIPHdRdAddr	: out	std_logic_vector( 5 downto 0 );
		IPSouAddrGen	: out 	std_logic_vector(31 downto 0 );		
		IPDesAddrGen	: out 	std_logic_vector(31 downto 0 );
		
		-- TCP Header Interface		
		SouPortGen		: out 	std_logic_vector(15 downto 0 );	
		DesPortGen		: out 	std_logic_vector(15 downto 0 );
	    SeqNumGen		: out 	std_logic_vector(31 downto 0 );	
		AckNumGen		: out 	std_logic_vector(31 downto 0 );
		DataOffsetGen	: out 	std_logic_vector( 3 downto 0 );
		FlagsGen		: out 	std_logic_vector( 8 downto 0 );
		WindowGen		: out 	std_logic_vector(15 downto 0 );
		UrgentGen		: out 	std_logic_vector(15 downto 0 );
		DataChecksum	: out 	std_logic_vector(15 downto 0 );
	
		RamTCPHdRdData	: in 	std_logic_vector( 7 downto 0 );
		RamTCPHdRdAddr	: out	std_logic_vector( 5 downto 0 );
		
		-- Payload Memory Interface	
		RamLoadRdData	: in 	std_logic_vector( 7 downto 0 );
		RamLoadRdAddr	: out 	std_logic_vector(13 downto 0 );
		
		-- Control Interface 
		CtrlDataLen		: out 	std_logic_vector(15 downto 0 );
		CtrlStart		: out	std_logic;
		CtrlPayloadEn	: out	std_logic;
		
		-- EMAC Interface	
		EMACReady		: in	std_logic;
		
		EMACReq			: out 	std_logic;
		EMACDataOut		: out	std_logic_vector(7 downto 0);
		EMACDataOutVal	: out	std_logic;
		EMACDataOutSop	: out	std_logic;
		EMACDataOutEop	: out	std_logic
	);
	End Component TxOutCtrl;

	Component RamTCPIPHd Is
	Port
	(
		clock			: IN STD_LOGIC  := '1';
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren			: IN STD_LOGIC  := '0';
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	End Component RamTCPIPHd;
	
	Component RamData16kx8 Is
	Port
	(
		clock			: IN STD_LOGIC  := '1';
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wren			: IN STD_LOGIC  := '0';
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	End Component RamData16kx8;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- TxOutCtrl For TCP/IP Header Generating signal 
	signal rIPSouAddrGen		: std_logic_vector(31 downto 0 );	
	signal rIPDesAddrGen        : std_logic_vector(31 downto 0 );
	signal rSouPortGen			: std_logic_vector(15 downto 0 );	
	signal rDesPortGen		    : std_logic_vector(15 downto 0 );
	signal rSeqNumGen		    : std_logic_vector(31 downto 0 );	
	signal rAckNumGen		    : std_logic_vector(31 downto 0 );
	signal rDataOffsetGen	    : std_logic_vector( 3 downto 0 );
	signal rFlagsGen		    : std_logic_vector( 8 downto 0 );
	signal rWindowGen		    : std_logic_vector(15 downto 0 );
	signal rUrgentGen	        : std_logic_vector(15 downto 0 );
	signal rDataCheckSum		: std_logic_vector(15 downto 0 );
	
	-- TxOutCtrl Control signal 
	signal rCtrlDataLen			: std_logic_vector(15 downto 0 );
	signal rCtrlStart			: std_logic;
	signal rCtrlPayloadEn	    : std_logic;
	
	-- Queue to CheckSumCal signal  
	signal rQ2CDataLen			: std_logic_vector(15 downto 0 );
	signal rQ2CDataIn			: std_logic_vector( 7 downto 0 );
	signal rQ2CDataSop	        : std_logic;
	signal rQ2CDataEop	        : std_logic;
	signal rQ2CDataVal	        : std_logic;
	signal rQ2CBusy             : std_logic;
	signal rQ2CCheckSumEnd		: std_logic;
	
	-- CheckSumCal to TxOutCtrl signal 
	signal rCS2TOCDataLen		: std_logic_vector(15 downto 0 );
	signal rCS2TOCCheckSum		: std_logic_vector(15 downto 0 );
	signal rCS2TOCCheckSumEnd	: std_logic;

	-- Ram IP header signal 
	signal rRamIPHdWrData		: std_logic_vector( 7 downto 0 );
	signal rRamIPHdWrAddr		: std_logic_vector( 5 downto 0 );
	signal rRamIPHdWrEn			: std_logic;
	
	signal rRamIPHdRdData		: std_logic_vector( 7 downto 0 );
	signal rRamIPHdRdAddr       : std_logic_vector( 5 downto 0 );
	
	-- Ram TCP header signal 
	signal rRamTCPHdWrData		: std_logic_vector( 7 downto 0 );
	signal rRamTCPHdWrAddr		: std_logic_vector( 5 downto 0 );
	signal rRamTCPHdWrEn		: std_logic;

	signal rRamTCPHdRdData		: std_logic_vector( 7 downto 0 );
	signal rRamTCPHdRdAddr      : std_logic_vector( 5 downto 0 );
	
	-- Ram Payload header signal 
	signal rRamLoadWrData		: std_logic_vector( 7 downto 0 );
	signal rRamLoadWrAddr		: std_logic_vector(13 downto 0 );
	signal rRamLoadWrEn			: std_logic;

	signal rRamLoadRdData		: std_logic_vector( 7 downto 0 );
	signal rRamLoadRdAddr      	: std_logic_vector(13 downto 0 );
	
Begin 
----------------------------------------------------------------------------------
-- DFF : Component Mapping 
----------------------------------------------------------------------------------
	
	u_TxOutCtrl : TxOutCtrl
	Port map 
	(
		RstB				=> RstB					,
		Clk				    => Clk                  ,

		MACSouAddr		    => MACSouAddr	        ,
		MACDesAddr		    => MACDesAddr	        ,
		IPSouAddr		    => IPSouAddr	        ,
		IPDesAddr		    => IPDesAddr	        ,
		SouPort			    => SouPort		        ,
		DesPort			    => DesPort		        ,
		SeqNum			    => SeqNum		        ,
		AckNum			    => AckNum		        ,
		DataOffset		    => DataOffset	        ,
		Flags			    => Flags		        ,
		Window			    => Window		        ,
		Urgent		        => Urgent		        ,
		TxPayloadEn		    => TPUPayloadEn	    	,
		TxReq			    => TPUTxReq		    	,
		TxBusy 			    => TPUTxCtrlBusy 		,
		
		DataLen				=> rCS2TOCDataLen		,
		CheckSumCalData		=> rCS2TOCCheckSum      ,
		CheckSumCalEnd		=> rCS2TOCCheckSumEnd   ,

		RamIPHdRdData		=> rRamIPHdRdData		,
		RamIPHdRdAddr	    => rRamIPHdRdAddr	    ,
		IPSouAddrGen		=> rIPSouAddrGen		,
		IPDesAddrGen		=> rIPDesAddrGen		,

		SouPortGen			=> rSouPortGen			,
		DesPortGen		    => rDesPortGen		    ,
	    SeqNumGen		    => rSeqNumGen		    ,
		AckNumGen		    => rAckNumGen		    ,
		DataOffsetGen	    => rDataOffsetGen	    ,
		FlagsGen		    => rFlagsGen		    ,
		WindowGen		    => rWindowGen		    ,
		UrgentGen		    => rUrgentGen		    ,
		DataChecksum		=> rDataChecksum		,
		RamTCPHdRdData	    => rRamTCPHdRdData	    ,
		RamTCPHdRdAddr	    => rRamTCPHdRdAddr	    ,

		RamLoadRdData	    => rRamLoadRdData	    ,
		RamLoadRdAddr	    => rRamLoadRdAddr	    ,

		CtrlDataLen			=> rCtrlDataLen		    ,
		CtrlStart			=> rCtrlStart		    ,
		CtrlPayloadEn		=> rCtrlPayloadEn		,

		EMACReady			=> EMACReady			,
	
		EMACReq			    => EMACReq			    ,
		EMACDataOut		    => EMACDataOut		    ,
		EMACDataOutVal	    => EMACDataOutVal	    ,
		EMACDataOutSop	    => EMACDataOutSop	    ,
		EMACDataOutEop		=> EMACDataOutEop		
	);
	
	u_IPHdGen : IPHdGen
	Port map
	(
		RstB				=> RstB					,
		Clk				    => Clk                  ,
	
		IPSouAddr		    => rIPSouAddrGen        ,
		IPDesAddr		    => rIPDesAddrGen        ,
		
		DataLen			    => rCtrlDataLen	        ,
		PayloadEn		    => rCtrlPayloadEn	    ,
		Start			    => rCtrlStart    	    ,
		TCPoption			=> rFlagsGen(1)			, -- SYN
	
		RamIPHdWrData	    => rRamIPHdWrData	    ,
		RamIPHdWrAddr	    => rRamIPHdWrAddr	    ,
		RamIPHdWrEn		    => rRamIPHdWrEn		
	);
	
	u_TCPHdGen : TCPHdGen
	Port map 
	(
		RstB				=> RstB					,
		Clk				    => Clk                  ,

		IPSouAddr		    => rIPSouAddrGen        ,
		IPDesAddr		    => rIPDesAddrGen        ,
	
		SouPort			    => rSouPortGen		    ,
		DesPort			    => rDesPortGen		    ,
		SeqNum			    => rSeqNumGen		    ,
		AckNum			    => rAckNumGen		    ,
		DataOffset		    => rDataOffsetGen	    ,
		Flags			    => rFlagsGen		    ,
		Window			    => rWindowGen		    ,
		Urgent			    => rUrgentGen		    ,
		DataCheckSum	    => rDataCheckSum        ,
		OptionMss			=> TCPOptionMss			, 

		DataLen			    => rCtrlDataLen	        ,
		PayloadEn		    => rCtrlPayloadEn       ,
		Start			    => rCtrlStart           ,
		
		RamTCPHdWrData	    => rRamTCPHdWrData	    ,
		RamTCPHdWrAddr	    => rRamTCPHdWrAddr	    ,
		RamTCPHdWrEn	    => rRamTCPHdWrEn		
	);
	
	u_CheckSumCal : CheckSumCal
	Port map 
	(
		RstB				=> RstB					,
		Clk				    => Clk                  ,
		
		Q2CDataLen			=> rQ2CDataLen			,
	    Q2CDataIn			=> rQ2CDataIn		    ,
	    Q2CDataVal			=> rQ2CDataVal		    ,
	    Q2CDataSop		 	=> rQ2CDataSop		    ,
	    Q2CDataEop			=> rQ2CDataEop		    ,
		Q2CCheckSumEnd		=> rQ2CCheckSumEnd		,
		Q2CBusy			    => rQ2CBusy             ,

		RamLoadWrData	    => rRamLoadWrData	    ,
		RamLoadWrAddr	    => rRamLoadWrAddr	    ,
		RamLoadWrEn		    => rRamLoadWrEn		    ,

		Start			    => rCtrlStart           ,
		PayloadEn		    => rCtrlPayloadEn		,
		PayloadLen			=> rCS2TOCDataLen		, 
		CheckSum		    => rCS2TOCCheckSum 	    ,
		CheckSumCalEnd		=> rCS2TOCCheckSumEnd   	
	);
	
	u_TxQueue : TxQueue 
	Port map 
	(	
		RstB				=> RstB					,	
		Clk				    => Clk				    ,

		UserDataVal		    => UserDataVal		    ,
		UserDataSop		    => UserDataSop		    ,
		UserDataEop		    => UserDataEop		    ,
		UserDataIn		    => UserDataIn		    ,
		UserDataLen		    => UserDataLen		    ,
		UserMemAlFull	    => UserMemAlFull	    ,

		TPUAckedSeqnum	    => TPUAckedSeqnum		,		
		TPUSeqNum		    => SeqNum				,		
		TPUOperations	    => TPUOperations		,
		TPUAckedSeqnumEn    => TPUAckedSeqnumEn		,
		TPUReset		    => TPUReset		        ,
		TPUTxReq 			=> TPUTxReq 		    ,
		TPUPayloadEn		=> TPUPayloadEn	        ,
		TPUPayloadLen	    => TPUPayloadLen	    ,
		TPUPayloadReq       => TPUPayloadReq        ,
		TPUOpReply		    => TPUOpReply		    ,
		TPUInitReady	    => TPUInitReady	        ,
		TPULastData		    => TPULastData		    ,
		

		Q2CBusy			    => rQ2CBusy			    ,
		Q2CDataLen		    => rQ2CDataLen		    ,
		Q2CDataIn		    => rQ2CDataIn		    ,
		Q2CDataVal		    => rQ2CDataVal		    ,
		Q2CDataSop		    => rQ2CDataSop		    ,
		Q2CDataEop		    => rQ2CDataEop		    ,
		Q2CCheckSumEnd	    => rQ2CCheckSumEnd	    
	);
	
	u_RamIPHd : RamTCPIPHd
	Port map 
	(
		clock				=> Clk					,

		data				=> rRamIPHdWrData		,						
		wraddress			=> rRamIPHdWrAddr		,	
		wren				=> rRamIPHdWrEn			,

		rdaddress           => rRamIPHdRdAddr       ,
		q					=> rRamIPHdRdData	
	);
	
	u_RamTCPHd : RamTCPIPHd
	Port map 
	(
		clock				=> Clk					,

		data				=> rRamTCPHdWrData		,						
		wraddress			=> rRamTCPHdWrAddr		,	
		wren				=> rRamTCPHdWrEn		,

		rdaddress           => rRamTCPHdRdAddr      ,
		q					=> rRamTCPHdRdData	
	);
	
	u_RamLoad16kx8 : RamData16kx8
	Port map
	(
		clock				=> Clk					,
	
		data			    => rRamLoadWrData       ,
		wraddress	        => rRamLoadWrAddr       ,
		wren	            => rRamLoadWrEn         ,
	
		rdaddress           => rRamLoadRdAddr       ,
		q			        => rRamLoadRdData
	);
	
End Architecture rtl;