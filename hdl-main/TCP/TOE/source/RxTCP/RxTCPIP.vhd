----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		ClkAdaptor.vhd
-- Title		
--
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         

-- Version      1.00
-- Author       K.Norawit
-- Date         2020/11/04
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--	Comment below is FYI note
--	1.  
--	2.	
--	3.	
--	4.	
--	5.	
--	6.	
--	7.		
--	8.	
--		
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity RxTCPIP Is
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
End Entity RxTCPIP;

Architecture rt1 Of RxTCPIP Is
----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
	
	Component ClkAdaptor Is
	Port 
	(	
		MacRstB					: in	std_logic;
		RstB					: in	std_logic;
		RxMacClk				: in	std_logic;
		Clk						: in	std_logic; 
		
		--	Input from RxMAC (RxMacClk)
		MacSOP					: in	std_logic;
		MacValid				: in	std_logic;
		MacEOP					: in	std_logic;
		MacData					: in	std_logic_vector( 7 downto 0 );
		MacError				: in	std_logic_vector( 1 downto 0 );
		
		-- TestErrorPort (RxMacClk)
		PktDropError			: out	std_logic;
		
		-- Output to RxTCPIP (Clk)
		SOP						: out	std_logic;
		DataValid				: out	std_logic;
		EOP						: out	std_logic;
		Data					: out	std_logic_vector( 7 downto 0 );
		RxMacError				: out	std_logic_vector( 1 downto 0 )
	);
	End Component ClkAdaptor;
	
	Component RxHeaderDec Is
	Port 
	(	
		RstB					: in	std_logic;
		Clk						: in	std_logic; 
		
		--	Input from RxMAC and TPU
		MacSOP					: in	std_logic;
		MacValid				: in	std_logic;
		MacEOP					: in	std_logic;
		MacData					: in	std_logic_vector( 7 downto 0 );
		MacError				: in	std_logic_vector( 1 downto 0 );
		DecodeEn				: in	std_logic;
		InitEn					: in	std_logic;
		ExpSeqNum				: in	std_logic_vector( 31 downto 0 );
		
		-- Input from User for IP and Port checking
		UserValid				: in	std_logic;
		UserSrcMac				: in	std_logic_vector( 47 downto 0 );
		UserDesMac				: in	std_logic_vector( 47 downto 0 );
		UserSrcIP				: in	std_logic_vector( 31 downto 0 );
		UserDesIP				: in	std_logic_vector( 31 downto 0 );
		UserSrcPort             : in	std_logic_vector( 15 downto 0 );
		UserDesPort             : in	std_logic_vector( 15 downto 0 );
		
		-- Validation and error flag for (error) condition checking
		MacAddrValid			: out	std_logic_vector( 1 downto 0 );
		IPVerValid				: out	std_logic;
        ProtocolValid			: out	std_logic;
        SrcIPValid				: out	std_logic;
        DesIPValid				: out	std_logic;
        SrcPortValid			: out	std_logic;
        DesPortValid			: out	std_logic;
        CheckSumValid			: out	std_logic_vector( 1 downto 0 );
        MacErrorFlag			: out	std_logic_vector( 1 downto 0 );
        SeqNumError				: out	std_logic;
		
        -- DataCtrl I/F
        WinUpReq				: out	std_logic;
     
        --	Decoded fields and Valid from TCP header to TPU
        PktValid				: out	std_logic;
        TCPSeqNum				: out	std_logic_vector( 31 downto 0 );
        TCPAck					: out	std_logic_vector( 31 downto 0 );
        TCPAckFlag				: out	std_logic;
        TCPPshFlag				: out	std_logic;
        TCPRstFlag				: out	std_logic;
        TCPSynFlag				: out	std_logic;
        TCPFinFlag				: out	std_logic;
        TCPWinSize				: out	std_logic_vector( 15 downto 0 );
        PayloadLen				: out	std_logic_vector( 15 downto 0 );
		
		-- Queue Writing I/F
		QWrFull					: in	std_logic;
		QCnt					: in	std_logic_vector( 7 downto 0 );	-- no use
		QWrReq					: out	std_logic;
		QWrData					: out	std_logic_vector( 16 downto 0 );
		
        -- Payload Writing I/F
        PLRamWrData				: out	std_logic_vector( 7 downto 0 );
        PLRamWrEn				: out	std_logic;
        PLRamWrAddr				: out	std_logic_vector( 15 downto 0 )
	);
	End Component RxHeaderDec;
	
	-- Payload Ram
	Component Ram64kx8 Is
	Port 
	(	
		clock		: in	std_logic;
		data		: in	std_logic_vector (7 downto 0);
		rdaddress	: in	std_logic_vector (15 downto 0);
		wraddress	: in 	std_logic_vector (15 downto 0);
		wren		: in 	std_logic;
		q			: out 	std_logic_vector (7 downto 0)
		
	);
	End Component Ram64kx8;
	
	-- Queue FIFO
	Component FIFO256x17 Is
	Port 
	(	
		clock		: in	std_logic ;
		data		: in	std_logic_vector (16 downto 0);
		rdreq		: in	std_logic ;
		sclr		: in	std_logic ;
		wrreq		: in	std_logic ;
		empty		: out 	std_logic ;
		full		: out 	std_logic ;
		q			: out 	std_logic_vector (16 downto 0);
		usedw		: out 	std_logic_vector (7 downto 0)
		
	);
	End Component FIFO256x17;
	
	Component RxDataCtrl Is
	Port 
	(	
		RstB					: in	std_logic;
		Clk						: in	std_logic;
		
		-- TPU I/F
		DataTransEn				: in	std_logic; 
		FreeSpace				: out	std_logic_vector( 15 downto 0 );
		
        -- Queue management from RxHeaderDec
		RxWinUpReq				: in	std_logic;
		RamWrAddr				: in	std_logic_vector( 15 downto 0 );
		QRdEmpty				: in	std_logic;
		QRdData					: in	std_logic_vector( 16 downto 0 );
		QRdReq					: out	std_logic;
		PlLenError				: out 	std_logic;				
        
        -- Payload Ram I/F (Ram 8 x 16k)
        RamRdData				: in	std_logic_vector( 7 downto 0 );
        RamRdAddr				: out	std_logic_vector( 15 downto 0 );
        
        -- FIX payload Transfer I/F
        FixReq					: in	std_logic;
        FixSOP					: out	std_logic;
        FixEOP					: out	std_logic;
        FixValid				: out	std_logic;
        FixData					: out	std_logic_vector( 7 downto 0 )
	);
	End Component RxDataCtrl;
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------	
	
	signal	FifoSynClr		: std_logic;
	
	-- ClkAdaptor I/F
	signal	rMacSOP	 		: std_logic;
	signal	rMacValid       : std_logic;
	signal	rMacEOP	        : std_logic;
	signal	rMacData	 	: std_logic_vector( 7 downto 0 );
	signal	rMacError       : std_logic_vector( 1 downto 0 );
	
	-- RxHeaderDec I/F
	signal	rWinUpReq		: std_logic;
	
	-- Queue FIFO I/F
	signal	rQWrReq			: std_logic;
	signal	rQWrData		: std_logic_vector( 16 downto 0 );
	signal	rQWrFull		: std_logic;
	signal	rQRdEmpty		: std_logic;
	signal	rQRdReq			: std_logic;
	signal	rQRdData		: std_logic_vector( 16 downto 0 );
	signal	rQDataCnt		: std_logic_vector( 7 downto 0 ); -- no use
	
	-- Payload Ram I/F
	signal	rRamWrData		: std_logic_vector( 7 downto 0 );
	signal	rRamWrEn		: std_logic;
	signal	rRamWrAddr		: std_logic_vector( 15 downto 0 );

	signal	rRamRdData		: std_logic_vector( 7 downto 0 );
	signal	rRamRdAddr		: std_logic_vector( 15 downto 0 );
	
Begin	

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Combination
----------------------------------------------------------------------------------

	FifoSynClr	<= not RstB;
	
----------------------------------------------------------------------------------
-- Port mappling
----------------------------------------------------------------------------------	
	
	u_ClkAdaptor : ClkAdaptor
	Port map
	(
		MacRstB			=> MacRstB		,
	    RstB		    => RstB	        ,
	    RxMacClk	    => RxMacClk     ,
	    Clk			    => Clk		    ,
		MacSOP	        => MacSOP	    ,
	    MacValid        => MacValid     ,
	    MacEOP	        => MacEOP	    ,
	    MacData	        => MacData	    ,
	    MacError        => MacError     ,
		PktDropError    => PktDropError ,
		SOP			    => rMacSOP	    ,
	    DataValid       => rMacValid    ,
	    EOP			    => rMacEOP	    ,
	    Data		    => rMacData     ,
	    RxMacError      => rMacError
	
	);
	
	u_RxHeaderDec : RxHeaderDec
	Port map
	(
		RstB			=> RstB				,
		Clk	            => Clk              ,
		MacSOP			=> rMacSOP	        ,
		MacValid        => rMacValid        ,
		MacEOP	        => rMacEOP	        ,
		MacData	        => rMacData         ,
		MacError        => rMacError        ,
		DecodeEn        => DecodeEn         ,
		InitEn	        => InitEn           ,
		ExpSeqNum       => ExpSeqNum        ,
		UserValid		=> UserValid	    ,
		UserSrcMac		=> UserSrcMac		,
		UserDesMac      => UserDesMac       ,
		UserSrcIP	    => UserSrcIP	    ,
		UserDesIP	    => UserDesIP	    ,
		UserSrcPort     => UserSrcPort      ,
		UserDesPort     => UserDesPort      ,
		MacAddrValid	=> MacAddrValid		,
		IPVerValid		=> IPVerValid		,
		ProtocolValid	=> ProtocolValid	,
		SrcIPValid		=> SrcIPValid		,
		DesIPValid		=> DesIPValid		,
		SrcPortValid	=> SrcPortValid	    ,
		DesPortValid	=> DesPortValid	    ,
		CheckSumValid	=> CheckSumValid	,
		MacErrorFlag	=> MacErrorFlag	    ,
		SeqNumError		=> SeqNumError      ,
		WinUpReq		=> rWinUpReq        ,
		PktValid		=> PktValid         ,
		TCPSeqNum       => TCPSeqNum        ,
		TCPAck		    => TCPAck		    ,
		TCPAckFlag      => TCPAckFlag	    ,
		TCPPshFlag      => TCPPshFlag	    ,
		TCPRstFlag      => TCPRstFlag	    ,
		TCPSynFlag      => TCPSynFlag	    ,
		TCPFinFlag      => TCPFinFlag	    ,
		TCPWinSize      => TCPWinSize	    ,
		PayloadLen      => TCPPLLen	        ,
		QWrFull			=> rQWrFull         ,
		QCnt	        => rQDataCnt         ,
		QWrReq	        => rQWrReq          ,
		QWrData	        => rQWrData         ,
		PLRamWrData		=> rRamWrData       ,
		PLRamWrEn	    => rRamWrEn         ,
		PLRamWrAddr	    => rRamWrAddr
		
	);
	
	-- Payload Ram
	u_Ram64kx8 : Ram64kx8
	Port map
	(
		clock		=> Clk			,
		data		=> rRamWrData   ,
		rdaddress 	=> rRamRdAddr   ,
		wraddress 	=> rRamWrAddr   ,
		wren	 	=> rRamWrEn     ,
		q		 	=> rRamRdData
		
	);
	
	-- Queue FIFO
	u_FIFO256x17 : FIFO256x17
	Port map
	(
		clock		=> Clk			,
		data		=> rQWrData     ,
		rdreq		=> rQRdReq      ,
		sclr        => FifoSynClr   ,
		wrreq	    => rQWrReq      ,
		empty       => rQRdEmpty    ,
		full        => rQWrFull     ,
		q	        => rQRdData     ,
		usedw		=> rQDataCnt
		
	);
	
	u_RxDataCtrl : RxDataCtrl
	Port map
	(
		RstB			=> RstB				,
		Clk	            => Clk              ,
		DataTransEn		=> DataTransEn      ,
		FreeSpace	    => RxWinSize        ,
		RxWinUpReq		=> rWinUpReq        ,
		RamWrAddr       => rRamWrAddr       ,
		QRdEmpty	    => rQRdEmpty        ,
		QRdData		    => rQRdData         ,
		QRdReq		    => rQRdReq          ,
		PlLenError      => PlLenError       ,
		RamRdData		=> rRamRdData       ,
		RamRdAddr       => rRamRdAddr       ,
		FixReq			=> FixReq	        ,
		FixSOP	        => FixSOP	        ,
		FixEOP	        => FixEOP	        ,
		FixValid        => FixValid         ,
		FixData	        => FixData	
		
	);
	
End Architecture rt1;