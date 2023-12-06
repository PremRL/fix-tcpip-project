----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TxQueue.vhd
-- Title        TxQueue for TxTCP/IP
-- 
-- Author       L.Ratchanon
-- Date         2020/10/20
-- Syntax       VHDL
-- Description      
--
-- Queuing Module in TxTCP/IP 
-- This module managing data from upper layer to support these following 
-- features according to TCP/IP Mechanism 
-- 1) Normal Transmission : Receiving data from upper layer and writing its 
-- in memory. Then reading out to CheckSumCal to calculate checksum 
-- 2) Retransmission : TPU Operation signal, searching Address of memory. 
-- After that, returns back to normal transmission.
-- 3) Keep-alive : Transferring last byte of data again. 
--
----------------------------------------------------------------------------------
-- Note
--
-- TPUOperations :	Bit 0 => Queuing Enable (Permission to write data)
--			   		Bit 1 => Initialization (Connecting)
--					Bit 2 => Retransmission 
--					Bit 3 => Termination (Not sending any data)
--	
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TxQueue Is
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
End Entity TxQueue;	
	
Architecture rtl Of TxQueue Is

----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------

	Component RamQueue Is
	Port
	(
		clock		: in std_logic  := '1';
		data		: in std_logic_vector(7 downto 0);
		rdaddress	: in std_logic_vector(15 downto 0);
		wraddress	: in std_logic_vector(15 downto 0);
		wren		: in std_logic  := '0';
		q			: out std_logic_vector(7 downto 0)
	);
	End Component RamQueue;

	Component RamIndex Is
	Port
	(
		Clk			: in	std_logic;
		RstB		: in	std_logic;

		WrAddr		: in 	std_logic_vector( 3 downto 0 );
		WrData		: in	std_logic_vector(16 downto 0 );
		WrEn		: in 	std_logic := '0';

		Init		: in	std_logic; 
		AckVal		: in	std_logic; 
		AckNum		: in	std_logic_vector(31 downto 0 );
		RefAddr 	: out	std_logic_vector( 3 downto 0 );
		
		RdAddr		: in 	std_logic_vector( 3 downto 0 );
		RdData		: out	std_logic_vector(16 downto 0 )
	);
	End Component RamIndex;

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant cRamIndex_constraint	: std_logic := '1';

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- FF Input signals 
	signal rUserDataValFF		: std_logic;
	signal rUserDataEopFF		: std_logic;
	signal rTPUOperationsFF0	: std_logic;
	signal TPUResetFF			: std_logic;
	
	-- User I/F 
	signal rUserMemAlFull		: std_logic;
	signal rUserMemAlFullFF		: std_logic;
	signal rRamQueueWrAFull		: std_logic;
	signal rRamIndexWrAFull		: std_logic;
	
	-- Write Memory I/F 
	signal rRamQueueWrAddr		: std_logic_vector(15 downto 0 );
	signal rRamQueueWrData		: std_logic_vector( 7 downto 0 );
	signal rRamQueueWrDataEn	: std_logic_vector( 1 downto 0 );

	signal rRamIndexRefAddr		: std_logic_vector( 3 downto 0 );
	signal rRamIndexWrAddr		: std_logic_vector( 3 downto 0 );
	signal rRamIndexWrData		: std_logic_vector(16 downto 0 );
	signal rRamIndexWrDataEn	: std_logic;
	
	signal rRamQueueWrSpace		: std_logic_vector(15 downto 0 );
	signal rRamIndexWrSpace		: std_logic_vector( 3 downto 0 );
	
	-- Read Memory I/F 
	signal rRamQueueRdAddr		: std_logic_vector(15 downto 0 );
	signal rRamQueueRdData		: std_logic_vector( 7 downto 0 );
	
	signal rRamIndexRdAddr		: std_logic_vector( 3 downto 0 );
	signal rRamIndexRdData		: std_logic_vector(16 downto 0 );
	signal rRamIndexRdDataFF	: std_logic_vector(15 downto 0 );
	
	signal rCompLenCal			: std_logic_vector(16 downto 0 );
	signal rRamQueueRdSpace		: std_logic_vector(15 downto 0 );
	signal rRamIndexRdSpace		: std_logic_vector( 3 downto 0 );
	signal rRamQueueRdAble		: std_logic;
	
	-- Read Control signals
	signal rPayloadLenFF		: std_logic_vector(15 downto 0 );
	signal rPayloadLen			: std_logic_vector(15 downto 0 );
	signal rRdCtrl0				: std_logic_vector( 4 downto 0 );
	signal rRdCtrl1				: std_logic_vector( 1 downto 0 );
	signal rRdCtrl2				: std_logic_vector( 1 downto 0 );
	signal rReadEn				: std_logic_vector( 2 downto 0 );
	signal rDetectClose			: std_logic_vector( 2 downto 0 );
	
	-- Retransmission Sub-Control signal 	
	signal rRetranIndexCal		: std_logic_vector(16 downto 0 );
	signal rRetranLenCalEn		: std_logic_vector( 1 downto 0 );
	signal rRetranBack			: std_logic_vector( 1 downto 0 );
	signal rRetranCompEn		: std_logic;
	
	-- TPU I/F 
	signal rTPUPayloadLen		: std_logic_vector(15 downto 0 );
	signal rTPUInitReady		: std_logic_vector( 2 downto 0 );
	signal rTPUPayloadReq		: std_logic;
	signal rTPUOpReply			: std_logic;
	signal rTPULastData			: std_logic;
	
	-- CheckSumCal I/F 
	signal rQ2CDataSop			: std_logic;
	signal rQ2CDataEop			: std_logic;
	signal rQ2CDataVal			: std_logic;
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	-- User I/F 
	UserMemAlFull				<= rUserMemAlFull;
	
	-- TPU I/F
	TPUPayloadLen(15 downto 0 )	<= rTPUPayloadLen(15 downto 0 );
	TPUPayloadReq				<= rTPUPayloadReq;
	TPUOpReply					<= rTPUOpReply;
	TPUInitReady				<= rTPUInitReady(2); 
	TPULastData					<= rTPULastData;
	
	-- CheckSumCal I/F 
	Q2CDataLen(15 downto 0 ) 	<= rTPUPayloadLen(15 downto 0 );		
	Q2CDataIn( 7 downto 0 )		<= rRamQueueRdData( 7 downto 0 );	
	Q2CDataVal		            <= rQ2CDataVal;		
	Q2CDataSop		            <= rQ2CDataSop;		
	Q2CDataEop		            <= rQ2CDataEop;		
	Q2CCheckSumEnd	            <= rQ2CDataEop;	
	

----------------------------------------------------------------------------------
-- DFF : Component Mapping 
----------------------------------------------------------------------------------

	u_rRamQueue : RamQueue
	Port map 
	(
		clock		=> Clk						,
	
		wraddress	=> rRamQueueWrAddr          ,
		data		=> rRamQueueWrData          ,
		wren		=> rRamQueueWrDataEn(1)     ,

		rdaddress	=> rRamQueueRdAddr          ,
		q			=> rRamQueueRdData 
	);
	
	u_rRamIndex : RamIndex
	Port map 
	(
		Clk			=> Clk						,
	    RstB		=> RstB						, 

		WrAddr		=> rRamIndexWrAddr          ,
		WrData		=> rRamIndexWrData          ,
        WrEn		=> rRamIndexWrDataEn        ,

		Init		=> rTPUInitReady(2)			, 
		AckVal		=> TPUAckedSeqnumEn			,
		AckNum		=> TPUAckedSeqnum			,
		RefAddr 	=> rRamIndexRefAddr			, 
		
		RdAddr		=> rRamIndexRdAddr          ,
		RdData		=> rRamIndexRdData 
	);
	
----------------------------------------------------------------------------------
-- DFF : Internal signal 
----------------------------------------------------------------------------------	

-----------------------------------------------------------
-- FF inputs 

	u_FFInputData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rUserDataValFF		<= '0';
				rTPUOperationsFF0	<= '0';
				TPUResetFF			<= '0';
			else 
				-- FF TPU Operation Bit 0 : Write data enable  
 				rTPUOperationsFF0	<= TPUOperations(0);
				rUserDataValFF		<= UserDataVal;
				TPUResetFF			<= TPUReset; 
			end if;
			rUserDataEopFF	<= UserDataEop;
		end if;
	End Process u_FFInputData;

-----------------------------------------------------------
-- Memory Write Interface 
	
	-- Write Data 
	-- Queuing RAM : Transmission data storing in memory 
	u_rRamQueueWrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( UserDataVal='1' ) then 
				rRamQueueWrData( 7 downto 0 )	<= UserDataIn( 7 downto 0 ); 
			else 
				rRamQueueWrData( 7 downto 0 )	<= rRamQueueWrData( 7 downto 0 ); 
			end if;
		end if;
	End Process u_rRamQueueWrData;
	
	-- Addressing of RAMQueue for each brust of Data  
	u_rRamIndexWrData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialization 
			if ( rTPUInitReady(1 downto 0)="01" ) then 
				rRamIndexWrData(16 downto 0 )	<= TPUSeqNum(16 downto 0 ) + 1;
			-- Write enable  
			elsif ( UserDataSop='1' and UserDataVal='1' and TPUOperations(0)='1' 
				and (rUserMemAlFull='0' or rUserMemAlFullFF='0') ) then 
				rRamIndexWrData(16 downto 0 )	<= rRamIndexWrData(16 downto 0 ) + ('0'&UserDataLen(15 downto 0 ));
			else 
				rRamIndexWrData(16 downto 0 )	<= rRamIndexWrData(16 downto 0 );
			end if;
		end if;
	End Process u_rRamIndexWrData;
	
	-- Write Enable 
	-- Data Write Queuing RAM Enable 
	u_rRamQueueWrDataEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamQueueWrDataEn( 1 downto 0 )	<= "00";
			else 
				-- control signal  
				-- Rst flag of TPU set or Flip-flop of EOP 
				if ( rUserDataEopFF='1' and rUserDataValFF='1' ) then 
					rRamQueueWrDataEn(0)	<= '0';
				-- Permission to write data in Queuing RAM 
				elsif ( UserDataSop='1' and UserDataVal='1' and TPUOperations(0)='1' 
					and (rUserMemAlFull='0' or rUserMemAlFullFF='0') ) then 
					rRamQueueWrDataEn(0)	<= '1';
				else 
					rRamQueueWrDataEn(0)	<= rRamQueueWrDataEn(0);
				end if;
				
				-- Write Enable signal 
				-- Enable to write data in Queuing RAM 
				if ( ((UserDataSop='1' and TPUOperations(0)='1' 
					and (rUserMemAlFull='0' or rUserMemAlFullFF='0'))
					or rRamQueueWrDataEn(0)='1') and UserDataVal='1' ) then 
					rRamQueueWrDataEn(1)	<= '1';
				else 
					rRamQueueWrDataEn(1)	<= '0';
				end if;
				
			end if;
		end if;
	End Process u_rRamQueueWrDataEn;
	
	-- Data Write Indexing RAM Enable 
	u_rRamIndexWrDataEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRamIndexWrDataEn	<= '0';
			else 
				-- Enable to write data in Queuing RAM 
					-- Initialization 
				if ( rTPUInitReady(1 downto 0)="01"
					-- Sop of data with permission of writing 
					or (UserDataSop='1' and UserDataVal='1' and TPUOperations(0)='1' 
					and (rUserMemAlFull='0' or rUserMemAlFullFF='0')) ) then 
					rRamIndexWrDataEn	<= '1';
				else 
					rRamIndexWrDataEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRamIndexWrDataEn;
	
	-- Addressing 
	-- Write Addressing of Queuing RAM  
	u_rRamQueueWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialize connection 
			if ( rTPUInitReady(1 downto 0)="01" ) then 
				rRamQueueWrAddr(15 downto 0 )	<= TPUSeqNum(15 downto 0 ) + 1;
			-- Writing Data
			elsif ( rRamQueueWrDataEn(0)='1' and rUserDataValFF='1' ) then 
				rRamQueueWrAddr(15 downto 0 )	<= rRamQueueWrAddr(15 downto 0 ) + 1;
			else 
				rRamQueueWrAddr(15 downto 0 )	<= rRamQueueWrAddr(15 downto 0 );
			end if;
		end if;
	End Process u_rRamQueueWrAddr;
	
	-- Write Addressing of Indexing RAM  
	u_rRamIndexWrAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialize connection 
			if ( rTPUInitReady(1 downto 0)="01" ) then 
				rRamIndexWrAddr( 3 downto 0 )	<= (others=>'0');
			-- Writing Data
			elsif ( rRamIndexWrDataEn='1' ) then 
				rRamIndexWrAddr( 3 downto 0 )	<= rRamIndexWrAddr( 3 downto 0 ) + 1;
			else 
				rRamIndexWrAddr( 3 downto 0 )	<= rRamIndexWrAddr( 3 downto 0 );
			end if;
		end if;
	End Process u_rRamIndexWrAddr;		
	
	-- Write space of RAM  
	u_rWrAddrCal : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			rRamQueueWrSpace(15 downto 0 )	<= TPUAckedSeqnum( 15 downto 0 ) - rRamQueueWrAddr(15 downto 0 );
			rRamIndexWrSpace( 3 downto 0 )	<= rRamIndexRefAddr( 3 downto 0 ) - rRamIndexWrAddr( 3 downto 0 );
		end if;
	End Process u_rWrAddrCal;
	
	-- Queuing RAM Almost full 
	u_rRamQueueWrAFull : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- There's only 12288 Byte write space left
			if ( (rRamQueueWrSpace(15 downto 12)="0010" or rRamQueueWrSpace(15 downto 12)="0001" 
				or rRamQueueWrSpace(15 downto 12)="0000") and rRamQueueWrSpace/=0  ) then 
				rRamQueueWrAFull	<= '1';
			else 
				rRamQueueWrAFull	<= '0';
			end if;
		end if;
	End Process u_rRamQueueWrAFull;
	
	-- Indexing RAM Almost full 
	u_rRamIndexWrAFull : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- There's only 3 times left for writing brust of data 
			if ( rRamIndexWrSpace(3 downto 2)="00" and rRamIndexWrSpace/=0 ) then 
				rRamIndexWrAFull	<= '1';
			else 
				rRamIndexWrAFull	<= '0';
			end if;
		end if;
	End Process u_rRamIndexWrAFull;
	
	-- Pausing to Write data in Memory
	u_rUserMemAlFull : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rUserMemAlFull		<= '1';
				rUserMemAlFullFF	<= '1';
			else 
				rUserMemAlFullFF	<= rUserMemAlFull;
				-- If both memory are almost full 
				if ( rRamQueueWrAFull='0' and rRamIndexWrAFull='0'
				-- and Permission to write data 
					and (TPUOperations(0)='1' or rTPUOperationsFF0='1') ) then 
					rUserMemAlFull	<= '0';
				else 
					rUserMemAlFull	<= '1';
				end if;
			end if;
		end if;
	End Process u_rUserMemAlFull;
	
-----------------------------------------------------------
-- Memory Read Control 

	-- Read Control accessibility 
	u_rReadEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0') then 
				rReadEn( 2 downto 0 )	<= "000";
			else 
				-- Using FF signal 
				rReadEn(2)	<= rReadEn(1);
				rReadEn(1)	<= rReadEn(0);
				-- Disable to access normal transmission when transferred last data 
				if ( TPUReset='1' or TPUOperations(3)='1' ) then 
					rReadEn(0)	<= '0'; 
				-- Enable to access read control (Initialized)
				elsif ( rTPUInitReady(1 downto 0)="01" ) then 
					rReadEn(0)	<= '1';
				else 
					rReadEn(0)	<= rReadEn(0);
				end if;
			end if;
		end if;
	End Process u_rReadEn;
	
	-- Disability to send any data from upper layer detection 
	u_rDetectClose : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rDetectClose( 2 downto 0 )	<= "000";
			else  
				rDetectClose( 2 downto 1 )	<= rDetectClose( 1 downto 0 );
				-- TCP disconnecting 
				if ( TPUResetFF='1' or TPUReset='1' or TPUOperations(3)='1' ) then 
					rDetectClose(0)	<= '0';
				-- Detect falling edge of Write data permission
				elsif ( TPUOperations(0)='0' and rTPUOperationsFF0='1' ) then 
					rDetectClose(0)	<= '1';
				else 
					rDetectClose(0)	<= rDetectClose(0);
				end if;
			end if;
		end if;
	End Process u_rDetectClose;
	
	-- Read Control signals : bit 0 => Normal, bit 1 => Retrans, bit 2 => keep-alive
	u_rRdCtrl : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRdCtrl2( 1 downto 0 )	<= (others=>'0');
				rRdCtrl1( 1 downto 0 )	<= (others=>'0');
				rRdCtrl0( 4 downto 0 )	<= (others=>'0');
			else 
				-- FF signal 
				rRdCtrl2(1 downto 0)	<= rRdCtrl1(1 downto 0);
				rRdCtrl1(1 downto 0)	<= rRdCtrl0(1 downto 0);
				-- Normal
				-- TPU permitted to send data out 
				if ( TPUReset='1' or rRdCtrl0(4 downto 1)/="0000" 
					or (rTPUPayloadReq='1' and TPUTxReq='1' and TPUPayloadEn='1') ) then 
					rRdCtrl0(0)	<= '0';
				-- Reading in normal state 
				elsif ( Q2CBusy='0' and rReadEn(2 downto 0)="111" and rRdCtrl0(0)='0'
					and rRamIndexRdSpace/=0 ) then 
					rRdCtrl0(0)	<= '1';
				else 
					rRdCtrl0(0)	<= rRdCtrl0(0);
				end if;
				
				-- Retransmission
				-- End of searching index 
				if ( TPUReset='1' or (rRetranCompEn='1' and rRetranIndexCal(16)='0') ) then 
					rRdCtrl0(1)	<= '0';
				-- Reading in Retransmission state 
				elsif ( Q2CBusy='0' and rRdCtrl0(4 downto 1)="0000"
					and TPUOperations(2)='1' and rReadEn(2 downto 0)="111" ) then 
					rRdCtrl0(1)	<= '1';
				else 
					rRdCtrl0(1)	<= rRdCtrl0(1);
				end if;
				
				-- Wait for RamQueue readable to transfer sop of data to checksum 
					-- Normal operation 
				if ( rTPUPayloadReq='1' and TPUTxReq='1' and TPUPayloadEn='1' and rRdCtrl0(0)='1' ) then 
					rRdCtrl0(2)	<= '1';
				-- Sending sop of data 
				elsif ( rRamQueueRdAble='1' ) then 
					rRdCtrl0(2)	<= '0';
				else 
					rRdCtrl0(2)	<= rRdCtrl0(2);
				end if;
				
				-- Transferring data 
				-- End of Transferring data to checksumcal 
				if ( rPayloadLen=1 and rRamQueueRdAble='1' ) then 
					rRdCtrl0(3)	<= '0';
				-- Reading in Keep-alive state 
				elsif ( rRdCtrl0(2)='1' and rRamQueueRdAble='1' ) then 
					rRdCtrl0(3)	<= '1';
				else 
					rRdCtrl0(3)	<= rRdCtrl0(3);
				end if;
				
				-- Delay : Delay for reply retransmission operation 
				-- or waiting for checksum busy (incase of keep-alive and immediately send dats)
				if ( rRdCtrl0(1)='1' or rRdCtrl0(2)='1' ) then 
					rRdCtrl0(4)	<= '1';
				else 
					rRdCtrl0(4)	<= '0';
				end if;

			end if;
		end if;
	End Process u_rRdCtrl;
	
	-- Payload length processing 
	u_rPayloadLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 	
			-- FF signal 
			rPayloadLenFF(15 downto 0 )		<= rPayloadLen(15 downto 0 );
			-- Latch length from TPUPayload when TPU requested to send data 
			if ( rTPUPayloadReq='1' ) then 
				rPayloadLen(15 downto 0 )	<= rTPUPayloadLen(15 downto 0 );
			-- Transferring data : Deducting length 
			elsif ( (rRdCtrl0(2)='1' or rRdCtrl0(3)='1') and rRamQueueRdAble='1' ) then 
				rPayloadLen(15 downto 0 )	<= rPayloadLen(15 downto 0 ) - 1;
			else 
				rPayloadLen(15 downto 0 )	<= rPayloadLen(15 downto 0 );
			end if;
		end if;
	End Process u_rPayloadLen;
	
	-- Retransmission : RdCtrl(1) Process 
	-- When this signal is set, 
	-- Comparing SeqNum and Calculated index signal 
	u_rRetranCompEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then 
				rRetranCompEn	<= '0';
			else 
				if ( rRdCtrl0(1)='1' and rRetranCompEn='0' and rRetranBack(0)='0' ) then 
					rRetranCompEn	<= '1';
				else 
					rRetranCompEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRetranCompEn;
	
	-- Retran : search index signal 
	-- When rRetranBack="01" => Back propagation in memory 
	-- for searching. 
	u_rRetranBack : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRetranBack( 1 downto 0 )	<= "00";
			else 
				rRetranBack(1)	<= rRetranBack(0);
				if ( rRetranBack(1)='1' ) then 
					rRetranBack(0)	<= '0';
				elsif ( rRetranCompEn='1' ) then 
					rRetranBack(0)	<= '1';
				else 
					rRetranBack(0)	<= rRetranBack(0);
				end if;
			end if;
		end if;
	End Process u_rRetranBack;
	
	-- Calculating Payload length when rRdCtrl0(0)='1' and rRdCtrl1='1' and rRdCtrl2='0' or not 
	u_rRetranLenCalEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRetranLenCalEn( 1 downto 0 )	<= "00";
			else 
				-- If first time serach found, calculating length 
				if ( rRdCtrl0(1)='1' and rRdCtrl1(1)='0' ) then 
					rRetranLenCalEn(0)	<= '1'; 
				else 
					rRetranLenCalEn(0)	<= '0'; 
				end if;
				
				-- Next Operation 1: Not calculating Payload Length, if this bit is set 
				if ( (rRdCtrl0(0)='1' and rRdCtrl1(0)='1' and rRdCtrl2(0)='0') or rReadEn(0)='0' ) then 
					rRetranLenCalEn(1)	<= '0'; 
				elsif ( rRetranLenCalEn(0)='0' and rRetranCompEn='1' 
					and rRetranIndexCal(16)='0' and rRdCtrl0(1)='1' ) then 
					rRetranLenCalEn(1)	<= '1';
				else 
					rRetranLenCalEn(1)	<= rRetranLenCalEn(1);
				end if;
			end if;
		end if;
	End Process u_rRetranLenCalEn;
	
	-- Retran : Calculation index 
	u_rIndexCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRamIndexRdDataFF(15 downto 0 )	<= rRamIndexRdData(15 downto 0 );
			rRetranIndexCal(16 downto 0 )	<= TPUSeqNum(16 downto 0 ) - rRamIndexRdData(16 downto 0 );
		end if;
	End Process u_rIndexCal;
	
	-- Addressing Read I/F 
	-- Queuing RAM Read addr 
	u_rRamQueueRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialization phase 1 or Retransmission 
			if ( rTPUInitReady(1 downto 0)="01" or rRdCtrl0(1)='1' ) then 
				rRamQueueRdAddr(15 downto 0 )	<= TPUSeqNum(15 downto 0 );
			-- Transferring data 
			elsif ( ((rRdCtrl0(2)='1' or rRdCtrl0(3)='1') and rRamQueueRdAble='1')
				-- Or Initialization phase 2 
				or rTPUInitReady(2)='1' ) then 
				rRamQueueRdAddr(15 downto 0 )	<= rRamQueueRdAddr(15 downto 0 ) + 1;
			else 
				rRamQueueRdAddr(15 downto 0 )	<= rRamQueueRdAddr(15 downto 0 );
			end if;
		end if;
	End Process u_rRamQueueRdAddr; 
		
	-- Indexing RAM Read addr 
	u_rRamIndexRdAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Initialization 
			if ( rTPUInitReady(1 downto 0)="01" ) then 
				rRamIndexRdAddr( 3 downto 0 )	<= (others=>'0');
				-- searching backward to find Index of address 
			elsif ( rRetranBack(1 downto 0)="01" and rRdCtrl0(1)='1' ) then 
				rRamIndexRdAddr( 3 downto 0 )	<= rRamIndexRdAddr( 3 downto 0 ) - 1;
			-- Normal Operation 
			elsif ( Q2CBusy='0' and rReadEn(2 downto 0)="111" and rRdCtrl0(4 downto 0)="0000000"
					and rRamIndexRdSpace/=0 ) then 
				rRamIndexRdAddr( 3 downto 0 )	<= rRamIndexRdAddr( 3 downto 0 ) + 1;
			else 
				rRamIndexRdAddr( 3 downto 0 )	<= rRamIndexRdAddr( 3 downto 0 );
			end if;
		end if;
	End Process u_rRamIndexRdAddr;
	
	-- Read space of both RAM  
	u_rRdAddrCal : Process (Clk) Is
	Begin 
		if ( rising_edge(Clk) ) then 
			rRamQueueRdSpace(15 downto 0 )	<= rRamQueueWrAddr(15 downto 0 ) - rRamQueueRdAddr(15 downto 0 );
			rRamIndexRdSpace( 3 downto 0 )	<= rRamIndexWrAddr( 3 downto 0 ) - rRamIndexRdAddr( 3 downto 0 ) - cRamIndex_constraint;
		end if;
	End Process u_rRdAddrCal;
	
	-- Check End of data writing of reading packet    
	u_rCompLenCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rCompLenCal(16 downto 0 )	<= ('0'&rRamQueueRdSpace(15 downto 0 )) - ('0'&rPayloadLenFF(15 downto 0 ));
		end if;
	End Process u_rCompLenCal;
	
	-- Queuing RAM Readable 
	u_rRamQueueRdAble : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- There's at least 4 byte able to read from Queuing RAM or the reading payload has been written 
			if ( rRamQueueRdSpace(15 downto 2)/="00000000000000" or rCompLenCal(16)='0' ) then 
				rRamQueueRdAble	<= '1';
			else 
				rRamQueueRdAble	<= '0';
			end if;
		end if;
	End Process u_rRamQueueRdAble;
	
-----------------------------------------------------------
-- Output control signal generator to TPU 
	
	-- TPU Operation (Initialization) Ready
	u_rTPUInitReady : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTPUInitReady( 2 downto 0 )	<= "000";
			else 	
				-- FF signal 
				rTPUInitReady(1)	<= rTPUInitReady(0);
				if ( TPUOperations(1)='1' and rRdCtrl0(4 downto 0)="00000" ) then 
					rTPUInitReady(0)	<= '1';
				else 
					rTPUInitReady(0)	<= '0';
				end if;
				
				-- Using bit 2   
				if ( rTPUInitReady(1 downto 0)="01" ) then 
					rTPUInitReady(2)	<= '1';
				else 
					rTPUInitReady(2)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTPUInitReady;
	
	-- Request to send data in normal operation 
	u_rTPUPayloadReq : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTPUPayloadReq	<= '0';
			else 
				-- Reset when TPU Replying the TxReq and payload enable or operating other options 
				if ( TPUReset='1' or (TPUTxReq='1' and TPUPayloadEn='1') or rRdCtrl0(0)='0' ) then 
					rTPUPayloadReq	<= '0';
				-- Request to transfer data 
				elsif ( rRdCtrl0(0)='1' and rRdCtrl1(0)='1' and rRdCtrl2(0)='0' ) then 
					rTPUPayloadReq	<= '1';
				else 
					rTPUPayloadReq	<= rTPUPayloadReq;
				end if;
			end if;
		end if;
	End Process u_rTPUPayloadReq;
	
	-- Last Data to send (in normal operation)
	u_rTPULastData : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTPULastData	<= '0';
			else 
				-- Last data have already transferred 
				if ( rDetectClose(2 downto 0)="111" and rRamIndexRdSpace=0 and rRamQueueRdSpace=0 ) then 
					rTPULastData	<= '1';
				else 
					rTPULastData	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTPULastData; 
	
	-- Replying the TPUOperations 2 : Retran
	u_rTPUOpReply : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rTPUOpReply	<= '0';
			else 
				-- Reply to retransmission success 
				if ( rRetranCompEn='1' and rRetranIndexCal(16)='0' and rRdCtrl0(1)='1' ) then 
					rTPUOpReply	<= '1';
				else 
					rTPUOpReply	<= '0';
				end if;
			end if;
		end if;
	End Process u_rTPUOpReply;
	
	-- TPUPayload validation with rTPUPayloadReq or rTPUOpReply
	u_rTPUPayloadLen : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			-- Retransmission
			if ( rRetranCompEn='0' and rRetranBack(1 downto 0)="10" and rRdCtrl0(1)='1' ) then 
				rTPUPayloadLen(15 downto 0 )	<= rRamIndexRdDataFF(15 downto 0 ) - TPUSeqNum(15 downto 0 );
			-- Normal Operation 
			elsif ( rRdCtrl0(0)='1' and rRdCtrl1(0)='1' and rRdCtrl2(0)='0' and rRetranLenCalEn(1)='0' ) then 
				rTPUPayloadLen(15 downto 0 )	<= rRamIndexRdData(15 downto 0 ) - rRamIndexRdDataFF(15 downto 0 );
			else 
				rTPUPayloadLen(15 downto 0 )	<= rTPUPayloadLen(15 downto 0 );
			end if;
		end if;
	End Process u_rTPUPayloadLen;
 	
-----------------------------------------------------------
-- Output Generator to checksum module 
	
	-- First byte sending (SOP)
	u_rQ2CDataSop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rQ2CDataSop	<= '0';
			else 
				if ( rRdCtrl0(2)='1' and rRamQueueRdAble='1' ) then 
					rQ2CDataSop	<= '1';
				else 
					rQ2CDataSop	<= '0';
				end if;
			end if;
		end if;
	End Process u_rQ2CDataSop;
	
	-- Output validation 
	u_rQ2CDataVal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rQ2CDataVal	<= '0';
			else 
				if ( (rRdCtrl0(2)='1' or rRdCtrl0(3)='1') and rRamQueueRdAble='1' ) then 
					rQ2CDataVal	<= '1';
				else 
					rQ2CDataVal	<= '0';
				end if;
			end if;
		end if;
	End Process u_rQ2CDataVal;
	
	-- Last byte sending (EOP)
	u_rQ2CDataEop : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then
				rQ2CDataEop	<= '0';
			else 
				if ( (rRdCtrl0(2)='1' or rRdCtrl0(3)='1') and rRamQueueRdAble='1' 
					and rPayloadLen=1 ) then 
					rQ2CDataEop <= '1';
				else 
					rQ2CDataEop <= '0';
				end if;
			end if;
		end if;
	End Process u_rQ2CDataEop;
	
End Architecture rtl;