----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbFixCtrl.vhd
-- Title        Testbench of FIX controller
-- 
-- Author       L.Ratchanon
-- Date         2021/03/07
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
-- 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use STD.textio.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_textio.all;
use work.PkTbFixCtrl.all;
use work.PkSigTbFixCtrl.all; 

Entity TbFixCtrl Is
End Entity TbFixCtrl;

Architecture HTWTestBench Of TbFixCtrl Is

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component PkMapTbFixCtrl Is 
	End Component PkMapTbFixCtrl;

Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------

	u_PkMapTbFixCtrl : PkMapTbFixCtrl; 
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	u_Test : Process
	Begin
		-------------------------------------------
		-- TM=0 : Initialization  
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 

		RTCTimeYear		    	<= conv_std_logic_vector(2021, 14);
		RTCTimeMonth	    	<= conv_std_logic_vector(3, 4);
		RTCTimeDay		    	<= conv_std_logic_vector(31, 5);
		RTCTimeHour		    	<= conv_std_logic_vector(12, 5);
		RTCTimeMin		    	<= conv_std_logic_vector(52, 6);
		RTCTimeMilliSec	    	<= conv_std_logic_vector(24531, 17);
		
		UserFixConn				<= '0';
		UserFixDisConn			<= '0';			
		UserFixSenderCompID		<= x"4d445f4649585f414c4c"&x"000000000000"; -- MD_FIX_ALL
		UserFixTargetCompID		<= x"534554"&x"00000000000000000000000000"; -- SET 
		UserFixUsername			<= x"4d445f4649585f55534552313233"&x"0000"; -- MD_FIX_USER123
		UserFixPassword         <= x"6162636431323321"&x"0000000000000000"; -- abcd123!
		UserFixSenderCompIDLen	<= conv_std_logic_vector(10, 5);
		UserFixTargetCompIDLen	<= conv_std_logic_vector(3, 5);
		UserFixUsernameLen		<= conv_std_logic_vector(14, 5);
		UserFixPasswordLen	    <= conv_std_logic_vector(8, 5);
		
		UserFixMrketData0		<= conv_std_logic_vector(0, 10);  
		UserFixMrketData1		<= conv_std_logic_vector(12, 10);
		UserFixMrketData2		<= conv_std_logic_vector(24, 10);
		UserFixMrketData3		<= conv_std_logic_vector(36, 10);
		UserFixMrketData4		<= conv_std_logic_vector(48, 10);
		UserFixNoRelatedSym		<= x"5"; --5 
		UserFixMDEntryTypes		<= x"3031";
		UserFixNoMDEntryTypes	<= "010"; -- 2
		
		Tx2CtrlMrketVal			<= (others=>'0');
		Tx2CtrlMrketSymbol0		<= x"414456414e43"; -- ADVANC
		Tx2CtrlMrketSecurityID0	<= x"042D"; -- 1,069
		Tx2CtrlMrketSymbol1		<= x"303030414f54"; -- 000AOT
		Tx2CtrlMrketSecurityID1 <= x"045D"; -- 1,117
		Tx2CtrlMrketSymbol2		<= x"303030415743"; -- 000AWC
		Tx2CtrlMrketSecurityID2 <= x"B6FE"; -- 46846
		Tx2CtrlMrketSymbol3		<= x"30303042424c"; -- 000BBL
		Tx2CtrlMrketSecurityID3 <= x"04BD"; -- 1,213
		Tx2CtrlMrketSymbol4		<= x"303042444d53"; -- 00BDMS
		Tx2CtrlMrketSecurityID4 <= x"04C3"; -- 1219
		
		DataGenInitial(RxDataRec);

		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Connection  
		-------------------------------------------
		-- TT=0 : Invalid Logon
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving invalid logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';
		RxDataRec.Rx2CtrlEncryptMetError	<= '1';
		RxDataRec.Rx2CtrlAppVerIdError		<= '1';   
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);  
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
	
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive any message other than a Logon
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving Heatbeat which is not logon
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum			<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);

		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive Invalid logon 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving invalid logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=2 : Receive Message Standard Header  
		-------------------------------------------
		-- TT=0 : MsgSeqNum(34) received as expected
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : MsgSeqNum(34) higher than expected 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(4, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- ResendReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0100" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(3, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(4, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : MsgSeqNum(34) lower than expected without PossDupFlag(43) set to Y
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(4, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=3 : Send/ Receive Heartbeat message
		-------------------------------------------
		-- TT=0 : No data sent during preset heartbeat interval 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		------------------------------------
		-- Wait for Tx Heartbeat has been sent 
		wait for 100*tClk;
		
		-- Receving Market Data Snapshot Full Refres
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(7)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : TestRequest(35=1) message received 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving TestRequest
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(3, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(1)		<= '1';  
		RxDataRec.Rx2CtrlTestReqId			<= x"5345545465737421"; -- SETTest!
		RxDataRec.Rx2CtrlTestReqIdLen		<= conv_std_logic_vector(8, 6);
		RxDataRec.Rx2CtrlTestReqIdVal		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Heartbeat with Tag 112 has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : Valid Heartbeat(35=0) message 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving Heartbeat
		wait for 50*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(4, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=4 : Send Test Request
		----------------------------------------	---
		-- TT=0 : No data received during preset heartbeat interval : TestReq -> Receive correctly 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- TestReq with Tag 112 has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0000" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk); 
		
		-- Receving Heartbeat with 112 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(5, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		RxDataRec.Rx2CtrlTestReqId			<= x"5465737452657121";  -- TestReq!
		RxDataRec.Rx2CtrlTestReqIdLen		<= conv_std_logic_vector(8, 6);
		RxDataRec.Rx2CtrlTestReqIdVal		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : No data received during preset heartbeat interval : TestReq -> not received, Disconnect
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- TestReq with Tag 112 has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0000" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk); 
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=5 : Receive Reject message
		-------------------------------------------
		-- TT=0 : Valid Reject(35=3) message 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		------------------------------------
		
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk); 
		
		-- Receving Reject(35=3) 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(3)		<= '1';  
		RxDataRec.Rx2CtrlRefSeqNum			<= conv_std_logic_vector(3, 32);
		RxDataRec.Rx2CtrlRefTagId			<= conv_std_logic_vector(112, 16);
		RxDataRec.Rx2CtrlRefMsgType			<= "10000000";
		RxDataRec.Rx2CtrlRejectReason		<= "001";
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=6 : Receive Resend Request message
		-------------------------------------------
		-- TT=0 : MrkDataReq + Long period of heartbeat (EndSeqNum=0)
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		for i in 0 to 2 loop
		-- Receving Heartbeat(35=0)
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(3+i, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		End loop; 
		
		-- Receving Heartbeat(35=0)
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(6, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Receving ResendReq(35=2) 
		wait for 50*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(7, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(2)		<= '1';  
		RxDataRec.Rx2CtrlBeginSeqNum		<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlEndSeqNum			<= conv_std_logic_vector(0, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- SeqReset has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0101" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : MrkDataReq + Long period of heartbeat (EndSeqNum/=0)
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving ResendReq(35=3) 
		wait for 50*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(8, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(2)		<= '1';  
		RxDataRec.Rx2CtrlBeginSeqNum		<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlEndSeqNum			<= conv_std_logic_vector(5, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- SeqReset has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0101" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=7 : Receive Sequence Reset
		-------------------------------------------
		-- TT=0 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) > NextNumIn
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Receving Heartbeat(35=0)
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(9, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
	
		-- Receving SeqReset
		wait for 10*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(11, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(4)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '1';
		RxDataRec.Rx2CtrlGapFillFlag		<= '1';
		RxDataRec.Rx2CtrlNewSeqNum			<= conv_std_logic_vector(15, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- ResendReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0100" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) = NextNumIn
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving SeqReset
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(10, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(4)		<= '1';  
		RxDataRec.Rx2CtrlGapFillFlag		<= '1';
		RxDataRec.Rx2CtrlNewSeqNum			<= conv_std_logic_vector(15, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) < NextNumIn and PossDupFlag(43)=Y
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving SeqReset
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(14, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(4)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '1';
		RxDataRec.Rx2CtrlPossDupFlag		<= '1';
		RxDataRec.Rx2CtrlGapFillFlag		<= '1';
		RxDataRec.Rx2CtrlNewSeqNum			<= conv_std_logic_vector(16, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Ignore 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=3 : Receive SequenceReset(35=4) with GapFillFlag(123)=Y message 
		-- with NewSeqNo(36) > MsgSeqNum(34) and MsgSeqNum(34) < NextNumIn and without PossDupFlag(43)=Y 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving SeqReset
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(15, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(4)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '1';
		RxDataRec.Rx2CtrlGapFillFlag		<= '0';
		RxDataRec.Rx2CtrlNewSeqNum			<= conv_std_logic_vector(16, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=8 : Receive Sequence Reset (N)
		-------------------------------------------
		-- TT=0 : Receive SequenceReset(35=4) with GapFillFlag(123)=N message with NewSeqNo(36) >= NextNumIn 
		-- >>Accept the SequenceReset(35=4) message without regard to its MsgSeqNum(34), Set NextNumIn to NewSeqNo(36)
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		------------------------------------
		
		-- Receving SeqReset
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(15, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(4)		<= '1';  
		RxDataRec.Rx2CtrlSeqNumError		<= '0';
		RxDataRec.Rx2CtrlGapFillFlag		<= '0';
		RxDataRec.Rx2CtrlNewSeqNum			<= conv_std_logic_vector(16, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=9 : logout process
		-------------------------------------------
		-- TT=0 : Send Logout(35=5) message and receive
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		UserFixDisConn			<= '1';

		-- TestReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0000" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving Heartbeat(35=0) with 112 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(16, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		RxDataRec.Rx2CtrlTestReqId			<= x"5465737452657121";  -- TestReq!
		RxDataRec.Rx2CtrlTestReqIdLen		<= conv_std_logic_vector(8, 6);
		RxDataRec.Rx2CtrlTestReqIdVal		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logout  
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(17, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(5)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		wait until UserFixOperate='0' and rising_edge(Clk);
		UserFixDisConn			<= '0';
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Send Logout(35=5) message and no response 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		------------------------------------
		
		------------------------------------
		-- Sending and receiving some messages
		for i in 0 to 2 loop
		-- Receving Heartbeat(35=0)
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2+i, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		End loop; 
		
		-- Receving Heartbeat(35=0)
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(5, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		------------------------------------
		
		UserFixDisConn			<= '1';
		
		-- TestReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0000" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving Heartbeat(35=0) with 112 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(6, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		RxDataRec.Rx2CtrlTestReqId			<= x"5465737452657121";  -- TestReq!
		RxDataRec.Rx2CtrlTestReqIdLen		<= conv_std_logic_vector(8, 6);
		RxDataRec.Rx2CtrlTestReqIdVal		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		wait until UserFixOperate='0' and rising_edge(Clk);
		UserFixDisConn			<= '0';
		
		-- Auto disconnect due to time-out 
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=2 : receive Logout(35=5) message 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		------------------------------------
		
		------------------------------------
		-- Sending and receiving some messages
		for i in 0 to 2 loop
		-- Receving Heartbeat(35=0)
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2+i, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		End loop; 
		
		-- Receving Heartbeat(35=0)
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(5, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		------------------------------------
		
		-- Receving Logout
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(6, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(5)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- Logout has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0111" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Disconnected 
		wait until TOE2FixStatus="0001" and rising_edge(Clk);
		
		wait for 40*tClk;
		-------------------------------------------
		-- TM=10: Receive application or session layer message
		-------------------------------------------
		-- TT=0 : Receive field identifier (tag number) not defined in specification
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		------------------------------------
		-- Connection 
		UserFixConn				<= '1';
		wait until UserFixOperate='1' and rising_edge(Clk);
		UserFixConn				<= '0';
		
		-- Logon has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0001" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Receving logon 
		wait for 20*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(1, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(6)		<= '1';  
		RxDataRec.Rx2CtrlResetSeqNumFlag	<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		------------------------------------
		
		------------------------------------
		-- Sending and receiving some messages
		for i in 0 to 2 loop
		-- Receving Heartbeat(35=0)
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(2+i, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		-- Heartbeat has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0010" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		wait until rising_edge(Clk);
		End loop; 
		
		-- Receving Heartbeat(35=0)
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(5, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(0)		<= '1';  
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		------------------------------------
		
		-- Receving Reject
		wait for 10*tClk; wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(6, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(3)		<= '1';  
		RxDataRec.Rx2CtrlErrorTagLatch		<= x"30333535"; -- 355 
		RxDataRec.Rx2CtrlErrorTagLen		<= conv_std_logic_vector(3, 6);
		RxDataRec.Rx2CtrlTagErrorFlag		<= '1';
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);	
		
		-- Reject has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0110" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TT=1 : Receive ResendReq of reject message  
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Receving ResendReq(35=3) 
		wait until rising_edge(Clk);
		RxDataRec.Rx2CtrlSeqNum				<= conv_std_logic_vector(7, 32);
		RxDataRec.Rx2CtrlMsgTypeVal(2)		<= '1';  
		RxDataRec.Rx2CtrlBeginSeqNum		<= conv_std_logic_vector(2, 32);
		RxDataRec.Rx2CtrlEndSeqNum			<= conv_std_logic_vector(0, 32);
		wait until rising_edge(Clk); 
		DataGenInitial(RxDataRec);
		
		-- MrkDataReq has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0011" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- SeqReset has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0101" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		-- Reject has been sent 
		wait until Ctrl2TxReq='1' and Tx2CtrlBusy='1' 
		and Ctrl2TxMsgType="0110" and rising_edge(Clk);
		wait until Tx2CtrlBusy='0' and rising_edge(Clk);
		
		wait for 20*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;