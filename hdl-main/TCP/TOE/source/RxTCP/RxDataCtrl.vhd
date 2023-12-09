----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename		RxDataCtrl.vhd
-- Title		
--
-- Company		Design Gateway Co., Ltd.
-- Project		Senior Project
-- PJ No.       
-- Syntax       VHDL
-- Note         

-- Version      1.00
-- Author       K.Norawit
-- Date         2020/10/09
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

Entity RxDataCtrl Is
Port
(
	RstB					: in	std_logic;
	Clk						: in	std_logic;
	
	-- TPU I/F
	DataTransEn				: in	std_logic; 
	FreeSpace				: out	std_logic_vector( 15 downto 0 );	-- Rx Window Size
	
	-- Queue management from RxHeaderDec and Queue FIFO I/F (256 x 17)
	RxWinUpReq				: in	std_logic;
	RamWrAddr				: in	std_logic_vector( 15 downto 0 );	-- Wr Pointer
	QRdEmpty				: in	std_logic;
	QRdData					: in	std_logic_vector( 16 downto 0 );
	QRdReq					: out	std_logic;
	PlLenError				: out 	std_logic;							-- Test Error Port
	
	-- Payload Ram I/F (Ram 16k x 8)
	RamRdData				: in	std_logic_vector( 7 downto 0 );
	RamRdAddr				: out	std_logic_vector( 15 downto 0 );	-- Rd Pointer
	
	-- FIX payload Transfer I/F
	FixReq					: in	std_logic;
	FixSOP					: out	std_logic;
	FixEOP					: out	std_logic;
	FixValid				: out	std_logic;
	FixData					: out	std_logic_vector( 7 downto 0 )
	
);
End Entity RxDataCtrl;

Architecture rt1 Of RxDataCtrl Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant	cDec65535		: std_logic_vector( 15 downto 0 )	:= x"FFFF";			-- RAM 64k depth
	
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
	
	-- Window Update 
	signal	rFreeSpace				: std_logic_vector( 15 downto 0 )	;
	signal	rTransByteCnt		: std_logic_vector( 9 downto 0 )	;
	signal	rFixWinUpReq	    : std_logic							;
	
	-- Rd Ram / Wr FIFO
	type SerStateType2 is
					(
						stIdle			,
						stRdQ			,
						stLatchQ		,
						stMode			,
						stTrans			,
						stFlush			,
						stWaitEndWr
					);
	
	signal 	rBufState			: SerStateType2						;
	signal	rQRdReq				: std_logic							;
	signal	rPLLenError			: std_logic							;
	signal	rQMode				: std_logic							;	-- latch from Queue Data
	signal	rPayloadLen			: std_logic_vector( 15 downto 0 )	;	-- latch from Queue Data
	
	signal	rRamRdCnt			: std_logic_vector( 15 downto 0 )	;
	signal	rRamRdReq			: std_logic							;
	signal	rRamRdReq1			: std_logic							;
	signal	rRamRdDataVal		: std_logic							;
	signal	rRamRdAddr			: std_logic_vector( 15 downto 0 )	;
	
	-- FIX transfer
	signal	rFixTransCnt		: std_logic_vector( 15 downto 0 )	;
	signal	rFixSOP				: std_logic							;
	signal	rFixEOP	            : std_logic							;
	signal	rFixValid           : std_logic							;
	signal	rFixData			: std_logic_vector( 7 downto 0 )	;
	
Begin

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	PlLenError			<= rPlLenError	;
	QRdReq				<= rQRdReq		;		-- Queue FIFO I/F
	FreeSpace			<= rFreeSpace	;		-- TPU I/F
	RamRdAddr			<= rRamRdAddr	;		-- Payload Ram I/F (Ram 16k x 8)
	-- FIX payload Transfer I/F
	FixSOP				<= rFixSOP		;
	FixEOP	            <= rFixEOP	    ;
	FixValid            <= rFixValid    ;
	FixData	            <= rFixData	    ;
	
----------------------------------------------------------------------------------
-- Internal Process of Window Update (1-clk processing time )
----------------------------------------------------------------------------------
	
	u_rFreeSpace : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFreeSpace	<= x"FFFF";		-- when restB is activated, all buffer flush, buffer space = max
			else
				-- Latch window size value  
				if ( RxWinUpReq='1' or rFixWinUpReq='1' ) then
				
					-- in case Rd = Wr Addr ---> free space is max
					if rRamRdAddr(15 downto 0)=RamWrAddr(15 downto 0) then
						rFreeSpace				<= x"FFFF";	
					else
						rFreeSpace(15 downto 0)	<= rRamRdAddr(15 downto 0) - RamWrAddr(15 downto 0);
					end if;
				else
					rFreeSpace(15 downto 0)		<= rFreeSpace(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rFreeSpace;
	
----------------------------------------------------------------------------------
-- Internal Process of Rd QFIFO & Ram / Wr FIFO
----------------------------------------------------------------------------------
	
	-----------------------------------
	-- Test Error Port:
	--		rPLLenError: set when bit 15th-14th rPayloadLen are not "00" (max payload len should be under 2^10; around 9k) 
	-----------------------------------
	
	u_rPLLenError : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rPLLenError	<= '0';
			else
				if ( rBufState=stFlush and rPayloadLen(15 downto 14)/="00" ) then
					rPLLenError	<= '1';
				else
					rPLLenError	<= rPLLenError;
				end if;
			end if;
		end if;
	End Process u_rPLLenError;
	
	-----------------------------------
	-- Rd QFIFO & Ram
	-----------------------------------
	
	u_rBufState : Process(Clk)	Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rBufState	<= stIdle;
			else
				case ( rBufState ) Is
					
					when stIdle		=>
						-- new payload queue is detected in Queue FIFO
						if ( QRdEmpty/='1' and DataTransEn='1' ) then
							rBufState	<= stRdQ;
						else
							rBufState	<= stIdle;
						end if;
					
					when stRdQ		=>
						-- 1-clk state
						rBufState	<= stLatchQ;
					
					when stLatchQ	=>
						-- 1-clk state
						rBufState	<= stMode;
					
					when stMode		=>
						-- Transfer payload from Ram.
						if ( DataTransEn='1' and rQMode='1' ) then
							rBufState	<= stTrans;
						-- Flush payload in Ram
						elsif ( rQMode='0' ) then
							rBufState	<= stFlush;
						else
							rBufState	<= stLatchQ;
						end if;
						
					when stTrans	=> 
						-- last byte of payload transfer
						if ( rRamRdCnt(15 downto 0)=1 and rRamRdReq='1' ) then
							rBufState	<= stWaitEndWr;
						else
							rBufState	<= stTrans;
						end if;
					
					when stWaitEndWr	=> 
						-- last byte of payload is written into FIFO
						if ( rRamRdDataVal='1' and rFixTransCnt(15 downto 0)=1 ) then
							rBufState	<= stIdle;
						else
							rBufState	<= stWaitEndWr;
						end if;
					
					when stFlush	=>
						-- 1-clk state
						rBufState	<= stIdle;
				end case;
			end if;
		end if;
	End Process u_rBufState;
	
	u_rQRdReq : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rQRdReq	<= '0';
			else
				-- new payload queue is detected in Queue FIFO @ Idle state, start to read queue
				if ( rBufState=stIdle and QRdEmpty/='1' and DataTransEn='1' ) then
					rQRdReq		<= '1';
				else
					rQRdReq		<= '0';
				end if;
			end if;
		end if;
	End Process u_rQRdReq;
	
	u_rQDataLatch : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			-- latch queue mode and PL Length in Queue Rd Data (from Queue FIFO)
			if ( rBufState=stLatchQ ) then
				rQMode						<= QRdData(16);
				rPayloadLen(15 downto 0)	<= QRdData(15 downto 0);
			else
				rQMode						<= rQMode;
				rPayloadLen(15 downto 0)	<= rPayloadLen(15 downto 0);
			end if;
		end if;
	End Process u_rQDataLatch;
	
	u_rRamRdCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRamRdCnt(15 downto 0)	<= (others=>'0');
			else
				-- load PayloadLen value in mode state
				if ( rBufState=stMode ) then
					rRamRdCnt(15 downto 0)	<= rPayloadLen(15 downto 0);
				-- decrease when RamRdReq is set (while reading Ram)
				elsif ( rRamRdReq='1' ) then
					rRamRdCnt(15 downto 0)	<= rRamRdCnt(15 downto 0) - 1;
				else
					rRamRdCnt(15 downto 0)	<= rRamRdCnt(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRamRdCnt;
	
	u_rRamRdReq : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRamRdReq		<= '0';
				rRamRdReq1		<= '0';
				rRamRdDataVal	<= '0';
			else
				-- Flip Flop
				rRamRdReq1		<= rRamRdReq;
				rRamRdDataVal	<= rRamRdReq1;
				
				-- special case: FIx PL length is one --> reset when one-clk-read is done
				if ( rBufState=stTrans and (rPayloadLen(15 downto 0)=1) and
						rRamRdReq='1' ) then
					rRamRdReq	<= '0';
				-- request to read ram till last byte is read (rRamRdCnt=1)
				elsif ( rBufState=stTrans and FixReq='1' and
					 (( rRamRdCnt(15 downto 0)/=1) or (rPayloadLen(15 downto 0)=1))) then
					rRamRdReq	<= '1';
				else
					rRamRdReq	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRamRdReq;

	u_rRamRdAddr : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRamRdAddr(15 downto 0)	<= (others=>'0');
			else
				-- Trans: increase when Data in Ram is read
				if ( rBufState=stTrans and rRamRdReq='1' ) then
					rRamRdAddr(15 downto 0)	<= rRamRdAddr(15 downto 0) + 1;
				-- Flush: skip the payload 
				-- if rPayloadLen(15 downto 14) is not "00" --> error
				elsif ( rBufState=stFlush ) then
					rRamRdAddr(15 downto 0)	<= rRamRdAddr(15 downto 0) + ("00"&rPayloadLen(13 downto 0));
				else
					rRamRdAddr(15 downto 0)	<= rRamRdAddr(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRamRdAddr;
	
	-----------------------------------
	-- FIX transfer
	-----------------------------------
	
	u_rFixTransCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixTransCnt(15 downto 0)	<= (others=>'0');
			else
				-- load PayloadLen value in mode state
				if ( rBufState=stMode ) then
					rFixTransCnt(15 downto 0)	<= rPayloadLen(15 downto 0);
				-- decrease when RamRdDataVal is set
				elsif ( rRamRdDataVal='1' ) then
					rFixTransCnt(15 downto 0)	<= rFixTransCnt(15 downto 0) - 1;
				else
					rFixTransCnt(15 downto 0)	<= rFixTransCnt(15 downto 0);
				end if;
			end if;
		end if;
	End Process u_rFixTransCnt;
	
	u_rFixValid : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixValid	<= '0';
			else
				-- Flip Flop
				rFixValid	<= rRamRdDataVal;
			end if;
		end if;
	End Process u_rFixValid;
	
	u_rFixSOP : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixSOP			<= '0';
			else
				-- first byte transfer
				if ( rRamRdDataVal='1' and rFixTransCnt(15 downto 0)=rPayloadLen(15 downto 0) ) then
					rFixSOP		<= '1';
				else
					rFixSOP		<= '0';
				end if;
			end if;
		end if;
	End Process u_rFixSOP;
	
	u_rFixEOP : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixEOP			<= '0';
			else
				-- last byte transfer
				if ( rRamRdDataVal='1' and rFixTransCnt(15 downto 0)=1 ) then
					rFixEOP		<= '1';
				else
					rFixEOP		<= '0';
				end if;
			end if;
		end if;
	End Process u_rFixEOP;
	
	u_rFixData : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			rFixData(7 downto 0)	<= RamRdData(7 downto 0);
		end if;
	End Process u_rFixData;
	
	u_rTransByteCnt : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rTransByteCnt(9 downto 0)	<= (others=>'0');
			else
				-- reset when reach 256 (dec)
				if ( rTransByteCnt(9)='1' ) then
					rTransByteCnt(9 downto 0)	<= (others=>'0');
				-- increase when FIX is transferring
				elsif ( rRamRdDataVal='1' ) then
					rTransByteCnt(9 downto 0)	<= rTransByteCnt(9 downto 0) + 1;
				else
					rTransByteCnt(9 downto 0)	<= rTransByteCnt(9 downto 0);
				end if;
			end if;
		end if;
	End Process u_rTransByteCnt;
	
	u_rFixWinUpReq : Process(Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rFixWinUpReq			<= '0';
			else
				-- request to undate Window size when transfer 256 payload bytes to FIX successful 
				if ( rTransByteCnt(9)='1' ) then
					rFixWinUpReq	<= '1';
				else
					rFixWinUpReq	<= '0';
				end if;
			end if;
		end if;
	End Process u_rFixWinUpReq;

End Architecture rt1;